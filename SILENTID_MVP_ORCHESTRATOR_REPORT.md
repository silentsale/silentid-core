# SILENTID MVP ORCHESTRATOR — UNIFIED DIAGNOSIS & PLANNING REPORT

**Generated:** 2025-11-24
**Analysis Scope:** Complete SilentID MVP vs CLAUDE.md Section 47 (Digital Trust Passport)
**Status:** ⚠️ CRITICAL CONFLICTS DETECTED — IMMEDIATE ACTION REQUIRED

---

## 1. MCP_STATUS

### MCP Server Health Check
- **puppeteer-console**: ✅ CONNECTED
- **code-index**: ❌ NOT AVAILABLE
- **context7**: ❌ NOT AVAILABLE
- **sequential-thinking**: ❌ NOT AVAILABLE

### Required Actions
⚠️ **BLOCKER:** Limited MCP connectivity. Only puppeteer console server active.
**Recommendation:** Reconnect all MCP servers before proceeding with implementation tasks.

---

## 2. MVP_FEATURE_CHECKLIST (from CLAUDE.md)

### Section 47 Requirements Extracted:

#### 47.1 Purpose
- [ ] Digital Trust Passport system
- [ ] Public profile showing verified marketplace star ratings
- [ ] TrustScore (0-1000) must be PRIVATE (never shown publicly)

#### 47.2 Public vs Private Information
- [ ] Public: Star ratings from platforms (Vinted, eBay, Depop)
- [ ] Public: Account age, platform count
- [ ] Public: Level 3 verification badges
- [ ] Private: TrustScore (0-1000)
- [ ] Private: URS (Unified Reputation Score)
- [ ] Private: Evidence Vault (receipts, screenshots)

#### 47.3 Level 3 Profile Verification
- [ ] **Method A: Token-in-Bio** (for platforms like Vinted, eBay, Depop)
  - [ ] Generate unique verification token: `SILENTID-VERIFY-{random-8-chars}`
  - [ ] User adds token to profile bio
  - [ ] SilentID scrapes profile via Playwright MCP
  - [ ] Check for exact token match
  - [ ] Lock ownership (one profile = one SilentID account)
  - [ ] Store snapshot hash (SHA-256)
  - [ ] Re-verify every 90 days

- [ ] **Method B: Share-Intent Verification** (for Instagram, TikTok, X/Twitter)
  - [ ] Generate verification link: `https://silentid.co.uk/verify/{token}`
  - [ ] User taps Share button → Copy Link
  - [ ] Validate within 5 minutes
  - [ ] Check device fingerprint consistency

- [ ] **Verification Levels Comparison:**
  - [ ] Level 1: URL submission only (low security, base profile weight)
  - [ ] Level 2: Username cross-check (medium security, +10% profile weight)
  - [ ] Level 3: Token-in-Bio or Share-Intent (high security, +50% profile weight + URS eligibility)

#### 47.4 URS: Universal Reputation Score
- [ ] Extract platform ratings from Level 3 verified profiles
- [ ] Normalize ratings to common scale (0-100%)
- [ ] Weight by review count & account age
- [ ] Calculate weighted average
- [ ] Convert to 0-200 point scale
- [ ] Anti-fraud URS rules:
  - [ ] Consistency check (variance > 20% = flag)
  - [ ] Freshness requirement (ratings >180 days = 50% weight reduction)
  - [ ] Minimum threshold (≥10 reviews, ≥3 months old)
  - [ ] Cap per platform (max 3 profiles per platform type)

#### 47.5 TrustScore Privacy Rules
- [ ] TrustScore MUST be private (never shown publicly)
- [ ] Only user sees TrustScore in private dashboard
- [ ] Public profile shows ONLY star ratings from platforms
- [ ] No "High Trust" labels derived from TrustScore on public profiles

#### 47.6 Email Receipt Model Update (Expensify Model)
- [ ] Unique forwarding alias per user: `{userId}.{random}@receipts.silentid.co.uk`
- [ ] User creates email forwarding rule in their email client
- [ ] SilentID receives forwarded receipt
- [ ] Extract metadata ONLY (date, platform, amount, order ID)
- [ ] Immediately delete raw email after extraction
- [ ] Store summary only (JSON metadata)

#### 47.7 Database Schema Updates
- [ ] **ProfileLinkEvidence** new fields:
  - [ ] `VerificationLevel` INT (1, 2, or 3)
  - [ ] `VerificationMethod` VARCHAR(50) ('TokenInBio', 'ShareIntent', 'None')
  - [ ] `VerificationToken` VARCHAR(100)
  - [ ] `OwnershipLockedAt` TIMESTAMP
  - [ ] `SnapshotHash` VARCHAR(64) (SHA-256)
  - [ ] `NextReverifyAt` TIMESTAMP (90 days from verification)

- [ ] **New Table: ExternalRatings**
  - [ ] `Id` UUID PRIMARY KEY
  - [ ] `ProfileLinkId` UUID REFERENCES ProfileLinkEvidence(Id)
  - [ ] `UserId` UUID REFERENCES Users(Id)
  - [ ] `Platform` VARCHAR(50) (Vinted, eBay, Depop, Etsy)
  - [ ] `PlatformRating` DECIMAL(5,2) (raw rating from platform)
  - [ ] `ReviewCount` INT
  - [ ] `AccountAge` INT (in days)
  - [ ] `NormalizedRating` DECIMAL(5,2) (0-100 scale)
  - [ ] `ReviewCountWeight` DECIMAL(3,2)
  - [ ] `AccountAgeWeight` DECIMAL(3,2)
  - [ ] `CombinedWeight` DECIMAL(3,2)
  - [ ] `WeightedScore` DECIMAL(6,2)
  - [ ] `ScrapedAt` TIMESTAMP
  - [ ] `ExpiresAt` TIMESTAMP (180 days from scrape)
  - [ ] `CreatedAt` TIMESTAMP

- [ ] **ReceiptEvidence** new fields:
  - [ ] `ForwardingAlias` VARCHAR(255) UNIQUE
  - [ ] `EmailMetadataJson` JSONB (NOT full email)
  - [ ] `RawEmailDeleted` BOOLEAN DEFAULT TRUE

#### 47.8 Digital Trust Passport UI Design
- [ ] Header: "Digital Trust Passport"
- [ ] Subheader: "Verified Reputation from {Platform Count} Platforms"
- [ ] Star ratings section:
  - [ ] Display each platform's stars visually (★★★★★)
  - [ ] Show exact rating: "4.8 out of 5.0"
  - [ ] Show review count: "(342 reviews)"
  - [ ] Show account age: "Member since March 2023"
  - [ ] Show freshness: "Last updated: 2 days ago"
- [ ] QR code section: "Scan My Trust Passport"
- [ ] Footer: "TrustScore is private. Only verified star ratings shown."
- [ ] NO TrustScore display on public profile

#### 47.9 Edge Case Handling
- [ ] **Account Hacks Detection:**
  - [ ] Monitor sudden rating drops (>1.0 stars in 24h)
  - [ ] Monitor review deletions (>50% reviews lost in 7 days)
  - [ ] Trigger grace period (7-14 days, stars shown with warning)
  - [ ] User can appeal via Help Center

- [ ] **Platform Account Suspensions:**
  - [ ] Grace period when profile becomes inaccessible
  - [ ] Stars shown with warning: "⚠️ Unable to verify"
  - [ ] After 30 days, verification drops to Level 1
  - [ ] User must re-verify or profile removed

