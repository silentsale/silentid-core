# SilentID API Contracts

**Version:** 2.0
**Base URL:** `https://api.silentid.co.uk/v1`
**Dev URL:** `http://localhost:5249/v1`
**Authentication:** Bearer JWT in `Authorization` header

---

## AUTHENTICATION

All endpoints except public ones require:
```
Authorization: Bearer <access_token>
```

**Token Lifecycle:**
- Access Token: 15 minutes
- Refresh Token: 7 days
- Re-authentication required after 2 hours (for sensitive operations)

---

## EXISTING ENDPOINTS (Sprint 1 Complete)

### 1. Health Check
**GET /v1/health**

**Auth:** None (Public)

**Response 200:**
```json
{
  "status": "healthy",
  "timestamp": "2025-11-21T10:00:00Z"
}
```

---

### 2. Request OTP
**POST /v1/auth/request-otp**

**Auth:** None (Public)

**Request:**
```json
{
  "email": "user@example.com"
}
```

**Response 200:**
```json
{
  "message": "OTP sent to your email",
  "expiresIn": 300
}
```

**Response 429 (Rate Limited):**
```json
{
  "error": "too_many_requests",
  "message": "Maximum 3 OTP requests per 5 minutes",
  "retryAfter": 180
}
```

**Business Rules:**
- 6-digit OTP generated
- Valid for 5 minutes
- Max 3 requests per email per 5 minutes
- OTP sent via SendGrid (or logged to console in dev)

---

### 3. Verify OTP
**POST /v1/auth/verify-otp**

**Auth:** None (Public)

**Request:**
```json
{
  "email": "user@example.com",
  "otp": "123456"
}
```

**Response 200 (Existing User):**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIs...",
  "refreshToken": "dGhpc2lzYXJlZnJlc2h0b2tlbg...",
  "expiresIn": 900,
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "username": "johndoe",
    "displayName": "John D.",
    "isEmailVerified": true,
    "accountType": "Free",
    "createdAt": "2025-01-01T00:00:00Z"
  }
}
```

**Response 201 (New User Created):**
```json
{
  "accessToken": "...",
  "refreshToken": "...",
  "expiresIn": 900,
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "username": null,
    "displayName": null,
    "isEmailVerified": true,
    "accountType": "Free",
    "createdAt": "2025-11-21T10:00:00Z"
  }
}
```

**Response 401 (Invalid OTP):**
```json
{
  "error": "invalid_otp",
  "message": "The OTP code is incorrect or has expired"
}
```

**Business Rules:**
- Auto-create user if email doesn't exist
- Email marked as verified upon successful OTP
- Username nullable (set later by user)
- Duplicate detection runs before account creation

---

### 4. Refresh Token
**POST /v1/auth/refresh**

**Auth:** None (Public)

**Request:**
```json
{
  "refreshToken": "dGhpc2lzYXJlZnJlc2h0b2tlbg..."
}
```

**Response 200:**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIs...",
  "expiresIn": 900
}
```

**Response 401 (Invalid/Expired):**
```json
{
  "error": "invalid_token",
  "message": "Refresh token is invalid or expired"
}
```

**Business Rules:**
- Refresh token valid for 7 days
- New access token issued on refresh
- Refresh token NOT rotated (same token reused)

---

### 5. Logout
**POST /v1/auth/logout**

**Auth:** Required

**Request:**
```json
{
  "refreshToken": "dGhpc2lzYXJlZnJlc2h0b2tlbg..."
}
```

**Response 200:**
```json
{
  "message": "Logged out successfully"
}
```

**Business Rules:**
- Deletes refresh token from database
- Access token remains valid until expiry (15 min)
- Device entry updated with LastUsedAt

---

## NEW ENDPOINTS (Sprint 2)

### 6. Create Stripe Identity Session
**POST /v1/identity/stripe/session**

**Auth:** Required

**Request:**
```json
{
  "returnUrl": "silentid://identity-verification-complete"
}
```

**Response 200:**
```json
{
  "sessionId": "vs_1ABC...",
  "url": "https://verify.stripe.com/start/vs_1ABC...",
  "expiresAt": "2025-11-21T11:00:00Z"
}
```

