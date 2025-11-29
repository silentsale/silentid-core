using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SilentID.Api.Models;

/// <summary>
/// WebAuthn/FIDO2 credential storage for admin users.
/// Separate from regular user passkeys for security isolation.
/// </summary>
public class AdminPasskeyCredential
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    public Guid AdminUserId { get; set; }

    /// <summary>
    /// Base64-encoded credential ID from the authenticator.
    /// </summary>
    [Required]
    [StringLength(1024)]
    public string CredentialId { get; set; } = string.Empty;

    /// <summary>
    /// Base64-encoded COSE public key.
    /// </summary>
    [Required]
    public string PublicKey { get; set; } = string.Empty;

    /// <summary>
    /// Signature counter for replay attack protection.
    /// </summary>
    public uint SignatureCounter { get; set; }

    /// <summary>
    /// Authenticator GUID (AAGUID) identifying the authenticator model.
    /// </summary>
    [StringLength(100)]
    public string? AaGuid { get; set; }

    /// <summary>
    /// User-friendly name for the device/authenticator.
    /// </summary>
    [StringLength(100)]
    public string DeviceName { get; set; } = "Admin Passkey";

    /// <summary>
    /// Attestation format used during registration.
    /// </summary>
    [StringLength(50)]
    public string? AttestationFormat { get; set; }

    /// <summary>
    /// Whether user verification was performed during registration.
    /// </summary>
    public bool UserVerified { get; set; }

    /// <summary>
    /// Credential type (should always be "public-key").
    /// </summary>
    [StringLength(50)]
    public string CredentialType { get; set; } = "public-key";

    /// <summary>
    /// Whether this credential is currently active.
    /// </summary>
    public bool IsActive { get; set; } = true;

    /// <summary>
    /// Last time this credential was used for authentication.
    /// </summary>
    public DateTime? LastUsedAt { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation property
    [ForeignKey(nameof(AdminUserId))]
    public AdminUser AdminUser { get; set; } = null!;
}
