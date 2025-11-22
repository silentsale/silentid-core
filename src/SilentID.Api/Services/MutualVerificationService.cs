using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

public interface IMutualVerificationService
{
    Task<MutualVerification> CreateVerificationAsync(Guid userId, CreateMutualVerificationRequest request);
    Task<List<MutualVerification>> GetIncomingRequestsAsync(Guid userId);
    Task<MutualVerification> RespondToVerificationAsync(Guid userId, Guid verificationId, string status, string? reason);
    Task<List<MutualVerification>> GetMyVerificationsAsync(Guid userId);
    Task<MutualVerification?> GetVerificationByIdAsync(Guid verificationId);
}

public class MutualVerificationService : IMutualVerificationService
{
    private readonly SilentIdDbContext _context;
    private readonly ILogger<MutualVerificationService> _logger;

    public MutualVerificationService(
        SilentIdDbContext context,
        ILogger<MutualVerificationService> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<MutualVerification> CreateVerificationAsync(Guid userId, CreateMutualVerificationRequest request)
    {
        // 1. Find other user by username or email
        var otherUser = await _context.Users
            .AsNoTracking() // Read-only lookup
            .FirstOrDefaultAsync(u => u.Username == request.OtherUserIdentifier ||
                                     u.Email == request.OtherUserIdentifier);

        if (otherUser == null)
        {
            throw new KeyNotFoundException($"User '{request.OtherUserIdentifier}' not found");
        }

        // 2. Anti-fraud check: can't verify with yourself
        if (otherUser.Id == userId)
        {
            throw new InvalidOperationException("Cannot verify transaction with yourself");
        }

        // 3. Check for duplicate
        var existing = await _context.MutualVerifications
            .Where(m => (m.UserAId == userId && m.UserBId == otherUser.Id) ||
                       (m.UserAId == otherUser.Id && m.UserBId == userId))
            .Where(m => m.Item == request.Item &&
                       Math.Abs((m.Date - request.Date).TotalDays) < 7)
            .FirstOrDefaultAsync();

        if (existing != null)
        {
            throw new InvalidOperationException("Similar verification already exists for this transaction");
        }

        // 4. Create verification
        var verification = new MutualVerification
        {
            UserAId = userId,
            UserBId = otherUser.Id,
            Item = request.Item,
            Amount = request.Amount,
            Currency = request.Currency ?? "GBP",
            RoleA = request.YourRole,
            RoleB = request.YourRole == TransactionRole.Buyer ? TransactionRole.Seller : TransactionRole.Buyer,
            Date = request.Date,
            Status = MutualVerificationStatus.Pending,
            FraudFlag = false
        };

        _context.MutualVerifications.Add(verification);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Created mutual verification {Id} between {UserA} and {UserB}",
            verification.Id, userId, otherUser.Id);

        return verification;
    }

    public async Task<List<MutualVerification>> GetIncomingRequestsAsync(Guid userId)
    {
        return await _context.MutualVerifications
            .AsNoTracking() // Read-only list query
            .Include(m => m.UserA)
            .Include(m => m.UserB)
            .Where(m => m.UserBId == userId && m.Status == MutualVerificationStatus.Pending)
            .OrderByDescending(m => m.CreatedAt)
            .ToListAsync();
    }

    public async Task<MutualVerification> RespondToVerificationAsync(
        Guid userId, Guid verificationId, string status, string? reason)
    {
        var verification = await _context.MutualVerifications
            .FirstOrDefaultAsync(m => m.Id == verificationId);

        if (verification == null)
        {
            throw new KeyNotFoundException("Verification not found");
        }

        // Only UserB can respond
        if (verification.UserBId != userId)
        {
            throw new UnauthorizedAccessException("You are not authorized to respond to this verification");
        }

        // Can only respond to pending requests
        if (verification.Status != MutualVerificationStatus.Pending)
        {
            throw new InvalidOperationException("This verification has already been responded to");
        }

        // Update status
        verification.Status = status.ToLower() switch
        {
            "confirmed" => MutualVerificationStatus.Confirmed,
            "rejected" => MutualVerificationStatus.Rejected,
            _ => throw new ArgumentException("Invalid status. Must be 'confirmed' or 'rejected'")
        };

        verification.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        _logger.LogInformation("User {UserId} responded {Status} to verification {VerificationId}",
            userId, status, verificationId);

        return verification;
    }

    public async Task<List<MutualVerification>> GetMyVerificationsAsync(Guid userId)
    {
        return await _context.MutualVerifications
            .AsNoTracking() // Read-only list query
            .Include(m => m.UserA)
            .Include(m => m.UserB)
            .Where(m => m.UserAId == userId || m.UserBId == userId)
            .OrderByDescending(m => m.CreatedAt)
            .ToListAsync();
    }

    public async Task<MutualVerification?> GetVerificationByIdAsync(Guid verificationId)
    {
        return await _context.MutualVerifications
            .AsNoTracking() // Read-only query
            .Include(m => m.UserA)
            .Include(m => m.UserB)
            .FirstOrDefaultAsync(m => m.Id == verificationId);
    }
}

// DTOs
public record CreateMutualVerificationRequest(
    string OtherUserIdentifier,  // username or email
    string Item,
    decimal Amount,
    string? Currency,
    TransactionRole YourRole,
    DateTime Date
);

public record RespondToVerificationRequest(
    string Status,  // "confirmed" or "rejected"
    string? Reason
);
