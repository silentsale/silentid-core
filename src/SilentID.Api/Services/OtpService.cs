using System.Security.Cryptography;
using System.Text;
using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

public interface IOtpService
{
    Task<string> GenerateOtpAsync(string email);
    Task<bool> ValidateOtpAsync(string email, string otp);
    Task<bool> CanRequestOtpAsync(string email);
    Task RevokeOtpAsync(string email);
}

/// <summary>
/// OTP service with persistent database storage.
/// Survives server restarts and works with horizontal scaling.
/// </summary>
public class OtpService : IOtpService
{
    private readonly ILogger<OtpService> _logger;
    private readonly IEmailService _emailService;
    private readonly SilentIdDbContext _dbContext;

    private const int OTP_LENGTH = 6;
    private const int OTP_EXPIRY_MINUTES = 10;
    private const int MAX_REQUESTS_PER_WINDOW = 3;
    private const int RATE_LIMIT_WINDOW_MINUTES = 5;
    private const int MAX_VALIDATION_ATTEMPTS = 3;

    public OtpService(
        ILogger<OtpService> logger,
        IEmailService emailService,
        SilentIdDbContext dbContext)
    {
        _logger = logger;
        _emailService = emailService;
        _dbContext = dbContext;
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

        // Invalidate any existing OTPs for this email
        await InvalidateExistingOtpsAsync(email);

        // Generate secure 6-digit OTP
        var otp = GenerateSecureOtp();

        // Store OTP with hash (never store plaintext)
        var otpCode = new OtpCode
        {
            Id = Guid.NewGuid(),
            Email = email,
            OtpHash = HashOtp(otp),
            CreatedAt = DateTime.UtcNow,
            ExpiresAt = DateTime.UtcNow.AddMinutes(OTP_EXPIRY_MINUTES),
            Attempts = 0,
            IsConsumed = false
        };

        _dbContext.OtpCodes.Add(otpCode);

        // Update rate limiting
        await UpdateRateLimitAsync(email);

        await _dbContext.SaveChangesAsync();

        // Send OTP via email
        await _emailService.SendOtpEmailAsync(email, otp, OTP_EXPIRY_MINUTES);

        _logger.LogInformation("OTP generated for email {Email}", email);

        return otp;
    }

    public async Task<bool> ValidateOtpAsync(string email, string otp)
    {
        email = email.ToLowerInvariant();
        otp = otp.Trim();

        // Find active (non-consumed, non-expired) OTP for this email
        var otpCode = await _dbContext.OtpCodes
            .Where(o => o.Email == email && !o.IsConsumed && o.ExpiresAt > DateTime.UtcNow)
            .OrderByDescending(o => o.CreatedAt)
            .FirstOrDefaultAsync();

        if (otpCode == null)
        {
            _logger.LogWarning("No valid OTP found for email {Email}", email);
            return false;
        }

        // Check if expired (double-check)
        if (DateTime.UtcNow > otpCode.ExpiresAt)
        {
            _logger.LogWarning("Expired OTP attempt for email {Email}", email);
            otpCode.IsConsumed = true; // Mark as consumed to prevent reuse
            await _dbContext.SaveChangesAsync();
            return false;
        }

        // Increment attempts
        otpCode.Attempts++;

        // Max attempts exceeded
        if (otpCode.Attempts > MAX_VALIDATION_ATTEMPTS)
        {
            _logger.LogWarning("Too many OTP validation attempts for email {Email}", email);
            otpCode.IsConsumed = true; // Invalidate after too many attempts
            await _dbContext.SaveChangesAsync();
            return false;
        }

        // Validate OTP hash
        if (HashOtp(otp) == otpCode.OtpHash)
        {
            _logger.LogInformation("OTP validated successfully for email {Email}", email);
            otpCode.IsConsumed = true; // Mark as consumed after successful validation
            await _dbContext.SaveChangesAsync();
            return true;
        }

        _logger.LogWarning("Invalid OTP attempt for email {Email}", email);
        await _dbContext.SaveChangesAsync();
        return false;
    }

