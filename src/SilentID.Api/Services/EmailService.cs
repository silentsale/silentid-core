using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace SilentID.Api.Services;

public interface IEmailService
{
    Task SendOtpEmailAsync(string toEmail, string otp, int expiryMinutes);
    Task SendWelcomeEmailAsync(string toEmail, string displayName);
    Task SendAccountSecurityAlertAsync(string toEmail, string alertMessage);
    Task SendAdminOtpEmailAsync(string toEmail, string otp, int expiryMinutes);
    Task SendIdentityVerifiedEmailAsync(string toEmail, string displayName);
    Task SendProfileVerifiedEmailAsync(string toEmail, string displayName, string platformName, string profileUsername);
    Task SendRatingDropAlertAsync(string toEmail, string displayName, string platformName, decimal oldRating, decimal newRating);
    Task SendPlatformWatchdogAlertAsync(string toEmail, string displayName, string platformName, string alertMessage);
    Task SendReVerificationReminderAsync(string toEmail, string displayName, string platformName, int daysUntilExpiry);
    Task SendAccountDeletionConfirmationAsync(string toEmail, string displayName);
}

/// <summary>
/// Email service using MailerSend REST API for production-ready email delivery.
/// Uses the official MailerSend API directly (https://developers.mailersend.com/).
/// Falls back to console logging in development if MailerSend is not configured.
/// </summary>
public class EmailService : IEmailService
{
    private readonly ILogger<EmailService> _logger;
    private readonly IConfiguration _configuration;
    private readonly HttpClient _httpClient;
    private readonly bool _isMailerSendConfigured;
    private readonly string _senderEmail;
    private readonly string _senderName;

    private const string MailerSendApiUrl = "https://api.mailersend.com/v1/email";

    public EmailService(
        ILogger<EmailService> logger,
        IConfiguration configuration,
        IHttpClientFactory httpClientFactory)
    {
        _logger = logger;
        _configuration = configuration;
        _httpClient = httpClientFactory.CreateClient("MailerSend");

        var apiToken = _configuration["MailerSend:ApiToken"];
        _senderEmail = _configuration["MailerSend:SenderEmail"] ?? "noreply@silentid.co.uk";
        _senderName = _configuration["MailerSend:SenderName"] ?? "SilentID";

        _isMailerSendConfigured = !string.IsNullOrEmpty(apiToken);

        if (_isMailerSendConfigured)
        {
            _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", apiToken);
            _httpClient.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
            _logger.LogInformation("MailerSend email service initialized (using official REST API)");
        }
        else
        {
            _logger.LogWarning("MailerSend API token not configured - emails will be logged to console only");
        }
    }

