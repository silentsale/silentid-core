# CLAUDE.MD UPDATE SPECIFICATION
**Generated:** 2025-11-24
**Target File:** C:\SILENTID\CLAUDE.md
**Purpose:** Safely integrate 6 new feature sets without breaking existing content

---

## EXECUTIVE SUMMARY

This document specifies surgical updates to CLAUDE.md to integrate:
- A. Strong External Profile Ownership (Level 3 Verification)
- B. Cross-Platform Ratings Extraction
- C. Unified Reputation Score (URS)
- D. Evidence Vault Weighting Rules
- E. Email Receipt Scanning (Expensify Model)
- F. Anti-Fake & Anti-Cheat Architecture (strengthening)

All updates preserve existing content, avoid duplicates, and maintain compatibility.

---

## UPDATE A: LEVEL 3 VERIFICATION (Strong External Profile Ownership)

### Location: SECTION 5 - After line 638 (after "Public Profile URL Scraper")

### INSERT NEW SUBSECTION:

```markdown
### Level 3 Verification: Strong External Profile Ownership

**Purpose:** Prove that a SilentID user is the legitimate owner of an external marketplace profile, not just someone linking to another person's profile.

**Verification Levels:**
- **Level 1 (Basic):** URL submitted, profile is public and accessible
- **Level 2 (Integrity Check):** Username similarity + behavioral pattern matching
- **Level 3 (Ownership Proof):** Cryptographic proof user controls the external profile

#### Level 3 Verification Methods

**Method A: Token-in-Bio Verification**

**Platforms:** Vinted, Depop, Instagram, LinkedIn, TikTok (any platform with editable bio)

**Flow:**
1. User submits external profile URL in SilentID
2. SilentID generates unique verification token: `SILENTID-VERIFY-{random_string}`
3. User instructed: "Add this code to your [Platform] bio"
4. User adds token to their bio on external platform
5. SilentID scrapes the bio after 60 seconds
6. If token found → **Level 3 Verified** + **Ownership Locked**
7. Token expires after 7 days (user must remove it)

**Security:**
- Token is one-time use
- Token includes timestamp + user hash (prevents reuse)
- Snapshot of bio taken and hashed
- Device fingerprint recorded at verification time

**Method B: Share-Intent Verification**

**Platforms:** Facebook Marketplace, eBay (platforms where sharing from account is provable)

**Flow:**
1. User submits external profile URL
2. SilentID generates shareable link: `https://silentid.co.uk/verify/{token}`
3. User instructed: "Share this link publicly from your [Platform] account"
4. SilentID monitors for share event or webhook from platform
5. If share detected from correct account → **Level 3 Verified**

**Security:**
- Token tied to specific SilentID user + platform account
- Share must originate from account matching the submitted profile
- Share timestamp must be within 10-minute verification window

#### Platform Type Classification

**Type A Platforms (Token-in-Bio):**
- Vinted, Depop, Instagram, LinkedIn, TikTok, Twitter/X, Etsy (about section)
- Requires editable bio/description field

**Type B Platforms (Share-Intent):**
- Facebook Marketplace, eBay (sharing capabilities)
- Requires platform sharing API or detectable share mechanism

**Type C Platforms (Unsupported for Level 3):**
- Platforms with no bio editing or sharing capability
- Can only achieve Level 2 verification
- Examples: Some closed marketplace apps

#### Ownership Locking Rules

**Critical Rule:** One external profile can be Level 3 verified by ONLY ONE SilentID account.

**Lock Behavior:**
1. User A completes Level 3 verification for `vinted.com/member/12345`
2. Profile is **locked** to User A's SilentID account
3. User B attempts to verify same URL → **Blocked**
4. Error message: "This profile is already verified by another SilentID account."

**Lock Release Conditions:**
- User A deletes their SilentID account (30-day grace period)
- User A manually unlinks the profile
- User A fails re-verification 3 times (profile abandoned)
- Admin manually releases lock (fraud investigation)

**Lock Timestamp:**
- Recorded in database: `OwnershipLockTimestamp`
- Displayed publicly: "Profile verified since [Date]"

#### Verification Snapshot Hashing

**Purpose:** Detect if external profile changes after verification (potential account takeover or sale).

**Process:**
1. At Level 3 verification, SilentID captures:
   - Profile HTML/JSON snapshot
   - Username, join date, rating, review count
   - Bio text (if applicable)
2. Snapshot hashed (SHA-256)
3. Hash stored: `SnapshotHash`
4. **Re-verification every 90 days:**
   - New snapshot taken
   - New hash compared to original
   - If mismatch → **Level 3 Revoked**, User notified

**What Triggers Revocation:**
- Username change on external platform
- Account join date changed (impossible, indicates fake profile)
- Review count drops significantly (account wiped/reset)
- Bio no longer contains expected patterns

**User Notification:**
"Your [Platform] profile verification has been revoked due to detected changes. Please re-verify."

#### Metadata Checks

**At Verification Time:**
- Platform account age (must be >30 days for high-trust)
- Transaction history visible (listings, reviews, ratings)
- Profile completeness (profile photo, bio, activity)
- Suspicious patterns (brand-new account, no activity, placeholder content)

