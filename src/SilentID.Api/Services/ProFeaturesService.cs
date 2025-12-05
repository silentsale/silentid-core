using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

/// <summary>
/// Pro Features Service - Handles Pro-only features:
/// - Combined Star Rating aggregation
/// - Rating Drop Alerts
/// - 7-day manual stats refresh
/// - Custom Passport URL
/// - Trust Timeline (Pro-gated)
/// </summary>
public interface IProFeaturesService
{
    /// <summary>
    /// Get combined star rating across all verified marketplace profiles.
    /// Pro feature: Shows aggregated rating from all platforms.
    /// </summary>
    Task<CombinedStarRating> GetCombinedStarRatingAsync(Guid userId);

    /// <summary>
    /// Check if user can perform manual stats refresh (Pro: 7 days, Free: 30 days).
    /// </summary>
    Task<ManualRefreshStatus> GetManualRefreshStatusAsync(Guid userId);

    /// <summary>
    /// Perform manual stats refresh for Pro users (7-day limit).
    /// </summary>
    Task<ManualRefreshResult> PerformManualRefreshAsync(Guid userId);

    /// <summary>
    /// Get rating change history for a user.
    /// Pro feature: Shows historical rating changes.
    /// </summary>
    Task<List<RatingChangeHistory>> GetRatingHistoryAsync(Guid userId, int days = 90);

    /// <summary>
    /// Check for rating drops and send alerts (Pro feature).
    /// Called by background job when profile stats are refreshed.
    /// </summary>
    Task CheckRatingDropsAsync(Guid userId, Guid profileLinkId, decimal? previousRating, decimal? newRating);

    /// <summary>
    /// Set custom passport URL for Pro users.
    /// </summary>
    Task<bool> SetCustomPassportUrlAsync(Guid userId, string customUrl);

    /// <summary>
    /// Check if custom passport URL is available.
    /// </summary>
    Task<bool> IsCustomUrlAvailableAsync(string customUrl);

    /// <summary>
    /// Get user's custom passport URL.
    /// </summary>
    Task<string?> GetCustomPassportUrlAsync(Guid userId);

    /// <summary>
    /// Check if user has Pro subscription.
    /// </summary>
    Task<bool> IsProUserAsync(Guid userId);

    /// <summary>
    /// Generate dispute evidence PDF for Pro users.
    /// Legal-ready document containing full reputation history.
    /// </summary>
    Task<DisputeEvidenceResult> GenerateDisputeEvidencePackAsync(Guid userId);

    /// <summary>
    /// Get list of active platform incidents (mass bans, shutdowns).
    /// Pro feature: Platform Watchdog alerts.
    /// </summary>
    Task<List<PlatformIncident>> GetActivePlatformIncidentsAsync();

    /// <summary>
    /// Subscribe user to platform watchdog alerts.
    /// </summary>
    Task<bool> SubscribeToPlatformWatchdogAsync(Guid userId, string platform);

    /// <summary>
    /// Get user's watchdog subscriptions.
    /// </summary>
    Task<List<string>> GetWatchdogSubscriptionsAsync(Guid userId);
}

public class ProFeaturesService : IProFeaturesService
{
    private readonly SilentIdDbContext _db;
    private readonly ISubscriptionService _subscriptionService;
    private readonly INotificationService _notificationService;
    private readonly ILogger<ProFeaturesService> _logger;

    // Custom URL restrictions
    private static readonly string[] ReservedUrls = { "admin", "api", "app", "help", "support", "about", "terms", "privacy", "u", "user", "verify", "passport" };

    public ProFeaturesService(
        SilentIdDbContext db,
        ISubscriptionService subscriptionService,
        INotificationService notificationService,
        ILogger<ProFeaturesService> logger)
    {
        _db = db;
        _subscriptionService = subscriptionService;
        _notificationService = notificationService;
        _logger = logger;
    }

    public async Task<bool> IsProUserAsync(Guid userId)
    {
        var subscription = await _subscriptionService.GetUserSubscriptionAsync(userId);
        return subscription?.Tier == SubscriptionTier.Pro && subscription.Status == SubscriptionStatus.Active;
    }

