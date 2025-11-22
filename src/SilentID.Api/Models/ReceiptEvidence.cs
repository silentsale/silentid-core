using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Stores evidence from email receipts (order confirmations, shipping confirmations).
/// AI extracts transaction details from emails to build TrustScore.
/// </summary>
public class ReceiptEvidence
{
    [Key]
    public Guid Id { get; set; }

    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    /// <summary>
    /// Source of the receipt (Gmail, Outlook, IMAP, Forwarded).
    /// </summary>
    public ReceiptSource Source { get; set; }

    /// <summary>
    /// Platform where transaction occurred (Vinted, eBay, Depop, etc.).
    /// </summary>
    public Platform Platform { get; set; }

    /// <summary>
    /// SHA-256 hash of raw email to detect duplicates.
    /// </summary>
    [Required]
    [MaxLength(64)]
    public string RawHash { get; set; } = string.Empty;

    /// <summary>
    /// Order ID from the receipt (if available).
    /// </summary>
    [MaxLength(255)]
    public string? OrderId { get; set; }

    /// <summary>
    /// Item name/description from receipt.
    /// </summary>
    [MaxLength(500)]
    public string? Item { get; set; }

    /// <summary>
    /// Transaction amount.
    /// </summary>
    public decimal Amount { get; set; }

    /// <summary>
    /// Currency code (GBP, USD, EUR).
    /// </summary>
    [Required]
    [MaxLength(3)]
    public string Currency { get; set; } = "GBP";

    /// <summary>
    /// User's role in this transaction.
    /// </summary>
    public TransactionRole Role { get; set; }

    /// <summary>
    /// Transaction date from receipt.
    /// </summary>
    public DateTime Date { get; set; }

    /// <summary>
    /// Integrity score (0-100) based on DKIM/SPF/header validation.
    /// </summary>
    public int IntegrityScore { get; set; } = 100;

    /// <summary>
    /// Fraud flag if receipt appears fake.
    /// </summary>
    public bool FraudFlag { get; set; } = false;

    /// <summary>
    /// Evidence state (Valid, Suspicious, Rejected).
    /// </summary>
    public EvidenceState EvidenceState { get; set; } = EvidenceState.Valid;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}

public enum ReceiptSource
{
    Gmail,
    Outlook,
    IMAP,
    Forwarded,
    Manual
}

public enum Platform
{
    Vinted,
    eBay,
    Depop,
    Etsy,
    FacebookMarketplace,
    PayPal,
    Stripe,
    Other
}

public enum TransactionRole
{
    Buyer,
    Seller
}

public enum EvidenceState
{
    Valid,
    Suspicious,
    Rejected
}
