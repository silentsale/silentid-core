using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Services;

namespace SilentID.Api.Controllers;

/// <summary>
/// Platform configuration endpoints for marketplace profile verification.
/// See CLAUDE.md Section 48 - Modular Platform Configuration System.
/// </summary>
[ApiController]
[Route("v1/platforms")]
public class PlatformController : ControllerBase
{
    private readonly IPlatformConfigurationService _platformService;
    private readonly ILogger<PlatformController> _logger;

    public PlatformController(
        IPlatformConfigurationService platformService,
        ILogger<PlatformController> logger)
    {
        _platformService = platformService;
        _logger = logger;
    }

    /// <summary>
    /// Get all active platforms available for profile linking.
    /// </summary>
    [HttpGet]
    [AllowAnonymous]
    public async Task<IActionResult> GetActivePlatforms()
    {
        var platforms = await _platformService.GetActivePlatformsAsync();

        var response = platforms.Select(p => new
        {
            platformId = p.PlatformId,
            displayName = p.DisplayName,
            domain = p.Domain,
            logoUrl = p.LogoUrl,
            brandColor = p.BrandColor,
            ratingFormat = p.RatingFormat.ToString().ToLower(),
            ratingMax = p.RatingMax
        });

        return Ok(new { platforms = response });
    }

    /// <summary>
    /// Match a URL to a platform and extract the username.
    /// Used by Flutter app when user pastes/shares a profile URL.
    /// </summary>
    [HttpPost("match")]
    [Authorize]
    public async Task<IActionResult> MatchUrl([FromBody] MatchUrlRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Url))
            return BadRequest(new { error = "URL is required" });

        var result = await _platformService.MatchUrlAsync(request.Url);

        if (result == null)
        {
            return Ok(new
            {
                matched = false,
                message = "URL does not match any supported platform"
            });
        }

        var verificationMethods = await _platformService.GetVerificationMethodsAsync(result.Platform.PlatformId);

        return Ok(new
        {
            matched = true,
            platform = new
            {
                platformId = result.Platform.PlatformId,
                displayName = result.Platform.DisplayName,
                domain = result.Platform.Domain,
                logoUrl = result.Platform.LogoUrl,
                brandColor = result.Platform.BrandColor
            },
            extractedUsername = result.ExtractedUsername,
            normalizedUrl = result.NormalizedUrl,
            verificationMethods = verificationMethods
        });
    }

    /// <summary>
    /// Match a share intent URI to a platform.
    /// Used when user shares directly from marketplace app.
    /// </summary>
    [HttpPost("match-intent")]
    [Authorize]
    public async Task<IActionResult> MatchShareIntent([FromBody] MatchIntentRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.IntentUri))
            return BadRequest(new { error = "Intent URI is required" });

        var result = await _platformService.MatchShareIntentAsync(request.IntentUri);

        if (result == null)
        {
            return Ok(new
            {
                matched = false,
                message = "Intent URI does not match any supported platform"
            });
        }

        var verificationMethods = await _platformService.GetVerificationMethodsAsync(result.Platform.PlatformId);

        return Ok(new
        {
            matched = true,
            platform = new
            {
                platformId = result.Platform.PlatformId,
                displayName = result.Platform.DisplayName,
                domain = result.Platform.Domain,
                logoUrl = result.Platform.LogoUrl,
                brandColor = result.Platform.BrandColor
            },
            extractedUsername = result.ExtractedUsername,
            verificationMethods = verificationMethods
        });
    }

    /// <summary>
    /// Get verification methods for a specific platform.
    /// Returns ordered list: ShareIntent first, TokenInBio second (if available).
    /// </summary>
    [HttpGet("{platformId}/verification-methods")]
    [AllowAnonymous]
    public async Task<IActionResult> GetVerificationMethods(string platformId)
    {
        var platform = await _platformService.GetByPlatformIdAsync(platformId);

        if (platform == null)
            return NotFound(new { error = "Platform not found" });

        var methods = await _platformService.GetVerificationMethodsAsync(platformId);

        return Ok(new
        {
            platformId = platform.PlatformId,
            displayName = platform.DisplayName,
            verificationMethods = methods,
            supportsTokenInBio = methods.Contains("TokenInBio")
        });
    }
}

public class MatchUrlRequest
{
    public string Url { get; set; } = string.Empty;
}

public class MatchIntentRequest
{
    public string IntentUri { get; set; } = string.Empty;
}
