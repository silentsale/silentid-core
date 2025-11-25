using SilentID.Api.Models;

namespace SilentID.Api.Services;

public interface ITrustScoreService
{
    Task<TrustScoreSnapshot> GetCurrentTrustScoreAsync(Guid userId);
    Task<TrustScoreBreakdown> GetTrustScoreBreakdownAsync(Guid userId);
    Task<List<TrustScoreSnapshot>> GetTrustScoreHistoryAsync(Guid userId, int months = 6);
    Task<TrustScoreSnapshot> CalculateAndSaveTrustScoreAsync(Guid userId);
}

public class TrustScoreBreakdown
{
    public int TotalScore { get; set; }
    public string Label { get; set; } = string.Empty;
    public IdentityBreakdown Identity { get; set; } = new();
    public EvidenceBreakdown Evidence { get; set; } = new();
    public BehaviourBreakdown Behaviour { get; set; } = new();
    public PeerBreakdown Peer { get; set; } = new();
    public UrsBreakdown Urs { get; set; } = new(); // Section 47: URS component
}

public class IdentityBreakdown
{
    public int Score { get; set; }
    public int MaxScore { get; set; } = 200;
    public List<ScoreItem> Items { get; set; } = new();
}

public class EvidenceBreakdown
{
    public int Score { get; set; }
    public int MaxScore { get; set; } = 300;
    public List<ScoreItem> Items { get; set; } = new();
}

public class BehaviourBreakdown
{
    public int Score { get; set; }
    public int MaxScore { get; set; } = 300;
    public List<ScoreItem> Items { get; set; } = new();
}

public class PeerBreakdown
{
    public int Score { get; set; }
    public int MaxScore { get; set; } = 200;
    public List<ScoreItem> Items { get; set; } = new();
}

public class UrsBreakdown
{
    public int Score { get; set; }
    public int MaxScore { get; set; } = 200;
    public List<ScoreItem> Items { get; set; } = new();
}

public class ScoreItem
{
    public string Description { get; set; } = string.Empty;
    public int Points { get; set; }
    public string Status { get; set; } = string.Empty; // "completed", "warning", "missing"
}
