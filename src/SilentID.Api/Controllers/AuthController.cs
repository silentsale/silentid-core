using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;
using SilentID.Api.Services;
using System.Security.Claims;

namespace SilentID.Api.Controllers;

[ApiController]
[Route("v1/auth")]
public class AuthController : ControllerBase
{
    private readonly SilentIdDbContext _context;
    private readonly ITokenService _tokenService;
    private readonly IOtpService _otpService;
    private readonly IDuplicateDetectionService _duplicateDetection;
    private readonly IEmailService _emailService;
    private readonly ILogger<AuthController> _logger;

    public AuthController(
        SilentIdDbContext context,
        ITokenService tokenService,
        IOtpService otpService,
        IDuplicateDetectionService duplicateDetection,
        IEmailService emailService,
        ILogger<AuthController> logger)
    {
        _context = context;
        _tokenService = tokenService;
        _otpService = otpService;
        _duplicateDetection = duplicateDetection;
        _emailService = emailService;
        _logger = logger;
    }

    /// <summary>
    /// Request OTP for email-based authentication
    /// </summary>
    [HttpPost("request-otp")]
    public async Task<IActionResult> RequestOtp([FromBody] RequestOtpRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(new { error = "invalid_request", message = "Please provide a valid email address." });
        }

        var email = request.Email.ToLowerInvariant();

