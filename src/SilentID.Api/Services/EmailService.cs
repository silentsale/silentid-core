using SendGrid;
using SendGrid.Helpers.Mail;

namespace SilentID.Api.Services;

public interface IEmailService
{
    Task SendOtpEmailAsync(string toEmail, string otp, int expiryMinutes);
    Task SendWelcomeEmailAsync(string toEmail, string displayName);
    Task SendAccountSecurityAlertAsync(string toEmail, string alertMessage);
    Task SendAdminOtpEmailAsync(string toEmail, string otp, int expiryMinutes);
}

/// <summary>
/// Email service using SendGrid for production-ready email delivery.
/// Falls back to console logging in development if SendGrid is not configured.
/// </summary>
public class EmailService : IEmailService
{
    private readonly ILogger<EmailService> _logger;
    private readonly IConfiguration _configuration;
    private readonly ISendGridClient? _sendGridClient;
    private readonly bool _isSendGridConfigured;

    public EmailService(ILogger<EmailService> logger, IConfiguration configuration)
    {
        _logger = logger;
        _configuration = configuration;

        var apiKey = _configuration["SendGrid:ApiKey"];
        if (!string.IsNullOrEmpty(apiKey))
        {
            _sendGridClient = new SendGridClient(apiKey);
            _isSendGridConfigured = true;
            _logger.LogInformation("SendGrid email service initialized");
        }
        else
        {
            _isSendGridConfigured = false;
            _logger.LogWarning("SendGrid API key not configured - emails will be logged to console only");
        }
    }

