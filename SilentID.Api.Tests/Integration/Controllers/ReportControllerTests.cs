using FluentAssertions;
using Microsoft.Extensions.DependencyInjection;
using SilentID.Api.Data;
using SilentID.Api.Models;
using SilentID.Api.Services;
using SilentID.Api.Tests.Helpers;
using System.Net;
using System.Net.Http.Json;
using Xunit;

namespace SilentID.Api.Tests.Integration.Controllers;

public class ReportControllerTests : IClassFixture<TestWebApplicationFactory>
{
    private readonly HttpClient _client;
    private readonly TestWebApplicationFactory _factory;

    public ReportControllerTests(TestWebApplicationFactory factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
    }

    private async Task<(HttpClient client, User user)> CreateAuthenticatedClientAsync(string email = "", bool verified = false)
    {
        email = string.IsNullOrEmpty(email) ? TestDataBuilder.GenerateEmail() : email;

        using var scope = _factory.Services.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<SilentIdDbContext>();
        var emailService = scope.ServiceProvider.GetRequiredService<IEmailService>() as MockEmailService;
        emailService!.ClearSentEmails();

        // Request OTP
        await _client.PostAsJsonAsync("/v1/auth/request-otp", new { Email = email });

        // Get OTP
        var sentEmail = emailService.SentEmails.FirstOrDefault(e => e.To == email);
        var otp = sentEmail!.Content;

        // Verify OTP
        var verifyResponse = await _client.PostAsJsonAsync("/v1/auth/verify-otp", new
        {
            Email = email,
            Otp = otp,
            DeviceId = Guid.NewGuid().ToString()
        });

        var tokens = await verifyResponse.Content.ReadFromJsonAsync<TokenResponse>();

        // Get user and verify if needed
        var user = await dbContext.Users.FindAsync(tokens!.UserId);
        if (verified)
        {
            var identityVerification = new IdentityVerification
            {
                Id = Guid.NewGuid(),
                UserId = user!.Id,
                Status = VerificationStatus.Verified,
                Level = VerificationLevel.Basic,
                StripeVerificationId = $"stripe_{Guid.NewGuid()}",
                VerifiedAt = DateTime.UtcNow,
                CreatedAt = DateTime.UtcNow
            };
            dbContext.IdentityVerifications.Add(identityVerification);
            await dbContext.SaveChangesAsync();
        }

        // Create authenticated client
        var authClient = _factory.CreateClient();
        authClient.DefaultRequestHeaders.Authorization =
            new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", tokens.AccessToken);

        return (authClient, user!);
    }

    [Fact]
    public async Task CreateReport_ValidRequest_ReturnsCreated()
    {
        // Arrange
        var (reporterClient, _) = await CreateAuthenticatedClientAsync(verified: true);
        var (_, reportedUser) = await CreateAuthenticatedClientAsync();

        var request = new
        {
            ReportedUserIdentifier = reportedUser.Email,
            Category = "ItemNotReceived",
            Description = "I paid for the item but never received it. Seller stopped responding to messages."
        };

        // Act
        var response = await reporterClient.PostAsJsonAsync("/v1/reports", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Created);

        var result = await response.Content.ReadFromJsonAsync<Dictionary<string, object>>();
        result.Should().ContainKey("id");
        result.Should().ContainKey("status");
    }

