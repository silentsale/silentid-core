using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

public interface IReceiptParsingService
{
    /// <summary>
    /// Processes an inbound email from SendGrid webhook.
    /// </summary>
    Task<ReceiptParseResult> ProcessInboundEmailAsync(InboundEmailData emailData);

    /// <summary>
    /// Gets all receipts for a user.
    /// </summary>
    Task<List<ReceiptEvidence>> GetUserReceiptsAsync(Guid userId);

    /// <summary>
    /// Gets receipt count for a user.
    /// </summary>
    Task<int> GetUserReceiptCountAsync(Guid userId);
}

/// <summary>
/// Data received from SendGrid Inbound Parse webhook.
/// </summary>
public class InboundEmailData
{
    public string To { get; set; } = string.Empty;
    public string From { get; set; } = string.Empty;
    public string Subject { get; set; } = string.Empty;
    public string Text { get; set; } = string.Empty;
    public string Html { get; set; } = string.Empty;
    public string SPF { get; set; } = string.Empty;
    public string DKIM { get; set; } = string.Empty;
    public string Envelope { get; set; } = string.Empty;
}

/// <summary>
/// Result of processing an inbound email.
/// </summary>
public class ReceiptParseResult
{
    public bool Success { get; set; }
    public string? ErrorMessage { get; set; }
    public Guid? ReceiptId { get; set; }
    public Platform? DetectedPlatform { get; set; }
}

/// <summary>
/// Service for parsing receipt emails and extracting transaction metadata.
/// Implements privacy-first approach: extract metadata only, delete raw email.
/// </summary>
public class ReceiptParsingService : IReceiptParsingService
{
    private readonly SilentIdDbContext _context;
    private readonly IForwardingAliasService _aliasService;
    private readonly ILogger<ReceiptParsingService> _logger;

    // Known marketplace sender domains for validation
    private static readonly Dictionary<string, Platform> KnownSenders = new(StringComparer.OrdinalIgnoreCase)
    {
        // Vinted
        { "vinted.co.uk", Platform.Vinted },
        { "vinted.com", Platform.Vinted },
        { "vinted.fr", Platform.Vinted },
        { "vinted.de", Platform.Vinted },
        // eBay
        { "ebay.co.uk", Platform.eBay },
        { "ebay.com", Platform.eBay },
        { "reply.ebay.co.uk", Platform.eBay },
        { "reply.ebay.com", Platform.eBay },
        // Depop
        { "depop.com", Platform.Depop },
        // Etsy
        { "etsy.com", Platform.Etsy },
        { "mail.etsy.com", Platform.Etsy },
        // PayPal
        { "paypal.co.uk", Platform.PayPal },
        { "paypal.com", Platform.PayPal },
        // Stripe
        { "stripe.com", Platform.Stripe },
        // Facebook Marketplace
        { "facebookmail.com", Platform.FacebookMarketplace },
    };

    public ReceiptParsingService(
        SilentIdDbContext context,
        IForwardingAliasService aliasService,
        ILogger<ReceiptParsingService> logger)
    {
        _context = context;
        _aliasService = aliasService;
        _logger = logger;
    }

    /// <summary>
    /// Processes an inbound email from SendGrid webhook.
    /// </summary>
    public async Task<ReceiptParseResult> ProcessInboundEmailAsync(InboundEmailData emailData)
    {
        try
        {
            // 1. Resolve the recipient alias to user ID
            var userId = await _aliasService.ResolveAliasToUserIdAsync(emailData.To);
            if (userId == null)
            {
                _logger.LogWarning("Unknown forwarding alias: {To}", emailData.To);
                return new ReceiptParseResult
                {
                    Success = false,
                    ErrorMessage = "Unknown forwarding alias"
                };
            }

            // 2. Validate sender domain
            var senderDomain = ExtractDomain(emailData.From);
            if (!KnownSenders.TryGetValue(senderDomain, out var platform))
            {
                _logger.LogWarning("Unknown sender domain: {Domain} from {From}", senderDomain, emailData.From);
                return new ReceiptParseResult
                {
                    Success = false,
                    ErrorMessage = "Email not from recognized marketplace"
                };
            }

            // 3. Calculate email hash for duplicate detection
            var rawHash = ComputeEmailHash(emailData);
            var existingReceipt = await _context.ReceiptEvidences
                .AnyAsync(r => r.UserId == userId && r.RawHash == rawHash);

            if (existingReceipt)
            {
                _logger.LogInformation("Duplicate receipt detected for user {UserId}", userId);
                return new ReceiptParseResult
                {
                    Success = false,
                    ErrorMessage = "Duplicate receipt"
                };
            }

            // 4. Calculate integrity score based on DKIM/SPF
            var integrityScore = CalculateIntegrityScore(emailData);

            // 5. Extract transaction metadata
            var metadata = ExtractMetadata(emailData, platform);

            // 6. Create receipt evidence record (metadata only)
            var receipt = new ReceiptEvidence
            {
                Id = Guid.NewGuid(),
                UserId = userId.Value,
                Source = ReceiptSource.Forwarded,
                Platform = platform,
                RawHash = rawHash,
                OrderId = metadata.OrderId,
                Item = metadata.ItemDescription,
                Amount = metadata.Amount,
                Currency = metadata.Currency,
                Role = metadata.Role,
                Date = metadata.TransactionDate ?? DateTime.UtcNow,
                IntegrityScore = integrityScore,
                FraudFlag = integrityScore < 50,
                EvidenceState = integrityScore >= 70 ? EvidenceState.Valid : EvidenceState.Suspicious,
                ForwardingAlias = emailData.To.Split('@')[0],
                EmailMetadataJson = JsonSerializer.Serialize(new
                {
                    senderDomain,
                    subject = emailData.Subject,
                    receivedAt = DateTime.UtcNow,
                    metadata.OrderId,
                    metadata.Amount,
                    metadata.Currency
                }),
                RawEmailDeleted = true, // We never store the raw email
                CreatedAt = DateTime.UtcNow
            };

            _context.ReceiptEvidences.Add(receipt);
            await _context.SaveChangesAsync();

            _logger.LogInformation(
                "Processed receipt for user {UserId}: Platform={Platform}, Amount={Amount} {Currency}",
                userId, platform, metadata.Amount, metadata.Currency);

            return new ReceiptParseResult
            {
                Success = true,
                ReceiptId = receipt.Id,
                DetectedPlatform = platform
            };
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error processing inbound email");
            return new ReceiptParseResult
            {
                Success = false,
                ErrorMessage = "Internal processing error"
            };
        }
    }

