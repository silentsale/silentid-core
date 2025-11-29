using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

/// <summary>
/// Service for extracting profile data after ownership verification.
/// Implements Section 49.6 (Screenshot + OCR) and Section 49.10 (Manual Screenshot).
///
/// OWNERSHIP-FIRST RULE (Section 49.2):
/// All extraction MUST occur AFTER ownership verification. Never before.
/// </summary>
public interface IExtractionService
{
    /// <summary>
    /// Extract profile data using automated methods (Screenshot + OCR, HTML).
    /// Requires ownership to be verified first.
    /// </summary>
    Task<ExtractionResult> ExtractProfileDataAsync(Guid profileLinkId, Guid userId);

    /// <summary>
    /// Process manual screenshot upload (up to 3 screenshots).
    /// Used as fallback when automated extraction fails.
    /// </summary>
    Task<ExtractionResult> ProcessManualScreenshotAsync(
        Guid profileLinkId,
        Guid userId,
        Stream screenshotStream,
        string fileName);

    /// <summary>
    /// Calculate confidence score based on extraction method and validation results.
    /// </summary>
    int CalculateConfidenceScore(ExtractionMethod method, bool htmlMatch, int screenshotCount);

    /// <summary>
    /// Record user consent for profile extraction.
    /// </summary>
    Task RecordConsentAsync(Guid profileLinkId, Guid userId, string ipAddress);
}

/// <summary>
/// Result of a profile data extraction attempt.
/// </summary>
public class ExtractionResult
{
    public bool Success { get; set; }
    public string? ErrorMessage { get; set; }

    // Extracted data
    public decimal? Rating { get; set; }
    public int? ReviewCount { get; set; }
    public string? Username { get; set; }
    public DateTime? JoinDate { get; set; }

    // Metadata
    public ExtractionMethod Method { get; set; }
    public int ConfidenceScore { get; set; }
    public bool HtmlExtractionMatch { get; set; }
}

/// <summary>
/// Extraction method used (Section 49.11).
/// </summary>
public enum ExtractionMethod
{
    /// <summary>
    /// Official platform API - 100% confidence.
    /// </summary>
    Api,

    /// <summary>
    /// Automated screenshot + OCR - 95% base confidence.
    /// </summary>
    ScreenshotOcr,

    /// <summary>
    /// User-uploaded screenshots - 75% base confidence.
    /// </summary>
    ManualScreenshot
}

public class ExtractionService : IExtractionService
{
    private readonly SilentIdDbContext _dbContext;
    private readonly IPlatformConfigurationService _platformService;
    private readonly IBlobStorageService _blobStorage;
    private readonly IOcrService _ocrService;
    private readonly ILogger<ExtractionService> _logger;

    // Maximum manual screenshots allowed (Section 49.10)
    private const int MaxManualScreenshots = 3;

    public ExtractionService(
        SilentIdDbContext dbContext,
        IPlatformConfigurationService platformService,
        IBlobStorageService blobStorage,
        IOcrService ocrService,
        ILogger<ExtractionService> logger)
    {
        _dbContext = dbContext;
        _platformService = platformService;
        _blobStorage = blobStorage;
        _ocrService = ocrService;
        _logger = logger;
    }

