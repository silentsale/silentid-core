using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;
using System.Text.Json;

namespace SilentID.Api.Services;

/// <summary>
/// Push Notification Service per Section 50.2
/// Handles FCM (Android) and APNS (iOS) notifications
/// </summary>
public interface IPushNotificationService
{
    /// <summary>
    /// Register a device token for push notifications
    /// </summary>
    Task<PushNotificationToken> RegisterTokenAsync(Guid userId, string token, string platform, string deviceId);

    /// <summary>
    /// Unregister a device token
    /// </summary>
    Task UnregisterTokenAsync(Guid userId, string deviceId);

    /// <summary>
    /// Send notification to a specific user
    /// </summary>
    Task<bool> SendToUserAsync(Guid userId, NotificationType type, string title, string body, Dictionary<string, string>? data = null);

    /// <summary>
    /// Send notification to multiple users
    /// </summary>
    Task<int> SendToUsersAsync(IEnumerable<Guid> userIds, NotificationType type, string title, string body, Dictionary<string, string>? data = null);

    /// <summary>
    /// Send notification to all users (broadcast)
    /// </summary>
    Task<int> BroadcastAsync(NotificationType type, string title, string body, Dictionary<string, string>? data = null);
}

public class PushNotificationService : IPushNotificationService
{
    private readonly SilentIdDbContext _db;
    private readonly ILogger<PushNotificationService> _logger;
    private readonly IConfiguration _configuration;
    private readonly HttpClient _httpClient;

    // FCM endpoint
    private const string FcmEndpoint = "https://fcm.googleapis.com/fcm/send";

    public PushNotificationService(
        SilentIdDbContext db,
        ILogger<PushNotificationService> logger,
        IConfiguration configuration,
        IHttpClientFactory httpClientFactory)
    {
        _db = db;
        _logger = logger;
        _configuration = configuration;
        _httpClient = httpClientFactory.CreateClient("FCM");
    }

    public async Task<PushNotificationToken> RegisterTokenAsync(Guid userId, string token, string platform, string deviceId)
    {
        // Check for existing token for this device
        var existingToken = await _db.PushNotificationTokens
            .FirstOrDefaultAsync(t => t.UserId == userId && t.DeviceId == deviceId);

        if (existingToken != null)
        {
            // Update existing token
            existingToken.Token = token;
            existingToken.Platform = platform.ToLower();
            existingToken.IsActive = true;
            existingToken.FailureCount = 0;
            existingToken.UpdatedAt = DateTime.UtcNow;
        }
        else
        {
            // Create new token
            existingToken = new PushNotificationToken
            {
                UserId = userId,
                Token = token,
                Platform = platform.ToLower(),
                DeviceId = deviceId
            };
            _db.PushNotificationTokens.Add(existingToken);
        }

        await _db.SaveChangesAsync();

        _logger.LogInformation("Push token registered for user {UserId} on {Platform}", userId, platform);

        return existingToken;
    }

    public async Task UnregisterTokenAsync(Guid userId, string deviceId)
    {
        var token = await _db.PushNotificationTokens
            .FirstOrDefaultAsync(t => t.UserId == userId && t.DeviceId == deviceId);

        if (token != null)
        {
            token.IsActive = false;
            token.UpdatedAt = DateTime.UtcNow;
            await _db.SaveChangesAsync();

            _logger.LogInformation("Push token unregistered for user {UserId}", userId);
        }
    }

    public async Task<bool> SendToUserAsync(Guid userId, NotificationType type, string title, string body, Dictionary<string, string>? data = null)
    {
        var tokens = await _db.PushNotificationTokens
            .Where(t => t.UserId == userId && t.IsActive && t.FailureCount < 3)
            .ToListAsync();

        if (!tokens.Any())
        {
            _logger.LogDebug("No active push tokens for user {UserId}", userId);
            return false;
        }

        var success = false;
        foreach (var token in tokens)
        {
            var result = await SendNotificationAsync(token, type, title, body, data);
            if (result)
            {
                success = true;
                token.LastUsedAt = DateTime.UtcNow;
                token.FailureCount = 0;
            }
            else
            {
                token.FailureCount++;
                if (token.FailureCount >= 3)
                {
                    token.IsActive = false;
                    _logger.LogWarning("Push token deactivated after 3 failures for user {UserId}", userId);
                }
            }
        }

        await _db.SaveChangesAsync();
        return success;
    }

