using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;
using Stripe;
using Stripe.Checkout;

namespace SilentID.Api.Services;

/// <summary>
/// Manages user subscriptions with Stripe Billing integration.
/// Handles Free → Premium/Pro upgrades and subscription lifecycle.
/// </summary>
public class SubscriptionService : ISubscriptionService
{
    private readonly SilentIdDbContext _context;
    private readonly IConfiguration _configuration;
    private readonly ILogger<SubscriptionService> _logger;

    // Stripe Price IDs (configured in appsettings or environment variables)
    private readonly string _premiumPriceId;
    private readonly string _proPriceId;

    public SubscriptionService(
        SilentIdDbContext context,
        IConfiguration configuration,
        ILogger<SubscriptionService> logger)
    {
        _context = context;
        _configuration = configuration;
        _logger = logger;

        // Initialize Stripe API key
        StripeConfiguration.ApiKey = _configuration["Stripe:SecretKey"]
            ?? throw new InvalidOperationException("Stripe:SecretKey not configured");

        // Load Price IDs from configuration
        _premiumPriceId = _configuration["Stripe:PremiumPriceId"]
            ?? throw new InvalidOperationException("Stripe:PremiumPriceId not configured");
        _proPriceId = _configuration["Stripe:ProPriceId"]
            ?? throw new InvalidOperationException("Stripe:ProPriceId not configured");
    }

    public async Task<Models.Subscription?> GetUserSubscriptionAsync(Guid userId)
    {
        return await _context.Subscriptions
            .AsNoTracking()
            .FirstOrDefaultAsync(s => s.UserId == userId);
    }

    public async Task<Models.Subscription> UpgradeSubscriptionAsync(
        Guid userId,
        SubscriptionTier tier,
        string paymentMethodId)
    {
        if (tier == SubscriptionTier.Free)
        {
            throw new ArgumentException("Cannot upgrade to Free tier");
        }

        // Get or create user
        var user = await _context.Users.FindAsync(userId)
            ?? throw new InvalidOperationException("User not found");

        // Get or create subscription record
        var subscription = await _context.Subscriptions
            .FirstOrDefaultAsync(s => s.UserId == userId);

        if (subscription == null)
        {
            subscription = new Models.Subscription
            {
                Id = Guid.NewGuid(),
                UserId = userId,
                Tier = SubscriptionTier.Free,
                Status = SubscriptionStatus.Active,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };
            _context.Subscriptions.Add(subscription);
        }

        // Create or retrieve Stripe customer
        var customerId = subscription.StripeCustomerId;
        if (string.IsNullOrEmpty(customerId))
        {
            var customerService = new CustomerService();
            var customer = await customerService.CreateAsync(new CustomerCreateOptions
            {
                Email = user.Email,
                PaymentMethod = paymentMethodId,
                InvoiceSettings = new CustomerInvoiceSettingsOptions
                {
                    DefaultPaymentMethod = paymentMethodId
                },
                Metadata = new Dictionary<string, string>
                {
                    { "user_id", userId.ToString() },
                    { "username", user.Username }
                }
            });

            customerId = customer.Id;
            subscription.StripeCustomerId = customerId;
        }
        else
        {
            // Attach payment method to existing customer
            var paymentMethodService = new PaymentMethodService();
            await paymentMethodService.AttachAsync(paymentMethodId, new PaymentMethodAttachOptions
            {
                Customer = customerId
            });

            // Set as default payment method
            var customerService = new CustomerService();
            await customerService.UpdateAsync(customerId, new CustomerUpdateOptions
            {
                InvoiceSettings = new CustomerInvoiceSettingsOptions
                {
                    DefaultPaymentMethod = paymentMethodId
                }
            });
        }

        // Create Stripe subscription
        var priceId = tier == SubscriptionTier.Premium ? _premiumPriceId : _proPriceId;
        var subscriptionService = new Stripe.SubscriptionService();

        // Cancel existing Stripe subscription if upgrading/downgrading
        if (!string.IsNullOrEmpty(subscription.StripeSubscriptionId))
        {
            await subscriptionService.CancelAsync(subscription.StripeSubscriptionId);
        }

        // Create new subscription
        var stripeSubscription = await subscriptionService.CreateAsync(new SubscriptionCreateOptions
        {
            Customer = customerId,
            Items = new List<SubscriptionItemOptions>
            {
                new SubscriptionItemOptions { Price = priceId }
            },
            PaymentBehavior = "default_incomplete",
            Expand = new List<string> { "latest_invoice.payment_intent" },
            Metadata = new Dictionary<string, string>
            {
                { "user_id", userId.ToString() },
                { "tier", tier.ToString() }
            }
        });

        // Update local subscription record
        subscription.Tier = tier;
        subscription.StripeSubscriptionId = stripeSubscription.Id;
        subscription.Status = stripeSubscription.Status == "active"
            ? SubscriptionStatus.Active
            : SubscriptionStatus.PastDue;
        subscription.RenewalDate = DateTime.UtcNow.AddMonths(1); // Will be synced from Stripe webhook
        subscription.CancelAt = null; // Clear cancellation if re-subscribing
        subscription.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        _logger.LogInformation(
            "User {UserId} upgraded to {Tier}. Stripe subscription: {StripeSubscriptionId}",
            userId, tier, stripeSubscription.Id);

        return subscription;
    }

