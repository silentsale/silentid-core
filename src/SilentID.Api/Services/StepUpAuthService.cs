using SilentID.Api.Data;
using SilentID.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace SilentID.Api.Services;

/// <summary>
/// Step-Up Authentication Service per Section 54.2
/// Determines when additional authentication is required based on device trust
/// </summary>
public interface IStepUpAuthService
{
    /// <summary>
    /// Check if step-up authentication is required for this device
    /// </summary>
    Task<StepUpResult> CheckStepUpRequiredAsync(Guid userId, string deviceId, string? ipAddress);

    /// <summary>
    /// Get the trust level for a device
    /// </summary>
    Task<DeviceTrustLevel> GetDeviceTrustLevelAsync(Guid userId, string deviceId);

    /// <summary>
    /// Update device trust level after successful authentication
    /// </summary>
    Task UpdateDeviceTrustAsync(Guid userId, string deviceId, bool loginSuccessful);

    /// <summary>
    /// Get allowed authentication methods based on device trust level
    /// </summary>
    List<string> GetAllowedAuthMethods(DeviceTrustLevel trustLevel);

    /// <summary>
    /// Record a login attempt for audit purposes
    /// </summary>
    Task RecordLoginAttemptAsync(LoginAttempt attempt);
}

public class StepUpResult
{
    public bool StepUpRequired { get; set; }
    public DeviceTrustLevel DeviceTrustLevel { get; set; }
    public List<string> AllowedMethods { get; set; } = new();
    public string? Reason { get; set; }
}

public class StepUpAuthService : IStepUpAuthService
{
    private readonly SilentIdDbContext _db;
    private readonly ILogger<StepUpAuthService> _logger;

    // Method priority per Section 54.1: Passkey > Apple > Google > Email OTP
    private static readonly List<string> AllMethods = new() { "passkey", "apple", "google", "email_otp" };
    private static readonly List<string> StrongMethods = new() { "passkey", "apple", "google" };
    private static readonly List<string> PasskeyOnly = new() { "passkey" };

    public StepUpAuthService(SilentIdDbContext db, ILogger<StepUpAuthService> logger)
    {
        _db = db;
        _logger = logger;
    }

    public async Task<StepUpResult> CheckStepUpRequiredAsync(Guid userId, string deviceId, string? ipAddress)
    {
        var device = await _db.AuthDevices
            .FirstOrDefaultAsync(d => d.UserId == userId && d.DeviceId == deviceId);

        // New device - always requires step-up
        if (device == null)
        {
            _logger.LogInformation("New device detected for user {UserId}, requiring step-up", userId);
            return new StepUpResult
            {
                StepUpRequired = true,
                DeviceTrustLevel = DeviceTrustLevel.New,
                AllowedMethods = StrongMethods,
                Reason = "New device detected"
            };
        }

        // Check for suspicious patterns
        var suspiciousReasons = await CheckSuspiciousPatternsAsync(userId, device, ipAddress);
        if (suspiciousReasons.Any())
        {
            _logger.LogWarning("Suspicious patterns for user {UserId}: {Reasons}",
                userId, string.Join(", ", suspiciousReasons));

            // Update device to suspicious
            device.TrustLevel = DeviceTrustLevel.Suspicious;
            await _db.SaveChangesAsync();

            return new StepUpResult
            {
                StepUpRequired = true,
                DeviceTrustLevel = DeviceTrustLevel.Suspicious,
                AllowedMethods = PasskeyOnly, // Most suspicious = passkey only
                Reason = string.Join("; ", suspiciousReasons)
            };
        }

        // Determine based on trust level
        var allowedMethods = GetAllowedAuthMethods(device.TrustLevel);
        var stepUpRequired = device.TrustLevel != DeviceTrustLevel.Trusted;

        return new StepUpResult
        {
            StepUpRequired = stepUpRequired,
            DeviceTrustLevel = device.TrustLevel,
            AllowedMethods = allowedMethods,
            Reason = stepUpRequired ? $"Device trust level: {device.TrustLevel}" : null
        };
    }

    public async Task<DeviceTrustLevel> GetDeviceTrustLevelAsync(Guid userId, string deviceId)
    {
        var device = await _db.AuthDevices
            .FirstOrDefaultAsync(d => d.UserId == userId && d.DeviceId == deviceId);

        return device?.TrustLevel ?? DeviceTrustLevel.New;
    }

