# Public Profile Endpoint - Testing Script

**Generated:** 2025-11-23
**Endpoint:** GET /v1/public/profile/{username}
**Purpose:** Manual testing instructions for public profile endpoint

---

## Prerequisites

### Backend
1. Backend server running:
   ```bash
   cd C:\SILENTID\src\SilentID.Api
   dotnet run
   ```
2. Server should be accessible at: `http://localhost:5249`
3. Database should have at least one test user

### Frontend (Optional)
1. Flutter app running:
   ```bash
   cd C:\SILENTID\silentid_app
   flutter run
   ```

### Tools Required
- cURL (command line) OR
- Postman / Insomnia (GUI) OR
- Browser (for simple GET requests)

---

## Test Suite 1: Backend API Tests (cURL)

### Test 1.1: Valid User Profile
**Purpose:** Verify endpoint returns complete profile for existing user

**Prerequisites:**
- Need actual username from database
- If no users exist, create one first via auth flow

**Command:**
```bash
curl -X GET "http://localhost:5249/v1/public/profile/testuser" \
  -H "Accept: application/json" \
  -v
```

**Replace `testuser` with actual username from your database.**

**Expected Response (200 OK):**
```json
{
  "username": "@testuser",
  "displayName": "Test U.",
  "trustScore": 0,
  "trustScoreLabel": "High Risk",
  "identityVerified": false,
  "accountAge": "Today",
  "verifiedPlatforms": [],
  "verifiedTransactionCount": 0,
  "mutualVerificationCount": 0,
  "badges": [],
  "riskWarning": null,
  "createdAt": "2025-11-23T19:00:00Z"
}
```

**Validation Checklist:**
- [ ] HTTP status code is 200
- [ ] Response is valid JSON
- [ ] All fields present
- [ ] Username has @ prefix
- [ ] DisplayName is privacy-safe (first name + initial)
- [ ] TrustScore is integer (0-1000)
- [ ] TrustScoreLabel is one of: "Very High Trust", "High Trust", "Moderate Trust", "Low Trust", "High Risk"
- [ ] IdentityVerified is boolean
- [ ] AccountAge is string
- [ ] VerifiedPlatforms is array
- [ ] VerifiedTransactionCount is integer
- [ ] MutualVerificationCount is integer
- [ ] Badges is array
- [ ] RiskWarning is null or string
- [ ] CreatedAt is ISO 8601 datetime

---

### Test 1.2: Username Not Found
**Purpose:** Verify 404 error handling

**Command:**
```bash
curl -X GET "http://localhost:5249/v1/public/profile/nonexistentuser999" \
  -H "Accept: application/json" \
  -v
```

**Expected Response (404 Not Found):**
```json
{
  "error": "username_not_found",
  "message": "This username does not exist."
}
```

**Validation Checklist:**
- [ ] HTTP status code is 404
- [ ] Error object contains "error" and "message" fields
- [ ] Error code is "username_not_found"
- [ ] Message is user-friendly

---

### Test 1.3: Invalid Username (Too Short)
**Purpose:** Verify validation error handling

**Command:**
```bash
curl -X GET "http://localhost:5249/v1/public/profile/ab" \
  -H "Accept: application/json" \
  -v
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "invalid_username",
  "message": "Invalid username format. Must be 3-30 characters, alphanumeric and underscore only, starting with a letter."
}
```

**Validation Checklist:**
- [ ] HTTP status code is 400
- [ ] Error code is "invalid_username"
- [ ] Message explains username rules

---

### Test 1.4: Invalid Username (Too Long)
**Purpose:** Verify length validation

**Command:**
```bash
curl -X GET "http://localhost:5249/v1/public/profile/thisusernameiswaytoolongandshouldfail" \
  -H "Accept: application/json" \
  -v
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "invalid_username",
  "message": "Invalid username format. Must be 3-30 characters, alphanumeric and underscore only, starting with a letter."
}
```

**Validation Checklist:**
- [ ] HTTP status code is 400

