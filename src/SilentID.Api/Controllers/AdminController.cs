using System.Security.Claims;
using System.Text.Json;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Controllers;

/// <summary>
/// Admin-only endpoints for user management, risk review, and report moderation.
/// All actions are logged to AdminAuditLogs for compliance (Section 28).
/// </summary>
[ApiController]
[Route("v1/admin")]
[Authorize(Policy = "AdminOnly")]
public class AdminController : ControllerBase
{
    private readonly SilentIdDbContext _context;
    private readonly ILogger<AdminController> _logger;

    public AdminController(
        SilentIdDbContext context,
        ILogger<AdminController> logger)
    {
        _context = context;
        _logger = logger;
    }

    /// <summary>
    /// Get full user profile (admin only).
    /// Returns comprehensive user information for admin review.
    /// </summary>
    /// <param name="id">User ID to retrieve</param>
    [HttpGet("users/{id}")]
    public async Task<IActionResult> GetUser(Guid id)
    {
        try
        {
            var adminUserId = GetAdminUserId();
            var adminEmail = GetAdminEmail();

            var user = await _context.Users
                .AsNoTracking()
                .FirstOrDefaultAsync(u => u.Id == id);

            if (user == null)
            {
                return NotFound(new
                {
                    error = "user_not_found",
                    message = "User not found"
                });
            }

            // Get identity verification status
            var identityVerification = await _context.IdentityVerifications
                .AsNoTracking()
                .FirstOrDefaultAsync(iv => iv.UserId == id);

            // Get latest TrustScore snapshot
            var latestTrustScore = await _context.TrustScoreSnapshots
                .AsNoTracking()
                .Where(ts => ts.UserId == id)
                .OrderByDescending(ts => ts.CreatedAt)
                .FirstOrDefaultAsync();

            // Get evidence counts
            var receiptsCount = await _context.ReceiptEvidences
                .CountAsync(r => r.UserId == id);
            var screenshotsCount = await _context.ScreenshotEvidences
                .CountAsync(s => s.UserId == id);
            var profileLinksCount = await _context.ProfileLinkEvidences
                .CountAsync(p => p.UserId == id);

            // Get risk signals
            var activeRiskSignals = await _context.RiskSignals
                .AsNoTracking()
                .Where(rs => rs.UserId == id && !rs.IsResolved)
                .OrderByDescending(rs => rs.CreatedAt)
                .Select(rs => new
                {
                    id = rs.Id,
                    type = rs.Type.ToString(),
                    severity = rs.Severity,
                    message = rs.Message,
                    metadata = rs.Metadata,
                    createdAt = rs.CreatedAt
                })
                .ToListAsync();

            var historicalRiskSignals = await _context.RiskSignals
                .AsNoTracking()
                .Where(rs => rs.UserId == id && rs.IsResolved)
                .OrderByDescending(rs => rs.CreatedAt)
                .Take(10)
                .Select(rs => new
                {
                    id = rs.Id,
                    type = rs.Type.ToString(),
                    severity = rs.Severity,
                    message = rs.Message,
                    createdAt = rs.CreatedAt
                })
                .ToListAsync();

            // Calculate current RiskScore
            var currentRiskScore = CalculateRiskScore(activeRiskSignals.Count, activeRiskSignals.Sum(rs => rs.severity));

            // Get reports filed by user
            var reportsFiledCount = await _context.Reports
                .CountAsync(r => r.ReporterId == id);

            // Get reports filed against user
            var reportsAgainstUser = await _context.Reports
                .AsNoTracking()
                .Where(r => r.ReportedUserId == id)
                .OrderByDescending(r => r.CreatedAt)
                .Select(r => new
                {
                    id = r.Id,
                    category = r.Category.ToString(),
                    status = r.Status.ToString(),
                    reporterId = r.ReporterId,
                    filedAt = r.CreatedAt
                })
                .ToListAsync();

            // Get devices
            var devicesCount = await _context.AuthDevices
                .CountAsync(d => d.UserId == id);

            // Get active sessions
            var activeSessionsCount = await _context.Sessions
                .CountAsync(s => s.UserId == id && s.ExpiresAt > DateTime.UtcNow);

            // Get subscription
            var subscription = await _context.Subscriptions
                .AsNoTracking()
                .Where(s => s.UserId == id)
                .OrderByDescending(s => s.CreatedAt)
                .FirstOrDefaultAsync();

            _logger.LogInformation("Admin {AdminEmail} viewed full profile for user {UserId}", adminEmail, id);

            return Ok(new
            {
                user = new
                {
                    id = user.Id,
                    email = user.Email,
                    username = user.Username,
                    displayName = user.DisplayName,
                    phoneNumber = user.PhoneNumber,
                    accountStatus = user.AccountStatus.ToString(),
                    accountType = user.AccountType.ToString(),
                    isEmailVerified = user.IsEmailVerified,
                    isPhoneVerified = user.IsPhoneVerified,
                    isPasskeyEnabled = user.IsPasskeyEnabled,
                    signupIP = user.SignupIP,
                    signupDeviceId = user.SignupDeviceId,
                    createdAt = user.CreatedAt,
                    updatedAt = user.UpdatedAt
                },
                identityVerification = identityVerification != null ? new
                {
                    status = identityVerification.Status.ToString(),
                    level = identityVerification.Level.ToString(),
                    stripeVerificationId = identityVerification.StripeVerificationId,
                    verifiedAt = identityVerification.VerifiedAt
                } : null,
                trustScore = latestTrustScore != null ? new
                {
                    score = latestTrustScore.Score,
                    identityScore = latestTrustScore.IdentityScore,
                    evidenceScore = latestTrustScore.EvidenceScore,
                    behaviourScore = latestTrustScore.BehaviourScore,
                    peerScore = latestTrustScore.PeerScore,
                    lastCalculated = latestTrustScore.CreatedAt
                } : null,
                evidence = new
                {
                    receiptsCount,
                    screenshotsCount,
                    profileLinksCount,
                    totalCount = receiptsCount + screenshotsCount + profileLinksCount
                },
                risk = new
                {
                    currentRiskScore,
                    activeSignalsCount = activeRiskSignals.Count,
                    activeSignals = activeRiskSignals,
                    historicalSignals = historicalRiskSignals
                },
                reports = new
                {
                    filedByUser = reportsFiledCount,
                    filedAgainstUser = reportsAgainstUser.Count,
                    againstUserDetails = reportsAgainstUser
                },
                devices = new
                {
                    totalDevices = devicesCount,
                    activeSessions = activeSessionsCount
                },
                subscription = subscription != null ? new
                {
                    tier = subscription.Tier.ToString(),
                    renewalDate = subscription.RenewalDate,
                    cancelAt = subscription.CancelAt,
                    stripeSubscriptionId = subscription.StripeSubscriptionId
                } : null
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving user profile for admin review");
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to retrieve user profile"
            });
        }
    }