    public async Task<CombinedStarRating> GetCombinedStarRatingAsync(Guid userId)
    {
        // Get all verified marketplace profiles with ratings
        var profiles = await _db.ProfileLinkEvidences
            .AsNoTracking()
            .Where(p => p.UserId == userId &&
                        p.EvidenceState == EvidenceState.Valid &&
                        p.LinkState == "Verified" &&
                        p.PlatformRating != null)
            .Select(p => new
            {
                p.Platform,
                Rating = p.PlatformRating ?? 0,
                ReviewCount = p.ReviewCount ?? 0
            })
            .ToListAsync();

        if (!profiles.Any())
        {
            return new CombinedStarRating
            {
                CombinedRating = 0,
                PlatformCount = 0,
                TotalReviews = 0,
                Platforms = new List<PlatformRatingSummary>()
            };
        }

        // Calculate weighted average based on review counts
        var totalReviews = profiles.Sum(p => p.ReviewCount);
        var weightedSum = 0m;

        if (totalReviews > 0)
        {
            foreach (var profile in profiles)
            {
                // Normalize all ratings to 5-star scale
                var normalizedRating = NormalizeToFiveStarScale(profile.Rating, profile.Platform.ToString());
                var weight = (decimal)profile.ReviewCount / totalReviews;
                weightedSum += normalizedRating * weight;
            }
        }
        else
        {
            // If no reviews, just average the ratings
            weightedSum = profiles.Average(p => NormalizeToFiveStarScale(p.Rating, p.Platform.ToString()));
        }

        return new CombinedStarRating
        {
            CombinedRating = Math.Round(weightedSum, 1),
            PlatformCount = profiles.Count,
            TotalReviews = totalReviews,
            Platforms = profiles.Select(p => new PlatformRatingSummary
            {
                Platform = p.Platform.ToString(),
                Rating = NormalizeToFiveStarScale(p.Rating, p.Platform.ToString()),
                ReviewCount = p.ReviewCount
            }).ToList()
        };
    }

    public async Task<ManualRefreshStatus> GetManualRefreshStatusAsync(Guid userId)
    {
        var isPro = await IsProUserAsync(userId);
        var refreshDays = isPro ? 7 : 30;

        // Find last manual refresh
        var lastRefresh = await _db.ProfileLinkEvidences
            .Where(p => p.UserId == userId && p.ExtractedAt != null)
            .OrderByDescending(p => p.ExtractedAt)
            .Select(p => p.ExtractedAt)
            .FirstOrDefaultAsync();

        var nextAvailable = lastRefresh?.AddDays(refreshDays) ?? DateTime.UtcNow;
        var canRefresh = DateTime.UtcNow >= nextAvailable;

        return new ManualRefreshStatus
        {
            IsPro = isPro,
            RefreshIntervalDays = refreshDays,
            LastRefresh = lastRefresh,
            NextAvailable = canRefresh ? DateTime.UtcNow : nextAvailable,
            CanRefreshNow = canRefresh
        };
    }

    public async Task<ManualRefreshResult> PerformManualRefreshAsync(Guid userId)
    {
        var status = await GetManualRefreshStatusAsync(userId);

        if (!status.CanRefreshNow)
        {
            return new ManualRefreshResult
            {
                Success = false,
                Message = $"You can refresh again on {status.NextAvailable:MMM dd, yyyy}",
                NextAvailable = status.NextAvailable
            };
        }

        // Mark profiles for refresh by the background job
        // In production, this would trigger the Playwright capture service
        var profiles = await _db.ProfileLinkEvidences
            .Where(p => p.UserId == userId &&
                        p.EvidenceState == EvidenceState.Valid &&
                        p.LinkState == "Verified")
            .ToListAsync();

        foreach (var profile in profiles)
        {
            profile.ExtractedAt = DateTime.UtcNow;
            profile.UpdatedAt = DateTime.UtcNow;
        }

        await _db.SaveChangesAsync();

        _logger.LogInformation("Manual stats refresh triggered for user {UserId}, {Count} profiles queued",
            userId, profiles.Count);

        return new ManualRefreshResult
        {
            Success = true,
            Message = $"Refresh started for {profiles.Count} profiles. Updates will appear shortly.",
            ProfilesRefreshed = profiles.Count,
            NextAvailable = DateTime.UtcNow.AddDays(status.RefreshIntervalDays)
        };
    }