**Red Flags:**
- Account created within last 7 days
- Zero transactions/reviews
- Stock photo or no profile picture
- Generic bio ("New here!")
- All listings identical/copy-paste

**Action on Red Flags:**
- Block Level 3 verification
- Allow Level 2 only
- Require additional evidence (screenshots, receipts)

#### Device Fingerprinting at Verification

**Purpose:** Link external profile verification to specific device for fraud prevention.

**Recorded:**
- Device ID (hashed)
- IP address (anonymized to /24 subnet)
- Browser fingerprint
- Geolocation (city level)
- Timestamp

**Fraud Detection:**
- Same device verifies 10+ profiles in 1 hour → **Bot detected**
- VPN/Tor exit node used during verification → **High risk**
- Device fingerprint matches known fraud cluster → **Blocked**

#### Profile Conflict Detection

**Scenario:** User attempts to verify profile that conflicts with existing evidence.

**Conflict Examples:**
1. **Username Mismatch:**
   - SilentID username: `@alice_silentid`
   - External profile: `vinted.com/member/bob123`
   - Action: Prompt user to explain mismatch

2. **Transaction Count Mismatch:**
   - User uploaded 500 email receipts from Vinted
   - External profile shows 50 transactions
   - Action: Flag for admin review, reduce TrustScore until resolved

3. **Platform Duplication:**
   - User already has Level 3 verified Vinted profile A
   - User attempts to verify Vinted profile B
   - Action: Block (one profile per platform per user)

#### Behaviour Consistency Checks

**Cross-Reference:**
- Do email receipts match external profile transaction dates?
- Do screenshots match external profile username/stats?
- Do mutual verifications align with external profile activity?

**Inconsistency Actions:**
- Minor inconsistency (off by 10%) → Warning, no penalty
- Moderate (off by 30%) → TrustScore reduced 20 points
- Severe (off by 50%+) → Evidence rejected, RiskSignal created

#### TrustScore Impact

**Level 1 (Basic URL):** +10 points (Evidence component)
**Level 2 (Integrity Checked):** +25 points
**Level 3 (Ownership Proven):** +60 points

**Multiple Level 3 Profiles:**
- First Level 3 profile: +60 points
- Second Level 3 profile (different platform): +40 points
- Third Level 3 profile: +25 points
- Fourth+ profiles: +10 points each (diminishing returns)

**Max from Level 3:** 150 points (Evidence component capped at 300 total)
```

---

## UPDATE B: CROSS-PLATFORM RATINGS EXTRACTION

### Location: SECTION 5 - After Level 3 Verification (new subsection)

### INSERT NEW SUBSECTION:

```markdown
### Cross-Platform Ratings Extraction (Stars + Feedback)

**Purpose:** Extract genuine star ratings from Level 3 verified external profiles and use them to calculate a Unified Reputation Score (URS).

**CRITICAL RULES:**
- ✅ Ratings extracted ONLY from Level 3 verified profiles
- ✅ Ratings extracted ONLY from known, trusted platform pages
- ❌ Users CANNOT manually enter star ratings
- ❌ Ratings CANNOT be extracted from screenshots
- ❌ Unverified profiles contribute ZERO to URS

#### Supported Platforms

**Platform Rating Structure:**

| Platform | Star Scale | Rating URL Pattern | DOM Selector (Example) |
|----------|------------|-------------------|------------------------|
| Vinted | 0-5 stars | `https://vinted.com/member/{id}` | `.rating-score` |
| Depop | 0-5 stars | `https://depop.com/{username}` | `.Rating__score` |
| eBay | 0-100% (convert to 5-star) | `https://ebay.com/usr/{username}` | `.seller-rating` |
| Etsy | 0-5 stars | `https://etsy.com/shop/{shopname}` | `.shop-rating` |
| Facebook Marketplace | 0-5 stars | `https://facebook.com/marketplace/profile/{id}` | `[data-rating]` |

*Note: DOM selectors are examples; actual implementation must handle platform UI changes.*

#### Rating URL Derivation

**From Profile URL → Rating URL:**

Most platforms display ratings on the main profile page, but some have separate review pages.

**Examples:**
- Vinted: Profile URL = Rating URL (ratings shown on profile)
- eBay: `ebay.com/usr/johndoe` → `ebay.com/fdbk/feedback_profile/johndoe`
- Etsy: `etsy.com/shop/MyShop` → `etsy.com/shop/MyShop#reviews`

**Backend Logic:**
```
function getRatingUrl(profileUrl, platform) {
  switch(platform) {
    case 'Vinted':
    case 'Depop':
      return profileUrl; // Ratings on profile
    case 'eBay':
      return profileUrl.replace('/usr/', '/fdbk/feedback_profile/');
    case 'Etsy':
      return profileUrl + '#reviews';
    // ... etc
  }
}
```

#### Extraction Method

**Step 1: Scraping (Playwright Headless Browser)**
1. Navigate to rating URL
2. Wait for dynamic content to load (JavaScript rendering)
3. Extract:
   - **Star rating** (e.g., 4.8 out of 5)
   - **Total review count** (e.g., 1,234 reviews)
   - **Recent reviews** (last 10-20 reviews for sentiment analysis)
   - **Account age** (days since profile created)

