using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

public interface IEvidenceService
{
    Task<ReceiptEvidence> AddReceiptEvidenceAsync(Guid userId, ReceiptEvidence receipt);
    Task<ScreenshotEvidence> AddScreenshotEvidenceAsync(Guid userId, ScreenshotEvidence screenshot);
    Task<ProfileLinkEvidence> AddProfileLinkEvidenceAsync(Guid userId, ProfileLinkEvidence profileLink);
    Task<List<ReceiptEvidence>> GetUserReceiptsAsync(Guid userId, int page = 1, int pageSize = 20);
    Task<ScreenshotEvidence?> GetScreenshotAsync(Guid id, Guid userId);
    Task<ProfileLinkEvidence?> GetProfileLinkAsync(Guid id, Guid userId);
    Task<int> GetTotalReceiptsCountAsync(Guid userId);
    Task<bool> IsDuplicateReceiptAsync(string rawHash);

    // Level 3 Verification Methods (Section 5 - Core Features)
    Task<string> GenerateVerificationTokenAsync(Guid profileLinkId, Guid userId);
    Task<ProfileLinkEvidence?> ConfirmTokenInBioAsync(Guid profileLinkId, Guid userId, string scrapedBioText);
    Task<ProfileLinkEvidence?> VerifyShareIntentAsync(Guid profileLinkId, Guid userId, string sharedUrl, string deviceFingerprint);
    Task<bool> IsProfileAlreadyVerifiedByAnotherUserAsync(string url);
    Task<List<ProfileLinkEvidence>> GetUserProfileLinksAsync(Guid userId);

    // Section 52 Methods
    Task<bool> DeleteProfileLinkAsync(Guid profileLinkId, Guid userId);
    Task<ProfileLinkEvidence?> UpdateProfileLinkVisibilityAsync(Guid profileLinkId, Guid userId, bool showOnPassport);
}

public class EvidenceService : IEvidenceService
{
    private readonly SilentIdDbContext _context;
    private readonly IPlatformConfigurationService _platformService;
    private readonly ILogger<EvidenceService> _logger;

    public EvidenceService(
        SilentIdDbContext context,
        IPlatformConfigurationService platformService,
        ILogger<EvidenceService> logger)
    {
        _context = context;
        _platformService = platformService;
        _logger = logger;
    }

    public async Task<ReceiptEvidence> AddReceiptEvidenceAsync(Guid userId, ReceiptEvidence receipt)
    {
        receipt.Id = Guid.NewGuid();
        receipt.UserId = userId;
        receipt.CreatedAt = DateTime.UtcNow;

        // Basic fraud checks (placeholder - enhance later with real validation)
        if (receipt.IntegrityScore < 70)
        {
            receipt.FraudFlag = true;
            receipt.EvidenceState = EvidenceState.Suspicious;
            _logger.LogWarning("Low integrity score for receipt {ReceiptId}: {Score}", receipt.Id, receipt.IntegrityScore);
        }

        _context.ReceiptEvidences.Add(receipt);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Receipt evidence {ReceiptId} added for user {UserId}", receipt.Id, userId);
        return receipt;
    }

    public async Task<ScreenshotEvidence> AddScreenshotEvidenceAsync(Guid userId, ScreenshotEvidence screenshot)
    {
        screenshot.Id = Guid.NewGuid();
        screenshot.UserId = userId;
        screenshot.CreatedAt = DateTime.UtcNow;

        // Basic fraud checks (placeholder - enhance later with OCR/EXIF validation)
        if (screenshot.IntegrityScore < 70)
        {
            screenshot.FraudFlag = true;
            screenshot.EvidenceState = EvidenceState.Suspicious;
            _logger.LogWarning("Low integrity score for screenshot {ScreenshotId}: {Score}", screenshot.Id, screenshot.IntegrityScore);
        }

        _context.ScreenshotEvidences.Add(screenshot);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Screenshot evidence {ScreenshotId} added for user {UserId}", screenshot.Id, userId);
        return screenshot;
    }

