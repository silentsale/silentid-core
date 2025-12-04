using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// User subscription to Pro tier (Stripe Billing).
/// v2.0: Simplified to Free + Pro only. Premium tier removed.
/// </summary>
public class Subscription
{
    [Key]
    public Guid Id { get; set; }

    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    /// <summary>
    /// Subscription tier.
    /// </summary>
    public SubscriptionTier Tier { get; set; } = SubscriptionTier.Free;

    /// <summary>
    /// Stripe subscription ID (if paid tier).
    /// </summary>
    [MaxLength(255)]
    public string? StripeSubscriptionId { get; set; }

    /// <summary>
    /// Stripe customer ID.
    /// </summary>
    [MaxLength(255)]
    public string? StripeCustomerId { get; set; }

    /// <summary>
    /// Subscription status.
    /// </summary>
    public SubscriptionStatus Status { get; set; } = SubscriptionStatus.Active;

    /// <summary>
    /// Next renewal date (for active subscriptions).
    /// </summary>
    public DateTime? RenewalDate { get; set; }

    /// <summary>
    /// Cancellation date (if user cancelled but still has access until period end).
    /// </summary>
    public DateTime? CancelAt { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}

/// <summary>
/// v2.0: Simplified to Free + Pro only
/// </summary>
public enum SubscriptionTier
{
    Free,
    [Obsolete("Premium tier removed in v2.0. Use Pro instead.")]
    Premium,
    Pro
}

public enum SubscriptionStatus
{
    Active,
    Cancelled,
    PastDue,
    Expired
}
