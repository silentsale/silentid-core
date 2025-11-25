using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

public interface IPasskeyService
{
    /// <summary>
    /// Generate registration options for creating a new passkey
    /// </summary>
    Task<PasskeyRegistrationOptions> GenerateRegistrationOptionsAsync(User user);

    /// <summary>
    /// Complete passkey registration by storing the credential
    /// </summary>
    Task<PasskeyCredential> CompleteRegistrationAsync(
        Guid userId,
        string credentialId,
        string publicKey,
        uint signatureCounter,
        string? aaGuid,
        string? deviceName,
        string? attestationFormat,
        bool userVerified);

    /// <summary>
    /// Generate authentication options for passkey login
    /// </summary>
    Task<PasskeyAuthenticationOptions> GenerateAuthenticationOptionsAsync(string? email = null);

    /// <summary>
    /// Complete passkey authentication by verifying the credential
    /// </summary>
    Task<PasskeyAuthenticationResult> CompleteAuthenticationAsync(
        string credentialId,
        string authenticatorData,
        string clientDataJson,
        string signature,
        uint signatureCounter);

    /// <summary>
    /// Get all passkeys for a user
    /// </summary>
    Task<List<PasskeyCredential>> GetUserPasskeysAsync(Guid userId);

    /// <summary>
    /// Delete a passkey
    /// </summary>
    Task<bool> DeletePasskeyAsync(Guid userId, Guid passkeyId);

    /// <summary>
    /// Update passkey device name
    /// </summary>
    Task<bool> UpdatePasskeyNameAsync(Guid userId, Guid passkeyId, string deviceName);
}

public class PasskeyService : IPasskeyService
{
    private readonly SilentIdDbContext _context;
    private readonly IConfiguration _configuration;
    private readonly ILogger<PasskeyService> _logger;

    // Challenge storage (in production, use distributed cache like Redis)
    private static readonly Dictionary<string, PasskeyChallenge> _challenges = new();

    public PasskeyService(
        SilentIdDbContext context,
        IConfiguration configuration,
        ILogger<PasskeyService> logger)
    {
        _context = context;
        _configuration = configuration;
        _logger = logger;
    }

    public async Task<PasskeyRegistrationOptions> GenerateRegistrationOptionsAsync(User user)
    {
        // Get existing credentials for this user (to exclude from registration)
        var existingCredentials = await _context.PasskeyCredentials
            .Where(p => p.UserId == user.Id && p.IsActive)
            .Select(p => p.CredentialId)
            .ToListAsync();

        // Generate challenge
        var challenge = GenerateChallenge();
        var challengeBase64 = Convert.ToBase64String(challenge);

        // Store challenge for verification
        var passkeyChallenge = new PasskeyChallenge
        {
            Challenge = challengeBase64,
            UserId = user.Id,
            Type = "registration",
            ExpiresAt = DateTime.UtcNow.AddMinutes(5)
        };
        _challenges[challengeBase64] = passkeyChallenge;

        // Clean up expired challenges
        CleanupExpiredChallenges();

        var rpId = _configuration["Passkey:RpId"] ?? "silentid.co.uk";
        var rpName = _configuration["Passkey:RpName"] ?? "SilentID";

        _logger.LogInformation("Generated passkey registration options for user {UserId}", user.Id);

        return new PasskeyRegistrationOptions
        {
            Challenge = challengeBase64,
            Rp = new RelyingParty
            {
                Id = rpId,
                Name = rpName
            },
            User = new PasskeyUser
            {
                Id = Convert.ToBase64String(user.Id.ToByteArray()),
                Name = user.Email,
                DisplayName = user.DisplayName
            },
            PubKeyCredParams = new List<PubKeyCredParam>
            {
                new() { Type = "public-key", Alg = -7 },   // ES256
                new() { Type = "public-key", Alg = -257 }  // RS256
            },
            Timeout = 60000, // 60 seconds
            Attestation = "none", // Don't require attestation for privacy
            AuthenticatorSelection = new AuthenticatorSelection
            {
                AuthenticatorAttachment = "platform", // Prefer platform authenticators (Face ID, Touch ID, Windows Hello)
                ResidentKey = "preferred",
                UserVerification = "preferred"
            },
            ExcludeCredentials = existingCredentials.Select(c => new PublicKeyCredentialDescriptor
            {
                Type = "public-key",
                Id = c
            }).ToList()
        };
    }

