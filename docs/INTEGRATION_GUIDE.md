# SilentID Integration Guide

**Purpose:** How to run the full stack locally and coordinate backend + frontend development

**Updated:** 2025-11-21 (Sprint 2)

---

## QUICK START (30 Seconds)

### 1. Start Backend API
```bash
cd C:\SILENTID\src\SilentID.Api
dotnet run
```
**Backend runs on:** `http://localhost:5249`

### 2. Start Flutter App
```bash
cd C:\SILENTID\silentid_app
flutter run
```

### 3. Test Authentication Flow
- Tap "Continue with Email"
- Enter email address
- Check backend console for OTP code
- Enter OTP in app
- Successfully login to Home screen

---

## ENVIRONMENT SETUP

### Prerequisites

**Backend:**
- .NET SDK 8.0+
- PostgreSQL 15+ (local or Docker)
- VS Code or Visual Studio

**Frontend:**
- Flutter SDK 3.16+
- Dart SDK 3.2+
- Android Studio (for Android emulator)
- Xcode (for iOS simulator, macOS only)

**Optional:**
- Redis (for distributed caching)
- Azure Storage Emulator (for blob storage testing)

---

## BACKEND SETUP

### 1. Database Configuration

**Option A: Local PostgreSQL**
```bash
# Install PostgreSQL 15+
# Create database:
createdb silentid_dev

# Connection string in user secrets:
cd C:\SILENTID\src\SilentID.Api
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Host=localhost;Database=silentid_dev;Username=postgres;Password=yourpassword"
```

**Option B: Docker PostgreSQL**
```bash
docker run --name silentid-postgres \
  -e POSTGRES_DB=silentid_dev \
  -e POSTGRES_PASSWORD=devpassword \
  -p 5432:5432 \
  -d postgres:15

# Connection string:
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Host=localhost;Port=5432;Database=silentid_dev;Username=postgres;Password=devpassword"
```

### 2. Apply Migrations

```bash
cd C:\SILENTID\src\SilentID.Api
dotnet ef database update
```

**Auto-Migration in Dev:**
- Migrations automatically apply on startup in Development environment
- Check `Program.cs` for auto-migration logic

### 3. Configure Secrets

**JWT Secret:**
```bash
dotnet user-secrets set "JwtSettings:SecretKey" "your-256-bit-secret-key-here-must-be-long"
```

**SendGrid (Email):**
```bash
dotnet user-secrets set "SendGridSettings:ApiKey" "SG.your-sendgrid-api-key"
dotnet user-secrets set "SendGridSettings:FromEmail" "noreply@silentid.co.uk"
```

**Stripe Identity:**
```bash
dotnet user-secrets set "StripeSettings:SecretKey" "sk_test_your-stripe-test-key"
dotnet user-secrets set "StripeSettings:PublishableKey" "pk_test_your-stripe-test-key"
```

**Azure Blob Storage:**
```bash
dotnet user-secrets set "AzureStorage:ConnectionString" "DefaultEndpointsProtocol=https;AccountName=...;AccountKey=..."
dotnet user-secrets set "AzureStorage:ContainerName" "evidence"
```

**Azure Cognitive Services (OCR):**
```bash
dotnet user-secrets set "AzureCognitive:ApiKey" "your-azure-ocr-key"
dotnet user-secrets set "AzureCognitive:Endpoint" "https://yourregion.api.cognitive.microsoft.com/"
```

### 4. Run Backend

```bash
cd C:\SILENTID\src\SilentID.Api
dotnet run
```

**Expected Output:**
```
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://localhost:5249
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
```

**Verify Health:**
```bash
curl http://localhost:5249/v1/health
```

**Expected Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-11-21T10:00:00Z"
}
```

---

## FRONTEND SETUP

### 1. Install Dependencies

```bash
cd C:\SILENTID\silentid_app
flutter pub get
```

### 2. Configure API Base URL

**File:** `lib/config/app_config.dart`

```dart
class AppConfig {
  static const String apiBaseUrl = 'http://localhost:5249/v1';
  static const String environment = 'development';
}
```

**For Android Emulator:**
```dart
static const String apiBaseUrl = 'http://10.0.2.2:5249/v1';
```

**For iOS Simulator:**
```dart
static const String apiBaseUrl = 'http://localhost:5249/v1';
```

### 3. Run Flutter App

**On Android Emulator:**
```bash
flutter run
```

**On iOS Simulator:**
```bash
flutter run
```

**On Physical Device:**
```bash
# Android:
flutter run --release