    public async Task<int> SendToUsersAsync(IEnumerable<Guid> userIds, NotificationType type, string title, string body, Dictionary<string, string>? data = null)
    {
        var successCount = 0;

        foreach (var userId in userIds)
        {
            var result = await SendToUserAsync(userId, type, title, body, data);
            if (result) successCount++;
        }

        return successCount;
    }

    public async Task<int> BroadcastAsync(NotificationType type, string title, string body, Dictionary<string, string>? data = null)
    {
        var userIds = await _db.PushNotificationTokens
            .Where(t => t.IsActive)
            .Select(t => t.UserId)
            .Distinct()
            .ToListAsync();

        return await SendToUsersAsync(userIds, type, title, body, data);
    }

    private async Task<bool> SendNotificationAsync(PushNotificationToken token, NotificationType type, string title, string body, Dictionary<string, string>? data)
    {
        try
        {
            var fcmKey = _configuration["Firebase:ServerKey"];

            if (string.IsNullOrEmpty(fcmKey))
            {
                _logger.LogWarning("Firebase Server Key not configured - notification not sent");
                return false;
            }

            var payload = new
            {
                to = token.Token,
                notification = new
                {
                    title,
                    body,
                    sound = "default",
                    badge = 1
                },
                data = new Dictionary<string, string>(data ?? new Dictionary<string, string>())
                {
                    ["type"] = type.ToString(),
                    ["timestamp"] = DateTime.UtcNow.ToString("O")
                },
                priority = "high"
            };

            var request = new HttpRequestMessage(HttpMethod.Post, FcmEndpoint)
            {
                Content = new StringContent(JsonSerializer.Serialize(payload), System.Text.Encoding.UTF8, "application/json")
            };
            request.Headers.TryAddWithoutValidation("Authorization", $"key={fcmKey}");

            var response = await _httpClient.SendAsync(request);

            if (response.IsSuccessStatusCode)
            {
                _logger.LogDebug("Push notification sent to {Platform} device", token.Platform);
                return true;
            }

            var responseBody = await response.Content.ReadAsStringAsync();
            _logger.LogWarning("FCM request failed: {StatusCode} - {Response}", response.StatusCode, responseBody);
            return false;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to send push notification to {Platform} device", token.Platform);
            return false;
        }
    }
}

/// <summary>
/// Notification helper for common notification scenarios
/// </summary>
public static class NotificationTemplates
{
    public static (string Title, string Body) GetTrustScoreUpdate(int oldScore, int newScore)
    {
        var change = newScore - oldScore;
        var direction = change >= 0 ? "increased" : "decreased";
        return (
            "TrustScore Updated",
            $"Your TrustScore has {direction} to {newScore} ({(change >= 0 ? "+" : "")}{change})"
        );
    }

    public static (string Title, string Body) GetEvidenceVerified(string evidenceType)
    {
        return (
            "Evidence Verified",
            $"Your {evidenceType} has been verified and added to your trust profile"
        );
    }

    public static (string Title, string Body) GetNewLoginDetected(string deviceInfo, string location)
    {
        return (
            "New Login Detected",
            $"New sign-in from {deviceInfo} in {location}. If this wasn't you, secure your account now."
        );
    }

    public static (string Title, string Body) GetSecurityAlert(string message)
    {
        return (
            "Security Alert",
            message
        );
    }

    public static (string Title, string Body) GetAchievementUnlocked(string achievementName)
    {
        return (
            "Achievement Unlocked!",
            $"Congratulations! You've earned the \"{achievementName}\" badge"
        );
    }

    public static (string Title, string Body) GetReferralBonus(int bonusPoints)
    {
        return (
            "Referral Bonus Earned",
            $"Your friend joined SilentID! You've earned +{bonusPoints} TrustScore points"
        );
    }
}