    /// <summary>
    /// List high-risk users (admin only).
    /// Returns paginated list of users with RiskScore >= minRiskScore.
    /// </summary>
    /// <param name="minRiskScore">Minimum risk score (default: 70)</param>
    /// <param name="page">Page number (default: 1)</param>
    /// <param name="pageSize">Page size (default: 20, max: 100)</param>
    [HttpGet("risk/users")]
    public async Task<IActionResult> GetHighRiskUsers(
        [FromQuery] int minRiskScore = 70,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20)
    {
        try
        {
            var adminEmail = GetAdminEmail();

            // Validate parameters
            if (minRiskScore < 0 || minRiskScore > 100)
            {
                return BadRequest(new
                {
                    error = "invalid_parameter",
                    message = "minRiskScore must be between 0 and 100"
                });
            }

            if (pageSize < 1 || pageSize > 100)
            {
                return BadRequest(new
                {
                    error = "invalid_parameter",
                    message = "pageSize must be between 1 and 100"
                });
            }

            if (page < 1)
            {
                return BadRequest(new
                {
                    error = "invalid_parameter",
                    message = "page must be >= 1"
                });
            }

            // Get all users with active risk signals
            var usersWithRisk = await _context.RiskSignals
                .AsNoTracking()
                .Where(rs => !rs.IsResolved)
                .GroupBy(rs => rs.UserId)
                .Select(g => new
                {
                    UserId = g.Key,
                    ActiveSignalsCount = g.Count(),
                    TotalSeverity = g.Sum(rs => rs.Severity),
                    RiskScore = CalculateRiskScore(g.Count(), g.Sum(rs => rs.Severity))
                })
                .Where(u => u.RiskScore >= minRiskScore)
                .ToListAsync();

            // Get user IDs for high-risk users
            var highRiskUserIds = usersWithRisk
                .OrderByDescending(u => u.RiskScore)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(u => u.UserId)
                .ToList();

            // Get user details
            var users = await _context.Users
                .AsNoTracking()
                .Where(u => highRiskUserIds.Contains(u.Id))
                .Select(u => new
                {
                    id = u.Id,
                    email = u.Email,
                    username = u.Username,
                    displayName = u.DisplayName,
                    accountStatus = u.AccountStatus.ToString(),
                    accountType = u.AccountType.ToString(),
                    createdAt = u.CreatedAt
                })
                .ToDictionaryAsync(u => u.id);

            // Get verified reports counts
            var verifiedReportsCounts = await _context.Reports
                .Where(r => highRiskUserIds.Contains(r.ReportedUserId) && r.Status == ReportStatus.Verified)
                .GroupBy(r => r.ReportedUserId)
                .Select(g => new { UserId = g.Key, Count = g.Count() })
                .ToDictionaryAsync(x => x.UserId, x => x.Count);

            // Get last activity (most recent session)
            var lastActivities = await _context.Sessions
                .Where(s => highRiskUserIds.Contains(s.UserId))
                .GroupBy(s => s.UserId)
                .Select(g => new { UserId = g.Key, LastActivity = g.Max(s => s.CreatedAt) })
                .ToDictionaryAsync(x => x.UserId, x => x.LastActivity);

            // Combine data
            var result = usersWithRisk
                .Where(u => highRiskUserIds.Contains(u.UserId))
                .OrderByDescending(u => u.RiskScore)
                .Select(u => new
                {
                    user = users.GetValueOrDefault(u.UserId),
                    riskScore = u.RiskScore,
                    activeRiskSignals = u.ActiveSignalsCount,
                    verifiedReports = verifiedReportsCounts.GetValueOrDefault(u.UserId, 0),
                    lastActivity = lastActivities.GetValueOrDefault(u.UserId)
                })
                .ToList();

            var totalCount = usersWithRisk.Count;
            var totalPages = (int)Math.Ceiling(totalCount / (double)pageSize);

            _logger.LogInformation("Admin {AdminEmail} queried high-risk users (minRiskScore: {MinRiskScore}, page: {Page})",
                adminEmail, minRiskScore, page);

            return Ok(new
            {
                users = result,
                pagination = new
                {
                    currentPage = page,
                    pageSize,
                    totalCount,
                    totalPages,
                    hasNextPage = page < totalPages,
                    hasPreviousPage = page > 1
                },
                filters = new
                {
                    minRiskScore
                }
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving high-risk users");
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to retrieve high-risk users"
            });
        }
    }

