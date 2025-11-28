using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SilentID.Api.Models;

/// <summary>
/// Tracks referral relationships between users (Section 50.6.1)
/// "Invite a friend → both get +50 TrustScore bonus once identity is verified."
/// </summary>
public class Referral
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    /// <summary>
    /// The user who sent the referral (referrer)
    /// </summary>
    [Required]
    public Guid ReferrerId { get; set; }

    [ForeignKey(nameof(ReferrerId))]
    public User? Referrer { get; set; }

    /// <summary>
    /// The user who was referred (referee) - null until they sign up
    /// </summary>
    public Guid? RefereeId { get; set; }

    [ForeignKey(nameof(RefereeId))]
    public User? Referee { get; set; }

    /// <summary>
    /// Email address the referral was sent to (before signup)
    /// </summary>
    [EmailAddress]
    [StringLength(255)]
    public string? InvitedEmail { get; set; }

    /// <summary>
    /// The referral code used (matches Referrer's ReferralCode)
    /// </summary>
    [Required]
    [StringLength(20)]
    public string ReferralCode { get; set; } = string.Empty;

    /// <summary>
    /// Current status of the referral
    /// </summary>
    public ReferralStatus Status { get; set; } = ReferralStatus.Pending;

    /// <summary>
    /// Points earned by the referrer (awarded when referee verifies identity)
    /// </summary>
    public int ReferrerPointsAwarded { get; set; } = 0;

    /// <summary>
    /// Points earned by the referee (awarded when they verify identity)
    /// </summary>
    public int RefereePointsAwarded { get; set; } = 0;

    /// <summary>
    /// When the referral link was created/sent
    /// </summary>
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    /// <summary>
    /// When the referee signed up (if they have)
    /// </summary>
    public DateTime? SignedUpAt { get; set; }

    /// <summary>
    /// When the referral was completed (referee verified identity)
    /// </summary>
    public DateTime? CompletedAt { get; set; }

    /// <summary>
    /// When the referral expires (e.g., 30 days after creation)
    /// </summary>
    public DateTime ExpiresAt { get; set; } = DateTime.UtcNow.AddDays(30);
}

public enum ReferralStatus
{
    /// <summary>
    /// Referral link created but referee hasn't signed up yet
    /// </summary>
    Pending = 0,

    /// <summary>
    /// Referee signed up but hasn't verified identity yet
    /// </summary>
    SignedUp = 1,

    /// <summary>
    /// Referee verified identity - both users receive bonus points
    /// </summary>
    Completed = 2,

    /// <summary>
    /// Referral expired before completion
    /// </summary>
    Expired = 3
}
