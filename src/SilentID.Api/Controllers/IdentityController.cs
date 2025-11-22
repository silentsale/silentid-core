using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Services;
using Stripe;
using System.Security.Claims;

namespace SilentID.Api.Controllers;

/// <summary>
/// Identity verification endpoints using Stripe Identity.
/// Handles creation of verification sessions and status checks.
/// </summary>
[ApiController]
[Route("v1/identity")]
public class IdentityController : ControllerBase
{
    private readonly IStripeIdentityService _stripeIdentityService;
    private readonly ILogger<IdentityController> _logger;
    private readonly IConfiguration _configuration;

    public IdentityController(
        IStripeIdentityService stripeIdentityService,
        ILogger<IdentityController> logger,
        IConfiguration configuration)
    {
        _stripeIdentityService = stripeIdentityService;
        _logger = logger;
        _configuration = configuration;
    }

    /// <summary>
    /// Creates a Stripe Identity verification session.
    /// User must be authenticated.
    /// </summary>
    /// <param name="request">Return URL for after verification</param>
    /// <returns>Stripe session URL</returns>
    [HttpPost("stripe/session")]
    [Authorize]
    public async Task<IActionResult> CreateStripeSession([FromBody] CreateSessionRequest request)
    {
        try
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
            {
                return Unauthorized(new { error = "invalid_token", message = "Invalid user ID" });
            }

            if (string.IsNullOrEmpty(request.ReturnUrl))
            {
                return BadRequest(new { error = "invalid_request", message = "returnUrl is required" });
            }

            var sessionUrl = await _stripeIdentityService.CreateVerificationSessionAsync(userId, request.ReturnUrl);

            _logger.LogInformation("Created Stripe Identity session for user {UserId}", userId);

            return Ok(new
            {
                sessionUrl,
                message = "Verification session created successfully"
            });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { error = "already_verified", message = ex.Message });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error creating Stripe Identity session");
            return StatusCode(500, new { error = "server_error", message = "Failed to create verification session" });
        }
    }

    /// <summary>
    /// Gets the current identity verification status for authenticated user.
    /// </summary>
    /// <returns>Verification status</returns>
    [HttpGet("status")]
    [Authorize]
    public async Task<IActionResult> GetStatus()
    {
        try
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
            {
                return Unauthorized(new { error = "invalid_token", message = "Invalid user ID" });
            }

            var verification = await _stripeIdentityService.GetVerificationStatusAsync(userId);

            if (verification == null)
            {
                return Ok(new
                {
                    status = "not_started",
                    message = "No verification initiated yet"
                });
            }

            return Ok(new
            {
                status = verification.Status.ToString().ToLower(),
                level = verification.Level.ToString().ToLower(),
                verifiedAt = verification.VerifiedAt,
                createdAt = verification.CreatedAt
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting verification status");
            return StatusCode(500, new { error = "server_error", message = "Failed to get verification status" });
        }
    }

    /// <summary>
    /// Stripe webhook endpoint for handling verification events.
    /// Public endpoint (no auth) - validates using Stripe webhook signature.
    /// </summary>
    /// <returns>OK if processed successfully</returns>
    [HttpPost("webhook")]
    [AllowAnonymous]
    public async Task<IActionResult> HandleWebhook()
    {
        try
        {
            var json = await new StreamReader(HttpContext.Request.Body).ReadToEndAsync();
            var stripeSignature = Request.Headers["Stripe-Signature"].ToString();
            var webhookSecret = _configuration["Stripe:WebhookSecret"];

            if (string.IsNullOrEmpty(webhookSecret))
            {
                _logger.LogWarning("Stripe webhook secret not configured");
                return BadRequest(new { error = "webhook_not_configured" });
            }

            // Verify webhook signature
            Event stripeEvent;
            try
            {
                stripeEvent = EventUtility.ConstructEvent(
                    json,
                    stripeSignature,
                    webhookSecret
                );
            }
            catch (StripeException ex)
            {
                _logger.LogError(ex, "Invalid Stripe webhook signature");
                return BadRequest(new { error = "invalid_signature" });
            }

            _logger.LogInformation("Received Stripe webhook: {EventType}", stripeEvent.Type);

            // Handle specific event types
            if (stripeEvent.Type == "identity.verification_session.verified" ||
                stripeEvent.Type == "identity.verification_session.requires_input")
            {
                var session = stripeEvent.Data.Object as Stripe.Identity.VerificationSession;
                if (session != null)
                {
                    await _stripeIdentityService.HandleVerificationSessionCompletedAsync(session.Id);
                }
            }

            return Ok(new { received = true });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing Stripe webhook");
            return StatusCode(500, new { error = "webhook_processing_failed" });
        }
    }
}

/// <summary>
/// Request model for creating verification session.
/// </summary>
public class CreateSessionRequest
{
    public string ReturnUrl { get; set; } = string.Empty;
}