    public async Task<bool> CanRequestOtpAsync(string email)
    {
        email = email.ToLowerInvariant();

        var rateLimit = await _dbContext.OtpRateLimits
            .FirstOrDefaultAsync(r => r.Email == email);

        if (rateLimit == null)
        {
            return true; // No rate limit entry = allowed
        }

        // Check if rate limit window has expired
        if (DateTime.UtcNow > rateLimit.WindowExpiresAt)
        {
            // Window expired, remove old entry
            _dbContext.OtpRateLimits.Remove(rateLimit);
            await _dbContext.SaveChangesAsync();
            return true;
        }

        // Check if within limit
        return rateLimit.RequestCount < MAX_REQUESTS_PER_WINDOW;
    }

    public async Task RevokeOtpAsync(string email)
    {
        email = email.ToLowerInvariant();
        await InvalidateExistingOtpsAsync(email);
        await _dbContext.SaveChangesAsync();
        _logger.LogInformation("OTP revoked for email {Email}", email);
    }

    private async Task InvalidateExistingOtpsAsync(string email)
    {
        var existingOtps = await _dbContext.OtpCodes
            .Where(o => o.Email == email && !o.IsConsumed)
            .ToListAsync();

        foreach (var otp in existingOtps)
        {
            otp.IsConsumed = true;
        }
    }

    private async Task UpdateRateLimitAsync(string email)
    {
        var rateLimit = await _dbContext.OtpRateLimits
            .FirstOrDefaultAsync(r => r.Email == email);

        if (rateLimit != null)
        {
            // Check if window has expired
            if (DateTime.UtcNow > rateLimit.WindowExpiresAt)
            {
                // Start new window
                rateLimit.RequestCount = 1;
                rateLimit.WindowExpiresAt = DateTime.UtcNow.AddMinutes(RATE_LIMIT_WINDOW_MINUTES);
            }
            else
            {
                // Increment count in current window
                rateLimit.RequestCount++;
            }
        }
        else
        {
            // Create new rate limit entry
            _dbContext.OtpRateLimits.Add(new OtpRateLimit
            {
                Id = Guid.NewGuid(),
                Email = email,
                RequestCount = 1,
                WindowExpiresAt = DateTime.UtcNow.AddMinutes(RATE_LIMIT_WINDOW_MINUTES)
            });
        }
    }

    private static string GenerateSecureOtp()
    {
        // Generate cryptographically secure 6-digit number
        var randomNumber = RandomNumberGenerator.GetInt32(100000, 999999);
        return randomNumber.ToString();
    }

    private static string HashOtp(string otp)
    {
        // Hash OTP with SHA256 for secure storage
        using var sha256 = SHA256.Create();
        var bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(otp));
        return Convert.ToHexString(bytes);
    }
}

/// <summary>
/// Background service to cleanup expired OTPs and rate limits.
/// Runs periodically to prevent database bloat.
/// </summary>
public class OtpCleanupService : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<OtpCleanupService> _logger;
    private readonly TimeSpan _cleanupInterval = TimeSpan.FromMinutes(15);

    public OtpCleanupService(IServiceProvider serviceProvider, ILogger<OtpCleanupService> logger)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await CleanupExpiredEntriesAsync();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error during OTP cleanup");
            }

            await Task.Delay(_cleanupInterval, stoppingToken);
        }
    }

    private async Task CleanupExpiredEntriesAsync()
    {
        using var scope = _serviceProvider.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<SilentIdDbContext>();

        var now = DateTime.UtcNow;

        // Delete expired OTPs (keep consumed ones for audit, delete after 24h)
        var expiredOtps = await dbContext.OtpCodes
            .Where(o => o.ExpiresAt < now.AddHours(-24))
            .ToListAsync();

        if (expiredOtps.Count > 0)
        {
            dbContext.OtpCodes.RemoveRange(expiredOtps);
            _logger.LogInformation("Cleaned up {Count} expired OTP codes", expiredOtps.Count);
        }

        // Delete expired rate limits
        var expiredRateLimits = await dbContext.OtpRateLimits
            .Where(r => r.WindowExpiresAt < now)
            .ToListAsync();

        if (expiredRateLimits.Count > 0)
        {
            dbContext.OtpRateLimits.RemoveRange(expiredRateLimits);
            _logger.LogInformation("Cleaned up {Count} expired rate limits", expiredRateLimits.Count);
        }

        await dbContext.SaveChangesAsync();
    }
}
