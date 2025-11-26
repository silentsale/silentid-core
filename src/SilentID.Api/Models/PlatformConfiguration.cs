using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Stores platform-specific configuration for marketplace profile verification.
/// Enables modular, configuration-driven scraping instead of hardcoded selectors.
/// See CLAUDE.md Section 48 - Modular Platform Configuration System.
/// </summary>
public class PlatformConfiguration
{
    [Key]
    public Guid Id { get; set; }

    /// <summary>
    /// Unique platform identifier (e.g., "vinted-uk", "ebay-us", "depop").
    /// </summary>
    [Required]
    [MaxLength(50)]
    public string PlatformId { get; set; } = string.Empty;

    /// <summary>
    /// Display name for UI (e.g., "Vinted UK", "eBay US").
    /// </summary>
    [Required]
    [MaxLength(100)]
    public string DisplayName { get; set; } = string.Empty;

    /// <summary>
    /// Primary domain for this platform (e.g., "vinted.co.uk", "ebay.com").
    /// </summary>
    [Required]
    [MaxLength(255)]
    public string Domain { get; set; } = string.Empty;

    /// <summary>
    /// Logo URL for display in UI.
    /// </summary>
    [MaxLength(500)]
    public string? LogoUrl { get; set; }

    /// <summary>
    /// Platform brand color (hex code, e.g., "#09B1BA" for Vinted).
    /// </summary>
    [MaxLength(10)]
    public string? BrandColor { get; set; }

    /// <summary>
    /// Current status of this platform configuration.
    /// </summary>
    public PlatformStatus Status { get; set; } = PlatformStatus.Active;

    /// <summary>
    /// Rating extraction method: API, ScreenshotPlusHtml, or Unsupported.
    /// </summary>
    public RatingSourceMode RatingSourceMode { get; set; } = RatingSourceMode.ScreenshotPlusHtml;

    // ========== URL MATCHING ==========

    /// <summary>
    /// Regex patterns for matching profile URLs (JSON array).
    /// Example: ["https?://(?:www\\.)?vinted\\.co\\.uk/member/([^/]+)"]
    /// </summary>
    public string? UrlPatternsJson { get; set; }

    /// <summary>
    /// Deep link patterns for Share-Intent verification (JSON array).
    /// Example: ["vinted://profile/([^/]+)"]
    /// </summary>
    public string? ShareIntentPatternsJson { get; set; }

    // ========== VERIFICATION METHODS ==========

    /// <summary>
    /// Supported verification methods (JSON array).
    /// Example: ["ShareIntent", "TokenInBio"]
    /// </summary>
    public string? VerificationMethodsJson { get; set; }

    /// <summary>
    /// CSS selector for bio field (Token-in-Bio verification).
    /// Example: "div.user-bio > p.bio-text"
    /// </summary>
    [MaxLength(500)]
    public string? BioFieldSelector { get; set; }

    /// <summary>
    /// XPath selector for bio field (fallback).
    /// Example: "//div[@class='user-bio']//p[1]"
    /// </summary>
    [MaxLength(500)]
    public string? BioFieldXPath { get; set; }

    // ========== EXTRACTION SELECTORS ==========

    /// <summary>
    /// CSS/XPath selectors for rating extraction (JSON with priority order).
    /// Example: [{"priority":1,"selector":"div.rating-stars > span.score","type":"css"}]
    /// </summary>
    public string? RatingSelectorsJson { get; set; }

    /// <summary>
    /// CSS/XPath selectors for review count extraction (JSON).
    /// </summary>
    public string? ReviewCountSelectorsJson { get; set; }

    /// <summary>
    /// CSS/XPath selectors for username extraction (JSON).
    /// </summary>
    public string? UsernameSelectorsJson { get; set; }

    /// <summary>
    /// CSS/XPath selectors for join date extraction (JSON).
    /// </summary>
    public string? JoinDateSelectorsJson { get; set; }

    // ========== RATING NORMALIZATION ==========

    /// <summary>
    /// Maximum rating value for this platform (e.g., 5.0 for stars, 100 for percentage).
    /// </summary>
    public decimal RatingMax { get; set; } = 5.0m;

    /// <summary>
    /// Rating format: Stars (0-5) or Percentage (0-100).
    /// </summary>
    public RatingFormat RatingFormat { get; set; } = RatingFormat.Stars;

    // ========== API CONFIGURATION (if RatingSourceMode = API) ==========

    /// <summary>
    /// API configuration for platforms with official APIs (JSON).
    /// Example: {"base_url":"https://api.ebay.com/...","auth_type":"oauth"}
    /// </summary>
    public string? ApiConfigJson { get; set; }

    // ========== RATE LIMITING ==========

    /// <summary>
    /// Maximum requests per minute for this platform.
    /// </summary>
    public int RateLimitPerMinute { get; set; } = 10;

    /// <summary>
    /// Backoff strategy when rate limited: Exponential or Fixed.
    /// </summary>
    public BackoffStrategy BackoffStrategy { get; set; } = BackoffStrategy.Exponential;

    // ========== HEALTH MONITORING ==========

    /// <summary>
    /// Average confidence score across extractions (0-100).
    /// </summary>
    public decimal? AvgConfidenceScore { get; set; }

    /// <summary>
    /// Last successful extraction timestamp.
    /// </summary>
    public DateTime? LastExtractionAt { get; set; }

    /// <summary>
    /// Current selector version number (increments on config changes).
    /// </summary>
    public int SelectorVersion { get; set; } = 1;

    // ========== TIMESTAMPS ==========

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}

/// <summary>
/// Platform configuration status.
/// </summary>
public enum PlatformStatus
{
    Active,
    Maintenance,
    Disabled,
    Deprecated
}

/// <summary>
/// How star ratings are extracted from this platform.
/// </summary>
public enum RatingSourceMode
{
    /// <summary>
    /// Platform provides official API (highest confidence: 100%).
    /// </summary>
    Api,

    /// <summary>
    /// Automated screenshot + OCR with HTML validation (confidence: 95%).
    /// </summary>
    ScreenshotPlusHtml,

    /// <summary>
    /// Platform not yet supported for automated extraction.
    /// </summary>
    Unsupported
}

/// <summary>
/// Rating display format for the platform.
/// </summary>
public enum RatingFormat
{
    /// <summary>
    /// Star-based rating (e.g., 4.9 out of 5.0).
    /// </summary>
    Stars,

    /// <summary>
    /// Percentage-based rating (e.g., 99.2% positive).
    /// </summary>
    Percentage
}

/// <summary>
/// Backoff strategy when rate limited.
/// </summary>
public enum BackoffStrategy
{
    /// <summary>
    /// Exponential backoff (1s, 2s, 4s, 8s...).
    /// </summary>
    Exponential,

    /// <summary>
    /// Fixed delay between retries.
    /// </summary>
    Fixed
}