---

### Test 1.5: Invalid Username (Starts with Number)
**Purpose:** Verify first character validation

**Command:**
```bash
curl -X GET "http://localhost:5249/v1/public/profile/123user" \
  -H "Accept: application/json" \
  -v
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "invalid_username",
  "message": "Invalid username format. Must be 3-30 characters, alphanumeric and underscore only, starting with a letter."
}
```

**Validation Checklist:**
- [ ] HTTP status code is 400

---

### Test 1.6: Invalid Username (Special Characters)
**Purpose:** Verify character validation

**Command:**
```bash
curl -X GET "http://localhost:5249/v1/public/profile/user@name" \
  -H "Accept: application/json" \
  -v
```

**Expected Response (400 Bad Request):**
```json
{
  "error": "invalid_username",
  "message": "Invalid username format. Must be 3-30 characters, alphanumeric and underscore only, starting with a letter."
}
```

**Validation Checklist:**
- [ ] HTTP status code is 400

---

### Test 1.7: Username with @ Prefix
**Purpose:** Verify @ prefix is stripped correctly

**Command:**
```bash
curl -X GET "http://localhost:5249/v1/public/profile/@testuser" \
  -H "Accept: application/json" \
  -v
```

**Expected Response (200 OK):**
Same as Test 1.1 (username found after stripping @)

**Validation Checklist:**
- [ ] HTTP status code is 200
- [ ] Response identical to Test 1.1
- [ ] @ prefix handled transparently

---

### Test 1.8: Case-Insensitive Username Lookup
**Purpose:** Verify username matching is case-insensitive

**Command:**
```bash
curl -X GET "http://localhost:5249/v1/public/profile/TESTUSER" \
  -H "Accept: application/json" \
  -v
```

**Expected Response (200 OK):**
Same as Test 1.1 (matches lowercase username)

**Validation Checklist:**
- [ ] HTTP status code is 200
- [ ] Username matched regardless of case
- [ ] Response username still has correct casing from database

---

### Test 1.9: Response Caching
**Purpose:** Verify 60-second cache header is set

**Command:**
```bash
curl -X GET "http://localhost:5249/v1/public/profile/testuser" \
  -H "Accept: application/json" \
  -v
```

**Expected Headers:**
```
Cache-Control: public, max-age=60
```

**Validation Checklist:**
- [ ] Cache-Control header present
- [ ] max-age=60 (60 seconds)
- [ ] Cache type is "public"

---

## Test Suite 2: Frontend Integration Tests

### Prerequisites
1. Backend running: `http://localhost:5249`
2. Flutter app running
3. At least one test user exists in database

---

### Test 2.1: View Public Profile (Happy Path)

**Steps:**
1. Open SilentID app
2. Navigate to public profile viewer screen
   - Route: `/profile/public/:username`
   - Or use search/browse feature
3. Enter username: `testuser` (replace with actual username)
4. Tap "View Profile" or equivalent

**Expected Behavior:**
- [ ] Loading spinner displays briefly
- [ ] Profile screen loads successfully
- [ ] Avatar displays (circular, with first letter of display name)
- [ ] Display name shows (e.g., "Test U.")
- [ ] Username shows with @ prefix (e.g., "@testuser")
- [ ] TrustScore card displays with:
  - Large number (0-1000)
  - Label text (e.g., "High Risk")
  - Purple gradient background
- [ ] Badges section displays (if user has badges)
- [ ] Activity metrics cards display:
  - Receipts count
  - Verified count
  - Platforms count
  - Account age
- [ ] QR code generates and displays
- [ ] Privacy notice displays at bottom
- [ ] No error messages or crashes

---

### Test 2.2: Safety Warning Display

**Prerequisites:**
- Create test user with 3+ verified reports
- OR temporarily modify backend to always show warning

**Steps:**
1. View public profile of user with verified reports
2. Scroll to safety warning section

