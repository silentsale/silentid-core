using Microsoft.AspNetCore.Mvc;

namespace SilentID.Api.Controllers;

/// <summary>
/// Public endpoints for landing page and external integrations
/// These endpoints are accessible without authentication
/// </summary>
[ApiController]
[Route("v1/public")]
public class PublicController : ControllerBase
{
    private readonly ILogger<PublicController> _logger;

    public class LandingStatsDto
    {
        public int TotalUsers { get; set; }
        public int VerifiedUsers { get; set; }
        public int TotalTransactions { get; set; }
        public int AverageTrustScore { get; set; }
        public int PlatformsSupported { get; set; }
    }

    public class TrustScoreExampleDto
    {
        public string DisplayName { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        public int TrustScore { get; set; }
        public string TrustLevel { get; set; } = string.Empty;
        public int BadgeCount { get; set; }
    }

    public PublicController(ILogger<PublicController> logger)
    {
        _logger = logger;
    }

    /// <summary>
    /// GET /v1/public/landing-stats
    /// Returns aggregated statistics for landing page
    /// NOTE: Currently returns static data. Will be connected to database when data is available.
    /// </summary>
    [HttpGet("landing-stats")]
    [ResponseCache(Duration = 300)] // Cache for 5 minutes
    public ActionResult<LandingStatsDto> GetLandingStats()
    {
        _logger.LogInformation("Landing stats requested");

        // TODO: Connect to database when data is available
        // For now, return static showcase data
        var stats = new LandingStatsDto
        {
            TotalUsers = 1247,
            VerifiedUsers = 982,
            TotalTransactions = 5680,
            AverageTrustScore = 754,
            PlatformsSupported = 12
        };

        return Ok(stats);
    }

    /// <summary>
    /// GET /v1/public/trust-examples
    /// Returns anonymized examples of high-trust users for showcase
    /// NOTE: Currently returns static examples. Will be connected to database when data is available.
    /// </summary>
    [HttpGet("trust-examples")]
    [ResponseCache(Duration = 3600)] // Cache for 1 hour
    public ActionResult<List<TrustScoreExampleDto>> GetTrustExamples()
    {
        _logger.LogInformation("Trust examples requested");

        // TODO: Connect to database when data is available
        // For now, return static showcase examples
        var examples = new List<TrustScoreExampleDto>
        {
            new() { DisplayName = "Sarah M.", Username = "@sarahtrusted", TrustScore = 847, TrustLevel = "Very High Trust", BadgeCount = 4 },
            new() { DisplayName = "James K.", Username = "@jamesseller", TrustScore = 756, TrustLevel = "High Trust", BadgeCount = 3 },
            new() { DisplayName = "Emma L.", Username = "@emmaverified", TrustScore = 692, TrustLevel = "High Trust", BadgeCount = 2 }
        };

        return Ok(examples);
    }
}
