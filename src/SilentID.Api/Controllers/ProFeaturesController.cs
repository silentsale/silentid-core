using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Services;

namespace SilentID.Api.Controllers;

/// <summary>
/// Pro Features Controller - Endpoints for Pro-only features.
/// - Combined Star Rating
/// - Rating Drop Alerts
/// - Manual Stats Refresh
/// - Custom Passport URL
/// - Trust Timeline (Pro-gated)
/// </summary>
[ApiController]
[Route("v1/pro")]
[Authorize]
public class ProFeaturesController : ControllerBase
{
    private readonly IProFeaturesService _proFeaturesService;
    private readonly ILogger<ProFeaturesController> _logger;

    public ProFeaturesController(
        IProFeaturesService proFeaturesService,
        ILogger<ProFeaturesController> logger)
    {
        _proFeaturesService = proFeaturesService;
        _logger = logger;
    }

    private Guid GetUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            throw new UnauthorizedAccessException("Invalid user ID in token");
        }
        return userId;
    }

    /// <summary>
    /// GET /v1/pro/combined-rating
    /// Get combined star rating across all verified marketplace profiles.
    /// Available to all users, but Pro users get the full breakdown.
    /// </summary>
    [HttpGet("combined-rating")]
    [ProducesResponseType(typeof(CombinedStarRating), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetCombinedRating()
    {
        try
        {
            var userId = GetUserId();
            var rating = await _proFeaturesService.GetCombinedStarRatingAsync(userId);

            return Ok(new
            {
                combinedRating = rating.CombinedRating,
                platformCount = rating.PlatformCount,
                totalReviews = rating.TotalReviews,
                displayText = rating.DisplayText,
                platforms = rating.Platforms.Select(p => new
                {
                    platform = p.Platform,
                    rating = p.Rating,
                    reviewCount = p.ReviewCount
                })
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting combined rating");
            return StatusCode(500, new { error = "internal_error", message = "Failed to get combined rating" });
        }
    }

    /// <summary>
    /// GET /v1/pro/refresh-status
    /// Get manual refresh status for the current user.
    /// </summary>
    [HttpGet("refresh-status")]
    [ProducesResponseType(typeof(ManualRefreshStatus), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetRefreshStatus()
    {
        try
        {
            var userId = GetUserId();
            var status = await _proFeaturesService.GetManualRefreshStatusAsync(userId);

            return Ok(new
            {
                isPro = status.IsPro,
                refreshIntervalDays = status.RefreshIntervalDays,
                lastRefresh = status.LastRefresh,
                nextAvailable = status.NextAvailable,
                canRefreshNow = status.CanRefreshNow
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting refresh status");
            return StatusCode(500, new { error = "internal_error", message = "Failed to get refresh status" });
        }
    }

    /// <summary>
    /// POST /v1/pro/refresh
    /// Perform manual stats refresh.
    /// Pro users: 7-day interval, Free users: 30-day interval.
    /// </summary>
    [HttpPost("refresh")]
    [ProducesResponseType(typeof(ManualRefreshResult), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> PerformManualRefresh()
    {
        try
        {
            var userId = GetUserId();
            var result = await _proFeaturesService.PerformManualRefreshAsync(userId);

            if (!result.Success)
            {
                return BadRequest(new
                {
                    error = "refresh_not_available",
                    message = result.Message,
                    nextAvailable = result.NextAvailable
                });
            }

            return Ok(new
            {
                success = result.Success,
                message = result.Message,
                profilesRefreshed = result.ProfilesRefreshed,
                nextAvailable = result.NextAvailable
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error performing manual refresh");
            return StatusCode(500, new { error = "internal_error", message = "Failed to perform refresh" });
        }
    }

    /// <summary>
    /// GET /v1/pro/rating-history
    /// Get rating change history for Pro users.
    /// </summary>
    [HttpGet("rating-history")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> GetRatingHistory([FromQuery] int days = 90)
    {
        try
        {
            var userId = GetUserId();

            // Pro-only feature
            if (!await _proFeaturesService.IsProUserAsync(userId))
            {
                return StatusCode(403, new
                {
                    error = "pro_required",
                    message = "Rating history is a Pro feature. Upgrade to access your rating change history."
                });
            }

            var history = await _proFeaturesService.GetRatingHistoryAsync(userId, Math.Min(days, 365));

            return Ok(new
            {
                history = history.Select(h => new
                {
                    platform = h.Platform,
                    previousRating = h.PreviousRating,
                    newRating = h.NewRating,
                    change = h.RatingChange,
                    date = h.CreatedAt
                }),
                count = history.Count
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting rating history");
            return StatusCode(500, new { error = "internal_error", message = "Failed to get rating history" });
        }
    }

    /// <summary>
    /// GET /v1/pro/custom-url
    /// Get the user's custom passport URL.
    /// </summary>
    [HttpGet("custom-url")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetCustomUrl()
    {
        try
        {
            var userId = GetUserId();
            var customUrl = await _proFeaturesService.GetCustomPassportUrlAsync(userId);
            var isPro = await _proFeaturesService.IsProUserAsync(userId);

            return Ok(new
            {
                currentUrl = customUrl,
                fullUrl = customUrl != null ? $"silentid.co.uk/{customUrl}" : null,
                canCustomize = isPro
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting custom URL");
            return StatusCode(500, new { error = "internal_error", message = "Failed to get custom URL" });
        }
    }

    /// <summary>
    /// POST /v1/pro/custom-url
    /// Set a custom passport URL (Pro feature).
    /// </summary>
    [HttpPost("custom-url")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> SetCustomUrl([FromBody] SetCustomUrlRequest request)
    {
        try
        {
            var userId = GetUserId();

            if (!await _proFeaturesService.IsProUserAsync(userId))
            {
                return StatusCode(403, new
                {
                    error = "pro_required",
                    message = "Custom passport URLs are a Pro feature. Upgrade to claim your custom URL."
                });
            }

            if (string.IsNullOrWhiteSpace(request.CustomUrl))
            {
                return BadRequest(new
                {
                    error = "invalid_url",
                    message = "Custom URL cannot be empty"
                });
            }

            // Check availability first
            if (!await _proFeaturesService.IsCustomUrlAvailableAsync(request.CustomUrl))
            {
                return BadRequest(new
                {
                    error = "url_taken",
                    message = "This URL is already taken or reserved. Please choose another."
                });
            }

            var success = await _proFeaturesService.SetCustomPassportUrlAsync(userId, request.CustomUrl);

            if (!success)
            {
                return BadRequest(new
                {
                    error = "invalid_url",
                    message = "Invalid URL format. Use 3-30 characters, letters, numbers, and hyphens only."
                });
            }

            return Ok(new
            {
                success = true,
                customUrl = request.CustomUrl.ToLowerInvariant(),
                fullUrl = $"silentid.co.uk/{request.CustomUrl.ToLowerInvariant()}"
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error setting custom URL");
            return StatusCode(500, new { error = "internal_error", message = "Failed to set custom URL" });
        }
    }

    /// <summary>
    /// GET /v1/pro/check-url/{url}
    /// Check if a custom URL is available.
    /// </summary>
    [HttpGet("check-url/{url}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> CheckUrlAvailability(string url)
    {
        try
        {
            var available = await _proFeaturesService.IsCustomUrlAvailableAsync(url);

            return Ok(new
            {
                url = url.ToLowerInvariant(),
                available = available
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error checking URL availability");
            return StatusCode(500, new { error = "internal_error", message = "Failed to check URL availability" });
        }
    }

    /// <summary>
    /// GET /v1/pro/status
    /// Get Pro subscription status and available features.
    /// </summary>
    [HttpGet("status")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetProStatus()
    {
        try
        {
            var userId = GetUserId();
            var isPro = await _proFeaturesService.IsProUserAsync(userId);
            var refreshStatus = await _proFeaturesService.GetManualRefreshStatusAsync(userId);

            return Ok(new
            {
                isPro = isPro,
                features = new
                {
                    unlimitedProfiles = isPro,
                    premiumBadgeWithQr = isPro,
                    combinedStarRating = true, // Available to all, but full breakdown for Pro
                    ratingDropAlerts = isPro,
                    trustTimeline = isPro,
                    disputeEvidencePack = isPro,
                    platformWatchdog = isPro,
                    manualRefreshDays = refreshStatus.RefreshIntervalDays,
                    customPassportUrl = isPro,
                    prioritySupport = isPro
                },
                upgradeUrl = isPro ? null : "/subscriptions/pro"
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting Pro status");
            return StatusCode(500, new { error = "internal_error", message = "Failed to get Pro status" });
        }
    }

    /// <summary>
    /// POST /v1/pro/dispute-evidence
    /// Generate a dispute evidence pack (Pro feature).
    /// Legal-ready PDF containing full reputation history.
    /// </summary>
    [HttpPost("dispute-evidence")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> GenerateDisputeEvidence()
    {
        try
        {
            var userId = GetUserId();
            var result = await _proFeaturesService.GenerateDisputeEvidencePackAsync(userId);

            if (!result.Success)
            {
                return StatusCode(403, new
                {
                    error = result.Error,
                    message = result.Message
                });
            }

            return Ok(new
            {
                success = result.Success,
                documentId = result.DocumentId,
                generatedAt = result.GeneratedAt,
                expiresAt = result.ExpiresAt,
                verificationUrl = result.VerificationUrl,
                user = result.UserSummary != null ? new
                {
                    username = result.UserSummary.Username,
                    accountCreatedAt = result.UserSummary.AccountCreatedAt,
                    isIdentityVerified = result.UserSummary.IsIdentityVerified,
                    currentTrustScore = result.UserSummary.CurrentTrustScore,
                    trustLabel = result.UserSummary.TrustLabel
                } : null,
                profiles = result.ProfilesSummary.Select(p => new
                {
                    platform = p.Platform,
                    profileUrl = p.ProfileUrl,
                    verifiedAt = p.VerifiedAt,
                    rating = p.Rating,
                    reviewCount = p.ReviewCount
                }),
                combinedRating = result.CombinedRating != null ? new
                {
                    rating = result.CombinedRating.CombinedRating,
                    platformCount = result.CombinedRating.PlatformCount,
                    totalReviews = result.CombinedRating.TotalReviews,
                    displayText = result.CombinedRating.DisplayText
                } : null
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error generating dispute evidence");
            return StatusCode(500, new { error = "internal_error", message = "Failed to generate dispute evidence" });
        }
    }

    /// <summary>
    /// GET /v1/pro/watchdog/incidents
    /// Get active platform incidents (Pro feature: Platform Watchdog).
    /// </summary>
    [HttpGet("watchdog/incidents")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetPlatformIncidents()
    {
        try
        {
            var userId = GetUserId();

            // Pro-only feature
            if (!await _proFeaturesService.IsProUserAsync(userId))
            {
                return StatusCode(403, new
                {
                    error = "pro_required",
                    message = "Platform Watchdog is a Pro feature. Upgrade to receive alerts about platform issues."
                });
            }

            var incidents = await _proFeaturesService.GetActivePlatformIncidentsAsync();

            return Ok(new
            {
                incidents = incidents.Select(i => new
                {
                    id = i.Id,
                    platform = i.Platform,
                    incidentType = i.IncidentType,
                    title = i.Title,
                    description = i.Description,
                    severity = i.Severity,
                    isActive = i.IsActive,
                    reportedAt = i.ReportedAt,
                    resolvedAt = i.ResolvedAt,
                    sourceUrl = i.SourceUrl,
                    estimatedAffectedUsers = i.EstimatedAffectedUsers,
                    affectedRegions = i.AffectedRegions
                }),
                count = incidents.Count
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting platform incidents");
            return StatusCode(500, new { error = "internal_error", message = "Failed to get platform incidents" });
        }
    }

    /// <summary>
    /// GET /v1/pro/watchdog/subscriptions
    /// Get user's watchdog subscriptions.
    /// </summary>
    [HttpGet("watchdog/subscriptions")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> GetWatchdogSubscriptions()
    {
        try
        {
            var userId = GetUserId();
            var subscriptions = await _proFeaturesService.GetWatchdogSubscriptionsAsync(userId);

            return Ok(new
            {
                platforms = subscriptions,
                count = subscriptions.Count
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting watchdog subscriptions");
            return StatusCode(500, new { error = "internal_error", message = "Failed to get watchdog subscriptions" });
        }
    }

    /// <summary>
    /// POST /v1/pro/watchdog/subscribe
    /// Subscribe to platform watchdog alerts.
    /// </summary>
    [HttpPost("watchdog/subscribe")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status403Forbidden)]
    public async Task<IActionResult> SubscribeToWatchdog([FromBody] WatchdogSubscribeRequest request)
    {
        try
        {
            var userId = GetUserId();

            if (!await _proFeaturesService.IsProUserAsync(userId))
            {
                return StatusCode(403, new
                {
                    error = "pro_required",
                    message = "Platform Watchdog is a Pro feature. Upgrade to subscribe to platform alerts."
                });
            }

            var success = await _proFeaturesService.SubscribeToPlatformWatchdogAsync(userId, request.Platform);

            if (!success)
            {
                return BadRequest(new
                {
                    error = "subscription_failed",
                    message = "Failed to subscribe to platform watchdog."
                });
            }

            return Ok(new
            {
                success = true,
                platform = request.Platform.ToLowerInvariant(),
                message = $"Successfully subscribed to {request.Platform} watchdog alerts."
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error subscribing to watchdog");
            return StatusCode(500, new { error = "internal_error", message = "Failed to subscribe to watchdog" });
        }
    }
}

/// <summary>
/// Request model for setting custom URL.
/// </summary>
public class SetCustomUrlRequest
{
    public string CustomUrl { get; set; } = string.Empty;
}

/// <summary>
/// Request model for watchdog subscription.
/// </summary>
public class WatchdogSubscribeRequest
{
    public string Platform { get; set; } = string.Empty;
}
