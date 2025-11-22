using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Moq;
using SilentID.Api.Data;
using SilentID.Api.Models;
using SilentID.Api.Services;
using SilentID.Api.Tests.Helpers;
using Xunit;

namespace SilentID.Api.Tests.Unit.Services;

public class DuplicateDetectionServiceTests : IDisposable
{
    private readonly SilentIdDbContext _context;
    private readonly Mock<ILogger<DuplicateDetectionService>> _mockLogger;
    private readonly DuplicateDetectionService _service;

    public DuplicateDetectionServiceTests()
    {
        var options = new DbContextOptionsBuilder<SilentIdDbContext>()
            .UseInMemoryDatabase(databaseName: "TestDb_" + Guid.NewGuid())
            .Options;

        _context = new SilentIdDbContext(options);
        _mockLogger = new Mock<ILogger<DuplicateDetectionService>>();
        _service = new DuplicateDetectionService(_context, _mockLogger.Object);
    }

    [Fact]
    public async Task CheckForDuplicatesAsync_SameEmail_ShouldDetect()
    {
        // Arrange
        var email = "test@example.com";
        var existingUser = TestDataBuilder.CreateUser(email: email);
        _context.Users.Add(existingUser);
        await _context.SaveChangesAsync();

        // Act
        var result = await _service.CheckForDuplicatesAsync(email);

        // Assert
        result.IsSuspicious.Should().BeTrue();
        result.HasExistingUser.Should().BeTrue();
        result.ExistingUserId.Should().Be(existingUser.Id);
        result.Reasons.Should().Contain("Email already registered");
    }

    [Fact]
    public async Task CheckForDuplicatesAsync_EmailAlias_ShouldDetect()
    {
        // Arrange
        var baseEmail = "user@gmail.com";
        var aliasEmail = "user+alias@gmail.com";

        var existingUser = TestDataBuilder.CreateUser(email: baseEmail);
        _context.Users.Add(existingUser);
        await _context.SaveChangesAsync();

        // Act
        var result = await _service.CheckForDuplicatesAsync(aliasEmail);

        // Assert
        result.IsSuspicious.Should().BeTrue();
        result.Reasons.Should().Contain(r => r.Contains("Email alias detected"));
    }

    [Fact]
    public async Task CheckForDuplicatesAsync_SameDevice_ShouldDetect()
    {
        // Arrange
        var deviceId = Guid.NewGuid().ToString();
        var existingUser = TestDataBuilder.CreateUser();
        existingUser.SignupDeviceId = deviceId;
        _context.Users.Add(existingUser);
        await _context.SaveChangesAsync();

        // Act
        var result = await _service.CheckForDuplicatesAsync("newuser@example.com", deviceId: deviceId);

        // Assert
        result.IsSuspicious.Should().BeTrue();
        result.Reasons.Should().Contain("Device fingerprint matches existing account");
        result.SimilarUsers.Should().Contain(existingUser.Id);
    }

    [Fact]
    public async Task CheckForDuplicatesAsync_SameIP_ShouldDetect()
    {
        // Arrange
        var ipAddress = "192.168.1.100";

        // Create 3 users with same IP (threshold)
        for (int i = 0; i < 3; i++)
        {
            var user = TestDataBuilder.CreateUser(email: $"user{i}@example.com");
            user.SignupIP = ipAddress;
            _context.Users.Add(user);
        }
        await _context.SaveChangesAsync();

        // Act
        var result = await _service.CheckForDuplicatesAsync("newuser@example.com", ipAddress: ipAddress);

        // Assert
        result.IsSuspicious.Should().BeTrue();
        result.Reasons.Should().Contain(r => r.Contains("IP address used by"));
    }

    [Fact]
    public async Task CheckForDuplicatesAsync_DifferentUser_ShouldNotDetect()
    {
        // Arrange
        var existingUser = TestDataBuilder.CreateUser(email: "existing@example.com");
        _context.Users.Add(existingUser);
        await _context.SaveChangesAsync();

        // Act
        var result = await _service.CheckForDuplicatesAsync(
            "different@example.com",
            deviceId: Guid.NewGuid().ToString(),
            ipAddress: "10.0.0.1"
        );

        // Assert
        result.IsSuspicious.Should().BeFalse();
        result.HasExistingUser.Should().BeFalse();
        result.Reasons.Should().BeEmpty();
    }

