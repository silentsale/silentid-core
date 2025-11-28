using System.Security.Cryptography;
using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;

namespace SilentID.Api.Services;

public interface IForwardingAliasService
{
    /// <summary>
    /// Gets or creates a unique receipt forwarding alias for a user.
    /// </summary>
    Task<string> GetOrCreateAliasAsync(Guid userId);

    /// <summary>
    /// Gets the full forwarding email address for a user.
    /// </summary>
    Task<string> GetForwardingEmailAsync(Guid userId);

    /// <summary>
    /// Resolves a forwarding alias to a user ID.
    /// </summary>
    Task<Guid?> ResolveAliasToUserIdAsync(string alias);

    /// <summary>
    /// Validates if an alias format is correct.
    /// </summary>
    bool IsValidAliasFormat(string alias);
}

/// <summary>
/// Service for managing unique email forwarding aliases for receipt collection.
/// Implements the Expensify-inspired model from Section 47.4.
/// </summary>
public class ForwardingAliasService : IForwardingAliasService
{
    private readonly SilentIdDbContext _context;
    private readonly ILogger<ForwardingAliasService> _logger;
    private readonly IConfiguration _configuration;

    // Domain for receipt forwarding emails
    private const string DefaultReceiptDomain = "receipts.silentid.co.uk";

    public ForwardingAliasService(
        SilentIdDbContext context,
        ILogger<ForwardingAliasService> logger,
        IConfiguration configuration)
    {
        _context = context;
        _logger = logger;
        _configuration = configuration;
    }

    /// <summary>
    /// Gets or creates a unique receipt forwarding alias for a user.
    /// Format: {shortId}.{randomString} (e.g., "ab12cd.x9kf3m")
    /// </summary>
    public async Task<string> GetOrCreateAliasAsync(Guid userId)
    {
        var user = await _context.Users.FindAsync(userId);
        if (user == null)
        {
            throw new InvalidOperationException("User not found");
        }

        // Return existing alias if already set
        if (!string.IsNullOrEmpty(user.ReceiptForwardingAlias))
        {
            return user.ReceiptForwardingAlias;
        }

        // Generate new unique alias
        var alias = await GenerateUniqueAliasAsync(userId);

        user.ReceiptForwardingAlias = alias;
        user.UpdatedAt = DateTime.UtcNow;
        await _context.SaveChangesAsync();

        _logger.LogInformation("Generated receipt forwarding alias for user {UserId}: {Alias}", userId, alias);

        return alias;
    }

    /// <summary>
    /// Gets the full forwarding email address for a user.
    /// </summary>
    public async Task<string> GetForwardingEmailAsync(Guid userId)
    {
        var alias = await GetOrCreateAliasAsync(userId);
        var domain = _configuration["Email:ReceiptDomain"] ?? DefaultReceiptDomain;
        return $"{alias}@{domain}";
    }

    /// <summary>
    /// Resolves a forwarding alias (or full email) to a user ID.
    /// </summary>
    public async Task<Guid?> ResolveAliasToUserIdAsync(string aliasOrEmail)
    {
        // Extract alias from email if full email provided
        var alias = aliasOrEmail.Contains('@')
            ? aliasOrEmail.Split('@')[0]
            : aliasOrEmail;

        if (!IsValidAliasFormat(alias))
        {
            _logger.LogWarning("Invalid alias format: {Alias}", alias);
            return null;
        }

        var user = await _context.Users
            .Where(u => u.ReceiptForwardingAlias == alias)
            .Select(u => new { u.Id })
            .FirstOrDefaultAsync();

        return user?.Id;
    }

    /// <summary>
    /// Validates if an alias format is correct.
    /// Expected format: {6chars}.{6chars} (lowercase alphanumeric)
    /// </summary>
    public bool IsValidAliasFormat(string alias)
    {
        if (string.IsNullOrEmpty(alias)) return false;

        var parts = alias.Split('.');
        if (parts.Length != 2) return false;

        // Each part should be 6 lowercase alphanumeric characters
        return parts[0].Length == 6 &&
               parts[1].Length == 6 &&
               parts[0].All(c => char.IsLetterOrDigit(c) && char.IsLower(c)) &&
               parts[1].All(c => char.IsLetterOrDigit(c) && char.IsLower(c));
    }

    /// <summary>
    /// Generates a unique alias that doesn't exist in the database.
    /// </summary>
    private async Task<string> GenerateUniqueAliasAsync(Guid userId)
    {
        const int maxAttempts = 10;

        for (int i = 0; i < maxAttempts; i++)
        {
            // Generate alias: first part from userId, second part random
            var shortId = GenerateShortId(userId);
            var randomPart = GenerateRandomString(6);
            var alias = $"{shortId}.{randomPart}";

            // Check uniqueness
            var exists = await _context.Users
                .AnyAsync(u => u.ReceiptForwardingAlias == alias);

            if (!exists)
            {
                return alias;
            }

            _logger.LogDebug("Alias collision detected, regenerating: {Alias}", alias);
        }

        throw new InvalidOperationException("Failed to generate unique alias after maximum attempts");
    }

    /// <summary>
    /// Generates a 6-character short ID from the user's GUID.
    /// </summary>
    private static string GenerateShortId(Guid userId)
    {
        // Use first 6 characters of base64-encoded GUID bytes
        var bytes = userId.ToByteArray();
        var base64 = Convert.ToBase64String(bytes)
            .Replace("+", "")
            .Replace("/", "")
            .Replace("=", "")
            .ToLowerInvariant();

        return base64[..6];
    }

    /// <summary>
    /// Generates a cryptographically secure random string.
    /// </summary>
    private static string GenerateRandomString(int length)
    {
        const string chars = "abcdefghijklmnopqrstuvwxyz0123456789";
        var bytes = RandomNumberGenerator.GetBytes(length);
        var result = new char[length];

        for (int i = 0; i < length; i++)
        {
            result[i] = chars[bytes[i] % chars.Length];
        }

        return new string(result);
    }
}
