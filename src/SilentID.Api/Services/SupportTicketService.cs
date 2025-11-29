using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

/// <summary>
/// Service for managing support tickets.
/// </summary>
public class SupportTicketService
{
    private readonly SilentIdDbContext _context;
    private readonly ILogger<SupportTicketService> _logger;

    public SupportTicketService(
        SilentIdDbContext context,
        ILogger<SupportTicketService> logger)
    {
        _context = context;
        _logger = logger;
    }

    /// <summary>
    /// Create a new support ticket.
    /// </summary>
    public async Task<SupportTicketResult> CreateTicketAsync(CreateTicketRequest request)
    {
        var ticket = new SupportTicket
        {
            Id = Guid.NewGuid(),
            UserId = request.UserId,
            ContactEmail = request.ContactEmail,
            Category = request.Category,
            Subject = request.Subject,
            Message = request.Message,
            DeviceInfo = request.DeviceInfo,
            AppVersion = request.AppVersion,
            Platform = request.Platform,
            IpAddress = request.IpAddress,
            Status = TicketStatus.New,
            Priority = DeterminePriority(request.Category),
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        };

        _context.SupportTickets.Add(ticket);
        await _context.SaveChangesAsync();

        _logger.LogInformation(
            "Support ticket created: {TicketId} for user {UserId}, category: {Category}",
            ticket.Id, request.UserId?.ToString() ?? "anonymous", request.Category);

        return SupportTicketResult.Success(ticket.Id);
    }

    /// <summary>
    /// Determine ticket priority based on category.
    /// </summary>
    private static TicketPriority DeterminePriority(SupportCategory category)
    {
        return category switch
        {
            SupportCategory.AccountLogin => TicketPriority.High,
            SupportCategory.VerificationHelp => TicketPriority.Normal,
            SupportCategory.TechnicalIssue => TicketPriority.Normal,
            SupportCategory.GeneralQuestion => TicketPriority.Low,
            SupportCategory.Billing => TicketPriority.High,
            SupportCategory.PrivacyData => TicketPriority.High,
            _ => TicketPriority.Normal
        };
    }

    /// <summary>
    /// Get tickets for a specific user.
    /// </summary>
    public async Task<List<SupportTicketDto>> GetUserTicketsAsync(Guid userId)
    {
        var tickets = await _context.SupportTickets
            .Where(t => t.UserId == userId)
            .OrderByDescending(t => t.CreatedAt)
            .ToListAsync();

        return tickets.Select(MapToDto).ToList();
    }

    /// <summary>
    /// Get all tickets for admin review.
    /// </summary>
    public async Task<List<SupportTicketDto>> GetAllTicketsAsync(
        TicketStatus? statusFilter = null,
        SupportCategory? categoryFilter = null,
        TicketPriority? priorityFilter = null,
        DateTime? fromDate = null,
        DateTime? toDate = null,
        int page = 1,
        int pageSize = 20)
    {
        var query = _context.SupportTickets
            .Include(t => t.User)
            .AsQueryable();

        if (statusFilter.HasValue)
            query = query.Where(t => t.Status == statusFilter.Value);

        if (categoryFilter.HasValue)
            query = query.Where(t => t.Category == categoryFilter.Value);

        if (priorityFilter.HasValue)
            query = query.Where(t => t.Priority == priorityFilter.Value);

        if (fromDate.HasValue)
            query = query.Where(t => t.CreatedAt >= fromDate.Value);

        if (toDate.HasValue)
            query = query.Where(t => t.CreatedAt <= toDate.Value);

        var tickets = await query
            .OrderByDescending(t => t.Priority)
            .ThenByDescending(t => t.CreatedAt)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();

        return tickets.Select(t => new SupportTicketDto
        {
            Id = t.Id,
            UserId = t.UserId,
            UserEmail = t.User?.Email ?? t.ContactEmail,
            UserDisplayName = t.User?.DisplayName ?? "Anonymous",
            ContactEmail = t.ContactEmail,
            Category = t.Category,
            CategoryText = GetCategoryText(t.Category),
            Subject = t.Subject,
            Message = t.Message,
            DeviceInfo = t.DeviceInfo,
            AppVersion = t.AppVersion,
            Platform = t.Platform,
            Status = t.Status,
            StatusText = t.Status.ToString(),
            Priority = t.Priority,
            PriorityText = t.Priority.ToString(),
            AdminNotes = t.AdminNotes,
            AssignedToAdminId = t.AssignedToAdminId,
            ResolvedAt = t.ResolvedAt,
            ResolutionNotes = t.ResolutionNotes,
            CreatedAt = t.CreatedAt,
            UpdatedAt = t.UpdatedAt
        }).ToList();
    }

    /// <summary>
    /// Get a single ticket by ID.
    /// </summary>
    public async Task<SupportTicketDto?> GetTicketByIdAsync(Guid id)
    {
        var ticket = await _context.SupportTickets
            .Include(t => t.User)
            .FirstOrDefaultAsync(t => t.Id == id);

        if (ticket == null) return null;

        return new SupportTicketDto
        {
            Id = ticket.Id,
            UserId = ticket.UserId,
            UserEmail = ticket.User?.Email ?? ticket.ContactEmail,
            UserDisplayName = ticket.User?.DisplayName ?? "Anonymous",
            ContactEmail = ticket.ContactEmail,
            Category = ticket.Category,
            CategoryText = GetCategoryText(ticket.Category),
            Subject = ticket.Subject,
            Message = ticket.Message,
            DeviceInfo = ticket.DeviceInfo,
            AppVersion = ticket.AppVersion,
            Platform = ticket.Platform,
            IpAddress = ticket.IpAddress,
            Status = ticket.Status,
            StatusText = ticket.Status.ToString(),
            Priority = ticket.Priority,
            PriorityText = ticket.Priority.ToString(),
            AdminNotes = ticket.AdminNotes,
            AssignedToAdminId = ticket.AssignedToAdminId,
            ResolvedAt = ticket.ResolvedAt,
            ResolutionNotes = ticket.ResolutionNotes,
            CreatedAt = ticket.CreatedAt,
            UpdatedAt = ticket.UpdatedAt
        };
    }

