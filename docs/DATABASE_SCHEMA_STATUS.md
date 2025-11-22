# SilentID Database Schema Implementation Status

**Generated:** 2025-11-21
**Database:** PostgreSQL
**Database Name:** `silentid_dev`
**Host:** localhost:5432

---

## 📊 QUICK SUMMARY

| Category | Implemented | Missing | Total | Progress |
|----------|-------------|---------|-------|----------|
| **Core Auth Tables** | 3 | 0 | 3 | 100% ✅ |
| **Identity Tables** | 0 | 1 | 1 | 0% 🔴 |
| **Evidence Tables** | 0 | 3 | 3 | 0% 🔴 |
| **Trust Tables** | 0 | 2 | 2 | 0% 🔴 |
| **Safety Tables** | 0 | 2 | 2 | 0% 🔴 |
| **Business Tables** | 0 | 2 | 2 | 0% 🔴 |
| **Admin Tables** | 0 | 1 | 1 | 0% 🔴 |
| **TOTAL** | **3** | **11** | **14** | **21%** |

---

## ✅ IMPLEMENTED TABLES (3/14)

### 1. Users Table - ✅ PRODUCTION READY

**Migration:** `20251121135028_InitialCreate.cs` + `20251121140300_AddOAuthProviderIds.cs`

**Schema:**
```sql
CREATE TABLE "Users" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "Email" VARCHAR(255) NOT NULL UNIQUE,
    "Username" VARCHAR(100) NOT NULL UNIQUE,
    "DisplayName" VARCHAR(100) NOT NULL,
    "PhoneNumber" VARCHAR(20),
    "IsEmailVerified" BOOLEAN DEFAULT FALSE,
    "IsPhoneVerified" BOOLEAN DEFAULT FALSE,
    "IsPasskeyEnabled" BOOLEAN DEFAULT FALSE,
    "AppleUserId" VARCHAR(255),
    "GoogleUserId" VARCHAR(255),
    "AccountStatus" INTEGER DEFAULT 0,  -- 0=Active, 1=Suspended, 2=UnderReview
    "AccountType" INTEGER DEFAULT 0,     -- 0=Free, 1=Premium, 2=Pro
    "SignupIP" VARCHAR(50),
    "SignupDeviceId" VARCHAR(200),
    "CreatedAt" TIMESTAMP NOT NULL,
    "UpdatedAt" TIMESTAMP NOT NULL
);

CREATE UNIQUE INDEX "IX_Users_Email" ON "Users"("Email");
CREATE UNIQUE INDEX "IX_Users_Username" ON "Users"("Username");
```

**Status:** ✅ Complete
**Notes:**
- NO password fields ✅
- OAuth provider IDs prepared for Apple/Google ✅
- Duplicate detection fields included ✅
- ⚠️ **CRITICAL:** Admin value (3) missing from AccountType enum

**C# Model Location:** `src/SilentID.Api/Models/User.cs`

---

### 2. Sessions Table - ✅ PRODUCTION READY

**Migration:** `20251121135028_InitialCreate.cs`

**Schema:**
```sql
CREATE TABLE "Sessions" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "UserId" UUID NOT NULL REFERENCES "Users"("Id") ON DELETE CASCADE,
    "RefreshTokenHash" VARCHAR(500) NOT NULL,
    "ExpiresAt" TIMESTAMP NOT NULL,
    "IP" VARCHAR(50),
    "DeviceId" VARCHAR(200),
    "CreatedAt" TIMESTAMP NOT NULL
);

CREATE INDEX "IX_Sessions_UserId" ON "Sessions"("UserId");
CREATE INDEX "IX_Sessions_RefreshTokenHash" ON "Sessions"("RefreshTokenHash");
```

**Status:** ✅ Complete
**Notes:**
- Refresh tokens hashed with SHA256 ✅
- 7-day expiry enforced ✅
- IP and device tracking ✅
- Cascade delete on user deletion ✅