- [ ] **Shared Devices / Household:**
  - [ ] Detect multiple SilentID accounts from same IP/device
  - [ ] Allow legitimate multi-account households
  - [ ] Whitelist specific device/IP combinations
  - [ ] Flag suspicious patterns (bulk signups, circular verifications)

- [ ] **HTML Scraping Failures:**
  - [ ] Retry with exponential backoff (3 attempts)
  - [ ] Fallback to cached snapshot (if <30 days old)
  - [ ] Show "Unable to refresh" warning
  - [ ] Request user to manually re-verify

#### 47.10 Anti-Fraud Rules
- [ ] Only Level 3 verified profiles contribute to URS
- [ ] Level 1/2 profiles contribute to Evidence component only (limited weight)
- [ ] If user attempts to verify profile already owned by another account → flag for admin review
- [ ] Bulk profile submissions (>5 in 24h) → suspicious activity flag

---

## 3. MVP_STATUS_MATRIX

### ✅ DONE (Fully Implemented & Working)

| Feature | Location | Status |
|---------|----------|--------|
| Basic account creation | AuthController.cs | ✅ DONE |
| Passwordless auth (Email OTP) | AuthController.cs | ✅ DONE |
| Stripe Identity verification | StripeIdentityService.cs | ✅ DONE |
| Public profile URL structure | PublicController.cs (line 205) | ✅ DONE |
| QR code generation | share_profile_sheet.dart (line 93) | ✅ DONE |
| Basic TrustScore calculation (4 components) | TrustScoreService.cs | ✅ DONE |
| Evidence upload (receipts, screenshots, profile links) | EvidenceController.cs | ✅ DONE |
| Mutual verification | MutualVerificationService.cs | ✅ DONE |
| Safety reports | ReportService.cs | ✅ DONE |
| Subscriptions (Free, Premium, Pro) | SubscriptionsController.cs | ✅ DONE |

---

### ⚠️ PARTIAL (Started but Incomplete/Incorrect)

| Feature | Location | Issue | Fix Required |
|---------|----------|-------|--------------|
| Public profile display | PublicController.cs (line 41, 209) | 🔴 **Shows TrustScore publicly** | Remove TrustScore from PublicProfileDto |
| Public profile UI | public_profile_viewer_screen.dart (lines 257-304) | 🔴 **Displays TrustScore prominently** | Replace with star ratings display |
| Identity verification levels | IdentityVerification.cs (line 69-73) | Only Basic/Enhanced, no Level 3 | Add Level 3 with Token-in-Bio/Share-Intent |
| Profile linking | ProfileLinkEvidence.cs | No Level 3 verification fields | Add VerificationLevel, VerificationMethod, VerificationToken, etc. |
| Evidence breakdown | TrustScoreService.cs (line 204-260) | Only counts evidence, no star ratings | Add URS calculation |
| TrustScore calculation | TrustScoreService.cs (line 84-86) | 4-component system (max 1000) | Update to 5-component system with URS (max 1200, normalized to 1000) |

---

### ❌ NOT STARTED (Missing Entirely)

| Feature | Required By | Priority | Estimated Effort |
|---------|-------------|----------|------------------|
| **Level 3 Profile Verification (Token-in-Bio)** | Section 47.3 | 🔴 CRITICAL | HIGH (3-5 days) |
| **Level 3 Profile Verification (Share-Intent)** | Section 47.3 | 🔴 CRITICAL | HIGH (3-5 days) |
| **URS (Unified Reputation Score) Calculation** | Section 47.4 | 🔴 CRITICAL | MEDIUM (2-3 days) |
| **ExternalRatings Table/Model** | Section 47.7 | 🔴 CRITICAL | LOW (1 day) |
| **Email Receipt Forwarding (Expensify Model)** | Section 47.6 | 🔴 CRITICAL | HIGH (4-6 days) |
| **Star Rating Scraping & Refresh System** | Section 47.4 | 🔴 CRITICAL | HIGH (4-6 days) |
| **Anomaly Detection (Account Hacks, Rating Drops)** | Section 47.9 | 🟡 IMPORTANT | MEDIUM (2-3 days) |
| **Grace Period Logic (Platform Suspensions)** | Section 47.9 | 🟡 IMPORTANT | LOW (1-2 days) |
| **Household/Shared Device Handling** | Section 47.9 | 🟡 IMPORTANT | MEDIUM (2-3 days) |
| **Digital Trust Passport UI (Section 47.8 Design)** | Section 47.8 | 🔴 CRITICAL | MEDIUM (3-4 days) |
| **Anti-Fraud URS Rules** | Section 47.10 | 🟡 IMPORTANT | LOW (1-2 days) |

---

## 4. GAP_ANALYSIS — Spec vs Reality

### 🔴 CRITICAL CONFLICTS (Must Fix Immediately)

#### **Conflict #1: TrustScore Exposed Publicly**
- **CLAUDE.md Section 47.5 (lines 10399-10414):** *"TrustScore (0-1000): Internal calculation, user sees it in private dashboard... NEVER shown on public profile."*
- **Current Reality:**
  - `PublicController.cs` line 41: `PublicProfileDto` includes `TrustScore` field
  - `PublicController.cs` line 209: Returns `TrustScore` in public endpoint
  - `public_profile_viewer_screen.dart` lines 257-304: Displays TrustScore prominently with purple gradient card

**Impact:** 🔴 VIOLATES core privacy requirement. Public users should NEVER see TrustScore.

**Fix Required:**
- Remove `TrustScore` and `TrustScoreLabel` fields from `PublicProfileDto`
- Update `GET /v1/public/profile/{username}` to return ONLY star ratings from platforms
- Rewrite `public_profile_viewer_screen.dart` to display star ratings instead of TrustScore
- Add footer text: "TrustScore is private. Only verified star ratings shown."

---

#### **Conflict #2: Wrong TrustScore Formula (4 Components vs 5 Components)**
- **CLAUDE.md Section 47 v1.8.0:** *"TrustScore uses 5 components: Identity (200) + Evidence (300) + Behaviour (300) + Peer (200) + URS (200) = raw max 1200, normalized to 1000"*
- **Current Reality:**
  - `TrustScoreService.cs` lines 78-86: Only 4 components (Identity + Evidence + Behaviour + Peer)
  - Max score is 1000 (200+300+300+200), not 1200
  - No URS calculation found anywhere

**Impact:** 🔴 TrustScore calculation is incomplete. Missing entire URS component.

**Fix Required:**
- Add URS calculation to `TrustScoreService.cs`
- Add `UrsScore` field to `TrustScoreSnapshot` model
- Update formula: `Raw Score = Identity + Evidence + Behaviour + Peer + URS` (max 1200)
- Normalize: `Final TrustScore = (Raw Score / 1200) × 1000`
- Update breakdown JSON to include URS component

---

#### **Conflict #3: No Level 3 Verification System**
- **CLAUDE.md Section 47.3:** *"Level 3 verification required for star display. Two methods: Token-in-Bio and Share-Intent."*
- **Current Reality:**
  - `IdentityVerification.cs` lines 69-73: Only `Basic` and `Enhanced` levels
  - No Token-in-Bio generation logic
  - No Share-Intent validation logic
  - `ProfileLinkEvidence.cs` has no verification level fields

**Impact:** 🔴 Cannot implement Digital Trust Passport without Level 3 verification.

**Fix Required:**
- Add `Level3` to `VerificationLevel` enum
- Add new fields to `ProfileLinkEvidence`:
  - `VerificationLevel` (INT: 1, 2, 3)
  - `VerificationMethod` (VARCHAR: 'TokenInBio', 'ShareIntent', 'None')
  - `VerificationToken` (VARCHAR: token string)
  - `OwnershipLockedAt` (TIMESTAMP)
  - `SnapshotHash` (VARCHAR: SHA-256 of profile snapshot)
  - `NextReverifyAt` (TIMESTAMP: 90 days from verification)
