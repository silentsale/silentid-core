using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Services;
using System.Security.Claims;

namespace SilentID.Api.Controllers;

/// <summary>
/// Push notification management endpoints per Section 50.2
/// </summary>
[ApiController]
[Route("api/v1/notifications")]
[Authorize]
public class NotificationsController : ControllerBase
{
    private readonly IPushNotificationService _pushService;
    private readonly ILogger<NotificationsController> _logger;

    public NotificationsController(
        IPushNotificationService pushService,
        ILogger<NotificationsController> logger)
    {
        _pushService = pushService;
        _logger = logger;
    }

    /// <summary>
    /// Register a device for push notifications
    /// </summary>
    [HttpPost("register")]
    public async Task<IActionResult> RegisterToken([FromBody] RegisterTokenRequest request)
    {
        var userId = GetUserId();
        if (userId == null)
            return Unauthorized();

        if (string.IsNullOrEmpty(request.Token) || string.IsNullOrEmpty(request.Platform) || string.IsNullOrEmpty(request.DeviceId))
        {
            return BadRequest(new { error = "Token, platform, and deviceId are required" });
        }

        var platform = request.Platform.ToLower();
        if (platform != "ios" && platform != "android")
        {
            return BadRequest(new { error = "Platform must be 'ios' or 'android'" });
        }

        var token = await _pushService.RegisterTokenAsync(userId.Value, request.Token, platform, request.DeviceId);

        _logger.LogInformation("Push token registered for user {UserId} on {Platform}", userId, platform);

        return Ok(new
        {
            success = true,
            message = "Push notification token registered successfully",
            tokenId = token.Id
        });
    }

    /// <summary>
    /// Unregister a device from push notifications
    /// </summary>
    [HttpDelete("unregister")]
    public async Task<IActionResult> UnregisterToken([FromBody] UnregisterTokenRequest request)
    {
        var userId = GetUserId();
        if (userId == null)
            return Unauthorized();

        if (string.IsNullOrEmpty(request.DeviceId))
        {
            return BadRequest(new { error = "DeviceId is required" });
        }

        await _pushService.UnregisterTokenAsync(userId.Value, request.DeviceId);

        return Ok(new
        {
            success = true,
            message = "Push notification token unregistered successfully"
        });
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

public class RegisterTokenRequest
{
    public string Token { get; set; } = string.Empty;
    public string Platform { get; set; } = string.Empty;
    public string DeviceId { get; set; } = string.Empty;
}

public class UnregisterTokenRequest
{
    public string DeviceId { get; set; } = string.Empty;
}