**C# Model Location:** `src/SilentID.Api/Models/Session.cs`

---

### 3. AuthDevices Table - ✅ PRODUCTION READY

**Migration:** `20251121135028_InitialCreate.cs`

**Schema:**
```sql
CREATE TABLE "AuthDevices" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "UserId" UUID NOT NULL REFERENCES "Users"("Id") ON DELETE CASCADE,
    "DeviceId" VARCHAR(200) NOT NULL,
    "DeviceModel" VARCHAR(100),
    "OS" VARCHAR(50),
    "Browser" VARCHAR(50),
    "LastUsedAt" TIMESTAMP NOT NULL,
    "IsTrusted" BOOLEAN DEFAULT FALSE,
    "CreatedAt" TIMESTAMP NOT NULL
);

CREATE INDEX "IX_AuthDevices_UserId" ON "AuthDevices"("UserId");
CREATE INDEX "IX_AuthDevices_DeviceId" ON "AuthDevices"("DeviceId");
```

**Status:** ✅ Complete
**Notes:**
- Device fingerprinting working ✅
- Trust flag prepared for future use ✅
- Tracks last usage timestamp ✅

**C# Model Location:** `src/SilentID.Api/Models/AuthDevice.cs`

---

## 🔴 MISSING TABLES (11/14)

### 4. IdentityVerification Table - ❌ NOT CREATED

**Required by:** Phase 3, Section 8 (Database Schema)

**Expected Schema (from spec):**
```sql
CREATE TABLE "IdentityVerification" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "UserId" UUID NOT NULL REFERENCES "Users"("Id") ON DELETE CASCADE,
    "StripeVerificationId" VARCHAR(255) NOT NULL,
    "Status" INTEGER DEFAULT 0,  -- 0=Pending, 1=Verified, 2=Failed, 3=NeedsRetry
    "Level" INTEGER DEFAULT 0,   -- 0=Basic, 1=Enhanced
    "VerifiedAt" TIMESTAMP,
    "CreatedAt" TIMESTAMP NOT NULL,
    CONSTRAINT "FK_IdentityVerification_Users" FOREIGN KEY ("UserId") REFERENCES "Users"("Id")
);

CREATE UNIQUE INDEX "IX_IdentityVerification_UserId" ON "IdentityVerification"("UserId");
CREATE INDEX "IX_IdentityVerification_Status" ON "IdentityVerification"("Status");
```

**Status:** ❌ Missing
**Blocker:** Stripe Identity integration not started
**Impact:** Users cannot verify identity, TrustScore stuck at low values

---

### 5. ReceiptEvidence Table - ❌ NOT CREATED

**Required by:** Phase 5, Section 8 (Database Schema)

**Expected Schema (from spec):**
```sql
CREATE TABLE "ReceiptEvidence" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "UserId" UUID NOT NULL REFERENCES "Users"("Id") ON DELETE CASCADE,
    "Source" INTEGER DEFAULT 0,  -- 0=Gmail, 1=Outlook, 2=IMAP, 3=Forwarded
    "Platform" INTEGER,          -- 0=Vinted, 1=eBay, 2=Depop, etc.
    "RawHash" VARCHAR(255) NOT NULL,
    "OrderId" VARCHAR(255),
    "Item" VARCHAR(500),
    "Amount" DECIMAL(10,2),
    "Currency" VARCHAR(3) DEFAULT 'GBP',
    "Role" INTEGER,              -- 0=Buyer, 1=Seller
    "Date" TIMESTAMP NOT NULL,
    "IntegrityScore" INTEGER DEFAULT 100,
    "FraudFlag" BOOLEAN DEFAULT FALSE,
    "EvidenceState" INTEGER DEFAULT 0,  -- 0=Valid, 1=Suspicious, 2=Rejected
    "CreatedAt" TIMESTAMP NOT NULL,
    CONSTRAINT "FK_ReceiptEvidence_Users" FOREIGN KEY ("UserId") REFERENCES "Users"("Id")
);

CREATE INDEX "IX_ReceiptEvidence_UserId" ON "ReceiptEvidence"("UserId");
CREATE INDEX "IX_ReceiptEvidence_RawHash" ON "ReceiptEvidence"("RawHash");
```