    public async Task<ExtractionResult> ExtractProfileDataAsync(Guid profileLinkId, Guid userId)
    {
        var profileLink = await _dbContext.ProfileLinkEvidences
            .FirstOrDefaultAsync(p => p.Id == profileLinkId && p.UserId == userId);

        if (profileLink == null)
        {
            return new ExtractionResult
            {
                Success = false,
                ErrorMessage = "Profile link not found"
            };
        }

        // OWNERSHIP-FIRST RULE (Section 49.2)
        // Must verify ownership before extraction
        if (profileLink.VerificationLevel < 3 || profileLink.OwnershipLockedAt == null)
        {
            _logger.LogWarning(
                "Extraction attempted before ownership verification for profile {ProfileLinkId}",
                profileLinkId);

            return new ExtractionResult
            {
                Success = false,
                ErrorMessage = "Ownership must be verified before extraction"
            };
        }

        // Check consent was recorded
        if (profileLink.ConsentConfirmedAt == null)
        {
            return new ExtractionResult
            {
                Success = false,
                ErrorMessage = "User consent required before extraction"
            };
        }

        // Get platform configuration for extraction selectors
        var platformMatch = await _platformService.MatchUrlAsync(profileLink.URL);
        if (platformMatch == null)
        {
            return new ExtractionResult
            {
                Success = false,
                ErrorMessage = "Unknown platform - cannot extract data"
            };
        }

        var platform = platformMatch.Platform;

        // Determine extraction method based on platform config
        ExtractionResult result;

        if (platform.RatingSourceMode == RatingSourceMode.Api)
        {
            // API Mode - highest confidence
            result = await ExtractViaApiAsync(profileLink, platform);
        }
        else if (platform.RatingSourceMode == RatingSourceMode.ScreenshotPlusHtml)
        {
            // Screenshot + OCR mode
            result = await ExtractViaScreenshotOcrAsync(profileLink, platform);
        }
        else
        {
            // Unsupported - fall back to manual screenshot
            result = new ExtractionResult
            {
                Success = false,
                ErrorMessage = "Automated extraction not supported for this platform. Please upload screenshots manually.",
                Method = ExtractionMethod.ManualScreenshot
            };
        }

        if (result.Success)
        {
            // Update profile link with extracted data
            profileLink.PlatformRating = result.Rating;
            profileLink.ReviewCount = result.ReviewCount;
            profileLink.ProfileJoinDate = result.JoinDate;
            profileLink.ExtractionMethod = result.Method.ToString();
            profileLink.ExtractionConfidence = result.ConfidenceScore;
            profileLink.ExtractedAt = DateTime.UtcNow;
            profileLink.HtmlExtractionMatch = result.HtmlExtractionMatch;
            profileLink.UpdatedAt = DateTime.UtcNow;

            await _dbContext.SaveChangesAsync();

            _logger.LogInformation(
                "Profile data extracted for {ProfileLinkId}: Rating={Rating}, Reviews={Reviews}, Confidence={Confidence}%",
                profileLinkId, result.Rating, result.ReviewCount, result.ConfidenceScore);
        }

        return result;
    }

    public async Task<ExtractionResult> ProcessManualScreenshotAsync(
        Guid profileLinkId,
        Guid userId,
        Stream screenshotStream,
        string fileName)
    {
        var profileLink = await _dbContext.ProfileLinkEvidences
            .FirstOrDefaultAsync(p => p.Id == profileLinkId && p.UserId == userId);

        if (profileLink == null)
        {
            return new ExtractionResult
            {
                Success = false,
                ErrorMessage = "Profile link not found"
            };
        }

        // Check max screenshots not exceeded
        if (profileLink.ManualScreenshotCount >= MaxManualScreenshots)
        {
            return new ExtractionResult
            {
                Success = false,
                ErrorMessage = $"Maximum {MaxManualScreenshots} screenshots already uploaded"
            };
        }

        // Upload screenshot to blob storage
        var blobName = $"manual-screenshots/{userId}/{profileLinkId}/{Guid.NewGuid()}{Path.GetExtension(fileName)}";
        var blobUrl = await _blobStorage.UploadFileAsync(screenshotStream, blobName, GetContentType(fileName));

        // Update screenshot URLs JSON array
        var existingUrls = string.IsNullOrEmpty(profileLink.ManualScreenshotUrlsJson)
            ? new List<string>()
            : JsonSerializer.Deserialize<List<string>>(profileLink.ManualScreenshotUrlsJson) ?? new List<string>();

        existingUrls.Add(blobUrl);

        profileLink.ManualScreenshotUrlsJson = JsonSerializer.Serialize(existingUrls);
        profileLink.ManualScreenshotCount = existingUrls.Count;
        profileLink.UpdatedAt = DateTime.UtcNow;

        // Get platform for OCR extraction
        var platformMatch = await _platformService.MatchUrlAsync(profileLink.URL);
        var platformId = platformMatch?.Platform.PlatformId ?? "other";

        // Extract profile data using OCR service (Section 49.6)
        ProfileOcrResult? ocrResult = null;
        try
        {
            ocrResult = await _ocrService.ExtractProfileDataAsync(blobUrl, platformId);

            if (ocrResult.Success && ocrResult.OverallConfidence >= 0.7)
            {
                _logger.LogInformation(
                    "OCR extraction successful for screenshot: Rating={Rating}, Reviews={Reviews}, Confidence={Confidence}",
                    ocrResult.Rating, ocrResult.ReviewCount, ocrResult.OverallConfidence);
            }
            else
            {
                _logger.LogWarning(
                    "OCR extraction low confidence ({Confidence}) for profile {ProfileLinkId}",
                    ocrResult.OverallConfidence, profileLinkId);
            }
        }
        catch (Exception ex)
        {
            _logger.LogWarning(ex, "OCR extraction failed for profile {ProfileLinkId}", profileLinkId);
        }

        var confidence = CalculateConfidenceScore(ExtractionMethod.ManualScreenshot, false, existingUrls.Count);

        // Update profile with extracted data if OCR succeeded
        if (ocrResult?.Success == true && ocrResult.OverallConfidence >= 0.7)
        {
            profileLink.PlatformRating = ocrResult.Rating;
            profileLink.ReviewCount = ocrResult.ReviewCount;
            profileLink.ProfileJoinDate = ocrResult.JoinDate;
            profileLink.ExtractedAt = DateTime.UtcNow;
        }

        profileLink.ExtractionMethod = ExtractionMethod.ManualScreenshot.ToString();
        profileLink.ExtractionConfidence = confidence;

        await _dbContext.SaveChangesAsync();

        _logger.LogInformation(
            "Manual screenshot {Count}/{Max} uploaded for profile {ProfileLinkId}",
            existingUrls.Count, MaxManualScreenshots, profileLinkId);

        return new ExtractionResult
        {
            Success = true,
            Rating = ocrResult?.Rating,
            ReviewCount = ocrResult?.ReviewCount,
            JoinDate = ocrResult?.JoinDate,
            Method = ExtractionMethod.ManualScreenshot,
            ConfidenceScore = confidence
        };
    }

