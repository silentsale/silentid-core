using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SilentID.Api.Models;

/// <summary>
/// In-app notification stored in database
/// Users can view these in the app's notification center
/// </summary>
public class InAppNotification
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    public Guid UserId { get; set; }

    /// <summary>
    /// Notification type for categorization and icons
    /// </summary>
    public NotificationType Type { get; set; }

    /// <summary>
    /// Notification title
    /// </summary>
    [Required]
    [StringLength(200)]
    public string Title { get; set; } = string.Empty;

    /// <summary>
    /// Notification body/message
    /// </summary>
    [Required]
    [StringLength(1000)]
    public string Body { get; set; } = string.Empty;

    /// <summary>
    /// Optional deep link URL for navigation
    /// </summary>
    [StringLength(500)]
    public string? ActionUrl { get; set; }

    /// <summary>
    /// Whether the notification has been read
    /// </summary>
    public bool IsRead { get; set; } = false;

    /// <summary>
    /// When the notification was read
    /// </summary>
    public DateTime? ReadAt { get; set; }

    /// <summary>
    /// When the notification was created
    /// </summary>
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation property
    [ForeignKey(nameof(UserId))]
    public User User { get; set; } = null!;
}

/// <summary>
/// Notification types for categorization
/// </summary>
public enum NotificationType
{
    TrustScoreUpdate,       // Weekly TrustScore regeneration
    EvidenceVerified,       // Evidence was verified
    NewLoginDetected,       // Login from new device
    SecurityAlert,          // Security-related notification
    AchievementUnlocked,    // Gamification milestone
    ReferralBonus,          // Referral completed
    SubscriptionReminder,   // Subscription expiring
    ProfileViewed,          // Someone viewed your Trust Passport
    SystemAnnouncement      // General announcements
}