**Step 2: Fail-Safe Behavior**
- If page returns 404 → Mark profile as inactive, retry in 7 days
- If rating element not found → Log warning, skip rating extraction
- If extraction fails 3 times → Disable rating extraction for this profile
- **NEVER** guess or estimate ratings

**Step 3: Data Validation**
- Rating must be within platform's valid range (e.g., 0-5 for Vinted)
- Review count must be non-negative integer
- Rating + review count must be consistent (can't have 0 reviews with 5-star rating)

**DOM Selector Strategy:**
- Maintain selector library per platform
- Update selectors when platforms change UI (monitoring system)
- Fallback to API if platform offers public API (e.g., eBay API)

#### Rating Normalization (Internal 0-100 Scale)

**Purpose:** Convert different platform rating systems to universal 0-100 scale.

**Conversion Formula:**

**5-Star Systems (Vinted, Depop, Etsy):**
```
normalized = (stars / 5) * 100
```
Example: 4.2 stars → (4.2 / 5) * 100 = 84

**Percentage Systems (eBay):**
```
normalized = percentage
```
Example: 98.5% → 98.5

**Review Count Weighting:**
- More reviews = higher confidence in rating
- Formula: `confidence_factor = min(1.0, review_count / 100)`
- Adjusted score: `adjusted = normalized * confidence_factor`

**Example:**
- Platform A: 4.8 stars, 10 reviews → 96 * 0.10 = 9.6
- Platform B: 4.2 stars, 500 reviews → 84 * 1.00 = 84
- Platform B contributes more despite lower star rating

#### Volume Weighting

**Small Account Penalty:**
- Accounts with <10 reviews get reduced weight
- Prevents new accounts with perfect 5.0 rating (from 1-2 reviews) dominating URS

**Weight Tiers:**
- 1-9 reviews: 0.3x weight
- 10-49 reviews: 0.6x weight
- 50-99 reviews: 0.8x weight
- 100-499 reviews: 1.0x weight
- 500+ reviews: 1.2x weight (established seller boost)

#### Recency Weighting

**Purpose:** Prioritize recent reviews over old reviews (behavior changes over time).

**Time Decay:**
- Reviews from last 6 months: 1.0x weight
- Reviews 6-12 months old: 0.8x weight
- Reviews 12-24 months old: 0.5x weight
- Reviews 24+ months old: 0.3x weight

**Calculation:**
Extract timestamps of last 20 reviews, apply time decay, calculate weighted average.

#### Tenure Weighting (Account Age)

**Longer Account = More Trust:**
- <3 months: 0.5x weight (new, unproven)
- 3-12 months: 0.8x weight
- 1-3 years: 1.0x weight
- 3+ years: 1.2x weight (established, trusted)

**Rationale:** Long-standing accounts with consistent ratings are more trustworthy.

#### Platform Credibility Weighting

**Not All Platforms Equal:**
- High credibility: eBay (1.0x), Etsy (1.0x) — established, strict policies
- Medium credibility: Vinted (0.9x), Depop (0.9x) — peer-to-peer, less oversight
- Low credibility: Facebook Marketplace (0.7x) — easy to game, less moderation

**Rationale:** Platforms with stronger anti-fraud measures and verification produce more reliable ratings.

#### Cross-Platform Consistency Scoring

**Purpose:** Detect rating manipulation (excellent on one platform, terrible on another).

**Consistency Check:**
1. Extract normalized ratings from all Level 3 verified profiles
2. Calculate variance: `variance = standard_deviation(ratings)`
3. High variance (>20 points) → **Inconsistency flag**

**Example:**
- Vinted: 95/100 (excellent)
- eBay: 45/100 (poor)
- Variance: 25 → **Red flag**, suggests one platform is fake or account was bought/sold

**Action on Inconsistency:**
- TrustScore penalty: -30 points
- Admin review triggered
- URS calculated with reduced weight (0.5x)

#### Final Weighted Rating Formula

**URS Calculation:**
```
For each Level 3 verified profile:
  normalized_rating = platform_rating_to_0_100(rating)

  weight = volume_weight * recency_weight * tenure_weight * platform_credibility_weight

  weighted_rating = normalized_rating * weight

URS = sum(weighted_ratings) / sum(weights)

URS = clamp(URS, 0, 100)  // Ensure 0-100 range
```

**Example Calculation:**
- **Vinted:** 4.8 stars (96), 300 reviews, account 2 years old
  - Volume weight: 1.0x, Recency: 1.0x, Tenure: 1.0x, Platform: 0.9x
  - Weighted: 96 * 0.9 = 86.4

- **eBay:** 98%, 150 reviews, account 5 years old
  - Volume weight: 1.0x, Recency: 1.0x, Tenure: 1.2x, Platform: 1.0x
  - Weighted: 98 * 1.2 = 117.6 (capped at 100) → 100

- **URS:** (86.4 + 100) / 2 = 93.2 → **93 External Reputation Score**

#### Storage (Database)

**ProfileLinkEvidence Table - Add Fields:**
- `RatingStars` DECIMAL(3,2) - Original star rating (e.g., 4.75)
- `RatingNormalized` INT - Normalized to 0-100 scale
- `ReviewCount` INT - Total reviews
- `LastReviewDate` DATETIME - Most recent review timestamp
- `AccountAge` INT - Days since profile created
- `RatingSnapshotHash` VARCHAR(64) - SHA-256 of rating page HTML (detect changes)
- `RatingLastScraped` DATETIME - When rating was last extracted
- `RatingExtractionStatus` ENUM('Success', 'Failed', 'Pending', 'Disabled')

**Unified Reputation Score (URS) Storage:**
- Stored in `TrustScoreSnapshots` table as new field: `ExternalReputationScore INT`

#### Fail-Safe & Error Handling

**Never Break if Rating Extraction Fails:**
- If scraping fails → URS calculated WITHOUT that platform (no penalty)
- If all platforms fail → URS = NULL (not 0)
- If URS = NULL → TrustScore calculated without external reputation component

**Retry Logic:**
- Failed extraction → Retry after 1 hour
- 3 consecutive failures → Disable extraction for 7 days
- After 7 days → Re-enable and try again

#### Anti-Fake Guarantee

**How Fake Ratings are Prevented:**
1. **Only Level 3 verified profiles** → User must prove ownership
2. **Scraped from trusted source** → Direct from platform, not user input
3. **Snapshot hashing** → Detects if rating page is tampered with
4. **Cross-platform consistency** → Detects if one platform is fake
5. **Volume + recency + tenure weighting** → Prevents gaming with fake reviews

**User Cannot:**
- ❌ Manually enter star ratings
- ❌ Upload screenshot of ratings (ignored)
- ❌ Link to someone else's profile (blocked by Level 3)
- ❌ Fake reviews on external platform (platform's responsibility, not SilentID's)

**SilentID's Responsibility:**
- ✅ Verify user owns the external profile
- ✅ Extract ratings accurately from platform
- ✅ Detect if ratings change suspiciously
- ❌ NOT responsible for fake reviews on external platforms (that's the platform's job)
```

---

## UPDATE C: UNIFIED REPUTATION SCORE (URS)

### Location: SECTION 3 - Line 308, REPLACE TrustScore Engine section

### REPLACE EXISTING TEXT (lines 308-322):

```markdown
### TrustScore Engine (0–1000)
**Breakdown:**
- **Identity (200 pts):** Stripe verification, email verified, phone verified, device consistency
- **Evidence (300 pts):** receipts, screenshots, public profile data, evidence quality
- **Behaviour (300 pts):** no reports, on-time shipping, account longevity, cross-platform consistency
- **Peer Verification (200 pts):** mutual endorsements, returning partner transactions

**Score Labels:**
- 801–1000: Very High Trust
- 601–800: High Trust
- 401–600: Moderate Trust
- 201–400: Low Trust
- 0–200: High Risk

**Regenerates weekly.**
```

### WITH NEW TEXT:

```markdown
### TrustScore Engine (0–1000)

**Core Formula:**
```
TrustScore = Identity + Evidence + Behaviour + Peer + External Reputation (URS)
```

**Component Breakdown:**

**1. Identity (200 pts max)**
- Stripe Basic ID Verification: 150 pts
- Stripe Enhanced ID Verification: 200 pts (replaces Basic)
- Email verified: included in Identity score
- Phone verified: included in Identity score
- Device consistency: included in Identity score

**2. Evidence (300 pts max)**

**Sub-components:**
- **Level 3 Verified Profiles:** 0-150 pts (see Level 3 Verification rules)
- **Email Receipts:** 0-75 pts (transaction evidence)
- **Evidence Vault:** 0-45 pts (screenshots, supporting docs) — **MAX 15% of Evidence component**
- **Mutual Verifications:** Moved to Peer component

**Evidence Vault Rule (CRITICAL):**
- Evidence Vault contributes MAXIMUM 10-15% of total TrustScore
- Vault acts as REINFORCEMENT, not primary trust source
- Bulk uploads / fake evidence contribute ZERO
- Vault evidence must match verified platform behaviour

**3. Behaviour (300 pts max)**
- No safety reports: 100 pts baseline
- On-time shipping patterns: 0-60 pts
- Account longevity: 0-60 pts (1 pt per month, max 5 years)
- Cross-platform consistency: 0-80 pts (do receipts match profiles?)
- Response rate (if applicable): 0-40 pts

**4. Peer Verification (200 pts max)**
- Mutual transaction confirmations: 10 pts each (max 150 pts)
- Returning trade partners: 5 pts each (max 50 pts)
- Anti-collusion filters applied (see Section 7)

**5. External Reputation / URS (200 pts max) — NEW**

**Unified Reputation Score (URS):**
- Weighted merge of star ratings from ALL Level 3 verified profiles
- Calculated on 0-100 scale
- Converted to TrustScore points: `(URS / 100) * 200`

**Example:**
- User has URS of 93 (from Vinted 4.8★, eBay 98%)
- TrustScore contribution: (93 / 100) * 200 = 186 points

**URS Integration Rules:**
- URS does NOT override Identity verification
- URS does NOT override Behaviour (safety reports)
- If user has NO Level 3 verified profiles → URS = 0 (TrustScore calculated from other 4 components)
- If Level 3 profiles exist but rating extraction fails → URS contribution = 0 (no penalty)

**Maximum TrustScore Breakdown:**
- Identity: 200
- Evidence: 300 (Level 3: 150 + Receipts: 75 + Vault: 45 + Mutual moved to Peer: 30)
- Behaviour: 300
- Peer: 200
- URS: 200
- **Total: 1200 possible** → Normalized to 1000

**Normalization Formula:**
```
Raw Score = Identity + Evidence + Behaviour + Peer + URS
TrustScore = (Raw Score / 1200) * 1000
TrustScore = clamp(TrustScore, 0, 1000)
```

**TrustScore Labels (Updated):**
- 850–1000: Exceptional Trust
- 700–849: Very High Trust
- 550–699: High Trust
- 400–549: Moderate Trust
- 250–399: Low Trust
- 0–249: High Risk

**Regenerates weekly** (every Sunday at 00:00 UTC).
```

---

## UPDATE D: EVIDENCE VAULT WEIGHTING RULES

### Location: SECTION 26.8 - REPLACE existing text (lines 5336-5352)

### REPLACE:

```markdown
### 26.8 Impact on TrustScore

**High-Quality Evidence:**
- IntegrityScore 90-100
- Full weight applied to Evidence component (up to 300 points)

**Questionable Evidence:**
- IntegrityScore 50-69
- 50% weight applied
- User encouraged to upload better quality evidence

**Rejected Evidence:**
- IntegrityScore < 50
- Zero weight
- RiskSignal created
- User notified: "This evidence could not be verified"
```

### WITH:

```markdown
### 26.8 Impact on TrustScore & Evidence Vault Weighting Rules

**CRITICAL VAULT RULE:**

**Evidence Vault contributes MAXIMUM 10-15% of TrustScore.**

**Definition:** "Evidence Vault" = User-uploaded screenshots, documents, and supporting materials (NOT including Level 3 verified profiles or email receipts).

**Rationale:**
- Vault evidence is EASILY FAKED (Photoshop, fake PDFs)
- Vault acts as REINFORCEMENT, not primary trust source
- Primary trust comes from: Identity verification, Level 3 profiles, email receipts, peer confirmations

**Vault Contribution Cap:**
- TrustScore max: 1000 points
- Evidence component max: 300 points
- Vault max: 45 points (15% of 300)

**Vault Evidence Types:**
- Screenshots of marketplace reviews/stats
- Uploaded receipts (manually added, NOT via email parsing)
- Profile screenshots (NOT Level 3 verified URLs)
- Supporting documents (shipping labels, tracking info)

**How Vault Evidence is Weighted:**

**High-Quality Vault Evidence (IntegrityScore 90-100):**
- First 5 items: 5 pts each (25 pts total)
- Next 5 items: 2 pts each (10 pts total)
- Additional items: 1 pt each (max 10 pts total)
- **Maximum from Vault: 45 points**

**Acceptable Vault Evidence (IntegrityScore 70-89):**
- 50% weight applied
- First 5 items: 2.5 pts each
- Encouragement: "Upload higher quality evidence for full credit"

**Questionable Vault Evidence (IntegrityScore 50-69):**
- 25% weight applied
- Flagged for admin review
- User notified: "This evidence quality is low"

**Rejected Vault Evidence (IntegrityScore < 50):**
- Zero weight
- RiskSignal created (type: FraudulentEvidence)
- User notified: "This evidence could not be verified"

**Vault Reinforcement Rules:**

**Vault evidence ONLY contributes if it MATCHES verified platform behavior:**

**Example 1: Consistent**
- User has Level 3 verified Vinted profile (4.8★, 300 transactions)
- User uploads 10 high-quality Vinted screenshots showing transactions
- Screenshots match profile username, dates, transaction count
- **Vault contribution: 25 points** (reinforces verified behavior)

**Example 2: Inconsistent**
- User has Level 3 verified Vinted profile (50 transactions)
- User uploads 100 screenshots claiming 500 transactions
- Mismatch detected: screenshots don't align with verified profile
- **Vault contribution: 0 points** (inconsistent, likely fake)

**Example 3: No Verification**
- User has NO Level 3 verified profiles
- User uploads 50 screenshots from various platforms
- No way to verify legitimacy
- **Vault contribution: 5-10 points MAX** (assumed low quality without verification)

**Multi-Year Consistency Adds Trust:**
- User uploads receipts spanning 3+ years
- Receipts align with verified profile join date and activity patterns
- **Bonus: +10 points** (long-term consistent behavior)

**Bulk Upload Detection:**
- User uploads 100+ items in <1 hour
- **Red flag:** Possible automated fake evidence generation
- **Action:** All items flagged for review, Vault contribution paused until admin verification

**Vault Fraud Patterns (Zero Contribution):**
- All screenshots identical resolution/format (batch-generated)
- All screenshots from same date (fake timestamp)
- Duplicate evidence across multiple users (hash collision)
- Evidence metadata doesn't match user's device/IP history
- OCR text extraction shows copy-paste patterns

**Evidence Component Distribution (Updated):**
```
Evidence (300 pts) =
  Level 3 Verified Profiles (0-150 pts) +
  Email Receipts (0-75 pts) +
  Evidence Vault (0-45 pts) +
  Mutual Verifications moved to Peer (30 pts transferred)
```

**Vault UI Display:**
```
Evidence Vault: 12/45 pts
⚠️ Vault evidence contributes max 15% of TrustScore.
💡 Verify your profiles to increase trust.
```

**Admin Override:**
- If admin determines vault evidence is exceptionally high-quality AND user has strong identity verification
- Admin can manually boost vault contribution by max +10 pts
- Requires justification + logged in AdminAuditLogs
```

---

## UPDATE E: EMAIL RECEIPT SCANNING (Expensify Model)

### Location: SECTION 5 - Within "Email Receipts" subsection (lines 560-570)

### REPLACE EXISTING EMAIL RECEIPTS TEXT WITH:

```markdown
**1. Email Receipts:**

**Expensify-Inspired Email Model:**

SilentID uses a **unique forwarding alias** system inspired by Expensify's receipt scanning approach. This ensures maximum privacy while enabling automated receipt detection.

**How It Works:**

**1. Unique Forwarding Alias:**
- Each user receives a unique email forwarding address:
  - Format: `{userId}.{randomString}@receipts.silentid.co.uk`
  - Example: `user12345.a7b3c9@receipts.silentid.co.uk`
- User forwards receipts to this alias (or sets up automatic forwarding)

**2. Shared Inbox Routing:**
- All aliases route to a single shared inbox: `receipts@silentid.co.uk`
- Backend processes incoming emails in real-time
- Email alias used to identify user (no inbox connection required)

**3. Metadata-Only Extraction:**
SilentID extracts ONLY:
- **Seller/Platform:** eBay, Vinted, Depop, Etsy, PayPal, Stripe
- **Transaction Date:** When order was placed
- **Amount:** Transaction value (£, €, $)
- **Item Description:** What was purchased/sold
- **Order ID:** Platform's order reference number
- **Buyer/Seller Role:** Whether user was buyer or seller

**SilentID does NOT store:**
- ❌ Full email body
- ❌ Email subject lines (beyond sender detection)
- ❌ Sender's personal email address
- ❌ Any personal correspondence

**4. Immediate Deletion:**
- After extraction, raw email is **immediately deleted** from server
- Only metadata summary is stored in `ReceiptEvidence` table
- Retention: Summary stored until user deletes account (max 7 years for legal compliance)

**5. Supported Senders:**
- Vinted: `noreply@vinted.com`, `receipts@vinted.co.uk`
- eBay: `ebay@ebay.com`, `ebay@ebay.co.uk`
- Depop: `hello@depop.com`, `receipts@depop.com`
- Etsy: `transaction@etsy.com`
- PayPal: `service@paypal.com`
- Stripe: `receipts@stripe.com`
- Facebook Marketplace: `notification@facebookmail.com`

**Optional: Limited Gmail API (Alternative Method):**

If user prefers NOT to forward emails:

**Gmail OAuth Scope (Read-Only, Receipt-Only):**
- Scope: `https://www.googleapis.com/auth/gmail.readonly`
- Filter: Only emails from known marketplace senders
- Query: `from:(vinted.com OR ebay.com OR depop.com OR etsy.com OR paypal.com OR stripe.com)`
- Frequency: Daily batch scan (not real-time)
- Same extraction + immediate deletion rules apply

**User chooses ONE method:**
1. **Forwarding Alias** (recommended, no inbox access required)
2. **Gmail OAuth** (requires limited inbox permission)

**Privacy Guarantees:**
- ✅ SilentID never reads personal emails
- ✅ Only transaction receipts from known platforms are scanned
- ✅ User can disconnect at any time (all future receipts ignored)
- ✅ Raw emails deleted immediately after extraction
- ✅ No email content stored (only transaction summaries)

**DKIM/SPF Validation:**
- All receipts verified for sender authenticity (prevent fake forwarded emails)
- Receipts without valid DKIM/SPF signatures are flagged for review

**Database Schema:**

```sql
-- Add to ReceiptEvidence table (Section 8)
ALTER TABLE ReceiptEvidence ADD COLUMN ForwardingAlias VARCHAR(255) NULL;
ALTER TABLE ReceiptEvidence ADD COLUMN ExtractionMethod VARCHAR(50); -- 'Forwarding' or 'GmailOAuth'
ALTER TABLE ReceiptEvidence ADD COLUMN DKIMValid BOOLEAN DEFAULT FALSE;
ALTER TABLE ReceiptEvidence ADD COLUMN SPFValid BOOLEAN DEFAULT FALSE;
```

**TrustScore Contribution:**
- Each verified receipt contributes 1-3 points to Evidence component (max 75 pts from receipts)
- Receipts with valid DKIM/SPF get full weight
- Receipts without validation get 50% weight (flagged for review)

**API Endpoints:**

```
POST /v1/evidence/receipts/get-forwarding-alias (User)
POST /v1/evidence/receipts/connect-gmail (User) -- OAuth flow
POST /v1/evidence/receipts/disconnect (User)
GET /v1/evidence/receipts (User) -- List all extracted receipts
DELETE /v1/evidence/receipts/{id} (User)
```

**User Flow:**

**Step 1: Get Forwarding Alias**
- User navigates to Settings > Evidence > Email Receipts
- Button: "Get My Receipt Forwarding Address"
- Display: `user12345.a7b3c9@receipts.silentid.co.uk`
- Instruction: "Forward your marketplace receipts to this address, or set up automatic forwarding in your email settings."

**Step 2: Forward Receipts**
- User forwards past receipts manually
- OR: User sets up email filter (Gmail: forward all from vinted.com to alias)

**Step 3: Automatic Processing**
- SilentID backend receives email at shared inbox
- Identifies user by alias
- Extracts metadata
- Deletes raw email
- Updates TrustScore

**Step 4: View Receipts**
- User sees: "12 receipts verified (£450 total transactions)"
- List shows: Date, Platform, Amount, Role (Buyer/Seller)

**Anti-Fraud Measures:**
- Rate limiting: Max 50 forwarded emails per day per user
- Duplicate detection: Same order ID rejected if already submitted
- Timing validation: Receipt date must be within last 5 years
- Cross-user collision: Same receipt forwarded by multiple users = both flagged
```

---

## UPDATE F: ANTI-FAKE & ANTI-CHEAT ARCHITECTURE (Strengthening Existing Sections)

### Location 1: SECTION 7 - Anti-Fraud Engine (After line 901, within existing 9 layers)

### INSERT NEW PARAGRAPH WITHIN "9 Major Scam Methods & Defenses":

```markdown
**SCAM #10: Fake External Ratings & Profile Ownership Fraud**
- **Attack:** User links to someone else's high-rated marketplace profile, or manually enters fake star ratings
- **Defense:**
  - **Level 3 Verification Required:** Ratings ONLY extracted from profiles with proven ownership (Token-in-Bio or Share-Intent)
  - **No Manual Entry:** Users CANNOT manually input ratings or star scores
  - **Screenshot Ratings Ignored:** Screenshots of star ratings contribute ZERO to URS (only live-scraped data from verified profiles)
  - **Ownership Locking:** One profile can only be verified by ONE SilentID account
  - **Snapshot Hashing:** Profile HTML snapshot hashed (SHA-256) at verification time; if profile changes significantly after verification, re-verification required
  - **Cross-Platform Consistency:** If user has 4.9★ on Vinted but 2.1★ on eBay (verified), system flags outlier and reduces URS weight
- **Result:** Fake ratings = ZERO contribution to URS, unverified profiles = ZERO, ownership fraud detected = account suspended

**STRENGTHENED ANTI-FAKE GUARANTEE:**

**What CANNOT be faked in SilentID:**

1. **Identity:**
   - ✅ Stripe Identity verification (government ID + selfie liveness)
   - ✅ Cannot fake: ID documents, biometric selfies
   - ✅ If attempted: Stripe detects fake IDs, account suspended

2. **External Ratings (URS):**
   - ✅ ONLY from Level 3 verified profiles (ownership proven)
   - ✅ Cannot fake: Token-in-Bio requires account control, Share-Intent requires platform authentication
   - ✅ Screenshots of ratings: IGNORED (contribute ZERO)
   - ✅ Manual entry: DISABLED (no UI to input ratings)
   - ✅ Linking to others' profiles: BLOCKED by ownership locking

3. **Email Receipts:**
   - ✅ DKIM/SPF validation required
   - ✅ Cannot fake: Receipts without valid signatures flagged
   - ✅ If attempted: Fake forwarded emails rejected, user flagged

4. **Evidence Vault (Screenshots/Docs):**
   - ✅ Max 15% of TrustScore (45 pts cap)
   - ✅ Tampered screenshots: Detected by image integrity engine (Section 26)
   - ✅ Bulk fake uploads: Detected by pattern analysis
   - ✅ Cannot override: Vault evidence NEVER overrides verified behavior

5. **Mutual Verifications:**
   - ✅ Requires both parties to confirm transaction
   - ✅ Collusion rings: Detected by graph analysis (Section 37)
   - ✅ Cannot fake: Circular patterns flagged, IP/device clustering detected

**ANTI-FAKE ENFORCEMENT:**

If user attempts to fake any component:
1. **First attempt:** Warning + evidence rejected
2. **Second attempt:** RiskScore increased (+30), evidence uploads disabled for 7 days
3. **Third attempt:** Account suspended, manual admin review required
4. **Confirmed fraud:** Permanent ban, all TrustScore contributions set to zero
```

---

### Location 2: SECTION 26 - Evidence Integrity Engine (After line 5354, within existing content)

### INSERT NEW SUBSECTION AFTER "26.8 Impact on TrustScore":

```markdown
### 26.9 Anti-Fake Reinforcement Rules

**CRITICAL: Evidence Vault Cannot Override Verified Behavior**

**Vault Evidence Hierarchy:**

1. **Level 3 Verified Profiles (Highest Trust):**
   - Live-scraped ratings from ownership-proven profiles
   - Contributes 0-150 pts to Evidence component
   - **Cannot be faked** (ownership locked, snapshot hashed)

2. **Email Receipts (High Trust):**
   - DKIM/SPF validated transaction confirmations
   - Contributes 0-75 pts to Evidence component
   - **Difficult to fake** (requires email sender authentication)

3. **Evidence Vault (Low Trust, Capped at 45 pts):**
   - User-uploaded screenshots and documents
   - Contributes MAX 45 pts (15% of Evidence component)
   - **Easily fakeable** (Photoshop, fabricated docs)
   - **MUST align with verified behavior** to contribute

**Vault Rejection Rules:**

**Automatic Rejection (Zero Contribution):**
- Screenshot tampered (detected by Layer 3 tampering detection)
- OCR text inconsistent with known platform formats
- Metadata suspicious (wrong device, wrong timezone)
- Duplicate hash across multiple users
- Uploaded in bulk (>20 items in <10 minutes)

**Flagged for Review (Zero Contribution Until Verified):**
- IntegrityScore < 50
- Vault evidence contradicts Level 3 verified profile data
- User uploads 10+ items from platform they have NO verified profile on
- Evidence quality suddenly improves (suggests outsourcing/buying fake evidence)

**Reinforcement-Only Rule:**

**Vault evidence ONLY adds points if it REINFORCES already-verified behavior.**

**Example 1: Reinforcement (Allowed)**
- User has Level 3 verified Vinted profile: 4.8★, 300 transactions
- User uploads 15 Vinted screenshots showing transactions from past 2 years
- Screenshots match verified username, dates align with account age
- **Vault contribution: 20 points** (reinforces verified behavior)

**Example 2: Contradiction (Rejected)**
- User has Level 3 verified eBay profile: 3.2★, 50 transactions
- User uploads 100 eBay screenshots claiming 500 transactions, 4.9★
- Screenshots contradict verified profile data
- **Vault contribution: 0 points** (inconsistent, likely fake)

**Example 3: No Verification (Limited)**
- User has NO Level 3 verified profiles
- User uploads 50 screenshots from multiple platforms
- No way to verify legitimacy
- **Vault contribution: 5-10 points MAX** (assumed low quality)

**Fake Screenshot Detection (Enhanced):**

**Layer 1: Metadata Forensics**
- EXIF data tampered or missing → IntegrityScore -20
- Screenshot timestamp in future → Rejected
- Device model inconsistent with user's known devices → Flagged

**Layer 2: Visual Analysis**
- Known platform UI doesn't match screenshot layout → Rejected
- Font rendering inconsistent with platform branding → Flagged
- Color palette doesn't match platform colors → IntegrityScore -15

**Layer 3: Pixel-Level Tampering**
- Clone stamping detected → Rejected
- Copy-paste artifacts detected → Rejected
- Edge inconsistencies (text overlayed) → IntegrityScore -30

**Layer 4: Cross-Reference Validation**
- Username in screenshot doesn't match verified profile → Rejected
- Rating in screenshot doesn't match live-scraped rating → Rejected
- Transaction count in screenshot wildly different from verified profile → Flagged

**If ANY Layer fails → Screenshot contributes ZERO to TrustScore**

**Fake Receipt Detection (Enhanced):**

**DKIM/SPF Validation (Mandatory):**
- Receipt forwarded without valid DKIM signature → 50% weight
- Receipt forwarded without valid SPF record → Flagged for review
- Receipt with forged headers → Rejected + RiskSignal created

**Sender Domain Validation:**
- Receipt claims to be from `vinted.com` but sent from `gmail.com` → Rejected
- Receipt HTML doesn't match known marketplace templates → Flagged
- Receipt contains suspicious links or attachments → Rejected

**Cross-User Duplicate Detection:**
- Same order ID submitted by multiple users → Both users flagged
- Same receipt hash across accounts → RiskSignal + admin review

**Timestamp Validation:**
- Receipt date in future → Rejected
- Receipt date >5 years old → 50% weight (outdated evidence)
- Receipt date doesn't align with user's account age → Flagged

**Anti-Fake Guarantee Statement:**

**SilentID's TrustScore is designed to be UNFAKEABLE:**

1. **Identity Component (200 pts):** Requires Stripe Identity (government ID + liveness) — Cannot be faked
2. **Evidence Component (300 pts):**
   - Level 3 Verified Profiles (0-150 pts): Ownership-proven, live-scraped — Cannot be faked
   - Email Receipts (0-75 pts): DKIM/SPF validated — Difficult to fake
   - Evidence Vault (0-45 pts): Capped at 15%, reinforcement-only — Minimal impact if faked
3. **Behaviour Component (300 pts):** Based on platform activity, no safety reports — Cannot be faked (external data)
4. **Peer Component (200 pts):** Mutual verifications, collusion-detected — Difficult to fake at scale
5. **URS Component (200 pts):** Live-scraped from verified profiles only — Cannot be faked

**Total: 1000 points (normalized from 1200 raw)**

**If user attempts to fake ANY component:**
- Evidence rejected → Zero contribution
- RiskScore increased → Account restrictions
- Repeated attempts → Permanent ban

**SilentID's Mission: Honest people rise. Scammers fail.**
```

---

## SPECIFICATION COMPLETE

All 6 updates (A-F) have been drafted with exact insertion/replacement points.

**Next Phase:** Generate complete updated CLAUDE.md file by applying all updates.