    public async Task<List<RatingChangeHistory>> GetRatingHistoryAsync(Guid userId, int days = 90)
    {
        var cutoff = DateTime.UtcNow.AddDays(-days);

        return await _db.Set<RatingChangeHistory>()
            .AsNoTracking()
            .Where(r => r.UserId == userId && r.CreatedAt >= cutoff)
            .OrderByDescending(r => r.CreatedAt)
            .ToListAsync();
    }

    public async Task CheckRatingDropsAsync(Guid userId, Guid profileLinkId, decimal? previousRating, decimal? newRating)
    {
        // Only alert Pro users
        if (!await IsProUserAsync(userId))
            return;

        if (previousRating == null || newRating == null)
            return;

        var change = newRating.Value - previousRating.Value;

        // Only alert on drops (negative change)
        if (change >= 0)
            return;

        var profile = await _db.ProfileLinkEvidences
            .AsNoTracking()
            .FirstOrDefaultAsync(p => p.Id == profileLinkId);

        if (profile == null)
            return;

        // Record the change
        var history = new RatingChangeHistory
        {
            ProfileLinkId = profileLinkId,
            UserId = userId,
            Platform = profile.Platform.ToString(),
            PreviousRating = previousRating,
            NewRating = newRating,
            PreviousReviewCount = profile.ReviewCount,
            NewReviewCount = profile.ReviewCount,
            RatingChange = change
        };

        _db.Set<RatingChangeHistory>().Add(history);
        await _db.SaveChangesAsync();

        // Send notification
        await _notificationService.NotifyAsync(
            userId,
            NotificationType.TrustScoreUpdate,
            "Rating Change Detected",
            $"Your {profile.Platform} rating changed from {previousRating:F1} to {newRating:F1} ({change:F1})",
            sendEmail: true
        );

        // Mark alert as sent
        history.AlertSent = true;
        history.AlertSentAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();

        _logger.LogInformation(
            "Rating drop alert sent for user {UserId}: {Platform} rating dropped from {Old} to {New}",
            userId, profile.Platform, previousRating, newRating);
    }

    public async Task<bool> SetCustomPassportUrlAsync(Guid userId, string customUrl)
    {
        if (!await IsProUserAsync(userId))
        {
            _logger.LogWarning("Non-Pro user {UserId} attempted to set custom URL", userId);
            return false;
        }

        customUrl = customUrl.Trim().ToLowerInvariant();

        if (!IsValidCustomUrl(customUrl))
        {
            _logger.LogWarning("Invalid custom URL format attempted by user {UserId}: {Url}", userId, customUrl);
            return false;
        }

        if (!await IsCustomUrlAvailableAsync(customUrl))
        {
            _logger.LogWarning("Custom URL already taken for user {UserId}: {Url}", userId, customUrl);
            return false;
        }

        var user = await _db.Users.FindAsync(userId);
        if (user == null)
            return false;

        // Store custom URL in Username field (it already has unique constraint)
        // Or we could add a new CustomPassportUrl field - for now we'll update Username
        var oldUsername = user.Username;
        user.Username = customUrl;
        user.UpdatedAt = DateTime.UtcNow;

        await _db.SaveChangesAsync();

        _logger.LogInformation("Custom passport URL set for user {UserId}: {OldUrl} -> {NewUrl}",
            userId, oldUsername, customUrl);

        return true;
    }

    public async Task<bool> IsCustomUrlAvailableAsync(string customUrl)
    {
        customUrl = customUrl.Trim().ToLowerInvariant();

        // Check reserved words
        if (ReservedUrls.Contains(customUrl))
            return false;

        // Check if already taken
        return !await _db.Users.AnyAsync(u => u.Username.ToLower() == customUrl);
    }

