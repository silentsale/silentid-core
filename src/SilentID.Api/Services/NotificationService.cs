using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

/// <summary>
/// Notification Service - Email + In-App only (no FCM/APNS)
/// Per user clarification: SilentID uses email and in-app notifications only
/// </summary>
public interface INotificationService
{
    /// <summary>
    /// Send notification to user (creates in-app + optional email)
    /// </summary>
    Task<InAppNotification> NotifyAsync(Guid userId, NotificationType type, string title, string body, bool sendEmail = false);

    /// <summary>
    /// Get unread notifications for user
    /// </summary>
    Task<List<InAppNotification>> GetUnreadAsync(Guid userId);

    /// <summary>
    /// Get all notifications for user (paginated)
    /// </summary>
    Task<List<InAppNotification>> GetAllAsync(Guid userId, int skip = 0, int take = 20);

    /// <summary>
    /// Mark notification as read
    /// </summary>
    Task MarkAsReadAsync(Guid notificationId);

    /// <summary>
    /// Mark all notifications as read for user
    /// </summary>
    Task MarkAllAsReadAsync(Guid userId);

    /// <summary>
    /// Get unread count for user
    /// </summary>
    Task<int> GetUnreadCountAsync(Guid userId);

    /// <summary>
    /// Delete old notifications (cleanup job)
    /// </summary>
    Task CleanupOldNotificationsAsync(int daysToKeep = 90);
}

public class NotificationService : INotificationService
{
    private readonly SilentIdDbContext _db;
    private readonly IEmailService _emailService;
    private readonly ILogger<NotificationService> _logger;

    public NotificationService(
        SilentIdDbContext db,
        IEmailService emailService,
        ILogger<NotificationService> logger)
    {
        _db = db;
        _emailService = emailService;
        _logger = logger;
    }

    public async Task<InAppNotification> NotifyAsync(Guid userId, NotificationType type, string title, string body, bool sendEmail = false)
    {
        // Create in-app notification
        var notification = new InAppNotification
        {
            UserId = userId,
            Type = type,
            Title = title,
            Body = body
        };

        _db.InAppNotifications.Add(notification);
        await _db.SaveChangesAsync();

        _logger.LogInformation("In-app notification created for user {UserId}: {Type}", userId, type);

        // Send email if requested
        if (sendEmail)
        {
            await SendEmailNotificationAsync(userId, type, title, body);
        }

        return notification;
    }

    public async Task<List<InAppNotification>> GetUnreadAsync(Guid userId)
    {
        return await _db.InAppNotifications
            .Where(n => n.UserId == userId && !n.IsRead)
            .OrderByDescending(n => n.CreatedAt)
            .Take(50)
            .ToListAsync();
    }

    public async Task<List<InAppNotification>> GetAllAsync(Guid userId, int skip = 0, int take = 20)
    {
        return await _db.InAppNotifications
            .Where(n => n.UserId == userId)
            .OrderByDescending(n => n.CreatedAt)
            .Skip(skip)
            .Take(take)
            .ToListAsync();
    }

    public async Task MarkAsReadAsync(Guid notificationId)
    {
        var notification = await _db.InAppNotifications.FindAsync(notificationId);
        if (notification != null && !notification.IsRead)
        {
            notification.IsRead = true;
            notification.ReadAt = DateTime.UtcNow;
            await _db.SaveChangesAsync();
        }
    }

    public async Task MarkAllAsReadAsync(Guid userId)
    {
        await _db.InAppNotifications
            .Where(n => n.UserId == userId && !n.IsRead)
            .ExecuteUpdateAsync(n => n
                .SetProperty(x => x.IsRead, true)
                .SetProperty(x => x.ReadAt, DateTime.UtcNow));
    }

    public async Task<int> GetUnreadCountAsync(Guid userId)
    {
        return await _db.InAppNotifications
            .CountAsync(n => n.UserId == userId && !n.IsRead);
    }

