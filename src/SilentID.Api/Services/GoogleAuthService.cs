using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

public interface IGoogleAuthService
{
    /// <summary>
    /// Validate Google identity token and authenticate/register user
    /// </summary>
    Task<GoogleAuthResult> AuthenticateAsync(GoogleSignInRequest request);

    /// <summary>
    /// Link Google account to existing user
    /// </summary>
    Task<bool> LinkGoogleAccountAsync(Guid userId, string idToken);

    /// <summary>
    /// Unlink Google account from user
    /// </summary>
    Task<bool> UnlinkGoogleAccountAsync(Guid userId);
}

public class GoogleAuthService : IGoogleAuthService
{
    private readonly SilentIdDbContext _context;
    private readonly IConfiguration _configuration;
    private readonly ILogger<GoogleAuthService> _logger;
    private readonly ITokenService _tokenService;
    private readonly IDuplicateDetectionService _duplicateDetectionService;
    private readonly HttpClient _httpClient;

    // Google's token info endpoint
    private const string GoogleTokenInfoUrl = "https://oauth2.googleapis.com/tokeninfo";

    public GoogleAuthService(
        SilentIdDbContext context,
        IConfiguration configuration,
        ILogger<GoogleAuthService> logger,
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

    public async Task<GoogleAuthResult> AuthenticateAsync(GoogleSignInRequest request)
    {
        try
        {
            // Validate the Google ID token
            var validationResult = await ValidateGoogleTokenAsync(request.IdToken);
            if (!validationResult.IsValid)
            {
                _logger.LogWarning("Google token validation failed: {Error}", validationResult.ErrorMessage);
                return new GoogleAuthResult
                {
                    Success = false,
                    ErrorMessage = validationResult.ErrorMessage ?? "Invalid Google ID token"
                };
            }

            var googleUserId = validationResult.GoogleUserId!;
            var email = validationResult.Email;

            // Check if user already exists with this Google ID
            var existingUser = await _context.Users
                .FirstOrDefaultAsync(u => u.GoogleUserId == googleUserId);

            if (existingUser != null)
            {
                // Existing Google user - log them in
                if (existingUser.AccountStatus != AccountStatus.Active)
                {
                    _logger.LogWarning("Google sign-in failed: account suspended for user {UserId}", existingUser.Id);
                    return new GoogleAuthResult
                    {
                        Success = false,
                        ErrorMessage = "Account is suspended"
                    };
                }

                _logger.LogInformation("Google sign-in successful for existing user {UserId}", existingUser.Id);
                return await CreateSuccessResultAsync(existingUser, false);
            }

            // Check if user exists with same email (account unification)
            if (!string.IsNullOrEmpty(email))
            {
                var emailUser = await _context.Users
                    .FirstOrDefaultAsync(u => u.Email == email.ToLowerInvariant());

                if (emailUser != null)
                {
                    // Link Google ID to existing email account
                    emailUser.GoogleUserId = googleUserId;
                    emailUser.UpdatedAt = DateTime.UtcNow;

                    // Google emails are verified
                    if (validationResult.EmailVerified && !emailUser.IsEmailVerified)
                    {
                        emailUser.IsEmailVerified = true;
                    }

                    await _context.SaveChangesAsync();

                    _logger.LogInformation("Linked Google account to existing user {UserId} via email match", emailUser.Id);
                    return await CreateSuccessResultAsync(emailUser, false);
                }
            }

            // Check for duplicate detection before creating new account
            if (!string.IsNullOrEmpty(request.DeviceId) || !string.IsNullOrEmpty(request.IpAddress))
            {
                var duplicateCheck = await _duplicateDetectionService.CheckForDuplicatesAsync(
                    email ?? $"google_{googleUserId}@google.com",
                    request.DeviceId,
                    request.IpAddress);

                if (duplicateCheck.IsSuspicious)
                {
                    _logger.LogWarning("Duplicate account detected during Google sign-up: {Reasons}", string.Join(", ", duplicateCheck.Reasons));
                    return new GoogleAuthResult
                    {
                        Success = false,
                        ErrorMessage = "This device is already associated with a SilentID account. Please use your existing login method."
                    };
                }
            }

            // Create new user
            var newUser = new User
            {
                Email = email?.ToLowerInvariant() ?? $"google_{googleUserId}@google.com",
                Username = await GenerateUniqueUsernameAsync(validationResult.GivenName, validationResult.FamilyName),
                DisplayName = GenerateDisplayName(validationResult.GivenName, validationResult.FamilyName),
                GoogleUserId = googleUserId,
                IsEmailVerified = validationResult.EmailVerified, // Google verifies emails
                AccountStatus = AccountStatus.Active,
                AccountType = AccountType.Free,
                SignupIP = request.IpAddress,
                SignupDeviceId = request.DeviceId,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.Users.Add(newUser);
            await _context.SaveChangesAsync();

            _logger.LogInformation("Created new user {UserId} via Google sign-in", newUser.Id);
            return await CreateSuccessResultAsync(newUser, true);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during Google authentication");
            return new GoogleAuthResult
            {
                Success = false,
                ErrorMessage = "An error occurred during Google sign-in"
            };
        }
    }

    public async Task<bool> LinkGoogleAccountAsync(Guid userId, string idToken)
    {
        try
        {
            var validationResult = await ValidateGoogleTokenAsync(idToken);
            if (!validationResult.IsValid)
            {
                _logger.LogWarning("Cannot link Google account: token validation failed");
                return false;
            }

            var user = await _context.Users.FindAsync(userId);
            if (user == null)
            {
                return false;
            }

            // Check if Google ID is already linked to another account
            var existingGoogleUser = await _context.Users
                .FirstOrDefaultAsync(u => u.GoogleUserId == validationResult.GoogleUserId && u.Id != userId);

            if (existingGoogleUser != null)
            {
                _logger.LogWarning("Google ID already linked to another account");
                return false;
            }

            user.GoogleUserId = validationResult.GoogleUserId;
            user.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            _logger.LogInformation("Linked Google account to user {UserId}", userId);
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error linking Google account for user {UserId}", userId);
            return false;
        }
    }

    public async Task<bool> UnlinkGoogleAccountAsync(Guid userId)
    {
        try
        {
            var user = await _context.Users.FindAsync(userId);
            if (user == null)
            {
                return false;
            }

            // Ensure user has another login method before unlinking
            var hasOtherLoginMethod = user.AppleUserId != null ||
                                       user.IsEmailVerified ||
                                       user.IsPasskeyEnabled;

            if (!hasOtherLoginMethod)
            {
                _logger.LogWarning("Cannot unlink Google account: no other login method available for user {UserId}", userId);
                return false;
            }

            user.GoogleUserId = null;
            user.UpdatedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();

            _logger.LogInformation("Unlinked Google account from user {UserId}", userId);
            return true;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error unlinking Google account for user {UserId}", userId);
            return false;
        }
    }

    // Private helper methods

    private async Task<GoogleTokenValidationResult> ValidateGoogleTokenAsync(string idToken)
    {
        try
        {
            // Validate token using Google's tokeninfo endpoint
            var response = await _httpClient.GetAsync($"{GoogleTokenInfoUrl}?id_token={idToken}");

            if (!response.IsSuccessStatusCode)
            {
                return new GoogleTokenValidationResult
                {
                    IsValid = false,
                    ErrorMessage = "Invalid or expired Google token"
                };
            }

            var content = await response.Content.ReadAsStringAsync();
            var tokenInfo = JsonSerializer.Deserialize<GoogleTokenInfo>(content, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });

            if (tokenInfo == null)
            {
                return new GoogleTokenValidationResult
                {
                    IsValid = false,
                    ErrorMessage = "Could not parse Google token response"
                };
            }

            // Verify the audience (client ID) matches our app
            var expectedClientId = _configuration["OAuth:Google:ClientId"];
            if (!string.IsNullOrEmpty(expectedClientId) && tokenInfo.Aud != expectedClientId)
            {
                _logger.LogWarning("Google token audience mismatch. Expected: {Expected}, Got: {Actual}",
                    expectedClientId, tokenInfo.Aud);
                return new GoogleTokenValidationResult
                {
                    IsValid = false,
                    ErrorMessage = "Token was not issued for this application"
                };
            }

            // Verify token is not expired
            if (tokenInfo.Exp.HasValue)
            {
                var expiryTime = DateTimeOffset.FromUnixTimeSeconds(tokenInfo.Exp.Value);
                if (expiryTime < DateTimeOffset.UtcNow)
                {
                    return new GoogleTokenValidationResult
                    {
                        IsValid = false,
                        ErrorMessage = "Google token has expired"
                    };
                }
            }

            // Extract user info
            var googleUserId = tokenInfo.Sub;
            if (string.IsNullOrEmpty(googleUserId))
            {
                return new GoogleTokenValidationResult
                {
                    IsValid = false,
                    ErrorMessage = "Google user ID not found in token"
                };
            }

            return new GoogleTokenValidationResult
            {
                IsValid = true,
                GoogleUserId = googleUserId,
                Email = tokenInfo.Email,
                EmailVerified = tokenInfo.Email_Verified == "true",
                GivenName = tokenInfo.Given_Name,
                FamilyName = tokenInfo.Family_Name,
                Picture = tokenInfo.Picture
            };
        }
        catch (HttpRequestException ex)
        {
            _logger.LogError(ex, "Failed to reach Google token validation endpoint");
            return new GoogleTokenValidationResult
            {
                IsValid = false,
                ErrorMessage = "Could not validate Google token"
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error validating Google token");
            return new GoogleTokenValidationResult
            {
                IsValid = false,
                ErrorMessage = "Token validation error"
            };
        }
    }

    private async Task<GoogleAuthResult> CreateSuccessResultAsync(User user, bool isNewUser)
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

        return new GoogleAuthResult
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

// DTOs for Google OAuth

public class GoogleSignInRequest
{
    public string IdToken { get; set; } = string.Empty;
    public string? DeviceId { get; set; }
    public string? IpAddress { get; set; }
}

public class GoogleAuthResult
{
    public bool Success { get; set; }
    public User? User { get; set; }
    public string? AccessToken { get; set; }
    public string? RefreshToken { get; set; }
    public bool IsNewUser { get; set; }
    public string? ErrorMessage { get; set; }
}

public class GoogleTokenValidationResult
{
    public bool IsValid { get; set; }
    public string? GoogleUserId { get; set; }
    public string? Email { get; set; }
    public bool EmailVerified { get; set; }
    public string? GivenName { get; set; }
    public string? FamilyName { get; set; }
    public string? Picture { get; set; }
    public string? ErrorMessage { get; set; }
}

// Internal DTO for Google tokeninfo response
internal class GoogleTokenInfo
{
    public string? Iss { get; set; }
    public string? Azp { get; set; }
    public string? Aud { get; set; }
    public string? Sub { get; set; }
    public string? Email { get; set; }
    public string? Email_Verified { get; set; }
    public string? At_Hash { get; set; }
    public string? Name { get; set; }
    public string? Picture { get; set; }
    public string? Given_Name { get; set; }
    public string? Family_Name { get; set; }
    public string? Locale { get; set; }
    public long? Iat { get; set; }
    public long? Exp { get; set; }
}