**Status:** ❌ Missing
**Blocker:** Evidence system not started
**Impact:** Cannot parse email receipts, major TrustScore component missing

---

### 6. ScreenshotEvidence Table - ❌ NOT CREATED

**Required by:** Phase 5, Section 8 (Database Schema)

**Expected Schema (from spec):**
```sql
CREATE TABLE "ScreenshotEvidence" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "UserId" UUID NOT NULL REFERENCES "Users"("Id") ON DELETE CASCADE,
    "FileUrl" VARCHAR(500) NOT NULL,  -- Azure Blob Storage URL
    "Platform" INTEGER,
    "OCRText" TEXT,
    "IntegrityScore" INTEGER DEFAULT 100,
    "FraudFlag" BOOLEAN DEFAULT FALSE,
    "EvidenceState" INTEGER DEFAULT 0,
    "CreatedAt" TIMESTAMP NOT NULL,
    CONSTRAINT "FK_ScreenshotEvidence_Users" FOREIGN KEY ("UserId") REFERENCES "Users"("Id")
);

CREATE INDEX "IX_ScreenshotEvidence_UserId" ON "ScreenshotEvidence"("UserId");
CREATE INDEX "IX_ScreenshotEvidence_Platform" ON "ScreenshotEvidence"("Platform");
```

**Status:** ❌ Missing
**Blocker:** Azure Blob Storage + OCR not integrated
**Impact:** Users cannot upload screenshots for verification

---

### 7. ProfileLinkEvidence Table - ❌ NOT CREATED

**Required by:** Phase 5, Section 8 (Database Schema)

**Expected Schema (from spec):**
```sql
CREATE TABLE "ProfileLinkEvidence" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "UserId" UUID NOT NULL REFERENCES "Users"("Id") ON DELETE CASCADE,
    "URL" VARCHAR(500) NOT NULL,
    "Platform" INTEGER,
    "ScrapeDataJson" JSONB,
    "UsernameMatchScore" INTEGER DEFAULT 0,
    "IntegrityScore" INTEGER DEFAULT 100,
    "EvidenceState" INTEGER DEFAULT 0,
    "CreatedAt" TIMESTAMP NOT NULL,
    CONSTRAINT "FK_ProfileLinkEvidence_Users" FOREIGN KEY ("UserId") REFERENCES "Users"("Id")
);

CREATE INDEX "IX_ProfileLinkEvidence_UserId" ON "ProfileLinkEvidence"("UserId");
CREATE INDEX "IX_ProfileLinkEvidence_URL" ON "ProfileLinkEvidence"("URL");
```

**Status:** ❌ Missing
**Blocker:** Playwright scraper not implemented
**Impact:** Cannot scrape public profiles (Vinted, eBay, etc.)

---

### 8. MutualVerifications Table - ❌ NOT CREATED

**Required by:** Phase 5, Section 8 (Database Schema)

**Expected Schema (from spec):**
```sql
CREATE TABLE "MutualVerifications" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "UserAId" UUID NOT NULL REFERENCES "Users"("Id"),
    "UserBId" UUID NOT NULL REFERENCES "Users"("Id"),
    "Item" VARCHAR(500),
    "Amount" DECIMAL(10,2),
    "RoleA" INTEGER,  -- 0=Buyer, 1=Seller
    "RoleB" INTEGER,
    "Date" TIMESTAMP NOT NULL,
    "EvidenceId" UUID,
    "Status" INTEGER DEFAULT 0,  -- 0=Pending, 1=Confirmed, 2=Rejected, 3=Blocked
    "FraudFlag" BOOLEAN DEFAULT FALSE,
    "CreatedAt" TIMESTAMP NOT NULL,
    CONSTRAINT "FK_MutualVerifications_UserA" FOREIGN KEY ("UserAId") REFERENCES "Users"("Id"),
    CONSTRAINT "FK_MutualVerifications_UserB" FOREIGN KEY ("UserBId") REFERENCES "Users"("Id")
);

CREATE INDEX "IX_MutualVerifications_UserAId" ON "MutualVerifications"("UserAId");
CREATE INDEX "IX_MutualVerifications_UserBId" ON "MutualVerifications"("UserBId");
CREATE INDEX "IX_MutualVerifications_Status" ON "MutualVerifications"("Status");
```

