using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SilentID.Api.Models;

/// <summary>
/// Stores device push notification tokens per Section 50.2.1
/// Supports both FCM (Android) and APNS (iOS)
/// </summary>
public class PushNotificationToken
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    public Guid UserId { get; set; }

    /// <summary>
    /// The device's push token (FCM token or APNS device token)
    /// </summary>
    [Required]
    [StringLength(500)]
    public string Token { get; set; } = string.Empty;

    /// <summary>
    /// Platform: ios, android
    /// </summary>
    [Required]
    [StringLength(20)]
    public string Platform { get; set; } = string.Empty;

    /// <summary>
    /// Device identifier to prevent duplicate tokens
    /// </summary>
    [Required]
    [StringLength(200)]
    public string DeviceId { get; set; } = string.Empty;

    /// <summary>
    /// Whether this token is still active/valid
    /// </summary>
    public bool IsActive { get; set; } = true;

    /// <summary>
    /// Last time a notification was successfully sent to this token
    /// </summary>
    public DateTime? LastUsedAt { get; set; }

    /// <summary>
    /// Number of consecutive failures (for cleanup)
    /// </summary>
    public int FailureCount { get; set; } = 0;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

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
