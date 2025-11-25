using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

public class TrustScoreService : ITrustScoreService
{
    private readonly SilentIdDbContext _context;
    private readonly ILogger<TrustScoreService> _logger;

    public TrustScoreService(SilentIdDbContext context, ILogger<TrustScoreService> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<TrustScoreSnapshot> GetCurrentTrustScoreAsync(Guid userId)
    {
        // Get the most recent TrustScore snapshot
        var snapshot = await _context.TrustScoreSnapshots
            .AsNoTracking() // Prevent EF from tracking this entity
            .Where(ts => ts.UserId == userId)
            .OrderByDescending(ts => ts.CreatedAt)
            .FirstOrDefaultAsync();

        if (snapshot == null)
        {
            // Calculate and save initial TrustScore
            snapshot = await CalculateAndSaveTrustScoreAsync(userId);
        }

        return snapshot;
    }

    public async Task<TrustScoreBreakdown> GetTrustScoreBreakdownAsync(Guid userId)
    {
        var user = await _context.Users
            .AsNoTracking() // Read-only query
            .FirstOrDefaultAsync(u => u.Id == userId);

        if (user == null)
        {
            throw new InvalidOperationException("User not found");
        }

        // Get identity verification status separately
        var identityVerification = await _context.IdentityVerifications
            .AsNoTracking() // Read-only query
            .FirstOrDefaultAsync(iv => iv.UserId == userId);

        // Get all evidence counts (CountAsync doesn't need AsNoTracking)
        var receiptsCount = await _context.ReceiptEvidences
            .Where(r => r.UserId == userId && r.EvidenceState == EvidenceState.Valid)
            .CountAsync();

        var screenshotsCount = await _context.ScreenshotEvidences
            .Where(s => s.UserId == userId && s.EvidenceState == EvidenceState.Valid)
            .CountAsync();

        var profileLinksCount = await _context.ProfileLinkEvidences
            .Where(p => p.UserId == userId && p.EvidenceState == EvidenceState.Valid)
            .CountAsync();

        var mutualVerificationsCount = await _context.MutualVerifications
            .Where(m => (m.UserAId == userId || m.UserBId == userId) && m.Status == MutualVerificationStatus.Confirmed)
            .CountAsync();

        var reportsCount = await _context.Reports
            .Where(r => r.ReportedUserId == userId && r.Status == ReportStatus.Verified)
            .CountAsync();

        var accountAgeDays = (DateTime.UtcNow - user.CreatedAt).Days;

        // Build breakdown (5 components: Identity, Evidence, Behaviour, Peer, URS)
        var breakdown = new TrustScoreBreakdown
        {
            Identity = BuildIdentityBreakdown(user, identityVerification, accountAgeDays),
            Evidence = BuildEvidenceBreakdown(receiptsCount, screenshotsCount, profileLinksCount),
            Behaviour = BuildBehaviourBreakdown(reportsCount, accountAgeDays),
            Peer = BuildPeerBreakdown(mutualVerificationsCount),
            Urs = await BuildUrsBreakdownAsync(userId)
        };

        // Section 47: New 5-component formula
        // Raw score = Identity (200) + Evidence (300) + Behaviour (300) + Peer (200) + URS (200) = max 1200
        // Final TrustScore = (Raw Score / 1200) × 1000 (normalized to 0-1000)
        var rawScore = breakdown.Identity.Score + breakdown.Evidence.Score +
                       breakdown.Behaviour.Score + breakdown.Peer.Score + breakdown.Urs.Score;
        breakdown.TotalScore = (int)Math.Round((rawScore / 1200.0) * 1000);
        breakdown.Label = GetTrustLabel(breakdown.TotalScore);

        return breakdown;
    }

    public async Task<List<TrustScoreSnapshot>> GetTrustScoreHistoryAsync(Guid userId, int months = 6)
    {
        var cutoffDate = DateTime.UtcNow.AddMonths(-months);

        var snapshots = await _context.TrustScoreSnapshots
            .AsNoTracking() // Read-only historical data
            .Where(ts => ts.UserId == userId && ts.CreatedAt >= cutoffDate)
            .OrderBy(ts => ts.CreatedAt)
            .ToListAsync();

        return snapshots;
    }

    public async Task<TrustScoreSnapshot> CalculateAndSaveTrustScoreAsync(Guid userId)
    {
        var breakdown = await GetTrustScoreBreakdownAsync(userId);

        var snapshot = new TrustScoreSnapshot
        {
            UserId = userId,
            Score = breakdown.TotalScore,
            IdentityScore = breakdown.Identity.Score,
            EvidenceScore = breakdown.Evidence.Score,
            BehaviourScore = breakdown.Behaviour.Score,
            PeerScore = breakdown.Peer.Score,
            UrsScore = breakdown.Urs.Score, // Section 47: Add URS component
            BreakdownJson = System.Text.Json.JsonSerializer.Serialize(breakdown),
            CreatedAt = DateTime.UtcNow
        };

        _context.TrustScoreSnapshots.Add(snapshot);
        await _context.SaveChangesAsync();

        _logger.LogInformation("TrustScore calculated for user {UserId}: {Score} (Identity:{Identity} Evidence:{Evidence} Behaviour:{Behaviour} Peer:{Peer} URS:{Urs})",
            userId, snapshot.Score, snapshot.IdentityScore, snapshot.EvidenceScore, snapshot.BehaviourScore, snapshot.PeerScore, snapshot.UrsScore);

        return snapshot;
    }

    // Helper methods to build breakdown sections
    private IdentityBreakdown BuildIdentityBreakdown(User user, IdentityVerification? identityVerification, int accountAgeDays)
    {
        var breakdown = new IdentityBreakdown();
        var items = new List<ScoreItem>();

        // Identity verification (150 points)
        if (identityVerification?.Status == VerificationStatus.Verified)
        {
            items.Add(new ScoreItem
            {
                Description = "Identity verified via Stripe",
                Points = 150,
                Status = "completed"
            });
            breakdown.Score += 150;
        }
        else
        {
            items.Add(new ScoreItem
            {
                Description = "Identity not verified",
                Points = 0,
                Status = "missing"
            });
        }

        // Email verification (25 points)
        if (user.IsEmailVerified)
        {
            items.Add(new ScoreItem
            {
                Description = "Email verified",
                Points = 25,
                Status = "completed"
            });
            breakdown.Score += 25;
        }
        else
        {
            items.Add(new ScoreItem
            {
                Description = "Email not verified",
                Points = 0,
                Status = "warning"
            });
        }

        // Phone verification (15 points)
        if (user.IsPhoneVerified)
        {
            items.Add(new ScoreItem
            {
                Description = "Phone verified",
                Points = 15,
                Status = "completed"
            });
            breakdown.Score += 15;
        }

        // Account age (10 points)
        if (accountAgeDays >= 30)
        {
            items.Add(new ScoreItem
            {
                Description = "Account active for 30+ days",
                Points = 10,
                Status = "completed"
            });
            breakdown.Score += 10;
        }

        breakdown.Items = items;
        return breakdown;
    }

    private EvidenceBreakdown BuildEvidenceBreakdown(int receiptsCount, int screenshotsCount, int profileLinksCount)
    {
        var breakdown = new EvidenceBreakdown();
        var items = new List<ScoreItem>();

        // Receipts (up to 150 points)
        if (receiptsCount > 0)
        {
            var receiptPoints = Math.Min(receiptsCount * 5, 150);
            items.Add(new ScoreItem
            {
                Description = $"{receiptsCount} verified receipt{(receiptsCount > 1 ? "s" : "")}",
                Points = receiptPoints,
                Status = "completed"
            });
            breakdown.Score += receiptPoints;
        }

        // Screenshots (up to 100 points)
        if (screenshotsCount > 0)
        {
            var screenshotPoints = Math.Min(screenshotsCount * 10, 100);
            items.Add(new ScoreItem
            {
                Description = $"{screenshotsCount} verified screenshot{(screenshotsCount > 1 ? "s" : "")}",
                Points = screenshotPoints,
                Status = "completed"
            });
            breakdown.Score += screenshotPoints;
        }

        // Profile links (up to 50 points)
        if (profileLinksCount > 0)
        {
            var profilePoints = Math.Min(profileLinksCount * 25, 50);
            items.Add(new ScoreItem
            {
                Description = $"{profileLinksCount} verified platform profile{(profileLinksCount > 1 ? "s" : "")}",
                Points = profilePoints,
                Status = "completed"
            });
            breakdown.Score += profilePoints;
        }

        if (items.Count == 0)
        {
            items.Add(new ScoreItem
            {
                Description = "No evidence uploaded yet",
                Points = 0,
                Status = "missing"
            });
        }

        breakdown.Items = items;
        return breakdown;
    }

    private BehaviourBreakdown BuildBehaviourBreakdown(int reportsCount, int accountAgeDays)
    {
        var breakdown = new BehaviourBreakdown();
        var items = new List<ScoreItem>();

        // No safety reports (100 points base)
        if (reportsCount == 0)
        {
            items.Add(new ScoreItem
            {
                Description = "No verified safety reports",
                Points = 100,
                Status = "completed"
            });
            breakdown.Score += 100;
        }
        else
        {
            var deduction = Math.Min(reportsCount * 50, 100);
            items.Add(new ScoreItem
            {
                Description = $"{reportsCount} verified safety report{(reportsCount > 1 ? "s" : "")}",
                Points = -(deduction),
                Status = "warning"
            });
            breakdown.Score -= deduction;
        }

        // Account longevity (up to 100 points)
        if (accountAgeDays >= 365)
        {
            items.Add(new ScoreItem
            {
                Description = "Account active for 1+ year",
                Points = 100,
                Status = "completed"
            });
            breakdown.Score += 100;
        }
        else if (accountAgeDays >= 180)
        {
            items.Add(new ScoreItem
            {
                Description = "Account active for 6+ months",
                Points = 50,
                Status = "completed"
            });
            breakdown.Score += 50;
        }
        else if (accountAgeDays >= 90)
        {
            items.Add(new ScoreItem
            {
                Description = "Account active for 3+ months",
                Points = 25,
                Status = "completed"
            });
            breakdown.Score += 25;
        }

        // Consistent activity (100 points)
        items.Add(new ScoreItem
        {
            Description = "Regular account activity",
            Points = 100,
            Status = "completed"
        });
        breakdown.Score += 100;

        breakdown.Items = items;
        return breakdown;
    }

    private PeerBreakdown BuildPeerBreakdown(int mutualVerificationsCount)
    {
        var breakdown = new PeerBreakdown();
        var items = new List<ScoreItem>();

        // Mutual verifications (up to 200 points)
        if (mutualVerificationsCount > 0)
        {
            var peerPoints = Math.Min(mutualVerificationsCount * 20, 200);
            items.Add(new ScoreItem
            {
                Description = $"{mutualVerificationsCount} mutual verification{(mutualVerificationsCount > 1 ? "s" : "")}",
                Points = peerPoints,
                Status = "completed"
            });
            breakdown.Score += peerPoints;
        }
        else
        {
            items.Add(new ScoreItem
            {
                Description = "No mutual verifications yet",
                Points = 0,
                Status = "missing"
            });
        }

        breakdown.Items = items;
        return breakdown;
    }

    private async Task<UrsBreakdown> BuildUrsBreakdownAsync(Guid userId)
    {
        var breakdown = new UrsBreakdown();
        var items = new List<ScoreItem>();

        // Get all non-expired external ratings for this user
        var externalRatings = await _context.ExternalRatings
            .AsNoTracking()
            .Where(er => er.UserId == userId && er.ExpiresAt > DateTime.UtcNow)
            .ToListAsync();

        if (externalRatings.Count == 0)
        {
            items.Add(new ScoreItem
            {
                Description = "No verified platform ratings yet",
                Points = 0,
                Status = "missing"
            });
            breakdown.Items = items;
            return breakdown;
        }

        // Calculate weighted average URS
        // Formula: Sum(WeightedScore) / Sum(CombinedWeight) normalized to 0-200 scale
        decimal totalWeightedScore = externalRatings.Sum(er => er.WeightedScore);
        decimal totalWeight = externalRatings.Sum(er => er.CombinedWeight);

        decimal averageScore = totalWeight > 0 ? totalWeightedScore / totalWeight : 0;

        // Convert from 0-100 (normalized rating) to 0-200 (URS points)
        int ursPoints = (int)Math.Round((averageScore / 100.0m) * 200);
        breakdown.Score = Math.Min(ursPoints, 200); // Cap at 200

        // Add breakdown items for each platform
        var platformGroups = externalRatings.GroupBy(er => er.Platform);
        foreach (var group in platformGroups)
        {
            var platformRatings = group.ToList();
            var avgPlatformRating = platformRatings.Average(r => r.NormalizedRating);
            var totalReviews = platformRatings.Sum(r => r.ReviewCount);

            items.Add(new ScoreItem
            {
                Description = $"{group.Key}: {avgPlatformRating:F1}/100 rating ({totalReviews} reviews)",
                Points = (int)Math.Round((avgPlatformRating / 100.0m) * 50), // Max 50 points per platform shown
                Status = "completed"
            });
        }

        breakdown.Items = items;
        return breakdown;
    }

    private string GetTrustLabel(int score)
    {
        return score switch
        {
            >= 801 => "Very High Trust",
            >= 601 => "High Trust",
            >= 401 => "Moderate Trust",
            >= 201 => "Low Trust",
            _ => "High Risk"
        };
    }
}
