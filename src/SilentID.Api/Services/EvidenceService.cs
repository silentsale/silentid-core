using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

public interface IEvidenceService
{
    Task<ReceiptEvidence> AddReceiptEvidenceAsync(Guid userId, ReceiptEvidence receipt);
    Task<ScreenshotEvidence> AddScreenshotEvidenceAsync(Guid userId, ScreenshotEvidence screenshot);
    Task<ProfileLinkEvidence> AddProfileLinkEvidenceAsync(Guid userId, ProfileLinkEvidence profileLink);
    Task<List<ReceiptEvidence>> GetUserReceiptsAsync(Guid userId, int page = 1, int pageSize = 20);
    Task<ScreenshotEvidence?> GetScreenshotAsync(Guid id, Guid userId);
    Task<ProfileLinkEvidence?> GetProfileLinkAsync(Guid id, Guid userId);
    Task<int> GetTotalReceiptsCountAsync(Guid userId);
    Task<bool> IsDuplicateReceiptAsync(string rawHash);
}

public class EvidenceService : IEvidenceService
{
    private readonly SilentIdDbContext _context;
    private readonly ILogger<EvidenceService> _logger;

    public EvidenceService(SilentIdDbContext context, ILogger<EvidenceService> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<ReceiptEvidence> AddReceiptEvidenceAsync(Guid userId, ReceiptEvidence receipt)
    {
        receipt.Id = Guid.NewGuid();
        receipt.UserId = userId;
        receipt.CreatedAt = DateTime.UtcNow;

        // Basic fraud checks (placeholder - enhance later with real validation)
        if (receipt.IntegrityScore < 70)
        {
            receipt.FraudFlag = true;
            receipt.EvidenceState = EvidenceState.Suspicious;
            _logger.LogWarning("Low integrity score for receipt {ReceiptId}: {Score}", receipt.Id, receipt.IntegrityScore);
        }

        _context.ReceiptEvidences.Add(receipt);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Receipt evidence {ReceiptId} added for user {UserId}", receipt.Id, userId);
        return receipt;
    }

    public async Task<ScreenshotEvidence> AddScreenshotEvidenceAsync(Guid userId, ScreenshotEvidence screenshot)
    {
        screenshot.Id = Guid.NewGuid();
        screenshot.UserId = userId;
        screenshot.CreatedAt = DateTime.UtcNow;

        // Basic fraud checks (placeholder - enhance later with OCR/EXIF validation)
        if (screenshot.IntegrityScore < 70)
        {
            screenshot.FraudFlag = true;
            screenshot.EvidenceState = EvidenceState.Suspicious;
            _logger.LogWarning("Low integrity score for screenshot {ScreenshotId}: {Score}", screenshot.Id, screenshot.IntegrityScore);
        }

        _context.ScreenshotEvidences.Add(screenshot);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Screenshot evidence {ScreenshotId} added for user {UserId}", screenshot.Id, userId);
        return screenshot;
    }

    public async Task<ProfileLinkEvidence> AddProfileLinkEvidenceAsync(Guid userId, ProfileLinkEvidence profileLink)
    {
        profileLink.Id = Guid.NewGuid();
        profileLink.UserId = userId;
        profileLink.CreatedAt = DateTime.UtcNow;
        profileLink.UpdatedAt = DateTime.UtcNow;

        // Basic fraud checks (placeholder - enhance later with real scraping)
        if (profileLink.UsernameMatchScore < 50)
        {
            profileLink.EvidenceState = EvidenceState.Suspicious;
            _logger.LogWarning("Low username match for profile link {ProfileLinkId}: {Score}", profileLink.Id, profileLink.UsernameMatchScore);
        }

        _context.ProfileLinkEvidences.Add(profileLink);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Profile link evidence {ProfileLinkId} added for user {UserId}", profileLink.Id, userId);
        return profileLink;
    }

    public async Task<List<ReceiptEvidence>> GetUserReceiptsAsync(Guid userId, int page = 1, int pageSize = 20)
    {
        return await _context.ReceiptEvidences
            .AsNoTracking() // Read-only pagination query
            .Where(r => r.UserId == userId)
            .OrderByDescending(r => r.Date)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .ToListAsync();
    }

    public async Task<ScreenshotEvidence?> GetScreenshotAsync(Guid id, Guid userId)
    {
        return await _context.ScreenshotEvidences
            .AsNoTracking() // Read-only query
            .FirstOrDefaultAsync(s => s.Id == id && s.UserId == userId);
    }

    public async Task<ProfileLinkEvidence?> GetProfileLinkAsync(Guid id, Guid userId)
    {
        return await _context.ProfileLinkEvidences
            .AsNoTracking() // Read-only query
            .FirstOrDefaultAsync(p => p.Id == id && p.UserId == userId);
    }

    public async Task<int> GetTotalReceiptsCountAsync(Guid userId)
    {
        return await _context.ReceiptEvidences
            .CountAsync(r => r.UserId == userId);
    }

    public async Task<bool> IsDuplicateReceiptAsync(string rawHash)
    {
        return await _context.ReceiptEvidences
            .AnyAsync(r => r.RawHash == rawHash);
    }
}