    private async Task SendEmailAsync(string toEmail, string? toName, string subject, string textContent, string htmlContent)
    {
        if (_isMailerSendConfigured)
        {
            try
            {
                var emailRequest = new MailerSendEmailRequest
                {
                    From = new EmailRecipient { Email = _senderEmail, Name = _senderName },
                    To = new List<EmailRecipient> { new EmailRecipient { Email = toEmail, Name = toName } },
                    Subject = subject,
                    Text = textContent,
                    Html = htmlContent
                };

                var jsonOptions = new JsonSerializerOptions
                {
                    PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower,
                    DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
                };

                var json = JsonSerializer.Serialize(emailRequest, jsonOptions);
                var content = new StringContent(json, Encoding.UTF8, "application/json");

                var response = await _httpClient.PostAsync(MailerSendApiUrl, content);

                if (response.IsSuccessStatusCode)
                {
                    var messageId = response.Headers.Contains("x-message-id")
                        ? response.Headers.GetValues("x-message-id").FirstOrDefault()
                        : "unknown";
                    _logger.LogInformation("Email sent successfully to {Email}. Message ID: {MessageId}", toEmail, messageId);
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    _logger.LogError("Failed to send email to {Email}. Status: {Status}, Error: {Error}",
                        toEmail, response.StatusCode, errorContent);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending email to {Email}", toEmail);
                throw;
            }
        }
        else
        {
            LogEmailToConsole(toEmail, subject, textContent);
        }
    }

    public async Task SendOtpEmailAsync(string toEmail, string otp, int expiryMinutes)
    {
        // ALWAYS log OTP to console for development/testing
        _logger.LogInformation("OTP CODE FOR {Email}: {Otp} (expires in {ExpiryMinutes} minutes)", toEmail, otp, expiryMinutes);

        await SendEmailAsync(
            toEmail,
            null,
            "Your SilentID Verification Code",
            $"Your SilentID verification code is: {otp}\n\nThis code expires in {expiryMinutes} minutes.\n\nIf you didn't request this code, please ignore this email.",
            GenerateOtpEmailHtml(otp, expiryMinutes));
    }

    public async Task SendWelcomeEmailAsync(string toEmail, string displayName)
    {
        _logger.LogInformation("Sending welcome email to {Email}", toEmail);

        // Extract the first name part (remove trailing numbers from auto-generated username)
        var firstName = System.Text.RegularExpressions.Regex.Replace(displayName, @"\d+$", "");

        await SendEmailAsync(
            toEmail,
            displayName,
            "Welcome to SilentID - Your Portable Trust Passport",
            $"Hi {firstName},\n\nWelcome to SilentID - Your Portable Trust Passport!\n\nYour username is currently {displayName}. You can customize it anytime in Settings.\n\nComplete your profile to build your TrustScore:\n- Verify your identity\n- Connect your marketplace profiles (Vinted, eBay, Depop)\n- Add evidence to your vault\n\nHonest people rise. Scammers fail.\n\n- The SilentID Team",
            GenerateWelcomeEmailHtml(firstName, displayName));
    }

    public async Task SendAccountSecurityAlertAsync(string toEmail, string alertMessage)
    {
        _logger.LogInformation("Sending security alert to {Email}", toEmail);

        await SendEmailAsync(
            toEmail,
            null,
            "SilentID Security Alert",
            $"Security Alert:\n\n{alertMessage}\n\nIf this wasn't you, please secure your account immediately.",
            GenerateSecurityAlertEmailHtml(alertMessage));
    }

    public async Task SendAdminOtpEmailAsync(string toEmail, string otp, int expiryMinutes)
    {
        // ALWAYS log OTP to console for development/testing
        _logger.LogInformation("ADMIN OTP CODE FOR {Email}: {Otp} (expires in {ExpiryMinutes} minutes)", toEmail, otp, expiryMinutes);

        await SendEmailAsync(
            toEmail,
            null,
            "SilentID Admin Panel - Verification Code",
            $"Your SilentID Admin Panel verification code is: {otp}\n\nThis code expires in {expiryMinutes} minutes.\n\nIf you didn't request this code, please contact your security team immediately.",
            GenerateAdminOtpEmailHtml(otp, expiryMinutes));
    }

    public async Task SendIdentityVerifiedEmailAsync(string toEmail, string displayName)
    {
        _logger.LogInformation("Sending identity verified email to {Email}", toEmail);

        await SendEmailAsync(
            toEmail,
            displayName,
            "Identity Verified - Your TrustScore Has Increased!",
            $"Hi {displayName},\n\nCongratulations! Your identity has been verified.\n\nYour TrustScore has increased and your Trust Passport now shows a verified badge.\n\n- The SilentID Team",
            GenerateIdentityVerifiedEmailHtml(displayName));
    }

    public async Task SendProfileVerifiedEmailAsync(string toEmail, string displayName, string platformName, string profileUsername)
    {
        _logger.LogInformation("Sending profile verified email to {Email} for {Platform}", toEmail, platformName);

        await SendEmailAsync(
            toEmail,
            displayName,
            $"Profile Verified - {platformName}",
            $"Hi {displayName},\n\nYour {platformName} profile (@{profileUsername}) has been verified!\n\nYour TrustScore has increased and this profile now appears on your Trust Passport.\n\n- The SilentID Team",
            GenerateProfileVerifiedEmailHtml(displayName, platformName, profileUsername));
    }

    public async Task SendRatingDropAlertAsync(string toEmail, string displayName, string platformName, decimal oldRating, decimal newRating)
    {
        _logger.LogInformation("Sending rating drop alert to {Email} for {Platform}: {Old} -> {New}", toEmail, platformName, oldRating, newRating);

        await SendEmailAsync(
            toEmail,
            displayName,
            $"Rating Alert - {platformName}",
            $"Hi {displayName},\n\nWe noticed your {platformName} rating changed from {oldRating:0.0} to {newRating:0.0}.\n\nThis is part of your Pro subscription rating protection alerts.\n\n- The SilentID Team",
            GenerateRatingDropAlertEmailHtml(displayName, platformName, oldRating, newRating));
    }

    public async Task SendPlatformWatchdogAlertAsync(string toEmail, string displayName, string platformName, string alertMessage)
    {
        _logger.LogInformation("Sending platform watchdog alert to {Email} for {Platform}", toEmail, platformName);

        await SendEmailAsync(
            toEmail,
            displayName,
            $"Platform Alert - {platformName}",
            $"Hi {displayName},\n\nPlatform Watchdog Alert for {platformName}:\n\n{alertMessage}\n\nYour reputation is backed up with SilentID.\n\n- The SilentID Team",
            GeneratePlatformWatchdogAlertEmailHtml(displayName, platformName, alertMessage));
    }

    public async Task SendReVerificationReminderAsync(string toEmail, string displayName, string platformName, int daysUntilExpiry)
    {
        _logger.LogInformation("Sending re-verification reminder to {Email} for {Platform}", toEmail, platformName);

        await SendEmailAsync(
            toEmail,
            displayName,
            $"Re-verify Your {platformName} Profile",
            $"Hi {displayName},\n\nYour {platformName} profile verification expires in {daysUntilExpiry} days.\n\nPlease re-verify to keep your verified status and TrustScore.\n\n- The SilentID Team",
            GenerateReVerificationReminderEmailHtml(displayName, platformName, daysUntilExpiry));
    }

    public async Task SendAccountDeletionConfirmationAsync(string toEmail, string displayName)
    {
        _logger.LogInformation("Sending account deletion confirmation to {Email}", toEmail);

        await SendEmailAsync(
            toEmail,
            displayName,
            "Account Deleted - SilentID",
            $"Hi {displayName},\n\nYour SilentID account has been deleted as requested.\n\nAll your data has been permanently removed.\n\nIf you didn't request this, please contact us immediately at support@silentid.co.uk.\n\n- The SilentID Team",
            GenerateAccountDeletionEmailHtml(displayName));
    }

    #region MailerSend API Models

    private class MailerSendEmailRequest
    {
        public EmailRecipient From { get; set; } = null!;
        public List<EmailRecipient> To { get; set; } = new();
        public string Subject { get; set; } = null!;
        public string? Text { get; set; }
        public string? Html { get; set; }
    }

    private class EmailRecipient
    {
        public string Email { get; set; } = null!;
        public string? Name { get; set; }
    }

    #endregion

    #region Email HTML Templates

    private void LogEmailToConsole(string toEmail, string subject, string body)
    {
        _logger.LogInformation("EMAIL: {Subject} to {Email}", subject, toEmail);
        _logger.LogInformation("---");
        _logger.LogInformation("To: {Email}", toEmail);
        _logger.LogInformation("Subject: {Subject}", subject);
        _logger.LogInformation("Body: {Body}", body);
        _logger.LogInformation("---");
    }

    private string GenerateOtpEmailHtml(string otp, int expiryMinutes)
    {
        return GenerateEmailWrapper("Your SilentID Verification Code", $@"
            <p style=""color: #111111; font-size: 16px; margin: 0 0 20px 0;"">Your verification code is:</p>
            <div style=""background: linear-gradient(135deg, #5A3EB8 0%, #7B5DC9 100%); border-radius: 12px; padding: 24px; font-size: 36px; font-weight: bold; letter-spacing: 12px; color: #FFFFFF; text-align: center;"">{otp}</div>
            <p style=""color: #4C4C4C; font-size: 14px; margin-top: 20px; text-align: center;"">This code expires in <strong>{expiryMinutes} minutes</strong></p>
            <p style=""color: #888888; font-size: 12px; margin-top: 20px; text-align: center;"">If you didn't request this code, please ignore this email.</p>
        ");
    }

    private string GenerateAdminOtpEmailHtml(string otp, int expiryMinutes)
    {
        return $@"
<!DOCTYPE html>
<html>
<head>
    <meta charset=""UTF-8"">
    <title>SilentID Admin Panel - Verification Code</title>
</head>
<body style=""font-family: Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background: linear-gradient(180deg, #1a1a2e 0%, #16162a 100%);"">
    <div style=""text-align: center; padding: 40px 0;"">
        <img src=""https://raw.githubusercontent.com/silentsale/silentid-core/main/assets/branding/logo-email.png"" alt=""SilentID"" style=""height: 40px; margin-bottom: 8px; filter: brightness(0) invert(1);"" onerror=""this.style.display='none';this.nextElementSibling.style.display='block';"">
        <h1 style=""color: #5A3EB8; margin: 0; display: none;"">SilentID</h1>
        <div style=""display: inline-block; background: rgba(90, 62, 184, 0.2); border: 1px solid #5A3EB8; color: #5A3EB8; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; margin-top: 12px;"">ADMIN PANEL</div>
    </div>

    <div style=""background: rgba(42, 42, 64, 0.8); border: 1px solid rgba(90, 62, 184, 0.3); border-radius: 16px; padding: 32px; text-align: center;"">
        <p style=""color: #ffffff; font-size: 16px; margin: 0 0 24px 0;"">Your verification code is:</p>
        <div style=""background: linear-gradient(135deg, #5A3EB8 0%, #7B5DC9 100%); border-radius: 12px; padding: 24px; font-size: 40px; font-weight: bold; letter-spacing: 12px; color: #ffffff;"">{otp}</div>
        <p style=""color: #888888; font-size: 14px; margin-top: 24px;"">This code expires in <strong style=""color: #fff;"">{expiryMinutes} minutes</strong></p>
    </div>

    <div style=""text-align: center; padding: 30px 0; font-size: 12px;"">
        <p style=""color: #ff4444; margin-bottom: 16px;"">⚠️ If you didn't request this code, contact your security team immediately.</p>
        <p style=""color: #666666; margin: 0;"">© 2025 SilentID Admin. Internal Use Only.</p>
    </div>
</body>
</html>
";
    }

    private string GenerateWelcomeEmailHtml(string firstName, string username)
    {
        return GenerateEmailWrapper("Welcome to SilentID", $@"
            <div style=""text-align: center; margin-bottom: 24px;"">
                <div style=""background: linear-gradient(135deg, #10B981 0%, #059669 100%); color: white; width: 64px; height: 64px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 32px;"">🎉</div>
            </div>
            <h2 style=""color: #111111; font-size: 24px; margin: 0 0 16px 0; text-align: center;"">Welcome, {firstName}!</h2>
            <p style=""color: #4C4C4C; font-size: 16px; line-height: 1.6; text-align: center;"">Your Portable Trust Passport is ready. Build trust once, use it everywhere.</p>

            <div style=""background: #F5F3FF; border-radius: 12px; padding: 20px; margin: 24px 0;"">
                <p style=""color: #5A3EB8; font-size: 14px; margin: 0 0 16px 0; font-weight: 600;"">GET STARTED:</p>
                <div style=""display: flex; align-items: center; margin-bottom: 12px;"">
                    <div style=""background: #5A3EB8; color: white; width: 28px; height: 28px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 14px; margin-right: 12px; flex-shrink: 0;"">1</div>
                    <span style=""color: #4C4C4C;"">Verify your identity <span style=""color: #10B981; font-weight: 600;"">+100 pts</span></span>
                </div>
                <div style=""display: flex; align-items: center; margin-bottom: 12px;"">
                    <div style=""background: #5A3EB8; color: white; width: 28px; height: 28px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 14px; margin-right: 12px; flex-shrink: 0;"">2</div>
                    <span style=""color: #4C4C4C;"">Connect marketplace profiles <span style=""color: #10B981; font-weight: 600;"">+150 pts</span></span>
                </div>
                <div style=""display: flex; align-items: center;"">
                    <div style=""background: #5A3EB8; color: white; width: 28px; height: 28px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 14px; margin-right: 12px; flex-shrink: 0;"">3</div>
                    <span style=""color: #4C4C4C;"">Add evidence to vault <span style=""color: #10B981; font-weight: 600;"">+100 pts</span></span>
                </div>
            </div>

            <div style=""text-align: center; margin-top: 24px;"">
                <a href=""https://silentid.co.uk/app"" style=""background: linear-gradient(135deg, #5A3EB8 0%, #7B5DC9 100%); color: white; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; display: inline-block;"">Open SilentID App</a>
            </div>
        ");
    }

    private string GenerateSecurityAlertEmailHtml(string alertMessage)
    {
        var now = DateTime.UtcNow;
        return GenerateEmailWrapper("Security Alert", $@"
            <div style=""text-align: center; margin-bottom: 20px;"">
                <div style=""background: #FEF2F2; color: #DC2626; width: 64px; height: 64px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 32px;"">🔐</div>
            </div>
            <h2 style=""color: #DC2626; font-size: 22px; margin: 0 0 16px 0; text-align: center;"">Security Alert</h2>
            <div style=""background: #FEF2F2; border-radius: 12px; padding: 20px; margin-bottom: 20px;"">
                <p style=""color: #7F1D1D; font-size: 16px; margin: 0; line-height: 1.6;"">{alertMessage}</p>
            </div>
            <div style=""background: #F9FAFB; border-radius: 8px; padding: 16px; margin-bottom: 20px;"">
                <p style=""color: #4C4C4C; font-size: 14px; margin: 0 0 8px 0;""><strong>Time:</strong> {now:MMMM d, yyyy} at {now:h:mm tt} UTC</p>
            </div>
            <div style=""text-align: center;"">
                <a href=""mailto:support@silentid.co.uk"" style=""background: #DC2626; color: white; padding: 12px 24px; border-radius: 8px; text-decoration: none; font-weight: 600; display: inline-block;"">Secure My Account</a>
            </div>
        ");
    }

    private string GenerateIdentityVerifiedEmailHtml(string displayName)
    {
        return GenerateEmailWrapper("Identity Verified!", $@"
            <div style=""text-align: center; margin-bottom: 24px;"">
                <div style=""background: linear-gradient(135deg, #10B981 0%, #059669 100%); color: white; width: 80px; height: 80px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 40px; box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);"">✓</div>
            </div>
            <h2 style=""color: #111111; font-size: 24px; text-align: center; margin: 0 0 8px 0;"">Identity Verified!</h2>
            <p style=""color: #4C4C4C; font-size: 16px; text-align: center; line-height: 1.6;"">Congratulations, {displayName}!</p>

            <div style=""background: linear-gradient(135deg, #F5F3FF 0%, #EDE9FE 100%); border-radius: 12px; padding: 24px; margin: 24px 0; text-align: center;"">
                <p style=""color: #5A3EB8; font-size: 14px; font-weight: 600; margin: 0 0 8px 0;"">TRUSTSCORE BOOST</p>
                <p style=""color: #5A3EB8; font-size: 36px; font-weight: 700; margin: 0;"">+100</p>
                <p style=""color: #6B7280; font-size: 14px; margin-top: 8px;"">Your Trust Passport now displays a verified badge</p>
            </div>

            <div style=""text-align: center; margin-top: 24px;"">
                <a href=""https://silentid.co.uk/app"" style=""background: linear-gradient(135deg, #5A3EB8 0%, #7B5DC9 100%); color: white; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; display: inline-block;"">View My Passport</a>
            </div>
        ");
    }

    private string GenerateProfileVerifiedEmailHtml(string displayName, string platformName, string profileUsername)
    {
        return GenerateEmailWrapper($"Profile Verified - {platformName}", $@"
            <div style=""text-align: center; margin-bottom: 24px;"">
                <div style=""background: linear-gradient(135deg, #10B981 0%, #059669 100%); color: white; width: 80px; height: 80px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 40px; box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);"">✓</div>
            </div>
            <h2 style=""color: #111111; font-size: 24px; text-align: center; margin: 0 0 16px 0;"">{platformName} Verified!</h2>

            <div style=""background: #F0FDF4; border: 2px solid #10B981; border-radius: 12px; padding: 20px; margin: 24px 0; text-align: center;"">
                <p style=""color: #166534; font-size: 20px; font-weight: 600; margin: 0;"">@{profileUsername}</p>
                <p style=""color: #166534; font-size: 14px; margin-top: 8px;"">Profile verified and backed up</p>
            </div>

            <div style=""background: linear-gradient(135deg, #F5F3FF 0%, #EDE9FE 100%); border-radius: 12px; padding: 20px; margin: 24px 0; text-align: center;"">
                <p style=""color: #5A3EB8; font-size: 14px; font-weight: 600; margin: 0 0 8px 0;"">TRUSTSCORE BOOST</p>
                <p style=""color: #5A3EB8; font-size: 32px; font-weight: 700; margin: 0;"">+75</p>
            </div>

            <div style=""text-align: center; margin-top: 24px;"">
                <a href=""https://silentid.co.uk/app"" style=""background: linear-gradient(135deg, #5A3EB8 0%, #7B5DC9 100%); color: white; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; display: inline-block;"">View My Passport</a>
            </div>
        ");
    }

    private string GenerateRatingDropAlertEmailHtml(string displayName, string platformName, decimal oldRating, decimal newRating)
    {
        var now = DateTime.UtcNow;
        var change = newRating - oldRating;
        var changeText = change < 0 ? $"{change:0.0}" : $"+{change:0.0}";

        return GenerateEmailWrapper($"Rating Alert - {platformName}", $@"
            <div style=""text-align: center; margin-bottom: 20px;"">
                <div style=""background: #FEF3C7; color: #F59E0B; width: 64px; height: 64px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 32px;"">📊</div>
            </div>
            <h2 style=""color: #111111; font-size: 22px; margin: 0 0 8px 0; text-align: center;"">Rating Alert: {platformName}</h2>
            <p style=""color: #6B7280; font-size: 14px; text-align: center;"">{now:MMMM d, yyyy}</p>

            <div style=""background: #FEF2F2; border-radius: 12px; padding: 24px; margin: 24px 0; text-align: center;"">
                <div style=""display: flex; justify-content: center; align-items: center; gap: 20px;"">
                    <div>
                        <p style=""color: #6B7280; font-size: 12px; margin: 0 0 4px 0;"">BEFORE</p>
                        <p style=""color: #4C4C4C; font-size: 36px; font-weight: 700; margin: 0;"">{oldRating:0.0}</p>
                    </div>
                    <div style=""color: #DC2626; font-size: 24px;"">→</div>
                    <div>
                        <p style=""color: #6B7280; font-size: 12px; margin: 0 0 4px 0;"">NOW</p>
                        <p style=""color: #DC2626; font-size: 36px; font-weight: 700; margin: 0;"">{newRating:0.0}</p>
                    </div>
                </div>
                <p style=""color: #DC2626; font-size: 14px; margin-top: 16px;"">{changeText} point change detected</p>
            </div>

            <div style=""background: #F0FDF4; border-radius: 8px; padding: 16px; text-align: center;"">
                <p style=""color: #166534; font-size: 14px; margin: 0;"">✓ Your reputation history is backed up and secure</p>
            </div>

            <div style=""text-align: center; margin-top: 24px;"">
                <a href=""https://silentid.co.uk/app"" style=""background: linear-gradient(135deg, #5A3EB8 0%, #7B5DC9 100%); color: white; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; display: inline-block;"">View Rating History</a>
            </div>
        ", "PRO");
    }

    private string GeneratePlatformWatchdogAlertEmailHtml(string displayName, string platformName, string alertMessage)
    {
        var now = DateTime.UtcNow;
        return GenerateEmailWrapper($"Platform Alert - {platformName}", $@"
            <div style=""text-align: center; margin-bottom: 20px;"">
                <div style=""background: #FEF3C7; color: #F59E0B; width: 64px; height: 64px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 32px;"">⚠️</div>
            </div>
            <h2 style=""color: #B45309; font-size: 22px; margin: 0 0 8px 0; text-align: center;"">{platformName} Platform Alert</h2>
            <p style=""color: #6B7280; font-size: 14px; text-align: center; margin-bottom: 20px;"">{now:MMMM d, yyyy}</p>

            <div style=""background: #FEF3C7; border-radius: 12px; padding: 20px; margin-bottom: 20px;"">
                <p style=""color: #78350F; font-size: 16px; margin: 0; line-height: 1.6;"">{alertMessage}</p>
            </div>

            <div style=""background: #F0FDF4; border-radius: 12px; padding: 20px; text-align: center;"">
                <p style=""color: #166534; font-size: 16px; font-weight: 600; margin: 0 0 8px 0;"">Your reputation is protected</p>
                <p style=""color: #166534; font-size: 14px; margin: 0;"">All your {platformName} profile data is backed up and secure</p>
            </div>

            <div style=""text-align: center; margin-top: 24px;"">
                <a href=""https://silentid.co.uk/app"" style=""background: linear-gradient(135deg, #5A3EB8 0%, #7B5DC9 100%); color: white; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; display: inline-block;"">View My Backup</a>
            </div>
        ", "PRO WATCHDOG");
    }

    private string GenerateReVerificationReminderEmailHtml(string displayName, string platformName, int daysUntilExpiry)
    {
        return GenerateEmailWrapper($"Re-verify Your {platformName} Profile", $@"
            <div style=""text-align: center; margin-bottom: 20px;"">
                <div style=""background: #FEF3C7; color: #F59E0B; width: 64px; height: 64px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 32px;"">🔄</div>
            </div>
            <h2 style=""color: #111111; font-size: 22px; margin: 0 0 8px 0; text-align: center;"">Re-verify Your {platformName} Profile</h2>

            <div style=""background: #FEF3C7; border-radius: 12px; padding: 24px; margin: 24px 0; text-align: center;"">
                <p style=""color: #B45309; font-size: 14px; margin: 0 0 8px 0;"">EXPIRES IN</p>
                <p style=""color: #B45309; font-size: 48px; font-weight: 700; margin: 0;"">{daysUntilExpiry}</p>
                <p style=""color: #B45309; font-size: 14px; margin: 0;"">days</p>
            </div>

            <div style=""background: #F9FAFB; border-radius: 8px; padding: 16px; margin-bottom: 20px;"">
                <p style=""color: #4C4C4C; font-size: 14px; margin: 0;""><strong>Profile:</strong> {platformName}</p>
            </div>

            <p style=""color: #6B7280; font-size: 14px; text-align: center; margin-bottom: 20px;"">Re-verify to keep your verified badge and TrustScore points</p>

            <div style=""text-align: center;"">
                <a href=""https://silentid.co.uk/app"" style=""background: linear-gradient(135deg, #F59E0B 0%, #D97706 100%); color: white; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; display: inline-block;"">Re-verify Now</a>
            </div>
        ");
    }

    private string GenerateAccountDeletionEmailHtml(string displayName)
    {
        return GenerateEmailWrapper("Account Deleted", $@"
            <div style=""text-align: center; margin-bottom: 20px;"">
                <div style=""background: #F3F4F6; color: #6B7280; width: 64px; height: 64px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 32px;"">👋</div>
            </div>
            <h2 style=""color: #111111; font-size: 22px; margin: 0 0 16px 0; text-align: center;"">Goodbye, {displayName}</h2>
            <p style=""color: #4C4C4C; font-size: 16px; line-height: 1.6; text-align: center;"">Your SilentID account has been deleted as requested.</p>

            <div style=""background: #F9FAFB; border-radius: 12px; padding: 20px; margin: 24px 0; text-align: center;"">
                <p style=""color: #6B7280; font-size: 14px; margin: 0;"">✓ All personal data permanently removed</p>
                <p style=""color: #6B7280; font-size: 14px; margin: 8px 0 0 0;"">✓ Verified profiles unlinked</p>
                <p style=""color: #6B7280; font-size: 14px; margin: 8px 0 0 0;"">✓ TrustScore data deleted</p>
            </div>

            <div style=""background: #FEF2F2; border-radius: 12px; padding: 20px; margin: 24px 0;"">
                <p style=""color: #DC2626; font-size: 14px; margin: 0; text-align: center;""><strong>Didn't request this?</strong><br/>Contact us immediately at <a href=""mailto:support@silentid.co.uk"" style=""color: #DC2626;"">support@silentid.co.uk</a></p>
            </div>

            <p style=""color: #6B7280; font-size: 14px; text-align: center;"">We're sorry to see you go. You can always create a new account in the future.</p>
        ");
    }

    private string GenerateEmailWrapper(string title, string content, string? badge = null)
    {
        var badgeHtml = badge != null
            ? $@"<div style=""display: inline-block; background: linear-gradient(135deg, #5A3EB8 0%, #7B5DC9 100%); color: white; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; margin-top: 8px;"">{badge}</div>"
            : "";

        return $@"
<!DOCTYPE html>
<html>
<head>
    <meta charset=""UTF-8"">
    <meta name=""viewport"" content=""width=device-width, initial-scale=1.0"">
    <title>{title}</title>
</head>
<body style=""font-family: Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background-color: #F9FAFB;"">
    <!-- Header with Logo -->
    <div style=""text-align: center; padding: 40px 0 20px 0;"">
        <img src=""https://raw.githubusercontent.com/silentsale/silentid-core/main/assets/branding/logo-email.png"" alt=""SilentID"" style=""height: 48px; margin-bottom: 8px;"" onerror=""this.style.display='none';this.nextElementSibling.style.display='block';"">
        <h1 style=""color: #5A3EB8; margin: 0; font-size: 28px; display: none;"">SilentID</h1>
        <p style=""color: #6B7280; margin-top: 8px; font-size: 14px;"">Your Portable Trust Passport</p>
        {badgeHtml}
    </div>

    <!-- Content Card -->
    <div style=""background: #FFFFFF; border-radius: 12px; padding: 32px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);"">
        {content}
    </div>

    <!-- Footer -->
    <div style=""text-align: center; padding: 32px 0; color: #6B7280; font-size: 12px;"">
        <p style=""margin: 0 0 8px 0; color: #5A3EB8; font-weight: 500;"">Honest people rise. Scammers fail.</p>
        <p style=""margin: 0;"">© 2025 SILENTSALE LTD. All rights reserved.</p>
        <p style=""margin: 8px 0 0 0;"">86-90 Paul Street, London EC2A 4NE</p>
        <p style=""margin: 8px 0 0 0;"">
            <a href=""https://silentid.co.uk/privacy"" style=""color: #5A3EB8; text-decoration: none;"">Privacy Policy</a> |
            <a href=""https://silentid.co.uk/terms"" style=""color: #5A3EB8; text-decoration: none;"">Terms of Use</a>
        </p>
    </div>
</body>
</html>
";
    }

    #endregion
}
