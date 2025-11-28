using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

public interface IReferralService
{
    /// <summary>
    /// Gets or creates the user's referral code
    /// </summary>
    Task<string> GetOrCreateReferralCodeAsync(Guid userId);

    /// <summary>
    /// Gets the user's referral summary (code, link, stats)
    /// </summary>
    Task<ReferralSummary> GetReferralSummaryAsync(Guid userId);

    /// <summary>
    /// Gets the list of referrals made by the user
    /// </summary>
    Task<List<ReferralInfo>> GetReferralsByUserAsync(Guid userId);

    /// <summary>
    /// Validates a referral code exists and is not expired
    /// </summary>
    Task<bool> ValidateReferralCodeAsync(string code);

    /// <summary>
    /// Applies a referral code when a new user signs up
    /// </summary>
    Task<bool> ApplyReferralCodeAsync(Guid newUserId, string referralCode);

    /// <summary>
    /// Awards referral bonuses when a referred user verifies their identity
    /// </summary>
    Task<bool> CompleteReferralAsync(Guid refereeUserId);
}

public class ReferralService : IReferralService
{
    private readonly SilentIdDbContext _context;
    private readonly ITrustScoreService _trustScoreService;
    private readonly ILogger<ReferralService> _logger;

    private const int ReferralBonusPoints = 50;
    private const int ReferralCodeLength = 8;
    private const string BaseReferralUrl = "https://silentid.co.uk/r/";

    public ReferralService(
        SilentIdDbContext context,
        ITrustScoreService trustScoreService,
        ILogger<ReferralService> logger)
    {
        _context = context;
        _trustScoreService = trustScoreService;
        _logger = logger;
    }

    public async Task<string> GetOrCreateReferralCodeAsync(Guid userId)
    {
        var user = await _context.Users.FindAsync(userId);
        if (user == null)
        {
            throw new InvalidOperationException("User not found");
        }

        if (!string.IsNullOrEmpty(user.ReferralCode))
        {
            return user.ReferralCode;
        }

        // Generate unique referral code
        var code = await GenerateUniqueReferralCodeAsync();
        user.ReferralCode = code;
        user.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        _logger.LogInformation("Generated referral code {Code} for user {UserId}", code, userId);

        return code;
    }

    public async Task<ReferralSummary> GetReferralSummaryAsync(Guid userId)
    {
        var code = await GetOrCreateReferralCodeAsync(userId);

        var referrals = await _context.Referrals
            .AsNoTracking()
            .Where(r => r.ReferrerId == userId)
            .ToListAsync();

        var totalEarned = referrals
            .Where(r => r.Status == ReferralStatus.Completed)
            .Sum(r => r.ReferrerPointsAwarded);

        var completedCount = referrals.Count(r => r.Status == ReferralStatus.Completed);
        var pendingCount = referrals.Count(r => r.Status == ReferralStatus.Pending || r.Status == ReferralStatus.SignedUp);

        return new ReferralSummary
        {
            ReferralCode = code,
            ReferralLink = $"{BaseReferralUrl}{code}",
            TotalReferrals = referrals.Count,
            CompletedReferrals = completedCount,
            PendingReferrals = pendingCount,
            TotalPointsEarned = totalEarned
        };
    }

    public async Task<List<ReferralInfo>> GetReferralsByUserAsync(Guid userId)
    {
        var referrals = await _context.Referrals
            .AsNoTracking()
            .Include(r => r.Referee)
            .Where(r => r.ReferrerId == userId)
            .OrderByDescending(r => r.CreatedAt)
            .ToListAsync();

        return referrals.Select(r => new ReferralInfo
        {
            Id = r.Id,
            RefereeName = r.Referee?.DisplayName ?? GetNameFromEmail(r.InvitedEmail),
            RefereeInitials = GetInitials(r.Referee?.DisplayName ?? r.InvitedEmail),
            Status = r.Status,
            PointsEarned = r.ReferrerPointsAwarded,
            InvitedAt = r.CreatedAt,
            SignedUpAt = r.SignedUpAt,
            CompletedAt = r.CompletedAt
        }).ToList();
    }

    public async Task<bool> ValidateReferralCodeAsync(string code)
    {
        if (string.IsNullOrWhiteSpace(code))
        {
            return false;
        }

        var codeUpperCase = code.ToUpperInvariant();

        // Check if code exists and belongs to an active user
        var user = await _context.Users
            .AsNoTracking()
            .FirstOrDefaultAsync(u => u.ReferralCode == codeUpperCase && u.AccountStatus == AccountStatus.Active);

        return user != null;
    }

