# SilentID Database Schema

**Database:** PostgreSQL
**Version:** 15+
**Environment:** Local dev, Azure prod later
**Migration Tool:** Entity Framework Core

---

## SCHEMA PRINCIPLES

1. **All tables use UUIDs** (GUID primary keys)
2. **All tables have timestamps** (CreatedAt, UpdatedAt)
3. **Soft deletes** where needed (DeletedAt nullable)
4. **Foreign keys** with cascade rules
5. **Unique constraints** on critical fields
6. **Indexes** on frequently queried fields
7. **GDPR-compliant** (no raw sensitive data)

---

## IMPLEMENTED TABLES (Sprint 1 Complete)

### 1. Users

**Purpose:** Core user accounts (passwordless only)

**Columns:**
```sql
CREATE TABLE Users (
    Id                  UUID PRIMARY KEY,
    Email               VARCHAR(255) NOT NULL UNIQUE,
    Username            VARCHAR(50) UNIQUE,
    DisplayName         VARCHAR(100),
    PhoneNumber         VARCHAR(20),

    -- OAuth Provider IDs
    AppleUserId         VARCHAR(255),
    GoogleUserId        VARCHAR(255),

    -- Verification Status
    IsEmailVerified     BOOLEAN NOT NULL DEFAULT FALSE,
    IsPhoneVerified     BOOLEAN NOT NULL DEFAULT FALSE,
    IsPasskeyEnabled    BOOLEAN NOT NULL DEFAULT FALSE,

    -- Account Management
    AccountStatus       VARCHAR(20) NOT NULL DEFAULT 'Active',
    AccountType         VARCHAR(20) NOT NULL DEFAULT 'Free',

    -- Anti-Fraud
    SignupIP            VARCHAR(50),
    SignupDeviceId      VARCHAR(200),

    -- Timestamps
    CreatedAt           TIMESTAMP NOT NULL DEFAULT NOW(),
    UpdatedAt           TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IX_Users_Email ON Users(Email);
CREATE INDEX IX_Users_Username ON Users(Username);
CREATE INDEX IX_Users_AppleUserId ON Users(AppleUserId);
CREATE INDEX IX_Users_GoogleUserId ON Users(GoogleUserId);
```

**Enum Values:**
- `AccountStatus`: Active, Suspended, UnderReview
- `AccountType`: Free, Premium, Pro, Admin

**Business Rules:**
- Email is primary identity anchor (one email = one account)
- Username optional initially (set later by user)
- AppleUserId/GoogleUserId for OAuth linking
- NO password fields anywhere
- Admin type added in Sprint 2

---

### 2. Sessions

**Purpose:** Refresh token storage for JWT authentication

**Columns:**
```sql
CREATE TABLE Sessions (
    Id                  UUID PRIMARY KEY,
    UserId              UUID NOT NULL REFERENCES Users(Id) ON DELETE CASCADE,

    -- Token Management
    RefreshTokenHash    VARCHAR(64) NOT NULL,
    ExpiresAt           TIMESTAMP NOT NULL,

    -- Security Tracking
    IP                  VARCHAR(50),
    DeviceId            VARCHAR(200),

    -- Timestamps
    CreatedAt           TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IX_Sessions_UserId ON Sessions(UserId);
CREATE INDEX IX_Sessions_RefreshTokenHash ON Sessions(RefreshTokenHash);
CREATE INDEX IX_Sessions_ExpiresAt ON Sessions(ExpiresAt);
```

**Business Rules:**
- RefreshTokenHash = SHA-256 hash (never store plaintext)
- Sessions expire after 7 days
- Old sessions auto-deleted by background job
- IP and DeviceId for fraud detection

---

### 3. AuthDevices

**Purpose:** Track devices used for authentication

**Columns:**
```sql
CREATE TABLE AuthDevices (
    Id                  UUID PRIMARY KEY,
    UserId              UUID NOT NULL REFERENCES Users(Id) ON DELETE CASCADE,

    -- Device Fingerprint
    DeviceId            VARCHAR(200) NOT NULL,
    DeviceModel         VARCHAR(100),
    OS                  VARCHAR(50),
    Browser             VARCHAR(100),

    -- Trust Status
    IsTrusted           BOOLEAN NOT NULL DEFAULT FALSE,
    LastUsedAt          TIMESTAMP NOT NULL,

    -- Timestamps
    CreatedAt           TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IX_AuthDevices_UserId ON AuthDevices(UserId);
CREATE INDEX IX_AuthDevices_DeviceId ON AuthDevices(DeviceId);
```