**Status:** ❌ Missing
**Blocker:** Verification system not implemented
**Impact:** Peer verification component of TrustScore missing

---

### 9. TrustScoreSnapshots Table - ❌ NOT CREATED

**Required by:** Phase 6, Section 8 (Database Schema)

**Expected Schema (from spec):**
```sql
CREATE TABLE "TrustScoreSnapshots" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "UserId" UUID NOT NULL REFERENCES "Users"("Id") ON DELETE CASCADE,
    "Score" INTEGER NOT NULL DEFAULT 0,
    "IdentityScore" INTEGER DEFAULT 0,
    "EvidenceScore" INTEGER DEFAULT 0,
    "BehaviourScore" INTEGER DEFAULT 0,
    "PeerScore" INTEGER DEFAULT 0,
    "BreakdownJson" JSONB,
    "CreatedAt" TIMESTAMP NOT NULL,
    CONSTRAINT "FK_TrustScoreSnapshots_Users" FOREIGN KEY ("UserId") REFERENCES "Users"("Id")
);

CREATE INDEX "IX_TrustScoreSnapshots_UserId" ON "TrustScoreSnapshots"("UserId");
CREATE INDEX "IX_TrustScoreSnapshots_CreatedAt" ON "TrustScoreSnapshots"("CreatedAt");
```

**Status:** ❌ Missing
**Blocker:** TrustScore calculation engine not implemented
**Impact:** No TrustScore system (core feature)

---

### 10. RiskSignals Table - ❌ NOT CREATED

**Required by:** Phase 7, Section 8 (Database Schema)

**Expected Schema (from spec):**
```sql
CREATE TABLE "RiskSignals" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "UserId" UUID NOT NULL REFERENCES "Users"("Id") ON DELETE CASCADE,
    "Type" INTEGER,  -- 0=FakeReceipt, 1=FakeScreenshot, 2=Collusion, etc.
    "Severity" INTEGER DEFAULT 1,  -- 1-10 scale
    "Message" VARCHAR(500),
    "Metadata" JSONB,
    "CreatedAt" TIMESTAMP NOT NULL,
    CONSTRAINT "FK_RiskSignals_Users" FOREIGN KEY ("UserId") REFERENCES "Users"("Id")
);

CREATE INDEX "IX_RiskSignals_UserId" ON "RiskSignals"("UserId");
CREATE INDEX "IX_RiskSignals_Type" ON "RiskSignals"("Type");
CREATE INDEX "IX_RiskSignals_Severity" ON "RiskSignals"("Severity");
```

**Status:** ❌ Missing
**Blocker:** Risk engine not implemented
**Impact:** No anti-fraud tracking, cannot flag suspicious users

---

### 11. Reports Table - ❌ NOT CREATED

**Required by:** Phase 8, Section 8 (Database Schema)

