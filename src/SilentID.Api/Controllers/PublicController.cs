using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

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
    private readonly SilentIdDbContext _context;

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

    public class PlatformRatingDto
    {
        public string Platform { get; set; } = string.Empty;
        public decimal Rating { get; set; }
        public int ReviewCount { get; set; }
        public string DisplayRating { get; set; } = string.Empty; // e.g., "4.9 ★" or "99.2% positive"
        public DateTime LastUpdated { get; set; }
        public bool IsLevel3Verified { get; set; }
    }

    public class PublicProfileDto
    {
        public string Username { get; set; } = string.Empty;
        public string DisplayName { get; set; } = string.Empty;
        public bool IdentityVerified { get; set; }
        public string AccountAge { get; set; } = string.Empty;
        public List<string> VerifiedPlatforms { get; set; } = new();
        public int VerifiedTransactionCount { get; set; }
        public List<string> Badges { get; set; } = new();
        public string? RiskWarning { get; set; }
        public DateTime CreatedAt { get; set; }
        public List<PlatformRatingDto> PlatformRatings { get; set; } = new();
    }

    public class UsernameAvailabilityDto
    {
        public string Username { get; set; } = string.Empty;
        public bool Available { get; set; }
        public List<string> Suggestions { get; set; } = new();
    }

    public PublicController(ILogger<PublicController> logger, SilentIdDbContext context)
    {
        _logger = logger;
        _context = context;
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

    /// <summary>
    /// GET /v1/public/profile/{username}
    /// Returns public SilentID profile for given username.
    /// NO authentication required - publicly accessible.
    /// PRIVACY-SAFE: Never returns email, phone, address, ID documents, or internal IDs.
    /// </summary>
    [HttpGet("profile/{username}")]
    [ResponseCache(Duration = 60)] // Cache for 1 minute
    public async Task<ActionResult<PublicProfileDto>> GetPublicProfile(string username)
    {
        _logger.LogInformation("Public profile requested for username: {Username}", username);

        // Remove @ prefix if present
        var cleanUsername = username.TrimStart('@');

        // Validate username format
        if (!IsValidUsername(cleanUsername))
        {
            _logger.LogWarning("Invalid username format: {Username}", cleanUsername);
            return BadRequest(new { error = "invalid_username", message = "Invalid username format. Must be 3-30 characters, alphanumeric and underscore only, starting with a letter." });
        }

        // Query user (case-insensitive)
        var user = await _context.Users
            .AsNoTracking()
            .FirstOrDefaultAsync(u => u.Username.ToLower() == cleanUsername.ToLower());

        if (user == null)
        {
            _logger.LogInformation("Username not found: {Username}", cleanUsername);
            return NotFound(new { error = "username_not_found", message = "This username does not exist." });
        }

        // Get identity verification status
        var identityVerification = await _context.IdentityVerifications
            .AsNoTracking()
            .FirstOrDefaultAsync(i => i.UserId == user.Id);

        var identityVerified = identityVerification?.Status == VerificationStatus.Verified;

        // Get verified platforms from ProfileLinkEvidence
        var verifiedPlatforms = await _context.ProfileLinkEvidences
            .AsNoTracking()
            .Where(p => p.UserId == user.Id && p.EvidenceState == EvidenceState.Valid)
            .Select(p => p.Platform.ToString())
            .Distinct()
            .ToListAsync();

        // Count verified transactions (receipts)
        var verifiedTransactionCount = await _context.ReceiptEvidences
            .AsNoTracking()
            .Where(r => r.UserId == user.Id && r.EvidenceState == EvidenceState.Valid)
            .CountAsync();

        // Calculate account age
        var accountAgeDays = (DateTime.UtcNow - user.CreatedAt).Days;
        var accountAge = accountAgeDays == 0 ? "Today" : $"{accountAgeDays} days";

        // Generate badges
        var badges = GenerateBadges(identityVerified, verifiedTransactionCount);

        // Check for verified safety reports (≥3 verified reports = public warning)
        var verifiedReportCount = await _context.Reports
            .AsNoTracking()
            .Where(r => r.ReportedUserId == user.Id && r.Status == ReportStatus.Verified)
            .CountAsync();

        string? riskWarning = null;
        if (verifiedReportCount >= 3)
        {
            // Defamation-safe language (Section 4 of CLAUDE.md)
            riskWarning = "⚠️ Safety concern flagged — multiple verified reports received.";
            _logger.LogInformation("Risk warning displayed for user {Username}: {Count} verified reports", cleanUsername, verifiedReportCount);
        }

        // Get platform ratings from ExternalRatings (Section 47: Digital Trust Passport)
        // Only show non-expired ratings with Level 3 verification status
        var externalRatings = await _context.ExternalRatings
            .AsNoTracking()
            .Where(er => er.UserId == user.Id && er.ExpiresAt > DateTime.UtcNow)
            .ToListAsync();

        // Get Level 3 verification status for each platform
        var profileLinks = await _context.ProfileLinkEvidences
            .AsNoTracking()
            .Where(p => p.UserId == user.Id && p.EvidenceState == EvidenceState.Valid)
            .ToListAsync();

        // Map to PlatformRatingDto with formatted display
        var platformRatings = externalRatings
            .GroupBy(er => er.Platform)
            .Select(g =>
            {
                var latestRating = g.OrderByDescending(r => r.ScrapedAt).First();
                var profileLink = profileLinks.FirstOrDefault(p => p.Platform.ToString() == latestRating.Platform);
                var isLevel3 = profileLink?.VerificationLevel == 3;
                var totalReviews = g.Sum(r => r.ReviewCount);

                // Format display rating based on platform type (Section 47.7)
                string displayRating;
                if (latestRating.Platform.ToLower() == "ebay")
                {
                    // eBay uses percentage format
                    displayRating = $"{latestRating.NormalizedRating:F1}% positive";
                }
                else
                {
                    // Most platforms use star format (Vinted, Depop, Etsy)
                    var starRating = (latestRating.PlatformRating / 20m); // Convert 0-100 to 0-5 if needed
                    if (latestRating.PlatformRating <= 5)
                        starRating = latestRating.PlatformRating; // Already in 0-5 scale
                    displayRating = $"{starRating:F1} ★";
                }

                return new PlatformRatingDto
                {
                    Platform = latestRating.Platform,
                    Rating = latestRating.PlatformRating,
                    ReviewCount = totalReviews,
                    DisplayRating = displayRating,
                    LastUpdated = latestRating.ScrapedAt,
                    IsLevel3Verified = isLevel3
                };
            })
            .OrderByDescending(r => r.IsLevel3Verified)
            .ThenByDescending(r => r.ReviewCount)
            .ToList();

        var profile = new PublicProfileDto
        {
            Username = $"@{user.Username}",
            DisplayName = user.DisplayName,
            IdentityVerified = identityVerified,
            AccountAge = accountAge,
            VerifiedPlatforms = verifiedPlatforms,
            VerifiedTransactionCount = verifiedTransactionCount,
            Badges = badges,
            RiskWarning = riskWarning,
            CreatedAt = user.CreatedAt,
            PlatformRatings = platformRatings
        };

        _logger.LogInformation("Public profile returned for {Username}: Verified={Verified}",
            cleanUsername, identityVerified);

        return Ok(profile);
    }

    /// <summary>
    /// GET /v1/public/availability/{username}
    /// Checks if a username is available for registration.
    /// NO authentication required - publicly accessible.
    /// Returns alternative suggestions if username is taken.
    /// </summary>
    [HttpGet("availability/{username}")]
    [ResponseCache(Duration = 30)] // Cache for 30 seconds
    public async Task<ActionResult<UsernameAvailabilityDto>> CheckUsernameAvailability(string username)
    {
        _logger.LogInformation("Username availability check for: {Username}", username);

        // Remove @ prefix if present
        var cleanUsername = username.TrimStart('@');

        // Validate username format
        if (!IsValidUsername(cleanUsername))
        {
            _logger.LogWarning("Invalid username format for availability check: {Username}", cleanUsername);
            return BadRequest(new { error = "invalid_username", message = "Invalid username format. Must be 3-30 characters, alphanumeric and underscore only, starting with a letter." });
        }

        // Check if username exists (case-insensitive)
        var exists = await _context.Users
            .AsNoTracking()
            .AnyAsync(u => u.Username.ToLower() == cleanUsername.ToLower());

        var result = new UsernameAvailabilityDto
        {
            Username = cleanUsername,
            Available = !exists
        };

        // If taken, generate suggestions
        if (exists)
        {
            _logger.LogInformation("Username {Username} is taken, generating suggestions", cleanUsername);
            result.Suggestions = await GenerateUsernameSuggestions(cleanUsername);
        }

        return Ok(result);
    }

    #region Private Helper Methods

    /// <summary>
    /// Validates username format: 3-30 chars, alphanumeric + underscore, starts with letter.
    /// </summary>
    private static bool IsValidUsername(string username)
    {
        if (string.IsNullOrWhiteSpace(username))
            return false;

        if (username.Length < 3 || username.Length > 30)
            return false;

        // Must start with a letter
        if (!char.IsLetter(username[0]))
            return false;

        // Must contain only letters, numbers, and underscores
        foreach (var c in username)
        {
            if (!char.IsLetterOrDigit(c) && c != '_')
                return false;
        }

        return true;
    }

    /// <summary>
    /// Converts TrustScore (0-1000) to human-readable label.
    /// Based on Section 3 of CLAUDE.md.
    /// </summary>
    private static string GetTrustScoreLabel(int score)
    {
        return score switch
        {
            >= 801 and <= 1000 => "Very High Trust",
            >= 601 and < 801 => "High Trust",
            >= 401 and < 601 => "Moderate Trust",
            >= 201 and < 401 => "Low Trust",
            >= 0 and < 201 => "High Risk",
            _ => "Unknown"
        };
    }

    /// <summary>
    /// Generates user-facing badges based on verification status and activity.
    /// </summary>
    private static List<string> GenerateBadges(bool identityVerified, int transactionCount)
    {
        var badges = new List<string>();

        if (identityVerified)
            badges.Add("Identity Verified");

        if (transactionCount >= 500)
            badges.Add("500+ verified transactions");
        else if (transactionCount >= 100)
            badges.Add("100+ verified transactions");
        else if (transactionCount >= 50)
            badges.Add("50+ verified transactions");

        return badges;
    }

    /// <summary>
    /// Generates 3 alternative username suggestions when a username is taken.
    /// Simple algorithm: append numbers, underscore variations.
    /// </summary>
    private async Task<List<string>> GenerateUsernameSuggestions(string baseUsername)
    {
        var suggestions = new List<string>();
        var suffixes = new[] { "2", "3", "_uk", "_pro", "_trusted", "123" };

        foreach (var suffix in suffixes)
        {
            var suggestion = baseUsername + suffix;

            // Check if suggestion is valid and available
            if (IsValidUsername(suggestion))
            {
                var exists = await _context.Users
                    .AsNoTracking()
                    .AnyAsync(u => u.Username.ToLower() == suggestion.ToLower());

                if (!exists)
                {
                    suggestions.Add(suggestion);
                    if (suggestions.Count >= 3)
                        break;
                }
            }
        }

        // If we couldn't find 3 suggestions, add some numeric ones
        if (suggestions.Count < 3)
        {
            for (int i = 10; i < 100 && suggestions.Count < 3; i++)
            {
                var suggestion = baseUsername + i;
                if (IsValidUsername(suggestion))
                {
                    var exists = await _context.Users
                        .AsNoTracking()
                        .AnyAsync(u => u.Username.ToLower() == suggestion.ToLower());

                    if (!exists)
                        suggestions.Add(suggestion);
                }
            }
        }

        return suggestions;
    }

    #endregion
}
