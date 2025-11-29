using System.Text.RegularExpressions;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

/// <summary>
/// Mock OCR service for development and testing.
/// Returns simulated extraction results for profile screenshots.
///
/// In production, replace with AzureComputerVisionOcrService.
/// </summary>
public class MockOcrService : IOcrService
{
    private readonly ILogger<MockOcrService> _logger;
    private readonly Random _random = new();

    public MockOcrService(ILogger<MockOcrService> logger)
    {
        _logger = logger;
    }

    public Task<OcrResult> ExtractTextAsync(string imageUrl)
    {
        _logger.LogInformation("MockOCR: Extracting text from URL: {Url}", imageUrl);

        // Simulate OCR processing delay
        Thread.Sleep(500);

        return Task.FromResult(new OcrResult
        {
            Success = true,
            ExtractedText = GenerateMockProfileText(),
            Confidence = 0.95,
            Regions = new List<OcrTextRegion>
            {
                new() { Text = "4.9★", Confidence = 0.98, X = 100, Y = 50, Width = 50, Height = 20 },
                new() { Text = "327 reviews", Confidence = 0.96, X = 100, Y = 80, Width = 80, Height = 20 },
                new() { Text = "Member since Jan 2023", Confidence = 0.94, X = 100, Y = 110, Width = 150, Height = 20 },
            }
        });
    }

    public Task<OcrResult> ExtractTextAsync(Stream imageStream)
    {
        _logger.LogInformation("MockOCR: Extracting text from stream");

        // Simulate OCR processing delay
        Thread.Sleep(500);

        return Task.FromResult(new OcrResult
        {
            Success = true,
            ExtractedText = GenerateMockProfileText(),
            Confidence = 0.93
        });
    }

    public Task<ProfileOcrResult> ExtractProfileDataAsync(string imageUrl, string platformId)
    {
        _logger.LogInformation("MockOCR: Extracting profile data for {Platform} from {Url}", platformId, imageUrl);

        // Simulate OCR processing delay
        Thread.Sleep(800);

        // Generate realistic mock data based on platform
        var rating = Math.Round(4.0m + (decimal)_random.NextDouble(), 1);
        var reviewCount = _random.Next(50, 500);
        var joinYear = _random.Next(2019, 2024);
        var joinMonth = _random.Next(1, 13);

        return Task.FromResult(new ProfileOcrResult
        {
            Success = true,
            Rating = rating,
            ReviewCount = reviewCount,
            Username = $"user_{Guid.NewGuid().ToString()[..8]}",
            JoinDate = new DateTime(joinYear, joinMonth, 1),
            RatingConfidence = 0.95 + _random.NextDouble() * 0.05,
            ReviewCountConfidence = 0.92 + _random.NextDouble() * 0.08,
            UsernameConfidence = 0.88 + _random.NextDouble() * 0.12,
            JoinDateConfidence = 0.90 + _random.NextDouble() * 0.10,
            OverallConfidence = 0.92
        });
    }

    private string GenerateMockProfileText()
    {
        var rating = Math.Round(4.0 + _random.NextDouble(), 1);
        var reviews = _random.Next(50, 500);
        var year = _random.Next(2019, 2024);

        return $@"Profile
Rating: {rating}★
{reviews} reviews
Member since Jan {year}
Active seller
Response time: within 1 hour";
    }
}
