using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Services;

namespace SilentID.Api.Controllers;

[ApiController]
[Route("v1/mutual-verifications")]
[Authorize]
public class MutualVerificationController : ControllerBase
{
    private readonly IMutualVerificationService _service;
    private readonly ILogger<MutualVerificationController> _logger;

    public MutualVerificationController(
        IMutualVerificationService service,
        ILogger<MutualVerificationController> logger)
    {
        _service = service;
        _logger = logger;
    }

    /// <summary>
    /// Create a mutual verification request.
    /// </summary>
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateMutualVerificationRequest request)
    {
        try
        {
            var userId = GetUserIdFromToken();
            var verification = await _service.CreateVerificationAsync(userId, request);

            return CreatedAtAction(nameof(GetById), new { id = verification.Id }, new
            {
                id = verification.Id,
                otherUser = verification.UserBId,
                item = verification.Item,
                amount = verification.Amount,
                currency = verification.Currency,
                date = verification.Date,
                status = verification.Status.ToString(),
                message = "Verification request created. Waiting for other party to confirm."
            });
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { error = "user_not_found", message = ex.Message });
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { error = "invalid_request", message = ex.Message });
        }
    }

    /// <summary>
    /// Get incoming verification requests (where you are UserB).
    /// </summary>
    [HttpGet("incoming")]
    public async Task<IActionResult> GetIncoming()
    {
        var userId = GetUserIdFromToken();
        var requests = await _service.GetIncomingRequestsAsync(userId);

        return Ok(new
        {
            incoming = requests.Select(r => new
            {
                id = r.Id,
                from = new
                {
                    username = r.UserA.Username,
                    displayName = r.UserA.DisplayName
                },
                item = r.Item,
                amount = r.Amount,
                currency = r.Currency,
                theirRole = r.RoleA.ToString(),
                yourRole = r.RoleB.ToString(),
                date = r.Date,
                status = r.Status.ToString(),
                createdAt = r.CreatedAt
            }),
            count = requests.Count
        });
    }

    /// <summary>
    /// Respond to a verification request (confirm or reject).
    /// </summary>
    [HttpPost("{id}/respond")]
    public async Task<IActionResult> Respond(Guid id, [FromBody] RespondToVerificationRequest request)
    {
        try
        {
            var userId = GetUserIdFromToken();
            var verification = await _service.RespondToVerificationAsync(
                userId, id, request.Status, request.Reason);

            return Ok(new
            {
                id = verification.Id,
                status = verification.Status.ToString(),
                message = $"Verification {request.Status.ToLower()}."
            });
        }
        catch (KeyNotFoundException)
        {
            return NotFound(new { error = "verification_not_found", message = "Verification not found" });
        }
        catch (UnauthorizedAccessException)
        {
            return Forbid();
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { error = "invalid_operation", message = ex.Message });
        }
        catch (ArgumentException ex)
        {
            return BadRequest(new { error = "invalid_status", message = ex.Message });
        }
    }

    /// <summary>
    /// Get all verifications (sent and received).
    /// </summary>
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var userId = GetUserIdFromToken();
        var verifications = await _service.GetMyVerificationsAsync(userId);

        return Ok(new
        {
            verifications = verifications.Select(v => new
            {
                id = v.Id,
                participants = new
                {
                    you = v.UserAId == userId ? v.RoleA.ToString() : v.RoleB.ToString(),
                    them = new
                    {
                        username = v.UserAId == userId ? v.UserB.Username : v.UserA.Username,
                        displayName = v.UserAId == userId ? v.UserB.DisplayName : v.UserA.DisplayName,
                        role = v.UserAId == userId ? v.RoleB.ToString() : v.RoleA.ToString()
                    }
                },
                item = v.Item,
                amount = v.Amount,
                currency = v.Currency,
                date = v.Date,
                status = v.Status.ToString(),
                initiatedByYou = v.UserAId == userId,
                createdAt = v.CreatedAt
            }),
            count = verifications.Count
        });
    }

    /// <summary>
    /// Get verification details by ID.
    /// </summary>
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var verification = await _service.GetVerificationByIdAsync(id);
        if (verification == null)
        {
            return NotFound(new { error = "verification_not_found", message = "Verification not found" });
        }

        var userId = GetUserIdFromToken();

        // Only participants can view
        if (verification.UserAId != userId && verification.UserBId != userId)
        {
            return Forbid();
        }

        return Ok(new
        {
            id = verification.Id,
            participants = new
            {
                userA = new
                {
                    username = verification.UserA.Username,
                    displayName = verification.UserA.DisplayName,
                    role = verification.RoleA.ToString()
                },
                userB = new
                {
                    username = verification.UserB.Username,
                    displayName = verification.UserB.DisplayName,
                    role = verification.RoleB.ToString()
                }
            },
            item = verification.Item,
            amount = verification.Amount,
            currency = verification.Currency,
            date = verification.Date,
            status = verification.Status.ToString(),
            createdAt = verification.CreatedAt,
            updatedAt = verification.UpdatedAt
        });
    }

    private Guid GetUserIdFromToken()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (string.IsNullOrEmpty(userIdClaim))
        {
            throw new UnauthorizedAccessException("User ID not found in token");
        }
        return Guid.Parse(userIdClaim);
    }
}