    public async Task<string?> GetCustomPassportUrlAsync(Guid userId)
    {
        var user = await _db.Users
            .AsNoTracking()
            .FirstOrDefaultAsync(u => u.Id == userId);

        return user?.Username;
    }

    private static bool IsValidCustomUrl(string url)
    {
        if (string.IsNullOrWhiteSpace(url))
            return false;

        if (url.Length < 3 || url.Length > 30)
            return false;

        // Only alphanumeric and hyphens, must start with letter
        if (!System.Text.RegularExpressions.Regex.IsMatch(url, @"^[a-z][a-z0-9-]*[a-z0-9]$"))
            return false;

        // No consecutive hyphens
        if (url.Contains("--"))
            return false;

        return true;
    }

    private static decimal NormalizeToFiveStarScale(decimal rating, string platform)
    {
        // eBay uses percentage (0-100), normalize to 5-star
        if (platform.Contains("ebay", StringComparison.OrdinalIgnoreCase))
        {
            return Math.Round(rating / 20m, 1);
        }

        // Most platforms use 5-star scale
        return Math.Min(rating, 5.0m);
    }

    public async Task<DisputeEvidenceResult> GenerateDisputeEvidencePackAsync(Guid userId)
    {
        // Pro-only feature
        if (!await IsProUserAsync(userId))
        {
            return new DisputeEvidenceResult
            {
                Success = false,
                Error = "pro_required",
                Message = "Dispute Evidence Pack is a Pro feature. Upgrade to generate legal-ready reputation documents."
            };
        }

        var user = await _db.Users
            .AsNoTracking()
            .FirstOrDefaultAsync(u => u.Id == userId);

        if (user == null)
        {
            return new DisputeEvidenceResult
            {
                Success = false,
                Error = "user_not_found",
                Message = "User not found."
            };
        }

        // Get all verified profiles with ratings
        var profiles = await _db.ProfileLinkEvidences
            .AsNoTracking()
            .Where(p => p.UserId == userId &&
                        p.EvidenceState == EvidenceState.Valid &&
                        p.LinkState == "Verified")
            .ToListAsync();

        // Get TrustScore history
        var trustScoreHistory = await _db.TrustScoreSnapshots
            .AsNoTracking()
            .Where(t => t.UserId == userId)
            .OrderByDescending(t => t.CreatedAt)
            .Take(30) // Last 30 snapshots
            .ToListAsync();

        // Get rating change history
        var ratingHistory = await GetRatingHistoryAsync(userId, 365);

        // Get combined star rating
        var combinedRating = await GetCombinedStarRatingAsync(userId);

        // Generate document ID
        var documentId = Guid.NewGuid();
        var generatedAt = DateTime.UtcNow;

        // In production, this would generate an actual PDF using a library like iTextSharp or QuestPDF
        // For now, we return the structured data that would be used to generate the PDF
        var evidence = new DisputeEvidenceResult
        {
            Success = true,
            DocumentId = documentId,
            GeneratedAt = generatedAt,
            ExpiresAt = generatedAt.AddDays(30), // Valid for 30 days
            VerificationUrl = $"https://silentid.co.uk/verify/{documentId}",
            UserSummary = new UserEvidenceSummary
            {
                UserId = userId,
                Username = user.Username,
                Email = user.Email,
                AccountCreatedAt = user.CreatedAt,
                IsIdentityVerified = await IsIdentityVerifiedAsync(userId),
                IdentityVerifiedAt = await GetIdentityVerifiedAtAsync(userId),
                CurrentTrustScore = trustScoreHistory.FirstOrDefault()?.Score ?? 0,
                TrustLabel = GetTrustLabel(trustScoreHistory.FirstOrDefault()?.Score ?? 0)
            },
            ProfilesSummary = profiles.Select(p => new ProfileEvidenceSummary
            {
                Platform = p.Platform.ToString(),
                ProfileUrl = p.URL,
                VerifiedAt = p.OwnershipLockedAt,
                Rating = p.PlatformRating,
                ReviewCount = p.ReviewCount,
                ScreenshotUrl = GetFirstScreenshotUrl(p.ManualScreenshotUrlsJson)
            }).ToList(),
            CombinedRating = combinedRating,
            TrustScoreHistory = trustScoreHistory.Select(t => new TrustScoreHistoryEntry
            {
                Score = t.Score,
                Date = t.CreatedAt
            }).ToList(),
            RatingHistory = ratingHistory.Select(r => new RatingHistoryEntry
            {
                Platform = r.Platform,
                PreviousRating = r.PreviousRating,
                NewRating = r.NewRating,
                Change = r.RatingChange,
                Date = r.CreatedAt
            }).ToList()
        };

        _logger.LogInformation("Dispute evidence pack generated for user {UserId}, document {DocumentId}",
            userId, documentId);

        return evidence;
    }

