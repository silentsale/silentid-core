using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Stores evidence from uploaded screenshots (marketplace profiles, ratings, reviews).
/// OCR extracts data, image forensics detects tampering.
/// </summary>
public class ScreenshotEvidence
{
    [Key]
    public Guid Id { get; set; }

    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    /// <summary>
    /// Azure Blob Storage URL for screenshot file.
    /// </summary>
    [Required]
    [MaxLength(1000)]
    public string FileUrl { get; set; } = string.Empty;

    /// <summary>
    /// Platform this screenshot is from.
    /// </summary>
    public Platform Platform { get; set; }

    /// <summary>
    /// OCR-extracted text from screenshot.
    /// </summary>
    public string? OCRText { get; set; }

    /// <summary>
    /// Integrity score (0-100) based on EXIF metadata, pixel analysis, edge detection.
    /// </summary>
    public int IntegrityScore { get; set; } = 100;

    /// <summary>
    /// Fraud flag if screenshot appears edited/fake.
    /// </summary>
    public bool FraudFlag { get; set; } = false;

    /// <summary>
    /// Evidence state (Valid, Suspicious, Rejected).
    /// </summary>
    public EvidenceState EvidenceState { get; set; } = EvidenceState.Valid;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
