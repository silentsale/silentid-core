using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

public interface IAppleAuthService
{
    /// <summary>
    /// Validate Apple identity token and authenticate/register user
    /// </summary>
    Task<AppleAuthResult> AuthenticateAsync(AppleSignInRequest request);

    /// <summary>
    /// Link Apple account to existing user
    /// </summary>
    Task<bool> LinkAppleAccountAsync(Guid userId, string identityToken);

    /// <summary>
    /// Unlink Apple account from user
    /// </summary>
    Task<bool> UnlinkAppleAccountAsync(Guid userId);
}

public class AppleAuthService : IAppleAuthService
{
    private readonly SilentIdDbContext _context;
    private readonly IConfiguration _configuration;
    private readonly ILogger<AppleAuthService> _logger;
    private readonly ITokenService _tokenService;
    private readonly IDuplicateDetectionService _duplicateDetectionService;
    private readonly HttpClient _httpClient;

    // Apple's public keys endpoint
    private const string AppleKeysUrl = "https://appleid.apple.com/auth/keys";
    private const string AppleIssuer = "https://appleid.apple.com";

    public AppleAuthService(
        SilentIdDbContext context,
        IConfiguration configuration,
        ILogger<AppleAuthService> logger,
        ITokenService tokenService,
        IDuplicateDetectionService duplicateDetectionService,
        IHttpClientFactory httpClientFactory)
    {
        _context = context;
        _configuration = configuration;
        _logger = logger;
        _tokenService = tokenService;
        _duplicateDetectionService = duplicateDetectionService;
        _httpClient = httpClientFactory.CreateClient();
    }