    [Fact]
    public async Task CreateReport_NotVerified_Returns400()
    {
        // Arrange
        var (reporterClient, _) = await CreateAuthenticatedClientAsync(verified: false);
        var (_, reportedUser) = await CreateAuthenticatedClientAsync();

        var request = new
        {
            ReportedUserIdentifier = reportedUser.Email,
            Category = "AggressiveBehaviour",
            Description = "Test report"
        };

        // Act
        var response = await reporterClient.PostAsJsonAsync("/v1/reports", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        var content = await response.Content.ReadAsStringAsync();
        content.Should().Contain("identity verification");
    }

    [Fact]
    public async Task CreateReport_ReportingYourself_Returns400()
    {
        // Arrange
        var (client, user) = await CreateAuthenticatedClientAsync(verified: true);

        var request = new
        {
            ReportedUserIdentifier = user.Email,
            Category = "FraudConcern",
            Description = "Test self-report"
        };

        // Act
        var response = await client.PostAsJsonAsync("/v1/reports", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        var content = await response.Content.ReadAsStringAsync();
        content.Should().Contain("cannot report yourself");
    }

    [Fact]
    public async Task CreateReport_NonExistentUser_Returns404()
    {
        // Arrange
        var (client, _) = await CreateAuthenticatedClientAsync(verified: true);

        var request = new
        {
            ReportedUserIdentifier = "nonexistent@example.com",
            Category = "FraudConcern",
            Description = "Test report"
        };

        // Act
        var response = await client.PostAsJsonAsync("/v1/reports", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
    }

    [Fact]
    public async Task CreateReport_MissingRequiredFields_Returns400()
    {
        // Arrange
        var (client, _) = await CreateAuthenticatedClientAsync(verified: true);

        var request = new
        {
            ReportedUserIdentifier = "other@example.com"
            // Missing Category and Description
        };

        // Act
        var response = await client.PostAsJsonAsync("/v1/reports", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    [Fact]
    public async Task CreateReport_InvalidCategory_Returns400()
    {
        // Arrange
        var (reporterClient, _) = await CreateAuthenticatedClientAsync(verified: true);
        var (_, reportedUser) = await CreateAuthenticatedClientAsync();

        var request = new
        {
            ReportedUserIdentifier = reportedUser.Email,
            Category = "InvalidCategory",
            Description = "Test report"
        };

        // Act
        var response = await reporterClient.PostAsJsonAsync("/v1/reports", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    [Fact]
    public async Task CreateReport_ExceedsRateLimit_Returns400()
    {
        // Arrange
        var (reporterClient, _) = await CreateAuthenticatedClientAsync(verified: true);

        // Create 6 reports (limit is 5 per day)
        for (int i = 0; i < 6; i++)
        {
            var (_, user) = await CreateAuthenticatedClientAsync();
            await reporterClient.PostAsJsonAsync("/v1/reports", new
            {
                ReportedUserIdentifier = user.Email,
                Category = "ItemNotReceived",
                Description = $"Test report {i}"
            });
        }

        var (_, lastUser) = await CreateAuthenticatedClientAsync();

        // Act - Try one more report
        var response = await reporterClient.PostAsJsonAsync("/v1/reports", new
        {
            ReportedUserIdentifier = lastUser.Email,
            Category = "FraudConcern",
            Description = "One too many"
        });

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        var content = await response.Content.ReadAsStringAsync();
        content.Should().Contain("rate limit");
    }

    [Fact]
    public async Task GetMyReports_ReturnsOnlyMyReports()
    {
        // Arrange
        var (reporterClient, reporter) = await CreateAuthenticatedClientAsync(verified: true);
        var (_, reportedUser1) = await CreateAuthenticatedClientAsync();
        var (_, reportedUser2) = await CreateAuthenticatedClientAsync();

        // Create reports
        await reporterClient.PostAsJsonAsync("/v1/reports", new
        {
            ReportedUserIdentifier = reportedUser1.Email,
            Category = "ItemNotReceived",
            Description = "Report 1"
        });

        await reporterClient.PostAsJsonAsync("/v1/reports", new
        {
            ReportedUserIdentifier = reportedUser2.Email,
            Category = "AggressiveBehaviour",
            Description = "Report 2"
        });

        // Act
        var response = await reporterClient.GetAsync("/v1/reports/mine");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var reports = await response.Content.ReadFromJsonAsync<List<dynamic>>();
        reports.Should().NotBeNull();
        reports!.Count.Should().BeGreaterThanOrEqualTo(2);
    }

    [Fact]
    public async Task CreateReport_Unauthenticated_Returns401()
    {
        // Arrange
        var unauthClient = _factory.CreateClient();

        var request = new
        {
            ReportedUserIdentifier = "other@example.com",
            Category = "FraudConcern",
            Description = "Test report"
        };

        // Act
        var response = await unauthClient.PostAsJsonAsync("/v1/reports", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }

    [Fact]
    public async Task CreateReport_WithEvidence_UploadsSuccessfully()
    {
        // Arrange
        var (reporterClient, _) = await CreateAuthenticatedClientAsync(verified: true);
        var (_, reportedUser) = await CreateAuthenticatedClientAsync();

        // Create report first
        var createResponse = await reporterClient.PostAsJsonAsync("/v1/reports", new
        {
            ReportedUserIdentifier = reportedUser.Email,
            Category = "FraudConcern",
            Description = "Evidence attached"
        });

        var report = await createResponse.Content.ReadFromJsonAsync<Dictionary<string, object>>();
        var reportId = report!["id"].ToString();

        // Create form data with file
        var content = new MultipartFormDataContent();
        var fileContent = new ByteArrayContent(new byte[] { 0x01, 0x02, 0x03 });
        fileContent.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("image/png");
        content.Add(fileContent, "file", "evidence.png");

        // Act
        var uploadResponse = await reporterClient.PostAsync($"/v1/reports/{reportId}/evidence", content);

        // Assert
        uploadResponse.StatusCode.Should().BeOneOf(HttpStatusCode.OK, HttpStatusCode.Created);
    }

    [Fact]
    public async Task CreateReport_DescriptionTooShort_Returns400()
    {
        // Arrange
        var (reporterClient, _) = await CreateAuthenticatedClientAsync(verified: true);
        var (_, reportedUser) = await CreateAuthenticatedClientAsync();

        var request = new
        {
            ReportedUserIdentifier = reportedUser.Email,
            Category = "FraudConcern",
            Description = "Too short" // Less than minimum required (e.g., 20 chars)
        };

        // Act
        var response = await reporterClient.PostAsJsonAsync("/v1/reports", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    [Fact]
    public async Task CreateReport_ValidCategories_AllWork()
    {
        // Arrange
        var (reporterClient, _) = await CreateAuthenticatedClientAsync(verified: true);
        var categories = new[] { "ItemNotReceived", "AggressiveBehaviour", "FraudConcern", "PaymentIssue", "OtherConcern" };

        foreach (var category in categories)
        {
            var (_, reportedUser) = await CreateAuthenticatedClientAsync();

            var request = new
            {
                ReportedUserIdentifier = reportedUser.Email,
                Category = category,
                Description = $"Testing category: {category}. This is a detailed description to meet minimum length requirements."
            };

            // Act
            var response = await reporterClient.PostAsJsonAsync("/v1/reports", request);

            // Assert
            response.StatusCode.Should().Be(HttpStatusCode.Created, $"Category {category} should be valid");
        }
    }
}
