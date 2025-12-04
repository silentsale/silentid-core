using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

/// <summary>
/// Anomaly Detection Service per Section 54.5
/// Detects suspicious patterns and triggers security responses
/// </summary>
public interface IAnomalyDetectionService
{
    /// <summary>
    /// Analyze login attempt for anomalies
    /// </summary>
    Task<AnomalyResult> AnalyzeLoginAsync(Guid userId, string deviceId, string ipAddress, string? userAgent);

    /// <summary>
    /// Analyze evidence upload patterns
    /// </summary>
    Task<AnomalyResult> AnalyzeEvidenceUploadAsync(Guid userId);

    /// <summary>
    /// Get user's risk score based on recent activity
    /// </summary>
    Task<int> CalculateRiskScoreAsync(Guid userId);

    /// <summary>
    /// Record an anomaly for future analysis
    /// </summary>
    Task RecordAnomalyAsync(Guid userId, AnomalyType type, string details, int severity);
}

public enum AnomalyType
{
    RapidIpChange,          // IP changed too quickly (geo velocity)
    MultipleFailedLogins,   // Too many failed login attempts
    UnusualLoginTime,       // Login at unusual hour for user
    NewDeviceLocation,      // Device from new geographic location
    DeviceFingerprintChange,// Device fingerprint mismatch
    RapidEvidenceUpload,    // Too many uploads in short time
    SuspiciousEvidencePattern, // Evidence patterns suggesting manipulation
    AccountTakeover,        // Signs of account compromise
    BotBehavior            // Patterns suggesting automated access
}

public class AnomalyResult
{
    public bool IsAnomalous { get; set; }
    public int RiskScore { get; set; } // 0-100
    public List<DetectedAnomaly> Anomalies { get; set; } = new();
    public string? RecommendedAction { get; set; }
    public bool ShouldBlockAction { get; set; }
    public bool ShouldNotifyUser { get; set; }
}

public class DetectedAnomaly
{
    public AnomalyType Type { get; set; }
    public string Description { get; set; } = string.Empty;
    public int Severity { get; set; } // 1-10
    public DateTime DetectedAt { get; set; } = DateTime.UtcNow;
}

public class AnomalyDetectionService : IAnomalyDetectionService
{
    private readonly SilentIdDbContext _db;
    private readonly INotificationService _notificationService;
    private readonly ILogger<AnomalyDetectionService> _logger;

    // Thresholds
    private const int MaxFailedLoginsPerHour = 5;
    private const int MaxIpChangesPerHour = 3;
    private const int MaxEvidenceUploadsPerHour = 10;
    private const double GeoVelocityThresholdKmPerHour = 500; // Impossible travel speed

    public AnomalyDetectionService(
        SilentIdDbContext db,
        INotificationService pushService,
        ILogger<AnomalyDetectionService> logger)
    {
        _db = db;
        _notificationService = pushService;
        _logger = logger;
    }

