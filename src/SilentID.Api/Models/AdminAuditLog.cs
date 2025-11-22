using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Audit log for all admin actions.
/// Append-only table for compliance and accountability.
/// </summary>
public class AdminAuditLog
{
    [Key]
    public Guid Id { get; set; }

    /// <summary>
    /// Admin user who performed the action (email or username).
    /// </summary>
    [Required]
    [MaxLength(255)]
    public string AdminUser { get; set; } = string.Empty;

    /// <summary>
    /// Action performed (FreezeAccount, VerifyReport, etc.).
    /// </summary>
    [Required]
    [MaxLength(255)]
    public string Action { get; set; } = string.Empty;

    /// <summary>
    /// Target user ID (if action was on a specific user).
    /// </summary>
    public Guid? TargetUserId { get; set; }

    /// <summary>
    /// Additional details as JSON (reason, duration, evidence, etc.).
    /// </summary>
    public string? Details { get; set; }

    /// <summary>
    /// IP address of admin.
    /// </summary>
    [MaxLength(50)]
    public string? IPAddress { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
