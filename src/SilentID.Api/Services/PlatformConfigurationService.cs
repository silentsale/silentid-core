using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

/// <summary>
/// Service for managing and querying platform configurations.
/// Provides URL matching, verification method lookup, and selector retrieval.
/// See CLAUDE.md Section 48 - Modular Platform Configuration System.
/// </summary>
public interface IPlatformConfigurationService
{
    /// <summary>
    /// Match a URL to a platform configuration.
    /// </summary>
    Task<PlatformMatchResult?> MatchUrlAsync(string url);

    /// <summary>
    /// Match a share intent URI to a platform configuration.
    /// </summary>
    Task<PlatformMatchResult?> MatchShareIntentAsync(string intentUri);

    /// <summary>
    /// Get all active platform configurations.
    /// </summary>
    Task<List<PlatformConfiguration>> GetActivePlatformsAsync();

    /// <summary>
    /// Get a platform configuration by ID.
    /// </summary>
    Task<PlatformConfiguration?> GetByPlatformIdAsync(string platformId);

    /// <summary>
    /// Get verification methods available for a platform.
    /// Returns ordered list: ShareIntent first, TokenInBio second (if available).
    /// </summary>
    Task<List<string>> GetVerificationMethodsAsync(string platformId);

    /// <summary>
    /// Check if a platform supports Token-in-Bio verification.
    /// </summary>
    Task<bool> SupportsTokenInBioAsync(string platformId);
}

/// <summary>
/// Result of matching a URL or share intent to a platform.
/// </summary>
public class PlatformMatchResult
{
    public required PlatformConfiguration Platform { get; set; }
    public required string ExtractedUsername { get; set; }
    public required string OriginalUrl { get; set; }
    public required string NormalizedUrl { get; set; }
}

public class PlatformConfigurationService : IPlatformConfigurationService
{
    private readonly SilentIdDbContext _dbContext;
    private readonly ILogger<PlatformConfigurationService> _logger;

    // Cache for compiled regex patterns (performance optimization)
    private static readonly Dictionary<string, List<Regex>> _urlPatternCache = new();
    private static readonly Dictionary<string, List<Regex>> _shareIntentPatternCache = new();
    private static readonly object _cacheLock = new();

    public PlatformConfigurationService(
        SilentIdDbContext dbContext,
        ILogger<PlatformConfigurationService> logger)
    {
        _dbContext = dbContext;
        _logger = logger;
    }

    public async Task<PlatformMatchResult?> MatchUrlAsync(string url)
    {
        if (string.IsNullOrWhiteSpace(url))
            return null;

        var normalizedUrl = NormalizeUrl(url);
        var platforms = await GetActivePlatformsAsync();

        foreach (var platform in platforms)
        {
            var patterns = GetCompiledUrlPatterns(platform);
            foreach (var pattern in patterns)
            {
                var match = pattern.Match(normalizedUrl);
                if (match.Success && match.Groups.Count > 1)
                {
                    var username = match.Groups[1].Value;
                    _logger.LogInformation(
                        "URL matched platform {PlatformId}, username: {Username}",
                        platform.PlatformId, username);

                    return new PlatformMatchResult
                    {
                        Platform = platform,
                        ExtractedUsername = username,
                        OriginalUrl = url,
                        NormalizedUrl = normalizedUrl
                    };
                }
            }
        }

        _logger.LogDebug("No platform match found for URL: {Url}", url);
        return null;
    }

    public async Task<PlatformMatchResult?> MatchShareIntentAsync(string intentUri)
    {
        if (string.IsNullOrWhiteSpace(intentUri))
            return null;

        var platforms = await GetActivePlatformsAsync();

        foreach (var platform in platforms)
        {
            var patterns = GetCompiledShareIntentPatterns(platform);
            foreach (var pattern in patterns)
            {
                var match = pattern.Match(intentUri);
                if (match.Success && match.Groups.Count > 1)
                {
                    var username = match.Groups[1].Value;
                    _logger.LogInformation(
                        "Share intent matched platform {PlatformId}, username: {Username}",
                        platform.PlatformId, username);

                    return new PlatformMatchResult
                    {
                        Platform = platform,
                        ExtractedUsername = username,
                        OriginalUrl = intentUri,
                        NormalizedUrl = intentUri
                    };
                }
            }
        }

        _logger.LogDebug("No platform match found for share intent: {IntentUri}", intentUri);
        return null;
    }

    public async Task<List<PlatformConfiguration>> GetActivePlatformsAsync()
    {
        return await _dbContext.PlatformConfigurations
            .Where(p => p.Status == PlatformStatus.Active)
            .OrderBy(p => p.DisplayName)
            .ToListAsync();
    }

    public async Task<PlatformConfiguration?> GetByPlatformIdAsync(string platformId)
    {
        return await _dbContext.PlatformConfigurations
            .FirstOrDefaultAsync(p => p.PlatformId == platformId);
    }

    public async Task<List<string>> GetVerificationMethodsAsync(string platformId)
    {
        var platform = await GetByPlatformIdAsync(platformId);
        if (platform == null)
            return new List<string>();

        return ParseJsonArray(platform.VerificationMethodsJson);
    }

    public async Task<bool> SupportsTokenInBioAsync(string platformId)
    {
        var methods = await GetVerificationMethodsAsync(platformId);
        return methods.Contains("TokenInBio");
    }

    #region Private Helpers

    private static string NormalizeUrl(string url)
    {
        // Remove trailing slashes, normalize to lowercase for domain
        url = url.Trim();

        if (!url.StartsWith("http://") && !url.StartsWith("https://"))
            url = "https://" + url;

        if (Uri.TryCreate(url, UriKind.Absolute, out var uri))
        {
            // Rebuild with lowercase host but preserve path case
            return $"{uri.Scheme}://{uri.Host.ToLowerInvariant()}{uri.PathAndQuery}".TrimEnd('/');
        }

        return url.ToLowerInvariant().TrimEnd('/');
    }

    private List<Regex> GetCompiledUrlPatterns(PlatformConfiguration platform)
    {
        var cacheKey = $"url_{platform.PlatformId}_{platform.SelectorVersion}";

        lock (_cacheLock)
        {
            if (_urlPatternCache.TryGetValue(cacheKey, out var cached))
                return cached;

            var patterns = ParseJsonArray(platform.UrlPatternsJson)
                .Select(p => new Regex(p, RegexOptions.IgnoreCase | RegexOptions.Compiled))
                .ToList();

            _urlPatternCache[cacheKey] = patterns;
            return patterns;
        }
    }

    private List<Regex> GetCompiledShareIntentPatterns(PlatformConfiguration platform)
    {
        var cacheKey = $"intent_{platform.PlatformId}_{platform.SelectorVersion}";

        lock (_cacheLock)
        {
            if (_shareIntentPatternCache.TryGetValue(cacheKey, out var cached))
                return cached;

            var patterns = ParseJsonArray(platform.ShareIntentPatternsJson)
                .Select(p => new Regex(p, RegexOptions.IgnoreCase | RegexOptions.Compiled))
                .ToList();

            _shareIntentPatternCache[cacheKey] = patterns;
            return patterns;
        }
    }

    private static List<string> ParseJsonArray(string? json)
    {
        if (string.IsNullOrWhiteSpace(json))
            return new List<string>();

        try
        {
            return JsonSerializer.Deserialize<List<string>>(json) ?? new List<string>();
        }
        catch
        {
            return new List<string>();
        }
    }

    #endregion
}
