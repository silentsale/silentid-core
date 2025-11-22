using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;
using Stripe.Identity;

namespace SilentID.Api.Services;

public interface IStripeIdentityService
{
    Task<string> CreateVerificationSessionAsync(Guid userId, string returnUrl);
    Task<IdentityVerification?> GetVerificationStatusAsync(Guid userId);
    Task HandleVerificationSessionCompletedAsync(string sessionId);
}

/// <summary>
/// Service for managing Stripe Identity verification.
/// Handles creation of verification sessions and webhook processing.
/// </summary>
public class StripeIdentityService : IStripeIdentityService
{
    private readonly SilentIdDbContext _context;
    private readonly ILogger<StripeIdentityService> _logger;
    private readonly IConfiguration _configuration;

    public StripeIdentityService(
        SilentIdDbContext context,
        ILogger<StripeIdentityService> logger,
        IConfiguration configuration)
    {
        _context = context;
        _logger = logger;
        _configuration = configuration;

        // Initialize Stripe API key
        var stripeSecretKey = _configuration["Stripe:SecretKey"];
        if (!string.IsNullOrEmpty(stripeSecretKey))
        {
            Stripe.StripeConfiguration.ApiKey = stripeSecretKey;
        }
        else
        {
            _logger.LogWarning("Stripe SecretKey not configured");
        }
    }

    /// <summary>
    /// Creates a Stripe Identity verification session for a user.
    /// </summary>
    /// <param name="userId">User ID to verify</param>
    /// <param name="returnUrl">URL to redirect user after verification</param>
    /// <returns>Stripe session URL for user to complete verification</returns>
    public async Task<string> CreateVerificationSessionAsync(Guid userId, string returnUrl)
    {
        // Check if user already has a verification session
        var existingVerification = await _context.IdentityVerifications
            .Where(v => v.UserId == userId)
            .OrderByDescending(v => v.CreatedAt)
            .FirstOrDefaultAsync();

        // If already verified, return success
        if (existingVerification?.Status == VerificationStatus.Verified)
        {
            _logger.LogInformation("User {UserId} already verified", userId);
            throw new InvalidOperationException("User is already verified");
        }

        try
        {
            // Create Stripe Identity verification session
            var options = new VerificationSessionCreateOptions
            {
                Type = "document",
                ReturnUrl = returnUrl,
                Metadata = new Dictionary<string, string>
                {
                    { "userId", userId.ToString() }
                }
            };

            var service = new VerificationSessionService();
            var session = await service.CreateAsync(options);

            // Store verification record in database
            var verification = new IdentityVerification
            {
                Id = Guid.NewGuid(),
                UserId = userId,
                StripeVerificationId = session.Id,
                Status = VerificationStatus.Pending,
                Level = VerificationLevel.Basic,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.IdentityVerifications.Add(verification);
            await _context.SaveChangesAsync();

            _logger.LogInformation("Created Stripe Identity session for user {UserId}: {SessionId}",
                userId, session.Id);

            return session.Url;
        }
        catch (Stripe.StripeException ex)
        {
            _logger.LogError(ex, "Stripe error creating verification session for user {UserId}", userId);
            throw new Exception("Failed to create verification session", ex);
        }
    }

    /// <summary>
    /// Gets the current verification status for a user.
    /// </summary>
    public async Task<IdentityVerification?> GetVerificationStatusAsync(Guid userId)
    {
        return await _context.IdentityVerifications
            .Where(v => v.UserId == userId)
            .OrderByDescending(v => v.CreatedAt)
            .FirstOrDefaultAsync();
    }

    /// <summary>
    /// Handles Stripe webhook for verification session completed.
    /// Updates verification status in database.
    /// </summary>
    public async Task HandleVerificationSessionCompletedAsync(string sessionId)
    {
        try
        {
            // Fetch the session from Stripe
            var service = new VerificationSessionService();
            var session = await service.GetAsync(sessionId);

            // Find matching verification record
            var verification = await _context.IdentityVerifications
                .FirstOrDefaultAsync(v => v.StripeVerificationId == sessionId);

            if (verification == null)
            {
                _logger.LogWarning("Verification session not found in database: {SessionId}", sessionId);
                return;
            }

            // Update status based on Stripe result
            switch (session.Status)
            {
                case "verified":
                    verification.Status = VerificationStatus.Verified;
                    verification.VerifiedAt = DateTime.UtcNow;
                    _logger.LogInformation("User {UserId} identity verified successfully", verification.UserId);
                    break;

                case "requires_input":
                    verification.Status = VerificationStatus.NeedsRetry;
                    _logger.LogInformation("User {UserId} verification needs retry", verification.UserId);
                    break;

                case "canceled":
                case "processing":
                    verification.Status = VerificationStatus.Pending;
                    break;

                default:
                    verification.Status = VerificationStatus.Failed;
                    _logger.LogWarning("User {UserId} verification failed: {Status}",
                        verification.UserId, session.Status);
                    break;
            }

            verification.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            _logger.LogInformation("Updated verification status for user {UserId}: {Status}",
                verification.UserId, verification.Status);
        }
        catch (Stripe.StripeException ex)
        {
            _logger.LogError(ex, "Stripe error handling verification session: {SessionId}", sessionId);
            throw;
        }
    }
}