    public async Task<AnomalyResult> AnalyzeLoginAsync(Guid userId, string deviceId, string ipAddress, string? userAgent)
    {
        var result = new AnomalyResult();
        var anomalies = new List<DetectedAnomaly>();

        // Check 1: Multiple failed logins
        var failedLogins = await _db.LoginAttempts
            .Where(l => l.UserId == userId &&
                       !l.Success &&
                       l.AttemptedAt > DateTime.UtcNow.AddHours(-1))
            .CountAsync();

        if (failedLogins >= MaxFailedLoginsPerHour)
        {
            anomalies.Add(new DetectedAnomaly
            {
                Type = AnomalyType.MultipleFailedLogins,
                Description = $"{failedLogins} failed login attempts in the last hour",
                Severity = Math.Min(failedLogins, 10)
            });
        }

        // Check 2: Rapid IP changes (geo velocity)
        var recentLogins = await _db.LoginAttempts
            .Where(l => l.UserId == userId &&
                       l.Success &&
                       l.AttemptedAt > DateTime.UtcNow.AddHours(-1))
            .OrderByDescending(l => l.AttemptedAt)
            .Take(5)
            .ToListAsync();

        var uniqueIps = recentLogins.Select(l => l.IpAddress).Distinct().Count();
        if (uniqueIps >= MaxIpChangesPerHour)
        {
            anomalies.Add(new DetectedAnomaly
            {
                Type = AnomalyType.RapidIpChange,
                Description = $"{uniqueIps} different IP addresses in the last hour",
                Severity = Math.Min(uniqueIps * 2, 10)
            });
        }

        // Check 3: New device from different location
        var knownDevice = await _db.AuthDevices
            .FirstOrDefaultAsync(d => d.UserId == userId && d.DeviceId == deviceId);

        if (knownDevice == null)
        {
            // First time seeing this device
            var existingDeviceCount = await _db.AuthDevices
                .CountAsync(d => d.UserId == userId);

            if (existingDeviceCount > 0)
            {
                anomalies.Add(new DetectedAnomaly
                {
                    Type = AnomalyType.NewDeviceLocation,
                    Description = "Login from new device",
                    Severity = 5
                });
            }
        }
        else if (knownDevice.LastIP != null && knownDevice.LastIP != ipAddress)
        {
            // Known device but different IP
            var timeSinceLastUse = DateTime.UtcNow - knownDevice.LastUsedAt;
            if (timeSinceLastUse.TotalMinutes < 30)
            {
                // Same device, different IP within 30 minutes - suspicious
                anomalies.Add(new DetectedAnomaly
                {
                    Type = AnomalyType.RapidIpChange,
                    Description = "IP address changed on same device within 30 minutes",
                    Severity = 7
                });
            }
        }

        // Check 4: Unusual login time
        var userLoginHours = await _db.LoginAttempts
            .Where(l => l.UserId == userId && l.Success)
            .Select(l => l.AttemptedAt.Hour)
            .ToListAsync();

        if (userLoginHours.Count >= 10)
        {
            var avgHour = userLoginHours.Average();
            var currentHour = DateTime.UtcNow.Hour;
            var hourDiff = Math.Abs(currentHour - avgHour);

            if (hourDiff > 8) // More than 8 hours from typical login time
            {
                anomalies.Add(new DetectedAnomaly
                {
                    Type = AnomalyType.UnusualLoginTime,
                    Description = $"Login at unusual time (hour {currentHour}, typical: {avgHour:F0})",
                    Severity = 3
                });
            }
        }

        // Calculate overall risk score
        result.Anomalies = anomalies;
        result.RiskScore = CalculateRiskFromAnomalies(anomalies);
        result.IsAnomalous = anomalies.Any();

        // Determine recommended action
        if (result.RiskScore >= 80)
        {
            result.ShouldBlockAction = true;
            result.ShouldNotifyUser = true;
            result.RecommendedAction = "Block login and notify user";
        }
        else if (result.RiskScore >= 50)
        {
            result.ShouldBlockAction = false;
            result.ShouldNotifyUser = true;
            result.RecommendedAction = "Require step-up authentication";
        }
        else if (result.RiskScore >= 30)
        {
            result.ShouldNotifyUser = true;
            result.RecommendedAction = "Allow but notify user of new login";
        }

        // Log significant anomalies
        if (result.IsAnomalous)
        {
            _logger.LogWarning(
                "Anomalies detected for user {UserId}: RiskScore={RiskScore}, Anomalies={Count}",
                userId, result.RiskScore, anomalies.Count);

            // Record for future analysis
            foreach (var anomaly in anomalies.Where(a => a.Severity >= 5))
            {
                await RecordAnomalyAsync(userId, anomaly.Type, anomaly.Description, anomaly.Severity);
            }
        }

        return result;
    }

