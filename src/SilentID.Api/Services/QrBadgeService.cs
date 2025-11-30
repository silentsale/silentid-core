using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;
using QRCoder;

namespace SilentID.Api.Services;

/// <summary>
/// QR Code Badge Generation Service per Section 51.4
/// Generates QR-enabled verified badges for Trust Passports
/// </summary>
public interface IQrBadgeService
{
    /// <summary>
    /// Generate a QR code image for a user's Trust Passport
    /// </summary>
    Task<QrBadgeResult> GenerateQrCodeAsync(Guid userId);

    /// <summary>
    /// Generate a full badge image with QR code and trust info
    /// </summary>
    Task<QrBadgeResult> GenerateBadgeImageAsync(Guid userId, BadgeStyle style = BadgeStyle.Standard);

    /// <summary>
    /// Get the public Trust Passport URL for a user
    /// </summary>
    Task<string?> GetPassportUrlAsync(Guid userId);
}

public enum BadgeStyle
{
    Standard,       // Default purple badge
    Minimal,        // Just QR code
    Dark,           // Dark theme badge
    Light           // Light theme badge
}

public class QrBadgeResult
{
    public bool Success { get; set; }
    public string? ErrorMessage { get; set; }
    public byte[]? ImageData { get; set; }
    public string? ContentType { get; set; }
    public string? PassportUrl { get; set; }
    public int? TrustScore { get; set; }
    public string? TrustLabel { get; set; }
}

public class QrBadgeService : IQrBadgeService
{
    private readonly SilentIdDbContext _db;
    private readonly ITrustScoreService _trustScoreService;
    private readonly IConfiguration _configuration;
    private readonly ILogger<QrBadgeService> _logger;

    private const string DefaultBaseUrl = "https://silentid.co.uk";

    public QrBadgeService(
        SilentIdDbContext db,
        ITrustScoreService trustScoreService,
        IConfiguration configuration,
        ILogger<QrBadgeService> logger)
    {
        _db = db;
        _trustScoreService = trustScoreService;
        _configuration = configuration;
        _logger = logger;
    }

    public async Task<QrBadgeResult> GenerateQrCodeAsync(Guid userId)
    {
        var passportUrl = await GetPassportUrlAsync(userId);
        if (passportUrl == null)
        {
            return new QrBadgeResult
            {
                Success = false,
                ErrorMessage = "User not found or passport not available"
            };
        }

        try
        {
            using var qrGenerator = new QRCodeGenerator();
            var qrCodeData = qrGenerator.CreateQrCode(passportUrl, QRCodeGenerator.ECCLevel.M);
            using var qrCode = new PngByteQRCode(qrCodeData);
            var qrCodeImage = qrCode.GetGraphic(20); // 20 pixels per module

            _logger.LogInformation("QR code generated for user {UserId}", userId);

            return new QrBadgeResult
            {
                Success = true,
                ImageData = qrCodeImage,
                ContentType = "image/png",
                PassportUrl = passportUrl
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to generate QR code for user {UserId}", userId);
            return new QrBadgeResult
            {
                Success = false,
                ErrorMessage = "Failed to generate QR code"
            };
        }
    }

    public async Task<QrBadgeResult> GenerateBadgeImageAsync(Guid userId, BadgeStyle style = BadgeStyle.Standard)
    {
        var user = await _db.Users.FindAsync(userId);
        if (user == null)
        {
            return new QrBadgeResult
            {
                Success = false,
                ErrorMessage = "User not found"
            };
        }

        var passportUrl = await GetPassportUrlAsync(userId);
        if (passportUrl == null)
        {
            return new QrBadgeResult
            {
                Success = false,
                ErrorMessage = "Passport not available"
            };
        }

        // Get current trust score
        var trustScore = await _trustScoreService.GetCurrentTrustScoreAsync(userId);
        var trustLabel = GetTrustLabel(trustScore.Score);

        try
        {
            // Generate QR code
            using var qrGenerator = new QRCodeGenerator();
            var qrCodeData = qrGenerator.CreateQrCode(passportUrl, QRCodeGenerator.ECCLevel.M);
            using var qrCode = new PngByteQRCode(qrCodeData);
            var qrCodeBytes = qrCode.GetGraphic(10);

            // For a full badge with text and styling, we'd need System.Drawing or SkiaSharp
            // For MVP, return the QR code with metadata
            // Full badge rendering would require additional image processing

            _logger.LogInformation(
                "Badge generated for user {UserId}: Score={Score}, Label={Label}",
                userId, trustScore.Score, trustLabel);

            return new QrBadgeResult
            {
                Success = true,
                ImageData = qrCodeBytes,
                ContentType = "image/png",
                PassportUrl = passportUrl,
                TrustScore = trustScore.Score,
                TrustLabel = trustLabel
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to generate badge for user {UserId}", userId);
            return new QrBadgeResult
            {
                Success = false,
                ErrorMessage = "Failed to generate badge"
            };
        }
    }

    public async Task<string?> GetPassportUrlAsync(Guid userId)
    {
        var user = await _db.Users.FindAsync(userId);
        if (user == null) return null;

        var baseUrl = _configuration["App:BaseUrl"] ?? DefaultBaseUrl;

        // Use username for cleaner URLs if available, otherwise use ID
        var identifier = !string.IsNullOrEmpty(user.Username)
            ? user.Username.ToLowerInvariant()
            : userId.ToString();

        return $"{baseUrl}/p/{identifier}";
    }

    private string GetTrustLabel(int score)
    {
        return score switch
        {
            >= 850 => "Exceptional Trust",
            >= 700 => "Very High Trust",
            >= 550 => "High Trust",
            >= 400 => "Moderate Trust",
            >= 250 => "Low Trust",
            _ => "Building Trust"
        };
    }
}
