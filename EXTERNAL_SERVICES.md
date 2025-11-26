# EXTERNAL SERVICES SETUP GUIDE

**SilentID External Service Dependencies**
**Last Updated:** 2025-11-26

This document lists all external services required for full SilentID functionality. Services are categorized by priority and current implementation status.

---

## Quick Reference

| Service | Priority | Status | Required For |
|---------|----------|--------|--------------|
| PostgreSQL | **CRITICAL** | Configured | Database |
| JWT Secret | **CRITICAL** | Configured | Auth tokens |
| Azure Blob Storage | HIGH | Placeholder | File uploads |
| Stripe Identity | HIGH | Placeholder | ID verification |
| Stripe Billing | HIGH | Placeholder | Subscriptions |
| SendGrid | MEDIUM | Placeholder | Email delivery |
| Apple OAuth | MEDIUM | Working | Apple Sign-In |
| Google OAuth | MEDIUM | Working | Google Sign-In |
| Playwright | LOW | Not implemented | Screenshot automation |
| Azure Computer Vision | LOW | Not implemented | OCR extraction |
| Platform APIs (eBay) | LOW | Not implemented | API extraction |

---

## 1. DATABASE (PostgreSQL)

**Status:** Configured
**Priority:** CRITICAL

### Configuration Location
```
appsettings.json → ConnectionStrings:DefaultConnection
```