**Business Rules:**
- DeviceId = hashed fingerprint (browser/OS/screen)
- IsTrusted = true for passkey-enabled devices
- Used for duplicate account detection
- Used for suspicious login detection

---

## SPRINT 2 TABLES (To Be Implemented)

### 4. IdentityVerification

**Purpose:** Track Stripe Identity verification status

**Columns:**
```sql
CREATE TABLE IdentityVerification (
    Id                      UUID PRIMARY KEY,
    UserId                  UUID NOT NULL REFERENCES Users(Id) ON DELETE CASCADE,

    -- Stripe Reference (NO ID documents stored)
    StripeVerificationId    VARCHAR(255) NOT NULL,
    Status                  VARCHAR(20) NOT NULL,
    Level                   VARCHAR(20),

    -- Timestamps
    VerifiedAt              TIMESTAMP,
    CreatedAt               TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IX_IdentityVerification_UserId ON IdentityVerification(UserId);
CREATE INDEX IX_IdentityVerification_StripeVerificationId ON IdentityVerification(StripeVerificationId);
```

**Enum Values:**
- `Status`: Pending, Verified, Failed, NeedsRetry
- `Level`: Basic, Enhanced

**Business Rules:**
- One verification per user (1:1 relationship)
- ONLY stores Stripe session ID and status
- NEVER stores ID documents, biometrics, or photos
- Stripe handles all sensitive data

---

### 5. ReceiptEvidence

**Purpose:** Store receipt-based transaction evidence

**Columns:**
```sql
CREATE TABLE ReceiptEvidence (
    Id                  UUID PRIMARY KEY,
    UserId              UUID NOT NULL REFERENCES Users(Id) ON DELETE CASCADE,

    -- Source Information
    Source              VARCHAR(50) NOT NULL,
    Platform            VARCHAR(50) NOT NULL,
    RawHash             VARCHAR(64),

    -- Transaction Details
    OrderId             VARCHAR(100),
    Item                VARCHAR(500),
    Amount              DECIMAL(10, 2),
    Currency            VARCHAR(3),
    Date                TIMESTAMP NOT NULL,
    Role                VARCHAR(20) NOT NULL,

    -- Quality Metrics
    IntegrityScore      INT NOT NULL DEFAULT 100,
    FraudFlag           BOOLEAN NOT NULL DEFAULT FALSE,
    EvidenceState       VARCHAR(20) NOT NULL DEFAULT 'Valid',

    -- Timestamps
    CreatedAt           TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IX_ReceiptEvidence_UserId ON ReceiptEvidence(UserId);
CREATE INDEX IX_ReceiptEvidence_Platform ON ReceiptEvidence(Platform);
CREATE INDEX IX_ReceiptEvidence_RawHash ON ReceiptEvidence(RawHash);
```

**Enum Values:**
- `Source`: Gmail, Outlook, IMAP, Forwarded, Manual
- `Platform`: Vinted, eBay, Depop, Etsy, FacebookMarketplace, Other
- `Role`: Buyer, Seller
- `EvidenceState`: Valid, Suspicious, Rejected

**Business Rules:**
- RawHash = SHA-256 of source email (detect duplicates)
- IntegrityScore 0-100 (calculated by risk engine)
- FraudFlag = true if risk engine detects fake receipt
- Manual receipts have higher scrutiny

---

### 6. ScreenshotEvidence

**Purpose:** Store screenshot-based evidence (ratings, reviews, profiles)

**Columns:**
```sql
CREATE TABLE ScreenshotEvidence (
    Id                  UUID PRIMARY KEY,
    UserId              UUID NOT NULL REFERENCES Users(Id) ON DELETE CASCADE,

    -- File Storage
    FileUrl             VARCHAR(500) NOT NULL,
    Platform            VARCHAR(50) NOT NULL,

    -- OCR Results
    OCRText             TEXT,

    -- Quality Metrics
    IntegrityScore      INT NOT NULL DEFAULT 100,
    FraudFlag           BOOLEAN NOT NULL DEFAULT FALSE,
    EvidenceState       VARCHAR(20) NOT NULL DEFAULT 'Valid',

    -- Timestamps
    CreatedAt           TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IX_ScreenshotEvidence_UserId ON ScreenshotEvidence(UserId);
CREATE INDEX IX_ScreenshotEvidence_Platform ON ScreenshotEvidence(Platform);
```

