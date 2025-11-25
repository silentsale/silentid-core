using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SilentID.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddDigitalTrustPassportSystem : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "UrsScore",
                table: "TrustScoreSnapshots",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "EmailMetadataJson",
                table: "ReceiptEvidences",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ForwardingAlias",
                table: "ReceiptEvidences",
                type: "character varying(255)",
                maxLength: 255,
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "RawEmailDeleted",
                table: "ReceiptEvidences",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "NextReverifyAt",
                table: "ProfileLinkEvidences",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "OwnershipLockedAt",
                table: "ProfileLinkEvidences",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "SnapshotHash",
                table: "ProfileLinkEvidences",
                type: "character varying(64)",
                maxLength: 64,
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "VerificationLevel",
                table: "ProfileLinkEvidences",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "VerificationMethod",
                table: "ProfileLinkEvidences",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "VerificationToken",
                table: "ProfileLinkEvidences",
                type: "character varying(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.CreateTable(
                name: "ExternalRatings",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    ProfileLinkId = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    Platform = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    PlatformRating = table.Column<decimal>(type: "numeric", nullable: false),
                    ReviewCount = table.Column<int>(type: "integer", nullable: false),
                    AccountAge = table.Column<int>(type: "integer", nullable: false),
                    NormalizedRating = table.Column<decimal>(type: "numeric", nullable: false),
                    ReviewCountWeight = table.Column<decimal>(type: "numeric", nullable: false),
                    AccountAgeWeight = table.Column<decimal>(type: "numeric", nullable: false),
                    CombinedWeight = table.Column<decimal>(type: "numeric", nullable: false),
                    WeightedScore = table.Column<decimal>(type: "numeric", nullable: false),
                    ScrapedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    ExpiresAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ExternalRatings", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ExternalRatings_ProfileLinkEvidences_ProfileLinkId",
                        column: x => x.ProfileLinkId,
                        principalTable: "ProfileLinkEvidences",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ExternalRatings_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ExternalRatings_ProfileLinkId",
                table: "ExternalRatings",
                column: "ProfileLinkId");

            migrationBuilder.CreateIndex(
                name: "IX_ExternalRatings_UserId",
                table: "ExternalRatings",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ExternalRatings");

            migrationBuilder.DropColumn(
                name: "UrsScore",
                table: "TrustScoreSnapshots");

            migrationBuilder.DropColumn(
                name: "EmailMetadataJson",
                table: "ReceiptEvidences");

            migrationBuilder.DropColumn(
                name: "ForwardingAlias",
                table: "ReceiptEvidences");

            migrationBuilder.DropColumn(
                name: "RawEmailDeleted",
                table: "ReceiptEvidences");

            migrationBuilder.DropColumn(
                name: "NextReverifyAt",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "OwnershipLockedAt",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "SnapshotHash",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "VerificationLevel",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "VerificationMethod",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "VerificationToken",
                table: "ProfileLinkEvidences");
        }
    }
}
