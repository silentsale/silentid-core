using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

/// <summary>
/// Smart Paywall Service per Section 50.3
/// Triggers paywall at value moments when user is most likely to convert
/// </summary>
public interface IPaywallService
{
    /// <summary>
    /// Check if paywall should be shown for this action
    /// </summary>
    Task<PaywallCheckResult> CheckPaywallAsync(Guid userId, PaywallTrigger trigger);

    /// <summary>
    /// Get user's current subscription status and limits
    /// </summary>
    Task<UserLimitsStatus> GetUserLimitsAsync(Guid userId);

    /// <summary>
    /// Record that user dismissed a paywall (for analytics)
    /// </summary>
    Task RecordPaywallDismissedAsync(Guid userId, PaywallTrigger trigger);
}

public enum PaywallTrigger
{
    TrustScore500Reached,      // First time reaching 500+ TrustScore
    Evidence10thUploaded,      // 10th evidence upload milestone
    PassportShareAttempt,      // Trying to share Trust Passport
    QrBadgeDownload,           // Trying to download QR badge
    FullHistoryAccess,         // Accessing full TrustScore history
    UnlimitedEvidence,         // Exceeding free evidence limit
    PremiumSupport,            // Requesting priority support
    AdvancedAnalytics,         // Accessing detailed analytics
    CustomPassportUrl          // Custom passport URL feature
}

public class PaywallCheckResult
{
    public bool ShouldShowPaywall { get; set; }
    public PaywallTrigger Trigger { get; set; }
    public string? Message { get; set; }
    public string? CtaText { get; set; }
    public bool IsHardBlock { get; set; } // true = must subscribe, false = soft limit (can dismiss)
    public int? CurrentUsage { get; set; }
    public int? Limit { get; set; }
    public string? FeatureName { get; set; }
}

public class UserLimitsStatus
{
    public bool IsPremium { get; set; }
    public DateTime? SubscriptionExpiresAt { get; set; }

    // Evidence limits
    public int EvidenceCount { get; set; }
    public int EvidenceLimit { get; set; }
    public bool CanUploadMoreEvidence => EvidenceCount < EvidenceLimit || IsPremium;

    // Profile limits
    public int LinkedProfilesCount { get; set; }
    public int LinkedProfilesLimit { get; set; }
    public bool CanLinkMoreProfiles => LinkedProfilesCount < LinkedProfilesLimit || IsPremium;

    // Feature access
    public bool CanSharePassport { get; set; }
    public bool CanDownloadQrBadge { get; set; }
    public bool CanAccessFullHistory { get; set; }
    public bool CanAccessAnalytics { get; set; }
}

public class PaywallService : IPaywallService
{
    private readonly SilentIdDbContext _db;
    private readonly ILogger<PaywallService> _logger;

    // Free tier limits per Section 50.3.2 (v2.0: 5 profiles for free tier)
    private const int FreeEvidenceLimit = 15; // Legacy - not used in v2.0
    private const int FreeProfileLimit = 5;
    private const int TrustScoreMilestone = 500;
    private const int EvidenceMilestone = 10;

    public PaywallService(SilentIdDbContext db, ILogger<PaywallService> logger)
    {
        _db = db;
        _logger = logger;
    }

    public async Task<PaywallCheckResult> CheckPaywallAsync(Guid userId, PaywallTrigger trigger)
    {
        var user = await _db.Users.FindAsync(userId);
        if (user == null)
        {
            return new PaywallCheckResult { ShouldShowPaywall = false };
        }

        // Check if user has active premium subscription
        var subscription = await _db.Subscriptions
            .Where(s => s.UserId == userId && s.Status == SubscriptionStatus.Active)
            .FirstOrDefaultAsync();

        var isPremium = subscription != null && subscription.Tier != SubscriptionTier.Free;

        // Premium users bypass all paywalls
        if (isPremium)
        {
            return new PaywallCheckResult { ShouldShowPaywall = false };
        }

        // Check specific triggers
        return trigger switch
        {
            PaywallTrigger.TrustScore500Reached => await CheckTrustScoreMilestoneAsync(userId),
            PaywallTrigger.Evidence10thUploaded => await CheckEvidenceMilestoneAsync(userId),
            PaywallTrigger.PassportShareAttempt => CheckPassportSharePaywall(),
            PaywallTrigger.QrBadgeDownload => CheckQrBadgePaywall(),
            PaywallTrigger.FullHistoryAccess => CheckHistoryAccessPaywall(),
            PaywallTrigger.UnlimitedEvidence => await CheckEvidenceLimitAsync(userId),
            PaywallTrigger.AdvancedAnalytics => CheckAnalyticsPaywall(),
            PaywallTrigger.CustomPassportUrl => CheckCustomUrlPaywall(),
            _ => new PaywallCheckResult { ShouldShowPaywall = false }
        };
    }

    public async Task<UserLimitsStatus> GetUserLimitsAsync(Guid userId)
    {
        var subscription = await _db.Subscriptions
            .Where(s => s.UserId == userId && s.Status == SubscriptionStatus.Active)
            .FirstOrDefaultAsync();

        var isPremium = subscription != null && subscription.Tier != SubscriptionTier.Free;

        // v2.0: Receipts and screenshots removed - only profile links remain
        var evidenceCount = 0; // Legacy field - no longer tracked
        var linkedProfiles = await _db.ProfileLinkEvidences.CountAsync(p => p.UserId == userId);

        return new UserLimitsStatus
        {
            IsPremium = isPremium,
            SubscriptionExpiresAt = subscription?.RenewalDate,
            EvidenceCount = evidenceCount,
            EvidenceLimit = isPremium ? int.MaxValue : FreeEvidenceLimit,
            LinkedProfilesCount = linkedProfiles,
            LinkedProfilesLimit = isPremium ? int.MaxValue : FreeProfileLimit,
            CanSharePassport = isPremium, // Premium feature
            CanDownloadQrBadge = isPremium, // Premium feature
            CanAccessFullHistory = isPremium, // Premium feature
            CanAccessAnalytics = isPremium // Premium feature
        };
    }

