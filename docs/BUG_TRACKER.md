# SilentID Bug Tracker

**Status:** Active
**Last Updated:** 2025-11-22
**Managed By:** Agent D (QA)

---

## Active Bugs

### BUG #003 - Backend Crashes After Extended Testing Session

**Severity:** 🔴 CRITICAL - P0
**Component:** Backend - ASP.NET Core Runtime
**Assigned To:** Agent B (Backend Engineer)
**Found By:** Agent D (QA)
**Date Found:** 2025-11-22 12:00 PM
**Status:** 🔴 OPEN - Blocking QA Testing

**Description:**
Backend API (localhost:5249) becomes unresponsive and crashes after 5-6 authenticated API requests during testing session. No error logs captured.

**Impact:**
- Blocks continuous integration testing
- Prevents full test suite execution
- Cannot verify multi-step user flows
- Cannot test concurrent requests

**Reproduction Steps:**
1. Start backend: `cd src/SilentID.Api && dotnet run`
2. Request OTP: `curl -X POST http://localhost:5249/v1/auth/request-otp -H "Content-Type: application/json" -d '{"email":"test@silentid.co.uk"}'`
3. Verify OTP: `curl -X POST http://localhost:5249/v1/auth/verify-otp ...` (with valid OTP)
4. Make 4-5 TrustScore requests with Bearer token:
   - `GET /v1/trustscore/me`
   - `GET /v1/trustscore/me/breakdown`
   - `GET /v1/trustscore/me/history`
   - `POST /v1/trustscore/me/recalculate`
5. Attempt 6th request → Backend unresponsive, port 5249 closed

**Expected Behavior:**
Backend should handle continuous requests without crashing. Should remain responsive for entire testing session.

**Actual Behavior:**
- Backend exits cleanly (no crash dumps)
- Port 5249 closes
- No error messages in console output
- Requires manual restart to continue testing

**Evidence:**
- Crash #1: After OTP verification + 1 TrustScore request
- Crash #2: After 4 TrustScore endpoint tests
- Backend log shows no exceptions before exit
- Process terminates with exit code 0

**Suspected Causes:**
- Memory leak in TrustScore service
- Unhandled exception in async pipeline
- Database connection pool exhaustion
- JWT token validation issue
- Middleware error swallowing exceptions

**Investigation Needed:**
1. Add comprehensive exception logging to Program.cs
2. Check for memory leaks in TrustScoreService
3. Verify database connection handling
4. Test with debugger attached to catch unhandled exceptions
5. Review middleware pipeline for error handling gaps

**Recommended Fix:**
1. Add global exception handler middleware
2. Implement proper using/dispose patterns for DbContext
3. Add logging before/after each middleware component
4. Verify async/await patterns in controllers
5. Test with longer-running sessions to identify leak

**Workaround:**
Manually restart backend between test sessions (not viable for CI/CD)

**Priority Justification:**
CRITICAL - Blocks all QA testing beyond basic smoke tests. Must be resolved before testing Mutual Verification and Safety Reports.

---

### BUG #002 - Email Validation Missing in AuthController

**Severity:** 🟡 HIGH - P1
**Component:** Backend - API Validation
**Assigned To:** Agent B (Backend Engineer)
**Found By:** Agent D (QA)
**Date Found:** 2025-11-22 06:43:25
**Status:** 🔴 OPEN - Test Failing

**Description:**
The `/v1/auth/request-otp` endpoint accepts invalid email addresses and returns 200 OK instead of rejecting them with 400 BadRequest.

**Test Failing:**
- `AuthControllerTests.RequestOtp_InvalidEmail_ShouldReturn400`

**Expected Behavior:**
```csharp
// POST /v1/auth/request-otp with invalid email
{ "email": "notanemail" }

// Should return:
HTTP 400 BadRequest
{ "error": "Invalid email address format" }
```

