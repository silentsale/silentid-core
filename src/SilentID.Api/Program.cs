using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using SilentID.Api.Data;
using SilentID.Api.Services;
using SilentID.Api.Middleware;

var builder = WebApplication.CreateBuilder(args);

// Configure comprehensive logging
builder.Logging.ClearProviders();
builder.Logging.AddConsole();
builder.Logging.AddDebug();
builder.Logging.SetMinimumLevel(LogLevel.Information);

// Log unhandled exceptions at app domain level
AppDomain.CurrentDomain.UnhandledException += (sender, args) =>
{
    var exception = (Exception)args.ExceptionObject;
    Console.WriteLine($"FATAL UNHANDLED EXCEPTION (AppDomain): {exception}");
    Console.WriteLine($"Stack Trace: {exception.StackTrace}");
};

// Log unobserved task exceptions
TaskScheduler.UnobservedTaskException += (sender, args) =>
{
    Console.WriteLine($"UNOBSERVED TASK EXCEPTION: {args.Exception}");
    args.SetObserved(); // Prevent process termination
};

// Add database context
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
if (!string.IsNullOrEmpty(connectionString))
{
    builder.Services.AddDbContext<SilentIdDbContext>(options =>
        options.UseNpgsql(connectionString));
}
// Note: In testing environment, TestWebApplicationFactory will configure in-memory database

// Add application services
builder.Services.AddScoped<ITokenService, TokenService>();
builder.Services.AddScoped<IOtpService, OtpService>();
builder.Services.AddScoped<IEmailService, EmailService>();
builder.Services.AddScoped<IDuplicateDetectionService, DuplicateDetectionService>();
builder.Services.AddScoped<IStripeIdentityService, StripeIdentityService>();
builder.Services.AddScoped<IEvidenceService, EvidenceService>();
builder.Services.AddScoped<ITrustScoreService, TrustScoreService>();
builder.Services.AddScoped<IReportService, ReportService>();
builder.Services.AddScoped<ISubscriptionService, SubscriptionService>();
builder.Services.AddScoped<IBlobStorageService, BlobStorageService>();
builder.Services.AddScoped<IRiskEngineService, RiskEngineService>();
builder.Services.AddScoped<IPasskeyService, PasskeyService>();
builder.Services.AddScoped<IPlatformConfigurationService, PlatformConfigurationService>();
builder.Services.AddScoped<IExtractionService, ExtractionService>();
builder.Services.AddScoped<IOcrService, MockOcrService>(); // TODO: Replace with AzureComputerVisionOcrService in production
builder.Services.AddScoped<IReferralService, ReferralService>();
builder.Services.AddScoped<IForwardingAliasService, ForwardingAliasService>();
// v2.0: ReceiptParsingService removed - receipts no longer part of product
builder.Services.AddScoped<ISecurityCenterService, SecurityCenterService>();
builder.Services.AddScoped<IStepUpAuthService, StepUpAuthService>();
builder.Services.AddScoped<INotificationService, NotificationService>();
builder.Services.AddScoped<IPaywallService, PaywallService>();
builder.Services.AddScoped<ISoftLimitsService, SoftLimitsService>();
builder.Services.AddScoped<IQrBadgeService, QrBadgeService>();
builder.Services.AddScoped<IAccountRecoveryService, AccountRecoveryService>();
builder.Services.AddScoped<IAnomalyDetectionService, AnomalyDetectionService>();
builder.Services.AddScoped<IProFeaturesService, ProFeaturesService>();

// Add Profile Concern and Support Ticket services
builder.Services.AddScoped<ProfileConcernService>();
builder.Services.AddScoped<SupportTicketService>();

// Add HttpClient factory for OAuth services
builder.Services.AddHttpClient();

// Add OAuth authentication services (Apple & Google Sign-In)
builder.Services.AddScoped<IAppleAuthService, AppleAuthService>();
builder.Services.AddScoped<IGoogleAuthService, GoogleAuthService>();

// Add Admin Panel authentication service
builder.Services.AddScoped<IAdminAuthService, AdminAuthService>();

// Add Background Services
builder.Services.AddHostedService<TrustScoreRegenerationService>();
builder.Services.AddHostedService<OtpCleanupService>();

// Add JWT authentication
var jwtSecretKey = builder.Configuration["Jwt:SecretKey"] ?? throw new InvalidOperationException("JWT SecretKey not configured");
var jwtIssuer = builder.Configuration["Jwt:Issuer"] ?? throw new InvalidOperationException("JWT Issuer not configured");
var jwtAudience = builder.Configuration["Jwt:Audience"] ?? throw new InvalidOperationException("JWT Audience not configured");

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = jwtIssuer,
        ValidAudience = jwtAudience,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSecretKey)),
        ClockSkew = TimeSpan.Zero // No tolerance for expired tokens
    };

    options.Events = new JwtBearerEvents
    {
        OnAuthenticationFailed = context =>
        {
            if (context.Exception.GetType() == typeof(SecurityTokenExpiredException))
            {
                context.Response.Headers.Append("Token-Expired", "true");
            }
            return Task.CompletedTask;
        }
    };
});