**Expected Behavior:**
- [ ] Amber warning banner displays above TrustScore card
- [ ] Warning icon (⚠️) visible
- [ ] Title: "Safety Concern Reported"
- [ ] Message: "⚠️ Safety concern flagged — multiple verified reports received."
- [ ] Banner background is light amber
- [ ] Border is amber color (2px)

---

### Test 2.3: QR Code Generation

**Steps:**
1. View public profile
2. Scroll to QR code section
3. Use phone camera to scan QR code

**Expected Behavior:**
- [ ] QR code is visible and clear
- [ ] QR code is square, centered
- [ ] QR code has white background
- [ ] Scanning QR code resolves to URL: `https://silentid.co.uk/u/username`
- [ ] URL format correct (no @prefix)
- [ ] Caption below QR: "Scan to view this SilentID profile"

---

### Test 2.4: Share Profile

**Steps:**
1. View public profile
2. Tap share icon (top-right)
3. Select share method (e.g., Messages, Email)

**Expected Behavior:**
- [ ] Share sheet opens
- [ ] Share text format: "Check out [Display Name]'s SilentID profile: https://silentid.co.uk/u/username"
- [ ] Share completes successfully

---

### Test 2.5: Report User

**Steps:**
1. View public profile
2. Tap flag/report icon (top-right)
3. Verify navigation to report screen

**Expected Behavior:**
- [ ] Navigates to report screen
- [ ] Username pre-filled or passed as parameter
- [ ] Report form displays

---

### Test 2.6: Error Handling - User Not Found

**Steps:**
1. Navigate to public profile viewer
2. Enter non-existent username: `nonexistentuser999`
3. Tap "View Profile"

**Expected Behavior:**
- [ ] Loading spinner displays briefly
- [ ] Error state displays:
  - Error icon (red)
  - Title: "Could not load profile"
  - Message: "Username not found" or similar
  - "Try Again" button visible
- [ ] Tapping "Try Again" retries API call
- [ ] No app crash

---

### Test 2.7: Error Handling - Invalid Username

**Steps:**
1. Navigate to public profile viewer
2. Enter invalid username: `ab` (too short)
3. Tap "View Profile"

**Expected Behavior:**
- [ ] Error state displays
- [ ] Error message: "Invalid username format" or similar
- [ ] "Try Again" button visible

---

### Test 2.8: Error Handling - Network Error

**Prerequisites:**
- Stop backend server

**Steps:**
1. View public profile with backend offline

**Expected Behavior:**
- [ ] Error state displays
- [ ] Error message indicates network issue
- [ ] "Try Again" button visible
- [ ] Retrying when backend is back online works

---

### Test 2.9: Privacy Notice Display

**Steps:**
1. View any public profile
2. Scroll to bottom

**Expected Behavior:**
- [ ] Privacy notice container visible
- [ ] Background: soft lilac
- [ ] Info icon (ⓘ) present
- [ ] Title: "Privacy Protected"
- [ ] Message: "This public profile only shows display name, username, TrustScore, and general activity metrics. Full legal name, email, phone, address, and ID documents are never shown."
- [ ] Text is readable and clear

---

## Test Suite 3: Data Validation Tests

### Test 3.1: TrustScore Label Accuracy

**Test Matrix:**

| TrustScore | Expected Label |
|------------|----------------|
| 0 | High Risk |
| 100 | High Risk |
| 200 | High Risk |
| 201 | Low Trust |
| 400 | Low Trust |
| 401 | Moderate Trust |
| 600 | Moderate Trust |
| 601 | High Trust |
| 800 | High Trust |
| 801 | Very High Trust |
| 1000 | Very High Trust |

**Steps:**
1. Create test users with each TrustScore value
2. View public profile for each
3. Verify label matches expected value

**Validation:**
- [ ] All TrustScore labels match specification
- [ ] Edge cases handled correctly (200, 201, 400, 401, 600, 601, 800, 801)

---

### Test 3.2: Badge Generation Logic

**Test Matrix:**

