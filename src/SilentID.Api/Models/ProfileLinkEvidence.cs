using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Stores evidence from public profile URLs (Vinted, eBay, Depop, etc.).
/// Scraped data includes ratings, review count, join date, listing patterns.
/// </summary>
public class ProfileLinkEvidence
{
    [Key]
    public Guid Id { get; set; }

    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    /// <summary>
    /// Public profile URL provided by user.
    /// </summary>
    [Required]
    [MaxLength(1000)]
    public string URL { get; set; } = string.Empty;

    /// <summary>
    /// Platform this profile is from.
    /// </summary>
    public Platform Platform { get; set; }

    // ========== SECTION 52 FIELDS ==========

    /// <summary>
    /// Extracted username from the profile URL (e.g., @shopname, /in/username).
    /// </summary>
    [MaxLength(200)]
    public string? Username { get; set; }

    /// <summary>
    /// Whether this profile should be shown on the public passport.
    /// Defaults to true - user can toggle off for privacy.
    /// </summary>
    public bool ShowOnPassport { get; set; } = true;

    /// <summary>
    /// Profile link state: "Linked" (user-added) or "Verified" (ownership confirmed).
    /// Per Section 52.4.
    /// </summary>
    [MaxLength(20)]
    public string LinkState { get; set; } = "Linked";

    /// <summary>
    /// Scraped data stored as JSON (rating, reviews, join date, username, etc.).
    /// </summary>
    public string? ScrapeDataJson { get; set; }

    /// <summary>
    /// Username similarity score (0-100) comparing scraped username to SilentID username.
    /// </summary>
    public int UsernameMatchScore { get; set; } = 0;

    /// <summary>
    /// Integrity score (0-100) based on profile age, activity patterns, consistency.
    /// </summary>
    public int IntegrityScore { get; set; } = 100;

    /// <summary>
    /// Evidence state (Valid, Suspicious, Rejected).
    /// </summary>
    public EvidenceState EvidenceState { get; set; } = EvidenceState.Valid;

    // ========== LEVEL 3 VERIFICATION FIELDS (Section 47.3) ==========

    /// <summary>
    /// Verification level: 1 = URL only, 2 = Username match, 3 = Token-in-Bio/Share-Intent verified.
    /// </summary>
    public int VerificationLevel { get; set; } = 1;

    /// <summary>
    /// Verification method used (TokenInBio, ShareIntent, or null if not Level 3).
    /// </summary>
    [MaxLength(50)]
    public string? VerificationMethod { get; set; }

    /// <summary>
    /// Generated verification token for Token-in-Bio method (e.g., SILENTID-VERIFY-abc123xy).
    /// </summary>
    [MaxLength(100)]
    public string? VerificationToken { get; set; }

    /// <summary>
    /// Timestamp when ownership was locked to this SilentID user (prevents duplicate claims).
    /// </summary>
    public DateTime? OwnershipLockedAt { get; set; }

    /// <summary>
    /// SHA-256 hash of profile snapshot at verification time (for tamper detection).
    /// </summary>
    [MaxLength(64)]
    public string? SnapshotHash { get; set; }

    /// <summary>
    /// 90 days from verification - when re-verification is required.
    /// </summary>
    public DateTime? NextReverifyAt { get; set; }

    // ========== EXTRACTION FIELDS (Section 49.6) ==========

    /// <summary>
    /// Extracted star rating from marketplace profile (e.g., 4.9 for Vinted).
    /// </summary>
    public decimal? PlatformRating { get; set; }

    /// <summary>
    /// Number of reviews/ratings on the marketplace profile.
    /// </summary>
    public int? ReviewCount { get; set; }

    /// <summary>
    /// Join/member since date extracted from profile.
    /// </summary>
    public DateTime? ProfileJoinDate { get; set; }

    /// <summary>
    /// Extraction method used: API, ScreenshotOCR, ManualScreenshot.
    /// </summary>
    [MaxLength(50)]
    public string? ExtractionMethod { get; set; }

    /// <summary>
    /// Confidence score for extraction (0-100).
    /// API=100%, ScreenshotOCR=95%, ManualScreenshot=75% base.
    /// </summary>
    public int? ExtractionConfidence { get; set; }

    /// <summary>
    /// When extraction was last performed.
    /// </summary>
    public DateTime? ExtractedAt { get; set; }

    /// <summary>
    /// True if HTML extraction matches OCR extraction.
    /// </summary>
    public bool? HtmlExtractionMatch { get; set; }

    // ========== CONSENT FIELDS (Section 49.2) ==========

    /// <summary>
    /// Timestamp when user confirmed "This is my profile".
    /// </summary>
    public DateTime? ConsentConfirmedAt { get; set; }

    /// <summary>
    /// IP address where consent was given.
    /// </summary>
    [MaxLength(50)]
    public string? ConsentIpAddress { get; set; }

    // ========== MANUAL SCREENSHOT FIELDS (Section 49.10) ==========

    /// <summary>
    /// Number of manual screenshots uploaded (max 3).
    /// </summary>
    public int ManualScreenshotCount { get; set; } = 0;

    /// <summary>
    /// URLs of manual screenshots in Azure Blob Storage (JSON array).
    /// </summary>
    public string? ManualScreenshotUrlsJson { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}
