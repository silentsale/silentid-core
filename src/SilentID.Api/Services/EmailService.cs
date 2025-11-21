namespace SilentID.Api.Services;

public interface IEmailService
{
    Task SendOtpEmailAsync(string toEmail, string otp, int expiryMinutes);
    Task SendWelcomeEmailAsync(string toEmail, string displayName);
    Task SendAccountSecurityAlertAsync(string toEmail, string alertMessage);
}

/// <summary>
/// Development email service that logs to console.
/// In production, implement with SendGrid, AWS SES, or similar service.
/// </summary>
public class EmailService : IEmailService
{
    private readonly ILogger<EmailService> _logger;
    private readonly IConfiguration _configuration;

    public EmailService(ILogger<EmailService> logger, IConfiguration configuration)
    {
        _logger = logger;
        _configuration = configuration;
    }

    public Task SendOtpEmailAsync(string toEmail, string otp, int expiryMinutes)
    {
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

        // TODO: In production, integrate with SendGrid or AWS SES
        // Example:
        // await _sendGridClient.SendEmailAsync(
        //     from: "noreply@silentid.app",
        //     to: toEmail,
        //     subject: "Your SilentID Verification Code",
        //     htmlContent: GenerateOtpEmailHtml(otp, expiryMinutes)
        // );

        return Task.CompletedTask;
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