# iOS:
flutter run --release
```

---

## INTEGRATION TESTING

### Test Full Authentication Flow

**1. Start Backend:**
```bash
cd C:\SILENTID\src\SilentID.Api
dotnet run
```

**2. Start Flutter App:**
```bash
cd C:\SILENTID\silentid_app
flutter run
```

**3. In the App:**
- Tap "Continue with Email"
- Enter: `test@example.com`
- Check backend console for OTP (if SendGrid not configured)
- Enter OTP in app
- Should reach Home screen

**4. Verify in Database:**
```sql
-- Connect to PostgreSQL
psql -d silentid_dev

-- Check user created
SELECT Id, Email, Username, IsEmailVerified, AccountType FROM Users;

-- Check session created
SELECT Id, UserId, ExpiresAt FROM Sessions;

-- Check device tracked
SELECT Id, UserId, DeviceModel, OS FROM AuthDevices;
```

---

## DEBUGGING

### Backend Debugging (VS Code)

**launch.json:**
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": ".NET Core Launch (web)",
      "type": "coreclr",
      "request": "launch",
      "preLaunchTask": "build",
      "program": "${workspaceFolder}/src/SilentID.Api/bin/Debug/net8.0/SilentID.Api.dll",
      "args": [],
      "cwd": "${workspaceFolder}/src/SilentID.Api",
      "stopAtEntry": false,
      "env": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    }
  ]
}
```

**Breakpoints:**
- Set breakpoints in `AuthController.cs`
- Step through OTP verification logic
- Inspect JWT token generation

### Frontend Debugging (VS Code)

**launch.json:**
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter",
      "type": "dart",
      "request": "launch",
      "program": "lib/main.dart"
    }
  ]
}
```

**DevTools:**
```bash
# Enable Dart DevTools
flutter pub global activate devtools

# Run DevTools
flutter pub global run devtools
```

### Network Debugging

**Flutter HTTP Logging:**

Add to `lib/services/api_service.dart`:
```dart
final dio = Dio(BaseOptions(
  baseUrl: AppConfig.apiBaseUrl,
))..interceptors.add(LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    error: true,
  ));
```

**Backend Request Logging:**

Check `Program.cs` for Serilog configuration.

---

## COMMON ISSUES

### Issue 1: "Connection Refused" from Flutter

**Cause:** Backend not running or wrong URL

**Fix:**
```bash
# Verify backend running:
curl http://localhost:5249/v1/health

# For Android emulator, use:
http://10.0.2.2:5249/v1

# For iOS simulator, use:
http://localhost:5249/v1
```

---

### Issue 2: "Database does not exist"

**Cause:** Migrations not applied

**Fix:**
```bash
cd C:\SILENTID\src\SilentID.Api
dotnet ef database update
```

---

### Issue 3: "OTP not received in app"

**Cause:** SendGrid not configured (dev mode)

**Fix:**
- Check backend console for OTP code:
  ```
  📧 EMAIL: Sending OTP to test@example.com
  OTP: 123456
  ```
- Enter code manually in app

**Production Fix:**
- Configure SendGrid API key
- OTPs will be emailed

---

### Issue 4: "JWT signature invalid"

**Cause:** Secret key mismatch

**Fix:**
```bash
# Verify secret configured:
dotnet user-secrets list