**Response 400 (Already Verified):**
```json
{
  "error": "already_verified",
  "message": "Identity already verified for this user"
}
```

**Business Rules:**
- Creates Stripe Identity verification session
- Stores sessionId in IdentityVerification table
- User can only have one active session at a time
- Session expires after 1 hour

---

### 7. Get Identity Verification Status
**GET /v1/identity/status**

**Auth:** Required

**Response 200 (Verified):**
```json
{
  "status": "Verified",
  "verifiedAt": "2025-11-20T15:30:00Z",
  "level": "Basic"
}
```

**Response 200 (Pending):**
```json
{
  "status": "Pending",
  "verifiedAt": null,
  "level": null
}
```

**Response 200 (Failed):**
```json
{
  "status": "Failed",
  "verifiedAt": null,
  "level": null,
  "canRetry": true
}
```

**Business Rules:**
- Status values: Pending, Verified, Failed, NeedsRetry
- Level values: Basic, Enhanced
- Only status and timestamp stored (NO ID documents)

---

### 8. Upload Manual Receipt
**POST /v1/evidence/receipts/manual**

**Auth:** Required

**Request:**
```json
{
  "platform": "Vinted",
  "orderId": "ORD-12345",
  "item": "Nike Air Max",
  "amount": 45.99,
  "currency": "GBP",
  "date": "2025-11-15T14:30:00Z",
  "role": "Seller"
}
```

**Response 201:**
```json
{
  "id": "uuid",
  "platform": "Vinted",
  "orderId": "ORD-12345",
  "item": "Nike Air Max",
  "amount": 45.99,
  "currency": "GBP",
  "date": "2025-11-15T14:30:00Z",
  "role": "Seller",
  "evidenceState": "Valid",
  "integrityScore": 100,
  "createdAt": "2025-11-21T10:00:00Z"
}
```

**Response 400 (Invalid Data):**
```json
{
  "error": "validation_failed",
  "message": "Amount must be positive",
  "details": {
    "field": "amount",
    "value": -10
  }
}
```

**Business Rules:**
- Platform enum: Vinted, eBay, Depop, Etsy, Other
- Role enum: Buyer, Seller
- Amount must be positive
- Date cannot be in future
- IntegrityScore calculated by risk engine

---

### 9. List User Receipts
**GET /v1/evidence/receipts**

**Auth:** Required

**Query Parameters:**
- `page` (int, default: 1)
- `pageSize` (int, default: 20, max: 100)
- `platform` (string, optional)
- `role` (string, optional)

**Response 200:**
```json
{
  "items": [
    {
      "id": "uuid",
      "platform": "Vinted",
      "orderId": "ORD-12345",
      "item": "Nike Air Max",
      "amount": 45.99,
      "currency": "GBP",
      "date": "2025-11-15T14:30:00Z",
      "role": "Seller",
      "evidenceState": "Valid",
      "integrityScore": 100,
      "createdAt": "2025-11-21T10:00:00Z"
    }
  ],
  "totalCount": 1,
  "page": 1,
  "pageSize": 20,
  "totalPages": 1
}
```

**Business Rules:**
- User can only see their own receipts
- Results sorted by date (newest first)
- Pagination required for large datasets

---

### 10. Get Screenshot Upload URL
**POST /v1/evidence/screenshots/upload-url**

**Auth:** Required

**Request:**
```json
{
  "fileName": "vinted-profile.png",
  "contentType": "image/png",
  "platform": "Vinted"
}
```

**Response 200:**
```json
{
  "uploadUrl": "https://silentid.blob.core.windows.net/evidence/...",
  "evidenceId": "uuid",
  "expiresIn": 300
}
```

**Business Rules:**
- Generates signed Azure Blob SAS URL
- Valid for 5 minutes
- Max file size: 10 MB
- Supported types: PNG, JPG, JPEG, PDF

---

### 11. Process Uploaded Screenshot
**POST /v1/evidence/screenshots**

**Auth:** Required

**Request:**
```json
{
  "evidenceId": "uuid",
  "platform": "Vinted"
}
```