    public async Task<AnomalyResult> AnalyzeEvidenceUploadAsync(Guid userId)
    {
        var result = new AnomalyResult();
        var anomalies = new List<DetectedAnomaly>();

        // v2.0: Check profile link upload rate (receipts/screenshots removed)
        var recentUploads = await _db.ProfileLinkEvidences
            .CountAsync(e => e.UserId == userId && e.CreatedAt > DateTime.UtcNow.AddHours(-1));

        if (recentUploads >= MaxEvidenceUploadsPerHour)
        {
            anomalies.Add(new DetectedAnomaly
            {
                Type = AnomalyType.RapidEvidenceUpload,
                Description = $"{recentUploads} evidence uploads in the last hour",
                Severity = Math.Min(recentUploads / 2, 8)
            });
        }

        // v2.0: Check for duplicate profile link patterns (receipts removed)
        var recentProfileLinks = await _db.ProfileLinkEvidences
            .Where(e => e.UserId == userId && e.CreatedAt > DateTime.UtcNow.AddDays(-1))
            .Select(e => e.URL)
            .ToListAsync();

        var duplicateUrls = recentProfileLinks.GroupBy(u => u).Where(g => g.Count() > 1).Count();
        if (duplicateUrls > 0)
        {
            anomalies.Add(new DetectedAnomaly
            {
                Type = AnomalyType.SuspiciousEvidencePattern,
                Description = $"{duplicateUrls} duplicate profile links detected",
                Severity = duplicateUrls * 3
            });
        }

        result.Anomalies = anomalies;
        result.RiskScore = CalculateRiskFromAnomalies(anomalies);
        result.IsAnomalous = anomalies.Any();

        if (result.RiskScore >= 60)
        {
            result.ShouldBlockAction = true;
            result.RecommendedAction = "Block upload and flag for review";
        }

        return result;
    }

    public async Task<int> CalculateRiskScoreAsync(Guid userId)
    {
        var riskSignals = await _db.RiskSignals
            .Where(r => r.UserId == userId && r.CreatedAt > DateTime.UtcNow.AddDays(-30))
            .ToListAsync();

        if (!riskSignals.Any())
            return 0;

        // Calculate weighted risk score
        var totalWeight = 0;
        var weightedSum = 0;

        foreach (var signal in riskSignals)
        {
            var age = (DateTime.UtcNow - signal.CreatedAt).Days;
            var decay = Math.Max(0.1, 1 - (age / 30.0)); // Decay over 30 days

            var weight = signal.Severity;
            totalWeight += weight;
            weightedSum += (int)(signal.Severity * signal.Severity * decay); // Squared for severity emphasis
        }

        return totalWeight > 0 ? Math.Min(100, weightedSum / totalWeight * 10) : 0;
    }

    public async Task RecordAnomalyAsync(Guid userId, AnomalyType type, string details, int severity)
    {
        // Map AnomalyType to RiskType
        var riskType = type switch
        {
            AnomalyType.RapidIpChange => RiskType.IPRisk,
            AnomalyType.MultipleFailedLogins => RiskType.SuspiciousLogin,
            AnomalyType.UnusualLoginTime => RiskType.SuspiciousLogin,
            AnomalyType.NewDeviceLocation => RiskType.DeviceMismatch,
            AnomalyType.DeviceFingerprintChange => RiskType.DeviceMismatch,
            AnomalyType.RapidEvidenceUpload => RiskType.AbnormalActivity,
            AnomalyType.SuspiciousEvidencePattern => RiskType.FakeReceipt,
            AnomalyType.AccountTakeover => RiskType.SuspiciousLogin,
            AnomalyType.BotBehavior => RiskType.AbnormalActivity,
            _ => RiskType.AbnormalActivity
        };

        var signal = new RiskSignal
        {
            UserId = userId,
            Type = riskType,
            Message = details,
            Severity = severity,
            CreatedAt = DateTime.UtcNow
        };

        _db.RiskSignals.Add(signal);
        await _db.SaveChangesAsync();

        _logger.LogInformation(
            "Anomaly recorded for user {UserId}: {Type} (severity {Severity})",
            userId, type, severity);

        // Notify user of high-severity anomalies
        if (severity >= 7)
        {
            await _notificationService.NotifyAsync(
                userId,
                NotificationType.SecurityAlert,
                "Security Alert",
                $"Unusual activity detected on your account: {details}", true);
        }
    }

    private int CalculateRiskFromAnomalies(List<DetectedAnomaly> anomalies)
    {
        if (!anomalies.Any())
            return 0;

        // Base score from sum of severities
        var baseScore = anomalies.Sum(a => a.Severity);

        // Multiply if multiple anomaly types (indicates coordinated attack)
        var typeCount = anomalies.Select(a => a.Type).Distinct().Count();
        var multiplier = 1 + (typeCount - 1) * 0.3; // 30% increase per additional type

        return Math.Min(100, (int)(baseScore * multiplier));
    }
}
