using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

/// <summary>
/// Soft Limits Enforcement Service per Section 50.3.3
/// Enforces usage limits with soft (warning) and hard (blocking) thresholds
/// </summary>
public interface ISoftLimitsService
{
    /// <summary>
    /// Check if user can perform an action and return limit status
    /// </summary>
    Task<LimitCheckResult> CheckLimitAsync(Guid userId, LimitType limitType);

    /// <summary>
    /// Increment usage counter for a limit type
    /// </summary>
    Task IncrementUsageAsync(Guid userId, LimitType limitType);

    /// <summary>
    /// Get all limits and usage for a user
    /// </summary>
    Task<AllLimitsStatus> GetAllLimitsAsync(Guid userId);
}

public enum LimitType
{
    EvidenceUpload,         // Receipts + Screenshots
    ProfileLinks,           // Connected profiles
    PassportShares,         // Shares per month
    QrDownloads,            // QR badge downloads per month
    SupportTickets,         // Support tickets per month
    PassportViews           // Incoming passport views (soft metric)
}

public class LimitCheckResult
{
    public bool CanProceed { get; set; }
    public bool IsAtSoftLimit { get; set; }
    public bool IsAtHardLimit { get; set; }
    public int CurrentUsage { get; set; }
    public int SoftLimit { get; set; }
    public int HardLimit { get; set; }
    public string? WarningMessage { get; set; }
    public string? BlockMessage { get; set; }
}

public class AllLimitsStatus
{
    public bool IsPremium { get; set; }
    public List<LimitStatus> Limits { get; set; } = new();
}

public class LimitStatus
{
    public LimitType Type { get; set; }
    public string DisplayName { get; set; } = string.Empty;
    public int CurrentUsage { get; set; }
    public int SoftLimit { get; set; }
    public int HardLimit { get; set; }
    public double UsagePercentage => HardLimit > 0 ? (double)CurrentUsage / HardLimit * 100 : 0;
    public bool IsNearLimit => UsagePercentage >= 80;
    public bool IsAtLimit => CurrentUsage >= HardLimit;
}

public class SoftLimitsService : ISoftLimitsService
{
    private readonly SilentIdDbContext _db;
    private readonly ILogger<SoftLimitsService> _logger;

    // Free tier limits (soft limit = warning, hard limit = block)
    private static readonly Dictionary<LimitType, (int Soft, int Hard, string Name)> FreeLimits = new()
    {
        { LimitType.EvidenceUpload, (10, 15, "Evidence Uploads") },
        { LimitType.ProfileLinks, (2, 3, "Profile Connections") },
        { LimitType.PassportShares, (3, 5, "Passport Shares (monthly)") },
        { LimitType.QrDownloads, (1, 1, "QR Badge Downloads") },
        { LimitType.SupportTickets, (2, 3, "Support Tickets (monthly)") },
        { LimitType.PassportViews, (50, int.MaxValue, "Passport Views (monthly)") } // Soft metric only
    };

    public SoftLimitsService(SilentIdDbContext db, ILogger<SoftLimitsService> logger)
    {
        _db = db;
        _logger = logger;
    }

    public async Task<LimitCheckResult> CheckLimitAsync(Guid userId, LimitType limitType)
    {
        // Check if premium (premium has no limits)
        var isPremium = await IsPremiumUserAsync(userId);
        if (isPremium)
        {
            return new LimitCheckResult
            {
                CanProceed = true,
                IsAtSoftLimit = false,
                IsAtHardLimit = false,
                CurrentUsage = 0,
                SoftLimit = int.MaxValue,
                HardLimit = int.MaxValue
            };
        }

        var currentUsage = await GetUsageCountAsync(userId, limitType);
        var limits = FreeLimits[limitType];

        var result = new LimitCheckResult
        {
            CurrentUsage = currentUsage,
            SoftLimit = limits.Soft,
            HardLimit = limits.Hard
        };

        if (currentUsage >= limits.Hard)
        {
            result.CanProceed = false;
            result.IsAtHardLimit = true;
            result.BlockMessage = $"You've reached the free limit for {limits.Name}. Upgrade to premium for unlimited access.";
            _logger.LogInformation("User {UserId} blocked by hard limit: {LimitType}", userId, limitType);
        }
        else if (currentUsage >= limits.Soft)
        {
            result.CanProceed = true;
            result.IsAtSoftLimit = true;
            result.WarningMessage = $"You're approaching the limit for {limits.Name} ({currentUsage}/{limits.Hard}). Consider upgrading to premium.";
            _logger.LogDebug("User {UserId} at soft limit: {LimitType}", userId, limitType);
        }
        else
        {
            result.CanProceed = true;
        }

        return result;
    }

    public async Task IncrementUsageAsync(Guid userId, LimitType limitType)
    {
        // This is handled by actual data creation in most cases
        // For monthly limits, we track by counting records within the month
        _logger.LogDebug("Usage incremented for user {UserId}: {LimitType}", userId, limitType);
        await Task.CompletedTask;
    }

    public async Task<AllLimitsStatus> GetAllLimitsAsync(Guid userId)
    {
        var isPremium = await IsPremiumUserAsync(userId);

        var limits = new List<LimitStatus>();

        foreach (var (limitType, config) in FreeLimits)
        {
            var usage = await GetUsageCountAsync(userId, limitType);

            limits.Add(new LimitStatus
            {
                Type = limitType,
                DisplayName = config.Name,
                CurrentUsage = usage,
                SoftLimit = isPremium ? int.MaxValue : config.Soft,
                HardLimit = isPremium ? int.MaxValue : config.Hard
            });
        }

        return new AllLimitsStatus
        {
            IsPremium = isPremium,
            Limits = limits
        };
    }

    private async Task<bool> IsPremiumUserAsync(Guid userId)
    {
        var subscription = await _db.Subscriptions
            .Where(s => s.UserId == userId && s.Status == SubscriptionStatus.Active)
            .FirstOrDefaultAsync();

        return subscription != null && subscription.Tier != SubscriptionTier.Free;
    }

    private async Task<int> GetUsageCountAsync(Guid userId, LimitType limitType)
    {
        var startOfMonth = new DateTime(DateTime.UtcNow.Year, DateTime.UtcNow.Month, 1);

        return limitType switch
        {
            LimitType.EvidenceUpload =>
                await _db.ReceiptEvidences.CountAsync(e => e.UserId == userId) +
                await _db.ScreenshotEvidences.CountAsync(e => e.UserId == userId),

            LimitType.ProfileLinks =>
                await _db.ProfileLinkEvidences.CountAsync(p => p.UserId == userId),

            LimitType.PassportShares =>
                // Would need a PassportShare tracking table
                // For now, return 0 as placeholder
                0,

            LimitType.QrDownloads =>
                // Would need a QrDownload tracking table
                // For now, return 0 as placeholder
                0,

            LimitType.SupportTickets =>
                await _db.SupportTickets
                    .CountAsync(t => t.UserId == userId && t.CreatedAt >= startOfMonth),

            LimitType.PassportViews =>
                // Would need passport view tracking
                // For now, return 0 as placeholder
                0,

            _ => 0
        };
    }
}
