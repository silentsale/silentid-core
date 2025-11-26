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
    private readonly IExtractionService _extractionService;
    private readonly IBlobStorageService _blobStorageService;
    private readonly IRiskEngineService _riskEngineService;
    private readonly ILogger<EvidenceController> _logger;

    public EvidenceController(
        IEvidenceService evidenceService,
        IExtractionService extractionService,
        IBlobStorageService blobStorageService,
        ILogger<EvidenceController> logger,
        IRiskEngineService riskEngineService)
    {
        _evidenceService = evidenceService;
        _extractionService = extractionService;
        _blobStorageService = blobStorageService;
        _logger = logger;
        _riskEngineService = riskEngineService;
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
    /// POST /v1/evidence/screenshots - Upload and add screenshot evidence
    /// </summary>
    [HttpPost("screenshots")]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> UploadScreenshot([FromForm] IFormFile file, [FromForm] Platform platform, [FromForm] string? ocrText)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        // Validate file
        if (file == null || file.Length == 0)
        {
            return BadRequest(new { error = "invalid_file", message = "Please provide a valid file." });
        }

        // Validate file type (images only)
        var allowedContentTypes = new[] { "image/jpeg", "image/jpg", "image/png", "image/webp" };
        if (!allowedContentTypes.Contains(file.ContentType.ToLowerInvariant()))
        {
            return BadRequest(new { error = "invalid_file_type", message = "Only image files (JPEG, PNG, WebP) are allowed." });
        }

        // Validate file size (max 10MB)
        const int maxFileSizeBytes = 10 * 1024 * 1024; // 10MB
        if (file.Length > maxFileSizeBytes)
        {
            return BadRequest(new { error = "file_too_large", message = "File size must not exceed 10MB." });
        }

        try
        {
            var userId = GetUserId();

            // Upload file to blob storage
            string fileUrl;
            using (var fileStream = file.OpenReadStream())
            {
                fileUrl = await _blobStorageService.UploadFileAsync(
                    fileStream,
                    file.FileName,
                    file.ContentType
                );
            }

            _logger.LogInformation("Screenshot uploaded for user {UserId}: {FileUrl}", userId, fileUrl);

            // Create screenshot evidence record
            var screenshot = new ScreenshotEvidence
            {
                FileUrl = fileUrl,
                Platform = platform,
                OCRText = ocrText,
                IntegrityScore = 85, // Placeholder - real OCR/EXIF validation would adjust this
                FraudFlag = false,
                EvidenceState = EvidenceState.Valid
            };

            var savedScreenshot = await _evidenceService.AddScreenshotEvidenceAsync(userId, screenshot);

            _logger.LogInformation("Screenshot evidence added: {ScreenshotId} for user {UserId}", savedScreenshot.Id, userId);

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
            _logger.LogError(ex, "Error uploading screenshot");
            return StatusCode(500, new { error = "internal_error", message = "Failed to upload screenshot." });
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
                verificationLevel = profileLink.VerificationLevel,
                verificationMethod = profileLink.VerificationMethod,
                verificationToken = profileLink.VerificationToken,
                ownershipLockedAt = profileLink.OwnershipLockedAt,
                nextReverifyAt = profileLink.NextReverifyAt,
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

    /// <summary>
    /// GET /v1/evidence/profile-links - Get all user's profile links
    /// </summary>
    [HttpGet("profile-links")]
    public async Task<IActionResult> GetProfileLinks()
    {
        try
        {
            var userId = GetUserId();

            var profileLinks = await _evidenceService.GetUserProfileLinksAsync(userId);

            return Ok(new
            {
                profileLinks = profileLinks.Select(p => new
                {
                    id = p.Id,
                    url = p.URL,
                    platform = p.Platform.ToString(),
                    usernameMatchScore = p.UsernameMatchScore,
                    integrityScore = p.IntegrityScore,
                    evidenceState = p.EvidenceState.ToString(),
                    verificationLevel = p.VerificationLevel,
                    verificationMethod = p.VerificationMethod,
                    ownershipLockedAt = p.OwnershipLockedAt,
                    nextReverifyAt = p.NextReverifyAt,
                    createdAt = p.CreatedAt,
                    updatedAt = p.UpdatedAt
                }),
                count = profileLinks.Count
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving profile links");
            return StatusCode(500, new { error = "internal_error", message = "Failed to retrieve profile links." });
        }
    }

    // ========== LEVEL 3 VERIFICATION ENDPOINTS ==========

    /// <summary>
    /// POST /v1/evidence/profile-links/{id}/generate-token - Generate Token-in-Bio verification token
    /// </summary>
    [HttpPost("profile-links/{id}/generate-token")]
    public async Task<IActionResult> GenerateVerificationToken(Guid id)
    {
        try
        {
            var userId = GetUserId();

            var token = await _evidenceService.GenerateVerificationTokenAsync(id, userId);

            _logger.LogInformation("Verification token generated for profile link {ProfileLinkId}, user {UserId}", id, userId);

            return Ok(new
            {
                profileLinkId = id,
                verificationToken = token,
                method = "TokenInBio",
                instructions = "Add this token to your profile bio/description, then call the confirm-token endpoint.",
                expiresIn = "24 hours"
            });
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Failed to generate token for profile link {ProfileLinkId}", id);
            return BadRequest(new { error = "token_generation_failed", message = ex.Message });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error generating verification token for profile link {ProfileLinkId}", id);
            return StatusCode(500, new { error = "internal_error", message = "Failed to generate verification token." });
        }
    }

    /// <summary>
    /// POST /v1/evidence/profile-links/{id}/confirm-token - Confirm Token-in-Bio verification
    /// </summary>
    [HttpPost("profile-links/{id}/confirm-token")]
    public async Task<IActionResult> ConfirmTokenInBio(Guid id, [FromBody] ConfirmTokenRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        if (string.IsNullOrWhiteSpace(request.ScrapedBioText))
        {
            return BadRequest(new { error = "invalid_request", message = "ScrapedBioText is required." });
        }

        try
        {
            var userId = GetUserId();

            var profileLink = await _evidenceService.ConfirmTokenInBioAsync(id, userId, request.ScrapedBioText);

            if (profileLink == null)
            {
                return BadRequest(new { error = "verification_failed", message = "Token not found in bio text. Please ensure you added the exact token to your profile bio." });
            }

            _logger.LogInformation("Token-in-Bio verification confirmed for profile link {ProfileLinkId}, user {UserId}", id, userId);

            return Ok(new
            {
                id = profileLink.Id,
                url = profileLink.URL,
                platform = profileLink.Platform.ToString(),
                verificationLevel = profileLink.VerificationLevel,
                verificationMethod = profileLink.VerificationMethod,
                ownershipLockedAt = profileLink.OwnershipLockedAt,
                nextReverifyAt = profileLink.NextReverifyAt,
                integrityScore = profileLink.IntegrityScore,
                message = "Profile successfully verified via Token-in-Bio! You can now remove the token from your bio."
            });
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Token confirmation failed for profile link {ProfileLinkId}", id);
            return BadRequest(new { error = "confirmation_failed", message = ex.Message });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error confirming token for profile link {ProfileLinkId}", id);
            return StatusCode(500, new { error = "internal_error", message = "Failed to confirm verification token." });
        }
    }

    /// <summary>
    /// POST /v1/evidence/profile-links/{id}/verify-intent - Verify via Share-Intent method
    /// </summary>
    [HttpPost("profile-links/{id}/verify-intent")]
    public async Task<IActionResult> VerifyShareIntent(Guid id, [FromBody] VerifyShareIntentRequest request)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        if (string.IsNullOrWhiteSpace(request.SharedUrl))
        {
            return BadRequest(new { error = "invalid_request", message = "SharedUrl is required." });
        }

        if (string.IsNullOrWhiteSpace(request.DeviceFingerprint))
        {
            return BadRequest(new { error = "invalid_request", message = "DeviceFingerprint is required." });
        }

        try
        {
            var userId = GetUserId();

            var profileLink = await _evidenceService.VerifyShareIntentAsync(id, userId, request.SharedUrl, request.DeviceFingerprint);

            if (profileLink == null)
            {
                return BadRequest(new { error = "verification_failed", message = "Share-Intent verification failed. Please ensure the shared URL matches your profile URL." });
            }

            _logger.LogInformation("Share-Intent verification confirmed for profile link {ProfileLinkId}, user {UserId}", id, userId);

            return Ok(new
            {
                id = profileLink.Id,
                url = profileLink.URL,
                platform = profileLink.Platform.ToString(),
                verificationLevel = profileLink.VerificationLevel,
                verificationMethod = profileLink.VerificationMethod,
                ownershipLockedAt = profileLink.OwnershipLockedAt,
                nextReverifyAt = profileLink.NextReverifyAt,
                integrityScore = profileLink.IntegrityScore,
                message = "Profile successfully verified via Share-Intent!"
            });
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Share-Intent verification failed for profile link {ProfileLinkId}", id);
            return BadRequest(new { error = "verification_failed", message = ex.Message });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error verifying share intent for profile link {ProfileLinkId}", id);
            return StatusCode(500, new { error = "internal_error", message = "Failed to verify share intent." });
        }
    }

    /// <summary>
    /// GET /v1/evidence/profile-links/{id}/ownership-check - Check if profile URL is already verified by another user
    /// </summary>
    [HttpGet("profile-links/ownership-check")]
    public async Task<IActionResult> CheckProfileOwnership([FromQuery] string url)
    {
        if (string.IsNullOrWhiteSpace(url))
        {
            return BadRequest(new { error = "invalid_request", message = "URL is required." });
        }

        try
        {
            var isOwned = await _evidenceService.IsProfileAlreadyVerifiedByAnotherUserAsync(url);

            return Ok(new
            {
                url = url,
                isOwnedByAnother = isOwned,
                message = isOwned
                    ? "This profile is already verified by another SilentID account."
                    : "This profile is available for verification."
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error checking profile ownership for URL {Url}", url);
            return StatusCode(500, new { error = "internal_error", message = "Failed to check profile ownership." });
        }
    }

    // ========== EXTRACTION ENDPOINTS (Section 49) ==========

    /// <summary>
    /// POST /v1/evidence/profile-links/{id}/consent - Record user consent before extraction
    /// Required before any extraction can occur.
    /// </summary>
    [HttpPost("profile-links/{id}/consent")]
    public async Task<IActionResult> RecordConsent(Guid id)
    {
        try
        {
            var userId = GetUserId();

            // Get client IP address
            var ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown";

            // Check for forwarded headers (behind proxy/load balancer)
            if (HttpContext.Request.Headers.TryGetValue("X-Forwarded-For", out var forwardedFor))
            {
                ipAddress = forwardedFor.ToString().Split(',')[0].Trim();
            }

            await _extractionService.RecordConsentAsync(id, userId, ipAddress);

            _logger.LogInformation(
                "Consent recorded for profile link {ProfileLinkId}, user {UserId}, IP {IP}",
                id, userId, ipAddress);

            return Ok(new
            {
                profileLinkId = id,
                consentRecorded = true,
                timestamp = DateTime.UtcNow,
                message = "Consent recorded. You can now upload screenshots or trigger extraction."
            });
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Failed to record consent for profile link {ProfileLinkId}", id);
            return NotFound(new { error = "not_found", message = ex.Message });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error recording consent for profile link {ProfileLinkId}", id);
            return StatusCode(500, new { error = "internal_error", message = "Failed to record consent." });
        }
    }

    /// <summary>
    /// POST /v1/evidence/profile-links/{id}/screenshots - Upload manual screenshot for extraction
    /// Maximum 3 screenshots allowed per profile link.
    /// </summary>
    [HttpPost("profile-links/{id}/screenshots")]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> UploadManualScreenshot(Guid id, [FromForm] IFormFile file)
    {
        // Validate file
        if (file == null || file.Length == 0)
        {
            return BadRequest(new { error = "invalid_file", message = "Please provide a valid file." });
        }

        // Validate file type (images only)
        var allowedContentTypes = new[] { "image/jpeg", "image/jpg", "image/png", "image/webp" };
        if (!allowedContentTypes.Contains(file.ContentType.ToLowerInvariant()))
        {
            return BadRequest(new { error = "invalid_file_type", message = "Only image files (JPEG, PNG, WebP) are allowed." });
        }

        // Validate file size (max 10MB)
        const int maxFileSizeBytes = 10 * 1024 * 1024;
        if (file.Length > maxFileSizeBytes)
        {
            return BadRequest(new { error = "file_too_large", message = "File size must not exceed 10MB." });
        }

        try
        {
            var userId = GetUserId();

            using var fileStream = file.OpenReadStream();
            var result = await _extractionService.ProcessManualScreenshotAsync(id, userId, fileStream, file.FileName);

            if (!result.Success)
            {
                return BadRequest(new { error = "upload_failed", message = result.ErrorMessage });
            }

            _logger.LogInformation(
                "Manual screenshot uploaded for profile link {ProfileLinkId}, user {UserId}",
                id, userId);

            return Ok(new
            {
                profileLinkId = id,
                screenshotUploaded = true,
                method = result.Method.ToString(),
                confidenceScore = result.ConfidenceScore,
                message = "Screenshot uploaded successfully. Upload more screenshots to increase confidence score (max 3)."
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error uploading manual screenshot for profile link {ProfileLinkId}", id);
            return StatusCode(500, new { error = "internal_error", message = "Failed to upload screenshot." });
        }
    }

    /// <summary>
    /// POST /v1/evidence/profile-links/{id}/extract - Trigger profile data extraction
    /// Requires ownership verified (Level 3) and consent recorded.
    /// </summary>
    [HttpPost("profile-links/{id}/extract")]
    public async Task<IActionResult> ExtractProfileData(Guid id)
    {
        try
        {
            var userId = GetUserId();

            var result = await _extractionService.ExtractProfileDataAsync(id, userId);

            if (!result.Success)
            {
                // If extraction failed due to ownership/consent, return specific error
                if (result.ErrorMessage?.Contains("Ownership") == true)
                {
                    return BadRequest(new
                    {
                        error = "ownership_required",
                        message = result.ErrorMessage,
                        action = "Complete Level 3 verification (Share-Intent or Token-in-Bio) before extracting data."
                    });
                }

                if (result.ErrorMessage?.Contains("consent") == true)
                {
                    return BadRequest(new
                    {
                        error = "consent_required",
                        message = result.ErrorMessage,
                        action = "Call POST /v1/evidence/profile-links/{id}/consent to confirm this is your profile."
                    });
                }

                // Extraction not supported - suggest manual screenshot
                return Ok(new
                {
                    profileLinkId = id,
                    extractionSuccess = false,
                    suggestedMethod = "ManualScreenshot",
                    message = result.ErrorMessage,
                    action = "Upload up to 3 screenshots via POST /v1/evidence/profile-links/{id}/screenshots"
                });
            }

            _logger.LogInformation(
                "Profile data extracted for {ProfileLinkId}: Rating={Rating}, Reviews={Reviews}, Confidence={Confidence}%",
                id, result.Rating, result.ReviewCount, result.ConfidenceScore);

            return Ok(new
            {
                profileLinkId = id,
                extractionSuccess = true,
                method = result.Method.ToString(),
                data = new
                {
                    rating = result.Rating,
                    reviewCount = result.ReviewCount,
                    username = result.Username,
                    joinDate = result.JoinDate
                },
                confidenceScore = result.ConfidenceScore,
                htmlMatch = result.HtmlExtractionMatch,
                message = "Profile data extracted successfully!"
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error extracting profile data for profile link {ProfileLinkId}", id);
            return StatusCode(500, new { error = "internal_error", message = "Failed to extract profile data." });
        }
    }

    /// <summary>
    /// GET /v1/evidence/profile-links/{id}/extraction-status - Get extraction status and data
    /// </summary>
    [HttpGet("profile-links/{id}/extraction-status")]
    public async Task<IActionResult> GetExtractionStatus(Guid id)
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
                profileLinkId = id,
                verificationLevel = profileLink.VerificationLevel,
                ownershipVerified = profileLink.OwnershipLockedAt != null,
                consentRecorded = profileLink.ConsentConfirmedAt != null,
                extraction = new
                {
                    method = profileLink.ExtractionMethod,
                    confidence = profileLink.ExtractionConfidence,
                    extractedAt = profileLink.ExtractedAt,
                    htmlMatch = profileLink.HtmlExtractionMatch
                },
                data = new
                {
                    rating = profileLink.PlatformRating,
                    reviewCount = profileLink.ReviewCount,
                    joinDate = profileLink.ProfileJoinDate
                },
                manualScreenshots = new
                {
                    count = profileLink.ManualScreenshotCount,
                    maxAllowed = 3
                }
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting extraction status for profile link {ProfileLinkId}", id);
            return StatusCode(500, new { error = "internal_error", message = "Failed to get extraction status." });
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

public class AddProfileLinkRequest
{
    public string Url { get; set; } = string.Empty;
    public Platform Platform { get; set; }
}

public class ConfirmTokenRequest
{
    public string ScrapedBioText { get; set; } = string.Empty;
}

public class VerifyShareIntentRequest
{
    public string SharedUrl { get; set; } = string.Empty;
    public string DeviceFingerprint { get; set; } = string.Empty;
}
