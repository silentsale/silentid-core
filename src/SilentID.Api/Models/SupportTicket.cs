using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Support tickets for user assistance requests.
/// Private and visible only to admins.
/// </summary>
public class SupportTicket
{
    [Key]
    public Guid Id { get; set; }

    /// <summary>
    /// User who submitted the ticket (nullable for pre-auth support requests).
    /// </summary>
    public Guid? UserId { get; set; }
    public User? User { get; set; }

    /// <summary>
    /// Email for anonymous/pre-auth tickets.
    /// </summary>
    [MaxLength(255)]
    public string? ContactEmail { get; set; }

    /// <summary>
    /// Category of the support request.
    /// </summary>
    public SupportCategory Category { get; set; }

    /// <summary>
    /// Subject/title of the ticket.
    /// </summary>
    [Required]
    [MaxLength(200)]
    public string Subject { get; set; } = string.Empty;

    /// <summary>
    /// User's message describing the issue.
    /// </summary>
    [Required]
    [MaxLength(4000)]
    public string Message { get; set; } = string.Empty;

    /// <summary>
    /// Device information auto-attached.
    /// </summary>
    [MaxLength(500)]
    public string? DeviceInfo { get; set; }

    /// <summary>
    /// App version.
    /// </summary>
    [MaxLength(50)]
    public string? AppVersion { get; set; }

    /// <summary>
    /// Platform (iOS/Android/Web).
    /// </summary>
    [MaxLength(20)]
    public string? Platform { get; set; }

    /// <summary>
    /// IP address of the requester.
    /// </summary>
    [MaxLength(50)]
    public string? IpAddress { get; set; }

    /// <summary>
    /// Current status of the ticket.
    /// </summary>
    public TicketStatus Status { get; set; } = TicketStatus.New;

    /// <summary>
    /// Priority level.
    /// </summary>
    public TicketPriority Priority { get; set; } = TicketPriority.Normal;

    /// <summary>
    /// Internal admin notes (not visible to users).
    /// </summary>
    [MaxLength(4000)]
    public string? AdminNotes { get; set; }

    /// <summary>
    /// Admin assigned to handle this ticket.
    /// </summary>
    public Guid? AssignedToAdminId { get; set; }

    /// <summary>
    /// When the ticket was resolved.
    /// </summary>
    public DateTime? ResolvedAt { get; set; }

    /// <summary>
    /// Resolution summary.
    /// </summary>
    [MaxLength(2000)]
    public string? ResolutionNotes { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}

/// <summary>
/// Support ticket categories.
/// </summary>
public enum SupportCategory
{
    /// <summary>
    /// Account/Login issues.
    /// </summary>
    AccountLogin = 1,

    /// <summary>
    /// Verification Help.
    /// </summary>
    VerificationHelp = 2,

    /// <summary>
    /// Technical Issue.
    /// </summary>
    TechnicalIssue = 3,

    /// <summary>
    /// General Question.
    /// </summary>
    GeneralQuestion = 4,

    /// <summary>
    /// Billing/Subscription.
    /// </summary>
    Billing = 5,

    /// <summary>
    /// Privacy/Data request.
    /// </summary>
    PrivacyData = 6
}

/// <summary>
/// Ticket status.
/// </summary>
public enum TicketStatus
{
    /// <summary>
    /// Newly submitted.
    /// </summary>
    New = 1,

    /// <summary>
    /// Being reviewed by support.
    /// </summary>
    InReview = 2,

    /// <summary>
    /// Waiting for user response.
    /// </summary>
    WaitingForUser = 3,

    /// <summary>
    /// Issue resolved.
    /// </summary>
    Resolved = 4,

    /// <summary>
    /// Ticket closed.
    /// </summary>
    Closed = 5
}

/// <summary>
/// Ticket priority levels.
/// </summary>
public enum TicketPriority
{
    Low = 1,
    Normal = 2,
    High = 3,
    Urgent = 4
}
