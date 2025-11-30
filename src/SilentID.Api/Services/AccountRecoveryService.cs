using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

/// <summary>
/// Account Recovery Service for passwordless account access
/// Since SilentID is 100% passwordless, recovery means:
/// 1. Email verification to prove account ownership
/// 2. Adding new passkeys/devices
/// 3. Revoking compromised devices
/// </summary>
public interface IAccountRecoveryService
{
    /// <summary>
    /// Initiate account recovery - sends verification to email
    /// </summary>
    Task<RecoveryResult> InitiateRecoveryAsync(string email, string ipAddress, string deviceInfo);

    /// <summary>
    /// Verify recovery code and establish session
    /// </summary>
    Task<RecoveryResult> VerifyRecoveryCodeAsync(string email, string code, string deviceId);

    /// <summary>
    /// Complete recovery by registering a new passkey
    /// </summary>
    Task<RecoveryResult> CompleteRecoveryWithPasskeyAsync(Guid userId, string credentialId, string publicKeyBase64, string deviceName);

    /// <summary>
    /// Revoke all existing sessions and devices (panic button)
    /// </summary>
    Task<RecoveryResult> RevokeAllSessionsAsync(Guid userId, string keepDeviceId);

    /// <summary>
    /// Get recovery status for a user
    /// </summary>
    Task<RecoveryStatus> GetRecoveryStatusAsync(Guid userId);
}

public class RecoveryResult
{
    public bool Success { get; set; }
    public string? ErrorMessage { get; set; }
    public string? RecoveryToken { get; set; }
    public Guid? UserId { get; set; }
    public int? SessionsRevoked { get; set; }
    public int? DevicesRevoked { get; set; }
}

public class RecoveryStatus
{
    public Guid UserId { get; set; }
    public bool HasPasskey { get; set; }
    public int ActiveDevices { get; set; }
    public int ActiveSessions { get; set; }
    public DateTime? LastRecoveryAttempt { get; set; }
    public bool IsRecoveryInProgress { get; set; }
    public List<string> AvailableRecoveryMethods { get; set; } = new();
}

public class AccountRecoveryService : IAccountRecoveryService
{
    private readonly SilentIdDbContext _db;
    private readonly IOtpService _otpService;
    private readonly IEmailService _emailService;
    private readonly ITokenService _tokenService;
    private readonly INotificationService _notificationService;
    private readonly ILogger<AccountRecoveryService> _logger;

    // Recovery rate limiting
    private const int MaxRecoveryAttemptsPerHour = 3;
    private const int RecoveryCodeExpiryMinutes = 15;

    public AccountRecoveryService(
        SilentIdDbContext db,
        IOtpService otpService,
        IEmailService emailService,
        ITokenService tokenService,
        INotificationService pushService,
        ILogger<AccountRecoveryService> logger)
    {
        _db = db;
        _otpService = otpService;
        _emailService = emailService;
        _tokenService = tokenService;
        _notificationService = pushService;
        _logger = logger;
    }