    public async Task RecordPaywallDismissedAsync(Guid userId, PaywallTrigger trigger)
    {
        _logger.LogInformation("User {UserId} dismissed paywall for trigger {Trigger}", userId, trigger);
        // Could store in analytics table for conversion optimization
        await Task.CompletedTask;
    }

    private async Task<PaywallCheckResult> CheckTrustScoreMilestoneAsync(Guid userId)
    {
        var latestScore = await _db.TrustScoreSnapshots
            .Where(t => t.UserId == userId)
            .OrderByDescending(t => t.CreatedAt)
            .Select(t => t.Score)
            .FirstOrDefaultAsync();

        if (latestScore >= TrustScoreMilestone)
        {
            return new PaywallCheckResult
            {
                ShouldShowPaywall = true,
                Trigger = PaywallTrigger.TrustScore500Reached,
                Message = $"Congratulations! You've reached a TrustScore of {latestScore}. Unlock premium features to showcase your trusted reputation.",
                CtaText = "Unlock Premium",
                IsHardBlock = false,
                FeatureName = "TrustScore Milestone"
            };
        }

        return new PaywallCheckResult { ShouldShowPaywall = false };
    }

    private async Task<PaywallCheckResult> CheckEvidenceMilestoneAsync(Guid userId)
    {
        // v2.0: Receipts and screenshots removed - check profile link milestone instead
        var profileLinksCount = await _db.ProfileLinkEvidences.CountAsync(e => e.UserId == userId);

        if (profileLinksCount == EvidenceMilestone)
        {
            return new PaywallCheckResult
            {
                ShouldShowPaywall = true,
                Trigger = PaywallTrigger.Evidence10thUploaded,
                Message = "You've connected 10 profiles! Upgrade to Pro for unlimited profile connections and advanced features.",
                CtaText = "Go Pro",
                IsHardBlock = false,
                CurrentUsage = profileLinksCount,
                FeatureName = "Profile Milestone"
            };
        }

        return new PaywallCheckResult { ShouldShowPaywall = false };
    }

    private async Task<PaywallCheckResult> CheckEvidenceLimitAsync(Guid userId)
    {
        // v2.0: Check profile link limit (receipts/screenshots removed)
        var profileLinksCount = await _db.ProfileLinkEvidences.CountAsync(e => e.UserId == userId);

        if (profileLinksCount >= FreeProfileLimit)
        {
            return new PaywallCheckResult
            {
                ShouldShowPaywall = true,
                Trigger = PaywallTrigger.UnlimitedEvidence,
                Message = $"You've reached the free limit of {FreeProfileLimit} profile connections. Upgrade to Pro for unlimited profiles.",
                CtaText = "Upgrade Now",
                IsHardBlock = true, // Hard block - can't continue without subscription
                CurrentUsage = profileLinksCount,
                Limit = FreeProfileLimit,
                FeatureName = "Profile Connections"
            };
        }

        return new PaywallCheckResult { ShouldShowPaywall = false };
    }

    private PaywallCheckResult CheckPassportSharePaywall()
    {
        return new PaywallCheckResult
        {
            ShouldShowPaywall = true,
            Trigger = PaywallTrigger.PassportShareAttempt,
            Message = "Share your Trust Passport with a premium subscription. Let others verify your trusted reputation.",
            CtaText = "Unlock Sharing",
            IsHardBlock = false, // Soft block - can dismiss but feature limited
            FeatureName = "Trust Passport Sharing"
        };
    }

    private PaywallCheckResult CheckQrBadgePaywall()
    {
        return new PaywallCheckResult
        {
            ShouldShowPaywall = true,
            Trigger = PaywallTrigger.QrBadgeDownload,
            Message = "Download your verified QR badge to share on social media and marketplaces.",
            CtaText = "Get QR Badge",
            IsHardBlock = true,
            FeatureName = "QR Verification Badge"
        };
    }

    private PaywallCheckResult CheckHistoryAccessPaywall()
    {
        return new PaywallCheckResult
        {
            ShouldShowPaywall = true,
            Trigger = PaywallTrigger.FullHistoryAccess,
            Message = "Access your complete TrustScore history and see how your reputation has evolved.",
            CtaText = "View Full History",
            IsHardBlock = true,
            FeatureName = "TrustScore History"
        };
    }

    private PaywallCheckResult CheckAnalyticsPaywall()
    {
        return new PaywallCheckResult
        {
            ShouldShowPaywall = true,
            Trigger = PaywallTrigger.AdvancedAnalytics,
            Message = "Get detailed insights into your trust profile performance and passport views.",
            CtaText = "Unlock Analytics",
            IsHardBlock = true,
            FeatureName = "Advanced Analytics"
        };
    }

    private PaywallCheckResult CheckCustomUrlPaywall()
    {
        return new PaywallCheckResult
        {
            ShouldShowPaywall = true,
            Trigger = PaywallTrigger.CustomPassportUrl,
            Message = "Create a custom URL for your Trust Passport (e.g., silentid.co.uk/p/yourname)",
            CtaText = "Get Custom URL",
            IsHardBlock = true,
            FeatureName = "Custom Passport URL"
        };
    }
}
