using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SilentID.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddProfileLinkExtractionFields : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "ConsentConfirmedAt",
                table: "ProfileLinkEvidences",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ConsentIpAddress",
                table: "ProfileLinkEvidences",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "ExtractedAt",
                table: "ProfileLinkEvidences",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ExtractionConfidence",
                table: "ProfileLinkEvidences",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ExtractionMethod",
                table: "ProfileLinkEvidences",
                type: "character varying(50)",
                maxLength: 50,
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "HtmlExtractionMatch",
                table: "ProfileLinkEvidences",
                type: "boolean",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ManualScreenshotCount",
                table: "ProfileLinkEvidences",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "ManualScreenshotUrlsJson",
                table: "ProfileLinkEvidences",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "PlatformRating",
                table: "ProfileLinkEvidences",
                type: "numeric",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "ProfileJoinDate",
                table: "ProfileLinkEvidences",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ReviewCount",
                table: "ProfileLinkEvidences",
                type: "integer",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ConsentConfirmedAt",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "ConsentIpAddress",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "ExtractedAt",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "ExtractionConfidence",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "ExtractionMethod",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "HtmlExtractionMatch",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "ManualScreenshotCount",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "ManualScreenshotUrlsJson",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "PlatformRating",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "ProfileJoinDate",
                table: "ProfileLinkEvidences");

            migrationBuilder.DropColumn(
                name: "ReviewCount",
                table: "ProfileLinkEvidences");
        }
    }
}