    public async Task UpdateDeviceTrustAsync(Guid userId, string deviceId, bool loginSuccessful)
    {
        var device = await _db.AuthDevices
            .FirstOrDefaultAsync(d => d.UserId == userId && d.DeviceId == deviceId);

        if (device == null)
        {
            _logger.LogWarning("Device not found for trust update: {DeviceId}", deviceId);
            return;
        }

        if (loginSuccessful)
        {
            device.LoginCount++;
            device.LastUsedAt = DateTime.UtcNow;

            // Upgrade trust level based on successful logins (Section 54.3)
            device.TrustLevel = device.LoginCount switch
            {
                >= 10 => DeviceTrustLevel.Trusted,  // 10+ successful logins
                >= 3 => DeviceTrustLevel.Known,     // 3-9 successful logins
                _ => DeviceTrustLevel.New           // 1-2 logins
            };

            _logger.LogInformation("Device {DeviceId} trust upgraded to {TrustLevel} after {Count} logins",
                deviceId, device.TrustLevel, device.LoginCount);
        }
        else
        {
            // Failed login - consider downgrading trust
            if (device.TrustLevel == DeviceTrustLevel.Trusted)
            {
                device.TrustLevel = DeviceTrustLevel.Known;
            }
            else if (device.TrustLevel == DeviceTrustLevel.Known)
            {
                device.TrustLevel = DeviceTrustLevel.New;
            }

            _logger.LogWarning("Device {DeviceId} trust downgraded to {TrustLevel} after failed login",
                deviceId, device.TrustLevel);
        }

        await _db.SaveChangesAsync();
    }

    public List<string> GetAllowedAuthMethods(DeviceTrustLevel trustLevel)
    {
        // Section 54.2: Method restrictions based on trust level
        return trustLevel switch
        {
            DeviceTrustLevel.Trusted => AllMethods,           // All methods allowed
            DeviceTrustLevel.Known => AllMethods,             // All methods allowed
            DeviceTrustLevel.New => StrongMethods,            // No Email OTP for new devices
            DeviceTrustLevel.Suspicious => PasskeyOnly,       // Passkey only for suspicious
            DeviceTrustLevel.Blocked => new List<string>(),   // No methods - blocked
            _ => StrongMethods
        };
    }

    public async Task RecordLoginAttemptAsync(LoginAttempt attempt)
    {
        _db.LoginAttempts.Add(attempt);
        await _db.SaveChangesAsync();

        _logger.LogInformation("Login attempt recorded for user {UserId}: {Method} - {Success}",
            attempt.UserId, attempt.AuthMethod, attempt.Success ? "Success" : "Failed");
    }

    private async Task<List<string>> CheckSuspiciousPatternsAsync(Guid userId, AuthDevice device, string? ipAddress)
    {
        var reasons = new List<string>();

        // Check 1: IP address change (geo velocity)
        if (!string.IsNullOrEmpty(ipAddress) && !string.IsNullOrEmpty(device.LastIP))
        {
            if (device.LastIP != ipAddress)
            {
                // Check if this IP was used recently (within 24 hours)
                var recentFromSameIp = await _db.LoginAttempts
                    .Where(l => l.UserId == userId &&
                               l.IpAddress == ipAddress &&
                               l.AttemptedAt > DateTime.UtcNow.AddHours(-24))
                    .AnyAsync();

                if (!recentFromSameIp)
                {
                    // Check time since last login for velocity
                    var hoursSinceLastLogin = (DateTime.UtcNow - device.LastUsedAt).TotalHours;
                    if (hoursSinceLastLogin < 1) // Same device, different IP within 1 hour
                    {
                        reasons.Add("Rapid IP address change detected");
                    }
                }
            }
        }

        // Check 2: Multiple failed attempts recently
        var recentFailedAttempts = await _db.LoginAttempts
            .Where(l => l.UserId == userId &&
                       !l.Success &&
                       l.AttemptedAt > DateTime.UtcNow.AddHours(-1))
            .CountAsync();

        if (recentFailedAttempts >= 3)
        {
            reasons.Add($"Multiple failed login attempts ({recentFailedAttempts} in last hour)");
        }

        // Check 3: Device fingerprint mismatch (if we have history)
        // This would compare stored fingerprint components
        // For MVP, we check basic attributes

        return reasons;
    }
}
