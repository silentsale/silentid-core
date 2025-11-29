using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Admin user model for SilentID Admin Panel.
/// Separate from regular User model to maintain clear separation of concerns.
/// Supports passwordless authentication via Passkey and Email OTP.
/// </summary>
public class AdminUser
{
    [Key]
    public Guid Id { get; set; } = Guid.NewGuid();

    [Required]
    [EmailAddress]
    [StringLength(255)]
    public string Email { get; set; } = string.Empty;

    [Required]
    [StringLength(100)]
    public string DisplayName { get; set; } = string.Empty;

    /// <summary>
    /// Admin role determines access level within the admin panel.
    /// </summary>
    public AdminRole Role { get; set; } = AdminRole.Support;

    /// <summary>
    /// Specific permissions that can override role defaults.
    /// Stored as JSON array of permission strings.
    /// </summary>
    [StringLength(2000)]
    public string? PermissionsJson { get; set; }

    /// <summary>
    /// Whether the admin account is currently active.
    /// </summary>
    public bool IsActive { get; set; } = true;

    /// <summary>
    /// Whether passkey authentication is enabled for this admin.
    /// </summary>
    public bool IsPasskeyEnabled { get; set; } = false;

    /// <summary>
    /// Last successful login timestamp.
    /// </summary>
    public DateTime? LastLoginAt { get; set; }

    /// <summary>
    /// Last login IP address.
    /// </summary>
    [StringLength(50)]
    public string? LastLoginIP { get; set; }

    /// <summary>
    /// Number of failed login attempts (for rate limiting).
    /// </summary>
    public int FailedLoginAttempts { get; set; } = 0;

    /// <summary>
    /// Lockout end time if account is temporarily locked.
    /// </summary>
    public DateTime? LockoutEndAt { get; set; }

    /// <summary>
    /// Who created this admin account.
    /// </summary>
    [StringLength(255)]
    public string? CreatedBy { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}

/// <summary>
/// Admin roles as defined in Section 28 of the specification.
/// Each role has different access levels within the admin panel.
/// </summary>
public enum AdminRole
{
    /// <summary>
    /// Read-only access plus light actions (e.g., adding notes).
    /// Cannot modify user accounts or make critical decisions.
    /// </summary>
    Support = 0,

    /// <summary>
    /// Can review and approve/reject verification requests.
    /// Can mark evidence as valid/invalid.
    /// </summary>
    VerificationSpecialist = 1,

    /// <summary>
    /// Can analyze TrustScore data and make trust-related decisions.
    /// Can recalculate TrustScores and review evidence.
    /// </summary>
    TrustAnalyst = 2,

    /// <summary>
    /// Can manage security alerts, review risk signals.
    /// Can freeze/unfreeze accounts based on security concerns.
    /// </summary>
    SecurityAnalyst = 3,

    /// <summary>
    /// Full access to all admin functionality.
    /// Can manage other admins, configure platform settings.
    /// Can promote Draft configs to Active (Section 48).
    /// </summary>
    SuperAdmin = 4
}

/// <summary>
/// Static class containing all admin permissions.
/// Used for fine-grained access control beyond roles.
/// </summary>
public static class AdminPermissions
{
    // User Management
    public const string ViewUsers = "users:view";
    public const string EditUsers = "users:edit";
    public const string SuspendUsers = "users:suspend";
    public const string DeleteUsers = "users:delete";

    // Evidence Management
    public const string ViewEvidence = "evidence:view";
    public const string ApproveEvidence = "evidence:approve";
    public const string RejectEvidence = "evidence:reject";
    public const string DeleteEvidence = "evidence:delete";

    // Trust Score
    public const string ViewTrustScores = "trustscore:view";
    public const string RecalculateTrustScores = "trustscore:recalculate";

    // Risk & Security
    public const string ViewRiskSignals = "risk:view";
    public const string ResolveRiskSignals = "risk:resolve";
    public const string ViewSecurityAlerts = "security:view";
    public const string ManageSecurityAlerts = "security:manage";

    // Reports
    public const string ViewReports = "reports:view";
    public const string DecideReports = "reports:decide";

    // Platform Configuration (Section 48)
    public const string ViewPlatformConfig = "platform:view";
    public const string EditPlatformConfig = "platform:edit";
    public const string PromotePlatformConfig = "platform:promote";
    public const string RollbackPlatformConfig = "platform:rollback";

    // Admin Management
    public const string ViewAdmins = "admins:view";
    public const string CreateAdmins = "admins:create";
    public const string EditAdmins = "admins:edit";
    public const string DeleteAdmins = "admins:delete";

    // Audit Logs
    public const string ViewAuditLogs = "audit:view";
    public const string ExportAuditLogs = "audit:export";

    /// <summary>
    /// Get default permissions for a given role.
    /// </summary>
    public static string[] GetDefaultPermissions(AdminRole role)
    {
        return role switch
        {
            AdminRole.Support => new[]
            {
                ViewUsers,
                ViewEvidence,
                ViewTrustScores,
                ViewRiskSignals,
                ViewReports,
                ViewPlatformConfig,
                ViewAuditLogs
            },
            AdminRole.VerificationSpecialist => new[]
            {
                ViewUsers,
                ViewEvidence, ApproveEvidence, RejectEvidence,
                ViewTrustScores,
                ViewRiskSignals,
                ViewReports,
                ViewPlatformConfig,
                ViewAuditLogs
            },
            AdminRole.TrustAnalyst => new[]
            {
                ViewUsers, EditUsers,
                ViewEvidence, ApproveEvidence, RejectEvidence,
                ViewTrustScores, RecalculateTrustScores,
                ViewRiskSignals, ResolveRiskSignals,
                ViewReports, DecideReports,
                ViewPlatformConfig,
                ViewAuditLogs
            },
            AdminRole.SecurityAnalyst => new[]
            {
                ViewUsers, EditUsers, SuspendUsers,
                ViewEvidence,
                ViewTrustScores,
                ViewRiskSignals, ResolveRiskSignals,
                ViewSecurityAlerts, ManageSecurityAlerts,
                ViewReports, DecideReports,
                ViewPlatformConfig,
                ViewAuditLogs
            },
            AdminRole.SuperAdmin => new[]
            {
                // All permissions
                ViewUsers, EditUsers, SuspendUsers, DeleteUsers,
                ViewEvidence, ApproveEvidence, RejectEvidence, DeleteEvidence,
                ViewTrustScores, RecalculateTrustScores,
                ViewRiskSignals, ResolveRiskSignals,
                ViewSecurityAlerts, ManageSecurityAlerts,
                ViewReports, DecideReports,
                ViewPlatformConfig, EditPlatformConfig, PromotePlatformConfig, RollbackPlatformConfig,
                ViewAdmins, CreateAdmins, EditAdmins, DeleteAdmins,
                ViewAuditLogs, ExportAuditLogs
            },
            _ => Array.Empty<string>()
        };
    }
}
