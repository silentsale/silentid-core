using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Azure.Storage.Sas;

namespace SilentID.Api.Services;

public interface IBlobStorageService
{
    Task<string> UploadFileAsync(Stream fileStream, string fileName, string contentType);
    Task<Stream> DownloadFileAsync(string blobUrl);
    Task DeleteFileAsync(string blobUrl);
    Task<string> GenerateSasTokenAsync(string blobName, int expiryHours = 1);
}

/// <summary>
/// Blob storage service using Azure Blob Storage for production file storage.
/// Falls back to local file system in development if Azure is not configured.
/// </summary>
public class BlobStorageService : IBlobStorageService
{
    private readonly ILogger<BlobStorageService> _logger;
    private readonly IConfiguration _configuration;
    private readonly BlobServiceClient? _blobServiceClient;
    private readonly string? _evidenceContainerName;
    private readonly bool _isAzureConfigured;
    private readonly string _localStoragePath;

    public BlobStorageService(ILogger<BlobStorageService> logger, IConfiguration configuration)
    {
        _logger = logger;
        _configuration = configuration;

        var connectionString = _configuration["AzureStorage:ConnectionString"];
        _evidenceContainerName = _configuration["AzureStorage:EvidenceContainer"] ?? "evidence";

        if (!string.IsNullOrEmpty(connectionString))
        {
            try
            {
                _blobServiceClient = new BlobServiceClient(connectionString);
                _isAzureConfigured = true;
                _logger.LogInformation("Azure Blob Storage service initialized. Container: {Container}", _evidenceContainerName);

                // Ensure container exists
                EnsureContainerExistsAsync().Wait();
            }
            catch (Exception ex)
            {
                _isAzureConfigured = false;
                _logger.LogError(ex, "Failed to initialize Azure Blob Storage - falling back to local storage");
            }
        }
        else
        {
            _isAzureConfigured = false;
            _logger.LogWarning("Azure Blob Storage connection string not configured - using local file storage");
        }

        // Local fallback storage path
        _localStoragePath = Path.Combine(Directory.GetCurrentDirectory(), "LocalStorage", "evidence");
        if (!_isAzureConfigured)
        {
            Directory.CreateDirectory(_localStoragePath);
            _logger.LogInformation("Local storage path created: {Path}", _localStoragePath);
        }
    }

    private async Task EnsureContainerExistsAsync()
    {
        if (_blobServiceClient != null && !string.IsNullOrEmpty(_evidenceContainerName))
        {
            try
            {
                var containerClient = _blobServiceClient.GetBlobContainerClient(_evidenceContainerName);
                await containerClient.CreateIfNotExistsAsync(PublicAccessType.None);
                _logger.LogInformation("Evidence container verified: {Container}", _evidenceContainerName);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to ensure container exists: {Container}", _evidenceContainerName);
                throw;
            }
        }
    }

