using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Models;
using SilentID.Api.Services;

namespace SilentID.Api.Controllers;

[ApiController]
[Route("v1/evidence")]
[Authorize]
public class EvidenceController : ControllerBase
{
    private readonly IEvidenceService _evidenceService;
    private readonly ILogger<EvidenceController> _logger;

    public EvidenceController(IEvidenceService evidenceService, ILogger<EvidenceController> logger)
    {
        _evidenceService = evidenceService;
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
    /// POST /v1/evidence/receipts/manual - Add manual receipt evidence
    /// </summary>
    [HttpPost("receipts/manual")]
    public async Task<IActionResult> AddManualReceipt([FromBody] AddReceiptRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        try
        {
            var userId = GetUserId();

            // Generate hash for the receipt (to detect duplicates)
            var receiptData = $"{request.Platform}_{request.Item}_{request.Amount}_{request.Date:yyyy-MM-dd}_{request.OrderId ?? ""}";
            var rawHash = ComputeSha256Hash(receiptData);

            // Check for duplicates
            if (await _evidenceService.IsDuplicateReceiptAsync(rawHash))
            {
                return Conflict(new { error = "duplicate_receipt", message = "This receipt has already been added." });
            }

            var receipt = new ReceiptEvidence
            {
                Source = ReceiptSource.Manual,
                Platform = request.Platform,
                RawHash = rawHash,
                OrderId = request.OrderId,
                Item = request.Item,
                Amount = request.Amount,
                Currency = request.Currency ?? "GBP",
                Role = request.Role,
                Date = request.Date,
                IntegrityScore = 85, // Manual entries get 85 (lower than email receipts which get 100)
                FraudFlag = false,
                EvidenceState = EvidenceState.Valid
            };

            var savedReceipt = await _evidenceService.AddReceiptEvidenceAsync(userId, receipt);

            _logger.LogInformation("Manual receipt added: {ReceiptId} for user {UserId}", savedReceipt.Id, userId);

            return CreatedAtAction(
                nameof(GetReceipts),
                new { id = savedReceipt.Id },
                new
                {
                    id = savedReceipt.Id,
                    platform = savedReceipt.Platform.ToString(),
                    item = savedReceipt.Item,
                    amount = savedReceipt.Amount,
                    currency = savedReceipt.Currency,
                    role = savedReceipt.Role.ToString(),
                    date = savedReceipt.Date,
                    integrityScore = savedReceipt.IntegrityScore,
                    evidenceState = savedReceipt.EvidenceState.ToString(),
                    createdAt = savedReceipt.CreatedAt
                });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error adding manual receipt");
            return StatusCode(500, new { error = "internal_error", message = "Failed to add receipt." });
        }
    }

    /// <summary>
    /// GET /v1/evidence/receipts - Get user's receipts (paginated)
    /// </summary>
    [HttpGet("receipts")]
    public async Task<IActionResult> GetReceipts([FromQuery] int page = 1, [FromQuery] int pageSize = 20)
    {
        if (page < 1 || pageSize < 1 || pageSize > 100)
        {
            return BadRequest(new { error = "invalid_pagination", message = "Page must be >= 1 and pageSize between 1-100." });
        }

        try
        {
            var userId = GetUserId();

            var receipts = await _evidenceService.GetUserReceiptsAsync(userId, page, pageSize);
            var totalCount = await _evidenceService.GetTotalReceiptsCountAsync(userId);

            return Ok(new
            {
                receipts = receipts.Select(r => new
                {
                    id = r.Id,
                    platform = r.Platform.ToString(),
                    item = r.Item,
                    amount = r.Amount,
                    currency = r.Currency,
                    role = r.Role.ToString(),
                    date = r.Date,
                    integrityScore = r.IntegrityScore,
                    evidenceState = r.EvidenceState.ToString(),
                    createdAt = r.CreatedAt
                }),
                pagination = new
                {
                    page,
                    pageSize,
                    totalCount,
                    totalPages = (int)Math.Ceiling((double)totalCount / pageSize)
                }
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving receipts");
            return StatusCode(500, new { error = "internal_error", message = "Failed to retrieve receipts." });
        }
    }

    /// <summary>
    /// POST /v1/evidence/screenshots/upload-url - Generate upload URL for screenshot
    /// </summary>
    [HttpPost("screenshots/upload-url")]
    public IActionResult GetScreenshotUploadUrl()
    {
        try
        {
            var userId = GetUserId();

            // For MVP, return a mock upload URL
            // In production, this would generate an Azure Blob Storage SAS token
            var uploadId = Guid.NewGuid();
            var mockUploadUrl = $"https://silentid-storage.blob.core.windows.net/evidence/{userId}/{uploadId}?sas-token=mock";

            _logger.LogInformation("Screenshot upload URL generated for user {UserId}: {UploadId}", userId, uploadId);

            return Ok(new
            {
                uploadUrl = mockUploadUrl,
                uploadId = uploadId,
                expiresAt = DateTime.UtcNow.AddHours(1),
                message = "Upload your screenshot to this URL. URL expires in 1 hour."
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error generating upload URL");
            return StatusCode(500, new { error = "internal_error", message = "Failed to generate upload URL." });
        }
    }

    /// <summary>
    /// POST /v1/evidence/screenshots - Add screenshot evidence
    /// </summary>
    [HttpPost("screenshots")]
    public async Task<IActionResult> AddScreenshot([FromBody] AddScreenshotRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        try
        {
            var userId = GetUserId();

            var screenshot = new ScreenshotEvidence
            {
                FileUrl = request.FileUrl,
                Platform = request.Platform,
                OCRText = request.OcrText,
                IntegrityScore = 85, // Placeholder - real OCR/EXIF validation would adjust this
                FraudFlag = false,
                EvidenceState = EvidenceState.Valid
            };

            var savedScreenshot = await _evidenceService.AddScreenshotEvidenceAsync(userId, screenshot);

            _logger.LogInformation("Screenshot added: {ScreenshotId} for user {UserId}", savedScreenshot.Id, userId);

            return CreatedAtAction(
                nameof(GetScreenshot),
                new { id = savedScreenshot.Id },
                new
                {
                    id = savedScreenshot.Id,
                    fileUrl = savedScreenshot.FileUrl,
                    platform = savedScreenshot.Platform.ToString(),
                    integrityScore = savedScreenshot.IntegrityScore,
                    evidenceState = savedScreenshot.EvidenceState.ToString(),
                    createdAt = savedScreenshot.CreatedAt
                });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error adding screenshot");
            return StatusCode(500, new { error = "internal_error", message = "Failed to add screenshot." });
        }
    }

    /// <summary>
    /// GET /v1/evidence/screenshots/{id} - Get screenshot details
    /// </summary>
    [HttpGet("screenshots/{id}")]
    public async Task<IActionResult> GetScreenshot(Guid id)
    {
        try
        {
            var userId = GetUserId();

            var screenshot = await _evidenceService.GetScreenshotAsync(id, userId);
            if (screenshot == null)
            {
                return NotFound(new { error = "not_found", message = "Screenshot not found." });
            }

            return Ok(new
            {
                id = screenshot.Id,
                fileUrl = screenshot.FileUrl,
                platform = screenshot.Platform.ToString(),
                ocrText = screenshot.OCRText,
                integrityScore = screenshot.IntegrityScore,
                fraudFlag = screenshot.FraudFlag,
                evidenceState = screenshot.EvidenceState.ToString(),
                createdAt = screenshot.CreatedAt
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving screenshot {ScreenshotId}", id);
            return StatusCode(500, new { error = "internal_error", message = "Failed to retrieve screenshot." });
        }
    }

    /// <summary>
    /// POST /v1/evidence/profile-links - Add public profile link evidence
    /// </summary>
    [HttpPost("profile-links")]
    public async Task<IActionResult> AddProfileLink([FromBody] AddProfileLinkRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        try
        {
            var userId = GetUserId();

            // Validate URL format (basic check)
            if (!Uri.TryCreate(request.Url, UriKind.Absolute, out var uri))
            {
                return BadRequest(new { error = "invalid_url", message = "Please provide a valid URL." });
            }

            var profileLink = new ProfileLinkEvidence
            {
                URL = request.Url,
                Platform = request.Platform,
                ScrapeDataJson = null, // Placeholder - real scraper would populate this
                UsernameMatchScore = 90, // Placeholder - real scraping would calculate actual score
                IntegrityScore = 100,
                EvidenceState = EvidenceState.Valid
            };

            var savedProfileLink = await _evidenceService.AddProfileLinkEvidenceAsync(userId, profileLink);

            _logger.LogInformation("Profile link added: {ProfileLinkId} for user {UserId}", savedProfileLink.Id, userId);

            return CreatedAtAction(
                nameof(GetProfileLink),
                new { id = savedProfileLink.Id },
                new
                {
                    id = savedProfileLink.Id,
                    url = savedProfileLink.URL,
                    platform = savedProfileLink.Platform.ToString(),
                    usernameMatchScore = savedProfileLink.UsernameMatchScore,
                    integrityScore = savedProfileLink.IntegrityScore,
                    evidenceState = savedProfileLink.EvidenceState.ToString(),
                    createdAt = savedProfileLink.CreatedAt
                });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error adding profile link");
            return StatusCode(500, new { error = "internal_error", message = "Failed to add profile link." });
        }
    }

    /// <summary>
    /// GET /v1/evidence/profile-links/{id} - Get profile link details
    /// </summary>
    [HttpGet("profile-links/{id}")]
    public async Task<IActionResult> GetProfileLink(Guid id)
    {
        try
        {
            var userId = GetUserId();

            var profileLink = await _evidenceService.GetProfileLinkAsync(id, userId);
            if (profileLink == null)
            {
                return NotFound(new { error = "not_found", message = "Profile link not found." });
            }

            return Ok(new
            {
                id = profileLink.Id,
                url = profileLink.URL,
                platform = profileLink.Platform.ToString(),
                scrapeDataJson = profileLink.ScrapeDataJson,
                usernameMatchScore = profileLink.UsernameMatchScore,
                integrityScore = profileLink.IntegrityScore,
                evidenceState = profileLink.EvidenceState.ToString(),
                createdAt = profileLink.CreatedAt,
                updatedAt = profileLink.UpdatedAt
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving profile link {ProfileLinkId}", id);
            return StatusCode(500, new { error = "internal_error", message = "Failed to retrieve profile link." });
        }
    }

    // Helper method to compute SHA-256 hash
    private static string ComputeSha256Hash(string input)
    {
        using var sha256 = SHA256.Create();
        var bytes = Encoding.UTF8.GetBytes(input);
        var hash = sha256.ComputeHash(bytes);
        return Convert.ToHexString(hash).ToLowerInvariant();
    }
}

// Request DTOs
public class AddReceiptRequest
{
    public Platform Platform { get; set; }
    public string? OrderId { get; set; }
    public string? Item { get; set; }
    public decimal Amount { get; set; }
    public string? Currency { get; set; }
    public TransactionRole Role { get; set; }
    public DateTime Date { get; set; }
}

public class AddScreenshotRequest
{
    public string FileUrl { get; set; } = string.Empty;
    public Platform Platform { get; set; }
    public string? OcrText { get; set; }
}

public class AddProfileLinkRequest
{
    public string Url { get; set; } = string.Empty;
    public Platform Platform { get; set; }
}