- Implement token generation endpoint: `POST /v1/evidence/profile-links/{id}/verify-token`
- Implement verification check endpoint: `POST /v1/evidence/profile-links/{id}/confirm-verification`
- Integrate Playwright MCP for profile scraping

---

#### **Conflict #4: No Star Rating Display on Public Profiles**
- **CLAUDE.md Section 47.8:** *"Digital Trust Passport shows verified star ratings from platforms (Vinted 4.8★, eBay 99% positive, etc.)"*
- **Current Reality:**
  - Public profile shows TrustScore (wrong)
  - No star ratings displayed
  - No platform-specific rating data shown

**Impact:** 🔴 Public profile UI completely wrong. Must show stars, not TrustScore.

**Fix Required:**
- Create `ExternalRatings` table/model (see Section 47.7 schema)
- Implement star rating scraping service
- Update `PublicProfileDto` to include:
  - `List<PlatformRating>` (platform name, star rating, review count, account age, last updated)
- Rewrite `public_profile_viewer_screen.dart`:
  - Remove TrustScore display
  - Add "Digital Trust Passport" header
  - Display each platform's stars visually (★★★★★)
  - Show exact ratings: "4.8 out of 5.0 (342 reviews)"
  - Show freshness: "Last updated: 2 days ago"

---

### 🟡 IMPORTANT GAPS (High Priority, Non-Blocking)

#### **Gap #1: Email Receipt Forwarding (Expensify Model)**
- **CLAUDE.md Section 47.6:** *"User forwards receipts to unique alias: {userId}.{random}@receipts.silentid.co.uk"*
- **Current Reality:** No email forwarding system. No `receipts.silentid.co.uk` subdomain.

**Impact:** Users cannot automatically sync marketplace receipts. Manual upload only.

**Fix Required:**
- Set up `receipts.silentid.co.uk` subdomain with email receiving
- Generate unique forwarding alias per user
- Implement email parsing service (extract date, platform, amount, order ID)
- Store metadata only (JSON), delete raw email immediately
- Add UI instructions: "Forward marketplace receipts to your unique address"

---

#### **Gap #2: Anomaly Detection (Account Hacks, Rating Drops)**
- **CLAUDE.md Section 47.9:** *"Monitor sudden rating drops (>1.0 stars in 24h), review deletions (>50% in 7 days)"*
- **Current Reality:** No anomaly detection logic found.

**Impact:** Cannot detect when user's marketplace account is hacked or suspended.

**Fix Required:**
- Implement `AnomalyDetectionService` to monitor:
  - Sudden rating drops (>1.0 stars in 24h)
  - Review deletions (>50% reviews lost in 7 days)
  - Profile access failures (404, suspended accounts)
- Trigger grace period (7-14 days) when anomaly detected
- Show warning on public profile: "⚠️ Unable to verify - grace period active"
- Send notification to user: "Your Vinted rating dropped suddenly. Please review."

---

#### **Gap #3: Grace Period Logic for Platform Suspensions**
- **CLAUDE.md Section 47.9:** *"If platform profile becomes inaccessible, grant 7-14 day grace period"*
- **Current Reality:** No grace period system.

**Impact:** Legitimate users may lose stars due to temporary platform issues.

**Fix Required:**
- Add `GracePeriodActive` BOOLEAN and `GracePeriodEndsAt` TIMESTAMP to `ExternalRatings` table
- When scraping fails (404, suspended): activate grace period
- During grace period: show stars with warning: "⚠️ Unable to verify"
- After grace period expires: drop verification to Level 1, remove stars from public display

---

#### **Gap #4: Household/Shared Device Handling**
- **CLAUDE.md Section 47.9:** *"Allow legitimate multi-account households, flag suspicious patterns"*
- **Current Reality:** Anti-duplicate system may block legitimate family members.

**Impact:** False positives when multiple family members use SilentID from same device.

**Fix Required:**
- Implement `HouseholdWhitelist` table to store approved device/IP combinations
- Add admin endpoint: `POST /v1/admin/users/{id}/whitelist-device`
- Modify duplicate detection to skip whitelisted devices
- Flag for admin review when:
  - >3 accounts from same device/IP
  - Circular mutual verifications between same-device accounts
  - Bulk signups (>5 accounts in 24h from same IP)

---

### 🟢 MINOR GAPS (Low Priority, Quality-of-Life)

#### **Gap #5: Digital Trust Passport UI Polish**
- **CLAUDE.md Section 47.8:** Detailed visual design specs (header, star icons, freshness indicators, QR code styling)
- **Current Reality:** UI exists but doesn't match design specs.

**Impact:** Visual inconsistency, less "passport-like" feel.

**Fix Required:**
- Update `public_profile_viewer_screen.dart` to match Section 47.8 design exactly
- Add "Digital Trust Passport" header with icon
- Use star icons (★) instead of text ratings
- Add freshness indicators: "Last updated: X days ago"
- Style QR code section per spec

---

## 5. REQUIRED_UI_UPDATES (Flutter)

### 🔴 CRITICAL (Must Fix Before Public Launch)

#### **File:** `silentid_app/lib/features/profile/screens/public_profile_viewer_screen.dart`

**Lines 257-304: Remove TrustScore Display**
```dart
// ❌ CURRENT (WRONG):
Container(
  padding: const EdgeInsets.all(AppSpacing.lg),
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppTheme.primaryPurple, AppTheme.darkModePurple],
    ),
  ),
  child: Column(
    children: [
      Text('TrustScore', // ❌ REMOVE THIS
        style: GoogleFonts.inter(fontSize: 16, color: AppTheme.pureWhite.withValues(alpha: 0.9)),
      ),
      Text('${profile.trustScore}', // ❌ REMOVE THIS
        style: GoogleFonts.inter(fontSize: 64, fontWeight: FontWeight.bold, color: AppTheme.pureWhite),
      ),
    ],
  ),
)
```

**Replace with:**
```dart
// ✅ NEW (CORRECT):
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Header
    Row(
      children: [
        Icon(Icons.verified_user, color: AppTheme.primaryPurple, size: 32),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Digital Trust Passport',
                style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('Verified Reputation from ${platformCount} Platforms',
                style: GoogleFonts.inter(fontSize: 14, color: AppTheme.neutralGray700),
              ),
            ],
          ),
        ),
      ],
    ),
    SizedBox(height: 24),

    // Star Ratings Section
    ...profile.platformRatings.map((rating) => PlatformRatingCard(
      platform: rating.platform,
      stars: rating.rating,
      reviewCount: rating.reviewCount,
      accountAge: rating.accountAge,
      lastUpdated: rating.lastUpdated,
    )),

    // Footer
    SizedBox(height: 16),
    Text('TrustScore is private. Only verified star ratings shown.',
      style: GoogleFonts.inter(fontSize: 12, color: AppTheme.neutralGray700),
      textAlign: TextAlign.center,
    ),
  ],
)
```

---

