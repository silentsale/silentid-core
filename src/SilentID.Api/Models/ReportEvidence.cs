using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Evidence files attached to safety reports (screenshots, receipts, chat logs, etc.).
/// </summary>
public class ReportEvidence
{
    [Key]
    public Guid Id { get; set; }

    public Guid ReportId { get; set; }
    public Report Report { get; set; } = null!;

    /// <summary>
    /// Azure Blob Storage URL for evidence file.
    /// </summary>
    [Required]
    [MaxLength(1000)]
    public string FileUrl { get; set; } = string.Empty;

    /// <summary>
    /// OCR-extracted text (if image).
    /// </summary>
    public string? OCRText { get; set; }

    /// <summary>
    /// File type/MIME type.
    /// </summary>
    [MaxLength(100)]
    public string? FileType { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
