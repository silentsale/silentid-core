using FluentAssertions;
using Microsoft.Extensions.DependencyInjection;
using SilentID.Api.Data;
using SilentID.Api.Services;
using SilentID.Api.Tests.Helpers;
using System.Net;
using System.Net.Http.Json;
using System.Text.Json;
using Xunit;

namespace SilentID.Api.Tests.Integration.Controllers;

public class AuthControllerTests : IClassFixture<TestWebApplicationFactory>
{
    private readonly HttpClient _client;
    private readonly TestWebApplicationFactory _factory;

    public AuthControllerTests(TestWebApplicationFactory factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task RequestOtp_ValidEmail_ShouldReturn200()
    {
        // Arrange
        var request = new { Email = "test@example.com" };

        // Act
        var response = await _client.PostAsJsonAsync("/v1/auth/request-otp", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var content = await response.Content.ReadAsStringAsync();
        content.Should().Contain("Verification code sent");
        content.Should().Contain("test@example.com");
    }

    [Fact]
    public async Task RequestOtp_InvalidEmail_ShouldReturn400()
    {
        // Arrange
        var request = new { Email = "not-an-email" };

        // Act
        var response = await _client.PostAsJsonAsync("/v1/auth/request-otp", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    [Fact]
    public async Task RequestOtp_RateLimitExceeded_ShouldReturn429()
    {
        // Arrange
        var email = "ratelimit@example.com";
        var request = new { Email = email };

        // Act - Request 4 OTPs (limit is 3)
        await _client.PostAsJsonAsync("/v1/auth/request-otp", request);
        await _client.PostAsJsonAsync("/v1/auth/request-otp", request);
        await _client.PostAsJsonAsync("/v1/auth/request-otp", request);
        var response = await _client.PostAsJsonAsync("/v1/auth/request-otp", request);

        // Assert
        response.StatusCode.Should().Be((HttpStatusCode)429);

        var content = await response.Content.ReadAsStringAsync();
        content.Should().Contain("rate_limit_exceeded");
    }

    [Fact]
    public async Task VerifyOtp_CorrectCode_ShouldReturnTokens()
    {
        // Arrange
        var email = TestDataBuilder.GenerateEmail();

        // Get OTP from mock email service
        using var scope = _factory.Services.CreateScope();
        var emailService = scope.ServiceProvider.GetRequiredService<IEmailService>() as MockEmailService;
        emailService!.ClearSentEmails();

        // Request OTP
        await _client.PostAsJsonAsync("/v1/auth/request-otp", new { Email = email });

        // Get the OTP that was "sent"
        var sentEmail = emailService.SentEmails.FirstOrDefault(e => e.To == email);
        sentEmail.Should().NotBeNull();
        var otp = sentEmail!.Content;

        var verifyRequest = new
        {
            Email = email,
            Otp = otp,
            DeviceId = Guid.NewGuid().ToString()
        };

        // Act
        var response = await _client.PostAsJsonAsync("/v1/auth/verify-otp", verifyRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var content = await response.Content.ReadAsStringAsync();
        var jsonDoc = JsonDocument.Parse(content);

        jsonDoc.RootElement.TryGetProperty("accessToken", out var accessToken).Should().BeTrue();
        jsonDoc.RootElement.TryGetProperty("refreshToken", out var refreshToken).Should().BeTrue();
        jsonDoc.RootElement.TryGetProperty("user", out var user).Should().BeTrue();

        accessToken.GetString().Should().NotBeNullOrEmpty();
        refreshToken.GetString().Should().NotBeNullOrEmpty();
    }

    [Fact]
    public async Task VerifyOtp_WrongCode_ShouldReturn401()
    {
        // Arrange
        var email = TestDataBuilder.GenerateEmail();

        // Request OTP (but we'll use wrong code)
        await _client.PostAsJsonAsync("/v1/auth/request-otp", new { Email = email });

        var verifyRequest = new
        {
            Email = email,
            Otp = "000000" // Wrong OTP
        };

        // Act
        var response = await _client.PostAsJsonAsync("/v1/auth/verify-otp", verifyRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);

        var content = await response.Content.ReadAsStringAsync();
        content.Should().Contain("invalid_otp");
    }

    [Fact]
    public async Task VerifyOtp_ExpiredCode_ShouldReturn401()
    {
        // Arrange
        var email = TestDataBuilder.GenerateEmail();
        var verifyRequest = new
        {
            Email = email,
            Otp = "123456" // Non-existent OTP (expired/never sent)
        };

        // Act
        var response = await _client.PostAsJsonAsync("/v1/auth/verify-otp", verifyRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    [Fact]
    public async Task VerifyOtp_NewUser_ShouldCreateAccount()
    {
        // Arrange
        var email = TestDataBuilder.GenerateEmail();

        using var scope = _factory.Services.CreateScope();
        var emailService = scope.ServiceProvider.GetRequiredService<IEmailService>() as MockEmailService;
        emailService!.ClearSentEmails();

        // Request OTP
        await _client.PostAsJsonAsync("/v1/auth/request-otp", new { Email = email });

        var otp = emailService.SentEmails.First(e => e.To == email).Content;

        var verifyRequest = new
        {
            Email = email,
            Otp = otp
        };

        // Act
        var response = await _client.PostAsJsonAsync("/v1/auth/verify-otp", verifyRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var content = await response.Content.ReadAsStringAsync();
        var jsonDoc = JsonDocument.Parse(content);

        jsonDoc.RootElement.GetProperty("user").GetProperty("isNewUser").GetBoolean().Should().BeTrue();

        // Verify user was created in database
        using var dbScope = _factory.Services.CreateScope();
        var db = dbScope.ServiceProvider.GetRequiredService<SilentIdDbContext>();
        var user = db.Users.FirstOrDefault(u => u.Email == email);
        user.Should().NotBeNull();
        user!.IsEmailVerified.Should().BeTrue();
    }

    [Fact]
    public async Task RefreshToken_ValidToken_ShouldReturnNewTokens()
    {
        // Arrange - First login to get tokens
        var email = TestDataBuilder.GenerateEmail();

        using var scope = _factory.Services.CreateScope();
        var emailService = scope.ServiceProvider.GetRequiredService<IEmailService>() as MockEmailService;
        emailService!.ClearSentEmails();

        await _client.PostAsJsonAsync("/v1/auth/request-otp", new { Email = email });
        var otp = emailService.SentEmails.First(e => e.To == email).Content;

        var verifyResponse = await _client.PostAsJsonAsync("/v1/auth/verify-otp", new
        {
            Email = email,
            Otp = otp
        });

        var verifyContent = await verifyResponse.Content.ReadAsStringAsync();
        var verifyJson = JsonDocument.Parse(verifyContent);
        var refreshToken = verifyJson.RootElement.GetProperty("refreshToken").GetString();

        // Act - Refresh token
        var refreshRequest = new { RefreshToken = refreshToken };
        var response = await _client.PostAsJsonAsync("/v1/auth/refresh", refreshRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var content = await response.Content.ReadAsStringAsync();
        var jsonDoc = JsonDocument.Parse(content);

        jsonDoc.RootElement.TryGetProperty("accessToken", out var newAccessToken).Should().BeTrue();
        jsonDoc.RootElement.TryGetProperty("refreshToken", out var newRefreshToken).Should().BeTrue();

        newAccessToken.GetString().Should().NotBeNullOrEmpty();
        newRefreshToken.GetString().Should().NotBeNullOrEmpty();
        newRefreshToken.GetString().Should().NotBe(refreshToken); // Should be rotated
    }

    [Fact]
    public async Task RefreshToken_InvalidToken_ShouldReturn401()
    {
        // Arrange
        var refreshRequest = new { RefreshToken = "invalid-token-12345" };

        // Act
        var response = await _client.PostAsJsonAsync("/v1/auth/refresh", refreshRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    [Fact]
    public async Task Logout_ValidToken_ShouldInvalidateSession()
    {
        // Arrange - First login
        var email = TestDataBuilder.GenerateEmail();

        using var scope = _factory.Services.CreateScope();
        var emailService = scope.ServiceProvider.GetRequiredService<IEmailService>() as MockEmailService;
        emailService!.ClearSentEmails();

        await _client.PostAsJsonAsync("/v1/auth/request-otp", new { Email = email });
        var otp = emailService.SentEmails.First(e => e.To == email).Content;

        var verifyResponse = await _client.PostAsJsonAsync("/v1/auth/verify-otp", new
        {
            Email = email,
            Otp = otp
        });

        var verifyContent = await verifyResponse.Content.ReadAsStringAsync();
        var verifyJson = JsonDocument.Parse(verifyContent);
        var accessToken = verifyJson.RootElement.GetProperty("accessToken").GetString();
        var refreshToken = verifyJson.RootElement.GetProperty("refreshToken").GetString();

        // Add Bearer token to client
        _client.DefaultRequestHeaders.Authorization =
            new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", accessToken);

        // Act - Logout
        var logoutRequest = new { RefreshToken = refreshToken };
        var response = await _client.PostAsJsonAsync("/v1/auth/logout", logoutRequest);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        // Try to use refresh token again (should fail)
        var retryRefresh = await _client.PostAsJsonAsync("/v1/auth/refresh", new { RefreshToken = refreshToken });
        retryRefresh.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    [Fact]
    public async Task VerifyOtp_DuplicateEmail_ShouldPreventAccountCreation()
    {
        // Arrange
        var email = TestDataBuilder.GenerateEmail();

        using var scope = _factory.Services.CreateScope();
        var emailService = scope.ServiceProvider.GetRequiredService<IEmailService>() as MockEmailService;
        var db = scope.ServiceProvider.GetRequiredService<SilentIdDbContext>();

        // Create existing user
        var existingUser = TestDataBuilder.CreateUser(email: email);
        db.Users.Add(existingUser);
        await db.SaveChangesAsync();

        emailService!.ClearSentEmails();

        // Request OTP
        await _client.PostAsJsonAsync("/v1/auth/request-otp", new { Email = email });
        var otp = emailService.SentEmails.FirstOrDefault(e => e.To == email)?.Content;

        // Act - Try to create account with same email
        var verifyRequest = new
        {
            Email = email,
            Otp = otp ?? "123456"
        };

        var response = await _client.PostAsJsonAsync("/v1/auth/verify-otp", verifyRequest);

        // Assert - Should allow login for existing user
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var content = await response.Content.ReadAsStringAsync();
        var jsonDoc = JsonDocument.Parse(content);
        jsonDoc.RootElement.GetProperty("user").GetProperty("isNewUser").GetBoolean().Should().BeFalse();
    }
}