**Business Rules:**
- FileUrl = Azure Blob Storage path
- OCRText extracted via Azure Cognitive Services
- IntegrityScore checks: EXIF metadata, pixel manipulation, edge consistency
- Auto-reject if IntegrityScore < 40

---

### 7. ProfileLinkEvidence

**Purpose:** Store public profile scraping results

**Columns:**
```sql
CREATE TABLE ProfileLinkEvidence (
    Id                      UUID PRIMARY KEY,
    UserId                  UUID NOT NULL REFERENCES Users(Id) ON DELETE CASCADE,

    -- Profile Information
    URL                     VARCHAR(500) NOT NULL,
    Platform                VARCHAR(50) NOT NULL,

    -- Scraped Data
    ScrapeDataJson          JSONB,
    UsernameMatchScore      INT,

    -- Quality Metrics
    IntegrityScore          INT NOT NULL DEFAULT 100,
    EvidenceState           VARCHAR(20) NOT NULL DEFAULT 'Valid',

    -- Timestamps
    CreatedAt               TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IX_ProfileLinkEvidence_UserId ON ProfileLinkEvidence(UserId);
CREATE INDEX IX_ProfileLinkEvidence_Platform ON ProfileLinkEvidence(Platform);
```

**Business Rules:**
- URL must be public profile (legal scraping)
- ScrapeDataJson = { rating, reviewCount, joinDate, username }
- UsernameMatchScore = similarity % with SilentID username
- Max 10 profiles per Free user, unlimited for Premium/Pro

---

### 8. MutualVerifications

**Purpose:** Peer-to-peer transaction confirmations

**Columns:**
```sql
CREATE TABLE MutualVerifications (
    Id                  UUID PRIMARY KEY,

    -- Participants
    UserAId             UUID NOT NULL REFERENCES Users(Id) ON DELETE CASCADE,
    UserBId             UUID NOT NULL REFERENCES Users(Id) ON DELETE CASCADE,

    -- Transaction Details
    Item                VARCHAR(500),
    Amount              DECIMAL(10, 2),
    RoleA               VARCHAR(20) NOT NULL,
    RoleB               VARCHAR(20) NOT NULL,
    Date                TIMESTAMP NOT NULL,

    -- Evidence Link
    EvidenceId          UUID,

    -- Status
    Status              VARCHAR(20) NOT NULL DEFAULT 'Pending',
    FraudFlag           BOOLEAN NOT NULL DEFAULT FALSE,

    -- Timestamps
    CreatedAt           TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IX_MutualVerifications_UserAId ON MutualVerifications(UserAId);
CREATE INDEX IX_MutualVerifications_UserBId ON MutualVerifications(UserBId);
CREATE UNIQUE INDEX IX_MutualVerifications_Unique ON MutualVerifications(UserAId, UserBId, Date, Item);
```

**Enum Values:**
- `RoleA/RoleB`: Buyer, Seller
- `Status`: Pending, Confirmed, Rejected, Blocked

**Business Rules:**
- Both users must confirm for verification to be valid
- Collusion Detection System checks for circular patterns
- FraudFlag if suspicious (same device, same IP, rapid confirmations)
- Cannot verify transactions with self (UserAId != UserBId)

---

### 9. TrustScoreSnapshots

**Purpose:** Historical TrustScore records (weekly snapshots)

**Columns:**
```sql
CREATE TABLE TrustScoreSnapshots (
    Id                  UUID PRIMARY KEY,
    UserId              UUID NOT NULL REFERENCES Users(Id) ON DELETE CASCADE,

    -- Score Components
    Score               INT NOT NULL,
    IdentityScore       INT NOT NULL,
    EvidenceScore       INT NOT NULL,
    BehaviourScore      INT NOT NULL,
    PeerScore           INT NOT NULL,

    -- Breakdown (JSON for detailed factors)
    BreakdownJson       JSONB,

    -- Timestamps
    CreatedAt           TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IX_TrustScoreSnapshots_UserId ON TrustScoreSnapshots(UserId);
CREATE INDEX IX_TrustScoreSnapshots_CreatedAt ON TrustScoreSnapshots(CreatedAt);
```

**Business Rules:**
- Score range: 0-1000
- Component scores: Identity (200), Evidence (300), Behaviour (300), Peer (200)
- BreakdownJson contains detailed factor explanations
- New snapshot created weekly by background job

---

### 10. RiskSignals

**Purpose:** Track anti-fraud flags and risk events

