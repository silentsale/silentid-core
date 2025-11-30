using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SilentID.Api.Models;

/// <summary>
/// Device trust levels per Section 54.3
/// </summary>
public enum DeviceTrustLevel
{
    Trusted,     // Known device, consistent behavior, no risk signals
    Known,       // Previously seen, some history
    New,         // First time device
    Suspicious,  // Anomalies detected (geo, velocity, fingerprint mismatch)
    Blocked      // Explicitly blocked by user or system
}

public class AuthDevice
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    public Guid UserId { get; set; }

    [Required]
    [StringLength(200)]
    public string DeviceId { get; set; } = string.Empty;

    [StringLength(100)]
    public string? DeviceModel { get; set; }

    [StringLength(50)]
    public string? OS { get; set; }

    [StringLength(100)]
    public string? OSVersion { get; set; }

    [StringLength(50)]
    public string? Browser { get; set; }

    [StringLength(50)]
    public string? AppVersion { get; set; }

    [StringLength(20)]
    public string? ScreenResolution { get; set; }

    [StringLength(50)]
    public string? Timezone { get; set; }

    [StringLength(10)]
    public string? Language { get; set; }

    public DateTime LastUsedAt { get; set; } = DateTime.UtcNow;

    [Obsolete("Use TrustLevel instead")]
    public bool IsTrusted { get; set; } = false;

    /// <summary>
    /// Device trust level (Section 54.3)
    /// </summary>
    public DeviceTrustLevel TrustLevel { get; set; } = DeviceTrustLevel.New;

    /// <summary>
    /// Number of successful logins from this device
    /// </summary>
    public int LoginCount { get; set; } = 0;

    /// <summary>
    /// Last known IP address
    /// </summary>
    [StringLength(45)]
    public string? LastIP { get; set; }

    /// <summary>
    /// History of IP addresses (JSONB)
    /// </summary>
    [Column(TypeName = "jsonb")]
    public string? IpAddressHistory { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation property
    [ForeignKey(nameof(UserId))]
    public User User { get; set; } = null!;
}