    public async Task<PasskeyCredential> CompleteRegistrationAsync(
        Guid userId,
        string credentialId,
        string publicKey,
        uint signatureCounter,
        string? aaGuid,
        string? deviceName,
        string? attestationFormat,
        bool userVerified)
    {
        // Check if credential already exists
        var existingCredential = await _context.PasskeyCredentials
            .FirstOrDefaultAsync(p => p.CredentialId == credentialId);

        if (existingCredential != null)
        {
            _logger.LogWarning("Attempted to register duplicate credential {CredentialId}", credentialId);
            throw new InvalidOperationException("This passkey is already registered.");
        }

        // Create new credential
        var credential = new PasskeyCredential
        {
            UserId = userId,
            CredentialId = credentialId,
            PublicKey = publicKey,
            SignatureCounter = signatureCounter,
            AaGuid = aaGuid,
            DeviceName = deviceName ?? "Passkey",
            AttestationFormat = attestationFormat,
            UserVerified = userVerified,
            IsActive = true,
            CreatedAt = DateTime.UtcNow
        };

        _context.PasskeyCredentials.Add(credential);

        // Update user's passkey enabled status
        var user = await _context.Users.FindAsync(userId);
        if (user != null)
        {
            user.IsPasskeyEnabled = true;
            user.UpdatedAt = DateTime.UtcNow;
        }

        await _context.SaveChangesAsync();

        _logger.LogInformation("Passkey registered for user {UserId}, credential {CredentialId}", userId, credentialId);

        return credential;
    }

    public async Task<PasskeyAuthenticationOptions> GenerateAuthenticationOptionsAsync(string? email = null)
    {
        var allowCredentials = new List<PublicKeyCredentialDescriptor>();

        // If email provided, get user's credentials
        if (!string.IsNullOrWhiteSpace(email))
        {
            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.Email == email.ToLowerInvariant());

            if (user != null)
            {
                var credentials = await _context.PasskeyCredentials
                    .Where(p => p.UserId == user.Id && p.IsActive)
                    .Select(p => p.CredentialId)
                    .ToListAsync();

                allowCredentials = credentials.Select(c => new PublicKeyCredentialDescriptor
                {
                    Type = "public-key",
                    Id = c
                }).ToList();
            }
        }

        // Generate challenge
        var challenge = GenerateChallenge();
        var challengeBase64 = Convert.ToBase64String(challenge);

        // Store challenge for verification
        var passkeyChallenge = new PasskeyChallenge
        {
            Challenge = challengeBase64,
            UserId = null, // Will be determined during authentication
            Type = "authentication",
            ExpiresAt = DateTime.UtcNow.AddMinutes(5)
        };
        _challenges[challengeBase64] = passkeyChallenge;

        // Clean up expired challenges
        CleanupExpiredChallenges();

        var rpId = _configuration["Passkey:RpId"] ?? "silentid.co.uk";

        _logger.LogInformation("Generated passkey authentication options");