**Response 201:**
```json
{
  "id": "uuid",
  "platform": "Vinted",
  "fileUrl": "https://silentid.blob.core.windows.net/evidence/...",
  "ocrText": "Extracted text from screenshot...",
  "integrityScore": 95,
  "evidenceState": "Valid",
  "fraudFlag": false,
  "createdAt": "2025-11-21T10:00:00Z"
}
```

**Response 400 (Suspicious):**
```json
{
  "error": "evidence_rejected",
  "message": "Screenshot appears to be modified",
  "evidenceState": "Rejected",
  "integrityScore": 25
}
```

**Business Rules:**
- OCR extraction via Azure Cognitive Services
- Image forensics checks (EXIF, pixel manipulation)
- IntegrityScore 0-100
- Auto-reject if score < 40

---

### 12. Get Screenshot Evidence
**GET /v1/evidence/screenshots/{id}**

**Auth:** Required

**Response 200:**
```json
{
  "id": "uuid",
  "platform": "Vinted",
  "fileUrl": "https://silentid.blob.core.windows.net/evidence/...",
  "ocrText": "Extracted text...",
  "integrityScore": 95,
  "evidenceState": "Valid",
  "fraudFlag": false,
  "createdAt": "2025-11-21T10:00:00Z"
}
```

**Response 403 (Not Owner):**
```json
{
  "error": "forbidden",
  "message": "You can only access your own evidence"
}
```

---

### 13. Submit Profile Link
**POST /v1/evidence/profile-links**

**Auth:** Required

**Request:**
```json
{
  "url": "https://www.vinted.com/member/12345",
  "platform": "Vinted"
}
```

**Response 202 (Accepted):**
```json
{
  "id": "uuid",
  "url": "https://www.vinted.com/member/12345",
  "platform": "Vinted",
  "status": "Pending",
  "createdAt": "2025-11-21T10:00:00Z"
}
```

**Business Rules:**
- Scraping happens asynchronously
- Status values: Pending, Scraped, Failed
- Max 10 profile links per user (Free tier)

---

### 14. Get Profile Link Data
**GET /v1/evidence/profile-links/{id}**

**Auth:** Required

**Response 200 (Scraped):**
```json
{
  "id": "uuid",
  "url": "https://www.vinted.com/member/12345",
  "platform": "Vinted",
  "status": "Scraped",
  "scrapeDataJson": {
    "rating": 4.9,
    "reviewCount": 234,
    "joinDate": "2020-05-15",
    "username": "johndoe"
  },
  "usernameMatchScore": 85,
  "integrityScore": 90,
  "evidenceState": "Valid",
  "createdAt": "2025-11-21T10:00:00Z"
}
```

---

### 15. Get Current TrustScore
**GET /v1/trustscore/me**

**Auth:** Required

**Response 200:**
```json
{
  "score": 754,
  "label": "High Trust",
  "identityScore": 200,
  "evidenceScore": 180,
  "behaviourScore": 240,
  "peerScore": 134,
  "lastCalculated": "2025-11-21T09:00:00Z"
}
```

**Business Rules:**
- Score range: 0-1000
- Labels: Very High Trust (801-1000), High Trust (601-800), Moderate Trust (401-600), Low Trust (201-400), High Risk (0-200)
- Recalculated weekly

---

### 16. Get TrustScore Breakdown
**GET /v1/trustscore/me/breakdown**

**Auth:** Required

**Response 200:**
```json
{
  "score": 754,
  "label": "High Trust",
  "breakdown": {
    "identity": {
      "maxPoints": 200,
      "earned": 200,
      "factors": [
        { "name": "Identity Verified via Stripe", "points": 200 }
      ]
    },
    "evidence": {
      "maxPoints": 300,
      "earned": 180,
      "factors": [
        { "name": "96 receipt-based transactions", "points": 140 },
        { "name": "3 public profiles linked", "points": 40 }
      ]
    },
    "behaviour": {
      "maxPoints": 300,
      "earned": 240,
      "factors": [
        { "name": "No safety flags", "points": 40 },
        { "name": "Account age (2 years)", "points": 60 },
        { "name": "Consistent cross-platform behavior", "points": 140 }
      ]
    },
    "peer": {
      "maxPoints": 200,
      "earned": 134,
      "factors": [
        { "name": "12 mutual verifications", "points": 120 },
        { "name": "Returning partner transactions", "points": 14 }
      ]
    }
  },
  "lastCalculated": "2025-11-21T09:00:00Z"
}
```