### Setup Steps
1. Install PostgreSQL 15+
2. Create database: `silentid_db`
3. Update connection string:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Database=silentid_db;Username=postgres;Password=YOUR_PASSWORD"
  }
}
```

4. Run migrations:
```bash
cd src/SilentID.Api
dotnet ef database update
```

### Files Using This Service
- `Program.cs:33-37` - Database context registration
- `Data/SilentIdDbContext.cs` - Entity Framework context

---

## 2. JWT SECRET KEY

**Status:** Required
**Priority:** CRITICAL

### Configuration Location
```
appsettings.json → Jwt:SecretKey
```

### Setup Steps
1. Generate a secure 256-bit key:
```bash
openssl rand -base64 32
```

2. Add to configuration:
```json
{
  "Jwt": {
    "SecretKey": "YOUR_GENERATED_SECRET_KEY_HERE_MIN_32_CHARS",
    "Issuer": "silentid-api",
    "Audience": "silentid-app",
    "AccessTokenExpiryMinutes": 15,
    "RefreshTokenExpiryDays": 7
  }
}
```

### Files Using This Service
- `Program.cs:66-85` - JWT authentication setup
- `Services/TokenService.cs` - Token generation

---

## 3. AZURE BLOB STORAGE

**Status:** Placeholder (falls back to local storage)
**Priority:** HIGH
**Required For:** Evidence uploads, screenshots, receipts

### Configuration Location
```
appsettings.json → AzureStorage
```

### Current Placeholder
```json
{
  "AzureStorage": {
    "ConnectionString": "",
    "EvidenceContainer": "evidence"
  }
}
```

### Setup Steps
1. Create Azure Storage Account
2. Create container: `evidence`
3. Get connection string from Azure Portal
4. Update configuration:
```json
{
  "AzureStorage": {
    "ConnectionString": "DefaultEndpointsProtocol=https;AccountName=YOUR_ACCOUNT;AccountKey=YOUR_KEY;EndpointSuffix=core.windows.net",
    "EvidenceContainer": "evidence"
  }
}
```

### Files Using This Service
- `Services/BlobStorageService.cs` - File upload/download/delete
- `Services/ExtractionService.cs:234` - Screenshot storage
- `Controllers/EvidenceController.cs` - Evidence uploads

### Fallback Behavior
When not configured, files are stored in `wwwroot/uploads/` locally.

---

## 4. STRIPE IDENTITY (ID Verification)

**Status:** Placeholder
**Priority:** HIGH
**Required For:** Identity verification (passport, ID document)

### Configuration Location
```
appsettings.json → Stripe:SecretKey
```

### Current Placeholder
```json
{
  "Stripe": {
    "SecretKey": "STRIPE_SECRET_KEY_PLACEHOLDER"
  }
}
```

### Setup Steps
1. Create Stripe account at https://stripe.com
2. Enable Stripe Identity in dashboard
3. Get API keys from Stripe Dashboard → Developers → API keys
4. Update configuration:
```json
{
  "Stripe": {
    "SecretKey": "sk_live_YOUR_SECRET_KEY"
  }
}
```

5. Set up webhook endpoint for:
   - `identity.verification_session.verified`
   - `identity.verification_session.requires_input`

### Webhook URL
```
https://your-domain.com/v1/webhooks/stripe
```

### Files Using This Service
- `Services/StripeIdentityService.cs` - Verification session management
- `Controllers/IdentityController.cs` - Verification endpoints

### Important Notes
- Stripe Identity handles ALL sensitive ID documents
- SilentID NEVER stores raw ID images (GDPR compliance)
- Only verification status is stored locally

---

## 5. STRIPE BILLING (Subscriptions)

**Status:** Placeholder
**Priority:** HIGH
**Required For:** Premium/Pro subscription tiers

### Configuration Location
```
appsettings.json → Stripe
```

### Current Placeholder
```json
{
  "Stripe": {
    "SecretKey": "STRIPE_SECRET_KEY_PLACEHOLDER",
    "PremiumPriceId": "PREMIUM_PRICE_ID_PLACEHOLDER",
    "ProPriceId": "PRO_PRICE_ID_PLACEHOLDER"
  }
}
```

### Setup Steps
1. Create products in Stripe Dashboard:
   - **SilentID Premium** - Monthly subscription
   - **SilentID Pro** - Monthly subscription

2. Get Price IDs from each product

3. Update configuration:
```json
{
  "Stripe": {
    "SecretKey": "sk_live_YOUR_SECRET_KEY",
    "PremiumPriceId": "price_XXXXXXXXXXXXX",
    "ProPriceId": "price_YYYYYYYYYYYYY"
  }
}
```

4. Set up webhooks for:
   - `customer.subscription.created`
   - `customer.subscription.updated`
   - `customer.subscription.deleted`
   - `invoice.payment_succeeded`
   - `invoice.payment_failed`

### Files Using This Service
- `Services/SubscriptionService.cs` - Subscription management
- `Controllers/SubscriptionsController.cs` - Subscription endpoints

---

## 6. SENDGRID (Email Delivery)

**Status:** Placeholder (falls back to console logging)
**Priority:** MEDIUM
**Required For:** OTP emails, welcome emails, security alerts

### Configuration Location
```
appsettings.json → SendGrid:ApiKey
```

### Setup Steps
1. Create SendGrid account at https://sendgrid.com
2. Create API key with "Mail Send" permission
3. Verify sender domain or email (noreply@silentid.co.uk)
4. Add to configuration:
```json
{
  "SendGrid": {
    "ApiKey": "SG.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  }
}
```

### Files Using This Service
- `Services/EmailService.cs` - Email sending
  - `SendOtpEmailAsync()` - OTP verification codes
  - `SendWelcomeEmailAsync()` - Welcome emails
  - `SendAccountSecurityAlertAsync()` - Security alerts

### Fallback Behavior
When not configured, OTP codes are logged to console for development:
```
🔐 OTP CODE FOR user@example.com: 123456 (expires in 10 minutes)
```

### Email Templates (TODO)
HTML templates exist for OTP emails. Welcome and security alert templates need implementation.

---

## 7. APPLE OAUTH (Apple Sign-In)

**Status:** Working (uses Apple public keys)
**Priority:** MEDIUM
**Required For:** Apple Sign-In authentication

### Configuration Location
```
appsettings.json → OAuth:Apple
```

### Setup Steps
1. Create App ID in Apple Developer Console
2. Enable "Sign In with Apple" capability
3. Create Services ID for web authentication
4. Add configuration:
```json
{
  "OAuth": {
    "Apple": {
      "ClientId": "com.silentsale.silentid",
      "TeamId": "YOUR_TEAM_ID",
      "BundleId": "com.silentsale.silentid"
    }
  }
}
```

### Files Using This Service
- `Services/AppleAuthService.cs` - Token validation via Apple JWKS
- `Controllers/AuthController.cs:700-755` - Apple sign-in endpoint

### How It Works
- Validates identity tokens using Apple's public keys (JWKS)
- No API key required - uses public key verification
- Tokens are validated against `appleid.apple.com`

---

## 8. GOOGLE OAUTH (Google Sign-In)

**Status:** Working (uses Google tokeninfo endpoint)
**Priority:** MEDIUM
**Required For:** Google Sign-In authentication

### Configuration Location
```
appsettings.json → OAuth:Google
```

### Setup Steps
1. Create project in Google Cloud Console
2. Enable Google Sign-In API
3. Create OAuth 2.0 credentials
4. Add configuration:
```json
{
  "OAuth": {
    "Google": {
      "ClientId": "YOUR_CLIENT_ID.apps.googleusercontent.com"
    }
  }
}
```

### Files Using This Service
- `Services/GoogleAuthService.cs` - Token validation via tokeninfo API
- `Controllers/AuthController.cs:757-805` - Google sign-in endpoint

### How It Works
- Validates tokens via `https://oauth2.googleapis.com/tokeninfo`
- Client ID validation is optional but recommended
- No API secret required for token validation

---

## 9. PLAYWRIGHT (Browser Automation)

**Status:** NOT IMPLEMENTED
**Priority:** LOW
**Required For:** Automated screenshot capture for profile extraction

### Future Configuration
```json
{
  "Playwright": {
    "HeadlessBrowser": true,
    "Timeout": 30000
  }
}
```

### Implementation Location
- `Services/ExtractionService.cs:336-350` - `ExtractViaScreenshotOcrAsync()`

### What It Will Do
1. Open headless browser
2. Navigate to marketplace profile URL
3. Capture screenshot
4. Extract visible text
5. Pass to Azure Computer Vision for OCR

### NuGet Package Required
```bash
dotnet add package Microsoft.Playwright
```

---

## 10. AZURE COMPUTER VISION (OCR)

**Status:** NOT IMPLEMENTED
**Priority:** LOW
**Required For:** Text extraction from profile screenshots

### Future Configuration
```json
{
  "AzureCognitiveServices": {
    "ComputerVision": {
      "Endpoint": "https://YOUR_REGION.api.cognitive.microsoft.com/",
      "ApiKey": "YOUR_API_KEY"
    }
  }
}
```

### Implementation Location
- `Services/ExtractionService.cs:248` - OCR processing TODO

### What It Will Do
1. Receive screenshot from Playwright
2. Extract text via Azure CV Read API
3. Parse ratings, review counts, usernames
4. Calculate confidence score (95% for OCR match)

### NuGet Package Required
```bash
dotnet add package Azure.AI.Vision.ImageAnalysis
```

---

## 11. PLATFORM APIs (eBay, etc.)

**Status:** NOT IMPLEMENTED
**Priority:** LOW
**Required For:** Direct API extraction (100% confidence)

### Platforms with APIs

#### eBay Commerce API
```json
{
  "PlatformApis": {
    "eBay": {
      "ClientId": "YOUR_CLIENT_ID",
      "ClientSecret": "YOUR_CLIENT_SECRET",
      "Environment": "PRODUCTION"
    }
  }
}
```

**Endpoints:**
- User profile: `/commerce/identity/v1/user`
- Feedback: `/sell/reputation/v1/reputation`

### Implementation Location
- `Services/ExtractionService.cs:320-334` - `ExtractViaApiAsync()`

### What It Will Do
1. Authenticate with platform API
2. Fetch user profile data
3. Extract ratings, review counts
4. Return 100% confidence score

---

## PASSKEY CONFIGURATION

**Status:** Working
**Priority:** MEDIUM
**Required For:** WebAuthn/FIDO2 passkey authentication

### Configuration Location
```
appsettings.json → Passkey
```

### Setup
```json
{
  "Passkey": {
    "RpId": "silentid.co.uk",
    "RpName": "SilentID"
  }
}
```

### Files Using This Service
- `Services/PasskeyService.cs` - Passkey registration and authentication
- `Controllers/AuthController.cs` - Passkey endpoints

### Important Notes
- `RpId` must match your domain (no https://, no port)
- For localhost development, use `localhost` as RpId
- COSE signature verification implemented (ES256, RS256)

---

## ENVIRONMENT VARIABLES (Recommended for Production)

Instead of storing secrets in `appsettings.json`, use environment variables:

```bash
# Database
export ConnectionStrings__DefaultConnection="Host=..."

# JWT
export Jwt__SecretKey="your-secret-key"

# Stripe
export Stripe__SecretKey="sk_live_..."
export Stripe__PremiumPriceId="price_..."
export Stripe__ProPriceId="price_..."

# Azure
export AzureStorage__ConnectionString="DefaultEndpointsProtocol=..."

# SendGrid
export SendGrid__ApiKey="SG...."

# OAuth
export OAuth__Apple__ClientId="com.silentsale.silentid"
export OAuth__Google__ClientId="....apps.googleusercontent.com"
```

---

## SETUP CHECKLIST

### MVP Launch (Minimum Required)
- [x] PostgreSQL database
- [x] JWT secret key
- [ ] Azure Blob Storage (or use local fallback)
- [ ] Stripe Identity (or disable ID verification)
- [ ] SendGrid (or use console OTP logging)

### Full Production
- [ ] All MVP items
- [ ] Stripe Billing (subscriptions)
- [ ] Apple OAuth configured
- [ ] Google OAuth configured
- [ ] Custom domain for Passkey RpId

### Future Enhancements
- [ ] Playwright for screenshots
- [ ] Azure Computer Vision for OCR
- [ ] Platform APIs (eBay, etc.)

---

## TESTING WITHOUT EXTERNAL SERVICES

The application is designed to gracefully degrade:

| Service | Fallback Behavior |
|---------|-------------------|
| Azure Blob Storage | Local file storage in `wwwroot/uploads/` |
| SendGrid | OTP logged to console |
| Stripe Identity | Throws exception (must mock or disable) |
| Stripe Billing | Throws exception (must mock or disable) |
| Playwright | Returns "not implemented" message |
| Azure CV | Returns "not implemented" message |

For development, you can run the full API with only:
1. PostgreSQL database
2. JWT secret key

All other services will log warnings but not crash.

---

## SECURITY NOTES

1. **Never commit secrets** - Use environment variables or Azure Key Vault
2. **Rotate keys regularly** - Especially JWT secrets and API keys
3. **Use test/sandbox modes** - Stripe has test mode with `sk_test_` keys
4. **Audit webhook endpoints** - Verify Stripe webhook signatures
5. **GDPR compliance** - Stripe Identity handles ID documents, not SilentID

---

**Document Version:** 1.0
**Maintained By:** Claude Code Assistant
