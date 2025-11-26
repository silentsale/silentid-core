using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SilentID.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddPlatformConfiguration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "PasskeyCredentials",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    CredentialId = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    PublicKey = table.Column<string>(type: "text", nullable: false),
                    SignatureCounter = table.Column<long>(type: "bigint", nullable: false),
                    AaGuid = table.Column<string>(type: "character varying(36)", maxLength: 36, nullable: true),
                    DeviceName = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    CredentialType = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false, defaultValue: "public-key"),
                    AttestationFormat = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    UserVerified = table.Column<bool>(type: "boolean", nullable: false),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    LastUsedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PasskeyCredentials", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PasskeyCredentials_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PlatformConfigurations",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    PlatformId = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    DisplayName = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Domain = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    LogoUrl = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    BrandColor = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: true),
                    Status = table.Column<int>(type: "integer", nullable: false),
                    RatingSourceMode = table.Column<int>(type: "integer", nullable: false),
                    UrlPatternsJson = table.Column<string>(type: "text", nullable: true),
                    ShareIntentPatternsJson = table.Column<string>(type: "text", nullable: true),
                    VerificationMethodsJson = table.Column<string>(type: "text", nullable: true),
                    BioFieldSelector = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    BioFieldXPath = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    RatingSelectorsJson = table.Column<string>(type: "text", nullable: true),
                    ReviewCountSelectorsJson = table.Column<string>(type: "text", nullable: true),
                    UsernameSelectorsJson = table.Column<string>(type: "text", nullable: true),
                    JoinDateSelectorsJson = table.Column<string>(type: "text", nullable: true),
                    RatingMax = table.Column<decimal>(type: "numeric", nullable: false),
                    RatingFormat = table.Column<int>(type: "integer", nullable: false),
                    ApiConfigJson = table.Column<string>(type: "text", nullable: true),
                    RateLimitPerMinute = table.Column<int>(type: "integer", nullable: false),
                    BackoffStrategy = table.Column<int>(type: "integer", nullable: false),
                    AvgConfidenceScore = table.Column<decimal>(type: "numeric", nullable: true),
                    LastExtractionAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    SelectorVersion = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PlatformConfigurations", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_PasskeyCredentials_CredentialId",
                table: "PasskeyCredentials",
                column: "CredentialId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_PasskeyCredentials_UserId",
                table: "PasskeyCredentials",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PasskeyCredentials");

            migrationBuilder.DropTable(
                name: "PlatformConfigurations");
        }
    }
}
