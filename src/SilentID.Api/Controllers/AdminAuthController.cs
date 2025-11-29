using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SilentID.Api.Services;

namespace SilentID.Api.Controllers;

/// <summary>
/// Admin authentication endpoints for the SilentID Admin Panel.
/// Supports passwordless authentication via Passkey and Email OTP.
/// Separate from regular user authentication for security isolation.
/// </summary>
[ApiController]
[Route("admin/auth")]
public class AdminAuthController : ControllerBase
{
    private readonly IAdminAuthService _adminAuthService;
    private readonly ILogger<AdminAuthController> _logger;

    public AdminAuthController(
        IAdminAuthService adminAuthService,
        ILogger<AdminAuthController> logger)
    {
        _adminAuthService = adminAuthService;
        _logger = logger;
    }

    /// <summary>
    /// Check if an email is a valid admin account.
    /// Returns authentication method preference (passkey or OTP).
    /// </summary>
    /// <param name="request">Email to check</param>
    [HttpPost("check")]
    public async Task<IActionResult> CheckAdmin([FromBody] AdminCheckRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Email))
        {
            return BadRequest(new
            {
                error = "invalid_request",
                message = "Email is required."
            });
        }

        try
        {
            var result = await _adminAuthService.CheckAdminEmailAsync(request.Email);

            if (!result.IsValid)
            {
                return Unauthorized(new
                {
                    error = "invalid_admin",
                    message = result.Message,
                    isLocked = result.IsLocked
                });
            }

            return Ok(new
            {
                valid = true,
                adminId = result.AdminId,
                displayName = result.DisplayName,
                role = result.Role,
                hasPasskey = result.HasPasskey,
                preferredAuthMethod = result.PreferredAuthMethod
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error checking admin email {Email}", request.Email);
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to verify admin email."
            });
        }
    }

    // ==================== PASSKEY ENDPOINTS ====================

    /// <summary>
    /// Generate passkey registration options for setting up a new passkey.
    /// Requires existing admin session.
    /// </summary>
    [Authorize(Policy = "AdminOnly")]
    [HttpPost("passkey/register/options")]
    public async Task<IActionResult> PasskeyRegisterOptions()
    {
        var adminId = GetAdminUserId();
        if (adminId == null)
        {
            return Unauthorized();
        }

        try
        {
            var options = await _adminAuthService.GeneratePasskeyRegistrationOptionsAsync(adminId.Value);

            _logger.LogInformation("Passkey registration options generated for admin {AdminId}", adminId);

            return Ok(options);
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Passkey registration options failed for admin {AdminId}", adminId);
            return BadRequest(new
            {
                error = "registration_failed",
                message = ex.Message
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error generating passkey registration options for admin {AdminId}", adminId);
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to generate passkey registration options."
            });
        }
    }

    /// <summary>
    /// Complete passkey registration after WebAuthn ceremony.
    /// </summary>
    [Authorize(Policy = "AdminOnly")]
    [HttpPost("passkey/register/complete")]
    public async Task<IActionResult> PasskeyRegisterComplete([FromBody] AdminPasskeyRegisterRequest request)
    {
        var adminId = GetAdminUserId();
        if (adminId == null)
        {
            return Unauthorized();
        }

        if (string.IsNullOrWhiteSpace(request.CredentialId) || string.IsNullOrWhiteSpace(request.PublicKey))
        {
            return BadRequest(new
            {
                error = "invalid_request",
                message = "Credential ID and public key are required."
            });
        }

        try
        {
            var credential = await _adminAuthService.CompletePasskeyRegistrationAsync(
                adminId.Value,
                request.CredentialId,
                request.PublicKey,
                request.SignatureCounter,
                request.AaGuid,
                request.DeviceName,
                request.AttestationFormat,
                request.UserVerified);

            _logger.LogInformation("Passkey registered for admin {AdminId}", adminId);

            return Ok(new
            {
                id = credential.Id,
                deviceName = credential.DeviceName,
                createdAt = credential.CreatedAt,
                message = "Passkey registered successfully."
            });
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Passkey registration failed for admin {AdminId}", adminId);
            return Conflict(new
            {
                error = "credential_exists",
                message = ex.Message
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error completing passkey registration for admin {AdminId}", adminId);
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to complete passkey registration."
            });
        }
    }

    /// <summary>
    /// Get WebAuthn challenge for passkey authentication.
    /// </summary>
    [HttpPost("passkey/challenge")]
    public async Task<IActionResult> PasskeyChallenge([FromBody] AdminPasskeyChallengeRequest? request)
    {
        try
        {
            var options = await _adminAuthService.GeneratePasskeyAuthenticationOptionsAsync(request?.Email);

            _logger.LogInformation("Passkey authentication challenge generated");

            return Ok(options);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error generating passkey authentication options");
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to generate passkey authentication options."
            });
        }
    }

    /// <summary>
    /// Verify passkey and create admin session.
    /// </summary>
    [HttpPost("passkey/verify")]
    public async Task<IActionResult> PasskeyVerify([FromBody] AdminPasskeyVerifyRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.CredentialId))
        {
            return BadRequest(new
            {
                error = "invalid_request",
                message = "Credential ID is required."
            });
        }

        try
        {
            var result = await _adminAuthService.CompletePasskeyAuthenticationAsync(
                request.CredentialId,
                request.AuthenticatorData,
                request.ClientDataJson,
                request.Signature,
                request.SignatureCounter,
                GetClientIpAddress(),
                GetUserAgent());

            if (!result.Success)
            {
                _logger.LogWarning("Passkey authentication failed: {Error}", result.ErrorMessage);
                return Unauthorized(new
                {
                    error = "authentication_failed",
                    message = result.ErrorMessage
                });
            }

            _logger.LogInformation("Admin authenticated via passkey: {AdminId}", result.Admin?.Id);

            return Ok(new
            {
                accessToken = result.AccessToken,
                refreshToken = result.RefreshToken,
                expiresIn = result.ExpiresIn,
                tokenType = "Bearer",
                admin = result.Admin
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error during passkey authentication");
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to complete passkey authentication."
            });
        }
    }

    // ==================== OTP ENDPOINTS ====================

    /// <summary>
    /// Request OTP to be sent to admin email.
    /// </summary>
    [HttpPost("otp/request")]
    public async Task<IActionResult> RequestOtp([FromBody] AdminOtpRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Email))
        {
            return BadRequest(new
            {
                error = "invalid_request",
                message = "Email is required."
            });
        }

        try
        {
            var success = await _adminAuthService.RequestOtpAsync(request.Email);

            if (!success)
            {
                return StatusCode(429, new
                {
                    error = "rate_limited",
                    message = "Too many requests. Please wait before requesting another code."
                });
            }

            // Always return success to prevent email enumeration
            return Ok(new
            {
                message = "If this email is registered as an admin, a verification code has been sent.",
                expiresInMinutes = 10
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error requesting OTP for {Email}", request.Email);
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to send verification code."
            });
        }
    }

    /// <summary>
    /// Verify OTP and create admin session.
    /// </summary>
    [HttpPost("otp/verify")]
    public async Task<IActionResult> VerifyOtp([FromBody] AdminOtpVerifyRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Email) || string.IsNullOrWhiteSpace(request.Otp))
        {
            return BadRequest(new
            {
                error = "invalid_request",
                message = "Email and verification code are required."
            });
        }

        try
        {
            var result = await _adminAuthService.VerifyOtpAsync(
                request.Email,
                request.Otp,
                GetClientIpAddress(),
                GetUserAgent());

            if (!result.Success)
            {
                _logger.LogWarning("OTP verification failed for {Email}: {Error}", request.Email, result.ErrorMessage);
                return Unauthorized(new
                {
                    error = "verification_failed",
                    message = result.ErrorMessage
                });
            }

            _logger.LogInformation("Admin authenticated via OTP: {AdminId}", result.Admin?.Id);

            return Ok(new
            {
                accessToken = result.AccessToken,
                refreshToken = result.RefreshToken,
                expiresIn = result.ExpiresIn,
                tokenType = "Bearer",
                admin = result.Admin
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error verifying OTP for {Email}", request.Email);
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to verify code."
            });
        }
    }

    // ==================== SESSION ENDPOINTS ====================

    /// <summary>
    /// Get current admin session information.
    /// </summary>
    [Authorize(Policy = "AdminOnly")]
    [HttpGet("session")]
    public async Task<IActionResult> GetSession()
    {
        var adminId = GetAdminUserId();
        if (adminId == null)
        {
            return Unauthorized();
        }

        // Get refresh token from header or body
        var refreshToken = Request.Headers["X-Refresh-Token"].FirstOrDefault();

        if (string.IsNullOrWhiteSpace(refreshToken))
        {
            return BadRequest(new
            {
                error = "invalid_request",
                message = "Refresh token required in X-Refresh-Token header."
            });
        }

        try
        {
            var session = await _adminAuthService.GetSessionAsync(adminId.Value, refreshToken);

            if (session == null)
            {
                return Unauthorized(new
                {
                    error = "session_expired",
                    message = "Session not found or expired."
                });
            }

            return Ok(new
            {
                session = new
                {
                    sessionId = session.SessionId,
                    adminId = session.AdminId,
                    email = session.Email,
                    displayName = session.DisplayName,
                    role = session.Role,
                    permissions = session.Permissions,
                    authMethod = session.AuthMethod,
                    createdAt = session.CreatedAt,
                    expiresAt = session.ExpiresAt,
                    lastActivityAt = session.LastActivityAt
                }
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting session for admin {AdminId}", adminId);
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to get session information."
            });
        }
    }

    /// <summary>
    /// Refresh admin session tokens.
    /// </summary>
    [HttpPost("session/refresh")]
    public async Task<IActionResult> RefreshSession([FromBody] AdminRefreshRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.RefreshToken))
        {
            return BadRequest(new
            {
                error = "invalid_request",
                message = "Refresh token is required."
            });
        }

        try
        {
            var result = await _adminAuthService.RefreshSessionAsync(request.RefreshToken);

            if (!result.Success)
            {
                _logger.LogWarning("Session refresh failed: {Error}", result.ErrorMessage);
                return Unauthorized(new
                {
                    error = "refresh_failed",
                    message = result.ErrorMessage
                });
            }

            return Ok(new
            {
                accessToken = result.AccessToken,
                refreshToken = result.RefreshToken,
                expiresIn = result.ExpiresIn,
                tokenType = "Bearer",
                admin = result.Admin
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error refreshing session");
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to refresh session."
            });
        }
    }

    /// <summary>
    /// Logout and invalidate admin session.
    /// </summary>
    [Authorize(Policy = "AdminOnly")]
    [HttpPost("logout")]
    public async Task<IActionResult> Logout([FromBody] AdminLogoutRequest? request)
    {
        var adminId = GetAdminUserId();
        if (adminId == null)
        {
            return Unauthorized();
        }

        try
        {
            await _adminAuthService.LogoutAsync(adminId.Value, request?.RefreshToken);

            _logger.LogInformation("Admin logged out: {AdminId}", adminId);

            return Ok(new
            {
                message = "Logged out successfully."
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error logging out admin {AdminId}", adminId);
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to logout."
            });
        }
    }

    // ==================== PASSKEY MANAGEMENT ====================

    /// <summary>
    /// List admin's registered passkeys.
    /// </summary>
    [Authorize(Policy = "AdminOnly")]
    [HttpGet("passkey")]
    public async Task<IActionResult> ListPasskeys()
    {
        var adminId = GetAdminUserId();
        if (adminId == null)
        {
            return Unauthorized();
        }

        try
        {
            var passkeys = await _adminAuthService.GetAdminPasskeysAsync(adminId.Value);

            return Ok(new
            {
                passkeys = passkeys.Select(p => new
                {
                    id = p.Id,
                    deviceName = p.DeviceName,
                    credentialType = p.CredentialType,
                    isActive = p.IsActive,
                    lastUsedAt = p.LastUsedAt,
                    createdAt = p.CreatedAt
                })
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error listing passkeys for admin {AdminId}", adminId);
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to list passkeys."
            });
        }
    }

    /// <summary>
    /// Delete an admin passkey.
    /// </summary>
    [Authorize(Policy = "AdminOnly")]
    [HttpDelete("passkey/{id:guid}")]
    public async Task<IActionResult> DeletePasskey(Guid id)
    {
        var adminId = GetAdminUserId();
        if (adminId == null)
        {
            return Unauthorized();
        }

        try
        {
            var deleted = await _adminAuthService.DeletePasskeyAsync(adminId.Value, id);

            if (!deleted)
            {
                return NotFound(new
                {
                    error = "passkey_not_found",
                    message = "Passkey not found."
                });
            }

            _logger.LogInformation("Passkey {PasskeyId} deleted for admin {AdminId}", id, adminId);

            return Ok(new
            {
                message = "Passkey deleted successfully."
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting passkey {PasskeyId} for admin {AdminId}", id, adminId);
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to delete passkey."
            });
        }
    }

    // ==================== HELPER METHODS ====================

    private Guid? GetAdminUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var adminId))
        {
            return null;
        }
        return adminId;
    }

    private string GetClientIpAddress()
    {
        var ipAddress = HttpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown";

        if (Request.Headers.ContainsKey("X-Forwarded-For"))
        {
            ipAddress = Request.Headers["X-Forwarded-For"].ToString().Split(',')[0].Trim();
        }

        return ipAddress;
    }

    private string? GetUserAgent()
    {
        return Request.Headers.UserAgent.ToString();
    }
}

// Request DTOs

public record AdminCheckRequest(string Email);

public record AdminPasskeyChallengeRequest(string? Email = null);

public record AdminPasskeyRegisterRequest(
    string CredentialId,
    string PublicKey,
    uint SignatureCounter,
    string? AaGuid,
    string? DeviceName,
    string? AttestationFormat,
    bool UserVerified
);

public record AdminPasskeyVerifyRequest(
    string CredentialId,
    string AuthenticatorData,
    string ClientDataJson,
    string Signature,
    uint SignatureCounter
);

public record AdminOtpRequest(string Email);

public record AdminOtpVerifyRequest(string Email, string Otp);

public record AdminRefreshRequest(string RefreshToken);

public record AdminLogoutRequest(string? RefreshToken = null);
