using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;
using System.Security.Claims;
using System.Text.RegularExpressions;

namespace SilentID.Api.Controllers;

/// <summary>
/// User profile management endpoints
/// </summary>
[ApiController]
[Route("v1/users")]
[Authorize]
public class UsersController : ControllerBase
{
    private readonly SilentIdDbContext _context;
    private readonly ILogger<UsersController> _logger;

    public UsersController(
        SilentIdDbContext context,
        ILogger<UsersController> logger)
    {
        _context = context;
        _logger = logger;
    }

    /// <summary>
    /// Get current user's profile
    /// </summary>
    /// <returns>User profile information</returns>
    [HttpGet("me")]
    public async Task<IActionResult> GetCurrentUser()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            return Unauthorized(new { error = "invalid_token", message = "Invalid authentication token." });
        }

        try
        {
            var user = await _context.Users
                .AsNoTracking()
                .FirstOrDefaultAsync(u => u.Id == userId);

            if (user == null)
            {
                _logger.LogWarning("User not found: {UserId}", userId);
                return NotFound(new { error = "user_not_found", message = "User not found." });
            }

            // Return user profile (excluding sensitive internal fields)
            return Ok(new
            {
                id = user.Id,
                email = user.Email,
                username = user.Username,
                displayName = user.DisplayName,
                phoneNumber = user.PhoneNumber,
                isEmailVerified = user.IsEmailVerified,
                isPhoneVerified = user.IsPhoneVerified,
                isPasskeyEnabled = user.IsPasskeyEnabled,
                accountStatus = user.AccountStatus.ToString(),
                accountType = user.AccountType.ToString(),
                createdAt = user.CreatedAt
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving user profile: {UserId}", userId);
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to retrieve user profile. Please try again."
            });
        }
    }

    /// <summary>
    /// Update current user's profile (displayName and/or username)
    /// </summary>
    /// <param name="request">Profile update request</param>
    /// <returns>Updated user profile</returns>
    [HttpPatch("me")]
    public async Task<IActionResult> UpdateCurrentUser([FromBody] UpdateProfileRequest request)
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            return Unauthorized(new { error = "invalid_token", message = "Invalid authentication token." });
        }

        if (!ModelState.IsValid)
        {
            return BadRequest(new { error = "invalid_request", message = "Invalid request data." });
        }

        // Validate at least one field is being updated
        if (string.IsNullOrWhiteSpace(request.DisplayName) && string.IsNullOrWhiteSpace(request.Username))
        {
            return BadRequest(new
            {
                error = "invalid_request",
                message = "At least one field (displayName or username) must be provided."
            });
        }

        try
        {
            var user = await _context.Users.FindAsync(userId);

            if (user == null)
            {
                _logger.LogWarning("User not found: {UserId}", userId);
                return NotFound(new { error = "user_not_found", message = "User not found." });
            }

            // Update display name if provided
            if (!string.IsNullOrWhiteSpace(request.DisplayName))
            {
                var displayName = request.DisplayName.Trim();

                // Validate display name format (2-50 chars, first name + initial format)
                if (displayName.Length < 2 || displayName.Length > 50)
                {
                    return BadRequest(new
                    {
                        error = "invalid_display_name",
                        message = "Display name must be between 2 and 50 characters."
                    });
                }

                // Validate display name follows "FirstName I." pattern (flexible validation)
                if (!IsValidDisplayName(displayName))
                {
                    return BadRequest(new
                    {
                        error = "invalid_display_name",
                        message = "Display name should follow the format 'FirstName I.' (e.g., 'Sarah M.')."
                    });
                }

                user.DisplayName = displayName;
            }

            // Update username if provided
            if (!string.IsNullOrWhiteSpace(request.Username))
            {
                var username = request.Username.Trim().ToLowerInvariant();

                // Validate username format (3-30 chars, alphanumeric + underscore, starts with letter)
                if (!IsValidUsername(username))
                {
                    return BadRequest(new
                    {
                        error = "invalid_username",
                        message = "Username must be 3-30 characters, alphanumeric or underscore, and start with a letter."
                    });
                }

                // Check username change frequency (max 1 per 30 days)
                var daysSinceLastUpdate = (DateTime.UtcNow - user.UpdatedAt).TotalDays;
                if (user.Username != username && daysSinceLastUpdate < 30)
                {
                    return BadRequest(new
                    {
                        error = "username_change_limit",
                        message = $"You can only change your username once every 30 days. Please try again in {Math.Ceiling(30 - daysSinceLastUpdate)} days."
                    });
                }

                // Check username uniqueness
                var existingUser = await _context.Users
                    .AsNoTracking()
                    .FirstOrDefaultAsync(u => u.Username == username && u.Id != userId);

                if (existingUser != null)
                {
                    return Conflict(new
                    {
                        error = "username_taken",
                        message = "This username is already taken. Please choose a different one."
                    });
                }

                user.Username = username;
            }

            // Update timestamp
            user.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            _logger.LogInformation("User profile updated: {UserId}", userId);

            // Return updated user profile
            return Ok(new
            {
                id = user.Id,
                email = user.Email,
                username = user.Username,
                displayName = user.DisplayName,
                phoneNumber = user.PhoneNumber,
                isEmailVerified = user.IsEmailVerified,
                isPhoneVerified = user.IsPhoneVerified,
                isPasskeyEnabled = user.IsPasskeyEnabled,
                accountStatus = user.AccountStatus.ToString(),
                accountType = user.AccountType.ToString(),
                createdAt = user.CreatedAt
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error updating user profile: {UserId}", userId);
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to update user profile. Please try again."
            });
        }
    }

    /// <summary>
    /// Delete current user's account (soft delete, GDPR compliant)
    /// </summary>
    /// <returns>Deletion confirmation message</returns>
    [HttpDelete("me")]
    public async Task<IActionResult> DeleteCurrentUser()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

        if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
        {
            return Unauthorized(new { error = "invalid_token", message = "Invalid authentication token." });
        }

        try
        {
            var user = await _context.Users.FindAsync(userId);

            if (user == null)
            {
                _logger.LogWarning("User not found: {UserId}", userId);
                return NotFound(new { error = "user_not_found", message = "User not found." });
            }

            // Soft delete: Suspend account and mark for deletion
            // Full deletion will happen after 30-day grace period (handled by background job)
            user.AccountStatus = AccountStatus.Suspended;
            user.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            _logger.LogInformation("User account marked for deletion: {UserId}", userId);

            return Ok(new
            {
                message = "Account deletion scheduled. You have 30 days to cancel by contacting support.",
                deletionScheduledAt = user.UpdatedAt,
                finalDeletionDate = user.UpdatedAt.AddDays(30)
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error deleting user account: {UserId}", userId);
            return StatusCode(500, new
            {
                error = "internal_error",
                message = "Failed to delete account. Please try again."
            });
        }
    }

    // Helper methods

    /// <summary>
    /// Validate username format (3-30 chars, alphanumeric + underscore, starts with letter)
    /// </summary>
    private bool IsValidUsername(string username)
    {
        if (string.IsNullOrWhiteSpace(username))
            return false;

        if (username.Length < 3 || username.Length > 30)
            return false;

        // Must start with a letter
        if (!char.IsLetter(username[0]))
            return false;

        // Only alphanumeric and underscore allowed
        var regex = new Regex(@"^[a-z][a-z0-9_]*$", RegexOptions.IgnoreCase);
        return regex.IsMatch(username);
    }

    /// <summary>
    /// Validate display name format (2-50 chars, first name + initial pattern)
    /// </summary>
    private bool IsValidDisplayName(string displayName)
    {
        if (string.IsNullOrWhiteSpace(displayName))
            return false;

        if (displayName.Length < 2 || displayName.Length > 50)
            return false;

        // Flexible validation: Allow "FirstName I." pattern or similar reasonable formats
        // Example valid formats: "Sarah M.", "John D", "Alice"
        // Must contain at least one letter
        return displayName.Any(char.IsLetter);
    }
}

/// <summary>
/// Request DTO for updating user profile
/// </summary>
public record UpdateProfileRequest(
    string? DisplayName = null,
    string? Username = null
);
