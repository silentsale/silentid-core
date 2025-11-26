using System.Formats.Cbor;
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

        // Verify the signature using the stored COSE public key
        try
        {
            var isValidSignature = VerifyWebAuthnSignature(
                credential.PublicKey,
                authenticatorData,
                clientDataJson,
                signature);

            if (!isValidSignature)
            {
                _logger.LogWarning("Passkey authentication failed: invalid signature for credential {CredentialId}", credentialId);
                return new PasskeyAuthenticationResult
                {
                    Success = false,
                    ErrorMessage = "Signature verification failed."
                };
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error verifying passkey signature for credential {CredentialId}", credentialId);
            return new PasskeyAuthenticationResult
            {
                Success = false,
                ErrorMessage = "Signature verification error."
            };
        }

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

    /// <summary>
    /// Verify WebAuthn assertion signature using the stored COSE public key
    /// </summary>
    private bool VerifyWebAuthnSignature(
        string publicKeyBase64,
        string authenticatorDataBase64,
        string clientDataJsonBase64,
        string signatureBase64)
    {
        // Decode inputs from base64
        var authenticatorData = Convert.FromBase64String(authenticatorDataBase64);
        var clientDataJson = Convert.FromBase64String(clientDataJsonBase64);
        var signature = Convert.FromBase64String(signatureBase64);
        var publicKeyBytes = Convert.FromBase64String(publicKeyBase64);

        // Compute hash of clientDataJSON
        var clientDataHash = SHA256.HashData(clientDataJson);

        // Concatenate authenticatorData + clientDataHash to form signed data
        var signedData = new byte[authenticatorData.Length + clientDataHash.Length];
        authenticatorData.CopyTo(signedData, 0);
        clientDataHash.CopyTo(signedData, authenticatorData.Length);

        // Parse COSE public key and verify signature
        var coseKey = ParseCoseKey(publicKeyBytes);

        return coseKey.KeyType switch
        {
            CoseKeyType.EC2 => VerifyEC2Signature(coseKey, signedData, signature),
            CoseKeyType.RSA => VerifyRSASignature(coseKey, signedData, signature),
            _ => throw new NotSupportedException($"Unsupported COSE key type: {coseKey.KeyType}")
        };
    }

    /// <summary>
    /// Parse a COSE-encoded public key
    /// </summary>
    private static CosePublicKey ParseCoseKey(byte[] coseKeyBytes)
    {
        var reader = new CborReader(coseKeyBytes);
        var result = new CosePublicKey();

        reader.ReadStartMap();

        while (reader.PeekState() != CborReaderState.EndMap)
        {
            var label = reader.ReadInt32();

            switch (label)
            {
                case 1: // kty (key type)
                    result.KeyType = (CoseKeyType)reader.ReadInt32();
                    break;
                case 3: // alg (algorithm)
                    result.Algorithm = reader.ReadInt32();
                    break;
                case -1: // crv (curve) for EC2, n (modulus) for RSA
                    if (reader.PeekState() == CborReaderState.NegativeInteger ||
                        reader.PeekState() == CborReaderState.UnsignedInteger)
                    {
                        result.Curve = reader.ReadInt32();
                    }
                    else
                    {
                        result.N = reader.ReadByteString();
                    }
                    break;
                case -2: // x (x-coordinate) for EC2, e (exponent) for RSA
                    result.X = reader.ReadByteString();
                    break;
                case -3: // y (y-coordinate) for EC2
                    result.Y = reader.ReadByteString();
                    break;
                default:
                    reader.SkipValue();
                    break;
            }
        }

        reader.ReadEndMap();
        return result;
    }

    /// <summary>
    /// Verify ECDSA signature (ES256, ES384, ES512)
    /// </summary>
    private static bool VerifyEC2Signature(CosePublicKey coseKey, byte[] data, byte[] signature)
    {
        if (coseKey.X == null || coseKey.Y == null)
        {
            throw new InvalidOperationException("EC2 key missing X or Y coordinate");
        }

        // Determine curve based on algorithm or curve parameter
        var curve = coseKey.Algorithm switch
        {
            -7 => ECCurve.NamedCurves.nistP256,   // ES256
            -35 => ECCurve.NamedCurves.nistP384,  // ES384
            -36 => ECCurve.NamedCurves.nistP521,  // ES512
            _ => coseKey.Curve switch
            {
                1 => ECCurve.NamedCurves.nistP256,
                2 => ECCurve.NamedCurves.nistP384,
                3 => ECCurve.NamedCurves.nistP521,
                _ => ECCurve.NamedCurves.nistP256 // Default to P-256
            }
        };

        var hashAlgorithm = coseKey.Algorithm switch
        {
            -7 => HashAlgorithmName.SHA256,
            -35 => HashAlgorithmName.SHA384,
            -36 => HashAlgorithmName.SHA512,
            _ => HashAlgorithmName.SHA256
        };

        // Create EC parameters
        var ecParameters = new ECParameters
        {
            Curve = curve,
            Q = new ECPoint
            {
                X = coseKey.X,
                Y = coseKey.Y
            }
        };

        using var ecdsa = ECDsa.Create(ecParameters);

        // WebAuthn signatures are in IEEE P1363 format (r || s concatenated)
        // .NET's VerifyData expects the same format
        return ecdsa.VerifyData(data, signature, hashAlgorithm);
    }

    /// <summary>
    /// Verify RSA signature (RS256, RS384, RS512)
    /// </summary>
    private static bool VerifyRSASignature(CosePublicKey coseKey, byte[] data, byte[] signature)
    {
        if (coseKey.N == null || coseKey.X == null)
        {
            throw new InvalidOperationException("RSA key missing N (modulus) or E (exponent)");
        }

        var hashAlgorithm = coseKey.Algorithm switch
        {
            -257 => HashAlgorithmName.SHA256, // RS256
            -258 => HashAlgorithmName.SHA384, // RS384
            -259 => HashAlgorithmName.SHA512, // RS512
            _ => HashAlgorithmName.SHA256
        };

        var rsaParameters = new RSAParameters
        {
            Modulus = coseKey.N,
            Exponent = coseKey.X // In COSE RSA, -2 is the exponent (stored in X for simplicity)
        };

        using var rsa = RSA.Create(rsaParameters);
        return rsa.VerifyData(data, signature, hashAlgorithm, RSASignaturePadding.Pkcs1);
    }
}

/// <summary>
/// COSE key types
/// </summary>
public enum CoseKeyType
{
    OKP = 1,   // Octet Key Pair (EdDSA)
    EC2 = 2,   // Elliptic Curve (ECDSA)
    RSA = 3    // RSA
}

/// <summary>
/// Parsed COSE public key
/// </summary>
public class CosePublicKey
{
    public CoseKeyType KeyType { get; set; }
    public int Algorithm { get; set; }
    public int Curve { get; set; }
    public byte[]? X { get; set; }  // EC x-coordinate or RSA exponent
    public byte[]? Y { get; set; }  // EC y-coordinate
    public byte[]? N { get; set; }  // RSA modulus
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
