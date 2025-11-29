using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

/// <summary>
/// Service for managing profile concerns (safety flags on public profiles).
/// Implements rate limiting and feeds soft signals to the risk engine.
/// </summary>
public class ProfileConcernService
{
    private readonly SilentIdDbContext _context;
    private readonly IRiskEngineService _riskEngine;
    private readonly ILogger<ProfileConcernService> _logger;

    // Rate limits
    private const int MaxConcernsPerUserPerDay = 3;
    private const int MaxConcernsPerProfilePerWeek = 1;

    public ProfileConcernService(
        SilentIdDbContext context,
        IRiskEngineService riskEngine,
        ILogger<ProfileConcernService> logger)
    {
        _context = context;
        _riskEngine = riskEngine;
        _logger = logger;
    }

    /// <summary>
    /// Submit a new concern about a public profile.
    /// </summary>
    public async Task<ProfileConcernResult> SubmitConcernAsync(
        Guid reportedUserId,
        Guid? reporterUserId,
        ConcernReason reason,
        string? notes,
        string? ipAddress,
        string? deviceInfo)
    {
        // Validate reported user exists
        var reportedUser = await _context.Users.FindAsync(reportedUserId);
        if (reportedUser == null)
        {
            return ProfileConcernResult.Failed("Profile not found");
        }

        // Prevent self-reporting
        if (reporterUserId.HasValue && reporterUserId.Value == reportedUserId)
        {
            return ProfileConcernResult.Failed("You cannot report your own profile");
        }

        // Check rate limits if reporter is authenticated
        if (reporterUserId.HasValue)
        {
            var rateLimitResult = await CheckRateLimitsAsync(reporterUserId.Value, reportedUserId);
            if (!rateLimitResult.IsSuccess)
            {
                return rateLimitResult;
            }
        }

        // Create the concern
        var concern = new ProfileConcern
        {
            Id = Guid.NewGuid(),
            ReportedUserId = reportedUserId,
            ReporterUserId = reporterUserId,
            Reason = reason,
            Notes = notes?.Length > 400 ? notes[..400] : notes,
            ReporterIpAddress = ipAddress,
            ReporterDeviceInfo = deviceInfo,
            Status = ConcernStatus.New,
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        };

        _context.ProfileConcerns.Add(concern);
        await _context.SaveChangesAsync();

        // Add soft risk signal (internal only, very low weight)
        await AddSoftRiskSignalAsync(reportedUserId, concern.Id);

        _logger.LogInformation(
            "Profile concern submitted: {ConcernId} for user {ReportedUserId} by {ReporterUserId}",
            concern.Id, reportedUserId, reporterUserId?.ToString() ?? "anonymous");

        return ProfileConcernResult.Success(concern.Id);
    }

    /// <summary>
    /// Check rate limits for the reporter.
    /// </summary>
    private async Task<ProfileConcernResult> CheckRateLimitsAsync(Guid reporterUserId, Guid reportedUserId)
    {
        var now = DateTime.UtcNow;
        var oneDayAgo = now.AddDays(-1);
        var oneWeekAgo = now.AddDays(-7);

        // Check daily limit (max 3 concerns per day per reporter)
        var dailyConcernCount = await _context.ProfileConcerns
            .CountAsync(c => c.ReporterUserId == reporterUserId && c.CreatedAt >= oneDayAgo);

        if (dailyConcernCount >= MaxConcernsPerUserPerDay)
        {
            return ProfileConcernResult.Failed(
                "You have reached the daily limit for reporting concerns. Please try again tomorrow.");
        }

        // Check per-profile limit (max 1 concern per profile per week per reporter)
        var existingConcernForProfile = await _context.ProfileConcerns
            .AnyAsync(c => c.ReporterUserId == reporterUserId
                       && c.ReportedUserId == reportedUserId
                       && c.CreatedAt >= oneWeekAgo);

        if (existingConcernForProfile)
        {
            return ProfileConcernResult.Failed(
                "You have already reported a concern about this profile recently.");
        }

        return ProfileConcernResult.Success(Guid.Empty);
    }

