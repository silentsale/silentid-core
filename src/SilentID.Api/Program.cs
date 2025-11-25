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
builder.Services.AddScoped<IMutualVerificationService, MutualVerificationService>();
builder.Services.AddScoped<IReportService, ReportService>();
builder.Services.AddScoped<ISubscriptionService, SubscriptionService>();
builder.Services.AddScoped<IBlobStorageService, BlobStorageService>();
builder.Services.AddScoped<IRiskEngineService, RiskEngineService>();
builder.Services.AddScoped<IPasskeyService, PasskeyService>();

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

            // Check if user has Admin AccountType
            var httpContext = context.Resource as Microsoft.AspNetCore.Http.HttpContext;
            if (httpContext == null)
                return false;

            // Get DbContext from request services
            var dbContext = httpContext.RequestServices.GetRequiredService<SilentID.Api.Data.SilentIdDbContext>();

            // Check user AccountType (synchronous check - consider caching in production)
            var user = dbContext.Users.FirstOrDefault(u => u.Id == userId);
            return user != null && user.AccountType == SilentID.Api.Models.AccountType.Admin;
        })
    );
});

// Add CORS for Flutter development
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
        c.RoutePrefix = string.Empty; // Serve Swagger UI at root
    });
}

app.UseHttpsRedirection();
app.UseCors("FlutterDevelopment");
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();

// Make Program class accessible to tests
public partial class Program { }
