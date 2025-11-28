using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

public interface ISecurityCenterService
{
    // Login History
    Task<LoginHistoryResponse> GetLoginHistoryAsync(Guid userId, int limit = 50);

    // Risk Score & Signals (user-facing view)
    Task<UserRiskStatusResponse> GetUserRiskStatusAsync(Guid userId);

    // Security Alerts
    Task<List<SecurityAlertResponse>> GetSecurityAlertsAsync(Guid userId, bool includeRead = false);
    Task<int> GetUnreadAlertCountAsync(Guid userId);
    Task MarkAlertAsReadAsync(Guid userId, Guid alertId);
    Task MarkAllAlertsAsReadAsync(Guid userId);
    Task CreateAlertAsync(Guid userId, SecurityAlertType type, string title, string message, int severity = 5, string? metadata = null);

    // Identity Status
    Task<IdentityStatusResponse> GetIdentityStatusAsync(Guid userId);

    // Evidence Vault Health
    Task<VaultHealthResponse> GetVaultHealthAsync(Guid userId);

    // Breach Check (placeholder - requires HaveIBeenPwned API)
    Task<BreachCheckResponse> CheckEmailBreachAsync(string email);
}

public class SecurityCenterService : ISecurityCenterService
{
    private readonly SilentIdDbContext _context;
    private readonly ILogger<SecurityCenterService> _logger;

    public SecurityCenterService(SilentIdDbContext context, ILogger<SecurityCenterService> logger)
    {
        _context = context;
        _logger = logger;
    }

    #region Login History

    public async Task<LoginHistoryResponse> GetLoginHistoryAsync(Guid userId, int limit = 50)
    {
        // Get sessions with device info
        var sessions = await _context.Sessions
            .Where(s => s.UserId == userId)
            .OrderByDescending(s => s.CreatedAt)
            .Take(limit)
            .Select(s => new LoginEntry
            {
                Id = s.Id,
                Timestamp = s.CreatedAt,
                IpAddress = MaskIpAddress(s.IP),
                DeviceId = s.DeviceId,
                ExpiresAt = s.ExpiresAt,
                IsActive = s.ExpiresAt > DateTime.UtcNow
            })
            .ToListAsync();

        // Get device details for each session
        var deviceIds = sessions.Where(s => s.DeviceId != null).Select(s => s.DeviceId).Distinct().ToList();
        var devices = await _context.AuthDevices
            .Where(d => d.UserId == userId && deviceIds.Contains(d.DeviceId))
            .ToDictionaryAsync(d => d.DeviceId, d => d);

        foreach (var session in sessions)
        {
            if (session.DeviceId != null && devices.TryGetValue(session.DeviceId, out var device))
            {
                session.DeviceModel = device.DeviceModel;
                session.OS = device.OS;
                session.Browser = device.Browser;
                session.IsTrusted = device.IsTrusted;
            }
        }

        return new LoginHistoryResponse
        {
            Logins = sessions,
            TotalCount = await _context.Sessions.CountAsync(s => s.UserId == userId)
        };
    }

    private static string? MaskIpAddress(string? ip)
    {
        if (string.IsNullOrEmpty(ip)) return null;

        // Mask last octet for privacy: 192.168.1.100 -> 192.168.1.xxx
        var parts = ip.Split('.');
        if (parts.Length == 4)
        {
            return $"{parts[0]}.{parts[1]}.{parts[2]}.xxx";
        }
        return ip;
    }

    #endregion

    #region Risk Status

    public async Task<UserRiskStatusResponse> GetUserRiskStatusAsync(Guid userId)
    {
        // Get active (unresolved) risk signals
        var signals = await _context.RiskSignals
            .Where(r => r.UserId == userId && !r.IsResolved)
            .OrderByDescending(r => r.Severity)
            .ThenByDescending(r => r.CreatedAt)
            .Select(r => new RiskSignalResponse
            {
                Id = r.Id,
                Type = r.Type.ToString(),
                Severity = r.Severity,
                Message = r.Message,
                CreatedAt = r.CreatedAt,
                IsResolved = r.IsResolved
            })
            .ToListAsync();

        // Calculate risk score (sum of severities, max 100)
        var riskScore = Math.Min(signals.Sum(s => s.Severity), 100);

        // Determine risk level
        var riskLevel = riskScore switch
        {
            0 => "None",
            < 20 => "Low",
            < 50 => "Moderate",
            < 70 => "High",
            _ => "Critical"
        };

        return new UserRiskStatusResponse
        {
            RiskScore = riskScore,
            RiskLevel = riskLevel,
            ActiveSignals = signals,
            SignalCount = signals.Count,
            LastUpdated = signals.FirstOrDefault()?.CreatedAt ?? DateTime.UtcNow
        };
    }