    /// <summary>
    /// Gets all receipts for a user.
    /// </summary>
    public async Task<List<ReceiptEvidence>> GetUserReceiptsAsync(Guid userId)
    {
        return await _context.ReceiptEvidences
            .Where(r => r.UserId == userId)
            .OrderByDescending(r => r.CreatedAt)
            .ToListAsync();
    }

    /// <summary>
    /// Gets receipt count for a user.
    /// </summary>
    public async Task<int> GetUserReceiptCountAsync(Guid userId)
    {
        return await _context.ReceiptEvidences
            .CountAsync(r => r.UserId == userId && r.EvidenceState == EvidenceState.Valid);
    }

    /// <summary>
    /// Extracts domain from email address.
    /// </summary>
    private static string ExtractDomain(string email)
    {
        var match = Regex.Match(email, @"@([\w.-]+)");
        return match.Success ? match.Groups[1].Value.ToLowerInvariant() : string.Empty;
    }

    /// <summary>
    /// Computes SHA-256 hash of email for duplicate detection.
    /// </summary>
    private static string ComputeEmailHash(InboundEmailData email)
    {
        var content = $"{email.From}|{email.Subject}|{email.Text}";
        var bytes = Encoding.UTF8.GetBytes(content);
        var hash = SHA256.HashData(bytes);
        return Convert.ToHexString(hash).ToLowerInvariant();
    }

    /// <summary>
    /// Calculates integrity score based on DKIM/SPF validation.
    /// </summary>
    private int CalculateIntegrityScore(InboundEmailData email)
    {
        var score = 50; // Base score

        // DKIM validation (+25 for pass)
        if (email.DKIM?.Contains("pass", StringComparison.OrdinalIgnoreCase) == true)
        {
            score += 25;
        }

        // SPF validation (+25 for pass)
        if (email.SPF?.Contains("pass", StringComparison.OrdinalIgnoreCase) == true)
        {
            score += 25;
        }

        return Math.Min(score, 100);
    }

    /// <summary>
    /// Extracts transaction metadata from email content.
    /// </summary>
    private TransactionMetadata ExtractMetadata(InboundEmailData email, Platform platform)
    {
        var metadata = new TransactionMetadata
        {
            Currency = "GBP", // Default
            Role = TransactionRole.Buyer // Default
        };

        var content = email.Html ?? email.Text ?? string.Empty;

        // Extract order ID
        var orderIdMatch = Regex.Match(content, @"(?:order|transaction|ref|confirmation)[#:\s]*([A-Z0-9-]+)", RegexOptions.IgnoreCase);
        if (orderIdMatch.Success)
        {
            metadata.OrderId = orderIdMatch.Groups[1].Value;
        }

        // Extract amount - various formats
        var amountMatch = Regex.Match(content, @"(?:£|GBP|€|EUR|\$|USD)\s*(\d+(?:[.,]\d{2})?)", RegexOptions.IgnoreCase);
        if (amountMatch.Success)
        {
            if (decimal.TryParse(amountMatch.Groups[1].Value.Replace(",", "."), out var amount))
            {
                metadata.Amount = amount;
            }

            // Detect currency from symbol
            if (content.Contains('£') || content.Contains("GBP"))
                metadata.Currency = "GBP";
            else if (content.Contains('€') || content.Contains("EUR"))
                metadata.Currency = "EUR";
            else if (content.Contains('$') || content.Contains("USD"))
                metadata.Currency = "USD";
        }

        // Extract item description (simplified)
        var itemMatch = Regex.Match(content, @"(?:item|product|order)[:\s]+([^<\n]{10,100})", RegexOptions.IgnoreCase);
        if (itemMatch.Success)
        {
            metadata.ItemDescription = itemMatch.Groups[1].Value.Trim();
        }

        // Determine role based on keywords
        if (Regex.IsMatch(content, @"you sold|sale confirmed|payment received|buyer paid", RegexOptions.IgnoreCase))
        {
            metadata.Role = TransactionRole.Seller;
        }

        // Extract date
        var dateMatch = Regex.Match(content, @"(\d{1,2}[/-]\d{1,2}[/-]\d{2,4}|\d{4}[/-]\d{1,2}[/-]\d{1,2})");
        if (dateMatch.Success && DateTime.TryParse(dateMatch.Groups[1].Value, out var date))
        {
            metadata.TransactionDate = date;
        }

        return metadata;
    }

    private class TransactionMetadata
    {
        public string? OrderId { get; set; }
        public string? ItemDescription { get; set; }
        public decimal Amount { get; set; }
        public string Currency { get; set; } = "GBP";
        public TransactionRole Role { get; set; }
        public DateTime? TransactionDate { get; set; }
    }
}
