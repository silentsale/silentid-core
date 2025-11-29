using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Profile concerns submitted by users about other users' public profiles.
/// Uses neutral, non-accusatory language. Concerns are private and reviewed by admins only.
/// This is separate from the Report system - concerns are for general safety flags on public profiles.
/// </summary>
public class ProfileConcern
{
    [Key]
    public Guid Id { get; set; }

    /// <summary>
    /// User being reported/flagged.
    /// </summary>
    public Guid ReportedUserId { get; set; }
    public User ReportedUser { get; set; } = null!;

    /// <summary>
    /// User who submitted the concern (nullable for future anonymous reports).
    /// </summary>
    public Guid? ReporterUserId { get; set; }
    public User? Reporter { get; set; }

    /// <summary>
    /// Reason category for the concern.
    /// </summary>
    public ConcernReason Reason { get; set; }

    /// <summary>
    /// Optional additional notes from reporter (max 400 chars).
    /// </summary>
    [MaxLength(400)]
    public string? Notes { get; set; }

    /// <summary>
    /// IP address of the reporter for abuse prevention.
    /// </summary>
    [MaxLength(50)]
    public string? ReporterIpAddress { get; set; }

    /// <summary>
    /// Device fingerprint of the reporter.
    /// </summary>
    [MaxLength(500)]
    public string? ReporterDeviceInfo { get; set; }

    /// <summary>
    /// Current status of the concern review.
    /// </summary>
    public ConcernStatus Status { get; set; } = ConcernStatus.New;

    /// <summary>
    /// Internal admin notes (not visible to users).
    /// </summary>
    [MaxLength(2000)]
    public string? AdminNotes { get; set; }

    /// <summary>
    /// Admin who reviewed this concern.
    /// </summary>
    public Guid? ReviewedByAdminId { get; set; }

    /// <summary>
    /// When the concern was reviewed.
    /// </summary>
    public DateTime? ReviewedAt { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}

/// <summary>
/// Concern reason categories using neutral, safe language.
/// NEVER use words like: scam, scammer, fraud, fake.
/// </summary>
public enum ConcernReason
{
    /// <summary>
    /// "Profile might not belong to this person"
    /// </summary>
    ProfileOwnership = 1,

    /// <summary>
    /// "Suspicious or inconsistent information"
    /// </summary>
    InconsistentInformation = 2,

    /// <summary>
    /// "Something feels unsafe"
    /// </summary>
    UnsafeFeeling = 3,

    /// <summary>
    /// "Other safety concern"
    /// </summary>
    OtherSafetyConcern = 4
}

/// <summary>
/// Status of a profile concern review.
/// </summary>
public enum ConcernStatus
{
    /// <summary>
    /// Newly submitted, awaiting review.
    /// </summary>
    New = 1,

    /// <summary>
    /// Currently being reviewed by admin.
    /// </summary>
    UnderReview = 2,

    /// <summary>
    /// Review completed, action may have been taken.
    /// </summary>
    Reviewed = 3,

    /// <summary>
    /// Concern was dismissed (no issue found).
    /// </summary>
    Dismissed = 4
}