**Create New Widget:** `PlatformRatingCard`
```dart
// silentid_app/lib/features/profile/widgets/platform_rating_card.dart
class PlatformRatingCard extends StatelessWidget {
  final String platform; // "Vinted", "eBay", "Depop"
  final double stars; // 4.8
  final int reviewCount; // 342
  final String accountAge; // "Member since March 2023"
  final String lastUpdated; // "Last updated: 2 days ago"

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Platform name + logo
          Row(
            children: [
              PlatformLogo(platform: platform), // TODO: Add platform logos
              SizedBox(width: 8),
              Text(platform, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.semibold)),
            ],
          ),
          SizedBox(height: 8),

          // Star display
          Row(
            children: [
              ...List.generate(5, (index) => Icon(
                index < stars.floor() ? Icons.star : (index < stars.ceil() ? Icons.star_half : Icons.star_border),
                color: AppTheme.warningAmber,
                size: 20,
              )),
              SizedBox(width: 8),
              Text('$stars out of 5.0', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.medium)),
            ],
          ),
          SizedBox(height: 4),

          // Review count
          Text('($reviewCount reviews)', style: GoogleFonts.inter(fontSize: 12, color: AppTheme.neutralGray700)),
          SizedBox(height: 4),

          // Account age
          Text(accountAge, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.neutralGray700)),
          SizedBox(height: 4),

          // Freshness
          Text(lastUpdated, style: GoogleFonts.inter(fontSize: 11, color: AppTheme.neutralGray700, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
```

---

#### **File:** `silentid_app/lib/models/public_profile.dart`

**Update Model to Match New Backend Response**
```dart
// ❌ REMOVE:
int trustScore;
String trustScoreLabel;

// ✅ ADD:
List<PlatformRating> platformRatings;

class PlatformRating {
  final String platform; // "Vinted", "eBay", "Depop"
  final double rating; // 4.8
  final int reviewCount; // 342
  final String accountAge; // "Member since March 2023"
  final DateTime lastUpdated;
  final String freshness; // "Last updated: 2 days ago"
}
```

---

#### **File:** `silentid_app/lib/services/public_profile_service.dart`

**Update API Call to Use New Endpoint**
```dart
Future<PublicProfile> getPublicProfile(String username) async {
  final response = await _dio.get('/v1/public/profile/$username');

  // Parse new response format with platformRatings instead of trustScore
  return PublicProfile.fromJson(response.data);
}
```

---

### 🟡 IMPORTANT (Should Fix Soon)

#### **New Screen:** `level_3_verification_screen.dart`
- Purpose: Guide user through Token-in-Bio or Share-Intent verification
- Steps:
  1. Select platform (Vinted, eBay, Depop, etc.)
  2. Choose verification method (Token-in-Bio or Share-Intent)
  3. Display verification token/link
  4. Instructions: "Add this token to your profile bio" or "Tap Share and copy link"
  5. Confirm button: "I've added the token" or "I've shared the link"
  6. Poll backend for verification status (every 5 seconds, max 2 minutes)
  7. Show success: "✅ Profile verified! Your stars will appear within 24 hours."

---

#### **New Widget:** `email_forwarding_setup_widget.dart`
- Purpose: Guide user to set up email receipt forwarding
- Display unique forwarding address: `{userId}.{random}@receipts.silentid.co.uk`
- Instructions:
  1. "Go to your email settings"
  2. "Create a forwarding rule for marketplace emails"
  3. "Forward to your unique SilentID address"
- Link to help article: "How to Set Up Email Forwarding"

---

## 6. REQUIRED_BACKEND_UPDATES (ASP.NET Core)

### 🔴 CRITICAL (Must Fix Before Public Launch)

#### **File:** `src/SilentID.Api/Controllers/PublicController.cs`

**Lines 38-51: Update PublicProfileDto**
```csharp
// ❌ REMOVE:
public int TrustScore { get; set; }
public string TrustScoreLabel { get; set; } = string.Empty;

// ✅ ADD:
public List<PlatformRatingDto> PlatformRatings { get; set; } = new();

public class PlatformRatingDto
{
    public string Platform { get; set; } = string.Empty; // "Vinted", "eBay", "Depop"
    public decimal Rating { get; set; } // 4.8
    public int ReviewCount { get; set; } // 342
    public string AccountAge { get; set; } = string.Empty; // "Member since March 2023"
    public DateTime LastUpdated { get; set; }
    public string Freshness { get; set; } = string.Empty; // "Last updated: 2 days ago"
}
```

**Lines 205-220: Update GetPublicProfile Method**
```csharp
[HttpGet("{username}")]
public async Task<ActionResult<PublicProfileDto>> GetPublicProfile(string username)
{
    // Remove @ prefix if present
    username = username.TrimStart('@');

    var user = await _context.Users
        .FirstOrDefaultAsync(u => u.Username == username && u.AccountStatus == AccountStatus.Active);

    if (user == null)
    {
        return NotFound(new { error = "profile_not_found", message = "This profile does not exist." });
    }

    // ❌ REMOVE: Get TrustScore
    // var trustScore = await _trustScoreService.GetCurrentTrustScoreAsync(user.Id);

    // ✅ ADD: Get platform ratings from ExternalRatings table
    var platformRatings = await _context.ExternalRatings
        .Where(r => r.UserId == user.Id && r.ExpiresAt > DateTime.UtcNow)
        .OrderByDescending(r => r.ScrapedAt)
        .Select(r => new PlatformRatingDto
        {
            Platform = r.Platform,
            Rating = r.PlatformRating,
            ReviewCount = r.ReviewCount,
            AccountAge = CalculateAccountAge(r.AccountAge),
            LastUpdated = r.ScrapedAt,
            Freshness = CalculateFreshness(r.ScrapedAt)
        })
        .ToListAsync();

    var profile = new PublicProfileDto
    {
        Username = $"@{user.Username}",
        DisplayName = user.DisplayName,
        // ❌ REMOVE: TrustScore = trustScore.Score,
        // ❌ REMOVE: TrustScoreLabel = GetTrustLabel(trustScore.Score),
        PlatformRatings = platformRatings, // ✅ ADD
        // ... rest of fields
    };

    return Ok(profile);
}

// ✅ ADD Helper Methods:
private string CalculateAccountAge(int accountAgeDays)
{
    var years = accountAgeDays / 365;
    if (years >= 1)
        return $"Member since {DateTime.UtcNow.AddDays(-accountAgeDays):MMMM yyyy}";
    return "New member";
}

private string CalculateFreshness(DateTime scrapedAt)
{
    var elapsed = DateTime.UtcNow - scrapedAt;
    if (elapsed.TotalHours < 24)
        return $"Last updated: {elapsed.TotalHours:F0} hours ago";
    if (elapsed.TotalDays < 30)
        return $"Last updated: {elapsed.TotalDays:F0} days ago";
    return "Last updated: Over 30 days ago";
}
```

---

#### **File:** `src/SilentID.Api/Models/ProfileLinkEvidence.cs`

**Add New Fields for Level 3 Verification**
```csharp
// ✅ ADD (after line 32):
/// <summary>
/// Verification level completed (1, 2, or 3).
/// Level 1: URL submission only
/// Level 2: Username cross-check
/// Level 3: Token-in-Bio or Share-Intent (cryptographic proof)
/// </summary>
public int VerificationLevel { get; set; } = 1;

/// <summary>
/// Verification method used for Level 3.
/// </summary>
public string? VerificationMethod { get; set; } // "TokenInBio", "ShareIntent", "None"

/// <summary>
/// Verification token generated for Token-in-Bio method.
/// </summary>
public string? VerificationToken { get; set; }

/// <summary>
/// Timestamp when ownership was locked (profile claimed by this user).
/// </summary>
public DateTime? OwnershipLockedAt { get; set; }

/// <summary>
/// SHA-256 hash of profile snapshot at verification time.
/// </summary>
public string? SnapshotHash { get; set; }

/// <summary>
/// Timestamp when re-verification is required (90 days from verification).
/// </summary>
public DateTime? NextReverifyAt { get; set; }
```

