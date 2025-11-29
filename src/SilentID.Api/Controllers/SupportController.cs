using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Models;
using SilentID.Api.Services;
using System.Security.Claims;

namespace SilentID.Api.Controllers;

/// <summary>
/// Controller for support tickets.
/// Provides a unified help system accessible anywhere in the app.
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class SupportController : ControllerBase
{
    private readonly SupportTicketService _ticketService;
    private readonly ILogger<SupportController> _logger;

    public SupportController(
        SupportTicketService ticketService,
        ILogger<SupportController> logger)
    {
        _ticketService = ticketService;
        _logger = logger;
    }

    /// <summary>
    /// Submit a new support ticket.
    /// Can be called by authenticated users or anonymously (for login issues).
    /// </summary>
    [HttpPost("tickets")]
    [AllowAnonymous]
    [ProducesResponseType(typeof(CreateTicketResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> CreateTicket([FromBody] CreateSupportTicketRequest request)
    {
        var userId = GetCurrentUserId();

        // Validate
        if (string.IsNullOrWhiteSpace(request.Message))
        {
            return BadRequest(new { error = "Message is required" });
        }

        if (userId == null && string.IsNullOrWhiteSpace(request.ContactEmail))
        {
            return BadRequest(new { error = "Contact email is required for anonymous tickets" });
        }

        // Get client info
        var ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString();

        var result = await _ticketService.CreateTicketAsync(new CreateTicketRequest
        {
            UserId = userId,
            ContactEmail = request.ContactEmail,
            Category = request.Category,
            Subject = string.IsNullOrWhiteSpace(request.Subject)
                ? GetDefaultSubject(request.Category)
                : request.Subject,
            Message = request.Message,
            DeviceInfo = request.DeviceInfo,
            AppVersion = request.AppVersion,
            Platform = request.Platform,
            IpAddress = ipAddress
        });

        if (!result.IsSuccess)
        {
            return BadRequest(new { error = result.ErrorMessage });
        }

        return Ok(new CreateTicketResponse
        {
            Success = true,
            Message = "Thanks — our support team will review this shortly.",
            TicketId = result.TicketId
        });
    }

    /// <summary>
    /// Get the current user's support tickets.
    /// </summary>
    [HttpGet("tickets")]
    [Authorize]
    [ProducesResponseType(typeof(List<SupportTicketSummary>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetMyTickets()
    {
        var userId = GetCurrentUserId();
        if (userId == null)
        {
            return Unauthorized();
        }

        var tickets = await _ticketService.GetUserTicketsAsync(userId.Value);

        var summaries = tickets.Select(t => new SupportTicketSummary
        {
            Id = t.Id,
            Category = t.CategoryText,
            Subject = t.Subject,
            Status = t.StatusText,
            CreatedAt = t.CreatedAt
        }).ToList();

        return Ok(summaries);
    }

    private static string GetDefaultSubject(SupportCategory category)
    {
        return category switch
        {
            SupportCategory.AccountLogin => "Account/Login Help",
            SupportCategory.VerificationHelp => "Verification Assistance",
            SupportCategory.TechnicalIssue => "Technical Support",
            SupportCategory.GeneralQuestion => "General Inquiry",
            SupportCategory.Billing => "Billing Question",
            SupportCategory.PrivacyData => "Privacy/Data Request",
            _ => "Support Request"
        };
    }

    private Guid? GetCurrentUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value
                       ?? User.FindFirst("sub")?.Value;

        return Guid.TryParse(userIdClaim, out var userId) ? userId : null;
    }
}

/// <summary>
/// Request to create a support ticket.
/// </summary>
public class CreateSupportTicketRequest
{
    /// <summary>
    /// Contact email (required for anonymous tickets).
    /// </summary>
    public string? ContactEmail { get; set; }

    /// <summary>
    /// Category of the support request.
    /// </summary>
    public SupportCategory Category { get; set; }

    /// <summary>
    /// Subject/title (optional, will auto-generate if empty).
    /// </summary>
    public string? Subject { get; set; }

    /// <summary>
    /// User's message describing the issue.
    /// </summary>
    public string Message { get; set; } = string.Empty;

    /// <summary>
    /// Device information (auto-attached by app).
    /// </summary>
    public string? DeviceInfo { get; set; }

    /// <summary>
    /// App version (auto-attached by app).
    /// </summary>
    public string? AppVersion { get; set; }

    /// <summary>
    /// Platform (iOS/Android/Web).
    /// </summary>
    public string? Platform { get; set; }
}

/// <summary>
/// Response after creating a ticket.
/// </summary>
public class CreateTicketResponse
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public Guid TicketId { get; set; }
}

/// <summary>
/// Summary of a support ticket for the user's view.
/// </summary>
public class SupportTicketSummary
{
    public Guid Id { get; set; }
    public string Category { get; set; } = string.Empty;
    public string Subject { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; }
}