// Custom authorization policies (Section 28: Admin Roles & Permissions)
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("AdminOnly", policy =>
        policy.RequireAssertion(context =>
        {
            // Extract user ID from token
            var userIdClaim = context.User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userIdClaim) || !Guid.TryParse(userIdClaim, out var userId))
                return false;

            // Check for is_admin claim (set by AdminAuthService)
            var isAdminClaim = context.User.FindFirst("is_admin")?.Value;
            if (isAdminClaim == "true")
            {
                // Verify admin exists in AdminUsers table
                var httpContext = context.Resource as Microsoft.AspNetCore.Http.HttpContext;
                if (httpContext == null)
                    return false;

                var dbContext = httpContext.RequestServices.GetRequiredService<SilentID.Api.Data.SilentIdDbContext>();
                var adminUser = dbContext.AdminUsers.FirstOrDefault(a => a.Id == userId && a.IsActive);
                return adminUser != null;
            }

            // Fallback: Check if regular user has Admin AccountType
            var httpCtx = context.Resource as Microsoft.AspNetCore.Http.HttpContext;
            if (httpCtx == null)
                return false;

            var dbCtx = httpCtx.RequestServices.GetRequiredService<SilentID.Api.Data.SilentIdDbContext>();
            var user = dbCtx.Users.FirstOrDefault(u => u.Id == userId);
            return user != null && user.AccountType == SilentID.Api.Models.AccountType.Admin;
        })
    );
});

// Add CORS for Flutter development and Admin Panel
builder.Services.AddCors(options =>
{
    options.AddPolicy("FlutterDevelopment", policy =>
    {
        policy.WithOrigins(
            "http://localhost:*",
            "http://127.0.0.1:*"
        )
        .SetIsOriginAllowedToAllowWildcardSubdomains()
        .AllowAnyHeader()
        .AllowAnyMethod()
        .AllowCredentials();
    });

    // Admin Panel CORS policy (Next.js development server)
    options.AddPolicy("AdminPanel", policy =>
    {
        policy.WithOrigins(
            "http://localhost:3000",    // Next.js default
            "http://localhost:3001",    // Admin panel port
            "http://127.0.0.1:3000",
            "http://127.0.0.1:3001"
        )
        .AllowAnyHeader()
        .AllowAnyMethod()
        .AllowCredentials()
        .WithExposedHeaders("Token-Expired"); // Expose custom headers
    });
});

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new()
    {
        Title = "SilentID API",
        Version = "v1",
        Description = "SilentID - Universal Trust Passport API"
    });
});

var app = builder.Build();

// CRITICAL: Add global exception handler FIRST in pipeline
app.UseMiddleware<GlobalExceptionHandlerMiddleware>();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "SilentID API v1");
        c.RoutePrefix = "api-docs"; // Moved off root for security
    });
}

app.UseHttpsRedirection();

// Security Headers Middleware
app.Use(async (context, next) =>
{
    // Prevent MIME-type sniffing
    context.Response.Headers.Append("X-Content-Type-Options", "nosniff");

    // Prevent clickjacking
    context.Response.Headers.Append("X-Frame-Options", "DENY");

    // Enable XSS filter in browsers
    context.Response.Headers.Append("X-XSS-Protection", "1; mode=block");

    // Control referrer information
    context.Response.Headers.Append("Referrer-Policy", "strict-origin-when-cross-origin");

    // Restrict browser features
    context.Response.Headers.Append("Permissions-Policy", "geolocation=(), microphone=(), camera=()");

    // Production-only headers
    if (!app.Environment.IsDevelopment())
    {
        // Force HTTPS with HSTS
        context.Response.Headers.Append("Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload");

        // Content Security Policy
        context.Response.Headers.Append("Content-Security-Policy",
            "default-src 'self'; " +
            "script-src 'self'; " +
            "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; " +
            "font-src 'self' https://fonts.gstatic.com; " +
            "img-src 'self' data: https:; " +
            "connect-src 'self' https://api.stripe.com https://js.stripe.com; " +
            "frame-ancestors 'none';");
    }

    await next();
});

// Apply CORS with environment-specific configuration
if (app.Environment.IsDevelopment())
{
    // Development: Allow specific localhost ports
    app.UseCors(builder =>
    {
        builder.WithOrigins(
                "http://localhost:3000",   // Admin Panel (Next.js)
                "http://localhost:3001",   // Admin Panel (alternate)
                "http://localhost:5173",   // Landing Page (Vite)
                "http://localhost:5174",   // Landing Page (alternate)
                "http://localhost:8080",   // Flutter Web
                "http://127.0.0.1:3000",
                "http://127.0.0.1:5173",
                "http://127.0.0.1:8080"
            )
            .WithHeaders(
                "Authorization",
                "Content-Type",
                "X-Requested-With",
                "X-CSRF-Token",
                "Accept",
                "Origin"
            )
            .WithMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
            .AllowCredentials()
            .WithExposedHeaders("Token-Expired");
    });
}
else
{
    // Production: Only allow explicit SilentID domains
    app.UseCors(builder =>
    {
        builder.WithOrigins(
                "https://silentid.co.uk",
                "https://www.silentid.co.uk",
                "https://app.silentid.co.uk",
                "https://admin.silentid.co.uk",
                "https://api.silentid.co.uk"
            )
            .WithHeaders(
                "Authorization",
                "Content-Type",
                "X-Requested-With",
                "X-CSRF-Token",
                "Accept",
                "Origin"
            )
            .WithMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
            .AllowCredentials()
            .WithExposedHeaders("Token-Expired");
    });
}

app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();

// Make Program class accessible to tests
public partial class Program { }
