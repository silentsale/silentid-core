using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SilentID.Api.Models;

/// <summary>
/// Admin session model for tracking admin panel login sessions.
/// Separate from regular user sessions for security isolation.
/// </summary>
public class AdminSession
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    public Guid AdminUserId { get; set; }

    /// <summary>
    /// Hashed refresh token for session validation.
    /// </summary>
    [Required]
    [StringLength(500)]
    public string RefreshTokenHash { get; set; } = string.Empty;

    /// <summary>
    /// Session expiration time.
    /// Admin sessions have shorter duration than regular sessions for security.
    /// </summary>
    public DateTime ExpiresAt { get; set; }

    /// <summary>
    /// IP address from which the session was created.
    /// </summary>
    [StringLength(50)]
    public string? IPAddress { get; set; }

    /// <summary>
    /// User agent string for device identification.
    /// </summary>
    [StringLength(500)]
    public string? UserAgent { get; set; }

    /// <summary>
    /// Whether this session is still active.
    /// Can be invalidated without deletion for audit purposes.
    /// </summary>
    public bool IsActive { get; set; } = true;

    /// <summary>
    /// Authentication method used for this session.
    /// </summary>
    public AdminAuthMethod AuthMethod { get; set; }

    /// <summary>
    /// Timestamp of last activity in this session.
    /// Used for idle timeout detection.
    /// </summary>
    public DateTime LastActivityAt { get; set; } = DateTime.UtcNow;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation property
    [ForeignKey(nameof(AdminUserId))]
    public AdminUser AdminUser { get; set; } = null!;
}

/// <summary>
/// Authentication methods available for admin login.
/// </summary>
public enum AdminAuthMethod
{
    /// <summary>
    /// WebAuthn/FIDO2 passkey authentication.
    /// Preferred method for security.
    /// </summary>
    Passkey = 0,

    /// <summary>
    /// Email one-time password.
    /// Fallback method when passkey not available.
    /// </summary>
    EmailOtp = 1
}