---

#### **New Model:** `src/SilentID.Api/Models/ExternalRating.cs`
```csharp
using System.ComponentModel.DataAnnotations;

namespace SilentID.Api.Models;

/// <summary>
/// Stores star ratings scraped from external marketplace profiles.
/// Only Level 3 verified profiles contribute to URS.
/// </summary>
public class ExternalRating
{
    [Key]
    public Guid Id { get; set; }

    /// <summary>
    /// Link to the profile evidence record.
    /// </summary>
    public Guid ProfileLinkId { get; set; }
    public ProfileLinkEvidence ProfileLink { get; set; } = null!;

    /// <summary>
    /// User who owns this rating.
    /// </summary>
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    /// <summary>
    /// Platform name (Vinted, eBay, Depop, Etsy).
    /// </summary>
    [Required]
    [MaxLength(50)]
    public string Platform { get; set; } = string.Empty;

    /// <summary>
    /// Raw rating from platform (e.g., 4.8/5.0 or 98%).
    /// </summary>
    public decimal PlatformRating { get; set; }

    /// <summary>
    /// Number of reviews/ratings.
    /// </summary>
    public int ReviewCount { get; set; }

    /// <summary>
    /// Account age in days.
    /// </summary>
    public int AccountAge { get; set; }

    /// <summary>
    /// Normalized rating (0-100 scale).
    /// </summary>
    public decimal NormalizedRating { get; set; }

    /// <summary>
    /// Weight based on review count.
    /// </summary>
    public decimal ReviewCountWeight { get; set; }

    /// <summary>
    /// Weight based on account age.
    /// </summary>
    public decimal AccountAgeWeight { get; set; }

    /// <summary>
    /// Combined weight (average of review count and account age weights).
    /// </summary>
    public decimal CombinedWeight { get; set; }

    /// <summary>
    /// Weighted score (normalized rating × combined weight).
    /// </summary>
    public decimal WeightedScore { get; set; }

    /// <summary>
    /// When this rating was scraped.
    /// </summary>
    public DateTime ScrapedAt { get; set; } = DateTime.UtcNow;

    /// <summary>
    /// When this rating expires (180 days from scrape).
    /// </summary>
    public DateTime ExpiresAt { get; set; }

    /// <summary>
    /// When this record was created.
    /// </summary>
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
```

---

#### **File:** `src/SilentID.Api/Services/TrustScoreService.cs`

**Add URS Calculation Method (after line 260)**
```csharp
private async Task<int> CalculateURSScoreAsync(Guid userId)
{
    // Get all Level 3 verified profiles with non-expired ratings
    var ratings = await _context.ExternalRatings
        .Where(r => r.UserId == userId && r.ExpiresAt > DateTime.UtcNow)
        .ToListAsync();

    if (ratings.Count == 0)
        return 0; // No URS contribution if no verified ratings

    // Calculate weighted average of normalized ratings
    var totalWeightedScore = ratings.Sum(r => r.WeightedScore);
    var totalWeight = ratings.Sum(r => r.CombinedWeight);

    if (totalWeight == 0)
        return 0;

    var weightedAverage = totalWeightedScore / totalWeight;

    // Convert to 0-200 point scale
    var ursPoints = (int)Math.Round((weightedAverage / 100m) * 200);

    return Math.Min(ursPoints, 200); // Cap at 200
}
```

**Update CalculateAndSaveTrustScoreAsync (lines 104-126)**
```csharp
public async Task<TrustScoreSnapshot> CalculateAndSaveTrustScoreAsync(Guid userId)
{
    var breakdown = await GetTrustScoreBreakdownAsync(userId);

    // ✅ ADD: Calculate URS
    var ursScore = await CalculateURSScoreAsync(userId);

    var snapshot = new TrustScoreSnapshot
    {
        UserId = userId,
        // ✅ UPDATE: Include URS in raw score calculation
        Score = (int)Math.Round(((double)(breakdown.Identity.Score + breakdown.Evidence.Score +
                                           breakdown.Behaviour.Score + breakdown.Peer.Score + ursScore) / 1200) * 1000), // Normalized to 1000
        IdentityScore = breakdown.Identity.Score,
        EvidenceScore = breakdown.Evidence.Score,
        BehaviourScore = breakdown.Behaviour.Score,
        PeerScore = breakdown.Peer.Score,
        UrsScore = ursScore, // ✅ ADD: Store URS score
        BreakdownJson = System.Text.Json.JsonSerializer.Serialize(breakdown),
        CreatedAt = DateTime.UtcNow
    };

    _context.TrustScoreSnapshots.Add(snapshot);
    await _context.SaveChangesAsync();

    _logger.LogInformation("TrustScore calculated for user {UserId}: {Score} (Identity: {Identity}, Evidence: {Evidence}, Behaviour: {Behaviour}, Peer: {Peer}, URS: {URS})",
        userId, snapshot.Score, snapshot.IdentityScore, snapshot.EvidenceScore, snapshot.BehaviourScore, snapshot.PeerScore, snapshot.UrsScore);

    return snapshot;
}
```

---

#### **File:** `src/SilentID.Api/Models/TrustScoreSnapshot.cs`

**Add URS Field**
```csharp
// ✅ ADD (after PeerScore property):
/// <summary>
/// URS (Unified Reputation Score) component (0-200 points).
/// Calculated from weighted average of star ratings from Level 3 verified profiles.
/// </summary>
public int UrsScore { get; set; }
```

---

#### **New Service:** `src/SilentID.Api/Services/Level3VerificationService.cs`
```csharp
using System.Security.Cryptography;
using System.Text;
using Microsoft.EntityFrameworkCore;
using SilentID.Api.Data;
using SilentID.Api.Models;

namespace SilentID.Api.Services;

public class Level3VerificationService : ILevel3VerificationService
{
    private readonly SilentIdDbContext _context;
    private readonly ILogger<Level3VerificationService> _logger;

    public Level3VerificationService(SilentIdDbContext context, ILogger<Level3VerificationService> logger)
    {
        _context = context;
        _logger = logger;
    }

    public async Task<string> GenerateVerificationTokenAsync(Guid profileLinkId)
    {
        var profileLink = await _context.ProfileLinkEvidences
            .FirstOrDefaultAsync(p => p.Id == profileLinkId);

        if (profileLink == null)
            throw new InvalidOperationException("Profile link not found");

        // Generate unique token: SILENTID-VERIFY-{random-8-chars}
        var randomString = GenerateRandomString(8);
        var token = $"SILENTID-VERIFY-{randomString}";

        // Save token to profile link
        profileLink.VerificationToken = token;
        profileLink.VerificationMethod = "TokenInBio";
        profileLink.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return token;
    }

    public async Task<bool> VerifyTokenInBioAsync(Guid profileLinkId)
    {
        var profileLink = await _context.ProfileLinkEvidences
            .FirstOrDefaultAsync(p => p.Id == profileLinkId);

        if (profileLink == null || string.IsNullOrEmpty(profileLink.VerificationToken))
            return false;

        // TODO: Use Playwright MCP to scrape profile and check for token in bio
        // For now, return false (implement scraping logic separately)

        // If token found in bio:
        // profileLink.VerificationLevel = 3;
        // profileLink.OwnershipLockedAt = DateTime.UtcNow;
        // profileLink.SnapshotHash = CalculateSHA256(profileSnapshot);
        // profileLink.NextReverifyAt = DateTime.UtcNow.AddDays(90);
        // await _context.SaveChangesAsync();

        return false; // TODO: Implement scraping logic
    }

    private string GenerateRandomString(int length)
    {
        const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        var random = new Random();
        return new string(Enumerable.Repeat(chars, length)
            .Select(s => s[random.Next(s.Length)]).ToArray());
    }

    private string CalculateSHA256(string input)
    {
        using var sha256 = SHA256.Create();
        var bytes = Encoding.UTF8.GetBytes(input);
        var hash = sha256.ComputeHash(bytes);
        return Convert.ToHexString(hash);
    }
}
```