---

### 17. Get TrustScore History
**GET /v1/trustscore/me/history**

**Auth:** Required

**Query Parameters:**
- `limit` (int, default: 10, max: 50)

**Response 200:**
```json
{
  "snapshots": [
    {
      "score": 754,
      "identityScore": 200,
      "evidenceScore": 180,
      "behaviourScore": 240,
      "peerScore": 134,
      "createdAt": "2025-11-21T09:00:00Z"
    },
    {
      "score": 720,
      "identityScore": 200,
      "evidenceScore": 160,
      "behaviourScore": 230,
      "peerScore": 130,
      "createdAt": "2025-11-14T09:00:00Z"
    }
  ]
}
```

---

### 18. Get User Risk Score
**GET /v1/security/risk-score**

**Auth:** Required

**Response 200:**
```json
{
  "riskScore": 12,
  "level": "Low",
  "signals": [
    {
      "type": "DeviceMismatch",
      "severity": 3,
      "message": "New device detected",
      "createdAt": "2025-11-20T10:00:00Z",
      "resolved": false
    }
  ]
}
```

**Business Rules:**
- RiskScore range: 0-100
- Levels: Safe (0-15), Medium Risk (16-40), High Risk (41-70), Critical (71-100)
- User can see their own risk data (transparency)

---

## ERROR RESPONSES

All endpoints follow consistent error format:

**400 Bad Request:**
```json
{
  "error": "validation_failed",
  "message": "Human-readable explanation",
  "details": {
    "field": "email",
    "value": "invalid"
  }
}
```

**401 Unauthorized:**
```json
{
  "error": "unauthorized",
  "message": "Access token is invalid or expired"
}
```

**403 Forbidden:**
```json
{
  "error": "forbidden",
  "message": "You don't have permission to access this resource"
}
```

**404 Not Found:**
```json
{
  "error": "not_found",
  "message": "Resource not found"
}
```

**409 Conflict:**
```json
{
  "error": "duplicate",
  "message": "Email already registered"
}
```

**422 Unprocessable Entity:**
```json
{
  "error": "invalid_data",
  "message": "Request data is invalid",
  "details": {
    "amount": "Must be positive"
  }
}
```

**429 Too Many Requests:**
```json
{
  "error": "rate_limit_exceeded",
  "message": "Too many requests. Please try again later.",
  "retryAfter": 60
}
```

**500 Internal Server Error:**
```json
{
  "error": "internal_error",
  "message": "An unexpected error occurred. Please contact support."
}
```

---

## WEBHOOKS

### Stripe Identity Webhook
**POST /webhooks/stripe/identity**

**Headers:**
```
Stripe-Signature: t=...,v1=...
```

**Payload:**
```json
{
  "type": "identity.verification_session.verified",
  "data": {
    "object": {
      "id": "vs_1ABC...",
      "status": "verified"
    }
  }
}
```

**Business Logic:**
1. Verify Stripe signature
2. Find IdentityVerification by sessionId
3. Update status to Verified
4. Trigger TrustScore recalculation
5. Return 200 to acknowledge

---

## PAGINATION

All list endpoints support pagination:

**Query Parameters:**
- `page` (int, default: 1)
- `pageSize` (int, default: 20, max: 100)

**Response Format:**
```json
{
  "items": [...],
  "totalCount": 150,
  "page": 1,
  "pageSize": 20,
  "totalPages": 8
}
```

---

## VERSIONING

**Current Version:** v1

**Version Header (Optional):**
```
API-Version: 1
```

**Breaking Changes:**
- Will increment to v2
- v1 supported for 6 months after v2 release

---

**Document Owner:** Agent A (Architect)
**Last Updated:** 2025-11-21
**Status:** CURRENT
