namespace SilentID.Api.Models;

/// <summary>
/// Persisted OTP code for email authentication.
/// Replaces in-memory storage for production reliability.
/// </summary>
public class OtpCode
{
    public Guid Id { get; set; }

    /// <summary>
    /// Email address (normalized to lowercase)
    /// </summary>
    public string Email { get; set; } = string.Empty;

    /// <summary>
    /// The hashed OTP code (SHA256 hash, not plaintext)
    /// </summary>
    public string OtpHash { get; set; } = string.Empty;

    /// <summary>
    /// When this OTP was created
    /// </summary>
    public DateTime CreatedAt { get; set; }

    /// <summary>
    /// When this OTP expires
    /// </summary>
    public DateTime ExpiresAt { get; set; }

    /// <summary>
    /// Number of validation attempts made
    /// </summary>
    public int Attempts { get; set; }

    /// <summary>
    /// Whether this OTP has been consumed (used successfully)
    /// </summary>
    public bool IsConsumed { get; set; }
}
