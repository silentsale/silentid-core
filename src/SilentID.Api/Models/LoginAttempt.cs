using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SilentID.Api.Models;

/// <summary>
/// Audit table for login attempts per Section 54.4
/// Used for anomaly detection and security monitoring
/// </summary>
public class LoginAttempt
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    public Guid UserId { get; set; }

    [Required]
    [StringLength(200)]
    public string DeviceId { get; set; } = string.Empty;

    /// <summary>
    /// Authentication method used: passkey, apple, google, email_otp
    /// </summary>
    [Required]
    [StringLength(50)]
    public string AuthMethod { get; set; } = string.Empty;

    /// <summary>
    /// Whether the attempt was successful
    /// </summary>
    public bool Success { get; set; }

    /// <summary>
    /// IP address of the attempt
    /// </summary>
    [StringLength(45)]
    public string? IpAddress { get; set; }

    /// <summary>
    /// User agent string
    /// </summary>
    [StringLength(500)]
    public string? UserAgent { get; set; }

    /// <summary>
    /// Country code from IP geolocation (if available)
    /// </summary>
    [StringLength(2)]
    public string? CountryCode { get; set; }

    /// <summary>
    /// City from IP geolocation (if available)
    /// </summary>
    [StringLength(100)]
    public string? City { get; set; }

    /// <summary>
    /// Failure reason if not successful
    /// </summary>
    [StringLength(500)]
    public string? FailureReason { get; set; }

    /// <summary>
    /// Risk score at time of attempt (0-100)
    /// </summary>
    public int? RiskScore { get; set; }

    /// <summary>
    /// Whether step-up auth was required
    /// </summary>
    public bool StepUpRequired { get; set; }

    /// <summary>
    /// Device trust level at time of attempt
    /// </summary>
    public DeviceTrustLevel DeviceTrustLevel { get; set; }

    /// <summary>
    /// When the attempt occurred
    /// </summary>
    public DateTime AttemptedAt { get; set; } = DateTime.UtcNow;

    // Navigation property
    [ForeignKey(nameof(UserId))]
    public User User { get; set; } = null!;
}