    public async Task<string> UploadFileAsync(Stream fileStream, string fileName, string contentType)
    {
        if (_isAzureConfigured && _blobServiceClient != null && !string.IsNullOrEmpty(_evidenceContainerName))
        {
            try
            {
                var containerClient = _blobServiceClient.GetBlobContainerClient(_evidenceContainerName);

                // Generate unique blob name with timestamp prefix to avoid collisions
                var blobName = $"{Guid.NewGuid()}_{fileName}";
                var blobClient = containerClient.GetBlobClient(blobName);

                // Upload with metadata
                var blobHttpHeaders = new BlobHttpHeaders
                {
                    ContentType = contentType
                };

                await blobClient.UploadAsync(fileStream, new BlobUploadOptions
                {
                    HttpHeaders = blobHttpHeaders
                });

                _logger.LogInformation("File uploaded to Azure Blob Storage: {BlobName}", blobName);

                return blobClient.Uri.ToString();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to upload file to Azure Blob Storage: {FileName}", fileName);
                throw;
            }
        }
        else
        {
            // Development fallback - save to local storage
            try
            {
                var localFileName = $"{Guid.NewGuid()}_{fileName}";
                var localFilePath = Path.Combine(_localStoragePath, localFileName);

                using (var fileStreamWrite = File.Create(localFilePath))
                {
                    await fileStream.CopyToAsync(fileStreamWrite);
                }

                _logger.LogInformation("📁 FILE: Saved to local storage: {FilePath}", localFilePath);
                _logger.LogInformation("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
                _logger.LogInformation("File: {FileName}", fileName);
                _logger.LogInformation("Size: {Size} bytes", new FileInfo(localFilePath).Length);
                _logger.LogInformation("Content-Type: {ContentType}", contentType);
                _logger.LogInformation("Path: {Path}", localFilePath);
                _logger.LogInformation("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

                // Return local file path as URL (in production this would be blob URL)
                return $"local://{localFileName}";
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to save file to local storage: {FileName}", fileName);
                throw;
            }
        }
    }

    public async Task<Stream> DownloadFileAsync(string blobUrl)
    {
        if (_isAzureConfigured && _blobServiceClient != null)
        {
            try
            {
                // Extract blob name from URL
                var uri = new Uri(blobUrl);
                var blobName = uri.Segments[^1];

                var containerClient = _blobServiceClient.GetBlobContainerClient(_evidenceContainerName!);
                var blobClient = containerClient.GetBlobClient(blobName);

                var response = await blobClient.DownloadStreamingAsync();
                _logger.LogInformation("File downloaded from Azure Blob Storage: {BlobName}", blobName);

                return response.Value.Content;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to download file from Azure Blob Storage: {BlobUrl}", blobUrl);
                throw;
            }
        }
        else
        {
            // Development fallback - read from local storage
            try
            {
                var localFileName = blobUrl.Replace("local://", "");
                var localFilePath = Path.Combine(_localStoragePath, localFileName);

                if (!File.Exists(localFilePath))
                {
                    _logger.LogError("Local file not found: {FilePath}", localFilePath);
                    throw new FileNotFoundException($"File not found: {localFileName}");
                }

                _logger.LogInformation("📁 FILE: Reading from local storage: {FilePath}", localFilePath);
                return File.OpenRead(localFilePath);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to read file from local storage: {BlobUrl}", blobUrl);
                throw;
            }
        }
    }

    public async Task DeleteFileAsync(string blobUrl)
    {
        if (_isAzureConfigured && _blobServiceClient != null)
        {
            try
            {
                // Extract blob name from URL
                var uri = new Uri(blobUrl);
                var blobName = uri.Segments[^1];

                var containerClient = _blobServiceClient.GetBlobContainerClient(_evidenceContainerName!);
                var blobClient = containerClient.GetBlobClient(blobName);

                await blobClient.DeleteIfExistsAsync();
                _logger.LogInformation("File deleted from Azure Blob Storage: {BlobName}", blobName);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to delete file from Azure Blob Storage: {BlobUrl}", blobUrl);
                throw;
            }
        }
        else
        {
            // Development fallback - delete from local storage
            try
            {
                var localFileName = blobUrl.Replace("local://", "");
                var localFilePath = Path.Combine(_localStoragePath, localFileName);

                if (File.Exists(localFilePath))
                {
                    File.Delete(localFilePath);
                    _logger.LogInformation("📁 FILE: Deleted from local storage: {FilePath}", localFilePath);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to delete file from local storage: {BlobUrl}", blobUrl);
                throw;
            }
        }
    }

    public async Task<string> GenerateSasTokenAsync(string blobName, int expiryHours = 1)
    {
        if (_isAzureConfigured && _blobServiceClient != null && !string.IsNullOrEmpty(_evidenceContainerName))
        {
            try
            {
                var containerClient = _blobServiceClient.GetBlobContainerClient(_evidenceContainerName);
                var blobClient = containerClient.GetBlobClient(blobName);

                // Generate SAS token
                var sasBuilder = new BlobSasBuilder
                {
                    BlobContainerName = _evidenceContainerName,
                    BlobName = blobName,
                    Resource = "b", // b = blob
                    StartsOn = DateTimeOffset.UtcNow.AddMinutes(-5), // Allow for clock skew
                    ExpiresOn = DateTimeOffset.UtcNow.AddHours(expiryHours)
                };

                sasBuilder.SetPermissions(BlobSasPermissions.Read);

                var sasToken = await Task.FromResult(blobClient.GenerateSasUri(sasBuilder).Query);
                _logger.LogInformation("SAS token generated for blob: {BlobName}", blobName);

                return sasToken;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Failed to generate SAS token for blob: {BlobName}", blobName);
                throw;
            }
        }
        else
        {
            // Development fallback - return empty token
            _logger.LogWarning("SAS token generation not available in local storage mode");
            return string.Empty;
        }
    }
}
