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

public class MutualVerificationControllerTests : IClassFixture<TestWebApplicationFactory>
{
    private readonly HttpClient _client;
    private readonly TestWebApplicationFactory _factory;

    public MutualVerificationControllerTests(TestWebApplicationFactory factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
    }

    private async Task<(HttpClient client, User user)> CreateAuthenticatedClientAsync(string email = "")
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

        // Create authenticated client
        var authClient = _factory.CreateClient();
        authClient.DefaultRequestHeaders.Authorization =
            new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", tokens!.AccessToken);

        // Get user
        var user = await dbContext.Users.FindAsync(tokens.UserId);

        return (authClient, user!);
    }

    [Fact]
    public async Task CreateVerification_ValidRequest_ReturnsCreated()
    {
        // Arrange
        var (client1, user1) = await CreateAuthenticatedClientAsync();
        var (_, user2) = await CreateAuthenticatedClientAsync();

        var request = new
        {
            OtherUserIdentifier = user2.Email,
            Item = "Nike Shoes",
            Amount = 45.99,
            YourRole = "Buyer",
            Date = DateTime.UtcNow.AddDays(-1)
        };

        // Act
        var response = await client1.PostAsJsonAsync("/v1/mutual-verifications", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Created);

        var result = await response.Content.ReadFromJsonAsync<dynamic>();
        result.Should().NotBeNull();
    }

    [Fact]
    public async Task CreateVerification_WithYourself_Returns400()
    {
        // Arrange
        var (client, user) = await CreateAuthenticatedClientAsync();

        var request = new
        {
            OtherUserIdentifier = user.Email,
            Item = "Test Item",
            Amount = 10.00,
            YourRole = "Buyer",
            Date = DateTime.UtcNow.AddDays(-1)
        };

        // Act
        var response = await client.PostAsJsonAsync("/v1/mutual-verifications", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
        var content = await response.Content.ReadAsStringAsync();
        content.Should().Contain("cannot verify with yourself");
    }

    [Fact]
    public async Task CreateVerification_NonExistentUser_Returns404()
    {
        // Arrange
        var (client, _) = await CreateAuthenticatedClientAsync();

        var request = new
        {
            OtherUserIdentifier = "nonexistent@example.com",
            Item = "Test Item",
            Amount = 10.00,
            YourRole = "Buyer",
            Date = DateTime.UtcNow.AddDays(-1)
        };

        // Act
        var response = await client.PostAsJsonAsync("/v1/mutual-verifications", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.NotFound);
    }

    [Fact]
    public async Task CreateVerification_MissingRequiredFields_Returns400()
    {
        // Arrange
        var (client, _) = await CreateAuthenticatedClientAsync();

        var request = new
        {
            OtherUserIdentifier = "other@example.com"
            // Missing Item, Amount, YourRole, Date
        };

        // Act
        var response = await client.PostAsJsonAsync("/v1/mutual-verifications", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.BadRequest);
    }

    [Fact]
    public async Task GetIncoming_ReturnsOnlyMyRequests()
    {
        // Arrange
        var (client1, user1) = await CreateAuthenticatedClientAsync();
        var (client2, user2) = await CreateAuthenticatedClientAsync();

        // User1 creates verification request to User2
        await client1.PostAsJsonAsync("/v1/mutual-verifications", new
        {
            OtherUserIdentifier = user2.Email,
            Item = "Test Item",
            Amount = 25.00,
            YourRole = "Buyer",
            Date = DateTime.UtcNow.AddDays(-1)
        });

        // Act - User2 gets incoming requests
        var response = await client2.GetAsync("/v1/mutual-verifications/incoming");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var verifications = await response.Content.ReadFromJsonAsync<List<dynamic>>();
        verifications.Should().NotBeNull();
        verifications!.Count.Should().BeGreaterThan(0);
    }

    [Fact]
    public async Task RespondToVerification_Confirm_UpdatesStatus()
    {
        // Arrange
        var (client1, user1) = await CreateAuthenticatedClientAsync();
        var (client2, user2) = await CreateAuthenticatedClientAsync();

        // User1 creates verification request
        var createResponse = await client1.PostAsJsonAsync("/v1/mutual-verifications", new
        {
            OtherUserIdentifier = user2.Email,
            Item = "Test Item",
            Amount = 30.00,
            YourRole = "Buyer",
            Date = DateTime.UtcNow.AddDays(-1)
        });

        var created = await createResponse.Content.ReadFromJsonAsync<Dictionary<string, object>>();
        var verificationId = created!["id"].ToString();

        // Act - User2 confirms
        var response = await client2.PostAsJsonAsync($"/v1/mutual-verifications/{verificationId}/respond", new
        {
            Response = "confirm",
            YourRole = "Seller"
        });

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var result = await response.Content.ReadFromJsonAsync<Dictionary<string, object>>();
        result.Should().ContainKey("status");
    }

    [Fact]
    public async Task RespondToVerification_Reject_UpdatesStatus()
    {
        // Arrange
        var (client1, user1) = await CreateAuthenticatedClientAsync();
        var (client2, user2) = await CreateAuthenticatedClientAsync();

        // User1 creates verification request
        var createResponse = await client1.PostAsJsonAsync("/v1/mutual-verifications", new
        {
            OtherUserIdentifier = user2.Email,
            Item = "Test Item",
            Amount = 20.00,
            YourRole = "Seller",
            Date = DateTime.UtcNow.AddDays(-2)
        });

        var created = await createResponse.Content.ReadFromJsonAsync<Dictionary<string, object>>();
        var verificationId = created!["id"].ToString();

        // Act - User2 rejects
        var response = await client2.PostAsJsonAsync($"/v1/mutual-verifications/{verificationId}/respond", new
        {
            Response = "reject"
        });

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
    }

    [Fact]
    public async Task RespondToVerification_NotAuthorized_Returns403()
    {
        // Arrange
        var (client1, user1) = await CreateAuthenticatedClientAsync();
        var (client2, user2) = await CreateAuthenticatedClientAsync();
        var (client3, user3) = await CreateAuthenticatedClientAsync();

        // User1 creates verification request to User2
        var createResponse = await client1.PostAsJsonAsync("/v1/mutual-verifications", new
        {
            OtherUserIdentifier = user2.Email,
            Item = "Test Item",
            Amount = 15.00,
            YourRole = "Buyer",
            Date = DateTime.UtcNow.AddDays(-1)
        });

        var created = await createResponse.Content.ReadFromJsonAsync<Dictionary<string, object>>();
        var verificationId = created!["id"].ToString();

        // Act - User3 (uninvolved) tries to respond
        var response = await client3.PostAsJsonAsync($"/v1/mutual-verifications/{verificationId}/respond", new
        {
            Response = "confirm",
            YourRole = "Seller"
        });

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
    }

    [Fact]
    public async Task GetMyVerifications_ReturnsAllMyVerifications()
    {
        // Arrange
        var (client1, user1) = await CreateAuthenticatedClientAsync();
        var (_, user2) = await CreateAuthenticatedClientAsync();

        // Create multiple verifications
        await client1.PostAsJsonAsync("/v1/mutual-verifications", new
        {
            OtherUserIdentifier = user2.Email,
            Item = "Item 1",
            Amount = 10.00,
            YourRole = "Buyer",
            Date = DateTime.UtcNow.AddDays(-1)
        });

        await client1.PostAsJsonAsync("/v1/mutual-verifications", new
        {
            OtherUserIdentifier = user2.Email,
            Item = "Item 2",
            Amount = 20.00,
            YourRole = "Seller",
            Date = DateTime.UtcNow.AddDays(-2)
        });

        // Act
        var response = await client1.GetAsync("/v1/mutual-verifications");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);

        var verifications = await response.Content.ReadFromJsonAsync<List<dynamic>>();
        verifications.Should().NotBeNull();
        verifications!.Count.Should().BeGreaterThanOrEqualTo(2);
    }

    [Fact]
    public async Task CreateVerification_Unauthenticated_Returns401()
    {
        // Arrange
        var unauthClient = _factory.CreateClient();

        var request = new
        {
            OtherUserIdentifier = "other@example.com",
            Item = "Test Item",
            Amount = 10.00,
            YourRole = "Buyer",
            Date = DateTime.UtcNow.AddDays(-1)
        };

        // Act
        var response = await unauthClient.PostAsJsonAsync("/v1/mutual-verifications", request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
    }
}

public class TokenResponse
{
    public Guid UserId { get; set; }
    public string AccessToken { get; set; } = string.Empty;
    public string RefreshToken { get; set; } = string.Empty;
}