    public int CalculateConfidenceScore(ExtractionMethod method, bool htmlMatch, int screenshotCount)
    {
        // Section 49.11 - Confidence levels
        int baseScore = method switch
        {
            ExtractionMethod.Api => 100,
            ExtractionMethod.ScreenshotOcr => 95,
            ExtractionMethod.ManualScreenshot => 75,
            _ => 50
        };

        // Bonuses
        if (method == ExtractionMethod.ScreenshotOcr && htmlMatch)
        {
            baseScore += 5; // OCR and HTML match exactly
        }

        // Manual screenshot bonuses (Section 49.10)
        if (method == ExtractionMethod.ManualScreenshot)
        {
            if (screenshotCount >= 2) baseScore += 5;  // 2+ screenshots
            if (screenshotCount >= 3) baseScore += 5;  // All 3 screenshots
        }

        // Cap at 100
        return Math.Min(baseScore, 100);
    }

    public async Task RecordConsentAsync(Guid profileLinkId, Guid userId, string ipAddress)
    {
        var profileLink = await _dbContext.ProfileLinkEvidences
            .FirstOrDefaultAsync(p => p.Id == profileLinkId && p.UserId == userId);

        if (profileLink == null)
        {
            throw new InvalidOperationException("Profile link not found");
        }

        profileLink.ConsentConfirmedAt = DateTime.UtcNow;
        profileLink.ConsentIpAddress = ipAddress;
        profileLink.UpdatedAt = DateTime.UtcNow;

        await _dbContext.SaveChangesAsync();

        _logger.LogInformation(
            "Consent recorded for profile {ProfileLinkId}, user {UserId}, IP {IP}",
            profileLinkId, userId, ipAddress);
    }

    #region Private Methods

    private async Task<ExtractionResult> ExtractViaApiAsync(ProfileLinkEvidence profileLink, PlatformConfiguration platform)
    {
        // Section 49.11 - Platform API extraction (100% confidence)
        // Currently supports: eBay Commerce API (stub)
        // Future: Depop API, Vinted API (when available)

        _logger.LogInformation(
            "Attempting API extraction for platform {Platform}",
            platform.PlatformId);

        try
        {
            // Match platform by ID pattern (e.g., "ebay-uk", "ebay-us")
            if (platform.PlatformId.StartsWith("ebay", StringComparison.OrdinalIgnoreCase))
            {
                return await ExtractFromEbayApiAsync(profileLink);
            }

            // Add other platforms here as APIs become available

            return new ExtractionResult
            {
                Success = false,
                ErrorMessage = $"API extraction not available for {platform.PlatformId}",
                Method = ExtractionMethod.Api
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "API extraction failed for platform {Platform}", platform.PlatformId);

            return new ExtractionResult
            {
                Success = false,
                ErrorMessage = "API extraction failed. Falling back to screenshot method.",
                Method = ExtractionMethod.Api
            };
        }
    }

