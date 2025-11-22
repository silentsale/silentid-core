using Bogus;
using SilentID.Api.Models;

namespace SilentID.Api.Tests.Helpers;

/// <summary>
/// Test data builder using Bogus for generating realistic test data
/// </summary>
public class TestDataBuilder
{
    private static readonly Faker _faker = new();

    public static User CreateUser(
        string? email = null,
        string? username = null,
        bool isEmailVerified = true,
        AccountType accountType = AccountType.Free,
        AccountStatus accountStatus = AccountStatus.Active)
    {
        var user = new User
        {
            Id = Guid.NewGuid(),
            Email = email ?? _faker.Internet.Email().ToLowerInvariant(),
            Username = username ?? _faker.Internet.UserName().ToLowerInvariant(),
            DisplayName = _faker.Name.FirstName(),
            PhoneNumber = _faker.Phone.PhoneNumber(),
            IsEmailVerified = isEmailVerified,
            IsPhoneVerified = false,
            IsPasskeyEnabled = false,
            AccountStatus = accountStatus,
            AccountType = accountType,
            SignupIP = _faker.Internet.Ip(),
            SignupDeviceId = Guid.NewGuid().ToString(),
            CreatedAt = DateTime.UtcNow,
            UpdatedAt = DateTime.UtcNow
        };

        return user;
    }

    public static User CreateUserWithOAuth(
        string? appleUserId = null,
        string? googleUserId = null)
    {
        var user = CreateUser();
        user.AppleUserId = appleUserId;
        user.GoogleUserId = googleUserId;
        return user;
    }

    public static Session CreateSession(User user, bool isExpired = false)
    {
        return new Session
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            User = user,
            RefreshTokenHash = GenerateRandomHash(),
            ExpiresAt = isExpired ? DateTime.UtcNow.AddDays(-1) : DateTime.UtcNow.AddDays(7),
            IP = _faker.Internet.Ip(),
            DeviceId = Guid.NewGuid().ToString(),
            CreatedAt = DateTime.UtcNow
        };
    }

    public static AuthDevice CreateAuthDevice(User user, bool isTrusted = false)
    {
        return new AuthDevice
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            User = user,
            DeviceId = Guid.NewGuid().ToString(),
            DeviceModel = _faker.Random.ArrayElement(new[] { "iPhone 13 Pro", "Pixel 7", "Samsung Galaxy S23" }),
            OS = _faker.Random.ArrayElement(new[] { "iOS 17.2", "Android 14", "Android 13" }),
            Browser = _faker.Random.ArrayElement(new[] { "Safari", "Chrome", "Firefox" }),
            LastUsedAt = DateTime.UtcNow,
            IsTrusted = isTrusted,
            CreatedAt = DateTime.UtcNow
        };
    }

    public static string GenerateOtp()
    {
        return _faker.Random.Number(100000, 999999).ToString();
    }

    public static string GenerateEmail()
    {
        return _faker.Internet.Email().ToLowerInvariant();
    }

    public static string GenerateEmailAlias(string baseEmail)
    {
        var parts = baseEmail.Split('@');
        return $"{parts[0]}+test@{parts[1]}";
    }

    public static string GenerateRandomHash()
    {
        return Convert.ToBase64String(System.Security.Cryptography.SHA256.HashData(
            System.Text.Encoding.UTF8.GetBytes(_faker.Random.AlphaNumeric(64))));
    }
}
