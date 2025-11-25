using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Stores normalized star ratings from Level 3 verified external marketplace profiles.
/// Used to calculate URS (Universal Reputation Score) component of TrustScore.
/// </summary>
public class ExternalRating
{
    [Key]
    public Guid Id { get; set; }

    /// <summary>
    /// Foreign key to the verified ProfileLinkEvidence.
    /// </summary>
    public Guid ProfileLinkId { get; set; }
    public ProfileLinkEvidence ProfileLink { get; set; } = null!;

    /// <summary>
    /// Foreign key to the user who owns this rating.
    /// </summary>
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    /// <summary>
    /// Platform where this rating was scraped from (Vinted, eBay, Depop, Etsy).
    /// </summary>
    [Required]
    [MaxLength(50)]
    public string Platform { get; set; } = string.Empty;

    /// <summary>
    /// Raw rating from the platform (e.g., 4.8 out of 5.0).
    /// </summary>
    public decimal PlatformRating { get; set; }

    /// <summary>
    /// Number of reviews/ratings the user has received on this platform.
    /// </summary>
    public int ReviewCount { get; set; }

    /// <summary>
    /// Platform account age in days.
    /// </summary>
    public int AccountAge { get; set; }

    /// <summary>
    /// Rating normalized to 0-100 scale.
    /// </summary>
    public decimal NormalizedRating { get; set; }

    /// <summary>
    /// Weight based on review count (0.5-1.5).
    /// </summary>
    public decimal ReviewCountWeight { get; set; }

    /// <summary>
    /// Weight based on account age (0.5-1.5).
    /// </summary>
    public decimal AccountAgeWeight { get; set; }

    /// <summary>
    /// Average of review count and account age weights.
    /// </summary>
    public decimal CombinedWeight { get; set; }

    /// <summary>
    /// Normalized rating × combined weight.
    /// </summary>
    public decimal WeightedScore { get; set; }

    /// <summary>
    /// When this rating was scraped from the platform.
    /// </summary>
    public DateTime ScrapedAt { get; set; }

    /// <summary>
    /// 180 days from scrape - when rating becomes stale and should be re-scraped.
    /// </summary>
    public DateTime ExpiresAt { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
