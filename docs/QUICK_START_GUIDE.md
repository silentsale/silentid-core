# SilentID API - Quick Start Guide

**Last Updated:** 2025-11-21
**Status:** Production-Ready for Phase 2

---

## For Developers: Start API Locally

### Prerequisites
- .NET 8.0 SDK installed
- PostgreSQL running on localhost:5432
- Database `silentid_dev` created

### Quick Start (3 commands)

```bash
# 1. Navigate to API directory
cd src/SilentID.Api

# 2. Apply migrations (first time only)
dotnet ef database update

# 3. Run API
dotnet run
```

**API will be available at:** http://localhost:5249

**Swagger UI:** http://localhost:5249/ (root path)

---

## User Secrets (Required for Local Development)

If you're setting up for the first time:

```bash
cd src/SilentID.Api

# Initialize user secrets
dotnet user-secrets init

# Add JWT secret
dotnet user-secrets set "Jwt:SecretKey" "SilentID-Dev-Key-2025-CHANGE-IN-PRODUCTION-Min32Chars-Required"

# Add database connection string
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Host=localhost;Port=5432;Database=silentid_dev;Username=postgres;Password=password"

# Optional: Add SendGrid API key (only if you want real emails)
dotnet user-secrets set "SendGrid:ApiKey" "SG.your-key-here"
```

**Verify secrets are set:**
```bash
dotnet user-secrets list
```

---

## Test Endpoints

### Health Check
```bash
curl http://localhost:5249/v1/health
```

**Expected Response:**
```json
{
  "status": "healthy",
  "application": "SilentID API",
  "version": "v1",
  "environment": "Development",
  "timestamp": "2025-11-21T21:25:06Z"
}
```

### Request OTP (Email Authentication)
```bash
curl -X POST http://localhost:5249/v1/auth/request-otp \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com"}'
```

**Expected Response:**
```json
{
  "message": "OTP sent successfully"
}
```

**OTP Code:** Check console output (not sent via email unless SendGrid configured)

### Verify OTP
```bash
curl -X POST http://localhost:5249/v1/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "otp": "123456"}'
```

---

## Common Tasks

### Create New Migration
```bash
cd src/SilentID.Api
dotnet ef migrations add YourMigrationName
dotnet ef database update
```

### Rollback Migration
```bash
dotnet ef database update PreviousMigrationName
```

### Remove Last Migration (if not applied)
```bash
dotnet ef migrations remove
```

### List All Migrations
```bash
dotnet ef migrations list
```

### Build API
```bash
dotnet build
```

### Clean Build
```bash
dotnet clean
dotnet build
```

---

## Troubleshooting

### Issue: API Won't Start

**Check:**
1. PostgreSQL is running: `pg_isready -U postgres`
2. Database exists: `psql -U postgres -l | grep silentid_dev`
3. User secrets configured: `dotnet user-secrets list`

**Solution:**
```bash
# Create database if missing
psql -U postgres -c "CREATE DATABASE silentid_dev;"

# Apply migrations
dotnet ef database update
```

### Issue: "JWT SecretKey not configured"

**Solution:**
```bash
dotnet user-secrets set "Jwt:SecretKey" "SilentID-Dev-Key-2025-CHANGE-IN-PRODUCTION-Min32Chars-Required"
```

### Issue: "Failed to determine the https port for redirect"

**This is normal in development.** The API runs on HTTP by default.

To suppress the warning, comment out this line in `Program.cs`:
```csharp
// app.UseHttpsRedirection();
```

### Issue: CORS Errors from Flutter App

**Check:**
1. CORS middleware is enabled in `Program.cs`
2. Flutter app is running on localhost
3. CORS middleware is BEFORE authentication middleware

**Verify CORS:**
```bash
curl -X OPTIONS http://localhost:5249/v1/health \
  -H "Origin: http://localhost:8080" \
  -H "Access-Control-Request-Method: GET" \
  -v
```

Should see: `Access-Control-Allow-Origin: http://localhost:8080`

---

## Project Structure

```
src/SilentID.Api/
├── Controllers/
│   ├── AuthController.cs          # OTP authentication endpoints
│   └── HealthController.cs         # Health check endpoint
├── Data/
│   └── SilentIdDbContext.cs       # EF Core database context
├── Migrations/                     # EF Core migrations
├── Models/
│   ├── User.cs                    # User entity (includes Admin account type)
│   ├── Session.cs                 # Session entity
│   └── AuthDevice.cs              # Device fingerprinting
├── Services/
│   ├── TokenService.cs            # JWT token generation
│   ├── OtpService.cs              # OTP generation & validation
│   ├── EmailService.cs            # SendGrid email integration
│   └── DuplicateDetectionService.cs
├── Program.cs                     # Application startup & middleware
└── appsettings.json               # Configuration (NO SECRETS HERE)
```

---

## Security Notes

### ✅ DO:
- Store secrets in user secrets for development
- Use environment variables for production
- Keep appsettings.json clean (no secrets)
- Use HTTPS in production

### ❌ DON'T:
- Commit secrets to git
- Hard-code API keys
- Disable CORS in production
- Reuse development JWT secret in production

---

## API Endpoints Reference

**Base URL:** http://localhost:5249/v1

| Method | Endpoint | Auth Required | Description |
|--------|----------|---------------|-------------|
| GET | /health | No | Health check |
| POST | /auth/request-otp | No | Request email OTP |
| POST | /auth/verify-otp | No | Verify OTP and get tokens |
| POST | /auth/refresh | No | Refresh access token |
| POST | /auth/logout | Yes | Invalidate session |

**More endpoints coming in Phase 2+**

---

## Environment Variables (Production)

For Azure App Service or production deployment:

```bash
# JWT Configuration
Jwt__SecretKey="PRODUCTION-SECRET-MIN-64-CHARS"
Jwt__Issuer="silentid-api"
Jwt__Audience="silentid-app"
Jwt__AccessTokenExpiryMinutes="15"
Jwt__RefreshTokenExpiryDays="7"

# Database Connection
ConnectionStrings__DefaultConnection="Host=silentid-db.postgres.database.azure.com;Port=5432;Database=silentid_prod;Username=admin;Password=SECURE_PASSWORD;SSL Mode=Require"

# SendGrid (Optional)
SendGrid__ApiKey="SG.production-api-key"

# SilentID Configuration
SilentId__Environment="Production"
SilentId__ApiVersion="v1"
SilentId__ApplicationName="SilentID API"
```

---

## Links

- **Full Documentation:** `/docs/SPRINT1_BACKEND_CHANGES.md`
- **Master Specification:** `/CLAUDE.md`
- **Completion Summary:** `/docs/SPRINT1_COMPLETION_SUMMARY.md`

---

**Last Updated:** 2025-11-21
**Version:** 1.0.0
**Status:** Production-Ready ✅
