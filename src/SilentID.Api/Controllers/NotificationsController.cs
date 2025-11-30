using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Services;
using System.Security.Claims;

namespace SilentID.Api.Controllers;

/// <summary>
/// In-app notification management endpoints
/// SilentID uses email + in-app notifications only (no FCM/APNS)
/// </summary>
[ApiController]
[Route("api/v1/notifications")]
[Authorize]
public class NotificationsController : ControllerBase
{
    private readonly INotificationService _notificationService;
    private readonly ILogger<NotificationsController> _logger;

    public NotificationsController(
        INotificationService notificationService,
        ILogger<NotificationsController> logger)
    {
        _notificationService = notificationService;
        _logger = logger;
    }

    /// <summary>
    /// Get all notifications for current user (paginated)
    /// </summary>
    [HttpGet]
    public async Task<IActionResult> GetNotifications([FromQuery] int skip = 0, [FromQuery] int take = 20)
    {
        var userId = GetUserId();
        if (userId == null)
            return Unauthorized();

        var notifications = await _notificationService.GetAllAsync(userId.Value, skip, take);

        return Ok(new
        {
            notifications = notifications.Select(n => new
            {
                n.Id,
                type = n.Type.ToString(),
                n.Title,
                n.Body,
                n.ActionUrl,
                n.IsRead,
                n.ReadAt,
                n.CreatedAt
            }),
            hasMore = notifications.Count == take
        });
    }

    /// <summary>
    /// Get unread notifications for current user
    /// </summary>
    [HttpGet("unread")]
    public async Task<IActionResult> GetUnreadNotifications()
    {
        var userId = GetUserId();
        if (userId == null)
            return Unauthorized();

        var notifications = await _notificationService.GetUnreadAsync(userId.Value);

        return Ok(new
        {
            notifications = notifications.Select(n => new
            {
                n.Id,
                type = n.Type.ToString(),
                n.Title,
                n.Body,
                n.ActionUrl,
                n.CreatedAt
            }),
            count = notifications.Count
        });
    }

    /// <summary>
    /// Get unread notification count for current user
    /// </summary>
    [HttpGet("count")]
    public async Task<IActionResult> GetUnreadCount()
    {
        var userId = GetUserId();
        if (userId == null)
            return Unauthorized();

        var count = await _notificationService.GetUnreadCountAsync(userId.Value);

        return Ok(new { unreadCount = count });
    }

    /// <summary>
    /// Mark a specific notification as read
    /// </summary>
    [HttpPost("{notificationId:guid}/read")]
    public async Task<IActionResult> MarkAsRead(Guid notificationId)
    {
        var userId = GetUserId();
        if (userId == null)
            return Unauthorized();

        await _notificationService.MarkAsReadAsync(notificationId);

        return Ok(new { success = true });
    }

    /// <summary>
    /// Mark all notifications as read for current user
    /// </summary>
    [HttpPost("read-all")]
    public async Task<IActionResult> MarkAllAsRead()
    {
        var userId = GetUserId();
        if (userId == null)
            return Unauthorized();

        await _notificationService.MarkAllAsReadAsync(userId.Value);

        _logger.LogInformation("All notifications marked as read for user {UserId}", userId);

        return Ok(new { success = true });
    }

    private Guid? GetUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            return null;
        }
        return userId;
    }
}
