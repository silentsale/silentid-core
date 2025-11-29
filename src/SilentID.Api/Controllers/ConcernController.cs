using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Models;
using SilentID.Api.Services;
using System.Security.Claims;

namespace SilentID.Api.Controllers;

/// <summary>
/// Controller for profile concerns (safety flags on public profiles).
/// Uses neutral, safe language as per SilentID spec.
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class ConcernController : ControllerBase
{
    private readonly ProfileConcernService _concernService;
    private readonly ILogger<ConcernController> _logger;

    public ConcernController(
        ProfileConcernService concernService,
        ILogger<ConcernController> logger)
    {
        _concernService = concernService;
        _logger = logger;
    }

    /// <summary>
    /// Submit a concern about a public profile.
    /// Rate limited: max 3 per day, max 1 per profile per week.
    /// </summary>
    [HttpPost]
    [Authorize]
    [ProducesResponseType(typeof(SubmitConcernResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status429TooManyRequests)]
    public async Task<IActionResult> SubmitConcern([FromBody] SubmitConcernRequest request)
    {
        var userId = GetCurrentUserId();
        if (userId == null)
        {
            return Unauthorized();
        }

        // Get client IP and device info
        var ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString();
        var deviceInfo = Request.Headers.UserAgent.ToString();

        var result = await _concernService.SubmitConcernAsync(
            request.ReportedUserId,
            userId,
            request.Reason,
            request.Notes,
            ipAddress,
            deviceInfo
        );

        if (!result.IsSuccess)
        {
            // Check if it's a rate limit error
            if (result.ErrorMessage?.Contains("limit") == true ||
                result.ErrorMessage?.Contains("already reported") == true)
            {
                return StatusCode(429, new { error = result.ErrorMessage });
            }

            return BadRequest(new { error = result.ErrorMessage });
        }

        return Ok(new SubmitConcernResponse
        {
            Success = true,
            Message = "Thanks — our team will privately review this concern.",
            ConcernId = result.ConcernId
        });
    }

    private Guid? GetCurrentUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value
                       ?? User.FindFirst("sub")?.Value;

        return Guid.TryParse(userIdClaim, out var userId) ? userId : null;
    }
}

/// <summary>
/// Request to submit a profile concern.
/// </summary>
public class SubmitConcernRequest
{
    /// <summary>
    /// User ID of the profile being flagged.
    /// </summary>
    public Guid ReportedUserId { get; set; }

    /// <summary>
    /// Reason for the concern.
    /// </summary>
    public ConcernReason Reason { get; set; }

    /// <summary>
    /// Optional additional notes (max 400 chars).
    /// </summary>
    public string? Notes { get; set; }
}

/// <summary>
/// Response after submitting a concern.
/// </summary>
public class SubmitConcernResponse
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public Guid ConcernId { get; set; }
}