    /// <summary>
    /// Make a decision on a safety report (admin only).
    /// Verifies or dismisses report, creates RiskSignal if verified.
    /// </summary>
    /// <param name="id">Report ID</param>
    /// <param name="request">Decision request</param>
    [HttpPost("reports/{id}/decision")]
    public async Task<IActionResult> MakeReportDecision(Guid id, [FromBody] ReportDecisionRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(new
            {
                error = "invalid_request",
                message = "Invalid request data"
            });
        }

        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            var adminUserId = GetAdminUserId();
            var adminEmail = GetAdminEmail();

            var report = await _context.Reports
                .Include(r => r.ReportedUser)
                .Include(r => r.Reporter)
                .FirstOrDefaultAsync(r => r.Id == id);

            if (report == null)
            {
                return NotFound(new
                {
                    error = "report_not_found",
                    message = "Report not found"
                });
            }

            // Validate decision
            if (request.Decision != "Verified" && request.Decision != "Dismissed")
            {
                return BadRequest(new
                {
                    error = "invalid_decision",
                    message = "Decision must be 'Verified' or 'Dismissed'"
                });
            }

            // Update report
            if (request.Decision == "Verified")
            {
                report.Status = ReportStatus.Verified;

                // Create RiskSignal for reported user
                var severity = GetSeverityFromCategory(report.Category);
                var riskSignal = new RiskSignal
                {
                    UserId = report.ReportedUserId,
                    Type = RiskType.Reported,
                    Severity = severity,
                    Message = $"Verified safety report: {report.Category}",
                    Metadata = JsonSerializer.Serialize(new
                    {
                        reportId = report.Id,
                        category = report.Category.ToString(),
                        reporterId = report.ReporterId,
                        verifiedBy = adminEmail
                    }),
                    IsResolved = false,
                    CreatedAt = DateTime.UtcNow
                };

                _context.RiskSignals.Add(riskSignal);

                _logger.LogWarning("Report {ReportId} verified by admin {AdminEmail} - RiskSignal created for user {UserId}",
                    id, adminEmail, report.ReportedUserId);
            }
            else
            {
                report.Status = ReportStatus.Dismissed;
                _logger.LogInformation("Report {ReportId} dismissed by admin {AdminEmail}", id, adminEmail);
            }

