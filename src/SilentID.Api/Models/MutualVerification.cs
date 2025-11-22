using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Mutual transaction verification between two SilentID users.
/// Both parties confirm the transaction details for high-trust evidence.
/// </summary>
public class MutualVerification
{
    [Key]
    public Guid Id { get; set; }

    /// <summary>
    /// User A who initiated the verification request.
    /// </summary>
    public Guid UserAId { get; set; }
    public User UserA { get; set; } = null!;

    /// <summary>
    /// User B who needs to confirm the verification.
    /// </summary>
    public Guid UserBId { get; set; }
    public User UserB { get; set; } = null!;

    /// <summary>
    /// Item/service description.
    /// </summary>
    [Required]
    [MaxLength(500)]
    public string Item { get; set; } = string.Empty;

    /// <summary>
    /// Transaction amount.
    /// </summary>
    public decimal Amount { get; set; }

    /// <summary>
    /// Currency code.
    /// </summary>
    [Required]
    [MaxLength(3)]
    public string Currency { get; set; } = "GBP";

    /// <summary>
    /// User A's role in transaction.
    /// </summary>
    public TransactionRole RoleA { get; set; }

    /// <summary>
    /// User B's role in transaction.
    /// </summary>
    public TransactionRole RoleB { get; set; }

    /// <summary>
    /// Transaction date.
    /// </summary>
    public DateTime Date { get; set; }

    /// <summary>
    /// Optional evidence ID (receipt, screenshot, etc.).
    /// </summary>
    public Guid? EvidenceId { get; set; }

    /// <summary>
    /// Mutual verification status.
    /// </summary>
    public MutualVerificationStatus Status { get; set; } = MutualVerificationStatus.Pending;

    /// <summary>
    /// Fraud flag if collusion/fake pattern detected.
    /// </summary>
    public bool FraudFlag { get; set; } = false;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}

public enum MutualVerificationStatus
{
    Pending,
    Confirmed,
    Rejected,
    Blocked
}
