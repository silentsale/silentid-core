using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Services;

namespace SilentID.Api.Controllers;

[ApiController]
[Route("v1/reports")]
[Authorize]
public class ReportController : ControllerBase
{
    private readonly IReportService _service;
    private readonly ILogger<ReportController> _logger;

    public ReportController(
        IReportService service,
        ILogger<ReportController> logger)
    {
        _service = service;
        _logger = logger;
    }

    /// <summary>
    /// Create a safety report against another user.
    /// </summary>
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateReportRequest request)
    {
        try
        {
            var userId = GetUserIdFromToken();
            var report = await _service.CreateReportAsync(userId, request);

            return CreatedAtAction(nameof(GetById), new { id = report.Id }, new
            {
                id = report.Id,
                reportedUser = report.ReportedUserId,
                category = report.Category.ToString(),
                status = report.Status.ToString(),
                message = "Report submitted successfully. We'll review it within 48 hours."
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
    /// Upload evidence for an existing report (JSON body with fileUrl).
    /// </summary>
    [HttpPost("{id}/evidence")]
    public async Task<IActionResult> UploadEvidence(Guid id, [FromBody] UploadReportEvidenceRequest request)
    {
        try
        {
            var userId = GetUserIdFromToken();
            var evidence = await _service.UploadEvidenceAsync(id, userId, request.FileUrl, request.FileType);

            return Ok(new
            {
                id = evidence.Id,
                reportId = evidence.ReportId,
                fileUrl = evidence.FileUrl,
                message = "Evidence uploaded successfully"
            });
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { error = "report_not_found", message = ex.Message });
        }
        catch (UnauthorizedAccessException)
        {
            return Forbid();
        }
    }

    /// <summary>
    /// Upload evidence file for an existing report (multipart form-data upload).
    /// This handles file upload to Azure Blob Storage internally.
    /// </summary>
    [HttpPost("{id}/evidence/upload")]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> UploadEvidenceFile(Guid id, [FromForm] IFormFile file)
    {
        if (file == null || file.Length == 0)
        {
            return BadRequest(new { error = "invalid_file", message = "Please provide a valid file." });
        }

        // Validate file type (images and PDFs)
        var allowedContentTypes = new[] { "image/jpeg", "image/jpg", "image/png", "image/webp", "application/pdf" };
        if (!allowedContentTypes.Contains(file.ContentType.ToLowerInvariant()))
        {
            return BadRequest(new { error = "invalid_file_type", message = "Only image files (JPEG, PNG, WebP) and PDFs are allowed." });
        }

        // Validate file size (max 10MB)
        const int maxFileSizeBytes = 10 * 1024 * 1024;
        if (file.Length > maxFileSizeBytes)
        {
            return BadRequest(new { error = "file_too_large", message = "File size must not exceed 10MB." });
        }

        try
        {
            var userId = GetUserIdFromToken();
            var evidence = await _service.UploadEvidenceFileAsync(id, userId, file);

            return Ok(new
            {
                id = evidence.Id,
                reportId = evidence.ReportId,
                fileUrl = evidence.FileUrl,
                fileType = evidence.FileType,
                message = "Evidence uploaded successfully"
            });
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { error = "report_not_found", message = ex.Message });
        }
        catch (UnauthorizedAccessException)
        {
            return Forbid();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error uploading evidence file for report {ReportId}", id);
            return StatusCode(500, new { error = "internal_error", message = "Failed to upload evidence file." });
        }
    }

    /// <summary>
    /// Get all reports filed by the current user.
    /// </summary>
    [HttpGet("mine")]
    public async Task<IActionResult> GetMyReports()
    {
        var userId = GetUserIdFromToken();
        var reports = await _service.GetMyReportsAsync(userId);

        return Ok(new
        {
            reports = reports.Select(r => new
            {
                id = r.Id,
                reportedUser = new
                {
                    username = r.ReportedUser.Username,
                    displayName = r.ReportedUser.DisplayName
                },
                category = r.Category.ToString(),
                description = r.Description,
                status = r.Status.ToString(),
                evidenceCount = r.Evidence.Count,
                filedAt = r.CreatedAt,
                lastUpdated = r.UpdatedAt
            }),
            count = reports.Count
        });
    }

    /// <summary>
    /// Get report details by ID.
    /// </summary>
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var userId = GetUserIdFromToken();
        var report = await _service.GetReportByIdAsync(id, userId);

        if (report == null)
        {
            return NotFound(new { error = "report_not_found", message = "Report not found or access denied" });
        }

        return Ok(new
        {
            id = report.Id,
            reportedUser = new
            {
                username = report.ReportedUser.Username,
                displayName = report.ReportedUser.DisplayName
            },
            category = report.Category.ToString(),
            description = report.Description,
            status = report.Status.ToString(),
            evidence = report.Evidence.Select(e => new
            {
                id = e.Id,
                fileUrl = e.FileUrl,
                fileType = e.FileType,
                uploadedAt = e.CreatedAt
            }),
            adminNotes = report.AdminNotes,
            reviewedBy = report.ReviewedBy,
            reviewedAt = report.ReviewedAt,
            filedAt = report.CreatedAt,
            lastUpdated = report.UpdatedAt
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