# Set if missing:
dotnet user-secrets set "JwtSettings:SecretKey" "your-256-bit-secret-key-here-must-be-long"
```

---

### Issue 5: "CORS policy blocked"

**Cause:** Flutter not allowed in CORS policy

**Fix:**

In `Program.cs`:
```csharp
builder.Services.AddCors(options =>
{
    options.AddPolicy("FlutterPolicy", policy =>
    {
        policy.WithOrigins("http://localhost", "http://10.0.2.2")
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});
```

---

## TESTING WORKFLOWS

### Unit Tests (Backend)

```bash
cd C:\SILENTID\SilentID.Api.Tests
dotnet test
```

**Expected Output:**
```
Passed!  - Failed:     0, Passed:    53, Skipped:     0, Total:    53
```

### Integration Tests (Backend)

```bash
cd C:\SILENTID\SilentID.Api.Tests
dotnet test --filter Category=Integration
```

### Widget Tests (Flutter)

```bash
cd C:\SILENTID\silentid_app
flutter test
```

---

## PRODUCTION DEPLOYMENT (Future)

### Backend Deployment (Azure App Service)

**1. Create App Service:**
```bash
az webapp create --name silentid-api --resource-group silentid-rg --plan silentid-plan
```

**2. Configure Connection String:**
```bash
az webapp config connection-string set --name silentid-api \
  --resource-group silentid-rg \
  --connection-string-type PostgreSQL \
  --settings DefaultConnection="Host=silentid.postgres.database.azure.com;Database=silentid_prod;Username=admin;Password=..."
```

**3. Deploy:**
```bash
cd C:\SILENTID\src\SilentID.Api
dotnet publish -c Release
az webapp deployment source config-zip --name silentid-api --resource-group silentid-rg --src publish.zip
```

### Flutter Deployment (App Stores)

**Android (Google Play):**
```bash
flutter build appbundle --release
# Upload to Google Play Console
```

**iOS (App Store):**
```bash
flutter build ipa --release
# Upload to App Store Connect
```

---

## COORDINATION BETWEEN AGENTS

### Agent B (Backend) → Agent C (Frontend)

**When Backend Implements New Endpoint:**

1. **Agent B updates API_CONTRACTS.md** with endpoint spec
2. **Agent B creates example request/response** in Postman/cURL
3. **Agent B notifies Agent C** endpoint is ready
4. **Agent C tests endpoint** with manual HTTP call first
5. **Agent C implements UI** to call endpoint

**Example:**

Agent B implements:
```
POST /v1/identity/stripe/session
```

Agent B provides cURL test:
```bash
curl -X POST http://localhost:5249/v1/identity/stripe/session \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"returnUrl": "silentid://identity-complete"}'
```

Agent C implements:
```dart
Future<StripeSessionResponse> createStripeSession() async {
  final response = await _apiService.post(
    '/identity/stripe/session',
    data: {'returnUrl': 'silentid://identity-complete'},
  );
  return StripeSessionResponse.fromJson(response.data);
}
```

---

### Agent C (Frontend) → Agent B (Backend)

**When Frontend Needs New Endpoint:**

1. **Agent C identifies requirement** (e.g., "need to fetch TrustScore")
2. **Agent C creates API contract proposal** in API_CONTRACTS.md
3. **Agent A (Architect) reviews** and approves
4. **Agent B implements** backend endpoint
5. **Agent C implements** frontend integration

---

### Agent D (QA) Testing

**Integration Test Workflow:**

1. **Agent B completes endpoint** (e.g., Stripe session)
2. **Agent D writes integration test:**
   ```csharp
   [Fact]
   public async Task CreateStripeSession_ReturnsSessionUrl()
   {
       // Arrange
       var client = _factory.CreateClient();
       var token = await GetAuthToken(client);
       client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

       // Act
       var response = await client.PostAsync("/v1/identity/stripe/session", new StringContent("{}"));

       // Assert
       response.StatusCode.Should().Be(HttpStatusCode.OK);
       var json = await response.Content.ReadAsStringAsync();
       json.Should().Contain("sessionId");
   }
   ```
3. **Agent D runs test** and verifies pass
4. **Agent C integrates** frontend with confidence

---

## MULTI-AGENT PARALLEL DEVELOPMENT

### Scenario: Implementing TrustScore Feature

**Week 1 - Parallel Tasks:**

**Agent B (Backend):**
- Day 1-2: Create TrustScoreSnapshots table
- Day 3-4: Implement TrustScoreService
- Day 5: Implement GET /v1/trustscore/me endpoint

**Agent C (Frontend - Can Start Immediately):**
- Day 1-2: Build TrustScore Overview screen (with mock data)
- Day 3: Build TrustScore Breakdown screen (with mock data)
- Day 4-5: Connect to real backend (when Agent B ready)

**Agent D (QA - Can Start Immediately):**
- Day 1-2: Write TrustScore calculation unit tests
- Day 3: Write integration tests for endpoint
- Day 4-5: E2E test with frontend

**Result:** Feature complete in 1 week instead of 3 weeks sequential

---

## DEVELOPER EXPERIENCE CHECKLIST

**Backend Developer Onboarding:**
- [ ] .NET SDK installed
- [ ] PostgreSQL running
- [ ] User secrets configured
- [ ] Migrations applied
- [ ] API running on localhost:5249
- [ ] Health endpoint responds
- [ ] Tests pass

**Frontend Developer Onboarding:**
- [ ] Flutter SDK installed
- [ ] Dependencies installed (flutter pub get)
- [ ] API base URL configured
- [ ] Emulator/simulator running
- [ ] App launches successfully
- [ ] Auth flow works E2E

**QA Engineer Onboarding:**
- [ ] Test project running
- [ ] All 53 tests passing
- [ ] Integration test DB configured
- [ ] Postman/cURL ready for manual testing
- [ ] Access to backend logs

---

**Document Owner:** Agent A (Architect)
**Last Updated:** 2025-11-21
**Status:** CURRENT
