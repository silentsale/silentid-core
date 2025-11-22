using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Safety reports filed by users against other users.
/// Requires review before affecting TrustScore.
/// </summary>
public class Report
{
    [Key]
    public Guid Id { get; set; }

    /// <summary>
    /// User who filed the report.
    /// </summary>
    public Guid ReporterId { get; set; }
    public User Reporter { get; set; } = null!;

    /// <summary>
    /// User being reported.
    /// </summary>
    public Guid ReportedUserId { get; set; }
    public User ReportedUser { get; set; } = null!;

    /// <summary>
    /// Report category.
    /// </summary>
    public ReportCategory Category { get; set; }

    /// <summary>
    /// Detailed description from reporter.
    /// </summary>
    [Required]
    [MaxLength(2000)]
    public string Description { get; set; } = string.Empty;

    /// <summary>
    /// Report status.
    /// </summary>
    public ReportStatus Status { get; set; } = ReportStatus.Pending;

    /// <summary>
    /// Evidence files attached to this report.
    /// </summary>
    public List<ReportEvidence> Evidence { get; set; } = new();

    /// <summary>
    /// Admin decision/notes.
    /// </summary>
    [MaxLength(2000)]
    public string? AdminNotes { get; set; }

    /// <summary>
    /// Admin who reviewed this report.
    /// </summary>
    [MaxLength(255)]
    public string? ReviewedBy { get; set; }

    /// <summary>
    /// When admin reviewed the report.
    /// </summary>
    public DateTime? ReviewedAt { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}

public enum ReportCategory
{
    ItemNotReceived,
    AggressiveBehaviour,
    FraudConcern,
    PaymentIssue,
    MisrepresentedItem,
    FakeProfile,
    Harassment,
    Other
}

public enum ReportStatus
{
    Pending,
    UnderReview,
    Verified,
    Dismissed
}