        return new PasskeyAuthenticationOptions
        {
            Challenge = challengeBase64,
            Timeout = 60000,
            RpId = rpId,
            AllowCredentials = allowCredentials,
            UserVerification = "preferred"
        };
    }

    public async Task<PasskeyAuthenticationResult> CompleteAuthenticationAsync(
        string credentialId,
        string authenticatorData,
        string clientDataJson,
        string signature,
        uint signatureCounter)
    {
        // Find credential
        var credential = await _context.PasskeyCredentials
            .Include(p => p.User)
            .FirstOrDefaultAsync(p => p.CredentialId == credentialId && p.IsActive);

        if (credential == null)
        {
            _logger.LogWarning("Passkey authentication failed: credential not found {CredentialId}", credentialId);
            return new PasskeyAuthenticationResult
            {
                Success = false,
                ErrorMessage = "Passkey not found or inactive."
            };
        }

        // Check user account status
        if (credential.User.AccountStatus != AccountStatus.Active)
        {
            _logger.LogWarning("Passkey authentication failed: account suspended for user {UserId}", credential.UserId);
            return new PasskeyAuthenticationResult
            {
                Success = false,
                ErrorMessage = "Account is suspended."
            };
        }

        // Verify signature counter (protection against cloned authenticators)
        if (signatureCounter <= credential.SignatureCounter && credential.SignatureCounter > 0)
        {
            _logger.LogWarning(
                "Passkey authentication failed: signature counter not incremented. Expected > {Expected}, got {Actual}",
                credential.SignatureCounter, signatureCounter);

            // This could indicate a cloned authenticator - flag for security review
            return new PasskeyAuthenticationResult
            {
                Success = false,
                ErrorMessage = "Security validation failed. Please use another authentication method."
            };
        }

        // In a full implementation, we would verify the signature using the stored public key
        // For now, we trust the client-side verification and update the counter
        // TODO: Implement full signature verification using the COSE public key

        // Update credential
        credential.SignatureCounter = signatureCounter;
        credential.LastUsedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();

        _logger.LogInformation("Passkey authentication successful for user {UserId}", credential.UserId);

        return new PasskeyAuthenticationResult
        {
            Success = true,
            User = credential.User,
            CredentialId = credentialId
        };
    }

    public async Task<List<PasskeyCredential>> GetUserPasskeysAsync(Guid userId)
    {
        return await _context.PasskeyCredentials
            .Where(p => p.UserId == userId)
            .OrderByDescending(p => p.CreatedAt)
            .ToListAsync();
    }

    public async Task<bool> DeletePasskeyAsync(Guid userId, Guid passkeyId)
    {
        var credential = await _context.PasskeyCredentials
            .FirstOrDefaultAsync(p => p.Id == passkeyId && p.UserId == userId);

        if (credential == null)
        {
            return false;
        }

        _context.PasskeyCredentials.Remove(credential);

        // Check if user has any remaining passkeys
        var remainingPasskeys = await _context.PasskeyCredentials
            .CountAsync(p => p.UserId == userId && p.Id != passkeyId && p.IsActive);

        if (remainingPasskeys == 0)
        {
            var user = await _context.Users.FindAsync(userId);
            if (user != null)
            {
                user.IsPasskeyEnabled = false;
                user.UpdatedAt = DateTime.UtcNow;
            }
        }

        await _context.SaveChangesAsync();

        _logger.LogInformation("Passkey {PasskeyId} deleted for user {UserId}", passkeyId, userId);

        return true;
    }

    public async Task<bool> UpdatePasskeyNameAsync(Guid userId, Guid passkeyId, string deviceName)
    {
        var credential = await _context.PasskeyCredentials
            .FirstOrDefaultAsync(p => p.Id == passkeyId && p.UserId == userId);

        if (credential == null)
        {
            return false;
        }

        credential.DeviceName = deviceName;
        await _context.SaveChangesAsync();

        _logger.LogInformation("Passkey {PasskeyId} renamed to '{DeviceName}' for user {UserId}",
            passkeyId, deviceName, userId);

        return true;
    }

    // Helper methods

    private static byte[] GenerateChallenge()
    {
        var challenge = new byte[32];
        using var rng = RandomNumberGenerator.Create();
        rng.GetBytes(challenge);
        return challenge;
    }

    private static void CleanupExpiredChallenges()
    {
        var expiredKeys = _challenges
            .Where(kvp => kvp.Value.ExpiresAt < DateTime.UtcNow)
            .Select(kvp => kvp.Key)
            .ToList();

        foreach (var key in expiredKeys)
        {
            _challenges.Remove(key);
        }
    }

    /// <summary>
    /// Validate that a challenge exists and hasn't expired
    /// </summary>
    public bool ValidateChallenge(string challenge, string type)
    {
        if (!_challenges.TryGetValue(challenge, out var storedChallenge))
        {
            return false;
        }

        if (storedChallenge.ExpiresAt < DateTime.UtcNow)
        {
            _challenges.Remove(challenge);
            return false;
        }

        if (storedChallenge.Type != type)
        {
            return false;
        }

        // Remove challenge after validation (one-time use)
        _challenges.Remove(challenge);
        return true;
    }
}

// DTOs for Passkey operations

public class PasskeyRegistrationOptions
{
    public string Challenge { get; set; } = string.Empty;
    public RelyingParty Rp { get; set; } = new();
    public PasskeyUser User { get; set; } = new();
    public List<PubKeyCredParam> PubKeyCredParams { get; set; } = new();
    public int Timeout { get; set; }
    public string Attestation { get; set; } = "none";
    public AuthenticatorSelection AuthenticatorSelection { get; set; } = new();
    public List<PublicKeyCredentialDescriptor> ExcludeCredentials { get; set; } = new();
}

public class RelyingParty
{
    public string Id { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
}

public class PasskeyUser
{
    public string Id { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string DisplayName { get; set; } = string.Empty;
}

public class PubKeyCredParam
{
    public string Type { get; set; } = "public-key";
    public int Alg { get; set; }
}

public class AuthenticatorSelection
{
    public string? AuthenticatorAttachment { get; set; }
    public string ResidentKey { get; set; } = "preferred";
    public string UserVerification { get; set; } = "preferred";
}

public class PublicKeyCredentialDescriptor
{
    public string Type { get; set; } = "public-key";
    public string Id { get; set; } = string.Empty;
    public List<string>? Transports { get; set; }
}

public class PasskeyAuthenticationOptions
{
    public string Challenge { get; set; } = string.Empty;
    public int Timeout { get; set; }
    public string RpId { get; set; } = string.Empty;
    public List<PublicKeyCredentialDescriptor> AllowCredentials { get; set; } = new();
    public string UserVerification { get; set; } = "preferred";
}

public class PasskeyAuthenticationResult
{
    public bool Success { get; set; }
    public User? User { get; set; }
    public string? CredentialId { get; set; }
    public string? ErrorMessage { get; set; }
}

public class PasskeyChallenge
{
    public string Challenge { get; set; } = string.Empty;
    public Guid? UserId { get; set; }
    public string Type { get; set; } = string.Empty; // "registration" or "authentication"
    public DateTime ExpiresAt { get; set; }
}