**Expected Schema (from spec):**
```sql
CREATE TABLE "Reports" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "ReporterId" UUID NOT NULL REFERENCES "Users"("Id"),
    "ReportedUserId" UUID NOT NULL REFERENCES "Users"("Id"),
    "Category" INTEGER,  -- 0=ItemNotReceived, 1=AggressiveBehaviour, etc.
    "Description" TEXT,
    "Status" INTEGER DEFAULT 0,  -- 0=Pending, 1=UnderReview, 2=Verified, 3=Dismissed
    "CreatedAt" TIMESTAMP NOT NULL,
    CONSTRAINT "FK_Reports_Reporter" FOREIGN KEY ("ReporterId") REFERENCES "Users"("Id"),
    CONSTRAINT "FK_Reports_Reported" FOREIGN KEY ("ReportedUserId") REFERENCES "Users"("Id")
);

CREATE INDEX "IX_Reports_ReporterId" ON "Reports"("ReporterId");
CREATE INDEX "IX_Reports_ReportedUserId" ON "Reports"("ReportedUserId");
CREATE INDEX "IX_Reports_Status" ON "Reports"("Status");
```

**Status:** ❌ Missing
**Blocker:** Safety report system not implemented
**Impact:** Users cannot report safety concerns

---

### 12. ReportEvidence Table - ❌ NOT CREATED

**Required by:** Phase 8, Section 8 (Database Schema)

**Expected Schema (from spec):**
```sql
CREATE TABLE "ReportEvidence" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "ReportId" UUID NOT NULL REFERENCES "Reports"("Id") ON DELETE CASCADE,
    "FileUrl" VARCHAR(500) NOT NULL,
    "OCRText" TEXT,
    "CreatedAt" TIMESTAMP NOT NULL,
    CONSTRAINT "FK_ReportEvidence_Reports" FOREIGN KEY ("ReportId") REFERENCES "Reports"("Id")
);

CREATE INDEX "IX_ReportEvidence_ReportId" ON "ReportEvidence"("ReportId");
```

**Status:** ❌ Missing
**Blocker:** Reports table + Azure Blob not implemented
**Impact:** Cannot attach evidence to reports

---

### 13. Subscriptions Table - ❌ NOT CREATED

**Required by:** Phase 15, Section 8 (Database Schema)

**Expected Schema (from spec):**
```sql
CREATE TABLE "Subscriptions" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "UserId" UUID NOT NULL REFERENCES "Users"("Id") ON DELETE CASCADE,
    "Tier" INTEGER DEFAULT 0,  -- 0=Free, 1=Premium, 2=Pro
    "RenewalDate" TIMESTAMP,
    "CancelAt" TIMESTAMP,
    "CreatedAt" TIMESTAMP NOT NULL,
    CONSTRAINT "FK_Subscriptions_Users" FOREIGN KEY ("UserId") REFERENCES "Users"("Id")
);

CREATE UNIQUE INDEX "IX_Subscriptions_UserId" ON "Subscriptions"("UserId");
CREATE INDEX "IX_Subscriptions_Tier" ON "Subscriptions"("Tier");
```

**Status:** ❌ Missing
**Blocker:** Stripe Billing not integrated
**Impact:** Cannot manage Premium/Pro subscriptions

---

### 14. AdminAuditLogs Table - ❌ NOT CREATED

**Required by:** Phase 8 + Section 14 (Admin Dashboard)

**Expected Schema (from spec):**
```sql
CREATE TABLE "AdminAuditLogs" (
    "Id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    "AdminUser" VARCHAR(255) NOT NULL,
    "Action" VARCHAR(255) NOT NULL,
    "TargetUserId" UUID,
    "Details" JSONB,
    "CreatedAt" TIMESTAMP NOT NULL
);

CREATE INDEX "IX_AdminAuditLogs_AdminUser" ON "AdminAuditLogs"("AdminUser");
CREATE INDEX "IX_AdminAuditLogs_TargetUserId" ON "AdminAuditLogs"("TargetUserId");
CREATE INDEX "IX_AdminAuditLogs_CreatedAt" ON "AdminAuditLogs"("CreatedAt");
```

**Status:** ❌ Missing
**Blocker:** Admin system not implemented (+ Admin enum missing)
**Impact:** No admin action tracking, compliance risk

---

## 🔧 ENTITY FRAMEWORK CORE STATUS

### DbContext Configuration

**File:** `src/SilentID.Api/Data/SilentIdDbContext.cs`

