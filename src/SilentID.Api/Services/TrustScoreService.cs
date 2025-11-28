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

        // Section 52.7: Count Linked vs Verified profiles separately
        var linkedProfilesCount = await _context.ProfileLinkEvidences
            .Where(p => p.UserId == userId && p.EvidenceState == EvidenceState.Valid && p.LinkState == "Linked")
            .CountAsync();

        var verifiedProfilesCount = await _context.ProfileLinkEvidences
            .Where(p => p.UserId == userId && p.EvidenceState == EvidenceState.Valid && p.LinkState == "Verified")
            .CountAsync();

        var reportsCount = await _context.Reports
            .Where(r => r.ReportedUserId == userId && r.Status == ReportStatus.Verified)
            .CountAsync();

        var accountAgeDays = (DateTime.UtcNow - user.CreatedAt).Days;

        // Build breakdown (3 components: Identity 250, Evidence 400, Behaviour 350 = max 1000)
        var breakdown = new TrustScoreBreakdown
        {
            Identity = BuildIdentityBreakdown(user, identityVerification, accountAgeDays),
            Evidence = BuildEvidenceBreakdown(receiptsCount, screenshotsCount, linkedProfilesCount, verifiedProfilesCount),
            Behaviour = BuildBehaviourBreakdown(reportsCount, accountAgeDays)
        };

        // 3-component formula: Identity (250) + Evidence (400) + Behaviour (350) = max 1000
        // No normalization required
        breakdown.TotalScore = breakdown.Identity.Score + breakdown.Evidence.Score + breakdown.Behaviour.Score;
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
            PeerScore = 0, // Deprecated - kept for backwards compatibility
            UrsScore = 0,  // Deprecated - kept for backwards compatibility
            BreakdownJson = System.Text.Json.JsonSerializer.Serialize(breakdown),
            CreatedAt = DateTime.UtcNow
        };

        _context.TrustScoreSnapshots.Add(snapshot);
        await _context.SaveChangesAsync();

        _logger.LogInformation("TrustScore calculated for user {UserId}: {Score} (Identity:{Identity} Evidence:{Evidence} Behaviour:{Behaviour})",
            userId, snapshot.Score, snapshot.IdentityScore, snapshot.EvidenceScore, snapshot.BehaviourScore);

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

        // Email verification (50 points)
        if (user.IsEmailVerified)
        {
            items.Add(new ScoreItem
            {
                Description = "Email verified",
                Points = 50,
                Status = "completed"
            });
            breakdown.Score += 50;
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

        // Phone verification (30 points)
        if (user.IsPhoneVerified)
        {
            items.Add(new ScoreItem
            {
                Description = "Phone verified",
                Points = 30,
                Status = "completed"
            });
            breakdown.Score += 30;
        }

        // Account age (20 points)
        if (accountAgeDays >= 30)
        {
            items.Add(new ScoreItem
            {
                Description = "Account active for 30+ days",
                Points = 20,
                Status = "completed"
            });
            breakdown.Score += 20;
        }

        breakdown.Items = items;
        return breakdown;
    }

    private EvidenceBreakdown BuildEvidenceBreakdown(int receiptsCount, int screenshotsCount, int linkedProfilesCount, int verifiedProfilesCount)
    {
        var breakdown = new EvidenceBreakdown();
        var items = new List<ScoreItem>();

        // Receipts (up to 200 points)
        if (receiptsCount > 0)
        {
            var receiptPoints = Math.Min(receiptsCount * 5, 200);
            items.Add(new ScoreItem
            {
                Description = $"{receiptsCount} verified receipt{(receiptsCount > 1 ? "s" : "")}",
                Points = receiptPoints,
                Status = "completed"
            });
            breakdown.Score += receiptPoints;
        }

        // Screenshots (up to 120 points)
        if (screenshotsCount > 0)
        {
            var screenshotPoints = Math.Min(screenshotsCount * 10, 120);
            items.Add(new ScoreItem
            {
                Description = $"{screenshotsCount} verified screenshot{(screenshotsCount > 1 ? "s" : "")}",
                Points = screenshotPoints,
                Status = "completed"
            });
            breakdown.Score += screenshotPoints;
        }

        // Section 52.7: Connected Profiles - Linked (+8 each) and Verified (+20 each)
        // Maximum 80 points total from profile connections
        var totalProfilePoints = 0;

        // Verified profiles: +20 points each (Section 52.7)
        if (verifiedProfilesCount > 0)
        {
            var verifiedPoints = verifiedProfilesCount * 20;
            items.Add(new ScoreItem
            {
                Description = $"{verifiedProfilesCount} verified profile{(verifiedProfilesCount > 1 ? "s" : "")} (ownership confirmed)",
                Points = verifiedPoints,
                Status = "completed"
            });
            totalProfilePoints += verifiedPoints;
        }

        // Linked profiles: +8 points each (Section 52.7)
        if (linkedProfilesCount > 0)
        {
            var linkedPoints = linkedProfilesCount * 8;
            items.Add(new ScoreItem
            {
                Description = $"{linkedProfilesCount} linked profile{(linkedProfilesCount > 1 ? "s" : "")} (pending verification)",
                Points = linkedPoints,
                Status = "partial"
            });
            totalProfilePoints += linkedPoints;
        }

        // Cap profile points at 80 (per 3-component model)
        breakdown.Score += Math.Min(totalProfilePoints, 80);

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

        // No safety reports (150 points base)
        if (reportsCount == 0)
        {
            items.Add(new ScoreItem
            {
                Description = "No verified safety reports",
                Points = 150,
                Status = "completed"
            });
            breakdown.Score += 150;
        }
        else
        {
            var deduction = Math.Min(reportsCount * 75, 150);
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

    // NOTE: BuildPeerBreakdown and BuildUrsBreakdownAsync removed in 3-component model refactor
    // Peer (Mutual Verification) and URS components deprecated - scores set to 0 for backwards compatibility

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