---

#### **New Controller Endpoint:** `src/SilentID.Api/Controllers/EvidenceController.cs`
```csharp
/// <summary>
/// Generate Level 3 verification token for Token-in-Bio method.
/// </summary>
[HttpPost("profile-links/{id}/generate-verification-token")]
public async Task<ActionResult<string>> GenerateVerificationToken(Guid id)
{
    var profileLink = await _context.ProfileLinkEvidences
        .FirstOrDefaultAsync(p => p.Id == id && p.UserId == UserId);

    if (profileLink == null)
        return NotFound(new { error = "profile_link_not_found" });

    var token = await _level3VerificationService.GenerateVerificationTokenAsync(id);

    return Ok(new { token });
}

/// <summary>
/// Confirm Level 3 verification (user has added token to bio).
/// </summary>
[HttpPost("profile-links/{id}/confirm-verification")]
public async Task<ActionResult> ConfirmVerification(Guid id)
{
    var profileLink = await _context.ProfileLinkEvidences
        .FirstOrDefaultAsync(p => p.Id == id && p.UserId == UserId);

    if (profileLink == null)
        return NotFound(new { error = "profile_link_not_found" });

    var verified = await _level3VerificationService.VerifyTokenInBioAsync(id);

    if (verified)
    {
        return Ok(new { message = "Profile verified successfully! Your stars will appear within 24 hours." });
    }
    else
    {
        return BadRequest(new { error = "verification_failed", message = "Token not found in profile bio. Please ensure you've added it correctly." });
    }
}
```

---

### 🟡 IMPORTANT (Should Fix Soon)

#### **New Service:** `src/SilentID.Api/Services/StarRatingScraperService.cs`
- Purpose: Scrape star ratings from marketplace profiles
- Use Playwright MCP to navigate to Vinted/eBay/Depop profiles
- Extract: rating, review count, account age, join date
- Calculate normalized rating, weights, weighted score
- Store in `ExternalRatings` table
- Run daily via background job (Hangfire or Azure Functions)

---

#### **New Service:** `src/SilentID.Api/Services/AnomalyDetectionService.cs`
- Purpose: Detect sudden rating drops, review deletions, account hacks
- Run hourly via background job
- Compare current ratings with last scraped ratings
- If rating drop > 1.0 stars in 24h: trigger grace period
- If review count drop > 50% in 7 days: trigger grace period
- Send notification to user

---

#### **New Service:** `src/SilentID.Api/Services/EmailReceiptForwardingService.cs`
- Purpose: Receive forwarded emails, parse receipts, extract metadata
- Set up email receiving on `receipts.silentid.co.uk`
- Parse email headers (From, Subject, Date)
- Extract order ID, amount, platform, item
- Store metadata in `ReceiptEvidence` table with `EmailMetadataJson`
- Delete raw email immediately after extraction

---

## 7. AGENT_TASK_PLAN — Use Existing 4 Agents

### Agent Definitions (from Project Memory)

**Agent 1: ARCHITECT (Agent A)**
- Role: System design, API contracts, database schema
- Focus: Backend architecture, data models, service patterns

**Agent 2: BACKEND DEVELOPER (Agent B)**
- Role: ASP.NET Core implementation, services, controllers
- Focus: Business logic, database operations, API endpoints

**Agent 3: FRONTEND DEVELOPER (Agent C)**
- Role: Flutter implementation, UI screens, widgets
- Focus: User experience, visual design, state management

**Agent 4: QA & INTEGRATION (Agent D)**
- Role: Testing, validation, integration, quality assurance
- Focus: End-to-end testing, API validation, bug detection

---

### Task Allocation by Agent

#### **Agent A (ARCHITECT) — Phase 1 Tasks**
1. ✅ Review Section 47 requirements and create detailed technical design
2. ✅ Design `ExternalRatings` table schema (already defined in this report)
3. ✅ Design Level 3 verification API contracts
4. ✅ Design URS calculation algorithm
5. ✅ Update `ProfileLinkEvidence` schema with Level 3 fields
6. ✅ Update `TrustScoreSnapshot` schema with URS field
7. ✅ Update `PublicProfileDto` to remove TrustScore, add star ratings
8. 🔄 Create database migration script for new schema changes
9. 🔄 Document API endpoint changes (breaking changes)

---

#### **Agent B (BACKEND) — Phase 2 Tasks**
1. 🔄 Create `ExternalRating` model (copy from Section 6 of this report)
2. 🔄 Add `UrsScore` field to `TrustScoreSnapshot` model
3. 🔄 Update `ProfileLinkEvidence` model with Level 3 verification fields
4. 🔄 Update `PublicController.cs` to remove TrustScore from public endpoint
5. 🔄 Update `PublicController.cs` to return star ratings from `ExternalRatings` table
6. 🔄 Implement `Level3VerificationService.cs` (token generation, verification)
7. 🔄 Update `TrustScoreService.cs` to calculate URS
8. 🔄 Update `TrustScoreService.cs` formula to normalize raw score (max 1200 → 1000)
9. 🔄 Create `StarRatingScraperService.cs` (using Playwright MCP)
10. 🔄 Create `AnomalyDetectionService.cs` (rating drops, review deletions)
11. 🔄 Create `EmailReceiptForwardingService.cs` (Expensify model)
12. 🔄 Add new endpoints to `EvidenceController.cs` (generate token, confirm verification)
13. 🔄 Run database migration to add new tables/fields

---

