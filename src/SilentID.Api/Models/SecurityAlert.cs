using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Security alerts for users (Section 15 - Security Center).
/// Alerts for breaches, suspicious logins, device issues, risk signals, etc.
/// </summary>
public class SecurityAlert
{
    [Key]
    public Guid Id { get; set; }

    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    /// <summary>
    /// Alert type.
    /// </summary>
    public SecurityAlertType Type { get; set; }

    /// <summary>
    /// Alert title.
    /// </summary>
    [Required]
    [MaxLength(200)]
    public string Title { get; set; } = string.Empty;

    /// <summary>
    /// Alert message/description.
    /// </summary>
    [Required]
    [MaxLength(2000)]
    public string Message { get; set; } = string.Empty;

    /// <summary>
    /// Severity (1-10).
    /// </summary>
    public int Severity { get; set; } = 5;

    /// <summary>
    /// Whether user has read this alert.
    /// </summary>
    public bool IsRead { get; set; } = false;

    /// <summary>
    /// Additional metadata as JSON.
    /// </summary>
    public string? Metadata { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}

public enum SecurityAlertType
{
    Breach,
    SuspiciousLogin,
    DeviceIssue,
    RiskSignal,
    IdentityExpiring,
    NewDevice,
    EvidenceIssue
}
