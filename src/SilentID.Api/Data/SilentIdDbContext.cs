using Microsoft.EntityFrameworkCore;
using SilentID.Api.Models;

namespace SilentID.Api.Data;

public class SilentIdDbContext : DbContext
{
    public SilentIdDbContext(DbContextOptions<SilentIdDbContext> options)
        : base(options)
    {
    }

    // Core tables
    public DbSet<User> Users { get; set; } = null!;
    public DbSet<Session> Sessions { get; set; } = null!;
    public DbSet<AuthDevice> AuthDevices { get; set; } = null!;
    public DbSet<IdentityVerification> IdentityVerifications { get; set; } = null!;

    // Evidence tables
    public DbSet<ReceiptEvidence> ReceiptEvidences { get; set; } = null!;
    public DbSet<ScreenshotEvidence> ScreenshotEvidences { get; set; } = null!;
    public DbSet<ProfileLinkEvidence> ProfileLinkEvidences { get; set; } = null!;
    public DbSet<ExternalRating> ExternalRatings { get; set; } = null!;

    // Trust & verification tables
    public DbSet<MutualVerification> MutualVerifications { get; set; } = null!;
    public DbSet<TrustScoreSnapshot> TrustScoreSnapshots { get; set; } = null!;

    // Risk & safety tables
    public DbSet<RiskSignal> RiskSignals { get; set; } = null!;
    public DbSet<Report> Reports { get; set; } = null!;
    public DbSet<ReportEvidence> ReportEvidences { get; set; } = null!;

    // Subscription & admin tables
    public DbSet<Subscription> Subscriptions { get; set; } = null!;
    public DbSet<AdminAuditLog> AdminAuditLogs { get; set; } = null!;

    // Security Center tables
    public DbSet<SecurityAlert> SecurityAlerts { get; set; } = null!;

    // Passkey/WebAuthn tables
    public DbSet<PasskeyCredential> PasskeyCredentials { get; set; } = null!;

    // Platform configuration tables (Section 48)
    public DbSet<PlatformConfiguration> PlatformConfigurations { get; set; } = null!;

    // Referral tables (Section 50.6.1)
    public DbSet<Referral> Referrals { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // User configuration
        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.Email).IsUnique();
            entity.HasIndex(e => e.Username).IsUnique();
            entity.HasIndex(e => e.ReferralCode).IsUnique();

            entity.Property(e => e.Email)
                .IsRequired()
                .HasMaxLength(255);

            entity.Property(e => e.Username)
                .IsRequired()
                .HasMaxLength(100);

            entity.Property(e => e.DisplayName)
                .IsRequired()
                .HasMaxLength(100);

