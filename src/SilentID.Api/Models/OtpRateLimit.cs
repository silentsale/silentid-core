namespace SilentID.Api.Models;

/// <summary>
/// Persisted OTP rate limit tracking.
/// Replaces in-memory storage for production reliability.
/// </summary>
public class OtpRateLimit
{
    public Guid Id { get; set; }

    /// <summary>
    /// Email address (normalized to lowercase)
    /// </summary>
    public string Email { get; set; } = string.Empty;

    /// <summary>
    /// Number of OTP requests in the current window
    /// </summary>
    public int RequestCount { get; set; }

    /// <summary>
    /// When the rate limit window expires
    /// </summary>
    public DateTime WindowExpiresAt { get; set; }
}