    public async Task<RecoveryResult> InitiateRecoveryAsync(string email, string ipAddress, string deviceInfo)
    {
        var user = await _db.Users.FirstOrDefaultAsync(u => u.Email == email.ToLowerInvariant());

        if (user == null)
        {
            // Don't reveal if account exists
            _logger.LogWarning("Recovery attempted for non-existent email: {Email}", email);
            return new RecoveryResult
            {
                Success = true, // Pretend success to prevent enumeration
                ErrorMessage = null
            };
        }

        // Check rate limiting
        var recentAttempts = await _db.LoginAttempts
            .Where(l => l.UserId == user.Id &&
                       l.AuthMethod == "recovery" &&
                       l.AttemptedAt > DateTime.UtcNow.AddHours(-1))
            .CountAsync();

        if (recentAttempts >= MaxRecoveryAttemptsPerHour)
        {
            _logger.LogWarning("Rate limit exceeded for recovery: {UserId}", user.Id);
            return new RecoveryResult
            {
                Success = false,
                ErrorMessage = "Too many recovery attempts. Please try again later."
            };
        }

        // Generate and send recovery OTP
        var otp = await _otpService.GenerateOtpAsync(user.Email);

        // Send recovery OTP email
        await _emailService.SendOtpEmailAsync(user.Email, otp, RecoveryCodeExpiryMinutes);

        // Also send security alert about recovery attempt
        await _emailService.SendAccountSecurityAlertAsync(
            user.Email,
            $"Account recovery initiated from IP: {ipAddress}. Device: {deviceInfo}. If this wasn't you, ignore the OTP code.");

        // Record the attempt
        _db.LoginAttempts.Add(new LoginAttempt
        {
            UserId = user.Id,
            DeviceId = "recovery",
            AuthMethod = "recovery",
            Success = false, // Not complete yet
            IpAddress = ipAddress,
            UserAgent = deviceInfo,
            AttemptedAt = DateTime.UtcNow
        });

        await _db.SaveChangesAsync();

        // Notify existing devices about recovery attempt
        await _notificationService.NotifyAsync(
            user.Id,
            NotificationType.SecurityAlert,
            "Account Recovery Initiated",
            $"Someone is trying to recover your account from {ipAddress}. If this wasn't you, secure your account immediately.", true);

        _logger.LogInformation("Recovery initiated for user {UserId} from IP {IP}", user.Id, ipAddress);

        return new RecoveryResult
        {
            Success = true,
            UserId = user.Id
        };
    }

    public async Task<RecoveryResult> VerifyRecoveryCodeAsync(string email, string code, string deviceId)
    {
        var user = await _db.Users.FirstOrDefaultAsync(u => u.Email == email.ToLowerInvariant());

        if (user == null)
        {
            return new RecoveryResult
            {
                Success = false,
                ErrorMessage = "Invalid code or email"
            };
        }

        // Verify OTP
        var isValid = await _otpService.ValidateOtpAsync(user.Email, code);

        if (!isValid)
        {
            _logger.LogWarning("Invalid recovery code for user {UserId}", user.Id);
            return new RecoveryResult
            {
                Success = false,
                ErrorMessage = "Invalid or expired code"
            };
        }

        // Generate a short-lived recovery token for completing the process
        // Generate a short-lived token for recovery completion
        var recoveryToken = _tokenService.GenerateRefreshToken();

        // Mark device as new (needs step-up for full trust)
        var device = await _db.AuthDevices
            .FirstOrDefaultAsync(d => d.UserId == user.Id && d.DeviceId == deviceId);

        if (device == null)
        {
            device = new AuthDevice
            {
                UserId = user.Id,
                DeviceId = deviceId,
                TrustLevel = DeviceTrustLevel.New,
                CreatedAt = DateTime.UtcNow
            };
            _db.AuthDevices.Add(device);
        }
        else
        {
            device.TrustLevel = DeviceTrustLevel.New; // Reset trust during recovery
        }

        device.LastUsedAt = DateTime.UtcNow;
        await _db.SaveChangesAsync();

        _logger.LogInformation("Recovery code verified for user {UserId}", user.Id);

        return new RecoveryResult
        {
            Success = true,
            RecoveryToken = recoveryToken,
            UserId = user.Id
        };
    }

    public async Task<RecoveryResult> CompleteRecoveryWithPasskeyAsync(
        Guid userId,
        string credentialId,
        string publicKeyBase64,
        string deviceName)
    {
        var user = await _db.Users.FindAsync(userId);
        if (user == null)
        {
            return new RecoveryResult
            {
                Success = false,
                ErrorMessage = "User not found"
            };
        }

        // Register the new passkey
        var passkey = new PasskeyCredential
        {
            UserId = userId,
            CredentialId = credentialId,
            PublicKey = publicKeyBase64,
            DeviceName = deviceName,
            CreatedAt = DateTime.UtcNow,
            LastUsedAt = DateTime.UtcNow
        };

        _db.PasskeyCredentials.Add(passkey);
        user.IsPasskeyEnabled = true;
        user.UpdatedAt = DateTime.UtcNow;

        await _db.SaveChangesAsync();

        // Notify user of new passkey
        await _notificationService.NotifyAsync(
            userId,
            NotificationType.SecurityAlert,
            "New Passkey Added",
            $"A new passkey was added to your account: {deviceName}", true);

        _logger.LogInformation("Recovery completed with new passkey for user {UserId}", userId);

        return new RecoveryResult
        {
            Success = true,
            UserId = userId
        };
    }