    /// <summary>
    /// Add a soft risk signal for the reported user.
    /// This is internal-only and does NOT directly affect TrustScore.
    /// Multiple concerns from different reporters may increase signal weight.
    /// </summary>
    private async Task AddSoftRiskSignalAsync(Guid userId, Guid concernId)
    {
        // Count recent distinct concerns for this user
        var oneMonthAgo = DateTime.UtcNow.AddDays(-30);
        var recentConcernCount = await _context.ProfileConcerns
            .Where(c => c.ReportedUserId == userId && c.CreatedAt >= oneMonthAgo)
            .Select(c => c.ReporterUserId)
            .Distinct()
            .CountAsync();

        // Only create a risk signal if multiple different reporters have flagged
        if (recentConcernCount >= 3)
        {
            var metadata = System.Text.Json.JsonSerializer.Serialize(new
            {
                concernCount = recentConcernCount,
                latestConcernId = concernId.ToString()
            });

            await _riskEngine.CreateRiskSignalAsync(
                userId,
                RiskType.ProfileConcernFlag,
                severity: 2, // Very low severity
                message: $"Multiple profile concerns received from {recentConcernCount} different users",
                metadata: metadata
            );

            _logger.LogInformation(
                "Soft risk signal added for user {UserId} due to {ConcernCount} concerns",
                userId, recentConcernCount);
        }
    }

    /// <summary>
    /// Get all concerns for admin review.
    /// </summary>
    public async Task<List<ProfileConcernDto>> GetAllConcernsAsync(
        ConcernStatus? statusFilter = null,
        ConcernReason? reasonFilter = null,
        DateTime? fromDate = null,
        DateTime? toDate = null,
        int page = 1,
        int pageSize = 20)
    {
        var query = _context.ProfileConcerns
            .Include(c => c.ReportedUser)
            .Include(c => c.Reporter)
            .AsQueryable();

        if (statusFilter.HasValue)
            query = query.Where(c => c.Status == statusFilter.Value);

        if (reasonFilter.HasValue)
            query = query.Where(c => c.Reason == reasonFilter.Value);

        if (fromDate.HasValue)
            query = query.Where(c => c.CreatedAt >= fromDate.Value);

        if (toDate.HasValue)
            query = query.Where(c => c.CreatedAt <= toDate.Value);

        var concerns = await query
            .OrderByDescending(c => c.CreatedAt)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        return concerns.Select(c => new ProfileConcernDto
        {
            Id = c.Id,
            ReportedUserId = c.ReportedUserId,
            ReportedUsername = c.ReportedUser?.Username ?? "Unknown",
            ReportedDisplayName = c.ReportedUser?.DisplayName ?? "Unknown",
            ReporterUserId = c.ReporterUserId,
            ReporterUsername = c.Reporter?.Username,
            Reason = c.Reason,
            ReasonText = GetReasonText(c.Reason),
            Notes = c.Notes,
            Status = c.Status,
            StatusText = c.Status.ToString(),
            AdminNotes = c.AdminNotes,
            ReviewedAt = c.ReviewedAt,
            CreatedAt = c.CreatedAt
        }).ToList();
    }

