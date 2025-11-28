using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

public interface IReportService
{
    Task<Report> CreateReportAsync(Guid reporterId, CreateReportRequest request);
    Task<ReportEvidence> UploadEvidenceAsync(Guid reportId, Guid userId, string fileUrl, string? fileType);
    Task<ReportEvidence> UploadEvidenceFileAsync(Guid reportId, Guid userId, IFormFile file);
    Task<List<Report>> GetMyReportsAsync(Guid userId);
    Task<Report?> GetReportByIdAsync(Guid reportId, Guid userId);
}

public class ReportService : IReportService
{
    private readonly SilentIdDbContext _context;
    private readonly IBlobStorageService _blobStorageService;
    private readonly ILogger<ReportService> _logger;

    public ReportService(
        SilentIdDbContext context,
        IBlobStorageService blobStorageService,
        ILogger<ReportService> logger)
    {
        _context = context;
        _blobStorageService = blobStorageService;
        _logger = logger;
    }

    public async Task<Report> CreateReportAsync(Guid reporterId, CreateReportRequest request)
    {
        // Find reported user
        var reportedUser = await _context.Users
            .AsNoTracking() // Read-only lookup
            .FirstOrDefaultAsync(u => u.Username == request.ReportedUserIdentifier ||
                                     u.Email == request.ReportedUserIdentifier);

        if (reportedUser == null)
        {
            throw new KeyNotFoundException($"User '{request.ReportedUserIdentifier}' not found");
        }

        // Can't report yourself
        if (reportedUser.Id == reporterId)
        {
            throw new InvalidOperationException("Cannot report yourself");
        }

        // Check if reporter is ID-verified (required for reports)
        var reporterIdentity = await _context.IdentityVerifications
            .FirstOrDefaultAsync(i => i.UserId == reporterId &&
                                     i.Status == VerificationStatus.Verified);

        if (reporterIdentity == null)
        {
            throw new InvalidOperationException("You must verify your identity before filing reports");
        }

        // Rate limiting: max 5 reports per day
        var todayReports = await _context.Reports
            .Where(r => r.ReporterId == reporterId &&
                       r.CreatedAt >= DateTime.UtcNow.AddDays(-1))
            .CountAsync();

        if (todayReports >= 5)
        {
            throw new InvalidOperationException("Report limit exceeded. You can file up to 5 reports per day.");
        }

        // Create report
        var report = new Report
        {
            ReporterId = reporterId,
            ReportedUserId = reportedUser.Id,
            Category = request.Category,
            Description = request.Description,
            Status = ReportStatus.Pending
        };

        _context.Reports.Add(report);

        // Add RiskSignal to reported user
        var riskSignal = new RiskSignal
        {
            UserId = reportedUser.Id,
            Type = RiskType.Reported,
            Severity = 5,
            Message = $"Safety report filed: {request.Category}",
            Metadata = System.Text.Json.JsonSerializer.Serialize(new
            {
                reportId = report.Id,
                category = request.Category.ToString(),
                reportedAt = DateTime.UtcNow
            })
        };

        _context.RiskSignals.Add(riskSignal);

        await _context.SaveChangesAsync();

        _logger.LogInformation("User {ReporterId} filed report {ReportId} against {ReportedUserId}",
            reporterId, report.Id, reportedUser.Id);

        return report;
    }

    public async Task<ReportEvidence> UploadEvidenceAsync(Guid reportId, Guid userId, string fileUrl, string? fileType)
    {
        var report = await _context.Reports
            .FirstOrDefaultAsync(r => r.Id == reportId);

        if (report == null)
        {
            throw new KeyNotFoundException("Report not found");
        }

        // Only reporter can upload evidence
        if (report.ReporterId != userId)
        {
            throw new UnauthorizedAccessException("You can only upload evidence to your own reports");
        }

        // Create evidence record
        var evidence = new ReportEvidence
        {
            ReportId = reportId,
            FileUrl = fileUrl,
            FileType = fileType,
            OCRText = null // TODO: OCR processing in future
        };

        _context.ReportEvidences.Add(evidence);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Evidence uploaded for report {ReportId}", reportId);

        return evidence;
    }

    public async Task<ReportEvidence> UploadEvidenceFileAsync(Guid reportId, Guid userId, IFormFile file)
    {
        var report = await _context.Reports
            .FirstOrDefaultAsync(r => r.Id == reportId);

        if (report == null)
        {
            throw new KeyNotFoundException("Report not found");
        }

        // Only reporter can upload evidence
        if (report.ReporterId != userId)
        {
            throw new UnauthorizedAccessException("You can only upload evidence to your own reports");
        }

        // Upload file to blob storage
        string fileUrl;
        using (var fileStream = file.OpenReadStream())
        {
            fileUrl = await _blobStorageService.UploadFileAsync(
                fileStream,
                file.FileName,
                file.ContentType
            );
        }

        _logger.LogInformation("Evidence file uploaded for report {ReportId}: {FileUrl}", reportId, fileUrl);

        // Create evidence record
        var evidence = new ReportEvidence
        {
            ReportId = reportId,
            FileUrl = fileUrl,
            FileType = file.ContentType,
            OCRText = null // Future: OCR processing
        };

        _context.ReportEvidences.Add(evidence);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Evidence record created for report {ReportId}, ID: {EvidenceId}", reportId, evidence.Id);

        return evidence;
    }

    public async Task<List<Report>> GetMyReportsAsync(Guid userId)
    {
        return await _context.Reports
            .AsNoTracking() // Read-only list query
            .Include(r => r.ReportedUser)
            .Include(r => r.Evidence)
            .Where(r => r.ReporterId == userId)
            .OrderByDescending(r => r.CreatedAt)
            .ToListAsync();
    }

    public async Task<Report?> GetReportByIdAsync(Guid reportId, Guid userId)
    {
        var report = await _context.Reports
            .AsNoTracking() // Read-only query
            .Include(r => r.ReportedUser)
            .Include(r => r.Evidence)
            .FirstOrDefaultAsync(r => r.Id == reportId);

        if (report == null)
        {
            return null;
        }

        // Only reporter can view
        if (report.ReporterId != userId)
        {
            return null;
        }

        return report;
    }
}

// DTOs
public record CreateReportRequest(
    string ReportedUserIdentifier,  // username or email
    ReportCategory Category,
    string Description
);

public record UploadReportEvidenceRequest(
    string FileUrl,
    string? FileType
);