    /// <summary>
    /// Extract profile data from eBay Commerce API.
    /// ExternalService: Requires eBay API credentials configuration.
    /// </summary>
    private Task<ExtractionResult> ExtractFromEbayApiAsync(ProfileLinkEvidence profileLink)
    {
        // ExternalService: eBay Commerce API integration
        // Documentation: https://developer.ebay.com/develop/apis/restful-apis/commerce-api
        //
        // Required configuration (appsettings.json / ExternalServices):
        // - EbayApi:ClientId
        // - EbayApi:ClientSecret
        // - EbayApi:Environment (sandbox/production)
        //
        // API endpoints:
        // - GET /sell/account/v1/privilege - Check seller privileges
        // - GET /sell/analytics/v1/seller_standards_profile - Seller performance
        // - GET /sell/fulfillment/v1/order - Order history
        //
        // For MVP, returning not implemented - implement when eBay API credentials configured

        _logger.LogInformation(
            "eBay API extraction stub called for profile {ProfileLinkId}. " +
            "Configure ExternalServices:EbayApi to enable.",
            profileLink.Id);

        return Task.FromResult(new ExtractionResult
        {
            Success = false,
            ErrorMessage = "eBay API not configured. Configure ExternalServices:EbayApi in appsettings.json",
            Method = ExtractionMethod.Api
        });
    }

    private async Task<ExtractionResult> ExtractViaScreenshotOcrAsync(ProfileLinkEvidence profileLink, PlatformConfiguration platform)
    {
        // Section 49.6 - Automated Screenshot + OCR extraction
        // Note: Full automated screenshot capture (via Playwright/Puppeteer) is an ExternalService
        // For now, if we have the profile URL, we can attempt OCR extraction

        _logger.LogInformation(
            "Attempting Screenshot+OCR extraction for platform {Platform}, URL: {Url}",
            platform.PlatformId, profileLink.URL);

        try
        {
            // Use OCR service to extract profile data from the profile URL
            // In production, this would first capture a screenshot using Playwright,
            // then process through Azure Computer Vision
            var ocrResult = await _ocrService.ExtractProfileDataAsync(profileLink.URL, platform.PlatformId);

            if (!ocrResult.Success)
            {
                return new ExtractionResult
                {
                    Success = false,
                    ErrorMessage = ocrResult.ErrorMessage ?? "OCR extraction failed",
                    Method = ExtractionMethod.ScreenshotOcr
                };
            }

            // Validate OCR confidence threshold (70% minimum)
            if (ocrResult.OverallConfidence < 0.7)
            {
                _logger.LogWarning(
                    "OCR confidence too low ({Confidence}) for automated extraction. Falling back to manual screenshots.",
                    ocrResult.OverallConfidence);

                return new ExtractionResult
                {
                    Success = false,
                    ErrorMessage = "Automated extraction confidence too low. Please upload screenshots manually.",
                    Method = ExtractionMethod.ManualScreenshot
                };
            }

            var confidence = CalculateConfidenceScore(ExtractionMethod.ScreenshotOcr, false, 0);

            _logger.LogInformation(
                "Screenshot+OCR extraction successful: Rating={Rating}, Reviews={Reviews}, Confidence={Confidence}%",
                ocrResult.Rating, ocrResult.ReviewCount, confidence);

            return new ExtractionResult
            {
                Success = true,
                Rating = ocrResult.Rating,
                ReviewCount = ocrResult.ReviewCount,
                Username = ocrResult.Username,
                JoinDate = ocrResult.JoinDate,
                Method = ExtractionMethod.ScreenshotOcr,
                ConfidenceScore = confidence,
                HtmlExtractionMatch = false // TODO: Compare with HTML scrape when implemented
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Screenshot+OCR extraction failed for profile {ProfileLinkId}", profileLink.Id);

            return new ExtractionResult
            {
                Success = false,
                ErrorMessage = "Automated extraction failed. Please upload screenshots manually.",
                Method = ExtractionMethod.ScreenshotOcr
            };
        }
    }

    private static string GetContentType(string fileName)
    {
        var ext = Path.GetExtension(fileName).ToLowerInvariant();
        return ext switch
        {
            ".jpg" or ".jpeg" => "image/jpeg",
            ".png" => "image/png",
            ".gif" => "image/gif",
            ".webp" => "image/webp",
            _ => "application/octet-stream"
        };
    }

    #endregion
}
