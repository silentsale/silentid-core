using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Services;
using System.Security.Claims;

namespace SilentID.Api.Controllers;

/// <summary>
/// Referral Program API endpoints (Section 50.6.1)
/// "Invite a friend → both get +50 TrustScore bonus once identity is verified."
/// </summary>
[ApiController]
[Route("v1/referrals")]
[Authorize]
public class ReferralController : ControllerBase
{
    private readonly IReferralService _referralService;
    private readonly ILogger<ReferralController> _logger;

    public ReferralController(
        IReferralService referralService,
        ILogger<ReferralController> logger)
    {
        _referralService = referralService;
        _logger = logger;
    }

    /// <summary>
    /// Get current user's referral summary (code, link, stats)
    /// </summary>
    /// <returns>Referral code, link, and statistics</returns>
    [HttpGet("me")]
    [ProducesResponseType(typeof(ReferralSummaryResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> GetMyReferralSummary()
    {
        var userId = GetUserId();
        if (userId == null)
        {
            return Unauthorized();
        }

        try
        {
            var summary = await _referralService.GetReferralSummaryAsync(userId.Value);

            return Ok(new ReferralSummaryResponse
            {
                ReferralCode = summary.ReferralCode,
                ReferralLink = summary.ReferralLink,
                TotalReferrals = summary.TotalReferrals,
                CompletedReferrals = summary.CompletedReferrals,
                PendingReferrals = summary.PendingReferrals,
                TotalPointsEarned = summary.TotalPointsEarned
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting referral summary for user {UserId}", userId);
            return StatusCode(500, new { error = "Failed to get referral summary" });
        }
    }

    /// <summary>
    /// Get list of referrals made by the current user
    /// </summary>
    /// <returns>List of referrals with status and points</returns>
    [HttpGet("me/referrals")]
    [ProducesResponseType(typeof(ReferralsListResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> GetMyReferrals()
    {
        var userId = GetUserId();
        if (userId == null)
        {
            return Unauthorized();
        }

        try
        {
            var referrals = await _referralService.GetReferralsByUserAsync(userId.Value);

            return Ok(new ReferralsListResponse
            {
                Referrals = referrals.Select(r => new ReferralItemResponse
                {
                    Id = r.Id,
                    Name = r.RefereeName,
                    Initials = r.RefereeInitials,
                    Status = r.Status.ToString().ToLowerInvariant(),
                    PointsEarned = r.PointsEarned,
                    InvitedAt = r.InvitedAt,
                    SignedUpAt = r.SignedUpAt,
                    CompletedAt = r.CompletedAt
                }).ToList()
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting referrals for user {UserId}", userId);
            return StatusCode(500, new { error = "Failed to get referrals" });
        }
    }

    /// <summary>
    /// Validate a referral code (public endpoint for sign-up flow)
    /// </summary>
    /// <param name="code">The referral code to validate</param>
    /// <returns>Whether the code is valid</returns>
    [HttpGet("validate/{code}")]
    [AllowAnonymous]
    [ProducesResponseType(typeof(ValidateCodeResponse), StatusCodes.Status200OK)]
    public async Task<IActionResult> ValidateReferralCode(string code)
    {
        if (string.IsNullOrWhiteSpace(code))
        {
            return Ok(new ValidateCodeResponse { IsValid = false });
        }

        try
        {
            var isValid = await _referralService.ValidateReferralCodeAsync(code);
            return Ok(new ValidateCodeResponse { IsValid = isValid });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error validating referral code {Code}", code);
            return Ok(new ValidateCodeResponse { IsValid = false });
        }
    }

    /// <summary>
    /// Apply a referral code to the current user (used during sign-up)
    /// </summary>
    /// <param name="request">The referral code to apply</param>
    /// <returns>Success or failure</returns>
    [HttpPost("apply")]
    [ProducesResponseType(typeof(ApplyReferralResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status401Unauthorized)]
    public async Task<IActionResult> ApplyReferralCode([FromBody] ApplyReferralRequest request)
    {
        var userId = GetUserId();
        if (userId == null)
        {
            return Unauthorized();
        }

        if (string.IsNullOrWhiteSpace(request.ReferralCode))
        {
            return BadRequest(new { error = "Referral code is required" });
        }

        try
        {
            var success = await _referralService.ApplyReferralCodeAsync(userId.Value, request.ReferralCode);

            if (success)
            {
                return Ok(new ApplyReferralResponse
                {
                    Success = true,
                    Message = "Referral code applied! You'll both receive +50 TrustScore bonus when you verify your identity."
                });
            }
            else
            {
                return Ok(new ApplyReferralResponse
                {
                    Success = false,
                    Message = "Invalid referral code or already used."
                });
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error applying referral code for user {UserId}", userId);
            return StatusCode(500, new { error = "Failed to apply referral code" });
        }
    }

    private Guid? GetUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (Guid.TryParse(userIdClaim, out var userId))
        {
            return userId;
        }
        return null;
    }
}

// Response DTOs

public class ReferralSummaryResponse
{
    public string ReferralCode { get; set; } = string.Empty;
    public string ReferralLink { get; set; } = string.Empty;
    public int TotalReferrals { get; set; }
    public int CompletedReferrals { get; set; }
    public int PendingReferrals { get; set; }
    public int TotalPointsEarned { get; set; }
}

public class ReferralsListResponse
{
    public List<ReferralItemResponse> Referrals { get; set; } = new();
}

public class ReferralItemResponse
{
    public Guid Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Initials { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public int PointsEarned { get; set; }
    public DateTime InvitedAt { get; set; }
    public DateTime? SignedUpAt { get; set; }
    public DateTime? CompletedAt { get; set; }
}

public class ValidateCodeResponse
{
    public bool IsValid { get; set; }
}

public class ApplyReferralRequest
{
    public string ReferralCode { get; set; } = string.Empty;
}

public class ApplyReferralResponse
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
}
