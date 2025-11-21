using System.Collections.Concurrent;
using System.Security.Cryptography;

namespace SilentID.Api.Services;

public interface IOtpService
{
    Task<string> GenerateOtpAsync(string email);
    Task<bool> ValidateOtpAsync(string email, string otp);
    Task<bool> CanRequestOtpAsync(string email);
    Task RevokeOtpAsync(string email);
}

public class OtpService : IOtpService
{
    private readonly ILogger<OtpService> _logger;
    private readonly IEmailService _emailService;

    // In-memory storage for OTPs (in production, consider Redis or database)
    private static readonly ConcurrentDictionary<string, OtpEntry> _otpStore = new();
    private static readonly ConcurrentDictionary<string, RateLimitEntry> _rateLimitStore = new();

    private const int OTP_LENGTH = 6;
    private const int OTP_EXPIRY_MINUTES = 10;
    private const int MAX_REQUESTS_PER_WINDOW = 3;
    private const int RATE_LIMIT_WINDOW_MINUTES = 5;

    public OtpService(ILogger<OtpService> logger, IEmailService emailService)
    {
        _logger = logger;
        _emailService = emailService;
    }

    public async Task<string> GenerateOtpAsync(string email)
    {
        email = email.ToLowerInvariant();

        // Check rate limiting
        if (!await CanRequestOtpAsync(email))
        {
            _logger.LogWarning("Rate limit exceeded for email {Email}", email);
            throw new InvalidOperationException("Too many OTP requests. Please try again later.");
        }

        // Generate secure 6-digit OTP
        var otp = GenerateSecureOtp();

        // Store OTP with expiry
        var otpEntry = new OtpEntry
        {
            Otp = otp,
            CreatedAt = DateTime.UtcNow,
            ExpiresAt = DateTime.UtcNow.AddMinutes(OTP_EXPIRY_MINUTES),
            Attempts = 0
        };

        _otpStore.AddOrUpdate(email, otpEntry, (key, existing) => otpEntry);

        // Update rate limiting
        UpdateRateLimit(email);

        // Send OTP via email
        await _emailService.SendOtpEmailAsync(email, otp, OTP_EXPIRY_MINUTES);

        _logger.LogInformation("OTP generated for email {Email}", email);

        return otp;
    }

    public Task<bool> ValidateOtpAsync(string email, string otp)
    {
        email = email.ToLowerInvariant();
        otp = otp.Trim();

        if (!_otpStore.TryGetValue(email, out var otpEntry))
        {
            _logger.LogWarning("No OTP found for email {Email}", email);
            return Task.FromResult(false);
        }

        // Check if expired
        if (DateTime.UtcNow > otpEntry.ExpiresAt)
        {
            _logger.LogWarning("Expired OTP attempt for email {Email}", email);
            _otpStore.TryRemove(email, out _);
            return Task.FromResult(false);
        }

        // Increment attempts
        otpEntry.Attempts++;

        // Max 3 attempts before invalidation
        if (otpEntry.Attempts > 3)
        {
            _logger.LogWarning("Too many OTP validation attempts for email {Email}", email);
            _otpStore.TryRemove(email, out _);
            return Task.FromResult(false);
        }

        // Validate OTP
        if (otpEntry.Otp == otp)
        {
            _logger.LogInformation("OTP validated successfully for email {Email}", email);
            _otpStore.TryRemove(email, out _); // Remove after successful validation
            return Task.FromResult(true);
        }

        _logger.LogWarning("Invalid OTP attempt for email {Email}", email);
        return Task.FromResult(false);
    }

    public Task<bool> CanRequestOtpAsync(string email)
    {
        email = email.ToLowerInvariant();

        if (!_rateLimitStore.TryGetValue(email, out var rateLimitEntry))
        {
            return Task.FromResult(true);
        }

        // Check if rate limit window has expired
        if (DateTime.UtcNow > rateLimitEntry.WindowExpiresAt)
        {
            _rateLimitStore.TryRemove(email, out _);
            return Task.FromResult(true);
        }

        // Check if within limit
        return Task.FromResult(rateLimitEntry.RequestCount < MAX_REQUESTS_PER_WINDOW);
    }

    public Task RevokeOtpAsync(string email)
    {
        email = email.ToLowerInvariant();
        _otpStore.TryRemove(email, out _);
        _logger.LogInformation("OTP revoked for email {Email}", email);
        return Task.CompletedTask;
    }

    private void UpdateRateLimit(string email)
    {
        if (_rateLimitStore.TryGetValue(email, out var rateLimitEntry))
        {
            // Check if window has expired
            if (DateTime.UtcNow > rateLimitEntry.WindowExpiresAt)
            {
                // Start new window
                rateLimitEntry = new RateLimitEntry
                {
                    RequestCount = 1,
                    WindowExpiresAt = DateTime.UtcNow.AddMinutes(RATE_LIMIT_WINDOW_MINUTES)
                };
            }
            else
            {
                // Increment count in current window
                rateLimitEntry.RequestCount++;
            }

            _rateLimitStore[email] = rateLimitEntry;
        }
        else
        {
            // Create new rate limit entry
            _rateLimitStore[email] = new RateLimitEntry
            {
                RequestCount = 1,
                WindowExpiresAt = DateTime.UtcNow.AddMinutes(RATE_LIMIT_WINDOW_MINUTES)
            };
        }
    }

    private static string GenerateSecureOtp()
    {
        // Generate cryptographically secure 6-digit number
        var randomNumber = RandomNumberGenerator.GetInt32(100000, 999999);
        return randomNumber.ToString();
    }

    // Background cleanup task to remove expired entries (would run as hosted service)
    public static void CleanupExpiredEntries()
    {
        var now = DateTime.UtcNow;

        // Cleanup expired OTPs
        foreach (var kvp in _otpStore)
        {
            if (now > kvp.Value.ExpiresAt)
            {
                _otpStore.TryRemove(kvp.Key, out _);
            }
        }

        // Cleanup expired rate limits
        foreach (var kvp in _rateLimitStore)
        {
            if (now > kvp.Value.WindowExpiresAt)
            {
                _rateLimitStore.TryRemove(kvp.Key, out _);
            }
        }
    }

    private class OtpEntry
    {
        public string Otp { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public DateTime ExpiresAt { get; set; }
        public int Attempts { get; set; }
    }

    private class RateLimitEntry
    {
        public int RequestCount { get; set; }
        public DateTime WindowExpiresAt { get; set; }
    }
}
