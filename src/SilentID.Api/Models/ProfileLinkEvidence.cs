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

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}