            // Relationships
            entity.HasMany(e => e.Sessions)
                .WithOne(e => e.User)
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            entity.HasMany(e => e.AuthDevices)
                .WithOne(e => e.User)
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // Session configuration
        modelBuilder.Entity<Session>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.RefreshTokenHash);
            entity.HasIndex(e => e.UserId);

            entity.Property(e => e.RefreshTokenHash)
                .IsRequired()
                .HasMaxLength(500);
        });

        // AuthDevice configuration
        modelBuilder.Entity<AuthDevice>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);
            entity.HasIndex(e => e.DeviceId);

            entity.Property(e => e.DeviceId)
                .IsRequired()
                .HasMaxLength(200);
        });

        // IdentityVerification configuration
        modelBuilder.Entity<IdentityVerification>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);
            entity.HasIndex(e => e.StripeVerificationId);

            entity.Property(e => e.StripeVerificationId)
                .IsRequired()
                .HasMaxLength(255);

            // One-to-One relationship with User
            entity.HasOne(e => e.User)
                .WithOne()
                .HasForeignKey<IdentityVerification>(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // ReceiptEvidence configuration
        modelBuilder.Entity<ReceiptEvidence>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);
            entity.HasIndex(e => e.RawHash);

            entity.HasOne(e => e.User)
                .WithMany()
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // ScreenshotEvidence configuration
        modelBuilder.Entity<ScreenshotEvidence>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);

            entity.HasOne(e => e.User)
                .WithMany()
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // ProfileLinkEvidence configuration
        modelBuilder.Entity<ProfileLinkEvidence>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);

            entity.HasOne(e => e.User)
                .WithMany()
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // MutualVerification configuration
        modelBuilder.Entity<MutualVerification>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserAId);
            entity.HasIndex(e => e.UserBId);

            entity.HasOne(e => e.UserA)
                .WithMany()
                .HasForeignKey(e => e.UserAId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(e => e.UserB)
                .WithMany()
                .HasForeignKey(e => e.UserBId)
                .OnDelete(DeleteBehavior.Restrict);
        });

        // TrustScoreSnapshot configuration
        modelBuilder.Entity<TrustScoreSnapshot>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);
            entity.HasIndex(e => e.CreatedAt);

            entity.HasOne(e => e.User)
                .WithMany()
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // RiskSignal configuration
        modelBuilder.Entity<RiskSignal>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);
            entity.HasIndex(e => e.Type);

            entity.HasOne(e => e.User)
                .WithMany()
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // Report configuration
        modelBuilder.Entity<Report>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.ReporterId);
            entity.HasIndex(e => e.ReportedUserId);
            entity.HasIndex(e => e.Status);

            entity.HasOne(e => e.Reporter)
                .WithMany()
                .HasForeignKey(e => e.ReporterId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(e => e.ReportedUser)
                .WithMany()
                .HasForeignKey(e => e.ReportedUserId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasMany(e => e.Evidence)
                .WithOne(e => e.Report)
                .HasForeignKey(e => e.ReportId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // ReportEvidence configuration
        modelBuilder.Entity<ReportEvidence>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.ReportId);
        });

        // Subscription configuration
        modelBuilder.Entity<Subscription>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);
            entity.HasIndex(e => e.StripeSubscriptionId);

            entity.HasOne(e => e.User)
                .WithMany()
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // AdminAuditLog configuration
        modelBuilder.Entity<AdminAuditLog>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.AdminUser);
            entity.HasIndex(e => e.TargetUserId);
            entity.HasIndex(e => e.CreatedAt);
        });

        // SecurityAlert configuration
        modelBuilder.Entity<SecurityAlert>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);
            entity.HasIndex(e => e.Type);
            entity.HasIndex(e => e.IsRead);

            entity.HasOne(e => e.User)
                .WithMany()
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // PasskeyCredential configuration
        modelBuilder.Entity<PasskeyCredential>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.UserId);
            entity.HasIndex(e => e.CredentialId).IsUnique();

            entity.Property(e => e.CredentialId)
                .IsRequired()
                .HasMaxLength(1024);

            entity.Property(e => e.PublicKey)
                .IsRequired();

            entity.Property(e => e.CredentialType)
                .HasMaxLength(50)
                .HasDefaultValue("public-key");

            entity.HasOne(e => e.User)
                .WithMany()
                .HasForeignKey(e => e.UserId)
                .OnDelete(DeleteBehavior.Cascade);
        });

        // PlatformConfiguration configuration & seed data
        modelBuilder.Entity<PlatformConfiguration>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.PlatformId).IsUnique();
            entity.HasIndex(e => e.Domain);

            // Seed initial platform configurations
            // Verification methods: ShareIntent (PRIMARY), TokenInBio (SECONDARY)
            entity.HasData(
                new PlatformConfiguration
                {
                    Id = Guid.Parse("11111111-1111-1111-1111-111111111111"),
                    PlatformId = "vinted-uk",
                    DisplayName = "Vinted UK",
                    Domain = "vinted.co.uk",
                    LogoUrl = "https://assets.vinted.com/logo.png",
                    BrandColor = "#09B1BA",
                    Status = PlatformStatus.Active,
                    RatingSourceMode = RatingSourceMode.ScreenshotPlusHtml,
                    UrlPatternsJson = "[\"https?://(?:www\\\\.)?vinted\\\\.co\\\\.uk/member/([^/]+)\"]",
                    ShareIntentPatternsJson = "[\"vinted://member/([^/]+)\"]",
                    VerificationMethodsJson = "[\"ShareIntent\",\"TokenInBio\"]",
                    BioFieldSelector = "div[data-testid='user-about'] p",
                    RatingSelectorsJson = "[{\"priority\":1,\"selector\":\"div[data-testid='user-rating'] span\",\"type\":\"css\"}]",
                    ReviewCountSelectorsJson = "[{\"priority\":1,\"selector\":\"span[data-testid='review-count']\",\"type\":\"css\"}]",
                    UsernameSelectorsJson = "[{\"priority\":1,\"selector\":\"h1[data-testid='username']\",\"type\":\"css\"}]",
                    RatingMax = 5.0m,
                    RatingFormat = RatingFormat.Stars,
                    RateLimitPerMinute = 10,
                    BackoffStrategy = BackoffStrategy.Exponential,
                    SelectorVersion = 1,
                    CreatedAt = new DateTime(2025, 1, 1, 0, 0, 0, DateTimeKind.Utc),
                    UpdatedAt = new DateTime(2025, 1, 1, 0, 0, 0, DateTimeKind.Utc)
                },
                new PlatformConfiguration
                {
                    Id = Guid.Parse("22222222-2222-2222-2222-222222222222"),
                    PlatformId = "ebay-uk",
                    DisplayName = "eBay UK",
                    Domain = "ebay.co.uk",
                    LogoUrl = "https://ir.ebaystatic.com/logo.png",
                    BrandColor = "#E53238",
                    Status = PlatformStatus.Active,
                    RatingSourceMode = RatingSourceMode.ScreenshotPlusHtml,
                    UrlPatternsJson = "[\"https?://(?:www\\\\.)?ebay\\\\.co\\\\.uk/usr/([^/?]+)\"]",
                    ShareIntentPatternsJson = "[\"ebay://user/([^/]+)\"]",
                    VerificationMethodsJson = "[\"ShareIntent\",\"TokenInBio\"]",
                    BioFieldSelector = "div.bio span.desc",
                    RatingSelectorsJson = "[{\"priority\":1,\"selector\":\"span.star-rating span.num\",\"type\":\"css\"}]",
                    ReviewCountSelectorsJson = "[{\"priority\":1,\"selector\":\"span.reviews a\",\"type\":\"css\"}]",
                    UsernameSelectorsJson = "[{\"priority\":1,\"selector\":\"h1.usr-id\",\"type\":\"css\"}]",
                    RatingMax = 100.0m,
                    RatingFormat = RatingFormat.Percentage,
                    RateLimitPerMinute = 10,
                    BackoffStrategy = BackoffStrategy.Exponential,
                    SelectorVersion = 1,
                    CreatedAt = new DateTime(2025, 1, 1, 0, 0, 0, DateTimeKind.Utc),
                    UpdatedAt = new DateTime(2025, 1, 1, 0, 0, 0, DateTimeKind.Utc)
                },
                new PlatformConfiguration
                {
                    Id = Guid.Parse("33333333-3333-3333-3333-333333333333"),
                    PlatformId = "depop",
                    DisplayName = "Depop",
                    Domain = "depop.com",
                    LogoUrl = "https://assets.depop.com/logo.png",
                    BrandColor = "#FF2300",
                    Status = PlatformStatus.Active,
                    RatingSourceMode = RatingSourceMode.ScreenshotPlusHtml,
                    UrlPatternsJson = "[\"https?://(?:www\\\\.)?depop\\\\.com/([^/?]+)\"]",
                    ShareIntentPatternsJson = "[\"depop://user/([^/]+)\"]",
                    VerificationMethodsJson = "[\"ShareIntent\",\"TokenInBio\"]",
                    BioFieldSelector = "p[data-testid='sellerBio']",
                    RatingSelectorsJson = "[{\"priority\":1,\"selector\":\"div[data-testid='seller-reviews'] span\",\"type\":\"css\"}]",
                    ReviewCountSelectorsJson = "[{\"priority\":1,\"selector\":\"span[data-testid='reviews-count']\",\"type\":\"css\"}]",
                    UsernameSelectorsJson = "[{\"priority\":1,\"selector\":\"h1[data-testid='username']\",\"type\":\"css\"}]",
                    RatingMax = 5.0m,
                    RatingFormat = RatingFormat.Stars,
                    RateLimitPerMinute = 10,
                    BackoffStrategy = BackoffStrategy.Exponential,
                    SelectorVersion = 1,
                    CreatedAt = new DateTime(2025, 1, 1, 0, 0, 0, DateTimeKind.Utc),
                    UpdatedAt = new DateTime(2025, 1, 1, 0, 0, 0, DateTimeKind.Utc)
                },
                new PlatformConfiguration
                {
                    Id = Guid.Parse("44444444-4444-4444-4444-444444444444"),
                    PlatformId = "facebook-marketplace",
                    DisplayName = "Facebook Marketplace",
                    Domain = "facebook.com",
                    LogoUrl = "https://static.xx.fbcdn.net/logo.png",
                    BrandColor = "#1877F2",
                    Status = PlatformStatus.Active,
                    RatingSourceMode = RatingSourceMode.ScreenshotPlusHtml,
                    UrlPatternsJson = "[\"https?://(?:www\\\\.)?facebook\\\\.com/marketplace/profile/([0-9]+)\"]",
                    ShareIntentPatternsJson = "[\"fb://marketplace/profile/([0-9]+)\"]",
                    VerificationMethodsJson = "[\"ShareIntent\"]",
                    RatingSelectorsJson = "[{\"priority\":1,\"selector\":\"span[data-testid='rating-value']\",\"type\":\"css\"}]",
                    ReviewCountSelectorsJson = "[{\"priority\":1,\"selector\":\"span[data-testid='rating-count']\",\"type\":\"css\"}]",
                    RatingMax = 5.0m,
                    RatingFormat = RatingFormat.Stars,
                    RateLimitPerMinute = 5,
                    BackoffStrategy = BackoffStrategy.Exponential,
                    SelectorVersion = 1,
                    CreatedAt = new DateTime(2025, 1, 1, 0, 0, 0, DateTimeKind.Utc),
                    UpdatedAt = new DateTime(2025, 1, 1, 0, 0, 0, DateTimeKind.Utc)
                },
                new PlatformConfiguration
                {
                    Id = Guid.Parse("55555555-5555-5555-5555-555555555555"),
                    PlatformId = "poshmark",
                    DisplayName = "Poshmark",
                    Domain = "poshmark.com",
                    LogoUrl = "https://assets.poshmark.com/logo.png",
                    BrandColor = "#7F0353",
                    Status = PlatformStatus.Active,
                    RatingSourceMode = RatingSourceMode.ScreenshotPlusHtml,
                    UrlPatternsJson = "[\"https?://(?:www\\\\.)?poshmark\\\\.com/closet/([^/?]+)\"]",
                    ShareIntentPatternsJson = "[\"poshmark://closet/([^/]+)\"]",
                    VerificationMethodsJson = "[\"ShareIntent\",\"TokenInBio\"]",
                    BioFieldSelector = "div.about-section p",
                    RatingSelectorsJson = "[{\"priority\":1,\"selector\":\"span.love-count\",\"type\":\"css\"}]",
                    UsernameSelectorsJson = "[{\"priority\":1,\"selector\":\"h1.closet-title\",\"type\":\"css\"}]",
                    RatingMax = 5.0m,
                    RatingFormat = RatingFormat.Stars,
                    RateLimitPerMinute = 10,
                    BackoffStrategy = BackoffStrategy.Exponential,
                    SelectorVersion = 1,
                    CreatedAt = new DateTime(2025, 1, 1, 0, 0, 0, DateTimeKind.Utc),
                    UpdatedAt = new DateTime(2025, 1, 1, 0, 0, 0, DateTimeKind.Utc)
                },
                new PlatformConfiguration
                {
                    Id = Guid.Parse("66666666-6666-6666-6666-666666666666"),
                    PlatformId = "etsy",
                    DisplayName = "Etsy",
                    Domain = "etsy.com",
                    LogoUrl = "https://www.etsy.com/logo.png",
                    BrandColor = "#F56400",
                    Status = PlatformStatus.Active,
                    RatingSourceMode = RatingSourceMode.ScreenshotPlusHtml,
                    UrlPatternsJson = "[\"https?://(?:www\\\\.)?etsy\\\\.com/shop/([^/?]+)\"]",
                    ShareIntentPatternsJson = "[\"etsy://shop/([^/]+)\"]",
                    VerificationMethodsJson = "[\"ShareIntent\",\"TokenInBio\"]",
                    BioFieldSelector = "div.shop-info p.announcement",
                    RatingSelectorsJson = "[{\"priority\":1,\"selector\":\"span[data-reviews-rating]\",\"type\":\"css\"}]",
                    ReviewCountSelectorsJson = "[{\"priority\":1,\"selector\":\"span.reviews-count\",\"type\":\"css\"}]",
                    UsernameSelectorsJson = "[{\"priority\":1,\"selector\":\"h1.shop-name\",\"type\":\"css\"}]",
                    RatingMax = 5.0m,
                    RatingFormat = RatingFormat.Stars,
                    RateLimitPerMinute = 10,
                    BackoffStrategy = BackoffStrategy.Exponential,
                    SelectorVersion = 1,
                    CreatedAt = new DateTime(2025, 1, 1, 0, 0, 0, DateTimeKind.Utc),
                    UpdatedAt = new DateTime(2025, 1, 1, 0, 0, 0, DateTimeKind.Utc)
                }
            );
        });

        // Referral configuration (Section 50.6.1)
        modelBuilder.Entity<Referral>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.ReferrerId);
            entity.HasIndex(e => e.RefereeId);
            entity.HasIndex(e => e.ReferralCode);
            entity.HasIndex(e => e.Status);

            entity.Property(e => e.ReferralCode)
                .IsRequired()
                .HasMaxLength(20);

            entity.HasOne(e => e.Referrer)
                .WithMany()
                .HasForeignKey(e => e.ReferrerId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasOne(e => e.Referee)
                .WithMany()
                .HasForeignKey(e => e.RefereeId)
                .OnDelete(DeleteBehavior.Restrict);
        });
    }
}
