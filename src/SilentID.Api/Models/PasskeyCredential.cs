using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SilentID.Api.Models;

/// <summary>
/// Stores WebAuthn/FIDO2 passkey credentials for passwordless authentication.
/// Each user can have multiple passkeys registered (e.g., different devices).
/// </summary>
public class PasskeyCredential
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    public Guid UserId { get; set; }

    /// <summary>
    /// The credential ID returned by the authenticator (Base64 encoded).
    /// This is used to identify the credential during authentication.
    /// </summary>
    [Required]
    [StringLength(1024)]
    public string CredentialId { get; set; } = string.Empty;

    /// <summary>
    /// The public key in COSE format (Base64 encoded).
    /// Used to verify signatures during authentication.
    /// </summary>
    [Required]
    public string PublicKey { get; set; } = string.Empty;

    /// <summary>
    /// The signature counter from the authenticator.
    /// Increments with each authentication to detect cloned credentials.
    /// </summary>
    public uint SignatureCounter { get; set; }

    /// <summary>
    /// The AAGUID of the authenticator (if available).
    /// Identifies the type/model of authenticator.
    /// </summary>
    [StringLength(36)]
    public string? AaGuid { get; set; }

    /// <summary>
    /// User-friendly name for this passkey (e.g., "iPhone Face ID", "Windows Hello").
    /// </summary>
    [StringLength(100)]
    public string? DeviceName { get; set; }

    /// <summary>
    /// The credential type (typically "public-key").
    /// </summary>
    [StringLength(50)]
    public string CredentialType { get; set; } = "public-key";

    /// <summary>
    /// The attestation format used during registration.
    /// </summary>
    [StringLength(50)]
    public string? AttestationFormat { get; set; }

    /// <summary>
    /// Whether this credential supports user verification (biometric/PIN).
    /// </summary>
    public bool UserVerified { get; set; }

    /// <summary>
    /// Whether this credential is currently active and can be used for authentication.
    /// </summary>
    public bool IsActive { get; set; } = true;

    /// <summary>
    /// The last time this passkey was used for authentication.
    /// </summary>
    public DateTime? LastUsedAt { get; set; }

    /// <summary>
    /// When this passkey was registered.
    /// </summary>
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation property
    [ForeignKey(nameof(UserId))]
    public User User { get; set; } = null!;
}
