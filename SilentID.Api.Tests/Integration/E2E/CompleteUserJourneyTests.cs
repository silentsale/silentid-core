using FluentAssertions;
using Microsoft.Extensions.DependencyInjection;
using SilentID.Api.Data;
using SilentID.Api.Models;
using SilentID.Api.Services;
using SilentID.Api.Tests.Helpers;
using System.Net;
using System.Net.Http.Json;
using Xunit;

namespace SilentID.Api.Tests.Integration.E2E;

/// <summary>
/// End-to-end tests simulating complete user journeys through the SilentID platform
/// </summary>
public class CompleteUserJourneyTests : IClassFixture<TestWebApplicationFactory>
{
    private readonly HttpClient _client;
    private readonly TestWebApplicationFactory _factory;

    public CompleteUserJourneyTests(TestWebApplicationFactory factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task CompleteJourney_NewUserToMutualVerification_Success()
    {
        /*
         * COMPLETE USER JOURNEY:
         * 1. New user signs up with email OTP
         * 2. Verifies identity with Stripe
         * 3. Adds evidence (receipt)
         * 4. Checks TrustScore (should be > 200)
         * 5. Creates mutual verification with another user
         * 6. Other user confirms
         * 7. TrustScore increases
         */

        // === PHASE 1: User Registration === //
        var email = TestDataBuilder.GenerateEmail();

        using var scope = _factory.Services.CreateScope();
        var emailService = scope.ServiceProvider.GetRequiredService<IEmailService>() as MockEmailService;
        emailService!.ClearSentEmails();

        // Request OTP
        var otpResponse = await _client.PostAsJsonAsync("/v1/auth/request-otp", new { Email = email });
        otpResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // Get OTP from mock email
        var sentEmail = emailService.SentEmails.FirstOrDefault(e => e.To == email);
        sentEmail.Should().NotBeNull();
        var otp = sentEmail!.Content;

        // Verify OTP and login
        var loginResponse = await _client.PostAsJsonAsync("/v1/auth/verify-otp", new
        {
            Email = email,
            Otp = otp,
            DeviceId = Guid.NewGuid().ToString()
        });
        loginResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        var tokens = await loginResponse.Content.ReadFromJsonAsync<TokenResponse>();
        tokens.Should().NotBeNull();
        tokens!.AccessToken.Should().NotBeNullOrEmpty();

        var authClient = _factory.CreateClient();
        authClient.DefaultRequestHeaders.Authorization =
            new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", tokens.AccessToken);

        // === PHASE 2: Identity Verification === //
        var identityResponse = await authClient.PostAsync("/v1/identity/stripe/session", null);
        identityResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // Simulate Stripe verification completion
        var dbContext = scope.ServiceProvider.GetRequiredService<SilentIdDbContext>();
        var user = await dbContext.Users.FindAsync(tokens.UserId);
        user.Should().NotBeNull();

        var identityVerification = new IdentityVerification
        {
            Id = Guid.NewGuid(),
            UserId = user!.Id,
            Status = VerificationStatus.Verified,
            Level = VerificationLevel.Basic,
            StripeVerificationId = $"stripe_test_{Guid.NewGuid()}",
            VerifiedAt = DateTime.UtcNow,
            CreatedAt = DateTime.UtcNow
        };
        dbContext.IdentityVerifications.Add(identityVerification);
        await dbContext.SaveChangesAsync();

        // Verify identity status
        var statusResponse = await authClient.GetAsync("/v1/identity/status");
        statusResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        var status = await statusResponse.Content.ReadFromJsonAsync<Dictionary<string, object>>();
        status.Should().ContainKey("status");

        // === PHASE 3: Add Evidence === //
        var receiptResponse = await authClient.PostAsJsonAsync("/v1/evidence/receipts/manual", new
        {
            Platform = "Vinted",
            Item = "Nike Air Max",
            Amount = 65.99,
            Currency = "GBP",
            Role = "Buyer",
            Date = DateTime.UtcNow.AddDays(-7),
            OrderId = $"VINTED-{Guid.NewGuid()}"
        });
        receiptResponse.StatusCode.Should().Be(HttpStatusCode.Created);

        // === PHASE 4: Check Initial TrustScore === //
        var scoreResponse = await authClient.GetAsync("/v1/trustscore/me");
        scoreResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        var scoreData = await scoreResponse.Content.ReadFromJsonAsync<Dictionary<string, object>>();
        scoreData.Should().ContainKey("totalScore");

        var totalScore = Convert.ToInt32(scoreData!["totalScore"]);
        totalScore.Should().BeGreaterThan(200, "User should have identity score + some evidence score");

        var initialScore = totalScore;

        // === PHASE 5: Create Second User === //
        var email2 = TestDataBuilder.GenerateEmail();
        emailService.ClearSentEmails();

        await _client.PostAsJsonAsync("/v1/auth/request-otp", new { Email = email2 });
        var sentEmail2 = emailService.SentEmails.FirstOrDefault(e => e.To == email2);
        var otp2 = sentEmail2!.Content;

        var loginResponse2 = await _client.PostAsJsonAsync("/v1/auth/verify-otp", new
        {
            Email = email2,
            Otp = otp2,
            DeviceId = Guid.NewGuid().ToString()
        });

        var tokens2 = await loginResponse2.Content.ReadFromJsonAsync<TokenResponse>();

        var authClient2 = _factory.CreateClient();
        authClient2.DefaultRequestHeaders.Authorization =
            new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", tokens2!.AccessToken);

        // Verify second user's identity
        var user2 = await dbContext.Users.FindAsync(tokens2.UserId);
        var identityVerification2 = new IdentityVerification
        {
            Id = Guid.NewGuid(),
            UserId = user2!.Id,
            Status = VerificationStatus.Verified,
            Level = VerificationLevel.Basic,
            StripeVerificationId = $"stripe_test_{Guid.NewGuid()}",
            VerifiedAt = DateTime.UtcNow,
            CreatedAt = DateTime.UtcNow
        };
        dbContext.IdentityVerifications.Add(identityVerification2);
        await dbContext.SaveChangesAsync();

        // === PHASE 6: Create Mutual Verification === //
        var verificationResponse = await authClient.PostAsJsonAsync("/v1/mutual-verifications", new
        {
            OtherUserIdentifier = email2,
            Item = "Vintage Camera",
            Amount = 120.00,
            YourRole = "Buyer",
            Date = DateTime.UtcNow.AddDays(-3)
        });
        verificationResponse.StatusCode.Should().Be(HttpStatusCode.Created);

        var verification = await verificationResponse.Content.ReadFromJsonAsync<Dictionary<string, object>>();
        verification.Should().ContainKey("id");
        var verificationId = verification!["id"].ToString();

        // === PHASE 7: Second User Confirms === //
        var confirmResponse = await authClient2.PostAsJsonAsync($"/v1/mutual-verifications/{verificationId}/respond", new
        {
            Response = "confirm",
            YourRole = "Seller"
        });
        confirmResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        // === PHASE 8: Verify TrustScore Increased === //
        // Wait a moment for score recalculation (if async)
        await Task.Delay(500);

        var finalScoreResponse = await authClient.GetAsync("/v1/trustscore/me");
        finalScoreResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        var finalScoreData = await finalScoreResponse.Content.ReadFromJsonAsync<Dictionary<string, object>>();
        var finalScore = Convert.ToInt32(finalScoreData!["totalScore"]);

        // TrustScore should be higher after mutual verification
        finalScore.Should().BeGreaterThanOrEqualTo(initialScore, "Mutual verification should increase or maintain TrustScore");

        // === JOURNEY COMPLETE === //
        // User has successfully:
        // - Registered
        // - Verified identity
        // - Added evidence
        // - Created and confirmed mutual verification
        // - Built trust profile
    }

    [Fact]
    public async Task CompleteJourney_UserFilesReport_Success()
    {
        /*
         * REPORT FILING JOURNEY:
         * 1. User A registers and verifies identity
         * 2. User B registers (suspicious behavior)
         * 3. User A files safety report against User B
         * 4. Report is created successfully
         * 5. User A can view their filed reports
         */

        // === PHASE 1: Create and verify User A === //
        var emailA = TestDataBuilder.GenerateEmail();

        using var scope = _factory.Services.CreateScope();
        var emailService = scope.ServiceProvider.GetRequiredService<IEmailService>() as MockEmailService;
        emailService!.ClearSentEmails();

        await _client.PostAsJsonAsync("/v1/auth/request-otp", new { Email = emailA });
        var sentEmailA = emailService.SentEmails.FirstOrDefault(e => e.To == emailA);
        var otpA = sentEmailA!.Content;

        var loginResponseA = await _client.PostAsJsonAsync("/v1/auth/verify-otp", new
        {
            Email = emailA,
            Otp = otpA,
            DeviceId = Guid.NewGuid().ToString()
        });

        var tokensA = await loginResponseA.Content.ReadFromJsonAsync<TokenResponse>();

        var authClientA = _factory.CreateClient();
        authClientA.DefaultRequestHeaders.Authorization =
            new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", tokensA!.AccessToken);

        // Verify User A's identity
        var dbContext = scope.ServiceProvider.GetRequiredService<SilentIdDbContext>();
        var userA = await dbContext.Users.FindAsync(tokensA.UserId);

        var identityVerificationA = new IdentityVerification
        {
            Id = Guid.NewGuid(),
            UserId = userA!.Id,
            Status = VerificationStatus.Verified,
            Level = VerificationLevel.Basic,
            StripeVerificationId = $"stripe_test_{Guid.NewGuid()}",
            VerifiedAt = DateTime.UtcNow,
            CreatedAt = DateTime.UtcNow
        };
        dbContext.IdentityVerifications.Add(identityVerificationA);
        await dbContext.SaveChangesAsync();

        // === PHASE 2: Create User B === //
        var emailB = TestDataBuilder.GenerateEmail();
        emailService.ClearSentEmails();

        await _client.PostAsJsonAsync("/v1/auth/request-otp", new { Email = emailB });
        var sentEmailB = emailService.SentEmails.FirstOrDefault(e => e.To == emailB);
        var otpB = sentEmailB!.Content;

        await _client.PostAsJsonAsync("/v1/auth/verify-otp", new
        {
            Email = emailB,
            Otp = otpB,
            DeviceId = Guid.NewGuid().ToString()
        });

        // === PHASE 3: User A Files Report === //
        var reportResponse = await authClientA.PostAsJsonAsync("/v1/reports", new
        {
            ReportedUserIdentifier = emailB,
            Category = "ItemNotReceived",
            Description = "I purchased an item from this seller 2 weeks ago. Payment was sent via PayPal but the item never arrived. Seller stopped responding to messages after payment was received."
        });
        reportResponse.StatusCode.Should().Be(HttpStatusCode.Created);

        var report = await reportResponse.Content.ReadFromJsonAsync<Dictionary<string, object>>();
        report.Should().ContainKey("id");
        report.Should().ContainKey("status");

        // === PHASE 4: View Filed Reports === //
        var myReportsResponse = await authClientA.GetAsync("/v1/reports/mine");
        myReportsResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        var myReports = await myReportsResponse.Content.ReadFromJsonAsync<List<Dictionary<string, object>>>();
        myReports.Should().NotBeNull();
        myReports!.Count.Should().BeGreaterThan(0);

        // === JOURNEY COMPLETE === //
        // User successfully filed a safety report
    }

    [Fact]
    public async Task CompleteJourney_MultipleEvidenceSources_BuildsStrongProfile()
    {
        /*
         * COMPREHENSIVE EVIDENCE JOURNEY:
         * 1. User registers and verifies
         * 2. Adds multiple receipt evidence
         * 3. Adds screenshot evidence
         * 4. Adds public profile link
         * 5. TrustScore reflects all evidence
         */

        // === PHASE 1: User Registration === //
        var email = TestDataBuilder.GenerateEmail();

        using var scope = _factory.Services.CreateScope();
        var emailService = scope.ServiceProvider.GetRequiredService<IEmailService>() as MockEmailService;
        emailService!.ClearSentEmails();

        await _client.PostAsJsonAsync("/v1/auth/request-otp", new { Email = email });
        var sentEmail = emailService.SentEmails.FirstOrDefault(e => e.To == email);
        var otp = sentEmail!.Content;

        var loginResponse = await _client.PostAsJsonAsync("/v1/auth/verify-otp", new
        {
            Email = email,
            Otp = otp,
            DeviceId = Guid.NewGuid().ToString()
        });

        var tokens = await loginResponse.Content.ReadFromJsonAsync<TokenResponse>();

        var authClient = _factory.CreateClient();
        authClient.DefaultRequestHeaders.Authorization =
            new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", tokens!.AccessToken);

        // Verify identity
        var dbContext = scope.ServiceProvider.GetRequiredService<SilentIdDbContext>();
        var user = await dbContext.Users.FindAsync(tokens.UserId);

        var identityVerification = new IdentityVerification
        {
            Id = Guid.NewGuid(),
            UserId = user!.Id,
            Status = VerificationStatus.Verified,
            Level = VerificationLevel.Basic,
            StripeVerificationId = $"stripe_test_{Guid.NewGuid()}",
            VerifiedAt = DateTime.UtcNow,
            CreatedAt = DateTime.UtcNow
        };
        dbContext.IdentityVerifications.Add(identityVerification);
        await dbContext.SaveChangesAsync();

        // === PHASE 2: Add Multiple Receipts === //
        var platforms = new[] { "Vinted", "eBay", "Depop", "Etsy" };
        foreach (var platform in platforms)
        {
            var receiptResponse = await authClient.PostAsJsonAsync("/v1/evidence/receipts/manual", new
            {
                Platform = platform,
                Item = $"Test item from {platform}",
                Amount = 20.00 + Random.Shared.Next(50),
                Currency = "GBP",
                Role = Random.Shared.Next(2) == 0 ? "Buyer" : "Seller",
                Date = DateTime.UtcNow.AddDays(-Random.Shared.Next(30)),
                OrderId = $"{platform}-{Guid.NewGuid()}"
            });
            receiptResponse.StatusCode.Should().Be(HttpStatusCode.Created);
        }

        // === PHASE 3: Add Screenshot Evidence === //
        var screenshotContent = new MultipartFormDataContent();
        var fileContent = new ByteArrayContent(new byte[] { 0x01, 0x02, 0x03, 0x04 });
        fileContent.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("image/png");
        screenshotContent.Add(fileContent, "file", "profile-screenshot.png");
        screenshotContent.Add(new StringContent("Vinted"), "platform");

        var screenshotResponse = await authClient.PostAsync("/v1/evidence/screenshots", screenshotContent);
        screenshotResponse.StatusCode.Should().BeOneOf(HttpStatusCode.Created, HttpStatusCode.OK);

        // === PHASE 4: Add Public Profile Link === //
        var profileResponse = await authClient.PostAsJsonAsync("/v1/evidence/profile-links", new
        {
            Url = "https://www.vinted.co.uk/member/12345678-testuser",
            Platform = "Vinted"
        });
        profileResponse.StatusCode.Should().BeOneOf(HttpStatusCode.Created, HttpStatusCode.OK);

        // === PHASE 5: Check Comprehensive TrustScore === //
        var scoreResponse = await authClient.GetAsync("/v1/trustscore/me");
        scoreResponse.StatusCode.Should().Be(HttpStatusCode.OK);

        var scoreData = await scoreResponse.Content.ReadFromJsonAsync<Dictionary<string, object>>();
        var totalScore = Convert.ToInt32(scoreData!["totalScore"]);

        // With identity + 4 receipts + screenshot + profile link, score should be substantial
        totalScore.Should().BeGreaterThan(300, "Comprehensive evidence should result in high TrustScore");

        // === JOURNEY COMPLETE === //
        // User built a strong trust profile with multiple evidence types
    }
}

public class TokenResponse
{
    public Guid UserId { get; set; }
    public string AccessToken { get; set; } = string.Empty;
    public string RefreshToken { get; set; } = string.Empty;
}