    public async Task<Models.Subscription> CancelSubscriptionAsync(Guid userId)
    {
        var subscription = await _context.Subscriptions
            .FirstOrDefaultAsync(s => s.UserId == userId)
            ?? throw new InvalidOperationException("No subscription found for user");

        if (subscription.Tier == SubscriptionTier.Free)
        {
            throw new InvalidOperationException("Cannot cancel Free tier");
        }

        if (string.IsNullOrEmpty(subscription.StripeSubscriptionId))
        {
            throw new InvalidOperationException("No active Stripe subscription found");
        }

        // Cancel Stripe subscription at period end (not immediately)
        var subscriptionService = new Stripe.SubscriptionService();
        var stripeSubscription = await subscriptionService.UpdateAsync(
            subscription.StripeSubscriptionId,
            new SubscriptionUpdateOptions
            {
                CancelAtPeriodEnd = true
            });

        // Update local record
        subscription.Status = SubscriptionStatus.Cancelled;
        subscription.CancelAt = DateTime.UtcNow.AddMonths(1); // Will be synced from Stripe webhook
        subscription.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        _logger.LogInformation(
            "User {UserId} cancelled subscription. Access until {CancelAt}",
            userId, subscription.CancelAt);

        return subscription;
    }

    public async Task<Models.Subscription> SyncSubscriptionFromStripeAsync(string stripeSubscriptionId)
    {
        // Retrieve subscription from Stripe
        var subscriptionService = new Stripe.SubscriptionService();
        var stripeSubscription = await subscriptionService.GetAsync(stripeSubscriptionId);

        // Find local subscription by Stripe ID
        var subscription = await _context.Subscriptions
            .FirstOrDefaultAsync(s => s.StripeSubscriptionId == stripeSubscriptionId)
            ?? throw new InvalidOperationException($"Subscription {stripeSubscriptionId} not found in database");

        // Sync status from Stripe
        subscription.Status = stripeSubscription.Status switch
        {
            "active" => SubscriptionStatus.Active,
            "canceled" => SubscriptionStatus.Cancelled,
            "past_due" => SubscriptionStatus.PastDue,
            "unpaid" => SubscriptionStatus.Expired,
            _ => SubscriptionStatus.Expired
        };

        subscription.RenewalDate = DateTime.UtcNow.AddMonths(1); // Will be synced from Stripe webhook
        subscription.UpdatedAt = DateTime.UtcNow;

        // If subscription cancelled or expired, downgrade to Free
        if (subscription.Status == SubscriptionStatus.Cancelled ||
            subscription.Status == SubscriptionStatus.Expired)
        {
            subscription.Tier = SubscriptionTier.Free;
            _logger.LogWarning(
                "Subscription {StripeSubscriptionId} downgraded to Free due to status: {Status}",
                stripeSubscriptionId, subscription.Status);
        }

        await _context.SaveChangesAsync();

        return subscription;
    }
}
