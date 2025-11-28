using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SilentID.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddSection52ProfileLinkFields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "LinkState",
                table: "ProfileLinkEvidences",
                type: "character varying(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<bool>(
                name: "ShowOnPassport",
                table: "ProfileLinkEvidences",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "Username",
                table: "ProfileLinkEvidences",
                type: "character varying(200)",
                maxLength: 200,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "LinkState",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "ShowOnPassport",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "Username",
                table: "ProfileLinkEvidences");
        }
    }
}
