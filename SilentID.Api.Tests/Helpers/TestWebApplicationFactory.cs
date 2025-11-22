using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using SilentID.Api.Data;
using SilentID.Api.Services;

namespace SilentID.Api.Tests.Helpers;

/// <summary>
/// Custom WebApplicationFactory for integration testing
/// Configures in-memory database and mocked external services
/// </summary>
public class TestWebApplicationFactory : WebApplicationFactory<Program>
{
    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.ConfigureServices(services =>
        {
            // Remove the PostgreSQL database context descriptor
            var descriptor = services.SingleOrDefault(
                d => d.ServiceType == typeof(DbContextOptions<SilentIdDbContext>));

            if (descriptor != null)
            {
                services.Remove(descriptor);
            }

            // Add in-memory database for testing
            services.AddDbContext<SilentIdDbContext>(options =>
            {
                options.UseInMemoryDatabase("TestDb_" + Guid.NewGuid());
            });

            // Replace Email Service with mock (don't actually send emails in tests)
            // Use SINGLETON so all scopes share the same instance and SentEmails list
            services.RemoveAll<IEmailService>();
            services.AddSingleton<IEmailService, MockEmailService>();

            // Build service provider and create database
            var sp = services.BuildServiceProvider();
            using var scope = sp.CreateScope();
            var scopedServices = scope.ServiceProvider;
            var db = scopedServices.GetRequiredService<SilentIdDbContext>();

            db.Database.EnsureCreated();
        });

        builder.ConfigureAppConfiguration((context, config) =>
        {
            // Add test configuration for JWT
            config.AddInMemoryCollection(new Dictionary<string, string?>
            {
                ["Jwt:SecretKey"] = "ThisIsAVerySecureSecretKeyForTestingPurposesOnly12345",
                ["Jwt:Issuer"] = "SilentID.Test",
                ["Jwt:Audience"] = "SilentID.Api.Test"
            });
        });

        builder.UseEnvironment("Testing");
    }
}

/// <summary>
/// Mock email service that doesn't actually send emails during testing
/// </summary>
public class MockEmailService : IEmailService
{
    public List<SentEmail> SentEmails { get; } = new();

    public Task SendOtpEmailAsync(string email, string otp, int expiryMinutes)
    {
        SentEmails.Add(new SentEmail
        {
            To = email,
            Type = "OTP",
            Content = otp
        });
        return Task.CompletedTask;
    }

    public Task SendWelcomeEmailAsync(string email, string displayName)
    {
        SentEmails.Add(new SentEmail
        {
            To = email,
            Type = "Welcome",
            Content = displayName
        });
        return Task.CompletedTask;
    }

    public Task SendAccountSecurityAlertAsync(string toEmail, string alertMessage)
    {
        SentEmails.Add(new SentEmail
        {
            To = toEmail,
            Type = "SecurityAlert",
            Content = alertMessage
        });
        return Task.CompletedTask;
    }

    public void ClearSentEmails()
    {
        SentEmails.Clear();
    }
}

public class SentEmail
{
    public string To { get; set; } = string.Empty;
    public string Type { get; set; } = string.Empty;
    public string Content { get; set; } = string.Empty;
}