    public async Task SendOtpEmailAsync(string toEmail, string otp, int expiryMinutes)
    {
        // ALWAYS log OTP to console in development for testing purposes
        _logger.LogInformation("🔐 OTP CODE FOR {Email}: {Otp} (expires in {ExpiryMinutes} minutes)", toEmail, otp, expiryMinutes);

        if (_isSendGridConfigured && _sendGridClient != null)
        {
            try
            {
                var from = new EmailAddress("noreply@silentid.co.uk", "SilentID");
                var to = new EmailAddress(toEmail);
                var subject = "Your SilentID Verification Code";
                var htmlContent = GenerateOtpEmailHtml(otp, expiryMinutes);
                var plainTextContent = $"Your SilentID verification code is: {otp}\n\nThis code expires in {expiryMinutes} minutes.\n\nIf you didn't request this code, please ignore this email.";

                var msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, htmlContent);
                var response = await _sendGridClient.SendEmailAsync(msg);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("OTP email sent successfully to {Email}", toEmail);
                }
                else
                {
                    _logger.LogError("Failed to send OTP email to {Email}. Status: {Status}", toEmail, response.StatusCode);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending OTP email to {Email}", toEmail);
                throw;
            }
        }
        else
        {
            // Development fallback - log to console
            _logger.LogInformation("📧 EMAIL: Sending OTP to {Email}", toEmail);
            _logger.LogInformation("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            _logger.LogInformation("To: {Email}", toEmail);
            _logger.LogInformation("Subject: Your SilentID Verification Code");
            _logger.LogInformation("");
            _logger.LogInformation("Your verification code is:");
            _logger.LogInformation("");
            _logger.LogInformation("    {Otp}", otp);
            _logger.LogInformation("");
            _logger.LogInformation("This code expires in {ExpiryMinutes} minutes.", expiryMinutes);
            _logger.LogInformation("");
            _logger.LogInformation("If you didn't request this code, please ignore this email.");
            _logger.LogInformation("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        }
    }

    public Task SendWelcomeEmailAsync(string toEmail, string displayName)
    {
        _logger.LogInformation("📧 EMAIL: Sending welcome email to {Email}", toEmail);
        _logger.LogInformation("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        _logger.LogInformation("To: {Email}", toEmail);
        _logger.LogInformation("Subject: Welcome to SilentID");
        _logger.LogInformation("");
        _logger.LogInformation("Hi {DisplayName},", displayName);
        _logger.LogInformation("");
        _logger.LogInformation("Welcome to SilentID - Your Portable Trust Passport!");
        _logger.LogInformation("");
        _logger.LogInformation("You can now build your trust profile and share it across platforms.");
        _logger.LogInformation("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

        // TODO: In production, send actual welcome email

        return Task.CompletedTask;
    }

    public Task SendAccountSecurityAlertAsync(string toEmail, string alertMessage)
    {
        _logger.LogInformation("📧 EMAIL: Sending security alert to {Email}", toEmail);
        _logger.LogInformation("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        _logger.LogInformation("To: {Email}", toEmail);
        _logger.LogInformation("Subject: SilentID Security Alert");
        _logger.LogInformation("");
        _logger.LogInformation("Security Alert:");
        _logger.LogInformation("{AlertMessage}", alertMessage);
        _logger.LogInformation("");
        _logger.LogInformation("If this wasn't you, please secure your account immediately.");
        _logger.LogInformation("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

        // TODO: In production, send actual security alert

        return Task.CompletedTask;
    }

    public async Task SendAdminOtpEmailAsync(string toEmail, string otp, int expiryMinutes)
    {
        // ALWAYS log OTP to console in development for testing purposes
        _logger.LogInformation("🔐 ADMIN OTP CODE FOR {Email}: {Otp} (expires in {ExpiryMinutes} minutes)", toEmail, otp, expiryMinutes);

        if (_isSendGridConfigured && _sendGridClient != null)
        {
            try
            {
                var from = new EmailAddress("admin-noreply@silentid.co.uk", "SilentID Admin");
                var to = new EmailAddress(toEmail);
                var subject = "SilentID Admin Panel - Verification Code";
                var htmlContent = GenerateAdminOtpEmailHtml(otp, expiryMinutes);
                var plainTextContent = $"Your SilentID Admin Panel verification code is: {otp}\n\nThis code expires in {expiryMinutes} minutes.\n\nIf you didn't request this code, please contact your security team immediately.";

                var msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, htmlContent);
                var response = await _sendGridClient.SendEmailAsync(msg);

                if (response.IsSuccessStatusCode)
                {
                    _logger.LogInformation("Admin OTP email sent successfully to {Email}", toEmail);
                }
                else
                {
                    _logger.LogError("Failed to send admin OTP email to {Email}. Status: {Status}", toEmail, response.StatusCode);
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error sending admin OTP email to {Email}", toEmail);
                throw;
            }
        }
        else
        {
            // Development fallback - log to console
            _logger.LogInformation("📧 ADMIN EMAIL: Sending OTP to {Email}", toEmail);
            _logger.LogInformation("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
            _logger.LogInformation("To: {Email}", toEmail);
            _logger.LogInformation("Subject: SilentID Admin Panel - Verification Code");
            _logger.LogInformation("");
            _logger.LogInformation("Your admin verification code is:");
            _logger.LogInformation("");
            _logger.LogInformation("    {Otp}", otp);
            _logger.LogInformation("");
            _logger.LogInformation("This code expires in {ExpiryMinutes} minutes.", expiryMinutes);
            _logger.LogInformation("");
            _logger.LogInformation("If you didn't request this code, contact your security team.");
            _logger.LogInformation("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        }
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
<body style=""font-family: Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; background: #1a1a1a;"">
    <div style=""text-align: center; padding: 40px 0;"">
        <h1 style=""color: #5A3EB8; margin: 0;"">SilentID Admin</h1>
        <p style=""color: #888888; margin-top: 10px;"">Admin Panel Authentication</p>
    </div>

    <div style=""background: #2a2a2a; border-radius: 12px; padding: 30px; text-align: center;"">
        <p style=""color: #ffffff; font-size: 16px; margin: 0 0 20px 0;"">Your verification code is:</p>
        <div style=""background: #1a1a1a; border: 2px solid #5A3EB8; border-radius: 8px; padding: 20px; font-size: 32px; font-weight: bold; letter-spacing: 8px; color: #5A3EB8;"">{otp}</div>
        <p style=""color: #888888; font-size: 14px; margin-top: 20px;"">This code expires in {expiryMinutes} minutes.</p>
    </div>

    <div style=""text-align: center; padding: 30px 0; color: #666666; font-size: 12px;"">
        <p style=""color: #ff4444;"">If you didn't request this code, contact your security team immediately.</p>
        <p style=""margin-top: 20px;"">© 2025 SilentID Admin. Internal Use Only.</p>
    </div>
</body>
</html>
";
    }

    // TODO: Add HTML email templates
    private string GenerateOtpEmailHtml(string otp, int expiryMinutes)
    {
        return $@"
<!DOCTYPE html>
<html>
<head>
    <meta charset=""UTF-8"">
    <title>Your SilentID Verification Code</title>
</head>
<body style=""font-family: Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;"">
    <div style=""text-align: center; padding: 40px 0;"">
        <h1 style=""color: #5A3EB8; margin: 0;"">SilentID</h1>
        <p style=""color: #4C4C4C; margin-top: 10px;"">Your Portable Trust Passport</p>
    </div>

    <div style=""background: #F9F9F9; border-radius: 12px; padding: 30px; text-align: center;"">
        <p style=""color: #111111; font-size: 16px; margin: 0 0 20px 0;"">Your verification code is:</p>
        <div style=""background: #FFFFFF; border: 2px solid #5A3EB8; border-radius: 8px; padding: 20px; font-size: 32px; font-weight: bold; letter-spacing: 8px; color: #5A3EB8;"">{otp}</div>
        <p style=""color: #4C4C4C; font-size: 14px; margin-top: 20px;"">This code expires in {expiryMinutes} minutes.</p>
    </div>

    <div style=""text-align: center; padding: 30px 0; color: #4C4C4C; font-size: 12px;"">
        <p>If you didn't request this code, please ignore this email.</p>
        <p style=""margin-top: 20px;"">© 2025 SilentID. All rights reserved.</p>
    </div>
</body>
</html>
";
    }
}