            report.ReviewedBy = adminEmail;
            report.ReviewedAt = DateTime.UtcNow;
            report.AdminNotes = request.Notes;
            report.UpdatedAt = DateTime.UtcNow;

            // Create AdminAuditLog
            var auditLog = new AdminAuditLog
            {
                AdminUser = adminEmail,
                Action = $"ReportDecision_{request.Decision}",
                TargetUserId = report.ReportedUserId,
                Details = JsonSerializer.Serialize(new
                {
                    reportId = id,
                    decision = request.Decision,
                    notes = request.Notes,
                    category = report.Category.ToString(),
                    reporterId = report.ReporterId
                }),
                IPAddress = GetClientIpAddress(),
                CreatedAt = DateTime.UtcNow
            };

            _context.AdminAuditLogs.Add(auditLog);

            await _context.SaveChangesAsync();
            await transaction.CommitAsync();

            return Ok(new
            {
                report = new
                {
                    id = report.Id,
                    reportedUser = new
                    {
                        id = report.ReportedUserId,
                        username = report.ReportedUser.Username
                    },
                    category = report.Category.ToString(),
                    status = report.Status.ToString(),
                    reviewedBy = report.ReviewedBy,
                    reviewedAt = report.ReviewedAt,
                    adminNotes = report.AdminNotes
                },
                message = $"Report {request.Decision.ToLowerInvariant()} successfully"
            });
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            _logger.LogError(ex, "Error making decision on report {ReportId}", id);
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to process report decision"
            });
        }
    }

    /// <summary>
    /// Take action on a user account (admin only).
    /// Can freeze, unfreeze, or limit user account.
    /// </summary>
    /// <param name="id">User ID</param>
    /// <param name="request">Action request</param>
    [HttpPost("users/{id}/action")]
    public async Task<IActionResult> TakeUserAction(Guid id, [FromBody] UserActionRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(new
            {
                error = "invalid_request",
                message = "Invalid request data"
            });
        }

        // Validate reason (mandatory per Section 28)
        if (string.IsNullOrWhiteSpace(request.Reason) || request.Reason.Length < 20)
        {
            return BadRequest(new
            {
                error = "invalid_reason",
                message = "Reason is required and must be at least 20 characters (compliance requirement)"
            });
        }

        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            var adminUserId = GetAdminUserId();
            var adminEmail = GetAdminEmail();

            var user = await _context.Users.FirstOrDefaultAsync(u => u.Id == id);

            if (user == null)
            {
                return NotFound(new
                {
                    error = "user_not_found",
                    message = "User not found"
                });
            }

            // Validate action
            if (request.Action != "Freeze" && request.Action != "Unfreeze" && request.Action != "Limit")
            {
                return BadRequest(new
                {
                    error = "invalid_action",
                    message = "Action must be 'Freeze', 'Unfreeze', or 'Limit'"
                });
            }

            string actionTaken;
            object actionDetails;

            switch (request.Action)
            {
                case "Freeze":
                    user.AccountStatus = AccountStatus.Suspended;
                    actionTaken = "FreezeAccount";
                    actionDetails = new
                    {
                        action = "Freeze",
                        reason = request.Reason,
                        duration = request.Duration,
                        previousStatus = user.AccountStatus.ToString()
                    };
                    _logger.LogWarning("Admin {AdminEmail} froze account {UserId}: {Reason}",
                        adminEmail, id, request.Reason);
                    break;

                case "Unfreeze":
                    user.AccountStatus = AccountStatus.Active;
                    actionTaken = "UnfreezeAccount";
                    actionDetails = new
                    {
                        action = "Unfreeze",
                        reason = request.Reason,
                        previousStatus = user.AccountStatus.ToString()
                    };
                    _logger.LogInformation("Admin {AdminEmail} unfroze account {UserId}: {Reason}",
                        adminEmail, id, request.Reason);
                    break;

                case "Limit":
                    // Create RiskSignal to trigger frontend feature limitations
                    var riskSignal = new RiskSignal
                    {
                        UserId = id,
                        Type = RiskType.AbnormalActivity,
                        Severity = 7, // High severity to trigger restrictions
                        Message = $"Account limited by admin: {request.Reason}",
                        Metadata = JsonSerializer.Serialize(new
                        {
                            adminEmail,
                            reason = request.Reason,
                            actionDate = DateTime.UtcNow
                        }),
                        IsResolved = false,
                        CreatedAt = DateTime.UtcNow
                    };

                    _context.RiskSignals.Add(riskSignal);
                    actionTaken = "LimitAccount";
                    actionDetails = new
                    {
                        action = "Limit",
                        reason = request.Reason,
                        riskSignalCreated = true
                    };
                    _logger.LogWarning("Admin {AdminEmail} limited account {UserId}: {Reason}",
                        adminEmail, id, request.Reason);
                    break;

                default:
                    return BadRequest(new
                    {
                        error = "invalid_action",
                        message = "Invalid action specified"
                    });
            }

            user.UpdatedAt = DateTime.UtcNow;

            // Create AdminAuditLog (MANDATORY per Section 28)
            var auditLog = new AdminAuditLog
            {
                AdminUser = adminEmail,
                Action = actionTaken,
                TargetUserId = id,
                Details = JsonSerializer.Serialize(actionDetails),
                IPAddress = GetClientIpAddress(),
                CreatedAt = DateTime.UtcNow
            };

            _context.AdminAuditLogs.Add(auditLog);

            await _context.SaveChangesAsync();
            await transaction.CommitAsync();

            return Ok(new
            {
                user = new
                {
                    id = user.Id,
                    email = user.Email,
                    username = user.Username,
                    accountStatus = user.AccountStatus.ToString(),
                    updatedAt = user.UpdatedAt
                },
                action = new
                {
                    type = request.Action,
                    reason = request.Reason,
                    performedBy = adminEmail,
                    performedAt = DateTime.UtcNow
                },
                message = $"User account {request.Action.ToLowerInvariant()}d successfully"
            });
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            _logger.LogError(ex, "Error taking action on user {UserId}", id);
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to perform user action"
            });
        }
    }

    // Helper methods

    private Guid GetAdminUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            throw new UnauthorizedAccessException("Admin user ID not found in token");
        }
        return userId;
    }

    private string GetAdminEmail()
    {
        var emailClaim = User.FindFirst(ClaimTypes.Email)?.Value;
        if (string.IsNullOrEmpty(emailClaim))
        {
            // Fallback to NameIdentifier if Email claim not present
            return GetAdminUserId().ToString();
        }
        return emailClaim;
    }

    private string GetClientIpAddress()
    {
        var ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown";

        // Check for forwarded IP (if behind proxy/load balancer)
        if (Request.Headers.ContainsKey("X-Forwarded-For"))
        {
            ipAddress = Request.Headers["X-Forwarded-For"].ToString().Split(',')[0].Trim();
        }

        return ipAddress;
    }

    private static int CalculateRiskScore(int activeSignalsCount, int totalSeverity)
    {
        // Simple RiskScore calculation (0-100)
        // Based on number of signals and their severity
        var baseScore = Math.Min(activeSignalsCount * 10, 50); // Up to 50 points from signal count
        var severityScore = Math.Min(totalSeverity * 5, 50); // Up to 50 points from severity
        return Math.Min(baseScore + severityScore, 100);
    }

    private static int GetSeverityFromCategory(ReportCategory category)
    {
        return category switch
        {
            ReportCategory.FraudConcern => 9,
            ReportCategory.FakeProfile => 8,
            ReportCategory.PaymentIssue => 7,
            ReportCategory.MisrepresentedItem => 6,
            ReportCategory.ItemNotReceived => 5,
            ReportCategory.AggressiveBehaviour => 6,
            ReportCategory.Harassment => 7,
            ReportCategory.Other => 4,
            _ => 5
        };
    }
}

// Request DTOs

/// <summary>
/// Request to make a decision on a safety report.
/// </summary>
public record ReportDecisionRequest(
    string Decision, // "Verified" or "Dismissed"
    string? Notes = null // Optional admin notes
);

/// <summary>
/// Request to take action on a user account.
/// </summary>
public record UserActionRequest(
    string Action, // "Freeze", "Unfreeze", or "Limit"
    string Reason, // Mandatory justification (min 20 chars)
    int? Duration = null // Optional duration in days for temporary actions
);
