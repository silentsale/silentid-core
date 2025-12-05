using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Represents a platform incident (mass bans, shutdowns, issues).
/// Used for Pro feature: Platform Watchdog alerts.
/// </summary>
public class PlatformIncident
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    /// <summary>
    /// Affected platform (e.g., "Vinted", "eBay", "Depop").
    /// </summary>
    [Required]
    [MaxLength(50)]
    public string Platform { get; set; } = string.Empty;

    /// <summary>
    /// Type of incident.
    /// </summary>
    [Required]
    [MaxLength(50)]
    public string IncidentType { get; set; } = string.Empty; // e.g., "MassBan", "Shutdown", "Outage", "PolicyChange"

    /// <summary>
    /// Incident title/headline.
    /// </summary>
    [Required]
    [MaxLength(200)]
    public string Title { get; set; } = string.Empty;

    /// <summary>
    /// Detailed description of the incident.
    /// </summary>
    [MaxLength(2000)]
    public string? Description { get; set; }

    /// <summary>
    /// Severity level: Low, Medium, High, Critical.
    /// </summary>
    [Required]
    [MaxLength(20)]
    public string Severity { get; set; } = "Medium";

    /// <summary>
    /// Whether the incident is currently active.
    /// </summary>
    public bool IsActive { get; set; } = true;

    /// <summary>
    /// When the incident was first reported.
    /// </summary>
    public DateTime ReportedAt { get; set; } = DateTime.UtcNow;

    /// <summary>
    /// When the incident was resolved (if applicable).
    /// </summary>
    public DateTime? ResolvedAt { get; set; }

    /// <summary>
    /// Link to more information.
    /// </summary>
    [MaxLength(500)]
    public string? SourceUrl { get; set; }

    /// <summary>
    /// Estimated number of affected users (if known).
    /// </summary>
    public int? EstimatedAffectedUsers { get; set; }

    /// <summary>
    /// Geographic regions affected (comma-separated).
    /// </summary>
    [MaxLength(200)]
    public string? AffectedRegions { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}