**Actual Behavior:**
```csharp
// POST /v1/auth/request-otp with invalid email
{ "email": "reagan_dach@hotmail.com" } // Bogus test data

// Returns:
HTTP 200 OK
{ "message": "Verification code sent...", "expiresInMinutes": 10 }
// And actually generates and sends OTP!
```

**Root Cause:**
Missing `[EmailAddress]` data annotation or manual validation in `AuthController.RequestOtp` method.

**Recommended Fix:**
```csharp
// In AuthController.cs
public class RequestOtpDto
{
    [Required]
    [EmailAddress(ErrorMessage = "Invalid email address format")]
    public string Email { get; set; } = string.Empty;
}
```

Or add validation in the controller:
```csharp
if (!IsValidEmail(request.Email))
{
    return BadRequest(new { error = "Invalid email address format" });
}
```

**Estimated Fix Time:** 15 minutes

**Verification:**
Run: `dotnet test --filter "RequestOtp_InvalidEmail"`
Should pass after fix.

---

### BUG #003 - MockEmailService Scope Issue Causing Test Failures

**Severity:** 🟡 HIGH - P1
**Component:** Backend - Test Infrastructure
**Assigned To:** Agent D (QA)
**Found By:** Agent D (QA)
**Date Found:** 2025-11-22 06:43:25
**Date Resolved:** 2025-11-22 07:42:00
**Status:** ✅ FIXED - Pending Verification (blocked by BUG #004 and #005)

**Description:**
5 integration tests failing because `MockEmailService` was registered as **scoped** instead of **singleton**, causing each HTTP request to get a different instance, so tests couldn't retrieve sent OTPs.

**Tests Affected:**
1. `VerifyOtp_CorrectCode_ShouldReturnTokens` - "Expected sentEmail not to be null"
2. `RefreshToken_ValidToken_ShouldReturnNewTokens` - "Sequence contains no matching element"
3. `VerifyOtp_DuplicateEmail_ShouldPreventAccountCreation` - 401 instead of 200
4. `VerifyOtp_NewUser_ShouldCreateAccount` - "Sequence contains no matching element"
5. `Logout_ValidToken_ShouldInvalidateSession` - "Sequence contains no matching element"

**Root Cause:**
```csharp
// WRONG (was in TestWebApplicationFactory.cs):
services.AddScoped<IEmailService, MockEmailService>();

// Each HTTP request creates NEW MockEmailService instance
// Test clears emails in one instance, but request uses different instance
```

**Resolution Applied:**
```csharp
// FIXED in TestWebApplicationFactory.cs:
services.AddSingleton<IEmailService, MockEmailService>();

// Now all scopes share same instance and SentEmails list
```

**File Modified:**
- `SilentID.Api.Tests/Helpers/TestWebApplicationFactory.cs` (line 40)

**Verification Status:**
✅ Fix applied
⏸️  Cannot verify yet - backend compilation errors prevent test execution (see BUG #004 and #005)

**Resolved By:** Agent D (QA Engineer)
**Will Verify After:** BUG #004 and BUG #005 are fixed

---

### BUG #004 - User Model Missing IdentityVerification Navigation Property

**Severity:** 🔴 CRITICAL - P0 BLOCKER
**Component:** Backend - Data Models
**Assigned To:** Agent B (Backend Engineer)
**Found By:** Agent D (QA)
**Date Found:** 2025-11-22 07:42:00
**Status:** 🔴 OPEN - Blocks All Testing

**Description:**
The `User` model is missing the reverse navigation property to `IdentityVerification`, causing compilation errors in `TrustScoreService`.

**Compilation Errors:**
```
CS1061: 'User' does not contain a definition for 'IdentityVerification'
        and no accessible extension method 'IdentityVerification' accepting
        a first argument of type 'User' could be found
```

**Failing Files:**
- `src/SilentID.Api/Services/TrustScoreService.cs:38` - `.Include(u => u.IdentityVerification)`
- `src/SilentID.Api/Services/TrustScoreService.cs:128` - `user.IdentityVerification`

**Current User Model:**
```csharp
public class User
{
    public Guid Id { get; set; }
    public string Email { get; set; }
    // ... other properties

    // Navigation properties
    public ICollection<Session> Sessions { get; set; } = new List<Session>();
    public ICollection<AuthDevice> AuthDevices { get; set; } = new List<AuthDevice>();
    // MISSING: IdentityVerification navigation property
}
```

**Required Fix:**
```csharp
public class User
{
    // ... existing properties

    // Navigation properties
    public ICollection<Session> Sessions { get; set; } = new List<Session>();
    public ICollection<AuthDevice> AuthDevices { get; set; } = new List<AuthDevice>();
    public IdentityVerification? IdentityVerification { get; set; }  // ADD THIS
}
```

**Impact:**
- **Backend cannot compile**
- **All tests blocked**
- **Development halted**

**Priority:** P0 - MUST FIX IMMEDIATELY

**Estimated Fix Time:** 5 minutes
**Verification:** `dotnet build` should succeed

---

### BUG #005 - TrustScoreService References Non-Existent VerificationStatus.Confirmed

**Severity:** 🔴 CRITICAL - P0 BLOCKER
**Component:** Backend - Services / Enums
**Assigned To:** Agent B (Backend Engineer)
**Found By:** Agent D (QA)
**Date Found:** 2025-11-22 07:42:00
**Status:** 🔴 OPEN - Blocks All Testing

**Description:**
`TrustScoreService` references `VerificationStatus.Confirmed` which doesn't exist in the enum definition.

**Compilation Error:**
```
CS0117: 'VerificationStatus' does not contain a definition for 'Confirmed'
```

**Failing File:**
- `src/SilentID.Api/Services/TrustScoreService.cs:60`

**Current VerificationStatus Enum:**
```csharp
public enum VerificationStatus
{
    Pending,        // Verification initiated but not completed
    Verified,       // Successfully verified
    Failed,         // Verification failed
    NeedsRetry      // User needs to retry
    // NO 'Confirmed' value exists
}
```

**TrustScoreService Code:**
```csharp
// Line 60 in TrustScoreService.cs:
.Where(m => (m.UserAId == userId || m.UserBId == userId)
        && m.Status == VerificationStatus.Confirmed)  // ERROR: Confirmed doesn't exist
```

**Required Fix:**
```csharp
// Should be MutualVerificationStatus, not VerificationStatus
// OR change to correct enum value

// Option 1: Use correct enum
.Where(m => (m.UserAId == userId || m.UserBId == userId)
        && m.Status == MutualVerificationStatus.Confirmed)

// Option 2: If VerificationStatus is correct, change to:
.Where(m => (m.UserAId == userId || m.UserBId == userId)
        && m.Status == VerificationStatus.Verified)
```

**Impact:**
- **Backend cannot compile**
- **All tests blocked**
- **Development halted**

**Priority:** P0 - MUST FIX IMMEDIATELY

**Estimated Fix Time:** 5 minutes
**Verification:** `dotnet build` should succeed

---

## Resolved Bugs

### BUG #001 - JWT SecretKey Not Configured in Test Environment ✅ RESOLVED

**Severity:** 🔴 CRITICAL - P0 BLOCKER
**Component:** Backend - Test Infrastructure
**Assigned To:** Agent D (QA Engineer)
**Found By:** Agent D (QA)
**Date Found:** 2025-11-22 00:41:03
**Date Resolved:** 2025-11-22 06:40:00
**Status:** ✅ VERIFIED - CLOSED

**Description:**
All 11 integration tests failed because `Program.cs` could not find JWT SecretKey when starting test server via `WebApplicationFactory`. This prevented end-to-end API testing.

**Impact:**
Prevented all integration testing of API endpoints.

**Root Cause:**
JWT configuration was not available when `Program.cs` executed during test startup.

**Resolution Applied:**
1. Created `src/SilentID.Api/appsettings.Testing.json` with JWT test configuration
2. Modified `src/SilentID.Api/Program.cs` to conditionally register PostgreSQL only if connection string exists
3. TestWebApplicationFactory already sets environment to "Testing", so configuration loads automatically

**Files Modified:**
- Created: `src/SilentID.Api/appsettings.Testing.json`
- Modified: `src/SilentID.Api/Program.cs` (lines 11-17)
- Modified: `SilentID.Api.Tests/Helpers/TestWebApplicationFactory.cs` (database provider fix)

**Verification:**
- Before fix: 42/53 tests passing (79%)
- After fix: 47/53 tests passing (89%)
- JWT configuration error: RESOLVED ✅
- Database provider conflict: RESOLVED ✅

**Resolved By:** Agent D (QA Engineer)
**Verified By:** Agent D (QA Engineer)

---

## Bug Statistics

| Severity | Open | Fixed (Unverified) | Resolved | Total |
|----------|------|-------------------|----------|-------|
| Critical (P0) | 2 | 0 | 1 | 3 |
| High (P1) | 1 | 1 | 0 | 2 |
| Medium (P2) | 0 | 0 | 0 | 0 |
| Low (P3) | 0 | 0 | 0 | 0 |
| **TOTAL** | **3** | **1** | **1** | **5** |

**Critical Blockers (P0):**
- BUG #004 - User model missing navigation property (BLOCKING ALL TESTING)
- BUG #005 - TrustScoreService enum mismatch (BLOCKING ALL TESTING)

**Test Health:**
- Total Tests: 53
- Passing: Cannot run (backend won't compile)
- Failing: Cannot run (backend won't compile)
- Last Successful Run: 2025-11-22 06:43 AM (48/53 passing)
- **Status:** 🔴 BLOCKED by compilation errors

**Trend:**
```
Initial run:     42/53 passing (79%) - 11 failed
After BUG #001:  48/53 passing (91%) - 5 failed
After BUG #003:  Cannot verify (backend won't compile)
Target:          53/53 passing (100%) - 0 failed
```

**Next Steps:**
1. Agent B must fix BUG #004 and #005 immediately (P0 blockers)
2. After backend compiles, Agent D will verify BUG #003 fix
3. After all P0 bugs fixed, continue with Sprint 3 testing

---

## Bug Lifecycle

```
OPEN → IN_PROGRESS → TESTING → VERIFIED → CLOSED
  ↓         ↓            ↓           ↓
BLOCKED  REOPENED    REJECTED   DEFERRED
```

**Current Lifecycle States:**
- **OPEN:** Bug reported, not yet started (BUG #001)
- **IN_PROGRESS:** Developer actively working on fix
- **BLOCKED:** Cannot proceed (waiting on dependency)
- **TESTING:** Fix implemented, awaiting QA verification
- **VERIFIED:** QA confirmed fix works
- **CLOSED:** Bug resolved and verified
- **REOPENED:** Bug recurred after being closed
- **REJECTED:** Not actually a bug
- **DEFERRED:** Bug acknowledged but not fixing now

---

## Bug Priority Definitions

**P0 - Critical (Blocker):**
- Blocks sprint progress
- Prevents testing or development
- No workaround available
- Must fix immediately

**P1 - High:**
- Major functionality broken
- Significant impact on users
- Workaround exists but difficult
- Fix within 1-2 days

**P2 - Medium:**
- Feature partially broken
- Moderate impact
- Easy workaround available
- Fix within 1 week

**P3 - Low:**
- Minor issue
- Cosmetic or edge case
- Minimal impact
- Fix when convenient

---

**Bug Tracker Maintained By:** Agent D (QA, Test & Automation)
**Review Frequency:** Daily during active sprints
**Escalation:** Critical bugs reported to Agent A (Architect) immediately

---