    public async Task<List<PlatformIncident>> GetActivePlatformIncidentsAsync()
    {
        // This would query a table of known platform incidents
        // For now, we return a static list that would be populated by admin/monitoring
        var cutoff = DateTime.UtcNow.AddDays(-30);

        var incidents = await _db.Set<PlatformIncident>()
            .AsNoTracking()
            .Where(i => i.IsActive && i.ReportedAt >= cutoff)
            .OrderByDescending(i => i.ReportedAt)
            .ToListAsync();

        return incidents;
    }

    public async Task<bool> SubscribeToPlatformWatchdogAsync(Guid userId, string platform)
    {
        // Pro-only feature
        if (!await IsProUserAsync(userId))
        {
            _logger.LogWarning("Non-Pro user {UserId} attempted to subscribe to watchdog", userId);
            return false;
        }

        platform = platform.Trim().ToLowerInvariant();

        // Check if already subscribed
        var existing = await _db.Set<WatchdogSubscription>()
            .FirstOrDefaultAsync(w => w.UserId == userId && w.Platform.ToLower() == platform);

        if (existing != null)
        {
            return true; // Already subscribed
        }

        var subscription = new WatchdogSubscription
        {
            UserId = userId,
            Platform = platform,
            SubscribedAt = DateTime.UtcNow
        };

        _db.Set<WatchdogSubscription>().Add(subscription);
        await _db.SaveChangesAsync();

        _logger.LogInformation("User {UserId} subscribed to {Platform} watchdog alerts", userId, platform);
        return true;
    }

    public async Task<List<string>> GetWatchdogSubscriptionsAsync(Guid userId)
    {
        return await _db.Set<WatchdogSubscription>()
            .AsNoTracking()
            .Where(w => w.UserId == userId)
            .Select(w => w.Platform)
            .ToListAsync();
    }

    private static string GetTrustLabel(int score)
    {
        return score switch
        {
            >= 850 => "Exceptional",
            >= 700 => "Very High",
            >= 550 => "High",
            >= 400 => "Moderate",
            >= 250 => "Low",
            _ => "High Risk"
        };
    }

    /// <summary>
    /// Check if user has verified identity via Stripe.
    /// </summary>
    private async Task<bool> IsIdentityVerifiedAsync(Guid userId)
    {
        var verification = await _db.IdentityVerifications
            .AsNoTracking()
            .Where(v => v.UserId == userId && v.Status == VerificationStatus.Verified)
            .FirstOrDefaultAsync();

        return verification != null;
    }

    /// <summary>
    /// Get the date when identity was verified.
    /// </summary>
    private async Task<DateTime?> GetIdentityVerifiedAtAsync(Guid userId)
    {
        var verification = await _db.IdentityVerifications
            .AsNoTracking()
            .Where(v => v.UserId == userId && v.Status == VerificationStatus.Verified)
            .FirstOrDefaultAsync();

        return verification?.VerifiedAt;
    }

    /// <summary>
    /// Get the first screenshot URL from JSON array.
    /// </summary>
    private static string? GetFirstScreenshotUrl(string? screenshotUrlsJson)
    {
        if (string.IsNullOrEmpty(screenshotUrlsJson))
            return null;

        try
        {
            var urls = System.Text.Json.JsonSerializer.Deserialize<string[]>(screenshotUrlsJson);
            return urls?.FirstOrDefault();
        }
        catch
        {
            return null;
        }
    }
}

