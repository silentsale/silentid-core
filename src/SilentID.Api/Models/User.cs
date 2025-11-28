using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

public class User
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    [EmailAddress]
    [StringLength(255)]
    public string Email { get; set; } = string.Empty;

    [Required]
    [StringLength(100)]
    public string Username { get; set; } = string.Empty;

    [Required]
    [StringLength(100)]
    public string DisplayName { get; set; } = string.Empty;

    [StringLength(20)]
    public string? PhoneNumber { get; set; }

    public bool IsEmailVerified { get; set; } = false;
    public bool IsPhoneVerified { get; set; } = false;
    public bool IsPasskeyEnabled { get; set; } = false;

    // OAuth Provider IDs (for account unification)
    [StringLength(255)]
    public string? AppleUserId { get; set; }

    [StringLength(255)]
    public string? GoogleUserId { get; set; }

    public AccountStatus AccountStatus { get; set; } = AccountStatus.Active;
    public AccountType AccountType { get; set; } = AccountType.Free;

    [StringLength(50)]
    public string? SignupIP { get; set; }

    [StringLength(200)]
    public string? SignupDeviceId { get; set; }

    // Section 50.6.1 - Referral Program
    /// <summary>
    /// User's unique referral code (8-character alphanumeric)
    /// </summary>
    [StringLength(20)]
    public string? ReferralCode { get; set; }

    /// <summary>
    /// The referral code used when this user signed up (if any)
    /// </summary>
    [StringLength(20)]
    public string? ReferredByCode { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

    // Navigation properties
    public ICollection<Session> Sessions { get; set; } = new List<Session>();
    public ICollection<AuthDevice> AuthDevices { get; set; } = new List<AuthDevice>();
}

public enum AccountStatus
{
    Active,
    Suspended,
    UnderReview
}

public enum AccountType
{
    Free,
    Premium,
    Pro,
    Admin
}