        try
        {
            // Check rate limiting
            if (!await _otpService.CanRequestOtpAsync(email))
            {
                return StatusCode(429, new
                {
                    error = "rate_limit_exceeded",
                    message = "Too many OTP requests. Please try again in a few minutes."
                });
            }

            // Generate and send OTP
            await _otpService.GenerateOtpAsync(email);

            _logger.LogInformation("OTP requested for email {Email}", email);

            return Ok(new
            {
                message = "Verification code sent to your email.",
                email = email,
                expiresInMinutes = 10
            });
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "OTP request failed for {Email}", email);
            return StatusCode(429, new
            {
                error = "rate_limit_exceeded",
                message = ex.Message
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error requesting OTP for {Email}", email);
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to send verification code. Please try again."
            });
        }
    }

    /// <summary>
    /// Verify OTP and authenticate user (login or register)
    /// </summary>
    [HttpPost("verify-otp")]
    public async Task<IActionResult> VerifyOtp([FromBody] VerifyOtpRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(new { error = "invalid_request", message = "Email and OTP are required." });
        }

        var email = request.Email.ToLowerInvariant();

        // Validate OTP
        var isValidOtp = await _otpService.ValidateOtpAsync(email, request.Otp);

        if (!isValidOtp)
        {
            _logger.LogWarning("Invalid OTP attempt for {Email}", email);
            return Unauthorized(new
            {
                error = "invalid_otp",
                message = "Invalid or expired verification code."
            });
        }

        // Check if user exists
        var existingUser = await _context.Users
            .FirstOrDefaultAsync(u => u.Email == email);

        User user;
        bool isNewUser = false;

        if (existingUser == null)
        {
            // New user registration
            isNewUser = true;

            // Check for duplicates
            var deviceId = request.DeviceId;
            var ipAddress = GetClientIpAddress();

            var duplicateCheck = await _duplicateDetection.CheckForDuplicatesAsync(email, deviceId, ipAddress);

            if (duplicateCheck.HasExistingUser)
            {
                _logger.LogWarning("Duplicate account attempt for {Email}: {Reasons}", email, string.Join(", ", duplicateCheck.Reasons));
                return Conflict(new
                {
                    error = "account_exists",
                    message = "An account with this email already exists. Please log in instead.",
                    existingUserId = duplicateCheck.ExistingUserId
                });
            }

            if (duplicateCheck.IsSuspicious)
            {
                _logger.LogWarning("Suspicious signup detected for {Email}: {Reasons}", email, string.Join(", ", duplicateCheck.Reasons));
                // Allow signup but flag for review
            }

            // Create username from email
            var username = GenerateUsername(email);

            // Create new user
            user = new User
            {
                Email = email,
                Username = username,
                DisplayName = username,
                IsEmailVerified = true, // Verified via OTP
                SignupIP = ipAddress,
                SignupDeviceId = deviceId,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            // Send welcome email
            await _emailService.SendWelcomeEmailAsync(email, user.DisplayName);

            _logger.LogInformation("New user registered: {UserId} ({Email})", user.Id, email);
        }
        else
        {
            // Existing user login
            user = existingUser;

            // Update email verification status
            if (!user.IsEmailVerified)
            {
                user.IsEmailVerified = true;
                user.UpdatedAt = DateTime.UtcNow;
                await _context.SaveChangesAsync();
            }

            _logger.LogInformation("User logged in: {UserId} ({Email})", user.Id, email);
        }

        // Generate tokens
        var accessToken = _tokenService.GenerateAccessToken(user);
        var refreshToken = _tokenService.GenerateRefreshToken();
        var refreshTokenHash = _tokenService.HashRefreshToken(refreshToken);

        // Store session
        var session = new Session
        {
            UserId = user.Id,
            RefreshTokenHash = refreshTokenHash,
            ExpiresAt = DateTime.UtcNow.AddDays(7),
            IP = GetClientIpAddress(),
            DeviceId = request.DeviceId,
            CreatedAt = DateTime.UtcNow
        };

        _context.Sessions.Add(session);
        await _context.SaveChangesAsync();

        // Track device
        if (!string.IsNullOrWhiteSpace(request.DeviceId))
        {
            await TrackDeviceAsync(user.Id, request.DeviceId, request.DeviceModel, request.OS, request.Browser);
        }

        return Ok(new
        {
            accessToken,
            refreshToken,
            expiresIn = 900, // 15 minutes in seconds
            tokenType = "Bearer",
            user = new
            {
                id = user.Id,
                email = user.Email,
                username = user.Username,
                displayName = user.DisplayName,
                accountType = user.AccountType.ToString(),
                isEmailVerified = user.IsEmailVerified,
                isNewUser
            }
        });
    }

    /// <summary>
    /// Refresh access token using refresh token
    /// </summary>
    [HttpPost("refresh")]
    public async Task<IActionResult> RefreshToken([FromBody] RefreshTokenRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.RefreshToken))
        {
            return BadRequest(new { error = "invalid_request", message = "Refresh token is required." });
        }

        var refreshTokenHash = _tokenService.HashRefreshToken(request.RefreshToken);

        // Find session with matching refresh token
        var session = await _context.Sessions
            .Include(s => s.User)
            .FirstOrDefaultAsync(s => s.RefreshTokenHash == refreshTokenHash && s.ExpiresAt > DateTime.UtcNow);

        if (session == null)
        {
            _logger.LogWarning("Invalid or expired refresh token");
            return Unauthorized(new
            {
                error = "invalid_token",
                message = "Invalid or expired refresh token."
            });
        }

        var user = session.User;

        // Check if user account is active
        if (user.AccountStatus != AccountStatus.Active)
        {
            _logger.LogWarning("Refresh token used for suspended account: {UserId}", user.Id);
            return Unauthorized(new
            {
                error = "account_suspended",
                message = "Your account has been suspended."
            });
        }

        // Generate new access token
        var accessToken = _tokenService.GenerateAccessToken(user);

        // Optionally rotate refresh token for better security
        var newRefreshToken = _tokenService.GenerateRefreshToken();
        var newRefreshTokenHash = _tokenService.HashRefreshToken(newRefreshToken);

        session.RefreshTokenHash = newRefreshTokenHash;
        session.ExpiresAt = DateTime.UtcNow.AddDays(7);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Token refreshed for user {UserId}", user.Id);

        return Ok(new
        {
            accessToken,
            refreshToken = newRefreshToken,
            expiresIn = 900, // 15 minutes in seconds
            tokenType = "Bearer"
        });
    }

    /// <summary>
    /// Logout and invalidate session
    /// </summary>
    [Authorize]
    [HttpPost("logout")]
    public async Task<IActionResult> Logout([FromBody] LogoutRequest? request)
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            return Unauthorized();
        }

        // Delete all sessions for user (or specific session if refresh token provided)
        if (request != null && !string.IsNullOrWhiteSpace(request.RefreshToken))
        {
            var refreshTokenHash = _tokenService.HashRefreshToken(request.RefreshToken);
            var session = await _context.Sessions
                .FirstOrDefaultAsync(s => s.UserId == userId && s.RefreshTokenHash == refreshTokenHash);

            if (session != null)
            {
                _context.Sessions.Remove(session);
            }
        }
        else
        {
            // Logout from all devices
            var sessions = await _context.Sessions
                .Where(s => s.UserId == userId)
                .ToListAsync();

            _context.Sessions.RemoveRange(sessions);
        }

        await _context.SaveChangesAsync();

        _logger.LogInformation("User logged out: {UserId}", userId);

        return Ok(new { message = "Logged out successfully." });
    }

    // Helper methods

    private string GetClientIpAddress()
    {
        var ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown";

        // Check for forwarded IP (if behind proxy/load balancer)
        if (Request.Headers.ContainsKey("X-Forwarded-For"))
        {
            ipAddress = Request.Headers["X-Forwarded-For"].ToString().Split(',')[0].Trim();
        }

        return ipAddress;
    }

    private string GenerateUsername(string email)
    {
        var baseUsername = email.Split('@')[0].ToLowerInvariant();

        // Remove special characters
        baseUsername = new string(baseUsername.Where(c => char.IsLetterOrDigit(c)).ToArray());

        // Ensure minimum length
        if (baseUsername.Length < 3)
        {
            baseUsername = "user" + baseUsername;
        }

        // Add random suffix to ensure uniqueness
        var randomSuffix = Random.Shared.Next(1000, 9999);
        return $"{baseUsername}{randomSuffix}";
    }

    private async Task TrackDeviceAsync(Guid userId, string deviceId, string? deviceModel, string? os, string? browser)
    {
        var existingDevice = await _context.AuthDevices
            .FirstOrDefaultAsync(d => d.UserId == userId && d.DeviceId == deviceId);

        if (existingDevice != null)
        {
            existingDevice.LastUsedAt = DateTime.UtcNow;
        }
        else
        {
            var newDevice = new AuthDevice
            {
                UserId = userId,
                DeviceId = deviceId,
                DeviceModel = deviceModel,
                OS = os,
                Browser = browser,
                IsTrusted = false,
                LastUsedAt = DateTime.UtcNow,
                CreatedAt = DateTime.UtcNow
            };

            _context.AuthDevices.Add(newDevice);
        }

        await _context.SaveChangesAsync();
    }
}

// Request DTOs
public record RequestOtpRequest(string Email);

public record VerifyOtpRequest(
    string Email,
    string Otp,
    string? DeviceId = null,
    string? DeviceModel = null,
    string? OS = null,
    string? Browser = null
);

public record RefreshTokenRequest(string RefreshToken);

public record LogoutRequest(string? RefreshToken = null);
