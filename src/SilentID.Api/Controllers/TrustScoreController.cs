using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Services;

namespace SilentID.Api.Controllers;

[ApiController]
[Route("v1/trustscore")]
[Authorize]
public class TrustScoreController : ControllerBase
{
    private readonly ITrustScoreService _trustScoreService;
    private readonly ILogger<TrustScoreController> _logger;

    public TrustScoreController(ITrustScoreService trustScoreService, ILogger<TrustScoreController> logger)
    {
        _trustScoreService = trustScoreService;
        _logger = logger;
    }

    private Guid GetUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            throw new UnauthorizedAccessException("Invalid user ID in token");
        }
        return userId;
    }

    /// <summary>
    /// GET /v1/trustscore/me - Get current TrustScore
    /// </summary>
    [HttpGet("me")]
    public async Task<IActionResult> GetMyTrustScore()
    {
        try
        {
            var userId = GetUserId();
            var snapshot = await _trustScoreService.GetCurrentTrustScoreAsync(userId);

            return Ok(new
            {
                totalScore = snapshot.Score,
                label = GetTrustLabel(snapshot.Score),
                identityScore = snapshot.IdentityScore,
                evidenceScore = snapshot.EvidenceScore,
                behaviourScore = snapshot.BehaviourScore,
                peerScore = snapshot.PeerScore,
                lastCalculated = snapshot.CreatedAt
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving TrustScore");
            return StatusCode(500, new { error = "internal_error", message = "Failed to retrieve TrustScore." });
        }
    }

    /// <summary>
    /// GET /v1/trustscore/me/breakdown - Get detailed TrustScore breakdown
    /// </summary>
    [HttpGet("me/breakdown")]
    public async Task<IActionResult> GetMyTrustScoreBreakdown()
    {
        try
        {
            var userId = GetUserId();
            var breakdown = await _trustScoreService.GetTrustScoreBreakdownAsync(userId);

            return Ok(new
            {
                totalScore = breakdown.TotalScore,
                label = breakdown.Label,
                components = new
                {
                    identity = new
                    {
                        score = breakdown.Identity.Score,
                        maxScore = breakdown.Identity.MaxScore,
                        items = breakdown.Identity.Items.Select(i => new
                        {
                            description = i.Description,
                            points = i.Points,
                            status = i.Status
                        })
                    },
                    evidence = new
                    {
                        score = breakdown.Evidence.Score,
                        maxScore = breakdown.Evidence.MaxScore,
                        items = breakdown.Evidence.Items.Select(i => new
                        {
                            description = i.Description,
                            points = i.Points,
                            status = i.Status
                        })
                    },
                    behaviour = new
                    {
                        score = breakdown.Behaviour.Score,
                        maxScore = breakdown.Behaviour.MaxScore,
                        items = breakdown.Behaviour.Items.Select(i => new
                        {
                            description = i.Description,
                            points = i.Points,
                            status = i.Status
                        })
                    },
                    peer = new
                    {
                        score = breakdown.Peer.Score,
                        maxScore = breakdown.Peer.MaxScore,
                        items = breakdown.Peer.Items.Select(i => new
                        {
                            description = i.Description,
                            points = i.Points,
                            status = i.Status
                        })
                    }
                }
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving TrustScore breakdown");
            return StatusCode(500, new { error = "internal_error", message = "Failed to retrieve TrustScore breakdown." });
        }
    }

    /// <summary>
    /// GET /v1/trustscore/me/history - Get TrustScore history
    /// </summary>
    [HttpGet("me/history")]
    public async Task<IActionResult> GetMyTrustScoreHistory([FromQuery] int months = 6)
    {
        if (months < 1 || months > 24)
        {
            return BadRequest(new { error = "invalid_months", message = "Months must be between 1 and 24." });
        }

        try
        {
            var userId = GetUserId();
            var snapshots = await _trustScoreService.GetTrustScoreHistoryAsync(userId, months);

            return Ok(new
            {
                snapshots = snapshots.Select(s => new
                {
                    score = s.Score,
                    identityScore = s.IdentityScore,
                    evidenceScore = s.EvidenceScore,
                    behaviourScore = s.BehaviourScore,
                    peerScore = s.PeerScore,
                    date = s.CreatedAt
                }),
                count = snapshots.Count
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving TrustScore history");
            return StatusCode(500, new { error = "internal_error", message = "Failed to retrieve TrustScore history." });
        }
    }

    /// <summary>
    /// POST /v1/trustscore/me/recalculate - Manually trigger TrustScore recalculation
    /// </summary>
    [HttpPost("me/recalculate")]
    public async Task<IActionResult> RecalculateMyTrustScore()
    {
        try
        {
            var userId = GetUserId();
            var snapshot = await _trustScoreService.CalculateAndSaveTrustScoreAsync(userId);

            return Ok(new
            {
                totalScore = snapshot.Score,
                label = GetTrustLabel(snapshot.Score),
                identityScore = snapshot.IdentityScore,
                evidenceScore = snapshot.EvidenceScore,
                behaviourScore = snapshot.BehaviourScore,
                peerScore = snapshot.PeerScore,
                calculatedAt = snapshot.CreatedAt,
                message = "TrustScore recalculated successfully."
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error recalculating TrustScore");
            return StatusCode(500, new { error = "internal_error", message = "Failed to recalculate TrustScore." });
        }
    }

    private string GetTrustLabel(int score)
    {
        return score switch
        {
            >= 801 => "Very High Trust",
            >= 601 => "High Trust",
            >= 401 => "Moderate Trust",
            >= 201 => "Low Trust",
            _ => "High Risk"
        };
    }
}
