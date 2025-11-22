using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Tracks Stripe Identity verification status for a user.
/// SilentID NEVER stores raw ID documents - Stripe handles all sensitive data.
/// We only store verification results and reference IDs.
/// </summary>
public class IdentityVerification
{
    [Key]
    public Guid Id { get; set; }

    /// <summary>
    /// Foreign key to Users table.
    /// </summary>
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    /// <summary>
    /// Stripe Identity verification session ID (for reference only).
    /// Used to query Stripe for verification status.
    /// </summary>
    [Required]
    [MaxLength(255)]
    public string StripeVerificationId { get; set; } = string.Empty;

    /// <summary>
    /// Current verification status.
    /// </summary>
    public VerificationStatus Status { get; set; } = VerificationStatus.Pending;

    /// <summary>
    /// Verification level completed.
    /// </summary>
    public VerificationLevel Level { get; set; } = VerificationLevel.Basic;

    /// <summary>
    /// Timestamp when verification was successfully completed (nullable if pending/failed).
    /// </summary>
    public DateTime? VerifiedAt { get; set; }

    /// <summary>
    /// When this verification record was created.
    /// </summary>
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    /// <summary>
    /// Last updated timestamp.
    /// </summary>
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}

/// <summary>
/// Verification status enum.
/// </summary>
public enum VerificationStatus
{
    Pending,        // Verification initiated but not completed
    Verified,       // Successfully verified
    Failed,         // Verification failed (document rejected, etc.)
    NeedsRetry      // User needs to retry verification
}

/// <summary>
/// Verification level enum.
/// </summary>
public enum VerificationLevel
{
    Basic,          // Standard ID verification
    Enhanced        // Enhanced verification (required for high-risk users or after reports)
}