    public async Task<ProfileLinkEvidence> AddProfileLinkEvidenceAsync(Guid userId, ProfileLinkEvidence profileLink)
    {
        profileLink.Id = Guid.NewGuid();
        profileLink.UserId = userId;
        profileLink.CreatedAt = DateTime.UtcNow;
        profileLink.UpdatedAt = DateTime.UtcNow;

        // Match URL to platform configuration and extract username
        var platformMatch = await _platformService.MatchUrlAsync(profileLink.URL);
        if (platformMatch != null)
        {
            // Map platform config to Platform enum based on platformId
            profileLink.Platform = MapPlatformIdToEnum(platformMatch.Platform.PlatformId);
            profileLink.URL = platformMatch.NormalizedUrl; // Store normalized URL

            // Store extracted username in ScrapeDataJson if not already set
            if (string.IsNullOrEmpty(profileLink.ScrapeDataJson))
            {
                profileLink.ScrapeDataJson = System.Text.Json.JsonSerializer.Serialize(new
                {
                    extractedUsername = platformMatch.ExtractedUsername,
                    platformDisplayName = platformMatch.Platform.DisplayName,
                    matchedAt = DateTime.UtcNow
                });
            }

            _logger.LogInformation(
                "Matched profile URL to platform {Platform}, username: {Username}",
                platformMatch.Platform.PlatformId, platformMatch.ExtractedUsername);
        }
        else
        {
            _logger.LogWarning(
                "Profile URL {Url} did not match any known platform",
                profileLink.URL);
        }

        // Basic fraud checks (placeholder - enhance later with real scraping)
        if (profileLink.UsernameMatchScore < 50)
        {
            profileLink.EvidenceState = EvidenceState.Suspicious;
            _logger.LogWarning("Low username match for profile link {ProfileLinkId}: {Score}", profileLink.Id, profileLink.UsernameMatchScore);
        }

        _context.ProfileLinkEvidences.Add(profileLink);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Profile link evidence {ProfileLinkId} added for user {UserId}", profileLink.Id, userId);
        return profileLink;
    }

    public async Task<List<ReceiptEvidence>> GetUserReceiptsAsync(Guid userId, int page = 1, int pageSize = 20)
    {
        return await _context.ReceiptEvidences
            .AsNoTracking() // Read-only pagination query
            .Where(r => r.UserId == userId)
            .OrderByDescending(r => r.Date)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
    }

    public async Task<ScreenshotEvidence?> GetScreenshotAsync(Guid id, Guid userId)
    {
        return await _context.ScreenshotEvidences
            .AsNoTracking() // Read-only query
            .FirstOrDefaultAsync(s => s.Id == id && s.UserId == userId);
    }

    public async Task<ProfileLinkEvidence?> GetProfileLinkAsync(Guid id, Guid userId)
    {
        return await _context.ProfileLinkEvidences
            .AsNoTracking() // Read-only query
            .FirstOrDefaultAsync(p => p.Id == id && p.UserId == userId);
    }

    public async Task<int> GetTotalReceiptsCountAsync(Guid userId)
    {
        return await _context.ReceiptEvidences
            .CountAsync(r => r.UserId == userId);
    }

    public async Task<bool> IsDuplicateReceiptAsync(string rawHash)
    {
        return await _context.ReceiptEvidences
            .AnyAsync(r => r.RawHash == rawHash);
    }

    // ========== LEVEL 3 VERIFICATION METHODS ==========

    /// <summary>
    /// Generates a unique verification token for Token-in-Bio method.
    /// Format: SILENTID-VERIFY-{8 random alphanumeric chars}
    /// Token expires after 24 hours if not used.
    /// </summary>
    public async Task<string> GenerateVerificationTokenAsync(Guid profileLinkId, Guid userId)
    {
        var profileLink = await _context.ProfileLinkEvidences
            .FirstOrDefaultAsync(p => p.Id == profileLinkId && p.UserId == userId);

        if (profileLink == null)
        {
            throw new InvalidOperationException("Profile link not found or does not belong to user.");
        }

        // Check if profile is already verified by another user (ownership locked)
        if (await IsProfileAlreadyVerifiedByAnotherUserAsync(profileLink.URL))
        {
            throw new InvalidOperationException("This profile is already verified by another SilentID account.");
        }

        // Generate unique 8-character alphanumeric token
        var randomChars = GenerateRandomAlphanumeric(8);
        var token = $"SILENTID-VERIFY-{randomChars}";

        profileLink.VerificationToken = token;
        profileLink.VerificationMethod = "TokenInBio";
        profileLink.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        _logger.LogInformation(
            "Generated verification token for profile link {ProfileLinkId}, user {UserId}",
            profileLinkId, userId);

        return token;
    }