**Current DbSets:**
```csharp
public DbSet<User> Users { get; set; }
public DbSet<Session> Sessions { get; set; }
public DbSet<AuthDevice> AuthDevices { get; set; }
```

**Missing DbSets (11):**
```csharp
public DbSet<IdentityVerification> IdentityVerifications { get; set; }
public DbSet<ReceiptEvidence> ReceiptEvidences { get; set; }
public DbSet<ScreenshotEvidence> ScreenshotEvidences { get; set; }
public DbSet<ProfileLinkEvidence> ProfileLinkEvidences { get; set; }
public DbSet<MutualVerification> MutualVerifications { get; set; }
public DbSet<TrustScoreSnapshot> TrustScoreSnapshots { get; set; }
public DbSet<RiskSignal> RiskSignals { get; set; }
public DbSet<Report> Reports { get; set; }
public DbSet<ReportEvidence> ReportEvidences { get; set; }
public DbSet<Subscription> Subscriptions { get; set; }
public DbSet<AdminAuditLog> AdminAuditLogs { get; set; }
```

### Migration History

**Applied Migrations (2):**
1. `20251121135028_InitialCreate` - Users, Sessions, AuthDevices tables
2. `20251121140300_AddOAuthProviderIds` - AppleUserId, GoogleUserId columns

**Pending Migrations:** 0 (database up to date with code)

**Future Migrations Needed:**
1. AddAdminAccountType (⚠️ CRITICAL - Admin enum missing)
2. AddIdentityVerificationTable
3. AddEvidenceTables (Receipts, Screenshots, ProfileLinks)
4. AddMutualVerificationsTable
5. AddTrustScoreTables
6. AddRiskSignalsTable
7. AddReportsTables
8. AddSubscriptionsTable
9. AddAdminAuditLogsTable

---

## 🚨 CRITICAL DATABASE ISSUES

### 🔴 Issue #1: Admin Enum Value Missing

**Problem:**
```csharp
// Current AccountType enum
public enum AccountType
{
    Free,      // 0
    Premium,   // 1
    Pro        // 2
    // ❌ Admin is MISSING
}
```

**Impact:**
- Cannot set user as admin
- Admin dashboard cannot be built (Section 14)
- Admin endpoints will fail authorization

**Fix Required:**
```csharp
public enum AccountType
{
    Free,      // 0
    Premium,   // 1
    Pro,       // 2
    Admin      // 3 - ADD THIS
}
```

**Migration Command:**
```bash
cd C:/SILENTID/src/SilentID.Api
dotnet ef migrations add AddAdminAccountType
dotnet ef database update
```

**Estimated Fix Time:** 5 minutes

---

### 🟡 Issue #2: No Data Encryption

**Problem:**
- Sensitive fields stored as plaintext:
  - SignupIP (user IP addresses)
  - SignupDeviceId (device fingerprints)
  - Email (personal data)

**Spec Requirement (Section 8):**
> "Certain fields encrypted (email, IP, device ID)"

**Current Status:** ❌ NOT IMPLEMENTED

**Fix Required:**
- Implement column-level encryption in EF Core
- Or use database-level encryption (Azure SQL TDE)

**Estimated Fix Time:** 2-3 hours

---

### 🟡 Issue #3: No Soft Delete

**Problem:**
- DELETE operations are hard deletes
- No "IsDeleted" flag anywhere

**Spec Requirement (Section 8):**
> "GDPR-compliant soft-delete"

**Current Status:** ❌ NOT IMPLEMENTED

**Fix Required:**
- Add `IsDeleted` and `DeletedAt` columns to all tables
- Override `SaveChanges` to soft-delete instead of hard-delete
- Add global query filters to exclude soft-deleted records

**Estimated Fix Time:** 1-2 hours

---

## 📊 DATABASE SIZE & PERFORMANCE

### Current Database Size
```
silentid_dev database:
- Tables: 3
- Rows: ~0-10 (test data only)
- Size: <1 MB
```

### Index Strategy

