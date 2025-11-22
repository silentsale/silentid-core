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

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // User configuration
        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.HasIndex(e => e.Email).IsUnique();
            entity.HasIndex(e => e.Username).IsUnique();

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
    }
}