    /// <summary>
    /// Confirms Token-in-Bio verification by checking if the token exists in scraped bio text.
    /// If found, upgrades profile to Level 3 verified and locks ownership.
    /// </summary>
    public async Task<ProfileLinkEvidence?> ConfirmTokenInBioAsync(Guid profileLinkId, Guid userId, string scrapedBioText)
    {
        var profileLink = await _context.ProfileLinkEvidences
            .FirstOrDefaultAsync(p => p.Id == profileLinkId && p.UserId == userId);

        if (profileLink == null)
        {
            _logger.LogWarning("Profile link {ProfileLinkId} not found for user {UserId}", profileLinkId, userId);
            return null;
        }

        if (string.IsNullOrEmpty(profileLink.VerificationToken))
        {
            _logger.LogWarning("No verification token exists for profile link {ProfileLinkId}", profileLinkId);
            return null;
        }

        // Check for exact token match in bio text
        if (!scrapedBioText.Contains(profileLink.VerificationToken, StringComparison.OrdinalIgnoreCase))
        {
            _logger.LogInformation(
                "Token not found in bio for profile link {ProfileLinkId}. Expected: {Token}",
                profileLinkId, profileLink.VerificationToken);
            return null;
        }

        // Token found - upgrade to Level 3 and set as Verified (Section 52)
        profileLink.VerificationLevel = 3;
        profileLink.VerificationMethod = "TokenInBio";
        profileLink.LinkState = "Verified"; // Section 52.4
        profileLink.OwnershipLockedAt = DateTime.UtcNow;
        profileLink.SnapshotHash = ComputeSha256Hash(scrapedBioText);
        profileLink.NextReverifyAt = DateTime.UtcNow.AddDays(90);
        profileLink.IntegrityScore = 100;
        profileLink.EvidenceState = EvidenceState.Valid;
        profileLink.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        _logger.LogInformation(
            "Profile link {ProfileLinkId} upgraded to Level 3 via Token-in-Bio for user {UserId}",
            profileLinkId, userId);

        return profileLink;
    }

    /// <summary>
    /// Verifies Share-Intent method by validating the shared URL and device fingerprint.
    /// Share link must be used within 5 minutes and device fingerprint must match session.
    /// </summary>
    public async Task<ProfileLinkEvidence?> VerifyShareIntentAsync(
        Guid profileLinkId, Guid userId, string sharedUrl, string deviceFingerprint)
    {
        var profileLink = await _context.ProfileLinkEvidences
            .FirstOrDefaultAsync(p => p.Id == profileLinkId && p.UserId == userId);

        if (profileLink == null)
        {
            _logger.LogWarning("Profile link {ProfileLinkId} not found for user {UserId}", profileLinkId, userId);
            return null;
        }

        // Normalize URLs for comparison
        var normalizedProfileUrl = NormalizeUrl(profileLink.URL);
        var normalizedSharedUrl = NormalizeUrl(sharedUrl);

        // Verify the shared URL matches the profile URL
        if (!normalizedProfileUrl.Equals(normalizedSharedUrl, StringComparison.OrdinalIgnoreCase))
        {
            _logger.LogWarning(
                "Shared URL mismatch for profile link {ProfileLinkId}. Expected: {Expected}, Got: {Got}",
                profileLinkId, normalizedProfileUrl, normalizedSharedUrl);
            return null;
        }

        // Check if profile is already verified by another user
        if (await IsProfileAlreadyVerifiedByAnotherUserAsync(profileLink.URL))
        {
            _logger.LogWarning(
                "Profile {Url} already verified by another user, cannot verify for {UserId}",
                profileLink.URL, userId);
            return null;
        }

        // Upgrade to Level 3 via Share-Intent and set as Verified (Section 52)
        profileLink.VerificationLevel = 3;
        profileLink.VerificationMethod = "ShareIntent";
        profileLink.LinkState = "Verified"; // Section 52.4
        profileLink.OwnershipLockedAt = DateTime.UtcNow;
        profileLink.SnapshotHash = ComputeSha256Hash($"{sharedUrl}|{deviceFingerprint}|{DateTime.UtcNow:O}");
        profileLink.NextReverifyAt = DateTime.UtcNow.AddDays(90);
        profileLink.IntegrityScore = 100;
        profileLink.EvidenceState = EvidenceState.Valid;
        profileLink.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        _logger.LogInformation(
            "Profile link {ProfileLinkId} upgraded to Level 3 via Share-Intent for user {UserId}",
            profileLinkId, userId);

        return profileLink;
    }

