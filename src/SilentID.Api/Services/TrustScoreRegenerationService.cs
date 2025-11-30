using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;

namespace SilentID.Api.Services;

/// <summary>
/// Background service for weekly TrustScore regeneration per Section 3.1
/// Runs every Sunday at midnight UTC to recalculate all user TrustScores
/// </summary>
public class TrustScoreRegenerationService : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly ILogger<TrustScoreRegenerationService> _logger;
    private readonly TimeSpan _checkInterval = TimeSpan.FromHours(1); // Check every hour

    public TrustScoreRegenerationService(
        IServiceProvider serviceProvider,
        ILogger<TrustScoreRegenerationService> logger)
    {
        _serviceProvider = serviceProvider;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("TrustScore Regeneration Service starting");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                if (ShouldRunRegeneration())
                {
                    await RegenerateAllTrustScoresAsync(stoppingToken);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error in TrustScore regeneration cycle");
            }

            await Task.Delay(_checkInterval, stoppingToken);
        }

        _logger.LogInformation("TrustScore Regeneration Service stopping");
    }

    private bool ShouldRunRegeneration()
    {
        var now = DateTime.UtcNow;

        // Run on Sundays between midnight and 1 AM UTC
        return now.DayOfWeek == DayOfWeek.Sunday && now.Hour == 0;
    }

    private async Task RegenerateAllTrustScoresAsync(CancellationToken stoppingToken)
    {
        _logger.LogInformation("Starting weekly TrustScore regeneration");
        var startTime = DateTime.UtcNow;
        var successCount = 0;
        var errorCount = 0;

        using var scope = _serviceProvider.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<SilentIdDbContext>();
        var trustScoreService = scope.ServiceProvider.GetRequiredService<ITrustScoreService>();

        // Get all users
        var userIds = await dbContext.Users
            .Select(u => u.Id)
            .ToListAsync(stoppingToken);

        var totalUsers = userIds.Count;
        _logger.LogInformation("Regenerating TrustScores for {TotalUsers} users", totalUsers);

        // Process in batches to avoid memory issues
        const int batchSize = 100;
        for (var i = 0; i < totalUsers; i += batchSize)
        {
            if (stoppingToken.IsCancellationRequested)
            {
                _logger.LogWarning("TrustScore regeneration cancelled");
                break;
            }

            var batch = userIds.Skip(i).Take(batchSize).ToList();

            foreach (var userId in batch)
            {
                try
                {
                    await trustScoreService.CalculateAndSaveTrustScoreAsync(userId);
                    successCount++;
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Failed to regenerate TrustScore for user {UserId}", userId);
                    errorCount++;
                }
            }

            // Small delay between batches to avoid overwhelming the database
            await Task.Delay(100, stoppingToken);
        }

        var duration = DateTime.UtcNow - startTime;
        _logger.LogInformation(
            "Weekly TrustScore regeneration completed. Success: {Success}, Errors: {Errors}, Duration: {Duration}",
            successCount, errorCount, duration);
    }

    /// <summary>
    /// Manually trigger regeneration for a specific user (called after evidence upload, etc.)
    /// </summary>
    public static async Task RegenerateForUserAsync(
        IServiceProvider serviceProvider,
        Guid userId,
        ILogger logger)
    {
        try
        {
            using var scope = serviceProvider.CreateScope();
            var trustScoreService = scope.ServiceProvider.GetRequiredService<ITrustScoreService>();
            await trustScoreService.CalculateAndSaveTrustScoreAsync(userId);

            logger.LogInformation("TrustScore regenerated for user {UserId}", userId);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, "Failed to regenerate TrustScore for user {UserId}", userId);
        }
    }
}