    #endregion

    #region Security Alerts

    public async Task<List<SecurityAlertResponse>> GetSecurityAlertsAsync(Guid userId, bool includeRead = false)
    {
        var query = _context.SecurityAlerts
            .Where(a => a.UserId == userId);

        if (!includeRead)
        {
            query = query.Where(a => !a.IsRead);
        }

        return await query
            .OrderByDescending(a => a.CreatedAt)
            .Select(a => new SecurityAlertResponse
            {
                Id = a.Id,
                Type = a.Type.ToString(),
                Title = a.Title,
                Message = a.Message,
                Severity = a.Severity,
                IsRead = a.IsRead,
                CreatedAt = a.CreatedAt
            })
            .ToListAsync();
    }

    public async Task<int> GetUnreadAlertCountAsync(Guid userId)
    {
        return await _context.SecurityAlerts
            .CountAsync(a => a.UserId == userId && !a.IsRead);
    }

    public async Task MarkAlertAsReadAsync(Guid userId, Guid alertId)
    {
        var alert = await _context.SecurityAlerts
            .FirstOrDefaultAsync(a => a.Id == alertId && a.UserId == userId);

        if (alert != null)
        {
            alert.IsRead = true;
            await _context.SaveChangesAsync();
        }
    }

    public async Task MarkAllAlertsAsReadAsync(Guid userId)
    {
        await _context.SecurityAlerts
            .Where(a => a.UserId == userId && !a.IsRead)
            .ExecuteUpdateAsync(a => a.SetProperty(x => x.IsRead, true));
    }

    public async Task CreateAlertAsync(Guid userId, SecurityAlertType type, string title, string message, int severity = 5, string? metadata = null)
    {
        var alert = new SecurityAlert
        {
            Id = Guid.NewGuid(),
            UserId = userId,
            Type = type,
            Title = title,
            Message = message,
            Severity = severity,
            Metadata = metadata,
            IsRead = false,
            CreatedAt = DateTime.UtcNow
        };

        _context.SecurityAlerts.Add(alert);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Created security alert {AlertId} for user {UserId}: {Title}",
            alert.Id, userId, title);
    }

    #endregion

    #region Identity Status

    public async Task<IdentityStatusResponse> GetIdentityStatusAsync(Guid userId)
    {
        var user = await _context.Users
            .FirstOrDefaultAsync(u => u.Id == userId);

        if (user == null)
        {
            throw new KeyNotFoundException($"User {userId} not found");
        }

        // Get identity verification status separately
        var latestVerification = await _context.IdentityVerifications
            .Where(v => v.UserId == userId)
            .OrderByDescending(v => v.CreatedAt)
            .FirstOrDefaultAsync();

        // Get passkey count
        var passkeyCount = await _context.PasskeyCredentials
            .CountAsync(p => p.UserId == userId);

        // Get last login from sessions
        var lastLogin = await _context.Sessions
            .Where(s => s.UserId == userId)
            .OrderByDescending(s => s.CreatedAt)
            .Select(s => s.CreatedAt)
            .FirstOrDefaultAsync();

        var isIdentityVerified = latestVerification?.Status == VerificationStatus.Verified;

        return new IdentityStatusResponse
        {
            // Identity verification
            IdentityVerified = isIdentityVerified,
            IdentityVerificationDate = latestVerification?.VerifiedAt,
            IdentityProvider = "Stripe Identity",

            // Email
            EmailVerified = user.IsEmailVerified,
            Email = MaskEmail(user.Email),

            // Passkeys
            PasskeyEnabled = user.IsPasskeyEnabled || passkeyCount > 0,
            PasskeyCount = passkeyCount,

            // Account info
            AccountCreatedAt = user.CreatedAt,
            LastLoginAt = lastLogin != default ? lastLogin : null,

            // Overall status
            VerificationScore = CalculateVerificationScore(user.IsEmailVerified, isIdentityVerified, passkeyCount > 0)
        };
    }

    private static string MaskEmail(string email)
    {
        var parts = email.Split('@');
        if (parts.Length != 2) return "***@***";

        var local = parts[0];
        var domain = parts[1];

        if (local.Length <= 2)
            return $"{local[0]}***@{domain}";

        return $"{local[0]}{local[1]}***@{domain}";
    }

    private static int CalculateVerificationScore(bool emailVerified, bool identityVerified, bool passkeyEnabled)
    {
        var score = 0;

        if (emailVerified) score += 25;
        if (identityVerified) score += 50;
        if (passkeyEnabled) score += 25;

        return score;
    }

    #endregion

    #region Vault Health

    public async Task<VaultHealthResponse> GetVaultHealthAsync(Guid userId)
    {
        var receiptsCount = await _context.ReceiptEvidences
            .CountAsync(r => r.UserId == userId);

        var screenshotsCount = await _context.ScreenshotEvidences
            .CountAsync(s => s.UserId == userId);

        var profileLinksCount = await _context.ProfileLinkEvidences
            .CountAsync(p => p.UserId == userId);

        // For now, assume all evidence is healthy (full integrity check would verify Azure Blob hashes)
        return new VaultHealthResponse
        {
            IsHealthy = true,
            ReceiptsCount = receiptsCount,
            ScreenshotsCount = screenshotsCount,
            ProfileLinksCount = profileLinksCount,
            TotalEvidenceCount = receiptsCount + screenshotsCount + profileLinksCount,
            LastCheckedAt = DateTime.UtcNow,
            Issues = new List<string>() // Would contain integrity issues if any
        };
    }

    #endregion

    #region Breach Check

    public Task<BreachCheckResponse> CheckEmailBreachAsync(string email)
    {
        // PLACEHOLDER: Requires HaveIBeenPwned API key
        // This would use k-anonymity (SHA-1 hash prefix) to check breaches privately

        _logger.LogInformation("Breach check requested for email (hash prefix would be sent to HIBP API)");

        return Task.FromResult(new BreachCheckResponse
        {
            Email = MaskEmail(email),
            Checked = false,
            Message = "Breach scanning requires HaveIBeenPwned API integration. This feature will be enabled once the API key is configured.",
            Breaches = new List<BreachInfo>(),
            BreachCount = 0,
            RequiresExternalService = true
        });
    }

    #endregion
}

