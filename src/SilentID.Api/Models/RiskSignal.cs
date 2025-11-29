using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Risk signals detected by anti-fraud engine.
/// Each signal contributes to user's RiskScore (0-100).
/// </summary>
public class RiskSignal
{
    [Key]
    public Guid Id { get; set; }

    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    /// <summary>
    /// Type of risk detected.
    /// </summary>
    public RiskType Type { get; set; }

    /// <summary>
    /// Severity level (1-10).
    /// </summary>
    public int Severity { get; set; } = 5;

    /// <summary>
    /// Human-readable message explaining the risk.
    /// </summary>
    [Required]
    [MaxLength(1000)]
    public string Message { get; set; } = string.Empty;

    /// <summary>
    /// Additional metadata as JSON (IPs, device IDs, pattern details, etc.).
    /// </summary>
    public string? Metadata { get; set; }

    /// <summary>
    /// Whether this signal has been resolved/dismissed.
    /// </summary>
    public bool IsResolved { get; set; } = false;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}

public enum RiskType
{
    FakeReceipt,
    FakeScreenshot,
    Collusion,
    DeviceMismatch,
    IPRisk,
    Reported,
    DuplicateAccount,
    ProfileMismatch,
    SuspiciousLogin,
    RapidAccountCreation,
    AbnormalActivity,
    /// <summary>
    /// Soft signal from multiple profile concerns.
    /// Very low weight, internal only, does not directly affect TrustScore.
    /// </summary>
    ProfileConcernFlag
}