/// <summary>
/// Combined star rating across all platforms.
/// </summary>
public class CombinedStarRating
{
    /// <summary>
    /// Weighted average rating (0-5 scale).
    /// </summary>
    public decimal CombinedRating { get; set; }

    /// <summary>
    /// Number of platforms included.
    /// </summary>
    public int PlatformCount { get; set; }

    /// <summary>
    /// Total reviews across all platforms.
    /// </summary>
    public int TotalReviews { get; set; }

    /// <summary>
    /// Breakdown by platform.
    /// </summary>
    public List<PlatformRatingSummary> Platforms { get; set; } = new();

    /// <summary>
    /// Formatted display string (e.g., "4.8★ across 5 platforms").
    /// </summary>
    public string DisplayText => PlatformCount > 0
        ? $"{CombinedRating:F1}★ across {PlatformCount} platform{(PlatformCount > 1 ? "s" : "")}"
        : "No ratings yet";
}

/// <summary>
/// Rating summary for a single platform.
/// </summary>
public class PlatformRatingSummary
{
    public string Platform { get; set; } = string.Empty;
    public decimal Rating { get; set; }
    public int ReviewCount { get; set; }
}

/// <summary>
/// Manual refresh status for a user.
/// </summary>
public class ManualRefreshStatus
{
    public bool IsPro { get; set; }
    public int RefreshIntervalDays { get; set; }
    public DateTime? LastRefresh { get; set; }
    public DateTime NextAvailable { get; set; }
    public bool CanRefreshNow { get; set; }
}

/// <summary>
/// Result of a manual refresh operation.
/// </summary>
public class ManualRefreshResult
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public int ProfilesRefreshed { get; set; }
    public DateTime? NextAvailable { get; set; }
}

/// <summary>
/// Result of dispute evidence pack generation.
/// </summary>
public class DisputeEvidenceResult
{
    public bool Success { get; set; }
    public string? Error { get; set; }
    public string? Message { get; set; }
    public Guid? DocumentId { get; set; }
    public DateTime? GeneratedAt { get; set; }
    public DateTime? ExpiresAt { get; set; }
    public string? VerificationUrl { get; set; }
    public UserEvidenceSummary? UserSummary { get; set; }
    public List<ProfileEvidenceSummary> ProfilesSummary { get; set; } = new();
    public CombinedStarRating? CombinedRating { get; set; }
    public List<TrustScoreHistoryEntry> TrustScoreHistory { get; set; } = new();
    public List<RatingHistoryEntry> RatingHistory { get; set; } = new();
}

/// <summary>
/// User summary for dispute evidence.
/// </summary>
public class UserEvidenceSummary
{
    public Guid UserId { get; set; }
    public string Username { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public DateTime AccountCreatedAt { get; set; }
    public bool IsIdentityVerified { get; set; }
    public DateTime? IdentityVerifiedAt { get; set; }
    public int CurrentTrustScore { get; set; }
    public string TrustLabel { get; set; } = string.Empty;
}

/// <summary>
/// Profile summary for dispute evidence.
/// </summary>
public class ProfileEvidenceSummary
{
    public string Platform { get; set; } = string.Empty;
    public string? ProfileUrl { get; set; }
    public DateTime? VerifiedAt { get; set; }
    public decimal? Rating { get; set; }
    public int? ReviewCount { get; set; }
    public string? ScreenshotUrl { get; set; }
}

/// <summary>
/// TrustScore history entry for dispute evidence.
/// </summary>
public class TrustScoreHistoryEntry
{
    public int Score { get; set; }
    public DateTime Date { get; set; }
}

/// <summary>
/// Rating history entry for dispute evidence.
/// </summary>
public class RatingHistoryEntry
{
    public string Platform { get; set; } = string.Empty;
    public decimal? PreviousRating { get; set; }
    public decimal? NewRating { get; set; }
    public decimal Change { get; set; }
    public DateTime Date { get; set; }
}
