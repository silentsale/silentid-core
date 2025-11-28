using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Services;

namespace SilentID.Api.Controllers;

/// <summary>
/// Webhook endpoint for SendGrid Inbound Parse.
/// Receives forwarded receipt emails and processes them.
/// Section 47.4 - Email Receipt Forwarding (Expensify Model)
/// </summary>
[ApiController]
[Route("webhooks")]
public class ReceiptParseController : ControllerBase
{
    private readonly IReceiptParsingService _receiptService;
    private readonly ILogger<ReceiptParseController> _logger;
    private readonly IConfiguration _configuration;

    public ReceiptParseController(
        IReceiptParsingService receiptService,
        ILogger<ReceiptParseController> logger,
        IConfiguration configuration)
    {
        _receiptService = receiptService;
        _logger = logger;
        _configuration = configuration;
    }

    /// <summary>
    /// SendGrid Inbound Parse webhook endpoint.
    /// Receives POST with multipart/form-data containing parsed email data.
    /// </summary>
    /// <remarks>
    /// SendGrid sends the following fields:
    /// - to: recipient email address
    /// - from: sender email address
    /// - subject: email subject
    /// - text: plain text body
    /// - html: HTML body
    /// - SPF: SPF verification result
    /// - dkim: DKIM verification result
    /// - envelope: JSON envelope data
    /// </remarks>
    [HttpPost("sendgrid/inbound")]
    [Consumes("multipart/form-data")]
    public async Task<IActionResult> ReceiveInboundEmail([FromForm] SendGridInboundPayload payload)
    {
        _logger.LogInformation("Received inbound email webhook from SendGrid");

        // Validate webhook secret (optional but recommended)
        var expectedSecret = _configuration["SendGrid:InboundWebhookSecret"];
        if (!string.IsNullOrEmpty(expectedSecret))
        {
            var providedSecret = Request.Headers["X-Webhook-Secret"].FirstOrDefault();
            if (providedSecret != expectedSecret)
            {
                _logger.LogWarning("Invalid webhook secret provided");
                return Unauthorized();
            }
        }

        // Log basic info (without sensitive content)
        _logger.LogInformation(
            "Processing email: To={To}, From={From}, Subject={Subject}",
            payload.To,
            MaskEmail(payload.From),
            payload.Subject?.Length > 50 ? payload.Subject[..50] + "..." : payload.Subject);

        // Convert to internal model
        var emailData = new InboundEmailData
        {
            To = payload.To ?? string.Empty,
            From = payload.From ?? string.Empty,
            Subject = payload.Subject ?? string.Empty,
            Text = payload.Text ?? string.Empty,
            Html = payload.Html ?? string.Empty,
            SPF = payload.SPF ?? string.Empty,
            DKIM = payload.Dkim ?? string.Empty,
            Envelope = payload.Envelope ?? string.Empty
        };

        // Process the email
        var result = await _receiptService.ProcessInboundEmailAsync(emailData);

        if (result.Success)
        {
            _logger.LogInformation(
                "Successfully processed receipt: Platform={Platform}, ReceiptId={ReceiptId}",
                result.DetectedPlatform,
                result.ReceiptId);

            return Ok(new { success = true, receiptId = result.ReceiptId });
        }
        else
        {
            _logger.LogWarning("Failed to process receipt: {Error}", result.ErrorMessage);

            // Return 200 OK even on failure to prevent SendGrid retries
            // (we've acknowledged receipt, just couldn't process it)
            return Ok(new { success = false, error = result.ErrorMessage });
        }
    }

    /// <summary>
    /// Health check endpoint for webhook verification.
    /// </summary>
    [HttpGet("sendgrid/inbound/health")]
    public IActionResult HealthCheck()
    {
        return Ok(new { status = "healthy", timestamp = DateTime.UtcNow });
    }

    /// <summary>
    /// Masks email address for logging.
    /// </summary>
    private static string MaskEmail(string? email)
    {
        if (string.IsNullOrEmpty(email)) return "[empty]";

        var atIndex = email.IndexOf('@');
        if (atIndex <= 1) return "***@" + (atIndex > 0 ? email[(atIndex + 1)..] : "***");

        return email[0] + "***" + email[(atIndex - 1)..];
    }
}

/// <summary>
/// Payload model for SendGrid Inbound Parse webhook.
/// SendGrid sends form data with these field names.
/// </summary>
public class SendGridInboundPayload
{
    /// <summary>
    /// Recipient email address(es).
    /// </summary>
    [FromForm(Name = "to")]
    public string? To { get; set; }

    /// <summary>
    /// Sender email address.
    /// </summary>
    [FromForm(Name = "from")]
    public string? From { get; set; }

    /// <summary>
    /// Email subject line.
    /// </summary>
    [FromForm(Name = "subject")]
    public string? Subject { get; set; }

    /// <summary>
    /// Plain text email body.
    /// </summary>
    [FromForm(Name = "text")]
    public string? Text { get; set; }

    /// <summary>
    /// HTML email body.
    /// </summary>
    [FromForm(Name = "html")]
    public string? Html { get; set; }

    /// <summary>
    /// SPF verification result.
    /// </summary>
    [FromForm(Name = "SPF")]
    public string? SPF { get; set; }

    /// <summary>
    /// DKIM verification result.
    /// </summary>
    [FromForm(Name = "dkim")]
    public string? Dkim { get; set; }

    /// <summary>
    /// JSON string containing envelope information.
    /// </summary>
    [FromForm(Name = "envelope")]
    public string? Envelope { get; set; }

    /// <summary>
    /// Number of attachments.
    /// </summary>
    [FromForm(Name = "attachments")]
    public int Attachments { get; set; }
}
