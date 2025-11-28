using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SilentID.Api.Migrations
{
    /// <inheritdoc />
    public partial class RemoveMutualVerification : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "MutualVerifications");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "MutualVerifications",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    UserAId = table.Column<Guid>(type: "uuid", nullable: false),
                    UserBId = table.Column<Guid>(type: "uuid", nullable: false),
                    Amount = table.Column<decimal>(type: "numeric", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    Currency = table.Column<string>(type: "character varying(3)", maxLength: 3, nullable: false),
                    Date = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    EvidenceId = table.Column<Guid>(type: "uuid", nullable: true),
                    FraudFlag = table.Column<bool>(type: "boolean", nullable: false),
                    Item = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                    RoleA = table.Column<int>(type: "integer", nullable: false),
                    RoleB = table.Column<int>(type: "integer", nullable: false),
                    Status = table.Column<int>(type: "integer", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MutualVerifications", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MutualVerifications_Users_UserAId",
                        column: x => x.UserAId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_MutualVerifications_Users_UserBId",
                        column: x => x.UserBId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_MutualVerifications_UserAId",
                table: "MutualVerifications",
                column: "UserAId");

            migrationBuilder.CreateIndex(
                name: "IX_MutualVerifications_UserBId",
                table: "MutualVerifications",
                column: "UserBId");
        }
    }
}