    public async Task<AppleAuthResult> AuthenticateAsync(AppleSignInRequest request)
    {
        try
        {
            // Validate the Apple identity token
            var validationResult = await ValidateAppleTokenAsync(request.IdentityToken);
            if (!validationResult.IsValid)
            {
                _logger.LogWarning("Apple token validation failed: {Error}", validationResult.ErrorMessage);
                return new AppleAuthResult
                {
                    Success = false,
                    ErrorMessage = validationResult.ErrorMessage ?? "Invalid Apple identity token"
                };
            }

            var appleUserId = validationResult.AppleUserId!;
            var email = validationResult.Email;

            // Check if user already exists with this Apple ID
            var existingUser = await _context.Users
                .FirstOrDefaultAsync(u => u.AppleUserId == appleUserId);

            if (existingUser != null)
            {
                // Existing Apple user - log them in
                if (existingUser.AccountStatus != AccountStatus.Active)
                {
                    _logger.LogWarning("Apple sign-in failed: account suspended for user {UserId}", existingUser.Id);
                    return new AppleAuthResult
                    {
                        Success = false,
                        ErrorMessage = "Account is suspended"
                    };
                }

                _logger.LogInformation("Apple sign-in successful for existing user {UserId}", existingUser.Id);
                return await CreateSuccessResultAsync(existingUser, false);
            }

            // Check if user exists with same email (account unification)
            if (!string.IsNullOrEmpty(email))
            {
                var emailUser = await _context.Users
                    .FirstOrDefaultAsync(u => u.Email == email.ToLowerInvariant());

                if (emailUser != null)
                {
                    // Link Apple ID to existing email account
                    emailUser.AppleUserId = appleUserId;
                    emailUser.UpdatedAt = DateTime.UtcNow;
                    await _context.SaveChangesAsync();

                    _logger.LogInformation("Linked Apple account to existing user {UserId} via email match", emailUser.Id);
                    return await CreateSuccessResultAsync(emailUser, false);
                }
            }

            // Check for duplicate detection before creating new account
            if (!string.IsNullOrEmpty(request.DeviceId) || !string.IsNullOrEmpty(request.IpAddress))
            {
                var duplicateCheck = await _duplicateDetectionService.CheckForDuplicatesAsync(
                    email ?? $"apple_{appleUserId}@private.appleid.com",
                    request.DeviceId,
                    request.IpAddress);

                if (duplicateCheck.IsSuspicious)
                {
                    _logger.LogWarning("Duplicate account detected during Apple sign-up: {Reasons}", string.Join(", ", duplicateCheck.Reasons));
                    return new AppleAuthResult
                    {
                        Success = false,
                        ErrorMessage = "This device is already associated with a SilentID account. Please use your existing login method."
                    };
                }
            }

            // Create new user
            var newUser = new User
            {
                Email = email?.ToLowerInvariant() ?? $"apple_{appleUserId}@private.appleid.com",
                Username = await GenerateUniqueUsernameAsync(request.FirstName, request.LastName),
                DisplayName = GenerateDisplayName(request.FirstName, request.LastName),
                AppleUserId = appleUserId,
                IsEmailVerified = !string.IsNullOrEmpty(email), // Apple verifies emails
                AccountStatus = AccountStatus.Active,
                AccountType = AccountType.Free,
                SignupIP = request.IpAddress,
                SignupDeviceId = request.DeviceId,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.Users.Add(newUser);
            await _context.SaveChangesAsync();

            _logger.LogInformation("Created new user {UserId} via Apple sign-in", newUser.Id);
            return await CreateSuccessResultAsync(newUser, true);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during Apple authentication");
            return new AppleAuthResult
            {
                Success = false,
                ErrorMessage = "An error occurred during Apple sign-in"
            };
        }
    }

    public async Task<bool> LinkAppleAccountAsync(Guid userId, string identityToken)
    {
        try
        {
            var validationResult = await ValidateAppleTokenAsync(identityToken);
            if (!validationResult.IsValid)
            {
                _logger.LogWarning("Cannot link Apple account: token validation failed");
                return false;
            }

            var user = await _context.Users.FindAsync(userId);
            if (user == null)
            {
                return false;
            }

            // Check if Apple ID is already linked to another account
            var existingAppleUser = await _context.Users
                .FirstOrDefaultAsync(u => u.AppleUserId == validationResult.AppleUserId && u.Id != userId);

            if (existingAppleUser != null)
            {
                _logger.LogWarning("Apple ID already linked to another account");
                return false;
            }

            user.AppleUserId = validationResult.AppleUserId;
            user.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            _logger.LogInformation("Linked Apple account to user {UserId}", userId);
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error linking Apple account for user {UserId}", userId);
            return false;
        }
    }

    public async Task<bool> UnlinkAppleAccountAsync(Guid userId)
    {
        try
        {
            var user = await _context.Users.FindAsync(userId);
            if (user == null)
            {
                return false;
            }

            // Ensure user has another login method before unlinking
            var hasOtherLoginMethod = user.GoogleUserId != null ||
                                       user.IsEmailVerified ||
                                       user.IsPasskeyEnabled;

            if (!hasOtherLoginMethod)
            {
                _logger.LogWarning("Cannot unlink Apple account: no other login method available for user {UserId}", userId);
                return false;
            }

            user.AppleUserId = null;
            user.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            _logger.LogInformation("Unlinked Apple account from user {UserId}", userId);
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error unlinking Apple account for user {UserId}", userId);
            return false;
        }
    }

    // Private helper methods

    private async Task<AppleTokenValidationResult> ValidateAppleTokenAsync(string identityToken)
    {
        try
        {
            var handler = new JwtSecurityTokenHandler();

            // Get Apple's public keys
            var appleKeys = await GetApplePublicKeysAsync();
            if (appleKeys == null)
            {
                return new AppleTokenValidationResult
                {
                    IsValid = false,
                    ErrorMessage = "Could not retrieve Apple public keys"
                };
            }

            var validationParameters = new TokenValidationParameters
            {
                ValidateIssuer = true,
                ValidIssuer = AppleIssuer,
                ValidateAudience = true,
                ValidAudience = _configuration["OAuth:Apple:ClientId"] ?? "com.silentsale.silentid",
                ValidateLifetime = true,
                IssuerSigningKeys = appleKeys.Keys,
                ClockSkew = TimeSpan.FromMinutes(5)
            };

            var principal = handler.ValidateToken(identityToken, validationParameters, out var validatedToken);

            // Extract claims
            var appleUserId = principal.FindFirst(ClaimTypes.NameIdentifier)?.Value
                              ?? principal.FindFirst("sub")?.Value;

            var email = principal.FindFirst(ClaimTypes.Email)?.Value
                        ?? principal.FindFirst("email")?.Value;

            if (string.IsNullOrEmpty(appleUserId))
            {
                return new AppleTokenValidationResult
                {
                    IsValid = false,
                    ErrorMessage = "Apple user ID not found in token"
                };
            }

            return new AppleTokenValidationResult
            {
                IsValid = true,
                AppleUserId = appleUserId,
                Email = email
            };
        }
        catch (SecurityTokenException ex)
        {
            _logger.LogWarning(ex, "Apple token security validation failed");
            return new AppleTokenValidationResult
            {
                IsValid = false,
                ErrorMessage = "Token validation failed: " + ex.Message
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error validating Apple token");
            return new AppleTokenValidationResult
            {
                IsValid = false,
                ErrorMessage = "Token validation error"
            };
        }
    }

    private async Task<JsonWebKeySet?> GetApplePublicKeysAsync()
    {
        try
        {
            var response = await _httpClient.GetStringAsync(AppleKeysUrl);
            return new JsonWebKeySet(response);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to retrieve Apple public keys");
            return null;
        }
    }

    private async Task<AppleAuthResult> CreateSuccessResultAsync(User user, bool isNewUser)
    {
        var accessToken = _tokenService.GenerateAccessToken(user);
        var refreshToken = _tokenService.GenerateRefreshToken();
        var refreshTokenHash = _tokenService.HashRefreshToken(refreshToken);

        // Create session
        var session = new Session
        {
            UserId = user.Id,
            RefreshTokenHash = refreshTokenHash,
            ExpiresAt = DateTime.UtcNow.AddDays(7),
            CreatedAt = DateTime.UtcNow
        };

        _context.Sessions.Add(session);
        await _context.SaveChangesAsync();

        return new AppleAuthResult
        {
            Success = true,
            User = user,
            AccessToken = accessToken,
            RefreshToken = refreshToken,
            IsNewUser = isNewUser
        };
    }

    private async Task<string> GenerateUniqueUsernameAsync(string? firstName, string? lastName)
    {
        var baseUsername = GenerateBaseUsername(firstName, lastName);
        var username = baseUsername;
        var counter = 1;

        while (await _context.Users.AnyAsync(u => u.Username == username))
        {
            username = $"{baseUsername}{counter}";
            counter++;
        }

        return username;
    }

    private static string GenerateBaseUsername(string? firstName, string? lastName)
    {
        if (!string.IsNullOrEmpty(firstName))
        {
            var name = firstName.ToLowerInvariant().Replace(" ", "");
            if (!string.IsNullOrEmpty(lastName) && lastName.Length > 0)
            {
                name += lastName.Substring(0, 1).ToLowerInvariant();
            }
            return name;
        }

        // Generate random username if no name provided
        return $"user{Random.Shared.Next(10000, 99999)}";
    }

    private static string GenerateDisplayName(string? firstName, string? lastName)
    {
        if (!string.IsNullOrEmpty(firstName))
        {
            var display = firstName;
            if (!string.IsNullOrEmpty(lastName) && lastName.Length > 0)
            {
                display += $" {lastName.Substring(0, 1).ToUpperInvariant()}.";
            }
            return display;
        }

        return "SilentID User";
    }
}

// DTOs for Apple OAuth

public class AppleSignInRequest
{
    public string IdentityToken { get; set; } = string.Empty;
    public string? AuthorizationCode { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public string? DeviceId { get; set; }
    public string? IpAddress { get; set; }
}

public class AppleAuthResult
{
    public bool Success { get; set; }
    public User? User { get; set; }
    public string? AccessToken { get; set; }
    public string? RefreshToken { get; set; }
    public bool IsNewUser { get; set; }
    public string? ErrorMessage { get; set; }
}

public class AppleTokenValidationResult
{
    public bool IsValid { get; set; }
    public string? AppleUserId { get; set; }
    public string? Email { get; set; }
    public string? ErrorMessage { get; set; }
}