**Columns:**
```sql
CREATE TABLE RiskSignals (
    Id                  UUID PRIMARY KEY,
    UserId              UUID NOT NULL REFERENCES Users(Id) ON DELETE CASCADE,

    -- Risk Details
    Type                VARCHAR(50) NOT NULL,
    Severity            INT NOT NULL,
    Message             VARCHAR(500),
    Metadata            JSONB,

    -- Timestamps
    CreatedAt           TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IX_RiskSignals_UserId ON RiskSignals(UserId);
CREATE INDEX IX_RiskSignals_Type ON RiskSignals(Type);
CREATE INDEX IX_RiskSignals_Severity ON RiskSignals(Severity);
```

**Type Values:**
- FakeReceipt, FakeScreenshot, Collusion, DeviceMismatch, IPRisk, Reported, ProfileMismatch, AccountTakeover

**Severity:** 1-10 (10 = critical)

**Business Rules:**
- RiskSignals accumulate to calculate RiskScore (0-100)
- Multiple signals of same type = higher RiskScore
- Admin can manually add/remove signals

---

### 11. Reports

**Purpose:** User-submitted safety reports

**Columns:**
```sql
CREATE TABLE Reports (
    Id                      UUID PRIMARY KEY,

    -- Parties
    ReporterId              UUID NOT NULL REFERENCES Users(Id) ON DELETE CASCADE,
    ReportedUserId          UUID NOT NULL REFERENCES Users(Id) ON DELETE CASCADE,

    -- Report Details
    Category                VARCHAR(50) NOT NULL,
    Description             TEXT,

    -- Status
    Status                  VARCHAR(20) NOT NULL DEFAULT 'Pending',

    -- Timestamps
    CreatedAt               TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IX_Reports_ReportedUserId ON Reports(ReportedUserId);
CREATE INDEX IX_Reports_Status ON Reports(Status);
```

**Category Values:**
- ItemNotReceived, AggressiveBehaviour, FraudConcern, Impersonation, Other

**Status Values:**
- Pending, UnderReview, Verified, Dismissed

**Business Rules:**
- Requires ≥3 verified reports for public risk flag
- Reporter must be ID-verified to submit
- Admin review required before marking Verified

---

### 12. ReportEvidence

**Purpose:** Attachments to safety reports

**Columns:**
```sql
CREATE TABLE ReportEvidence (
    Id                  UUID PRIMARY KEY,
    ReportId            UUID NOT NULL REFERENCES Reports(Id) ON DELETE CASCADE,

    -- File Information
    FileUrl             VARCHAR(500) NOT NULL,
    OCRText             TEXT,

    -- Timestamps
    CreatedAt           TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IX_ReportEvidence_ReportId ON ReportEvidence(ReportId);
```

**Business Rules:**
- Supports screenshots, receipts, chat logs
- OCR extraction for text-based evidence
- Max 5 evidence files per report

---

### 13. Subscriptions

**Purpose:** Track billing and subscription tiers

**Columns:**
```sql
CREATE TABLE Subscriptions (
    Id                  UUID PRIMARY KEY,
    UserId              UUID NOT NULL REFERENCES Users(Id) ON DELETE CASCADE,

    -- Subscription Details
    Tier                VARCHAR(20) NOT NULL DEFAULT 'Free',
    StripeCustomerId    VARCHAR(255),
    StripeSubscriptionId VARCHAR(255),

    -- Billing
    RenewalDate         TIMESTAMP,
    CancelAt            TIMESTAMP,

    -- Timestamps
    CreatedAt           TIMESTAMP NOT NULL DEFAULT NOW(),
    UpdatedAt           TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IX_Subscriptions_UserId ON Subscriptions(UserId);
CREATE INDEX IX_Subscriptions_StripeCustomerId ON Subscriptions(StripeCustomerId);
```

**Tier Values:**
- Free, Premium, Pro

**Business Rules:**
- One active subscription per user
- Stripe handles payment processing
- CancelAt = scheduled cancellation (keeps access until end of period)

---

### 14. AdminAuditLogs

**Purpose:** Track all admin actions for compliance

**Columns:**
```sql
CREATE TABLE AdminAuditLogs (
    Id                  UUID PRIMARY KEY,

    -- Admin Information
    AdminUser           VARCHAR(255) NOT NULL,
    Action              VARCHAR(100) NOT NULL,
    TargetUserId        UUID,

    -- Details
    Details             JSONB,

    -- Timestamps
    CreatedAt           TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IX_AdminAuditLogs_AdminUser ON AdminAuditLogs(AdminUser);
CREATE INDEX IX_AdminAuditLogs_TargetUserId ON AdminAuditLogs(TargetUserId);
CREATE INDEX IX_AdminAuditLogs_CreatedAt ON AdminAuditLogs(CreatedAt);
```

