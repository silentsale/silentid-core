using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

public interface IRiskEngineService
{
    Task<int> CalculateRiskScoreAsync(Guid userId);
    Task CreateRiskSignalAsync(Guid userId, RiskType type, int severity, string message, string? metadata = null);
    Task<List<RiskSignal>> GetActiveRiskSignalsAsync(Guid userId);
    Task CheckEvidenceIntegrityAsync(Guid evidenceId, string evidenceType);
}

public class RiskEngineService : IRiskEngineService
{
    private readonly ILogger<RiskEngineService> _logger;
    private readonly SilentIdDbContext _context;

    private const int LOW_RISK_THRESHOLD = 20;
    private const int MILD_RISK_THRESHOLD = 40;
    private const int ELEVATED_RISK_THRESHOLD = 60;
    private const int HIGH_RISK_THRESHOLD = 80;

    public RiskEngineService(ILogger<RiskEngineService> logger, SilentIdDbContext context)
    {
        _logger = logger;
        _context = context;
    }

    public async Task<int> CalculateRiskScoreAsync(Guid userId)
    {
        _logger.LogInformation("Calculating RiskScore for user {UserId}", userId);

        var activeSignals = await _context.RiskSignals
            .Where(r => r.UserId == userId && !r.IsResolved)
            .ToListAsync();

        if (!activeSignals.Any())
        {
            return 0;
        }

        int riskScore = 0;

        foreach (var signal in activeSignals)
        {
            var points = signal.Type switch
            {
                RiskType.FakeReceipt => 30,
                RiskType.FakeScreenshot => 30,
                RiskType.Collusion => 20,
                RiskType.DeviceMismatch => 10,
                RiskType.IPRisk => 5,
                RiskType.Reported => 10 * signal.Severity,
                RiskType.DuplicateAccount => 20,
                RiskType.ProfileMismatch => 10,
                RiskType.SuspiciousLogin => 5,
                RiskType.RapidAccountCreation => 10,
                RiskType.AbnormalActivity => 10,
                // ProfileConcernFlag is internal-only soft signal, very low weight
                // Does NOT directly affect TrustScore, only internal risk tracking
                RiskType.ProfileConcernFlag => 2,
                _ => signal.Severity
            };

            riskScore += points;
        }

        riskScore = Math.Min(riskScore, 100);

        _logger.LogInformation("RiskScore for user {UserId}: {RiskScore}", userId, riskScore);

        return riskScore;
    }

    public async Task CreateRiskSignalAsync(Guid userId, RiskType type, int severity, string message, string? metadata = null)
    {
        if (severity < 1 || severity > 10)
        {
            throw new ArgumentException("Severity must be between 1 and 10", nameof(severity));
        }

        var riskSignal = new RiskSignal
        {
            Id = Guid.NewGuid(),
            UserId = userId,
            Type = type,
            Severity = severity,
            Message = message,
            Metadata = metadata,
            IsResolved = false,
            CreatedAt = DateTime.UtcNow
        };

        _context.RiskSignals.Add(riskSignal);
        await _context.SaveChangesAsync();

        var newRiskScore = await CalculateRiskScoreAsync(userId);

        if (newRiskScore >= HIGH_RISK_THRESHOLD)
        {
            _logger.LogError("CRITICAL RISK: User {UserId} RiskScore = {RiskScore}", userId, newRiskScore);
        }
    }

    public async Task<List<RiskSignal>> GetActiveRiskSignalsAsync(Guid userId)
    {
        return await _context.RiskSignals
            .Where(r => r.UserId == userId && !r.IsResolved)
            .OrderByDescending(r => r.CreatedAt)
            .ToListAsync();
    }

    public async Task CheckEvidenceIntegrityAsync(Guid evidenceId, string evidenceType)
    {
        // v2.0: Receipts and screenshots removed - check profile links only
        if (evidenceType == "profile_link")
        {
            var profileLink = await _context.ProfileLinkEvidences
                .FirstOrDefaultAsync(p => p.Id == evidenceId);

            if (profileLink != null && profileLink.IntegrityScore < 50)
            {
                await CreateRiskSignalAsync(
                    profileLink.UserId,
                    RiskType.ProfileMismatch,
                    severity: 5,
                    message: $"Profile link failed integrity check (score: {profileLink.IntegrityScore})"
                );

                profileLink.EvidenceState = EvidenceState.Suspicious;
                await _context.SaveChangesAsync();
            }
        }
        // Legacy evidence types - log warning but do nothing
        else if (evidenceType == "receipt" || evidenceType == "screenshot")
        {
            _logger.LogWarning("v2.0: {EvidenceType} evidence type is deprecated and no longer processed", evidenceType);
        }
    }
}