**Existing Indexes (7):**
```sql
-- Users
IX_Users_Email (UNIQUE)
IX_Users_Username (UNIQUE)

-- Sessions
IX_Sessions_UserId
IX_Sessions_RefreshTokenHash

-- AuthDevices
IX_AuthDevices_UserId
IX_AuthDevices_DeviceId
```

**Status:** ✅ Appropriate for current tables

**Future Index Needs:**
- Evidence tables: UserId, Platform, CreatedAt
- TrustScore: UserId, Score, CreatedAt
- RiskSignals: UserId, Severity, Type
- Reports: ReporterId, ReportedUserId, Status

---

## 🎯 DATABASE IMPLEMENTATION ROADMAP

### Priority 1: Fix Admin Enum (5 minutes) ⚠️ URGENT
```bash
1. Edit User.cs - add Admin to AccountType
2. dotnet ef migrations add AddAdminAccountType
3. dotnet ef database update
```

### Priority 2: Stripe Identity Table (30 minutes)
```bash
1. Create IdentityVerification.cs model
2. Add DbSet to DbContext
3. dotnet ef migrations add AddIdentityVerificationTable
4. dotnet ef database update
```

### Priority 3: Evidence Tables (1 hour)
```bash
1. Create ReceiptEvidence.cs
2. Create ScreenshotEvidence.cs
3. Create ProfileLinkEvidence.cs
4. Add DbSets to DbContext
5. dotnet ef migrations add AddEvidenceTables
6. dotnet ef database update
```

### Priority 4: TrustScore Tables (30 minutes)
```bash
1. Create TrustScoreSnapshot.cs
2. Create MutualVerification.cs
3. Add DbSets to DbContext
4. dotnet ef migrations add AddTrustScoreTables
5. dotnet ef database update
```

### Priority 5: Risk & Safety Tables (45 minutes)
```bash
1. Create RiskSignal.cs
2. Create Report.cs
3. Create ReportEvidence.cs
4. Add DbSets to DbContext
5. dotnet ef migrations add AddRiskAndSafetyTables
6. dotnet ef database update
```

### Priority 6: Business Tables (30 minutes)
```bash
1. Create Subscription.cs
2. Create AdminAuditLog.cs
3. Add DbSets to DbContext
4. dotnet ef migrations add AddBusinessTables
5. dotnet ef database update
```

### Priority 7: Add Encryption & Soft Delete (2-3 hours)
```bash
1. Implement soft delete infrastructure
2. Add encryption for sensitive fields
3. Update all migrations
```

---

## 📋 POSTGRESQL SPECIFIC NOTES

### PostgreSQL Version
- Recommended: PostgreSQL 15+
- Current dev connection: localhost:5432

### PostgreSQL Features Used
- ✅ UUID primary keys (`gen_random_uuid()`)
- ✅ JSONB columns (prepared for future use)
- ✅ Timestamps with timezone
- ✅ Indexes on foreign keys
- ✅ Unique constraints

### PostgreSQL Features Not Yet Used
- ❌ Full-text search (could use for username/email search)
- ❌ Partitioning (not needed yet, but useful for logs later)
- ❌ Triggers (could use for auto-updating UpdatedAt)
- ❌ Row-level security (could use for multi-tenancy)

---

## ✅ DATABASE BEST PRACTICES COMPLIANCE

### ✅ Good Practices Followed
1. UUID primary keys ✅
2. Unique constraints on email/username ✅
3. Foreign key relationships with cascade ✅
4. Indexes on frequently queried columns ✅
5. Timestamp tracking (CreatedAt, UpdatedAt) ✅
6. Enum values stored as integers ✅
7. Nullable columns marked appropriately ✅

### ⚠️ Missing Best Practices
1. No soft delete ❌
2. No data encryption ❌
3. No UpdatedAt auto-update trigger ❌
4. No row versioning (concurrency) ❌
5. No audit triggers ❌

---

**END OF DATABASE SCHEMA STATUS REPORT**
