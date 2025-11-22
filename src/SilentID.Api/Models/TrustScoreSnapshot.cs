using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Historical snapshot of user's TrustScore calculation.
/// Recalculated weekly and stored for history/trend analysis.
/// </summary>
public class TrustScoreSnapshot
{
    [Key]
    public Guid Id { get; set; }

    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    /// <summary>
    /// Total TrustScore (0-1000).
    /// </summary>
    public int Score { get; set; }

    /// <summary>
    /// Identity component score (0-200).
    /// </summary>
    public int IdentityScore { get; set; }

    /// <summary>
    /// Evidence component score (0-300).
    /// </summary>
    public int EvidenceScore { get; set; }

    /// <summary>
    /// Behaviour component score (0-300).
    /// </summary>
    public int BehaviourScore { get; set; }

    /// <summary>
    /// Peer verification component score (0-200).
    /// </summary>
    public int PeerScore { get; set; }

    /// <summary>
    /// Detailed breakdown as JSON (reasons, contributing factors, etc.).
    /// </summary>
    public string? BreakdownJson { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
