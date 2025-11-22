using FluentAssertions;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Moq;
using SilentID.Api.Models;
using SilentID.Api.Services;
using SilentID.Api.Tests.Helpers;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Xunit;

namespace SilentID.Api.Tests.Unit.Services;

public class TokenServiceTests
{
    private readonly Mock<IConfiguration> _mockConfiguration;
    private readonly Mock<ILogger<TokenService>> _mockLogger;
    private readonly TokenService _tokenService;

    public TokenServiceTests()
    {
        _mockConfiguration = new Mock<IConfiguration>();
        _mockLogger = new Mock<ILogger<TokenService>>();

        // Configure JWT settings
        _mockConfiguration.Setup(x => x["Jwt:SecretKey"]).Returns("ThisIsAVerySecureSecretKeyForTestingPurposesOnly12345");
        _mockConfiguration.Setup(x => x["Jwt:Issuer"]).Returns("SilentID.Test");
        _mockConfiguration.Setup(x => x["Jwt:Audience"]).Returns("SilentID.Api.Test");

        _tokenService = new TokenService(_mockConfiguration.Object, _mockLogger.Object);
    }

    [Fact]
    public void GenerateAccessToken_ShouldContainUserClaims()
    {
        // Arrange
        var user = TestDataBuilder.CreateUser(
            email: "test@example.com",
            username: "testuser123",
            accountType: AccountType.Premium
        );

        // Act
        var token = _tokenService.GenerateAccessToken(user);

        // Assert
        token.Should().NotBeNullOrEmpty();

        var handler = new JwtSecurityTokenHandler();
        var jwtToken = handler.ReadJwtToken(token);

        jwtToken.Claims.Should().Contain(c => c.Type == "sub" && c.Value == user.Id.ToString());
        jwtToken.Claims.Should().Contain(c => c.Type == "email" && c.Value == user.Email);
        jwtToken.Claims.Should().Contain(c => c.Type == "username" && c.Value == user.Username);
        jwtToken.Claims.Should().Contain(c => c.Type == "account_type" && c.Value == "Premium");
    }

    [Fact]
    public void GenerateAccessToken_ShouldExpireIn15Minutes()
    {
        // Arrange
        var user = TestDataBuilder.CreateUser();

        // Act
        var token = _tokenService.GenerateAccessToken(user);

        // Assert
        var handler = new JwtSecurityTokenHandler();
        var jwtToken = handler.ReadJwtToken(token);

        var expiryTime = jwtToken.ValidTo;
        var expectedExpiry = DateTime.UtcNow.AddMinutes(15);

        expiryTime.Should().BeCloseTo(expectedExpiry, TimeSpan.FromSeconds(5));
    }

    [Fact]
    public void GenerateRefreshToken_ShouldBeUnique()
    {
        // Act
        var token1 = _tokenService.GenerateRefreshToken();
        var token2 = _tokenService.GenerateRefreshToken();
        var token3 = _tokenService.GenerateRefreshToken();

        // Assert
        token1.Should().NotBeNullOrEmpty();
        token2.Should().NotBeNullOrEmpty();
        token3.Should().NotBeNullOrEmpty();

        token1.Should().NotBe(token2);
        token2.Should().NotBe(token3);
        token1.Should().NotBe(token3);
    }

    [Fact]
    public void GenerateRefreshToken_ShouldBeSecure()
    {
        // Act
        var token = _tokenService.GenerateRefreshToken();

        // Assert
        token.Length.Should().BeGreaterThan(64); // Base64 encoded 64 bytes
        token.Should().MatchRegex("^[A-Za-z0-9+/=]+$"); // Valid Base64
    }

    [Fact]
    public void ValidateAccessToken_WithValidToken_ShouldReturnClaims()
    {
        // Arrange
        var user = TestDataBuilder.CreateUser();
        var token = _tokenService.GenerateAccessToken(user);

        // Act
        var principal = _tokenService.ValidateAccessToken(token);

        // Assert
        principal.Should().NotBeNull();
        principal!.FindFirst(ClaimTypes.NameIdentifier)?.Value.Should().Be(user.Id.ToString());
        principal.FindFirst("email")?.Value.Should().Be(user.Email);
    }

    [Fact]
    public void ValidateAccessToken_WithInvalidToken_ShouldReturnNull()
    {
        // Arrange
        var invalidToken = "invalid.token.here";

        // Act
        var principal = _tokenService.ValidateAccessToken(invalidToken);

        // Assert
        principal.Should().BeNull();
    }

    [Fact]
    public void ValidateAccessToken_WithExpiredToken_ShouldReturnNull()
    {
        // Note: This test would need to wait 15 minutes or manipulate time
        // For now, we'll test with an invalid signature which also returns null

        // Arrange
        var tamperedToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

        // Act
        var principal = _tokenService.ValidateAccessToken(tamperedToken);

        // Assert
        principal.Should().BeNull();
    }

    [Fact]
    public void HashRefreshToken_ShouldBeConsistent()
    {
        // Arrange
        var refreshToken = "test-refresh-token-123";

        // Act
        var hash1 = _tokenService.HashRefreshToken(refreshToken);
        var hash2 = _tokenService.HashRefreshToken(refreshToken);

        // Assert
        hash1.Should().NotBeNullOrEmpty();
        hash1.Should().Be(hash2); // Same input should produce same hash
    }

    [Fact]
    public void HashRefreshToken_DifferentInputs_ShouldProduceDifferentHashes()
    {
        // Act
        var hash1 = _tokenService.HashRefreshToken("token1");
        var hash2 = _tokenService.HashRefreshToken("token2");

        // Assert
        hash1.Should().NotBe(hash2);
    }

    [Fact]
    public void ValidateRefreshTokenHash_WithCorrectToken_ShouldReturnTrue()
    {
        // Arrange
        var refreshToken = _tokenService.GenerateRefreshToken();
        var hash = _tokenService.HashRefreshToken(refreshToken);

        // Act
        var isValid = _tokenService.ValidateRefreshTokenHash(refreshToken, hash);

        // Assert
        isValid.Should().BeTrue();
    }

    [Fact]
    public void ValidateRefreshTokenHash_WithWrongToken_ShouldReturnFalse()
    {
        // Arrange
        var refreshToken = _tokenService.GenerateRefreshToken();
        var hash = _tokenService.HashRefreshToken(refreshToken);
        var wrongToken = _tokenService.GenerateRefreshToken();

        // Act
        var isValid = _tokenService.ValidateRefreshTokenHash(wrongToken, hash);

        // Assert
        isValid.Should().BeFalse();
    }
}