    [Fact]
    public async Task CheckOAuthProviderAsync_ExistingAppleUserId_ShouldDetect()
    {
        // Arrange
        var appleUserId = "apple-user-12345";
        var existingUser = TestDataBuilder.CreateUserWithOAuth(appleUserId: appleUserId);
        _context.Users.Add(existingUser);
        await _context.SaveChangesAsync();

        // Act
        var result = await _service.CheckOAuthProviderAsync(appleUserId, null);

        // Assert
        result.IsSuspicious.Should().BeTrue();
        result.HasExistingUser.Should().BeTrue();
        result.ExistingUserId.Should().Be(existingUser.Id);
        result.Reasons.Should().Contain("Apple User ID already registered");
    }

    [Fact]
    public async Task CheckOAuthProviderAsync_ExistingGoogleUserId_ShouldDetect()
    {
        // Arrange
        var googleUserId = "google-user-67890";
        var existingUser = TestDataBuilder.CreateUserWithOAuth(googleUserId: googleUserId);
        _context.Users.Add(existingUser);
        await _context.SaveChangesAsync();

        // Act
        var result = await _service.CheckOAuthProviderAsync(null, googleUserId);

        // Assert
        result.IsSuspicious.Should().BeTrue();
        result.HasExistingUser.Should().BeTrue();
        result.ExistingUserId.Should().Be(existingUser.Id);
        result.Reasons.Should().Contain("Google User ID already registered");
    }

    [Fact]
    public async Task CheckOAuthProviderAsync_NewUser_ShouldNotDetect()
    {
        // Act
        var result = await _service.CheckOAuthProviderAsync("new-apple-user", "new-google-user");

        // Assert
        result.IsSuspicious.Should().BeFalse();
        result.HasExistingUser.Should().BeFalse();
    }

    [Fact]
    public async Task IsEmailAliasAsync_GmailAlias_ShouldReturnTrue()
    {
        // Act
        var result = await _service.IsEmailAliasAsync("user+alias@gmail.com");

        // Assert
        result.Should().BeTrue();
    }

    [Fact]
    public async Task IsEmailAliasAsync_OutlookAlias_ShouldReturnTrue()
    {
        // Act
        var result = await _service.IsEmailAliasAsync("user+test@outlook.com");

        // Assert
        result.Should().BeTrue();
    }

    [Fact]
    public async Task IsEmailAliasAsync_NormalEmail_ShouldReturnFalse()
    {
        // Act
        var result = await _service.IsEmailAliasAsync("user@example.com");

        // Assert
        result.Should().BeFalse();
    }

    [Fact]
    public async Task CheckForDuplicatesAsync_DeviceUsedByMultipleUsers_ShouldDetect()
    {
        // Arrange
        var deviceId = Guid.NewGuid().ToString();

        // Create 2 users with same device in AuthDevices
        var user1 = TestDataBuilder.CreateUser(email: "user1@example.com");
        var user2 = TestDataBuilder.CreateUser(email: "user2@example.com");

        _context.Users.AddRange(user1, user2);
        await _context.SaveChangesAsync();

        var device1 = TestDataBuilder.CreateAuthDevice(user1);
        device1.DeviceId = deviceId;
        var device2 = TestDataBuilder.CreateAuthDevice(user2);
        device2.DeviceId = deviceId;

        _context.AuthDevices.AddRange(device1, device2);
        await _context.SaveChangesAsync();

        // Act
        var result = await _service.CheckForDuplicatesAsync("newuser@example.com", deviceId: deviceId);

        // Assert
        result.IsSuspicious.Should().BeTrue();
        result.Reasons.Should().Contain(r => r.Contains("Device used by") && r.Contains("accounts"));
    }

    public void Dispose()
    {
        _context.Database.EnsureDeleted();
        _context.Dispose();
    }
}
