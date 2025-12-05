using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Stores historical rating snapshots for tracking changes over time.
/// Used for Pro feature: Rating Drop Alerts.
/// </summary>
public class RatingChangeHistory
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    /// <summary>
    /// Foreign key to the profile link.
    /// </summary>
    public Guid ProfileLinkId { get; set; }
    public ProfileLinkEvidence ProfileLink { get; set; } = null!;

    /// <summary>
    /// Foreign key to the user.
    /// </summary>
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    /// <summary>
    /// Platform name (Vinted, eBay, Depop, etc.).
    /// </summary>
    [Required]
    [MaxLength(50)]
    public string Platform { get; set; } = string.Empty;

    /// <summary>
    /// Previous rating value.
    /// </summary>
    public decimal? PreviousRating { get; set; }

    /// <summary>
    /// New rating value.
    /// </summary>
    public decimal? NewRating { get; set; }

    /// <summary>
    /// Previous review count.
    /// </summary>
    public int? PreviousReviewCount { get; set; }

    /// <summary>
    /// New review count.
    /// </summary>
    public int? NewReviewCount { get; set; }

    /// <summary>
    /// Change in rating (can be negative for drops).
    /// </summary>
    public decimal RatingChange { get; set; }

    /// <summary>
    /// Whether an alert was sent for this change.
    /// </summary>
    public bool AlertSent { get; set; } = false;

    /// <summary>
    /// When the alert was sent.
    /// </summary>
    public DateTime? AlertSentAt { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
