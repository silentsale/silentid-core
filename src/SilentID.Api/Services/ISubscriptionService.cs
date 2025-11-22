using SilentID.Api.Models;

namespace SilentID.Api.Services;

/// <summary>
/// Service for managing user subscriptions (Free, Premium, Pro) and Stripe Billing integration.
/// </summary>
public interface ISubscriptionService
{
    /// <summary>
    /// Get the current user's subscription details.
    /// </summary>
    /// <param name="userId">User ID</param>
    /// <returns>Subscription or null if no subscription exists</returns>
    Task<Subscription?> GetUserSubscriptionAsync(Guid userId);

    /// <summary>
    /// Upgrade user to Premium or Pro tier.
    /// Creates Stripe customer and subscription if needed.
    /// </summary>
    /// <param name="userId">User ID</param>
    /// <param name="tier">Target tier (Premium or Pro)</param>
    /// <param name="paymentMethodId">Stripe payment method ID</param>
    /// <returns>Updated subscription</returns>
    Task<Subscription> UpgradeSubscriptionAsync(Guid userId, SubscriptionTier tier, string paymentMethodId);

    /// <summary>
    /// Cancel user's subscription.
    /// User retains access until current billing period ends.
    /// </summary>
    /// <param name="userId">User ID</param>
    /// <returns>Updated subscription with CancelAt date set</returns>
    Task<Subscription> CancelSubscriptionAsync(Guid userId);

    /// <summary>
    /// Sync subscription status from Stripe webhook events.
    /// Called by Stripe webhooks to update subscription status.
    /// </summary>
    /// <param name="stripeSubscriptionId">Stripe subscription ID</param>
    /// <returns>Updated subscription</returns>
    Task<Subscription> SyncSubscriptionFromStripeAsync(string stripeSubscriptionId);
}