**Business Rules:**
- Append-only table (NO updates or deletes)
- All admin actions must be logged
- Retention: 7 years for compliance
- Accessible to senior admins only

---

### 15. SecurityAlerts

**Purpose:** Security notifications for users (Section 15)

**Columns:**
```sql
CREATE TABLE SecurityAlerts (
    Id                  UUID PRIMARY KEY,
    UserId              UUID NOT NULL REFERENCES Users(Id) ON DELETE CASCADE,

    -- Alert Details
    Type                VARCHAR(50) NOT NULL,
    Title               VARCHAR(200) NOT NULL,
    Message             TEXT,
    Severity            INT NOT NULL,

    -- Status
    IsRead              BOOLEAN NOT NULL DEFAULT FALSE,

    -- Timestamps
    CreatedAt           TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX IX_SecurityAlerts_UserId ON SecurityAlerts(UserId);
CREATE INDEX IX_SecurityAlerts_IsRead ON SecurityAlerts(IsRead);
```

**Type Values:**
- Breach, SuspiciousLogin, DeviceIssue, RiskSignal

**Severity:** 1-10

**Business Rules:**
- Push notifications sent for Severity ≥ 7
- Auto-marked IsRead after 30 days
- Max 100 alerts per user (oldest auto-deleted)

---

## RELATIONSHIP DIAGRAM

```
Users (hub)
 ├── Sessions (1:many)
 ├── AuthDevices (1:many)
 ├── IdentityVerification (1:1)
 ├── ReceiptEvidence (1:many)
 ├── ScreenshotEvidence (1:many)
 ├── ProfileLinkEvidence (1:many)
 ├── MutualVerifications (many:many via UserA/UserB)
 ├── TrustScoreSnapshots (1:many)
 ├── RiskSignals (1:many)
 ├── Reports (1:many as Reporter AND ReportedUser)
 ├── Subscriptions (1:1 or 1:many for history)
 ├── SecurityAlerts (1:many)
 └── AdminAuditLogs (many:1 as TargetUser)

Reports
 └── ReportEvidence (1:many)
```

---

## DATA PRIVACY & GDPR

### What We Store:
- ✅ Email (encrypted at rest)
- ✅ Username, DisplayName
- ✅ OAuth provider IDs (AppleUserId, GoogleUserId)
- ✅ Stripe verification status (NOT documents)
- ✅ Evidence metadata (NOT raw emails)
- ✅ Hashed device fingerprints
- ✅ IP addresses (for fraud detection, retention limits)

### What We NEVER Store:
- ❌ Passwords (none exist)
- ❌ ID document photos
- ❌ Biometric data
- ❌ Full raw emails
- ❌ Passport/ID numbers
- ❌ Full legal names (public profiles)

### Retention Policies:
- User data: Until account deletion
- Sessions: 7 days
- AdminAuditLogs: 7 years
- RiskSignals: 6 years (fraud prevention)
- TrustScoreSnapshots: Until account deletion

### Right to Erasure:
- User requests deletion → soft delete (mark DeletedAt)
- Anonymize personally identifiable fields
- Keep fraud logs for legal compliance (6-7 years)
- Export data before deletion (GDPR SAR)

---

## MIGRATION STRATEGY

### Sprint 1 (Complete):
- ✅ Users table
- ✅ Sessions table
- ✅ AuthDevices table

### Sprint 2 (Planned):
- [ ] IdentityVerification table
- [ ] ReceiptEvidence, ScreenshotEvidence, ProfileLinkEvidence
- [ ] MutualVerifications table
- [ ] TrustScoreSnapshots table
- [ ] RiskSignals table
- [ ] Reports, ReportEvidence tables
- [ ] Subscriptions table
- [ ] AdminAuditLogs table
- [ ] SecurityAlerts table

**Migration Command:**
```bash
cd C:\SILENTID\src\SilentID.Api
dotnet ef migrations add Sprint2CompleteSchema
dotnet ef database update
```

**Auto-Migration in Dev:**
- Migrations auto-apply on startup in Development environment
- Manual approval required in Production

---

**Document Owner:** Agent A (Architect)
**Last Updated:** 2025-11-21
**Status:** CURRENT