    public async Task<bool> ApplyReferralCodeAsync(Guid newUserId, string referralCode)
    {
        if (string.IsNullOrWhiteSpace(referralCode))
        {
            return false;
        }

        var codeUpperCase = referralCode.ToUpperInvariant();

        // Find the referrer
        var referrer = await _context.Users
            .FirstOrDefaultAsync(u => u.ReferralCode == codeUpperCase && u.AccountStatus == AccountStatus.Active);

        if (referrer == null)
        {
            _logger.LogWarning("Invalid referral code {Code} used by user {UserId}", referralCode, newUserId);
            return false;
        }

        // Ensure user isn't referring themselves
        if (referrer.Id == newUserId)
        {
            _logger.LogWarning("User {UserId} attempted to use their own referral code", newUserId);
            return false;
        }

        // Get the new user
        var newUser = await _context.Users.FindAsync(newUserId);
        if (newUser == null)
        {
            return false;
        }

        // Check if this user was already referred
        var existingReferral = await _context.Referrals
            .FirstOrDefaultAsync(r => r.RefereeId == newUserId);

        if (existingReferral != null)
        {
            _logger.LogWarning("User {UserId} already has a referral record", newUserId);
            return false;
        }

        // Create referral record
        var referral = new Referral
        {
            ReferrerId = referrer.Id,
            RefereeId = newUserId,
            InvitedEmail = newUser.Email,
            ReferralCode = codeUpperCase,
            Status = ReferralStatus.SignedUp,
            SignedUpAt = DateTime.UtcNow
        };

        // Update new user's referred by code
        newUser.ReferredByCode = codeUpperCase;
        newUser.UpdatedAt = DateTime.UtcNow;

        _context.Referrals.Add(referral);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Referral applied: {ReferrerId} referred {RefereeId} with code {Code}",
            referrer.Id, newUserId, codeUpperCase);

        return true;
    }

    public async Task<bool> CompleteReferralAsync(Guid refereeUserId)
    {
        // Find pending referral for this user
        var referral = await _context.Referrals
            .Include(r => r.Referrer)
            .Include(r => r.Referee)
            .FirstOrDefaultAsync(r => r.RefereeId == refereeUserId &&
                                      (r.Status == ReferralStatus.Pending || r.Status == ReferralStatus.SignedUp));

        if (referral == null)
        {
            // No pending referral for this user
            return false;
        }

        // Mark referral as completed and award points
        referral.Status = ReferralStatus.Completed;
        referral.CompletedAt = DateTime.UtcNow;
        referral.ReferrerPointsAwarded = ReferralBonusPoints;
        referral.RefereePointsAwarded = ReferralBonusPoints;

        await _context.SaveChangesAsync();

        // Recalculate TrustScores for both users to include the bonus
        // The bonus is factored into the next TrustScore calculation
        if (referral.ReferrerId != Guid.Empty)
        {
            await _trustScoreService.CalculateAndSaveTrustScoreAsync(referral.ReferrerId);
        }
        await _trustScoreService.CalculateAndSaveTrustScoreAsync(refereeUserId);

        _logger.LogInformation("Referral completed: {ReferrerId} and {RefereeId} each earned +{Points} TrustScore bonus",
            referral.ReferrerId, refereeUserId, ReferralBonusPoints);

        return true;
    }

    private async Task<string> GenerateUniqueReferralCodeAsync()
    {
        const string chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // Excludes confusing chars: I, O, 0, 1
        var random = new Random();
        string code;
        int attempts = 0;

        do
        {
            code = new string(Enumerable.Repeat(chars, ReferralCodeLength)
                .Select(s => s[random.Next(s.Length)]).ToArray());
            attempts++;

            if (attempts > 100)
            {
                throw new InvalidOperationException("Failed to generate unique referral code");
            }
        }
        while (await _context.Users.AnyAsync(u => u.ReferralCode == code));

        return code;
    }

    private static string GetNameFromEmail(string? email)
    {
        if (string.IsNullOrEmpty(email))
        {
            return "Unknown";
        }

        var localPart = email.Split('@')[0];
        // Capitalize first letter
        return char.ToUpper(localPart[0]) + localPart.Substring(1);
    }

    private static string GetInitials(string? name)
    {
        if (string.IsNullOrEmpty(name))
        {
            return "??";
        }

        var parts = name.Split(' ', StringSplitOptions.RemoveEmptyEntries);
        if (parts.Length >= 2)
        {
            return $"{char.ToUpper(parts[0][0])}{char.ToUpper(parts[1][0])}";
        }
        return name.Length >= 2
            ? $"{char.ToUpper(name[0])}{char.ToUpper(name[1])}"
            : name.ToUpper();
    }
}

/// <summary>
/// Summary of a user's referral program status
/// </summary>
public class ReferralSummary
{
    public string ReferralCode { get; set; } = string.Empty;
    public string ReferralLink { get; set; } = string.Empty;
    public int TotalReferrals { get; set; }
    public int CompletedReferrals { get; set; }
    public int PendingReferrals { get; set; }
    public int TotalPointsEarned { get; set; }
}

/// <summary>
/// Information about a single referral
/// </summary>
public class ReferralInfo
{
    public Guid Id { get; set; }
    public string RefereeName { get; set; } = string.Empty;
    public string RefereeInitials { get; set; } = string.Empty;
    public ReferralStatus Status { get; set; }
    public int PointsEarned { get; set; }
    public DateTime InvitedAt { get; set; }
    public DateTime? SignedUpAt { get; set; }
    public DateTime? CompletedAt { get; set; }
}
