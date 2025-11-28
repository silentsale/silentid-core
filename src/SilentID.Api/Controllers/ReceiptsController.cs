using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Services;

namespace SilentID.Api.Controllers;

/// <summary>
/// API endpoints for receipt evidence management.
/// Section 47.4 - Email Receipt Forwarding (Expensify Model)
/// </summary>
[ApiController]
[Route("v1/receipts")]
[Authorize]
public class ReceiptsController : ControllerBase
{
    private readonly IForwardingAliasService _aliasService;
    private readonly IReceiptParsingService _receiptService;
    private readonly ILogger<ReceiptsController> _logger;

    public ReceiptsController(
        IForwardingAliasService aliasService,
        IReceiptParsingService receiptService,
        ILogger<ReceiptsController> logger)
    {
        _aliasService = aliasService;
        _receiptService = receiptService;
        _logger = logger;
    }

    /// <summary>
    /// Gets the user's unique receipt forwarding email address.
    /// Creates one if it doesn't exist.
    /// </summary>
    /// <returns>The forwarding email and setup instructions.</returns>
    [HttpGet("forwarding-alias")]
    [ProducesResponseType(typeof(ForwardingAliasResponse), 200)]
    public async Task<IActionResult> GetForwardingAlias()
    {
        var userId = GetUserId();
        if (userId == null) return Unauthorized();

        var forwardingEmail = await _aliasService.GetForwardingEmailAsync(userId.Value);

        return Ok(new ForwardingAliasResponse
        {
            ForwardingEmail = forwardingEmail,
            Instructions = new SetupInstructions
            {
                Gmail = new[]
                {
                    "1. Open Gmail Settings → Filters and Blocked Addresses",
                    "2. Click 'Create a new filter'",
                    "3. In 'From' field, enter: vinted.com OR ebay.com OR depop.com OR etsy.com OR paypal.com",
                    $"4. Click 'Create filter' → 'Forward it to' → {forwardingEmail}",
                    "5. Done! Receipts will be automatically forwarded."
                },
                Outlook = new[]
                {
                    "1. Open Outlook → Settings → Mail → Rules",
                    "2. Click 'Add new rule'",
                    "3. Name it 'Forward Receipts to SilentID'",
                    "4. Condition: 'From contains' → vinted.com, ebay.com, depop.com, etsy.com, paypal.com",
                    $"5. Action: 'Forward to' → {forwardingEmail}",
                    "6. Save the rule."
                },
                Manual = new[]
                {
                    $"Forward any marketplace receipt email to: {forwardingEmail}",
                    "We accept receipts from: Vinted, eBay, Depop, Etsy, PayPal, Stripe, Facebook Marketplace"
                }
            },
            SupportedPlatforms = new[]
            {
                new SupportedPlatform { Name = "Vinted", Domain = "vinted.co.uk", Icon = "vinted" },
                new SupportedPlatform { Name = "eBay", Domain = "ebay.co.uk", Icon = "ebay" },
                new SupportedPlatform { Name = "Depop", Domain = "depop.com", Icon = "depop" },
                new SupportedPlatform { Name = "Etsy", Domain = "etsy.com", Icon = "etsy" },
                new SupportedPlatform { Name = "PayPal", Domain = "paypal.com", Icon = "paypal" },
                new SupportedPlatform { Name = "Facebook Marketplace", Domain = "facebook.com", Icon = "facebook" },
            }
        });
    }

    /// <summary>
    /// Gets all receipt evidence for the authenticated user.
    /// </summary>
    [HttpGet]
    [ProducesResponseType(typeof(ReceiptListResponse), 200)]
    public async Task<IActionResult> GetReceipts()
    {
        var userId = GetUserId();
        if (userId == null) return Unauthorized();

        var receipts = await _receiptService.GetUserReceiptsAsync(userId.Value);

        return Ok(new ReceiptListResponse
        {
            Receipts = receipts.Select(r => new ReceiptDto
            {
                Id = r.Id,
                Platform = r.Platform.ToString(),
                OrderId = r.OrderId,
                Item = r.Item,
                Amount = r.Amount,
                Currency = r.Currency,
                Role = r.Role.ToString(),
                Date = r.Date,
                IntegrityScore = r.IntegrityScore,
                Status = r.EvidenceState.ToString(),
                CreatedAt = r.CreatedAt
            }).ToList(),
            TotalCount = receipts.Count,
            ValidCount = receipts.Count(r => r.EvidenceState == Models.EvidenceState.Valid)
        });
    }

    /// <summary>
    /// Gets receipt count summary for the authenticated user.
    /// </summary>
    [HttpGet("count")]
    [ProducesResponseType(typeof(ReceiptCountResponse), 200)]
    public async Task<IActionResult> GetReceiptCount()
    {
        var userId = GetUserId();
        if (userId == null) return Unauthorized();

        var count = await _receiptService.GetUserReceiptCountAsync(userId.Value);

        return Ok(new ReceiptCountResponse
        {
            ValidCount = count
        });
    }

    private Guid? GetUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        return Guid.TryParse(userIdClaim, out var userId) ? userId : null;
    }
}

#region Response DTOs

public class ForwardingAliasResponse
{
    public string ForwardingEmail { get; set; } = string.Empty;
    public SetupInstructions Instructions { get; set; } = new();
    public SupportedPlatform[] SupportedPlatforms { get; set; } = Array.Empty<SupportedPlatform>();
}

public class SetupInstructions
{
    public string[] Gmail { get; set; } = Array.Empty<string>();
    public string[] Outlook { get; set; } = Array.Empty<string>();
    public string[] Manual { get; set; } = Array.Empty<string>();
}

public class SupportedPlatform
{
    public string Name { get; set; } = string.Empty;
    public string Domain { get; set; } = string.Empty;
    public string Icon { get; set; } = string.Empty;
}

public class ReceiptListResponse
{
    public List<ReceiptDto> Receipts { get; set; } = new();
    public int TotalCount { get; set; }
    public int ValidCount { get; set; }
}

public class ReceiptDto
{
    public Guid Id { get; set; }
    public string Platform { get; set; } = string.Empty;
    public string? OrderId { get; set; }
    public string? Item { get; set; }
    public decimal Amount { get; set; }
    public string Currency { get; set; } = "GBP";
    public string Role { get; set; } = "Buyer";
    public DateTime Date { get; set; }
    public int IntegrityScore { get; set; }
    public string Status { get; set; } = "Valid";
    public DateTime CreatedAt { get; set; }
}

public class ReceiptCountResponse
{
    public int ValidCount { get; set; }
}

#endregion
