// ASP.NET Integration Example for SilentID Playwright Capture Service
// Add this to your SilentID.Core.Services namespace

using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace SilentID.Core.Services;

public class PlaywrightCaptureService
{
    private readonly HttpClient _httpClient;
    private readonly string _baseUrl;

    public PlaywrightCaptureService(HttpClient httpClient, string baseUrl = "http://localhost:3000")
    {
        _httpClient = httpClient;
        _baseUrl = baseUrl;
    }

    public async Task<CaptureResult> CaptureProfileAsync(CaptureRequest request)
    {
        var response = await _httpClient.PostAsJsonAsync($"{_baseUrl}/capture", request);
        response.EnsureSuccessStatusCode();

        var result = await response.Content.ReadFromJsonAsync<CaptureResult>();
        return result ?? throw new InvalidOperationException("Failed to deserialize capture result");
    }

    public async Task<bool> HealthCheckAsync()
    {
        try
        {
            var response = await _httpClient.GetAsync($"{_baseUrl}/health");
            return response.IsSuccessStatusCode;
        }
        catch
        {
            return false;
        }
    }

    public async Task<TokenVerificationResult> VerifyTokenInBioAsync(string profileUrl, string token)
    {
        var request = new CaptureRequest
        {
            Url = profileUrl,
            Mode = CaptureMode.TOKEN_IN_BIO,
            Token = token,
            MaxScreenshots = 1
        };

        var result = await CaptureProfileAsync(request);

        return new TokenVerificationResult
        {
            Success = result.Success,
            TokenFound = result.TokenVerification?.Found ?? false,
            TokenLocation = result.TokenVerification?.Location,
            Screenshots = result.Screenshots,
            Platform = result.Platform,
            CapturedAt = result.CapturedAt
        };
    }

    public async Task<ProfileExtractionResult> ExtractProfileAsync(string profileUrl)
    {
        var request = new CaptureRequest
        {
            Url = profileUrl,
            Mode = CaptureMode.PROFILE_EXTRACTION,
            MaxScreenshots = 3
        };

        var result = await CaptureProfileAsync(request);

        return new ProfileExtractionResult
        {
            Success = result.Success,
            Platform = result.Platform,
            ProfileData = result.ProfileData,
            Screenshots = result.Screenshots,
            CapturedAt = result.CapturedAt
        };
    }
}

// Request Models
public class CaptureRequest
{
    [JsonPropertyName("url")]
    public required string Url { get; set; }

    [JsonPropertyName("mode")]
    [JsonConverter(typeof(JsonStringEnumConverter))]
    public CaptureMode Mode { get; set; }

    [JsonPropertyName("token")]
    public string? Token { get; set; }

    [JsonPropertyName("maxScreenshots")]
    public int MaxScreenshots { get; set; } = 3;

    [JsonPropertyName("viewport")]
    public Viewport? Viewport { get; set; }
}

public class Viewport
{
    [JsonPropertyName("width")]
    public int Width { get; set; } = 1280;

    [JsonPropertyName("height")]
    public int Height { get; set; } = 800;
}

public enum CaptureMode
{
    PROFILE_EXTRACTION,
    TOKEN_IN_BIO
}

// Response Models
public class CaptureResult
{
    [JsonPropertyName("success")]
    public bool Success { get; set; }

    [JsonPropertyName("sessionId")]
    public string? SessionId { get; set; }

    [JsonPropertyName("platform")]
    public string? Platform { get; set; }

    [JsonPropertyName("mode")]
    public string? Mode { get; set; }

    [JsonPropertyName("screenshots")]
    public List<ScreenshotInfo>? Screenshots { get; set; }

    [JsonPropertyName("screenshotsDir")]
    public string? ScreenshotsDir { get; set; }

    [JsonPropertyName("tokenVerification")]
    public TokenVerificationInfo? TokenVerification { get; set; }

    [JsonPropertyName("profileData")]
    public ProfileData? ProfileData { get; set; }

    [JsonPropertyName("capturedAt")]
    public DateTime CapturedAt { get; set; }
}

public class ScreenshotInfo
{
    [JsonPropertyName("name")]
    public string? Name { get; set; }

    [JsonPropertyName("filename")]
    public string? Filename { get; set; }

    [JsonPropertyName("timestamp")]
    public DateTime Timestamp { get; set; }
}

public class TokenVerificationInfo
{
    [JsonPropertyName("token")]
    public string? Token { get; set; }

    [JsonPropertyName("found")]
    public bool Found { get; set; }

    [JsonPropertyName("location")]
    public string? Location { get; set; }
}

public class ProfileData
{
    [JsonPropertyName("pageTitle")]
    public string? PageTitle { get; set; }

    [JsonPropertyName("url")]
    public string? Url { get; set; }

    [JsonPropertyName("username")]
    public string? Username { get; set; }
}

// Result Models for convenience methods
public class TokenVerificationResult
{
    public bool Success { get; set; }
    public bool TokenFound { get; set; }
    public string? TokenLocation { get; set; }
    public List<ScreenshotInfo>? Screenshots { get; set; }
    public string? Platform { get; set; }
    public DateTime CapturedAt { get; set; }
}

public class ProfileExtractionResult
{
    public bool Success { get; set; }
    public string? Platform { get; set; }
    public ProfileData? ProfileData { get; set; }
    public List<ScreenshotInfo>? Screenshots { get; set; }
    public DateTime CapturedAt { get; set; }
}

// Dependency Injection Extension
public static class PlaywrightCaptureServiceExtensions
{
    public static IServiceCollection AddPlaywrightCaptureService(
        this IServiceCollection services,
        string baseUrl = "http://localhost:3000")
    {
        services.AddHttpClient<PlaywrightCaptureService>(client =>
        {
            client.BaseAddress = new Uri(baseUrl);
            client.Timeout = TimeSpan.FromSeconds(60);
        });

        return services;
    }
}

// Usage Example:
/*
// In Program.cs:
builder.Services.AddPlaywrightCaptureService("http://localhost:3000");

// In a Controller:
[ApiController]
[Route("api/[controller]")]
public class ProfileVerificationController : ControllerBase
{
    private readonly PlaywrightCaptureService _captureService;

    public ProfileVerificationController(PlaywrightCaptureService captureService)
    {
        _captureService = captureService;
    }

    [HttpPost("verify-token")]
    public async Task<IActionResult> VerifyToken([FromBody] VerifyTokenRequest request)
    {
        var result = await _captureService.VerifyTokenInBioAsync(request.ProfileUrl, request.Token);

        if (result.TokenFound)
        {
            // Token verified - update profile ownership in database
            return Ok(new { verified = true, platform = result.Platform });
        }

        return BadRequest(new { verified = false, message = "Token not found in profile bio" });
    }
}
*/
