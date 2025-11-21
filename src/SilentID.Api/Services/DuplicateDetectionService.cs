using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

public interface IDuplicateDetectionService
{
    Task<DuplicateCheckResult> CheckForDuplicatesAsync(string email, string? deviceId = null, string? ipAddress = null);
    Task<DuplicateCheckResult> CheckOAuthProviderAsync(string? appleUserId, string? googleUserId);
    Task<bool> IsEmailAliasAsync(string email);
}

public class DuplicateDetectionService : IDuplicateDetectionService
{
    private readonly SilentIdDbContext _context;
    private readonly ILogger<DuplicateDetectionService> _logger;

    public DuplicateDetectionService(SilentIdDbContext context, ILogger<DuplicateDetectionService> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<DuplicateCheckResult> CheckForDuplicatesAsync(string email, string? deviceId = null, string? ipAddress = null)
    {
        email = email.ToLowerInvariant();

        var result = new DuplicateCheckResult
        {
            IsSuspicious = false,
            Reasons = new List<string>()
        };

        // Check if email already exists
        var existingUserByEmail = await _context.Users
            .FirstOrDefaultAsync(u => u.Email == email);

        if (existingUserByEmail != null)
        {
            result.ExistingUserId = existingUserByEmail.Id;
            result.IsSuspicious = true;
            result.Reasons.Add("Email already registered");
            _logger.LogWarning("Duplicate email detected: {Email}", email);
            return result;
        }

        // Check for email aliases (e.g., user+alias@gmail.com)
        if (IsEmailAliasPattern(email))
        {
            var baseEmail = GetBaseEmail(email);
            var baseEmailParts = baseEmail.Split('@');
            var localPart = baseEmailParts[0];
            var domain = baseEmailParts[1];

            var existingUserByAlias = await _context.Users
                .FirstOrDefaultAsync(u => u.Email.StartsWith(localPart) && u.Email.Contains(domain));

            if (existingUserByAlias != null)
            {
                result.ExistingUserId = existingUserByAlias.Id;
                result.IsSuspicious = true;
                result.Reasons.Add($"Email alias detected (base: {baseEmail})");
                _logger.LogWarning("Email alias detected: {Email} -> {BaseEmail}", email, baseEmail);
            }
        }

        // Check device fingerprint
        if (!string.IsNullOrWhiteSpace(deviceId))
        {
            var existingUserByDevice = await _context.Users
                .FirstOrDefaultAsync(u => u.SignupDeviceId == deviceId);

            if (existingUserByDevice != null)
            {
                result.SimilarUsers.Add(existingUserByDevice.Id);
                result.IsSuspicious = true;
                result.Reasons.Add("Device fingerprint matches existing account");
                _logger.LogWarning("Duplicate device detected: {DeviceId}", deviceId);
            }

            // Check if device is associated with multiple users via AuthDevices
            var deviceCount = await _context.AuthDevices
                .Where(d => d.DeviceId == deviceId)
                .Select(d => d.UserId)
                .Distinct()
                .CountAsync();

            if (deviceCount > 1)
            {
                result.IsSuspicious = true;
                result.Reasons.Add($"Device used by {deviceCount} accounts");
                _logger.LogWarning("Device {DeviceId} used by {Count} accounts", deviceId, deviceCount);
            }
        }

        // Check IP address patterns
        if (!string.IsNullOrWhiteSpace(ipAddress))
        {
            var usersWithSameIP = await _context.Users
                .Where(u => u.SignupIP == ipAddress)
                .CountAsync();

            if (usersWithSameIP >= 3)
            {
                result.IsSuspicious = true;
                result.Reasons.Add($"IP address used by {usersWithSameIP} accounts");
                _logger.LogWarning("Suspicious IP detected: {IP} used by {Count} accounts", ipAddress, usersWithSameIP);
            }
        }

        return result;
    }

    public async Task<DuplicateCheckResult> CheckOAuthProviderAsync(string? appleUserId, string? googleUserId)
    {
        var result = new DuplicateCheckResult
        {
            IsSuspicious = false,
            Reasons = new List<string>()
        };

        // Check Apple User ID
        if (!string.IsNullOrWhiteSpace(appleUserId))
        {
            var existingUserByApple = await _context.Users
                .FirstOrDefaultAsync(u => u.AppleUserId == appleUserId);

            if (existingUserByApple != null)
            {
                result.ExistingUserId = existingUserByApple.Id;
                result.IsSuspicious = true;
                result.Reasons.Add("Apple User ID already registered");
                _logger.LogInformation("Existing Apple User ID found: {AppleUserId} -> User {UserId}", appleUserId, existingUserByApple.Id);
                return result;
            }
        }

        // Check Google User ID
        if (!string.IsNullOrWhiteSpace(googleUserId))
        {
            var existingUserByGoogle = await _context.Users
                .FirstOrDefaultAsync(u => u.GoogleUserId == googleUserId);

            if (existingUserByGoogle != null)
            {
                result.ExistingUserId = existingUserByGoogle.Id;
                result.IsSuspicious = true;
                result.Reasons.Add("Google User ID already registered");
                _logger.LogInformation("Existing Google User ID found: {GoogleUserId} -> User {UserId}", googleUserId, existingUserByGoogle.Id);
                return result;
            }
        }

        return result;
    }

    public Task<bool> IsEmailAliasAsync(string email)
    {
        var isAlias = IsEmailAliasPattern(email);
        return Task.FromResult(isAlias);
    }

    private bool IsEmailAliasPattern(string email)
    {
        // Gmail, Outlook, and other providers support + aliases
        // Example: user+alias@gmail.com -> user@gmail.com
        var supportedDomains = new[] { "gmail.com", "googlemail.com", "outlook.com", "hotmail.com" };

        var emailParts = email.Split('@');
        if (emailParts.Length != 2) return false;

        var localPart = emailParts[0];
        var domain = emailParts[1].ToLowerInvariant();

        // Check if domain supports aliases
        if (!supportedDomains.Contains(domain)) return false;

        // Check if local part contains +
        return localPart.Contains('+');
    }

    private string GetBaseEmail(string email)
    {
        var emailParts = email.Split('@');
        if (emailParts.Length != 2) return email;

        var localPart = emailParts[0];
        var domain = emailParts[1];

        // Remove everything after + in local part
        if (localPart.Contains('+'))
        {
            localPart = localPart.Substring(0, localPart.IndexOf('+'));
        }

        // Gmail ignores dots in local part
        if (domain.Contains("gmail") || domain.Contains("googlemail"))
        {
            localPart = localPart.Replace(".", "");
        }

        return $"{localPart}@{domain}";
    }
}

public class DuplicateCheckResult
{
    public bool IsSuspicious { get; set; }
    public Guid? ExistingUserId { get; set; }
    public List<Guid> SimilarUsers { get; set; } = new();
    public List<string> Reasons { get; set; } = new();

    public bool HasExistingUser => ExistingUserId.HasValue;
    public bool HasSimilarUsers => SimilarUsers.Any();
}