    public async Task<RecoveryResult> RevokeAllSessionsAsync(Guid userId, string keepDeviceId)
    {
        var user = await _db.Users.FindAsync(userId);
        if (user == null)
        {
            return new RecoveryResult
            {
                Success = false,
                ErrorMessage = "User not found"
            };
        }

        // Revoke all sessions except current
        var sessions = await _db.Sessions
            .Where(s => s.UserId == userId)
            .ToListAsync();

        var sessionsToRevoke = sessions.Where(s => s.DeviceId != keepDeviceId).ToList();
        _db.Sessions.RemoveRange(sessionsToRevoke);

        // Mark all other devices as suspicious
        var devices = await _db.AuthDevices
            .Where(d => d.UserId == userId && d.DeviceId != keepDeviceId)
            .ToListAsync();

        foreach (var device in devices)
        {
            device.TrustLevel = DeviceTrustLevel.Blocked;
            device.LastUsedAt = DateTime.UtcNow;
        }

        // Deactivate push tokens for other devices
        var pushTokens = await _db.PushNotificationTokens
            .Where(t => t.UserId == userId && t.DeviceId != keepDeviceId)
            .ToListAsync();

        foreach (var token in pushTokens)
        {
            token.IsActive = false;
            token.UpdatedAt = DateTime.UtcNow;
        }

        await _db.SaveChangesAsync();

        _logger.LogWarning(
            "All sessions revoked for user {UserId}. Sessions: {Sessions}, Devices: {Devices}",
            userId, sessionsToRevoke.Count, devices.Count);

        return new RecoveryResult
        {
            Success = true,
            SessionsRevoked = sessionsToRevoke.Count,
            DevicesRevoked = devices.Count
        };
    }

    public async Task<RecoveryStatus> GetRecoveryStatusAsync(Guid userId)
    {
        var user = await _db.Users.FindAsync(userId);
        if (user == null)
        {
            return new RecoveryStatus { UserId = userId };
        }

        var hasPasskey = await _db.PasskeyCredentials
            .AnyAsync(p => p.UserId == userId);

        var activeDevices = await _db.AuthDevices
            .CountAsync(d => d.UserId == userId && d.TrustLevel != DeviceTrustLevel.Blocked);

        var activeSessions = await _db.Sessions
            .CountAsync(s => s.UserId == userId && s.ExpiresAt > DateTime.UtcNow);

        var lastRecovery = await _db.LoginAttempts
            .Where(l => l.UserId == userId && l.AuthMethod == "recovery")
            .OrderByDescending(l => l.AttemptedAt)
            .Select(l => l.AttemptedAt)
            .FirstOrDefaultAsync();

        var recoveryMethods = new List<string> { "email_otp" };
        if (hasPasskey) recoveryMethods.Add("passkey");
        if (user.AppleUserId != null) recoveryMethods.Add("apple");
        if (user.GoogleUserId != null) recoveryMethods.Add("google");

        return new RecoveryStatus
        {
            UserId = userId,
            HasPasskey = hasPasskey,
            ActiveDevices = activeDevices,
            ActiveSessions = activeSessions,
            LastRecoveryAttempt = lastRecovery == default ? null : lastRecovery,
            IsRecoveryInProgress = false, // Would check for pending recovery tokens
            AvailableRecoveryMethods = recoveryMethods
        };
    }
}