    public async Task CleanupOldNotificationsAsync(int daysToKeep = 90)
    {
        var cutoff = DateTime.UtcNow.AddDays(-daysToKeep);

        var deleted = await _db.InAppNotifications
            .Where(n => n.CreatedAt < cutoff && n.IsRead)
            .ExecuteDeleteAsync();

        _logger.LogInformation("Cleaned up {Count} old notifications", deleted);
    }

    private async Task SendEmailNotificationAsync(Guid userId, NotificationType type, string title, string body)
    {
        try
        {
            var user = await _db.Users.FindAsync(userId);
            if (user == null || string.IsNullOrEmpty(user.Email))
            {
                _logger.LogWarning("Cannot send email - user {UserId} not found or no email", userId);
                return;
            }

            // Only send email for important notification types
            var emailTypes = new[]
            {
                NotificationType.SecurityAlert,
                NotificationType.NewLoginDetected,
                NotificationType.SubscriptionReminder
            };

            if (!emailTypes.Contains(type))
            {
                return;
            }

            await _emailService.SendAccountSecurityAlertAsync(
                user.Email,
                $"{title}: {body}"
            );

            _logger.LogInformation("Email notification sent to {Email} for {Type}", user.Email, type);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to send email notification for user {UserId}", userId);
        }
    }

    private static string GetEmailTemplate(NotificationType type, string title, string body, string userName)
    {
        return type switch
        {
            NotificationType.SecurityAlert => $"""
                <h2>Security Alert</h2>
                <p>Hi {userName},</p>
                <p>{body}</p>
                <p>If this wasn't you, please secure your account immediately.</p>
                <p>- The SilentID Team</p>
                """,

            NotificationType.NewLoginDetected => $"""
                <h2>New Login Detected</h2>
                <p>Hi {userName},</p>
                <p>{body}</p>
                <p>If you don't recognize this activity, please review your security settings.</p>
                <p>- The SilentID Team</p>
                """,

            _ => $"""
                <h2>{title}</h2>
                <p>Hi {userName},</p>
                <p>{body}</p>
                <p>- The SilentID Team</p>
                """
        };
    }
}

/// <summary>
/// Notification helper for common notification scenarios
/// </summary>
public static class NotificationTemplates
{
    public static (string Title, string Body, bool SendEmail) GetTrustScoreUpdate(int oldScore, int newScore)
    {
        var change = newScore - oldScore;
        var direction = change >= 0 ? "increased" : "decreased";
        return (
            "TrustScore Updated",
            $"Your TrustScore has {direction} to {newScore} ({(change >= 0 ? "+" : "")}{change})",
            false // No email for score updates
        );
    }

    public static (string Title, string Body, bool SendEmail) GetEvidenceVerified(string evidenceType)
    {
        return (
            "Evidence Verified",
            $"Your {evidenceType} has been verified and added to your trust profile",
            false
        );
    }

    public static (string Title, string Body, bool SendEmail) GetNewLoginDetected(string deviceInfo, string location)
    {
        return (
            "New Login Detected",
            $"New sign-in from {deviceInfo} in {location}. If this wasn't you, secure your account now.",
            true // Send email for security
        );
    }

    public static (string Title, string Body, bool SendEmail) GetSecurityAlert(string message)
    {
        return (
            "Security Alert",
            message,
            true // Send email for security
        );
    }

    public static (string Title, string Body, bool SendEmail) GetAchievementUnlocked(string achievementName)
    {
        return (
            "Achievement Unlocked!",
            $"Congratulations! You've earned the \"{achievementName}\" badge",
            false
        );
    }

    public static (string Title, string Body, bool SendEmail) GetReferralBonus(int bonusPoints)
    {
        return (
            "Referral Bonus Earned",
            $"Your friend joined SilentID! You've earned +{bonusPoints} TrustScore points",
            false
        );
    }
}