    /// <summary>
    /// Get a single concern by ID.
    /// </summary>
    public async Task<ProfileConcernDto?> GetConcernByIdAsync(Guid id)
    {
        var concern = await _context.ProfileConcerns
            .Include(c => c.ReportedUser)
            .Include(c => c.Reporter)
            .FirstOrDefaultAsync(c => c.Id == id);

        if (concern == null) return null;

        return new ProfileConcernDto
        {
            Id = concern.Id,
            ReportedUserId = concern.ReportedUserId,
            ReportedUsername = concern.ReportedUser?.Username ?? "Unknown",
            ReportedDisplayName = concern.ReportedUser?.DisplayName ?? "Unknown",
            ReporterUserId = concern.ReporterUserId,
            ReporterUsername = concern.Reporter?.Username,
            Reason = concern.Reason,
            ReasonText = GetReasonText(concern.Reason),
            Notes = concern.Notes,
            Status = concern.Status,
            StatusText = concern.Status.ToString(),
            AdminNotes = concern.AdminNotes,
            ReviewedByAdminId = concern.ReviewedByAdminId,
            ReviewedAt = concern.ReviewedAt,
            ReporterIpAddress = concern.ReporterIpAddress,
            ReporterDeviceInfo = concern.ReporterDeviceInfo,
            CreatedAt = concern.CreatedAt,
            UpdatedAt = concern.UpdatedAt
        };
    }

    /// <summary>
    /// Update concern status (admin only).
    /// </summary>
    public async Task<bool> UpdateConcernStatusAsync(
        Guid concernId,
        ConcernStatus newStatus,
        string? adminNotes,
        Guid adminId)
    {
        var concern = await _context.ProfileConcerns.FindAsync(concernId);
        if (concern == null) return false;

        concern.Status = newStatus;
        concern.AdminNotes = adminNotes;
        concern.ReviewedByAdminId = adminId;
        concern.ReviewedAt = DateTime.UtcNow;
        concern.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        _logger.LogInformation(
            "Profile concern {ConcernId} status updated to {Status} by admin {AdminId}",
            concernId, newStatus, adminId);

        return true;
    }

    /// <summary>
    /// Get human-readable text for concern reason.
    /// Uses neutral, safe language as per spec.
    /// </summary>
    public static string GetReasonText(ConcernReason reason)
    {
        return reason switch
        {
            ConcernReason.ProfileOwnership => "Profile might not belong to this person",
            ConcernReason.InconsistentInformation => "Suspicious or inconsistent information",
            ConcernReason.UnsafeFeeling => "Something feels unsafe",
            ConcernReason.OtherSafetyConcern => "Other safety concern",
            _ => "Unknown concern"
        };
    }

    /// <summary>
    /// Get count of concerns by status.
    /// </summary>
    public async Task<Dictionary<ConcernStatus, int>> GetConcernCountsByStatusAsync()
    {
        return await _context.ProfileConcerns
            .GroupBy(c => c.Status)
            .Select(g => new { Status = g.Key, Count = g.Count() })
            .ToDictionaryAsync(x => x.Status, x => x.Count);
    }
}

/// <summary>
/// Result of submitting a profile concern.
/// </summary>
public class ProfileConcernResult
{
    public bool IsSuccess { get; set; }
    public string? ErrorMessage { get; set; }
    public Guid ConcernId { get; set; }

    public static ProfileConcernResult Success(Guid concernId) => new()
    {
        IsSuccess = true,
        ConcernId = concernId
    };

    public static ProfileConcernResult Failed(string message) => new()
    {
        IsSuccess = false,
        ErrorMessage = message
    };
}

/// <summary>
/// DTO for profile concern data.
/// </summary>
public class ProfileConcernDto
{
    public Guid Id { get; set; }
    public Guid ReportedUserId { get; set; }
    public string ReportedUsername { get; set; } = string.Empty;
    public string ReportedDisplayName { get; set; } = string.Empty;
    public Guid? ReporterUserId { get; set; }
    public string? ReporterUsername { get; set; }
    public ConcernReason Reason { get; set; }
    public string ReasonText { get; set; } = string.Empty;
    public string? Notes { get; set; }
    public ConcernStatus Status { get; set; }
    public string StatusText { get; set; } = string.Empty;
    public string? AdminNotes { get; set; }
    public Guid? ReviewedByAdminId { get; set; }
    public DateTime? ReviewedAt { get; set; }
    public string? ReporterIpAddress { get; set; }
    public string? ReporterDeviceInfo { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
