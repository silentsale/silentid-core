using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace SilentID.Api.Migrations
{
    /// <inheritdoc />
    public partial class SeedPlatformConfigurations : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "PlatformConfigurations",
                columns: new[] { "Id", "ApiConfigJson", "AvgConfidenceScore", "BackoffStrategy", "BioFieldSelector", "BioFieldXPath", "BrandColor", "CreatedAt", "DisplayName", "Domain", "JoinDateSelectorsJson", "LastExtractionAt", "LogoUrl", "PlatformId", "RateLimitPerMinute", "RatingFormat", "RatingMax", "RatingSelectorsJson", "RatingSourceMode", "ReviewCountSelectorsJson", "SelectorVersion", "ShareIntentPatternsJson", "Status", "UpdatedAt", "UrlPatternsJson", "UsernameSelectorsJson", "VerificationMethodsJson" },
                values: new object[,]
                {
                    { new Guid("11111111-1111-1111-1111-111111111111"), null, null, 0, "div[data-testid='user-about'] p", null, "#09B1BA", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "Vinted UK", "vinted.co.uk", null, null, "https://assets.vinted.com/logo.png", "vinted-uk", 10, 0, 5.0m, "[{\"priority\":1,\"selector\":\"div[data-testid='user-rating'] span\",\"type\":\"css\"}]", 1, "[{\"priority\":1,\"selector\":\"span[data-testid='review-count']\",\"type\":\"css\"}]", 1, "[\"vinted://member/([^/]+)\"]", 0, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "[\"https?://(?:www\\\\.)?vinted\\\\.co\\\\.uk/member/([^/]+)\"]", "[{\"priority\":1,\"selector\":\"h1[data-testid='username']\",\"type\":\"css\"}]", "[\"ShareIntent\",\"TokenInBio\"]" },
                    { new Guid("22222222-2222-2222-2222-222222222222"), null, null, 0, "div.bio span.desc", null, "#E53238", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "eBay UK", "ebay.co.uk", null, null, "https://ir.ebaystatic.com/logo.png", "ebay-uk", 10, 1, 100.0m, "[{\"priority\":1,\"selector\":\"span.star-rating span.num\",\"type\":\"css\"}]", 1, "[{\"priority\":1,\"selector\":\"span.reviews a\",\"type\":\"css\"}]", 1, "[\"ebay://user/([^/]+)\"]", 0, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "[\"https?://(?:www\\\\.)?ebay\\\\.co\\\\.uk/usr/([^/?]+)\"]", "[{\"priority\":1,\"selector\":\"h1.usr-id\",\"type\":\"css\"}]", "[\"ShareIntent\",\"TokenInBio\"]" },
                    { new Guid("33333333-3333-3333-3333-333333333333"), null, null, 0, "p[data-testid='sellerBio']", null, "#FF2300", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "Depop", "depop.com", null, null, "https://assets.depop.com/logo.png", "depop", 10, 0, 5.0m, "[{\"priority\":1,\"selector\":\"div[data-testid='seller-reviews'] span\",\"type\":\"css\"}]", 1, "[{\"priority\":1,\"selector\":\"span[data-testid='reviews-count']\",\"type\":\"css\"}]", 1, "[\"depop://user/([^/]+)\"]", 0, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "[\"https?://(?:www\\\\.)?depop\\\\.com/([^/?]+)\"]", "[{\"priority\":1,\"selector\":\"h1[data-testid='username']\",\"type\":\"css\"}]", "[\"ShareIntent\",\"TokenInBio\"]" },
                    { new Guid("44444444-4444-4444-4444-444444444444"), null, null, 0, null, null, "#1877F2", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "Facebook Marketplace", "facebook.com", null, null, "https://static.xx.fbcdn.net/logo.png", "facebook-marketplace", 5, 0, 5.0m, "[{\"priority\":1,\"selector\":\"span[data-testid='rating-value']\",\"type\":\"css\"}]", 1, "[{\"priority\":1,\"selector\":\"span[data-testid='rating-count']\",\"type\":\"css\"}]", 1, "[\"fb://marketplace/profile/([0-9]+)\"]", 0, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "[\"https?://(?:www\\\\.)?facebook\\\\.com/marketplace/profile/([0-9]+)\"]", null, "[\"ShareIntent\"]" },
                    { new Guid("55555555-5555-5555-5555-555555555555"), null, null, 0, "div.about-section p", null, "#7F0353", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "Poshmark", "poshmark.com", null, null, "https://assets.poshmark.com/logo.png", "poshmark", 10, 0, 5.0m, "[{\"priority\":1,\"selector\":\"span.love-count\",\"type\":\"css\"}]", 1, null, 1, "[\"poshmark://closet/([^/]+)\"]", 0, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "[\"https?://(?:www\\\\.)?poshmark\\\\.com/closet/([^/?]+)\"]", "[{\"priority\":1,\"selector\":\"h1.closet-title\",\"type\":\"css\"}]", "[\"ShareIntent\",\"TokenInBio\"]" },
                    { new Guid("66666666-6666-6666-6666-666666666666"), null, null, 0, "div.shop-info p.announcement", null, "#F56400", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "Etsy", "etsy.com", null, null, "https://www.etsy.com/logo.png", "etsy", 10, 0, 5.0m, "[{\"priority\":1,\"selector\":\"span[data-reviews-rating]\",\"type\":\"css\"}]", 1, "[{\"priority\":1,\"selector\":\"span.reviews-count\",\"type\":\"css\"}]", 1, "[\"etsy://shop/([^/]+)\"]", 0, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc), "[\"https?://(?:www\\\\.)?etsy\\\\.com/shop/([^/?]+)\"]", "[{\"priority\":1,\"selector\":\"h1.shop-name\",\"type\":\"css\"}]", "[\"ShareIntent\",\"TokenInBio\"]" }
                });

            migrationBuilder.CreateIndex(
                name: "IX_PlatformConfigurations_Domain",
                table: "PlatformConfigurations",
                column: "Domain");

            migrationBuilder.CreateIndex(
                name: "IX_PlatformConfigurations_PlatformId",
                table: "PlatformConfigurations",
                column: "PlatformId",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_PlatformConfigurations_Domain",
                table: "PlatformConfigurations");

            migrationBuilder.DropIndex(
                name: "IX_PlatformConfigurations_PlatformId",
                table: "PlatformConfigurations");

            migrationBuilder.DeleteData(
                table: "PlatformConfigurations",
                keyColumn: "Id",
                keyValue: new Guid("11111111-1111-1111-1111-111111111111"));

            migrationBuilder.DeleteData(
                table: "PlatformConfigurations",
                keyColumn: "Id",
                keyValue: new Guid("22222222-2222-2222-2222-222222222222"));

            migrationBuilder.DeleteData(
                table: "PlatformConfigurations",
                keyColumn: "Id",
                keyValue: new Guid("33333333-3333-3333-3333-333333333333"));

            migrationBuilder.DeleteData(
                table: "PlatformConfigurations",
                keyColumn: "Id",
                keyValue: new Guid("44444444-4444-4444-4444-444444444444"));

            migrationBuilder.DeleteData(
                table: "PlatformConfigurations",
                keyColumn: "Id",
                keyValue: new Guid("55555555-5555-5555-5555-555555555555"));

            migrationBuilder.DeleteData(
                table: "PlatformConfigurations",
                keyColumn: "Id",
                keyValue: new Guid("66666666-6666-6666-6666-666666666666"));
        }
    }
}
