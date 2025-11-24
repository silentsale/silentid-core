using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Models;
using SilentID.Api.Services;
using System.Security.Claims;

namespace SilentID.Api.Controllers;

/// <summary>
/// Subscription management endpoints for Premium and Pro tiers.
/// </summary>
[ApiController]
[Route("v1/subscriptions")]
[Authorize]
public class SubscriptionsController : ControllerBase
{
    private readonly ISubscriptionService _subscriptionService;
    private readonly ILogger<SubscriptionsController> _logger;

    public SubscriptionsController(
        ISubscriptionService subscriptionService,
        ILogger<SubscriptionsController> logger)
    {
        _subscriptionService = subscriptionService;
        _logger = logger;
    }

    /// <summary>
    /// GET /v1/subscriptions/me
    /// Get current user's subscription details.
    /// </summary>
    [HttpGet("me")]
    [ProducesResponseType(typeof(SubscriptionResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetMySubscription()
    {
        var userId = GetUserId();

        var subscription = await _subscriptionService.GetUserSubscriptionAsync(userId);

        if (subscription == null)
        {
            return NotFound(new
            {
                error = "no_subscription",
                message = "No subscription found for this user"
            });
        }

        return Ok(new SubscriptionResponse
        {
            Tier = subscription.Tier.ToString(),
            Status = subscription.Status.ToString(),
            RenewalDate = subscription.RenewalDate,
            CancelAt = subscription.CancelAt,
            CreatedAt = subscription.CreatedAt
        });
    }

    /// <summary>
    /// POST /v1/subscriptions/upgrade
    /// Upgrade to Premium or Pro tier.
    /// Requires Stripe payment method ID.
    /// </summary>
    [HttpPost("upgrade")]
    [ProducesResponseType(typeof(SubscriptionResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> UpgradeSubscription([FromBody] UpgradeRequest request)
    {
        var userId = GetUserId();

        if (!Enum.TryParse<SubscriptionTier>(request.Tier, ignoreCase: true, out var tier))
        {
            return BadRequest(new
            {
                error = "invalid_tier",
                message = "Tier must be 'Premium' or 'Pro'"
            });
        }

        if (tier == SubscriptionTier.Free)
        {
            return BadRequest(new
            {
                error = "invalid_tier",
                message = "Cannot upgrade to Free tier"
            });
        }

        if (string.IsNullOrWhiteSpace(request.PaymentMethodId))
        {
            return BadRequest(new
            {
                error = "missing_payment_method",
                message = "Payment method ID is required"
            });
        }

        try
        {
            var subscription = await _subscriptionService.UpgradeSubscriptionAsync(
                userId,
                tier,
                request.PaymentMethodId);

            return Ok(new SubscriptionResponse
            {
                Tier = subscription.Tier.ToString(),
                Status = subscription.Status.ToString(),
                RenewalDate = subscription.RenewalDate,
                CancelAt = subscription.CancelAt,
                CreatedAt = subscription.CreatedAt
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to upgrade subscription for user {UserId}", userId);
            return BadRequest(new
            {
                error = "upgrade_failed",
                message = "Failed to process subscription upgrade",
                details = ex.Message
            });
        }
    }

    /// <summary>
    /// POST /v1/subscriptions/cancel
    /// Cancel current subscription.
    /// User retains access until current billing period ends.
    /// </summary>
    [HttpPost("cancel")]
    [ProducesResponseType(typeof(SubscriptionResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> CancelSubscription()
    {
        var userId = GetUserId();

        try
        {
            var subscription = await _subscriptionService.CancelSubscriptionAsync(userId);

            return Ok(new SubscriptionResponse
            {
                Tier = subscription.Tier.ToString(),
                Status = subscription.Status.ToString(),
                RenewalDate = subscription.RenewalDate,
                CancelAt = subscription.CancelAt,
                CreatedAt = subscription.CreatedAt,
                Message = $"Subscription cancelled. Access continues until {subscription.CancelAt:yyyy-MM-dd}"
            });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new
            {
                error = "cancellation_failed",
                message = ex.Message
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to cancel subscription for user {UserId}", userId);
            return BadRequest(new
            {
                error = "cancellation_failed",
                message = "Failed to process subscription cancellation",
                details = ex.Message
            });
        }
    }

    private Guid GetUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value
            ?? throw new UnauthorizedAccessException("User ID not found in token");

        return Guid.Parse(userIdClaim);
    }
}

/// <summary>
/// Request model for subscription upgrade.
/// </summary>
public class UpgradeRequest
{
    /// <summary>
    /// Target subscription tier (Premium or Pro).
    /// </summary>
    public string Tier { get; set; } = string.Empty;

    /// <summary>
    /// Stripe payment method ID (obtained from frontend Stripe.js).
    /// </summary>
    public string PaymentMethodId { get; set; } = string.Empty;
}

/// <summary>
/// Response model for subscription endpoints.
/// </summary>
public class SubscriptionResponse
{
    public string Tier { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public DateTime? RenewalDate { get; set; }
    public DateTime? CancelAt { get; set; }
    public DateTime CreatedAt { get; set; }
    public string? Message { get; set; }
}
