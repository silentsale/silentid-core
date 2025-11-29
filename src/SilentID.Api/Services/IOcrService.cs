using SilentID.Api.Models;

namespace SilentID.Api.Services;

/// <summary>
/// Interface for OCR (Optical Character Recognition) service.
/// Used for extracting profile data from screenshots (Section 49.6).
///
/// Implementations:
/// - AzureComputerVisionOcrService (production)
/// - MockOcrService (development/testing)
/// </summary>
public interface IOcrService
{
    /// <summary>
    /// Extract text from an image URL.
    /// </summary>
    Task<OcrResult> ExtractTextAsync(string imageUrl);

    /// <summary>
    /// Extract text from an image stream.
    /// </summary>
    Task<OcrResult> ExtractTextAsync(Stream imageStream);

    /// <summary>
    /// Extract structured profile data from an image.
    /// </summary>
    /// <param name="imageUrl">URL of the image to extract data from</param>
    /// <param name="platformId">Platform identifier string (e.g., "vinted-uk", "ebay-us")</param>
    Task<ProfileOcrResult> ExtractProfileDataAsync(string imageUrl, string platformId);
}

/// <summary>
/// Result from OCR text extraction.
/// </summary>
public class OcrResult
{
    public bool Success { get; set; }
    public string? ErrorMessage { get; set; }
    public string ExtractedText { get; set; } = string.Empty;
    public double Confidence { get; set; }
    public List<OcrTextRegion> Regions { get; set; } = new();
}

/// <summary>
/// A region of text detected in the image.
/// </summary>
public class OcrTextRegion
{
    public string Text { get; set; } = string.Empty;
    public double Confidence { get; set; }
    public int X { get; set; }
    public int Y { get; set; }
    public int Width { get; set; }
    public int Height { get; set; }
}

/// <summary>
/// Structured profile data extracted via OCR.
/// </summary>
public class ProfileOcrResult
{
    public bool Success { get; set; }
    public string? ErrorMessage { get; set; }

    // Extracted profile fields
    public decimal? Rating { get; set; }
    public int? ReviewCount { get; set; }
    public string? Username { get; set; }
    public DateTime? JoinDate { get; set; }

    // Confidence scores for each field
    public double RatingConfidence { get; set; }
    public double ReviewCountConfidence { get; set; }
    public double UsernameConfidence { get; set; }
    public double JoinDateConfidence { get; set; }

    // Overall confidence (average of successful extractions)
    public double OverallConfidence { get; set; }
}
