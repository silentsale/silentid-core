using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Represents a user's subscription to platform watchdog alerts.
/// Pro feature: Platform Watchdog.
/// </summary>
public class WatchdogSubscription
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    /// <summary>
    /// Foreign key to the user.
    /// </summary>
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    /// <summary>
    /// Platform being watched (e.g., "vinted", "ebay", "depop").
    /// </summary>
    [Required]
    [MaxLength(50)]
    public string Platform { get; set; } = string.Empty;

    /// <summary>
    /// When the user subscribed to this watchdog.
    /// </summary>
    public DateTime SubscribedAt { get; set; } = DateTime.UtcNow;

    /// <summary>
    /// Whether notifications are enabled.
    /// </summary>
    public bool NotificationsEnabled { get; set; } = true;

    /// <summary>
    /// Whether email notifications are enabled.
    /// </summary>
    public bool EmailEnabled { get; set; } = true;
}