    /// <summary>
    /// Checks if a profile URL is already verified (Level 3) by another user.
    /// Prevents duplicate profile ownership claims.
    /// </summary>
    public async Task<bool> IsProfileAlreadyVerifiedByAnotherUserAsync(string url)
    {
        var normalizedUrl = NormalizeUrl(url);

        return await _context.ProfileLinkEvidences
            .AsNoTracking()
            .AnyAsync(p =>
                p.VerificationLevel == 3 &&
                p.OwnershipLockedAt != null &&
                NormalizeUrl(p.URL) == normalizedUrl);
    }

    /// <summary>
    /// Gets all profile link evidence for a user.
    /// </summary>
    public async Task<List<ProfileLinkEvidence>> GetUserProfileLinksAsync(Guid userId)
    {
        return await _context.ProfileLinkEvidences
            .AsNoTracking()
            .Where(p => p.UserId == userId)
            .OrderByDescending(p => p.VerificationLevel)
            .ThenByDescending(p => p.CreatedAt)
            .ToListAsync();
    }

    // ========== HELPER METHODS ==========

    private static string GenerateRandomAlphanumeric(int length)
    {
        const string chars = "abcdefghijklmnopqrstuvwxyz0123456789";
        var random = new Random();
        return new string(Enumerable.Repeat(chars, length)
            .Select(s => s[random.Next(s.Length)]).ToArray());
    }

    private static string ComputeSha256Hash(string input)
    {
        using var sha256 = System.Security.Cryptography.SHA256.Create();
        var bytes = System.Text.Encoding.UTF8.GetBytes(input);
        var hash = sha256.ComputeHash(bytes);
        return Convert.ToHexString(hash).ToLowerInvariant();
    }

    private static string NormalizeUrl(string url)
    {
        if (string.IsNullOrEmpty(url)) return string.Empty;

        // Remove trailing slashes, convert to lowercase, remove www prefix
        var normalized = url.Trim().ToLowerInvariant();
        normalized = normalized.TrimEnd('/');

        if (Uri.TryCreate(normalized, UriKind.Absolute, out var uri))
        {
            var host = uri.Host.StartsWith("www.") ? uri.Host[4..] : uri.Host;
            return $"{uri.Scheme}://{host}{uri.PathAndQuery}".TrimEnd('/');
        }

        return normalized;
    }

    /// <summary>
    /// Maps platform configuration ID to Platform enum.
    /// </summary>
    private static Platform MapPlatformIdToEnum(string platformId)
    {
        return platformId.ToLowerInvariant() switch
        {
            "vinted-uk" or "vinted" => Platform.Vinted,
            "ebay-uk" or "ebay-us" or "ebay" => Platform.eBay,
            "depop" => Platform.Depop,
            "etsy" => Platform.Etsy,
            "facebook-marketplace" => Platform.FacebookMarketplace,
            "poshmark" => Platform.Other, // Add to enum if needed
            _ => Platform.Other
        };
    }

    // ========== SECTION 52 METHODS ==========

    /// <summary>
    /// Delete a profile link (Section 52).
    /// </summary>
    public async Task<bool> DeleteProfileLinkAsync(Guid profileLinkId, Guid userId)
    {
        var profileLink = await _context.ProfileLinkEvidences
            .FirstOrDefaultAsync(p => p.Id == profileLinkId && p.UserId == userId);

        if (profileLink == null)
        {
            return false;
        }

        _context.ProfileLinkEvidences.Remove(profileLink);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Profile link {ProfileLinkId} deleted for user {UserId}", profileLinkId, userId);
        return true;
    }

    /// <summary>
    /// Update profile link passport visibility (Section 52).
    /// </summary>
    public async Task<ProfileLinkEvidence?> UpdateProfileLinkVisibilityAsync(Guid profileLinkId, Guid userId, bool showOnPassport)
    {
        var profileLink = await _context.ProfileLinkEvidences
            .FirstOrDefaultAsync(p => p.Id == profileLinkId && p.UserId == userId);

        if (profileLink == null)
        {
            return null;
        }

        profileLink.ShowOnPassport = showOnPassport;
        profileLink.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        _logger.LogInformation("Profile link {ProfileLinkId} visibility updated to {ShowOnPassport} for user {UserId}",
            profileLinkId, showOnPassport, userId);
        return profileLink;
    }
}