| Condition | Expected Badge |
|-----------|---------------|
| IdentityVerified = true | "Identity Verified" |
| TransactionCount ≥ 500 | "500+ verified transactions" |
| TransactionCount ≥ 100 | "100+ verified transactions" |
| TransactionCount ≥ 50 | "50+ verified transactions" |
| TrustScore ≥ 800 | "Excellent behaviour" |
| TrustScore ≥ 600 | "Good behaviour" |
| MutualVerificationCount ≥ 20 | "Peer-verified user" |

**Steps:**
1. Create test users with various badge conditions
2. View public profiles
3. Verify badges appear correctly

**Validation:**
- [ ] All badge conditions trigger correctly
- [ ] Multiple badges display together
- [ ] Badge text matches specification

---

### Test 3.3: Safety Warning Threshold

**Test Matrix:**

| Verified Reports | Expected Warning |
|------------------|------------------|
| 0 | null |
| 1 | null |
| 2 | null |
| 3 | "⚠️ Safety concern flagged — multiple verified reports received." |
| 5 | "⚠️ Safety concern flagged — multiple verified reports received." |

**Steps:**
1. Create test users with 0, 1, 2, 3, 5 verified reports
2. View public profiles
3. Verify warning displays only when ≥3 reports

**Validation:**
- [ ] No warning for < 3 reports
- [ ] Warning appears for ≥ 3 reports
- [ ] Warning text matches specification exactly
- [ ] Warning is defamation-safe

---

## Test Suite 4: Performance Tests

### Test 4.1: Response Time

**Steps:**
1. Measure API response time with cURL:
   ```bash
   curl -X GET "http://localhost:5249/v1/public/profile/testuser" \
     -o /dev/null \
     -s \
     -w "Time: %{time_total}s\n"
   ```

**Expected:**
- [ ] Response time < 1 second (P95)
- [ ] Response time < 500ms average

---

### Test 4.2: Database Query Efficiency

**Steps:**
1. Enable SQL logging in appsettings.json
2. Make API request
3. Review logs for query count

**Expected:**
- [ ] No N+1 query issues
- [ ] All queries use AsNoTracking()
- [ ] Total queries ≤ 10 per request

---

### Test 4.3: Cache Effectiveness

**Steps:**
1. Make initial request (cache miss)
2. Make second request within 60 seconds (cache hit)
3. Compare response times

**Expected:**
- [ ] Second request returns cached response
- [ ] Second request faster than first

---

## Test Suite 5: Security Tests

### Test 5.1: No Sensitive Data Exposure

**Steps:**
1. View multiple public profiles
2. Check response for sensitive data

**Validation:**
- [ ] No full legal name
- [ ] No email addresses
- [ ] No phone numbers
- [ ] No physical addresses
- [ ] No date of birth
- [ ] No ID document data
- [ ] No internal user IDs (only username)
- [ ] No device fingerprints
- [ ] No IP addresses
- [ ] No raw evidence content

---

### Test 5.2: SQL Injection Prevention

**Steps:**
1. Attempt SQL injection in username:
   ```bash
   curl -X GET "http://localhost:5249/v1/public/profile/test' OR '1'='1"
   ```

**Expected:**
- [ ] Request rejected or treated as invalid username
- [ ] No SQL error returned
- [ ] No database access

---

### Test 5.3: XSS Prevention

**Steps:**
1. Create user with XSS attempt in display name: `<script>alert('XSS')</script>`
2. View public profile

**Expected:**
- [ ] Script not executed
- [ ] Display name shown as plain text
- [ ] No HTML rendering of malicious content

---

## Test Suite 6: Edge Cases

### Test 6.1: New User (No Evidence)

**Steps:**
1. Create brand new user
2. View public profile immediately

**Expected:**
- [ ] TrustScore = 0
- [ ] TrustScoreLabel = "High Risk"
- [ ] IdentityVerified = false
- [ ] AccountAge = "Today"
- [ ] All counts = 0
- [ ] Empty arrays for platforms and badges
- [ ] No safety warning

