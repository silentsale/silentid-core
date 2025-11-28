using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Services;
using System.Security.Claims;

namespace SilentID.Api.Controllers;

/// <summary>
/// Security Center API endpoints (Section 15).
/// Provides login history, risk status, security alerts, identity status, and vault health.
/// </summary>
[ApiController]
[Route("v1/security")]
[Authorize]
public class SecurityController : ControllerBase
{
    private readonly ISecurityCenterService _securityService;
    private readonly ILogger<SecurityController> _logger;

    public SecurityController(ISecurityCenterService securityService, ILogger<SecurityController> logger)
    {
        _securityService = securityService;
        _logger = logger;
    }

    private Guid GetUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value
            ?? User.FindFirst("sub")?.Value;

        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            throw new UnauthorizedAccessException("Invalid user token");
        }

        return userId;
    }

    #region Login History

    /// <summary>
    /// Get login activity history for the authenticated user.
    /// </summary>
    /// <param name="limit">Maximum number of entries to return (default 50, max 100)</param>
    [HttpGet("login-history")]
    [ProducesResponseType(typeof(LoginHistoryResponse), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetLoginHistory([FromQuery] int limit = 50)
    {
        try
        {
            var userId = GetUserId();
            limit = Math.Min(Math.Max(limit, 1), 100);

            var result = await _securityService.GetLoginHistoryAsync(userId, limit);
            return Ok(result);
        }
        catch (UnauthorizedAccessException)
        {
            return Unauthorized(new { error = "Invalid authentication" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting login history");
            return StatusCode(500, new { error = "Failed to retrieve login history" });
        }
    }

    #endregion

    #region Risk Status

    /// <summary>
    /// Get user's risk score and active risk signals.
    /// </summary>
    [HttpGet("risk-score")]
    [ProducesResponseType(typeof(UserRiskStatusResponse), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetRiskStatus()
    {
        try
        {
            var userId = GetUserId();
            var result = await _securityService.GetUserRiskStatusAsync(userId);
            return Ok(result);
        }
        catch (UnauthorizedAccessException)
        {
            return Unauthorized(new { error = "Invalid authentication" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting risk status");
            return StatusCode(500, new { error = "Failed to retrieve risk status" });
        }
    }

    #endregion

    #region Security Alerts

    /// <summary>
    /// Get security alerts for the authenticated user.
    /// </summary>
    /// <param name="includeRead">Include already read alerts (default false)</param>
    [HttpGet("alerts")]
    [ProducesResponseType(typeof(SecurityAlertsResponse), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAlerts([FromQuery] bool includeRead = false)
    {
        try
        {
            var userId = GetUserId();
            var alerts = await _securityService.GetSecurityAlertsAsync(userId, includeRead);
            var unreadCount = await _securityService.GetUnreadAlertCountAsync(userId);

            return Ok(new SecurityAlertsResponse
            {
                Alerts = alerts,
                UnreadCount = unreadCount,
                TotalCount = alerts.Count
            });
        }
        catch (UnauthorizedAccessException)
        {
            return Unauthorized(new { error = "Invalid authentication" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting security alerts");
            return StatusCode(500, new { error = "Failed to retrieve security alerts" });
        }
    }

    /// <summary>
    /// Get unread alert count for badge display.
    /// </summary>
    [HttpGet("alerts/count")]
    [ProducesResponseType(typeof(AlertCountResponse), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAlertCount()
    {
        try
        {
            var userId = GetUserId();
            var count = await _securityService.GetUnreadAlertCountAsync(userId);

            return Ok(new AlertCountResponse { UnreadCount = count });
        }
        catch (UnauthorizedAccessException)
        {
            return Unauthorized(new { error = "Invalid authentication" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting alert count");
            return StatusCode(500, new { error = "Failed to retrieve alert count" });
        }
    }

    /// <summary>
    /// Mark a specific alert as read.
    /// </summary>
    [HttpPost("alerts/{alertId}/mark-read")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> MarkAlertAsRead(Guid alertId)
    {
        try
        {
            var userId = GetUserId();
            await _securityService.MarkAlertAsReadAsync(userId, alertId);

            return Ok(new { success = true });
        }
        catch (UnauthorizedAccessException)
        {
            return Unauthorized(new { error = "Invalid authentication" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error marking alert as read");
            return StatusCode(500, new { error = "Failed to mark alert as read" });
        }
    }

    /// <summary>
    /// Mark all alerts as read.
    /// </summary>
    [HttpPost("alerts/mark-all-read")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public async Task<IActionResult> MarkAllAlertsAsRead()
    {
        try
        {
            var userId = GetUserId();
            await _securityService.MarkAllAlertsAsReadAsync(userId);

            return Ok(new { success = true });
        }
        catch (UnauthorizedAccessException)
        {
            return Unauthorized(new { error = "Invalid authentication" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error marking all alerts as read");
            return StatusCode(500, new { error = "Failed to mark alerts as read" });
        }
    }

    #endregion

    #region Identity Status

    /// <summary>
    /// Get identity verification status overview.
    /// </summary>
    [HttpGet("identity-status")]
    [ProducesResponseType(typeof(IdentityStatusResponse), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetIdentityStatus()
    {
        try
        {
            var userId = GetUserId();
            var result = await _securityService.GetIdentityStatusAsync(userId);
            return Ok(result);
        }
        catch (KeyNotFoundException)
        {
            return NotFound(new { error = "User not found" });
        }
        catch (UnauthorizedAccessException)
        {
            return Unauthorized(new { error = "Invalid authentication" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting identity status");
            return StatusCode(500, new { error = "Failed to retrieve identity status" });
        }
    }

    #endregion

    #region Vault Health

    /// <summary>
    /// Check evidence vault health and integrity.
    /// </summary>
    [HttpGet("vault-health")]
    [ProducesResponseType(typeof(VaultHealthResponse), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetVaultHealth()
    {
        try
        {
            var userId = GetUserId();
            var result = await _securityService.GetVaultHealthAsync(userId);
            return Ok(result);
        }
        catch (UnauthorizedAccessException)
        {
            return Unauthorized(new { error = "Invalid authentication" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting vault health");
            return StatusCode(500, new { error = "Failed to retrieve vault health" });
        }
    }

    #endregion

    #region Breach Check

    /// <summary>
    /// Check if email has appeared in known data breaches.
    /// Note: Requires HaveIBeenPwned API key to be configured.
    /// </summary>
    [HttpPost("breach-check")]
    [ProducesResponseType(typeof(BreachCheckResponse), StatusCodes.Status200OK)]
    public async Task<IActionResult> CheckBreach([FromBody] BreachCheckRequest request)
    {
        try
        {
            var userId = GetUserId();

            // Use provided email or user's account email
            var email = string.IsNullOrWhiteSpace(request.Email)
                ? User.FindFirst(ClaimTypes.Email)?.Value ?? ""
                : request.Email;

            if (string.IsNullOrWhiteSpace(email))
            {
                return BadRequest(new { error = "Email address is required" });
            }

            var result = await _securityService.CheckEmailBreachAsync(email);
            return Ok(result);
        }
        catch (UnauthorizedAccessException)
        {
            return Unauthorized(new { error = "Invalid authentication" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error checking breach");
            return StatusCode(500, new { error = "Failed to check for breaches" });
        }
    }

    #endregion

    #region Security Overview

    /// <summary>
    /// Get complete security center overview in a single call.
    /// </summary>
    [HttpGet("overview")]
    [ProducesResponseType(typeof(SecurityOverviewResponse), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetSecurityOverview()
    {
        try
        {
            var userId = GetUserId();

            // Fetch all data in parallel
            var identityStatusTask = _securityService.GetIdentityStatusAsync(userId);
            var riskStatusTask = _securityService.GetUserRiskStatusAsync(userId);
            var alertCountTask = _securityService.GetUnreadAlertCountAsync(userId);
            var vaultHealthTask = _securityService.GetVaultHealthAsync(userId);
            var loginHistoryTask = _securityService.GetLoginHistoryAsync(userId, 5);

            await Task.WhenAll(identityStatusTask, riskStatusTask, alertCountTask, vaultHealthTask, loginHistoryTask);

            return Ok(new SecurityOverviewResponse
            {
                IdentityStatus = await identityStatusTask,
                RiskStatus = await riskStatusTask,
                UnreadAlertCount = await alertCountTask,
                VaultHealth = await vaultHealthTask,
                RecentLogins = (await loginHistoryTask).Logins
            });
        }
        catch (KeyNotFoundException)
        {
            return NotFound(new { error = "User not found" });
        }
        catch (UnauthorizedAccessException)
        {
            return Unauthorized(new { error = "Invalid authentication" });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting security overview");
            return StatusCode(500, new { error = "Failed to retrieve security overview" });
        }
    }

    #endregion
}

#region Request/Response Models

public class BreachCheckRequest
{
    public string? Email { get; set; }
}

public class SecurityAlertsResponse
{
    public List<SecurityAlertResponse> Alerts { get; set; } = new();
    public int UnreadCount { get; set; }
    public int TotalCount { get; set; }
}

public class AlertCountResponse
{
    public int UnreadCount { get; set; }
}

public class SecurityOverviewResponse
{
    public IdentityStatusResponse IdentityStatus { get; set; } = null!;
    public UserRiskStatusResponse RiskStatus { get; set; } = null!;
    public int UnreadAlertCount { get; set; }
    public VaultHealthResponse VaultHealth { get; set; } = null!;
    public List<LoginEntry> RecentLogins { get; set; } = new();
}

#endregion