#### **Agent C (FRONTEND) — Phase 3 Tasks**
1. 🔄 Update `PublicProfile` model to remove `trustScore`, add `platformRatings`
2. 🔄 Rewrite `public_profile_viewer_screen.dart` to display star ratings (NOT TrustScore)
3. 🔄 Create `PlatformRatingCard` widget (copy from Section 5 of this report)
4. 🔄 Create `level_3_verification_screen.dart` (guide user through Token-in-Bio)
5. 🔄 Create `email_forwarding_setup_widget.dart` (guide user to forward emails)
6. 🔄 Update `public_profile_service.dart` to use new API response format
7. 🔄 Test QR code display (already implemented in `share_profile_sheet.dart`)
8. 🔄 Add "Digital Trust Passport" header design per Section 47.8
9. 🔄 Add footer text: "TrustScore is private. Only verified star ratings shown."
10. 🔄 Update private dashboard to show TrustScore (user's own view only)

---

#### **Agent D (QA) — Phase 4 Tasks**
1. 🔄 Test public profile API endpoint (verify TrustScore NOT returned)
2. 🔄 Test public profile UI (verify TrustScore NOT displayed)
3. 🔄 Test star rating display (verify all platforms shown correctly)
4. 🔄 Test Level 3 verification flow (token generation, bio scraping, verification)
5. 🔄 Test URS calculation (verify formula correctness)
6. 🔄 Test TrustScore normalization (verify raw 1200 → normalized 1000)
7. 🔄 Test email receipt forwarding (send test email, verify metadata extraction)
8. 🔄 Test anomaly detection (simulate rating drop, verify grace period triggered)
9. 🔄 Test grace period logic (verify stars shown with warning)
10. 🔄 Integration test: Complete flow from profile linking → Level 3 verification → star display on public profile
11. 🔄 Regression test: Verify existing features still work (auth, subscriptions, reports)
12. 🔄 Performance test: Verify public profile loads in <500ms
13. 🔄 Document all test results and create bug reports for any issues

---

## 8. NEXT_PROMPTS_FOR_EACH_AGENT

### PROMPT_FOR_AGENT_1 (ARCHITECT)

```
Agent A (ARCHITECT), your immediate task is to create the database migration script for Section 47 (Digital Trust Passport) requirements.

Reference:
- CLAUDE.md Section 47.7 (Database Schema Updates)
- This report Section 6 (REQUIRED_BACKEND_UPDATES)

Actions Required:
1. Create EF Core migration script named "AddLevel3VerificationAndURS"
2. Add new table: ExternalRatings (see schema in Section 6 of SILENTID_MVP_ORCHESTRATOR_REPORT.md)
3. Add fields to ProfileLinkEvidence:
   - VerificationLevel INT
   - VerificationMethod VARCHAR(50)
   - VerificationToken VARCHAR(100)
   - OwnershipLockedAt TIMESTAMP
   - SnapshotHash VARCHAR(64)
   - NextReverifyAt TIMESTAMP
4. Add field to TrustScoreSnapshot:
   - UrsScore INT
5. Add fields to ReceiptEvidence:
   - ForwardingAlias VARCHAR(255) UNIQUE
   - EmailMetadataJson JSONB
   - RawEmailDeleted BOOLEAN DEFAULT TRUE

Deliverable:
- Create migration file: src/SilentID.Api/Migrations/{timestamp}_AddLevel3VerificationAndURS.cs
- Ensure migration is reversible (include Down() method)
- Test migration in local dev environment
- Document breaking changes in MIGRATION_NOTES.md

DO NOT proceed to implementation until migration is reviewed and approved.
```

---

### PROMPT_FOR_AGENT_2 (BACKEND)

```
Agent B (BACKEND DEVELOPER), your immediate task is to fix the CRITICAL TrustScore exposure bug in PublicController.cs.

Reference:
- CLAUDE.md Section 47.5 (TrustScore Privacy Rules)
- This report Section 4 (GAP_ANALYSIS - Conflict #1)
- This report Section 6 (REQUIRED_BACKEND_UPDATES)

Actions Required (in this order):
1. Update PublicController.cs:
   - Remove TrustScore and TrustScoreLabel fields from PublicProfileDto (lines 41-42)
   - Remove TrustScore calculation from GetPublicProfile method (lines 205-220)
   - Replace with PlatformRatings list (query ExternalRatings table)
   - Add helper methods: CalculateAccountAge() and CalculateFreshness()

2. Create new model: ExternalRating.cs (copy exact schema from Section 6 of this report)

3. Update TrustScoreService.cs:
   - Add CalculateURSScoreAsync() method (copy from Section 6 of this report)
   - Update CalculateAndSaveTrustScoreAsync() to include URS in formula
   - Update normalization: (Raw Score / 1200) × 1000

4. Update TrustScoreSnapshot.cs:
   - Add UrsScore INT property

5. Test changes:
   - Run GET /v1/public/profile/testuser
   - Verify response does NOT include TrustScore field
   - Verify response DOES include PlatformRatings array (empty if no ratings yet)

Deliverable:
- Updated PublicController.cs (TrustScore removed from public endpoint)
- New ExternalRating.cs model
- Updated TrustScoreService.cs (URS calculation added)
- Updated TrustScoreSnapshot.cs (UrsScore field added)
- Test results confirming TrustScore is no longer exposed publicly

CRITICAL: This is a PRIVACY VIOLATION. Must be fixed before any public launch.
```

---

### PROMPT_FOR_AGENT_3 (FRONTEND)

```
Agent C (FRONTEND DEVELOPER), your immediate task is to rewrite public_profile_viewer_screen.dart to display star ratings instead of TrustScore.

Reference:
- CLAUDE.md Section 47.8 (Digital Trust Passport UI Design)
- This report Section 5 (REQUIRED_UI_UPDATES)
- This report Section 4 (GAP_ANALYSIS - Conflict #1)

Actions Required (in this order):
1. Update models/public_profile.dart:
   - Remove trustScore and trustScoreLabel fields
   - Add platformRatings field (List<PlatformRating>)
   - Create PlatformRating model (platform, rating, reviewCount, accountAge, lastUpdated, freshness)

2. Rewrite public_profile_viewer_screen.dart (lines 257-304):
   - Remove TrustScore display (purple gradient card with big number)
   - Add "Digital Trust Passport" header (icon + title + subtitle)
   - Display star ratings for each platform (use PlatformRatingCard widget)
   - Add footer: "TrustScore is private. Only verified star ratings shown."

3. Create new widget: platform_rating_card.dart
   - Copy exact implementation from Section 5 of this report
   - Display platform logo (placeholder for now), platform name
   - Display stars visually (★★★★☆ using Icons.star)
   - Display exact rating: "4.8 out of 5.0"
   - Display review count: "(342 reviews)"
   - Display account age: "Member since March 2023"
   - Display freshness: "Last updated: 2 days ago"

4. Update public_profile_service.dart:
   - Update getPublicProfile() to parse new API response format
   - Map platformRatings array to List<PlatformRating>

5. Test changes:
   - Run app in dev mode
   - Navigate to public profile screen
   - Verify TrustScore is NOT displayed
   - Verify placeholder message: "No verified star ratings yet" (if no ratings)
   - Verify star ratings display correctly (once backend provides data)

Deliverable:
- Updated public_profile.dart model (TrustScore removed, platformRatings added)
- Rewritten public_profile_viewer_screen.dart (star ratings instead of TrustScore)
- New platform_rating_card.dart widget
- Updated public_profile_service.dart (handles new API format)
- Screenshots/screen recording showing new UI

CRITICAL: Public profile must NEVER show TrustScore. Only star ratings from verified platforms.
```

---

### PROMPT_FOR_AGENT_4 (QA)

```
Agent D (QA & INTEGRATION), your immediate task is to validate that TrustScore is no longer exposed publicly after Agent B and Agent C complete their fixes.

Reference:
- CLAUDE.md Section 47.5 (TrustScore Privacy Rules)
- This report Section 4 (GAP_ANALYSIS - Conflict #1)

Test Plan:

1. Backend API Test:
   - Run GET /v1/public/profile/testuser
   - Verify response does NOT contain "trustScore" field
   - Verify response does NOT contain "trustScoreLabel" field
   - Verify response DOES contain "platformRatings" array
   - If platformRatings is empty, verify it returns [] not null
   - Document API response structure

2. Frontend UI Test:
   - Launch Flutter app in dev mode
   - Navigate to public profile screen (any user)
   - Verify NO TrustScore number is displayed anywhere
   - Verify NO TrustScore label ("High Trust", "Low Trust") is displayed
   - Verify "Digital Trust Passport" header is present
   - If no star ratings exist yet, verify placeholder message: "No verified star ratings yet"
   - Take screenshots of before/after

3. Private Dashboard Test (Sanity Check):
   - Login as test user
   - Navigate to private TrustScore screen
   - Verify TrustScore IS displayed in private dashboard (should still work)
   - Verify breakdown shows Identity, Evidence, Behaviour, Peer components
   - Confirm URS component added (may show 0 if no ratings yet)

4. Regression Test:
   - Verify existing features still work:
     - Login/signup
     - Evidence upload
     - Mutual verification
     - Safety reports
     - Subscription management
   - Document any broken features

5. Performance Test:
   - Measure public profile load time (should be <500ms per Section 47)
   - Use browser dev tools or Postman to measure API latency
   - Document results

Deliverables:
- Test execution report with pass/fail status for each test case
- Screenshots of public profile (before/after)
- API response samples (before/after)
- Bug reports for any issues found
- Performance metrics (API latency, page load time)

Acceptance Criteria:
✅ Public profile API does NOT return TrustScore
✅ Public profile UI does NOT display TrustScore
✅ Private dashboard STILL displays TrustScore (no regression)
✅ No existing features broken

If ALL tests pass, create MVP_READINESS_REPORT.md summarizing status.
If ANY tests fail, STOP and report blockers immediately.
```

---

## 9. ESTIMATED TIMELINE & EFFORT

### Phase 1: Critical Fixes (TrustScore Privacy Violation)
- **Agent A:** Database migration — 1 day
- **Agent B:** Backend fixes (PublicController, TrustScoreService, models) — 2 days
- **Agent C:** Frontend fixes (public_profile_viewer_screen.dart rewrite) — 2 days
- **Agent D:** Testing & validation — 1 day
- **Total:** **5-6 working days**

### Phase 2: Level 3 Verification System
- **Agent A:** API contract design — 1 day
- **Agent B:** Backend implementation (Level3VerificationService, endpoints, Playwright integration) — 5-7 days
- **Agent C:** Frontend implementation (level_3_verification_screen.dart) — 3-4 days
- **Agent D:** Testing & validation — 2 days
- **Total:** **11-14 working days**

### Phase 3: URS & Star Rating System
- **Agent A:** Algorithm design — 1 day
- **Agent B:** Backend implementation (StarRatingScraperService, URS calculation) — 6-8 days
- **Agent C:** Frontend implementation (PlatformRatingCard widget) — 2-3 days
- **Agent D:** Testing & validation — 2 days
- **Total:** **11-14 working days**

### Phase 4: Email Receipt Forwarding (Expensify Model)
- **Agent A:** Email infrastructure design — 1 day
- **Agent B:** Backend implementation (EmailReceiptForwardingService, parsing logic) — 7-10 days
- **Agent C:** Frontend implementation (email_forwarding_setup_widget.dart) — 2 days
- **Agent D:** Testing & validation — 2 days
- **Total:** **12-15 working days**

### Phase 5: Anomaly Detection & Edge Cases
- **Agent A:** Detection rules design — 1 day
- **Agent B:** Backend implementation (AnomalyDetectionService, grace period logic) — 5-7 days
- **Agent C:** Frontend implementation (anomaly warnings UI) — 2 days
- **Agent D:** Testing & validation — 2 days
- **Total:** **10-12 working days**

---

## 10. RISK ASSESSMENT

### 🔴 CRITICAL RISKS (Immediate Attention)

#### **Risk #1: TrustScore Privacy Violation**
- **Impact:** GDPR/legal liability, user trust erosion, reputational damage
- **Probability:** 100% (already happening in production)
- **Mitigation:** Emergency fix required (Phase 1 tasks)

#### **Risk #2: Incomplete TrustScore Formula**
- **Impact:** Misleading trust calculations, user confusion, unfair scoring
- **Probability:** 100% (missing URS component)
- **Mitigation:** Implement URS calculation (Phase 3 tasks)

#### **Risk #3: No Level 3 Verification**
- **Impact:** Cannot implement Digital Trust Passport per Section 47
- **Probability:** 100% (feature not built)
- **Mitigation:** Implement Level 3 verification system (Phase 2 tasks)

---

### 🟡 MEDIUM RISKS (Should Monitor)

#### **Risk #4: Playwright MCP Integration Complexity**
- **Impact:** Profile scraping may fail, Level 3 verification blocked
- **Probability:** Medium (depends on Playwright MCP reliability)
- **Mitigation:** Implement fallback to cached snapshots, retry logic

#### **Risk #5: Email Forwarding Deliverability**
- **Impact:** Users cannot forward receipts, manual upload only
- **Probability:** Medium (depends on email provider configuration)
- **Mitigation:** Provide alternative: manual receipt upload, connect inbox OAuth

---

### 🟢 LOW RISKS (Accept or Monitor)

#### **Risk #6: UI Polish Delays**
- **Impact:** Visual inconsistency, less polished feel
- **Probability:** Low
- **Mitigation:** Iterate post-launch, gather user feedback

---

## 11. NEXT_STEPS

### Immediate Actions (DO NOT DELAY)

1. **Reconnect All MCP Servers**
   - Only puppeteer console currently active
   - Need code-index, context7, sequential-thinking for implementation tasks

2. **Agent A: Create Database Migration**
   - Use prompt from Section 8 (PROMPT_FOR_AGENT_1)
   - Deliverable: Migration script for ExternalRatings table + new fields

3. **Agent B: Fix TrustScore Privacy Violation**
   - Use prompt from Section 8 (PROMPT_FOR_AGENT_2)
   - Deliverable: PublicController.cs updated, TrustScore removed from public endpoint

4. **Agent C: Rewrite Public Profile UI**
   - Use prompt from Section 8 (PROMPT_FOR_AGENT_3)
   - Deliverable: public_profile_viewer_screen.dart rewritten, star ratings displayed

5. **Agent D: Validate Fixes**
   - Use prompt from Section 8 (PROMPT_FOR_AGENT_4)
   - Deliverable: Test execution report, screenshots, bug reports

---

### Follow-Up Actions (After Phase 1 Complete)

6. **Agent B: Implement Level 3 Verification**
   - Token-in-Bio generation
   - Share-Intent validation
   - Playwright MCP integration for bio scraping

7. **Agent B: Implement URS Calculation**
   - Star rating scraper service
   - URS formula integration
   - ExternalRatings table population

8. **Agent C: Build Level 3 Verification UI**
   - level_3_verification_screen.dart
   - Guide user through token-in-bio flow
   - Poll backend for verification status

9. **Agent D: Integration Testing**
   - End-to-end test: profile linking → Level 3 verification → star display
   - Performance testing: public profile load time
   - Regression testing: existing features

---

## 12. CONCLUSION

### Summary of Findings

**✅ What's Working:**
- Core MVP features (auth, subscriptions, evidence upload, mutual verification)
- QR code generation for public profiles
- Basic TrustScore calculation (4-component system)

**🔴 What's Broken:**
- TrustScore exposed publicly (CRITICAL PRIVACY VIOLATION)
- Wrong TrustScore formula (missing URS component)
- No Level 3 verification system
- No star rating display on public profiles
- No email receipt forwarding (Expensify model)
- No anomaly detection

**🎯 What Must Happen:**
1. **Emergency Fix (Phase 1):** Remove TrustScore from public profiles immediately
2. **Critical Implementation (Phase 2-3):** Build Level 3 verification + URS calculation
3. **Important Features (Phase 4-5):** Email forwarding, anomaly detection, edge cases

---

### Final Recommendation

**DO NOT launch public profiles until:**
- ✅ TrustScore removed from public endpoint (Phase 1)
- ✅ Star ratings displayed instead of TrustScore (Phase 1)
- ✅ Level 3 verification implemented (Phase 2)
- ✅ URS calculation added to TrustScore formula (Phase 3)
- ✅ All tests passed (Phase 1, 2, 3 validation)

**Estimated time to MVP readiness:** 6-8 weeks (assuming full-time work by all 4 agents)

---

**END OF REPORT**

Generated by: SilentID MVP Orchestrator
Report File: C:\SILENTID\SILENTID_MVP_ORCHESTRATOR_REPORT.md
Date: 2025-11-24