---

### Test 6.2: User with All Badges

**Steps:**
1. Create user meeting all badge conditions
2. View public profile

**Expected:**
- [ ] All badges display
- [ ] Badges wrap properly in UI
- [ ] No layout issues with many badges

---

### Test 6.3: Long Username (30 chars)

**Steps:**
1. Create user with 30-character username
2. View public profile

**Expected:**
- [ ] Profile loads successfully
- [ ] Username displays fully in UI
- [ ] No truncation or layout issues

---

## Test Results Template

### Test Execution Summary

**Date:** _______________
**Tester:** _______________
**Environment:** Local / Staging / Production

### Results

| Test ID | Test Name | Status | Notes |
|---------|-----------|--------|-------|
| 1.1 | Valid User Profile | ☐ Pass ☐ Fail | |
| 1.2 | Username Not Found | ☐ Pass ☐ Fail | |
| 1.3 | Invalid Username (Short) | ☐ Pass ☐ Fail | |
| 1.4 | Invalid Username (Long) | ☐ Pass ☐ Fail | |
| 1.5 | Invalid Username (Number) | ☐ Pass ☐ Fail | |
| 1.6 | Invalid Username (Special) | ☐ Pass ☐ Fail | |
| 1.7 | Username with @ Prefix | ☐ Pass ☐ Fail | |
| 1.8 | Case-Insensitive Lookup | ☐ Pass ☐ Fail | |
| 1.9 | Response Caching | ☐ Pass ☐ Fail | |
| 2.1 | View Public Profile | ☐ Pass ☐ Fail | |
| 2.2 | Safety Warning Display | ☐ Pass ☐ Fail | |
| 2.3 | QR Code Generation | ☐ Pass ☐ Fail | |
| 2.4 | Share Profile | ☐ Pass ☐ Fail | |
| 2.5 | Report User | ☐ Pass ☐ Fail | |
| 2.6 | Error - User Not Found | ☐ Pass ☐ Fail | |
| 2.7 | Error - Invalid Username | ☐ Pass ☐ Fail | |
| 2.8 | Error - Network Error | ☐ Pass ☐ Fail | |
| 2.9 | Privacy Notice | ☐ Pass ☐ Fail | |
| 3.1 | TrustScore Labels | ☐ Pass ☐ Fail | |
| 3.2 | Badge Generation | ☐ Pass ☐ Fail | |
| 3.3 | Safety Warning Threshold | ☐ Pass ☐ Fail | |
| 4.1 | Response Time | ☐ Pass ☐ Fail | |
| 4.2 | Query Efficiency | ☐ Pass ☐ Fail | |
| 4.3 | Cache Effectiveness | ☐ Pass ☐ Fail | |
| 5.1 | No Sensitive Data | ☐ Pass ☐ Fail | |
| 5.2 | SQL Injection Prevention | ☐ Pass ☐ Fail | |
| 5.3 | XSS Prevention | ☐ Pass ☐ Fail | |
| 6.1 | New User | ☐ Pass ☐ Fail | |
| 6.2 | User with All Badges | ☐ Pass ☐ Fail | |
| 6.3 | Long Username | ☐ Pass ☐ Fail | |

### Overall Test Status
- Total Tests: 30
- Passed: ______
- Failed: ______
- Pass Rate: ______%

### Critical Issues Found
1. _______________
2. _______________
3. _______________

### Recommendations
1. _______________
2. _______________
3. _______________

---

## Quick Start Testing

**If you have limited time, run these 5 essential tests:**

1. **Test 1.1:** Valid user profile (happy path)
2. **Test 1.2:** Username not found (404 error)
3. **Test 2.1:** View public profile in app (frontend integration)
4. **Test 2.3:** QR code generation (critical MVP feature)
5. **Test 5.1:** No sensitive data exposure (security critical)

**Estimated Time:** 15 minutes

---

**End of Test Script**