#region Response Models

public class LoginHistoryResponse
{
    public List<LoginEntry> Logins { get; set; } = new();
    public int TotalCount { get; set; }
}

public class LoginEntry
{
    public Guid Id { get; set; }
    public DateTime Timestamp { get; set; }
    public string? IpAddress { get; set; }
    public string? DeviceId { get; set; }
    public string? DeviceModel { get; set; }
    public string? OS { get; set; }
    public string? Browser { get; set; }
    public bool IsTrusted { get; set; }
    public DateTime ExpiresAt { get; set; }
    public bool IsActive { get; set; }
}

public class UserRiskStatusResponse
{
    public int RiskScore { get; set; }
    public string RiskLevel { get; set; } = "None";
    public List<RiskSignalResponse> ActiveSignals { get; set; } = new();
    public int SignalCount { get; set; }
    public DateTime LastUpdated { get; set; }
}

public class RiskSignalResponse
{
    public Guid Id { get; set; }
    public string Type { get; set; } = string.Empty;
    public int Severity { get; set; }
    public string Message { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
    public bool IsResolved { get; set; }
}

public class SecurityAlertResponse
{
    public Guid Id { get; set; }
    public string Type { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public string Message { get; set; } = string.Empty;
    public int Severity { get; set; }
    public bool IsRead { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class IdentityStatusResponse
{
    public bool IdentityVerified { get; set; }
    public DateTime? IdentityVerificationDate { get; set; }
    public string? IdentityProvider { get; set; }

    public bool EmailVerified { get; set; }
    public string Email { get; set; } = string.Empty;

    public bool PasskeyEnabled { get; set; }
    public int PasskeyCount { get; set; }

    public DateTime AccountCreatedAt { get; set; }
    public DateTime? LastLoginAt { get; set; }

    public int VerificationScore { get; set; }
}

public class VaultHealthResponse
{
    public bool IsHealthy { get; set; }
    public int ReceiptsCount { get; set; }
    public int ScreenshotsCount { get; set; }
    public int ProfileLinksCount { get; set; }
    public int TotalEvidenceCount { get; set; }
    public DateTime LastCheckedAt { get; set; }
    public List<string> Issues { get; set; } = new();
}

public class BreachCheckResponse
{
    public string Email { get; set; } = string.Empty;
    public bool Checked { get; set; }
    public string? Message { get; set; }
    public List<BreachInfo> Breaches { get; set; } = new();
    public int BreachCount { get; set; }
    public bool RequiresExternalService { get; set; }
}

public class BreachInfo
{
    public string Name { get; set; } = string.Empty;
    public DateTime Date { get; set; }
    public List<string> CompromisedData { get; set; } = new();
    public bool IsVerified { get; set; }
}

#endregion