    /// <summary>
    /// Update ticket (admin only).
    /// </summary>
    public async Task<bool> UpdateTicketAsync(
        Guid ticketId,
        TicketStatus? newStatus = null,
        TicketPriority? newPriority = null,
        string? adminNotes = null,
        Guid? assignedToAdminId = null,
        string? resolutionNotes = null)
    {
        var ticket = await _context.SupportTickets.FindAsync(ticketId);
        if (ticket == null) return false;

        if (newStatus.HasValue)
        {
            ticket.Status = newStatus.Value;
            if (newStatus.Value == TicketStatus.Resolved)
            {
                ticket.ResolvedAt = DateTime.UtcNow;
            }
        }

        if (newPriority.HasValue)
            ticket.Priority = newPriority.Value;

        if (adminNotes != null)
            ticket.AdminNotes = adminNotes;

        if (assignedToAdminId.HasValue)
            ticket.AssignedToAdminId = assignedToAdminId;

        if (resolutionNotes != null)
            ticket.ResolutionNotes = resolutionNotes;

        ticket.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        _logger.LogInformation(
            "Support ticket {TicketId} updated. Status: {Status}",
            ticketId, ticket.Status);

        return true;
    }

    /// <summary>
    /// Get count of tickets by status.
    /// </summary>
    public async Task<Dictionary<TicketStatus, int>> GetTicketCountsByStatusAsync()
    {
        return await _context.SupportTickets
            .GroupBy(t => t.Status)
            .Select(g => new { Status = g.Key, Count = g.Count() })
            .ToDictionaryAsync(x => x.Status, x => x.Count);
    }

    /// <summary>
    /// Get human-readable text for category.
    /// </summary>
    public static string GetCategoryText(SupportCategory category)
    {
        return category switch
        {
            SupportCategory.AccountLogin => "Account/Login",
            SupportCategory.VerificationHelp => "Verification Help",
            SupportCategory.TechnicalIssue => "Technical Issue",
            SupportCategory.GeneralQuestion => "General Question",
            SupportCategory.Billing => "Billing/Subscription",
            SupportCategory.PrivacyData => "Privacy/Data",
            _ => "Unknown"
        };
    }

    private static SupportTicketDto MapToDto(SupportTicket t)
    {
        return new SupportTicketDto
        {
            Id = t.Id,
            UserId = t.UserId,
            ContactEmail = t.ContactEmail,
            Category = t.Category,
            CategoryText = GetCategoryText(t.Category),
            Subject = t.Subject,
            Message = t.Message,
            Status = t.Status,
            StatusText = t.Status.ToString(),
            Priority = t.Priority,
            PriorityText = t.Priority.ToString(),
            CreatedAt = t.CreatedAt,
            UpdatedAt = t.UpdatedAt
        };
    }
}

/// <summary>
/// Request to create a support ticket.
/// </summary>
public class CreateTicketRequest
{
    public Guid? UserId { get; set; }
    public string? ContactEmail { get; set; }
    public SupportCategory Category { get; set; }
    public string Subject { get; set; } = string.Empty;
    public string Message { get; set; } = string.Empty;
    public string? DeviceInfo { get; set; }
    public string? AppVersion { get; set; }
    public string? Platform { get; set; }
    public string? IpAddress { get; set; }
}

/// <summary>
/// Result of creating a support ticket.
/// </summary>
public class SupportTicketResult
{
    public bool IsSuccess { get; set; }
    public string? ErrorMessage { get; set; }
    public Guid TicketId { get; set; }

    public static SupportTicketResult Success(Guid ticketId) => new()
    {
        IsSuccess = true,
        TicketId = ticketId
    };

    public static SupportTicketResult Failed(string message) => new()
    {
        IsSuccess = false,
        ErrorMessage = message
    };
}

/// <summary>
/// DTO for support ticket data.
/// </summary>
public class SupportTicketDto
{
    public Guid Id { get; set; }
    public Guid? UserId { get; set; }
    public string? UserEmail { get; set; }
    public string? UserDisplayName { get; set; }
    public string? ContactEmail { get; set; }
    public SupportCategory Category { get; set; }
    public string CategoryText { get; set; } = string.Empty;
    public string Subject { get; set; } = string.Empty;
    public string Message { get; set; } = string.Empty;
    public string? DeviceInfo { get; set; }
    public string? AppVersion { get; set; }
    public string? Platform { get; set; }
    public string? IpAddress { get; set; }
    public TicketStatus Status { get; set; }
    public string StatusText { get; set; } = string.Empty;
    public TicketPriority Priority { get; set; }
    public string PriorityText { get; set; } = string.Empty;
    public string? AdminNotes { get; set; }
    public Guid? AssignedToAdminId { get; set; }
    public DateTime? ResolvedAt { get; set; }
    public string? ResolutionNotes { get; set; }
    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }
}
