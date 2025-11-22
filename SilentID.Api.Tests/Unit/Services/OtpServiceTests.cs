using FluentAssertions;
using Microsoft.Extensions.Logging;
using Moq;
using SilentID.Api.Services;
using Xunit;

namespace SilentID.Api.Tests.Unit.Services;

/// <summary>
/// NOTE: OTP service uses static storage, so tests are isolated using unique emails per test
/// </summary>
public class OtpServiceTests
{
    private readonly Mock<ILogger<OtpService>> _mockLogger;
    private readonly Mock<IEmailService> _mockEmailService;
    private readonly OtpService _otpService;

    public OtpServiceTests()
    {
        _mockLogger = new Mock<ILogger<OtpService>>();
        _mockEmailService = new Mock<IEmailService>();
        _otpService = new OtpService(_mockLogger.Object, _mockEmailService.Object);
    }

    private string GenerateUniqueEmail() => $"test{Guid.NewGuid()}@example.com";

    [Fact]
    public async Task GenerateOtpAsync_ShouldReturn6DigitCode()
    {
        // Arrange
        var email = GenerateUniqueEmail();

        // Act
        var otp = await _otpService.GenerateOtpAsync(email);

        // Assert
        otp.Should().NotBeNullOrEmpty();
        otp.Length.Should().Be(6);
        otp.Should().MatchRegex("^[0-9]{6}$");
    }

    [Fact]
    public async Task GenerateOtpAsync_ShouldSendEmail()
    {
        // Arrange
        var email = GenerateUniqueEmail();

        // Act
        await _otpService.GenerateOtpAsync(email);

        // Assert
        _mockEmailService.Verify(
            x => x.SendOtpEmailAsync(email, It.IsAny<string>(), 10),
            Times.Once
        );
    }

    [Fact]
    public async Task ValidateOtpAsync_WithCorrectCode_ShouldReturnTrue()
    {
        // Arrange
        var email = GenerateUniqueEmail();
        var otp = await _otpService.GenerateOtpAsync(email);

        // Act
        var result = await _otpService.ValidateOtpAsync(email, otp);

        // Assert
        result.Should().BeTrue();
    }

    [Fact]
    public async Task ValidateOtpAsync_WithWrongCode_ShouldReturnFalse()
    {
        // Arrange
        var email = GenerateUniqueEmail();
        await _otpService.GenerateOtpAsync(email);

        // Act
        var result = await _otpService.ValidateOtpAsync(email, "000000");

        // Assert
        result.Should().BeFalse();
    }

    [Fact]
    public async Task ValidateOtpAsync_WithNonExistentEmail_ShouldReturnFalse()
    {
        // Arrange
        var email = GenerateUniqueEmail();

        // Act
        var result = await _otpService.ValidateOtpAsync(email, "123456");

        // Assert
        result.Should().BeFalse();
    }

    [Fact]
    public async Task ValidateOtpAsync_AfterMaxAttempts_ShouldLockOut()
    {
        // Arrange
        var email = GenerateUniqueEmail();
        var otp = await _otpService.GenerateOtpAsync(email);

        // Act - Make 3 failed attempts
        await _otpService.ValidateOtpAsync(email, "wrong1");
        await _otpService.ValidateOtpAsync(email, "wrong2");
        await _otpService.ValidateOtpAsync(email, "wrong3");

        // Fourth attempt should fail even with correct OTP
        var result = await _otpService.ValidateOtpAsync(email, otp);

        // Assert
        result.Should().BeFalse();
    }

    [Fact]
    public async Task ValidateOtpAsync_ShouldRemoveOtpAfterSuccessfulValidation()
    {
        // Arrange
        var email = GenerateUniqueEmail();
        var otp = await _otpService.GenerateOtpAsync(email);

        // Act
        await _otpService.ValidateOtpAsync(email, otp);

        // Try to use same OTP again
        var secondAttempt = await _otpService.ValidateOtpAsync(email, otp);

        // Assert
        secondAttempt.Should().BeFalse();
    }

    [Fact]
    public async Task CanRequestOtpAsync_NewUser_ShouldReturnTrue()
    {
        // Arrange
        var email = GenerateUniqueEmail();

        // Act
        var canRequest = await _otpService.CanRequestOtpAsync(email);

        // Assert
        canRequest.Should().BeTrue();
    }

    [Fact]
    public async Task GenerateOtpAsync_RateLimited_ShouldThrowException()
    {
        // Arrange
        var email = GenerateUniqueEmail();

        // Generate 3 OTPs (max limit)
        await _otpService.GenerateOtpAsync(email);
        await _otpService.GenerateOtpAsync(email);
        await _otpService.GenerateOtpAsync(email);

        // Act & Assert
        var act = async () => await _otpService.GenerateOtpAsync(email);
        await act.Should().ThrowAsync<InvalidOperationException>()
            .WithMessage("*Too many OTP requests*");
    }

    [Fact]
    public async Task RevokeOtpAsync_ShouldInvalidateOtp()
    {
        // Arrange
        var email = GenerateUniqueEmail();
        var otp = await _otpService.GenerateOtpAsync(email);

        // Act
        await _otpService.RevokeOtpAsync(email);
        var result = await _otpService.ValidateOtpAsync(email, otp);

        // Assert
        result.Should().BeFalse();
    }

    [Fact]
    public async Task GenerateOtpAsync_ShouldNormalizeEmail()
    {
        // Arrange
        var uniquePart = Guid.NewGuid().ToString();
        var email = $"Test{uniquePart}@Example.COM";
        var expectedEmail = email.ToLowerInvariant();

        // Act
        await _otpService.GenerateOtpAsync(email);

        // Assert - Should send to lowercase email
        _mockEmailService.Verify(
            x => x.SendOtpEmailAsync(expectedEmail, It.IsAny<string>(), 10),
            Times.Once
        );
    }
}
