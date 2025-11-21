using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace SilentID.Api.Models;

public class AuthDevice
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    public Guid UserId { get; set; }

    [Required]
    [StringLength(200)]
    public string DeviceId { get; set; } = string.Empty;

    [StringLength(100)]
    public string? DeviceModel { get; set; }

    [StringLength(50)]
    public string? OS { get; set; }

    [StringLength(50)]
    public string? Browser { get; set; }

    public DateTime LastUsedAt { get; set; } = DateTime.UtcNow;

    public bool IsTrusted { get; set; } = false;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Navigation property
    [ForeignKey(nameof(UserId))]
    public User User { get; set; } = null!;
}
