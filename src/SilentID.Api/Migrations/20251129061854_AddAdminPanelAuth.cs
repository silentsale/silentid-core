using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SilentID.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddAdminPanelAuth : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AdminUsers",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Email = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: false),
                    DisplayName = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    Role = table.Column<int>(type: "integer", nullable: false),
                    PermissionsJson = table.Column<string>(type: "character varying(2000)", maxLength: 2000, nullable: true),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    IsPasskeyEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    LastLoginAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    LastLoginIP = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    FailedLoginAttempts = table.Column<int>(type: "integer", nullable: false),
                    LockoutEndAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    CreatedBy = table.Column<string>(type: "character varying(255)", maxLength: 255, nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AdminUsers", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AdminPasskeyCredentials",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AdminUserId = table.Column<Guid>(type: "uuid", nullable: false),
                    CredentialId = table.Column<string>(type: "character varying(1024)", maxLength: 1024, nullable: false),
                    PublicKey = table.Column<string>(type: "text", nullable: false),
                    SignatureCounter = table.Column<long>(type: "bigint", nullable: false),
                    AaGuid = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    DeviceName = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    AttestationFormat = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    UserVerified = table.Column<bool>(type: "boolean", nullable: false),
                    CredentialType = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false, defaultValue: "public-key"),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    LastUsedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AdminPasskeyCredentials", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AdminPasskeyCredentials_AdminUsers_AdminUserId",
                        column: x => x.AdminUserId,
                        principalTable: "AdminUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AdminSessions",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    AdminUserId = table.Column<Guid>(type: "uuid", nullable: false),
                    RefreshTokenHash = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                    ExpiresAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    IPAddress = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: true),
                    UserAgent = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    AuthMethod = table.Column<int>(type: "integer", nullable: false),
                    LastActivityAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AdminSessions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AdminSessions_AdminUsers_AdminUserId",
                        column: x => x.AdminUserId,
                        principalTable: "AdminUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "AdminUsers",
                columns: new[] { "Id", "CreatedAt", "CreatedBy", "DisplayName", "Email", "FailedLoginAttempts", "IsActive", "IsPasskeyEnabled", "LastLoginAt", "LastLoginIP", "LockoutEndAt", "PermissionsJson", "Role", "UpdatedAt" },
                values: new object[] { new Guid("a0000000-0000-0000-0000-000000000001"), new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "System", "System Administrator", "admin@silentid.co.uk", 0, true, false, null, null, null, null, 4, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc) });

            migrationBuilder.CreateIndex(
                name: "IX_AdminPasskeyCredentials_AdminUserId",
                table: "AdminPasskeyCredentials",
                column: "AdminUserId");

            migrationBuilder.CreateIndex(
                name: "IX_AdminPasskeyCredentials_CredentialId",
                table: "AdminPasskeyCredentials",
                column: "CredentialId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AdminSessions_AdminUserId",
                table: "AdminSessions",
                column: "AdminUserId");

            migrationBuilder.CreateIndex(
                name: "IX_AdminSessions_RefreshTokenHash",
                table: "AdminSessions",
                column: "RefreshTokenHash");

            migrationBuilder.CreateIndex(
                name: "IX_AdminUsers_Email",
                table: "AdminUsers",
                column: "Email",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AdminPasskeyCredentials");

            migrationBuilder.DropTable(
                name: "AdminSessions");

            migrationBuilder.DropTable(
                name: "AdminUsers");
        }
    }
}
