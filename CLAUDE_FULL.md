# SILENTID - MASTER SPECIFICATION DOCUMENT

**Version:** 1.8.0
**Last Updated:** 2025-11-24
**Status:** Pre-Development - Complete Specification (Updated with 5-Component TrustScore)

---

## TABLE OF CONTENTS

1. [Project Overview](#project-overview)
2. [Section 0: Claude Behavior & Working Mode](#section-0-claude-behavior--working-mode)
3. [Section 1: Vision & Purpose](#section-1-vision--purpose)
4. [Section 2: Branding & Visual Identity](#section-2-branding--visual-identity)
5. [Section 3: System Overview](#section-3-system-overview)
6. [Section 4: Legal & Compliance](#section-4-legal--compliance)
7. [Section 5: Core Features](#section-5-core-features)
8. [Section 6: Feature Flows & UI Copy](#section-6-feature-flows--ui-copy)
9. [Section 7: Anti-Fraud Engine](#section-7-anti-fraud-engine)
10. [Section 8: Database Schema](#section-8-database-schema)
11. [Section 9: API Endpoints](#section-9-api-endpoints)
12. [Section 10: Frontend Architecture](#section-10-frontend-architecture)
13. [Section 11: Implementation Phases](#section-11-implementation-phases)
14. [Section 12: Monetisation](#section-12-monetisation)
15. [Section 13: Pre-Coding Checklist](#section-13-pre-coding-checklist)
16. [Section 14: SilentID Admin Dashboard](#section-14-silentid-admin-dashboard)
17. [Section 15: SilentID Security Center](#section-15-silentid-security-center)
18. [Section 16: Monetization — Security Center Integration](#section-16-monetization--security-center-integration)
19. [Section 17: Safe Development Rules](#section-17-safe-development-rules)
20. [Section 18: Domain Structure](#section-18-domain-structure)
21. [Section 19: SilentID Help Center System](#section-19-silentid-help-center-system)
22. [Section 20: Critical System Requirements](#section-20-critical-system-requirements)
23. [Section 21: SilentID Landing Page](#section-21-silentid-landing-page)

---

## PROJECT OVERVIEW

**SilentID** is a standalone passwordless trust-identity application that allows users to build a portable reputation profile across marketplaces, dating apps, rental platforms, and community groups.

### Core Technology Stack
- **Frontend:** Flutter (iOS + Android)
- **Backend:** ASP.NET Core Web API
- **Database:** PostgreSQL (Local dev, Azure prod later)
- **Auth:** 100% Passwordless (Apple Sign-In, Google Sign-In, Passkeys, Email OTP)
- **Identity Verification:** Stripe Identity
- **Billing:** Stripe Billing
- **Primary Color:** Royal Purple `#5A3EB8`
- **UI Style:** Bank-grade, clean, secure, serious

### Key Principles
- **NO passwords stored** - ever
- **NO ID documents stored** - Stripe Identity handles this
- **Evidence-based trust** - receipts, screenshots, public profiles
- **Anti-fraud first** - comprehensive risk engine
- **GDPR compliant** - privacy by design
- **Defamation-safe language** - never accuse, only present evidence

---

## SECTION 0: CLAUDE BEHAVIOR & WORKING MODE

### Vibe Coding Mode (Mandatory for Implementation)

**Core Rules:**
1. **Tiny steps only** - small, digestible chunks
2. **Always explain in simple language** - no jargon without translation
3. **No assumptions about user knowledge** - explain everything
4. **Explicit step boundaries** - clear labeling and expectations
5. **Interactive loop** - explain → action → expected result → wait for confirmation
6. **Error handling** - never ignore, always explain and fix
7. **No big leaps** - many small verify-as-you-go steps

**Tone:**
- Calm, professional, reassuring, respectful, non-patronizing
- Bank-grade seriousness without being cold
- Short explanations, deep when needed

**User Context:**
- Uses VS Code + CLI
- NOT technical
- Will rely entirely on Claude for commands, file edits, troubleshooting

**Claude Role:**
Paired-programming session with Claude as senior engineer and user as keyboard.

---

## SECTION 1: VISION & PURPOSE

### Core Statement
SilentID is a **universal trust passport** for the entire internet. It verifies *who* a person is and *how they behave* across all online and offline interactions.

**Core Question:** "Is this person likely trustworthy to deal with?"

### The Problem
People are forced to trust complete strangers across marketplaces, dating apps, Facebook groups, Telegram chats, and real-world meetups with **zero independent verification**.

Traditional platforms keep trust *locked inside their ecosystem*.

### The Solution
A **portable, evidence-backed trust profile** that works everywhere:
- Marketplaces (Vinted, Depop, eBay, Etsy, Facebook Marketplace)
- Dating & social apps (Tinder, Bumble, Hinge, Instagram DMs)
- Renting (rooms, apartments, roommates)
- Local services (cleaners, tutors, tradespeople)
- Freelancers & gig workers
- Community groups & parent groups
- In-person meetups
- Gaming trades & digital item exchanges

### The Trust Triangle
1. **WHO YOU ARE** - Identity (Stripe verification)
2. **WHAT YOU'VE DONE** - Behavior (receipts, screenshots, peer confirmations)
3. **HOW YOU ACT NOW** - Consistency (patterns, disputes, verified reports)

### Brand Essence
- **Sentence:** "SilentID is the passport of trust for the real world and the digital world."
- **Feeling:** "Bank-grade security, Apple-level design, Stripe-level transparency."
- **Promise:** "Honest people rise. Scammers fail."

### Primary Audiences
1. Everyday people (avoiding scams on marketplaces)
2. Sellers on marketplaces (portable seller badge)
3. Buyers (verify before you buy)
4. Renters / room-seekers (ID + behavioral verification)
5. Freelancers & gig workers (trust CV)
6. Community groups & parents (safety screening)
7. Dating users (ID verification + safety signals)

---

## SECTION 2: BRANDING & VISUAL IDENTITY

### Core Brand Color
**Primary:** Royal Purple `#5A3EB8`

**Secondary Palette:**
- Dark Mode Purple: `#462F8F`
- Soft Lilac (backgrounds): `#E8E2FF`
- Deep Neutral Black: `#0A0A0A`
- Pure White: `#FFFFFF`
- Neutral Gray 900: `#111111`
- Neutral Gray 700: `#4C4C4C`
- Neutral Gray 300: `#DADADA`
- Success Green: `#1FBF71`
- Warning Amber: `#FFC043`
- Danger Red: `#D04C4C`

### Brand Personality
**MUST feel:** Serious, calm, professional, high-trust, evidence-driven, neutral, premium, minimal, precise

**NEVER feel:** Juvenile, social-media style, cartoonish, overly marketing, playful, loud, "startup cheap"

**Think:** "Apple × Stripe × Revolut × Bank-level identity"

### Typography
**Primary Font:** Inter (only font used)
- Inter Bold (titles)
- Inter Semibold (subtitles)
- Inter Regular (body text)
- Inter Medium (buttons)
- Inter Light (hints/help text)

**Fallbacks:** San Francisco (iOS), Roboto (Android), System UI (web)

### Button Design
**Primary Button:**
- Background: `#5A3EB8`
- Text: `#FFFFFF`
- Corners: 12–14px radius
- Height: 52–56px
- Weight: Medium
- Shadow: minimal (0–2px blur)

**Secondary Button:**
- Background: Transparent
- Border: 1.5px solid `#5A3EB8`
- Text: `#5A3EB8`
- Height: 52px

**Danger Button:**
- Background: `#D04C4C`
- Text: `#FFFFFF`

### Layout Style
- Full-width sections
- 20–24px horizontal padding
- 16–24px top spacing
- Clean white background
- Generous spacing for "trustworthy" feel
- Strong alignment rules
- Only purple for highlights

### User Name Display Rules (CRITICAL FOR PRIVACY/LEGAL)
**Default public display:**
- Display Name: "Sarah M."
- Username: @sarahtrusted

**NEVER publicly show:**
- Full legal name
- Surname
- Address
- Date of birth
- Phone/email
- ID documents

**Reason:** GDPR compliance, privacy, defamation safety, personal safety

### Brand Consistency Checklist (Enforce on Every UI Screen)
- [ ] Primary purple #5A3EB8 used correctly
- [ ] Inter font used
- [ ] Modern and minimalist shapes
- [ ] Feels like bank/security app
- [ ] Avoids playful, social, cartoon elements
- [ ] User's identity protected by default
- [ ] Privacy-safe information shown
- [ ] Sufficient white space
- [ ] Professional and calm tone
- [ ] Buttons large, clear, accessible
- [ ] Layout clean and non-cluttered

---

## SECTION 3: SYSTEM OVERVIEW

### High-Level Architecture
**SilentID = Identity Layer + Evidence Layer + Behaviour Layer + Trust Engine + Public Profile Layer**

### 10 Major Modules
1. **Identity Verification** (Stripe Identity)
2. **Authentication** (100% Passwordless: Apple, Google, Passkeys, Email OTP)
3. **User Profiles** (Private + Public layers)
4. **Evidence Collectors** (email receipts, screenshots, public profile scrapers)
5. **Mutual Transaction Verification**
6. **TrustScore Engine** (0–1000)
7. **Risk & Anti-Fraud Engine**
8. **Safety Reports & Dispute Review**
9. **Public Profile Viewer**
10. **Admin Console & Audit Logs**

### System Components
**Frontend (Flutter):**
- iOS + Android + Web
- Passkeys + OTP login flows
- Profile creation
- Public profile viewing
- Evidence upload
- Screenshot OCR interface
- Stripe Identity flow
- TrustScore display
- Linking & sharing profiles
- Report submission
- Secure sessions

**Backend (ASP.NET Core):**
- All business logic
- Stripe connection
- TrustScore management
- Risk Engine
- User + evidence storage
- Email OTPs
- Public profile generation
- Logs & audits
- Admin tools

**Database (PostgreSQL):**
- Users
- Identity-verification status
- Uploaded evidence
- Receipts extracted
- Screenshot metadata
- Transactions verified
- TrustScore components
- Anti-fraud flags
- Reports
- Logs
- Encrypted data

**File Storage (Azure Blob Storage):**
- Screenshots
- Receipts (images/PDFs)
- Profile proof documents
- Hashed references, not raw names

**Third-Party Integrations:**
- Stripe Identity (ID verification)
- SendGrid / AWS SES (email)
- Azure Cognitive Services (OCR & image verification)
- Playwright (public profile scraping)

### Evidence Sources
1. **Email Receipts:**
   - Connect inbox (IMAP OAuth or forward)
   - AI extracts: date, amount, item, buyer/seller role, platform
   - Each receipt = verified transaction evidence

2. **Screenshots:**
   - Upload screenshot
   - OCR + image integrity check
   - Extract: ratings, reviews count, join date, username consistency

3. **Public Profile URL:**
   - User enters URL (Vinted, eBay, Depop, etc.)
   - SilentID scrapes: review count, rating, join date, listing styles, behavioral info
   - Fully legal (only public pages, user explicitly requests)

### TrustScore Engine (0–1000)

**Version 1.8.0 Update:** TrustScore now uses **5 components** with raw max of 1200 points, normalized to 1000.

**Calculation Formula:**
```
Raw Score = Identity + Evidence + Behaviour + Peer + URS (max 1200)
Final TrustScore = (Raw Score / 1200) × 1000 (normalized to 0-1000)
```

**5-Component Breakdown:**
- **Identity (200 pts):** Stripe verification, email verified, phone verified, device consistency
- **Evidence (300 pts):** receipts, screenshots, public profile data, evidence quality (capped at 15% per vault)
- **Behaviour (300 pts):** no reports, on-time shipping, account longevity, cross-platform consistency
- **Peer Verification (200 pts):** mutual endorsements, returning partner transactions
- **URS - Universal Reputation Score (200 pts):** Cross-platform ratings aggregation from verified external profiles

**Score Labels (Updated):**
- 850–1000: Exceptional Trust (NEW)
- 700–849: Very High Trust
- 550–699: High Trust
- 400–549: Moderate Trust
- 250–399: Low Trust
- 0–249: High Risk

**Regenerates weekly.**

### Public Profile System
**URL format:** `https://silentid.app/u/sarahtrusted`

**Shows:**
- Display name ("Sarah M.")
- Username (@sarahtrusted)
- TrustScore + label
- Identity Verified badge
- Verified platforms
- Number of receipts parsed
- Number of mutual verifications
- Account age
- Risk warnings (gentle wording if applicable)
- QR code for sharing

**Never shows:**
- Full legal name
- Address
- ID document data
- Email
- Phone
- Raw evidence

---

## SECTION 4: LEGAL & COMPLIANCE

### Core Legal Positioning
**SilentID IS:**
- A trust-support tool
- A reputation aggregator
- A safety indicator layer
- A neutral intermediary

**SilentID IS NOT:**
- Credit reference agency
- Criminal records provider
- Insurer or guarantee provider
- Law enforcement agency
- Background-check/"clearance" service
- Marketplace or transaction platform

### GDPR / Data Protection
**Lawful Basis for Each Data Type:**
1. Core account/security → Legitimate Interest
2. Email receipt scanning → Explicit Consent (opt-in, revocable)
3. Screenshot uploads → Consent + Legitimate Interest (fraud prevention)
4. Public profile scraping → Legitimate Interest (user's explicit request)
5. Risk & anti-fraud → Legitimate Interest (fraud prevention)

**Data Subject Rights (Must Support):**
- ✅ Access (SAR) - see TrustScore, data, flags, risk decisions
- ✅ Rectification - correct mis-parsed data, challenge mappings
- ✅ Erasure - delete account/evidence (subject to fraud log retention)
- ✅ Restriction/Objection - opt out of email scraping, object to profiling
- ✅ Portability - export profile data (JSON/PDF)

**Data Minimization & Retention:**
- Store ONLY: what's needed for TrustScore, fraud prevention, explainability
- Don't store: full raw emails, unnecessary metadata, arbitrary logs
- Retention: 6-7 years max for security logs (EU/UK norms)
- On deletion: anonymize user-identifiable fields

### Identity Verification (Stripe) Rules
**Stripe handles:**
- ID document capture
- Selfie & liveness detection
- Cross-checking
- Storing sensitive data

**SilentID stores ONLY:**
- Verification status
- Reference ID
- Timestamp

**NEVER stores:**
- ID images
- Biometric data
- Raw documents

### Defamation & Reputation Protection
**Language Rules - NEVER state as fact:**
- ❌ "a scammer"
- ❌ "a fraudster"
- ❌ "untrustworthy"
- ❌ "a criminal"
- ❌ "dangerous"

**Always use cautious, evidence-based language:**
- ✅ "Safety concern flagged"
- ✅ "Multiple verified reports about this profile"
- ✅ "SilentID has identified risk signals based on user reports and evidence"
- ✅ "We recommend extra caution"

**Evidence Thresholds for Public Risk Labels:**
- Require: ≥3 independent reports from ID-verified users
- Require: credible evidence (receipts, messages, tracking)
- Require: human admin review

**Must Provide:**
- Clear appeal process
- Clear explanation (why flag exists, how to resolve)

### Public Profile Visibility Rules
**CAN Show:**
- Username, display name
- TrustScore + label
- Badges (Identity Verified, Email receipts, Peer-verified)
- Metrics (transaction count, platforms, account age)
- Safety metrics (with cautious wording)

**MUST NOT Show (by default):**
- Full legal name (unless explicit opt-in)
- Date of birth
- Address/postcode/location
- Phone/email
- Passport/ID numbers
- Device IDs/IP addresses
- Raw evidence content

### Email Access & Privacy Rules
**Before connecting email, must explain:**
- "We will only scan for receipts and order/shipping confirmations"
- "We do not read or store your personal emails"
- "You can disconnect at any time"

**Parsing scope:**
- Target: known sender domains (Vinted, eBay, Depop, Etsy, Stripe, PayPal)
- Limit: subject lines + bodies that look like receipts
- Avoid: general personal communications

**Storage:**
- Store: summary extraction (date, amount, direction, platform, item)
- Store: hash reference for integrity
- Don't store: full raw email body (unless fraud evidence required)

### 10 Non-Negotiable Legal Rules
1. ✅ No full legal names on public profiles by default
2. ✅ No raw ID documents stored in SilentID
3. ✅ Use Stripe Identity for ID checks; store only the result
4. ✅ Public wording must be defamation-safe ("safety concern", not "scammer")
5. ✅ Email access is explicit, narrow, revocable, transparent
6. ✅ Users can access, correct, delete, and export their data
7. ✅ TrustScore must be explainable in plain language
8. ✅ SilentID provides risk signals, not guarantees
9. ✅ Under-18s not allowed
10. ✅ Admin actions must be auditable

---

## SECTION 5: CORE FEATURES

### Authentication & Account Unification (Passwordless, No Duplicates)

**CRITICAL RULE: SilentID is 100% passwordless. NO passwords anywhere in the system.**

#### Supported Authentication Methods (ONLY these 4):

1. **Apple Sign-In** - Standard Apple OAuth, extracts email, handles private relay
2. **Google Sign-In** - Standard Google OAuth, extracts email
3. **Passkeys (WebAuthn/FIDO2)** - Face ID, Touch ID, Windows Hello, Android Biometrics
4. **Email OTP** - 6-digit one-time code sent to email

#### Explicitly FORBIDDEN:

- ❌ Password creation
- ❌ Password login
- ❌ "Set password" or "change password" flows
- ❌ Password reset / forgot password
- ❌ Password columns or hashes in database
- ❌ Any UI fields for passwords
- ❌ Magic links (removed - use OTP instead)
- ❌ SMS-only login (SMS allowed as 2FA backup only)

#### Single-Account Rule: One Real Person = One SilentID Account

**Core Principle:** Email address is the primary identity anchor. Each email can belong to ONLY ONE SilentID user.

##### Authentication Flow Logic:

**When Apple/Google/Passkey/OTP returns an email:**

1. **Check if email exists in system:**
   - **If YES** → Log into existing account (never create duplicate)
   - **If NO** → Run duplicate detection checks before creating new account

2. **For Apple Private Relay Emails:**
   - Treat each relay email as unique initially
   - Monitor device fingerprint + IP patterns
   - If strong signals suggest same person → offer account merge, not duplicate creation

3. **For Passkey Registration:**
   - Passkeys always bound to existing user account
   - If email exists → link passkey to that user
   - Never create second account for same email

4. **For Email OTP (New User):**
   - Before creating new user, check:
     - Device fingerprint matches existing user?
     - IP patterns match existing user?
     - Email alias patterns (e.g., user+alias@gmail.com)?
   - If duplicate signals detected:
     - **Block creation** with message: "This device is already associated with a SilentID account. Please use your existing login method."
   - Only create new user if NO duplicate signals

##### Duplicate Prevention System:

**Monitor and cross-reference:**
- Device fingerprint (SignupDeviceId)
- Browser/OS fingerprint (stored in AuthDevices)
- IP patterns (SignupIP)
- Email alias patterns (gmail+alias detection)
- Apple User ID (AppleUserId)
- Google User ID (GoogleUserId)
- Stripe Identity results (same person verification)

**Anti-Duplicate Actions:**
- New login appears to be duplicate/alias → DO NOT create second user
- Either:
  - Force login to existing account, OR
  - Block creation and create RiskSignal for admin review

##### Account Merging (Legitimate Users Only):

**When legitimate user has multiple login methods:**

If system detects two accounts likely belong to same person:

1. Offer explicit "Merge Accounts" flow
2. Require email ownership confirmation on both accounts
3. After merge:
   - Keep single unified SilentID user
   - Consolidate all evidence, TrustScore, login methods
   - Maintain audit trail of merge

**Merge Conditions:**
- Both accounts verified via Stripe Identity as same person
- User explicitly confirms ownership of both emails
- No fraud flags on either account

##### OAuth Provider Linking:

**Apple Sign-In:**
- Store AppleUserId in User table
- Link to existing account if email matches
- Handle private relay email separately but track for merge detection

**Google Sign-In:**
- Store GoogleUserId in User table
- Link to existing account if email matches
- Never create duplicate for same Google account

**Passkey:**
- Store in AuthDevices with IsTrusted = true
- Always link to existing user by email
- Enable for fast re-authentication

**Email OTP:**
- Verify email ownership
- Check for existing user before creation
- Link to existing account if email verified

##### Security & Session Management:

- Short-lived JWT access tokens (15 minutes)
- Refresh tokens in secure storage (7 days)
- Device fingerprinting for all auth methods
- Rate limiting on OTP requests (max 3 per 5 minutes)
- Suspicious login detection (new device, new IP, unusual time)
- Intercept repeated failed OTP attempts
- Force re-verification on high-risk signals

##### Database Fields (Users Table):

```sql
Email VARCHAR(255) UNIQUE NOT NULL  -- Primary identity anchor
AppleUserId VARCHAR(255) NULL       -- Apple Sign-In unique ID
GoogleUserId VARCHAR(255) NULL      -- Google Sign-In unique ID
IsEmailVerified BOOLEAN DEFAULT FALSE
IsPasskeyEnabled BOOLEAN DEFAULT FALSE
SignupIP VARCHAR(50) NULL           -- For duplicate detection
SignupDeviceId VARCHAR(200) NULL    -- For duplicate detection
```

**NEVER store:**
- Password
- PasswordHash
- PasswordSalt
- Any password-related fields

### Identity Verification (via Stripe)
**Two Levels:**
1. **Basic ID Verification:** Proves user is real person
2. **Enhanced ID Verification:** Required when reports exist, evidence conflicts, or high risk detected

**SilentID Stores ONLY:**
- Verification status
- Reference ID
- Timestamp

### Evidence Collection (3 Streams)
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
- No access to personal emails
- No storage of full email content
- DKIM/SPF validation for authenticity
- Immediate deletion after metadata extraction

**2. Screenshot OCR:**
- Upload: marketplace reviews, profile stats, sales history, ratings, badges
- Processing: Azure OCR, image forensics, screen consistency checks, metadata verification
- Must be tamper-resistant

**3. Public Profile URL Scraper:**
- Input: Vinted, Depop, eBay, Etsy, Facebook Marketplace, LinkedIn URLs
- Scraping: Playwright-based, headless, rate-limited, anti-fraud aware
- Extracts: ratings, review count, join date, listing patterns, username consistency

### Level 3 Profile Verification (v1.8.0 NEW)

**Purpose:** Cryptographically prove ownership of external marketplace profiles to prevent impersonation and fake profile linking.

**Two Verification Methods:**

#### **Method A: Token-in-Bio (for Type A Platforms)**
**Supported Platforms:** Vinted, Depop, eBay (any platform where users can edit profile bio/description)

**Flow:**
1. User submits external profile URL to SilentID
2. SilentID generates unique verification token: `SILENTID-VERIFY-{random-8-chars}`
3. User instructed to add token to their profile bio/description
4. User confirms "I've added the token"
5. SilentID scrapes profile via Playwright MCP
6. System checks for exact token match in bio text
7. If match found:
   - Profile marked as **Level 3 Verified**
   - Ownership locked (cannot be claimed by another SilentID account)
   - Profile snapshot hash (SHA-256) stored
   - User can remove token after verification
8. If not found: Verification fails, user can retry

**Security:**
- Token expires after 24 hours if not used
- Profile can only be verified by ONE SilentID account (ownership locking)
- Re-verification required every 90 days
- If profile deleted/unavailable during re-verify: verification drops to Level 1

#### **Method B: Share-Intent Verification (for Type B Platforms)**
**Supported Platforms:** Instagram, TikTok, X/Twitter (platforms with share buttons but no editable bio)

**Flow:**
1. User submits external profile URL
2. SilentID generates unique verification link: `https://silentid.co.uk/verify/{token}`
3. User instructed to:
   - Open their external profile
   - Tap "Share" button
   - Select "Copy Link" or "Share to another app"
   - Paste link into SilentID verification field
4. System validates:
   - URL matches submitted profile
   - Share action timestamp (must be within 5 minutes)
   - Device fingerprint consistency
5. If valid:
   - Profile marked as **Level 3 Verified**
   - Ownership locked
   - Profile snapshot stored
6. If invalid: User shown troubleshooting steps

**Security:**
- Share link expires after 5 minutes
- Device fingerprint must match SilentID session
- Profile can only be verified by ONE account
- Re-verification every 90 days

#### **Verification Levels Comparison:**

| Level | Method | Security | TrustScore Impact |
|-------|--------|----------|-------------------|
| **Level 1** | URL submission only | Low (no ownership proof) | Base profile weight |
| **Level 2** | Username cross-check | Medium (fuzzy matching) | +10% profile weight |
| **Level 3** | Token-in-Bio or Share-Intent | High (cryptographic proof) | +50% profile weight + URS eligibility |

**Anti-Fraud Rules:**
- Only Level 3 verified profiles contribute to URS (Universal Reputation Score)
- Level 1/2 profiles contribute to Evidence component only (limited weight)
- If user attempts to verify profile already owned by another account → flagged for admin review
- Bulk profile submissions (>5 in 24h) → suspicious activity flag

**Database Schema (New Fields in ProfileLinkEvidence):**
```sql
VerificationLevel INT (1, 2, or 3)
VerificationMethod VARCHAR(50) ('TokenInBio', 'ShareIntent', 'None')
VerificationToken VARCHAR(100) (for Token-in-Bio)
OwnershipLockedAt TIMESTAMP
SnapshotHash VARCHAR(64) (SHA-256 of profile at verification time)
NextReverifyAt TIMESTAMP (90 days from verification)
```

### URS: Universal Reputation Score (v1.8.0 NEW)

**Definition:** URS aggregates ratings and reviews from **Level 3 verified** external profiles into a unified reputation score (0-200 points).

**Purpose:**
- Leverage existing trust users have built on other platforms
- Reward consistent cross-platform good behaviour
- Detect rating discrepancies (red flag for fraud)

**Calculation Method:**

**Step 1: Extract Platform Ratings (from Level 3 verified profiles only)**

For each verified profile, extract:
- **Platform Rating:** e.g., 4.8/5.0 on Vinted, 98% positive on eBay
- **Review Count:** Number of reviews/ratings
- **Account Age:** How long account has existed (in days)

**Step 2: Normalize Ratings to Common Scale**

Different platforms use different scales:
- Vinted: 5-star system (0-5)
- eBay: Percentage positive (0-100%)
- Depop: 5-star system (0-5)
- Etsy: 5-star system (0-5)

**Normalization Formula:**
```
Normalized Rating = (Platform Rating / Platform Max) × 100
```

Examples:
- Vinted 4.8/5.0 → (4.8/5.0) × 100 = 96%
- eBay 98% positive → Already 98%
- Depop 5.0/5.0 → (5.0/5.0) × 100 = 100%

**Step 3: Weight by Review Count & Account Age**

**Review Count Weight:**
- 1-10 reviews: 0.5x weight
- 11-50 reviews: 0.75x weight
- 51-100 reviews: 1.0x weight
- 101-500 reviews: 1.25x weight
- 500+ reviews: 1.5x weight

**Account Age Weight:**
- < 3 months: 0.5x weight
- 3-12 months: 0.75x weight
- 1-3 years: 1.0x weight
- 3-5 years: 1.25x weight
- 5+ years: 1.5x weight

**Combined Weight:**
```
Weight = (Review Count Weight + Account Age Weight) / 2
```

**Step 4: Calculate Weighted Average**

```
Weighted Score = Σ(Normalized Rating × Weight) / Σ(Weight)
```

**Step 5: Convert to 0-200 Point Scale**

```
URS Points = (Weighted Score / 100) × 200
```

**Example Calculation:**

User has 3 Level 3 verified profiles:

1. **Vinted:**
   - Rating: 4.9/5.0 → 98% normalized
   - Reviews: 150 (1.25x weight)
   - Age: 2 years (1.0x weight)
   - Combined Weight: (1.25 + 1.0) / 2 = 1.125
   - Weighted Score: 98 × 1.125 = 110.25

2. **eBay:**
   - Rating: 99% positive
   - Reviews: 420 (1.25x weight)
   - Age: 5 years (1.5x weight)
   - Combined Weight: (1.25 + 1.5) / 2 = 1.375
   - Weighted Score: 99 × 1.375 = 136.125

3. **Depop:**
   - Rating: 4.7/5.0 → 94% normalized
   - Reviews: 45 (0.75x weight)
   - Age: 1 year (1.0x weight)
   - Combined Weight: (0.75 + 1.0) / 2 = 0.875
   - Weighted Score: 94 × 0.875 = 82.25

**Final Weighted Average:**
```
(110.25 + 136.125 + 82.25) / (1.125 + 1.375 + 0.875) = 328.625 / 3.375 = 97.4%
```

**URS Points:**
```
(97.4 / 100) × 200 = 194.8 ≈ 195 points
```

**Anti-Fraud URS Rules:**

1. **Consistency Check:**
   - If rating variance > 20% between platforms → Flag for admin review
   - Example: Vinted 98%, eBay 60% → Suspicious

2. **Freshness Requirement:**
   - Ratings older than 180 days → 50% weight reduction
   - Profiles not re-verified in 90 days → Excluded from URS

3. **Minimum Threshold:**
   - Profile must have ≥10 reviews to contribute to URS
   - Profile must be ≥3 months old

4. **Cap per Platform:**
   - Maximum 3 profiles per platform type (e.g., max 3 eBay profiles)
   - Prevents gaming by creating multiple accounts on same platform

**Database Schema (New Table):**
```sql
CREATE TABLE ExternalRatings (
  Id UUID PRIMARY KEY,
  ProfileLinkId UUID REFERENCES ProfileLinkEvidence(Id),
  UserId UUID REFERENCES Users(Id),
  Platform VARCHAR(50), -- Vinted, eBay, Depop, Etsy
  PlatformRating DECIMAL(5,2), -- Raw rating from platform
  ReviewCount INT,
  AccountAge INT, -- In days
  NormalizedRating DECIMAL(5,2), -- 0-100 scale
  ReviewCountWeight DECIMAL(3,2),
  AccountAgeWeight DECIMAL(3,2),
  CombinedWeight DECIMAL(3,2),
  WeightedScore DECIMAL(6,2),
  ScrapedAt TIMESTAMP,
  ExpiresAt TIMESTAMP, -- 180 days from scrape
  CreatedAt TIMESTAMP
);
```

### Email Receipt Model Update (v1.8.0 - Expensify Model)

**Previous Model (v1.7.0):**
- User connects full inbox via OAuth/IMAP
- SilentID scans entire inbox for receipts
- Privacy concern: access to all emails

**New Model (v1.8.0):**
**Inspired by Expensify's receipt forwarding system**

**How It Works:**

1. **Unique Forwarding Alias:**
   - Each user receives unique email address: `{userId}.{random}@receipts.silentid.co.uk`
   - Example: `ab12cd34.x9kf@receipts.silentid.co.uk`

2. **User Setup:**
   - User creates email forwarding rule in their email client:
     - Gmail: Filter → Forward to SilentID alias
     - Outlook: Rules → Forward to SilentID alias
   - Filter rule: "From: *@vinted.co.uk OR *@ebay.com OR *@depop.com → Forward to SilentID"

3. **Processing:**
   - SilentID receives forwarded receipt
   - Extracts metadata ONLY:
     - Sender domain (vinted.co.uk, ebay.com)
     - Date
     - Order ID
     - Amount (if parsable)
     - Transaction type (order, shipment, refund)
   - Validates DKIM/SPF
   - **Immediately deletes raw email** after extraction

4. **Storage:**
   - Store: Extracted metadata summary (JSON)
   - Do NOT store: Full email body, attachments, personal content
   - Retention: Summary stored until user deletes or account closed

**Privacy Advantages:**
- ✅ SilentID never sees personal emails (only forwarded receipts)
- ✅ User controls which emails to forward
- ✅ No inbox OAuth access required
- ✅ Raw email deleted immediately (GDPR-compliant)
- ✅ User can stop forwarding anytime (just delete email rule)

**Security:**
- Unique alias per user prevents cross-contamination
- DKIM/SPF validation prevents spoofed receipts
- Rate limiting: Max 50 receipts per day per user
- Suspicious patterns (e.g., 100 identical receipts) → flagged

**Database Schema (Updated ReceiptEvidence):**
```sql
-- Add new columns:
ForwardingAlias VARCHAR(255) UNIQUE, -- User's unique receipt email
EmailMetadataJson JSONB, -- Extracted metadata (NOT full email)
RawEmailDeleted BOOLEAN DEFAULT TRUE -- Confirms raw email removed
```

### Mutual Transaction Verification
**Flow:**
1. User A logs transaction
2. SilentID notifies User B
3. User B confirms: role, item name, value, date, optional proof

**If both confirm:**
- High weight added to TrustScore
- Displayed publicly: "Mutually Verified Transaction"
- Immutable internal record

**Abuse Prevention:**
- Blocks: same account parties, over-verification, fake circular confirmation, "mutual boosting rings"
- Anti-collusion logic in risk engine

### Safety Features
**Warnings/Risk Flags:**
- "Safety concern flagged — multiple user reports."
- "Data inconsistency detected — please review carefully."
- "Low score due to unverified identity."

**Scam Report Pipeline:**
- User submits evidence
- Needs ≥3 verified reports for public flag
- Admin review required

**Meetup Safety Tools:**
- Share profile QR code
- See each other's TrustScore
- Timed verification code for in-person exchanges (future)

---

## SECTION 6: FEATURE FLOWS & UI COPY

### Authentication Flows

**Welcome Screen:**
- Title: "Welcome to SilentID"
- Subtitle: "Your portable trust passport."
- Buttons:
  - "Continue with Apple" (Apple Sign-In button, styled per Apple guidelines)
  - "Continue with Google" (Google Sign-In button, styled per Google guidelines)
  - "Continue with Email" (Email OTP)
  - "Use a Passkey" (WebAuthn/FIDO2)
- Footer: "By continuing, you agree to SilentID's Terms & Privacy Policy."
- Legal Notice: "SilentID never stores passwords. Your account is secured with modern passwordless authentication."

**Email Input Screen:**
- Title: "Enter your email"
- Placeholder: "you@example.com"
- Button: "Send Verification Code"
- Errors: "Please enter a valid email address." / "We couldn't send a code. Please try again."

**OTP Screen:**
- Title: "Check your email"
- Subtitle: "We've sent a 6-digit code to **you@example.com**"
- Input: • • • • • •
- Timer: "Resend code in 29s"
- Button: "Verify & Continue" (disabled until filled)
- Security Notice: "We monitor login patterns to prevent account abuse."

**Passkey Prompt:**
- Title: "Set up a Passkey"
- Description: "Use Face ID or your fingerprint to sign in instantly. No passwords. Maximum security."
- Buttons: "Create Passkey" (primary), "Maybe later" (secondary)

### Identity Verification Flows

**Pre-Verification Screen:**
- Title: "Verify your identity"
- Description: "SilentID uses Stripe to securely confirm you're a real person. We do **not** store your ID documents — Stripe handles everything."
- Bullet points:
  - Prevent impersonation
  - Strengthen your TrustScore
  - Unlock advanced features
- Button: "Start Verification" (primary)
- Legal Footer: "Your document photos are processed by Stripe, not SilentID."

**Status States:**
- Pending: "Your verification is in progress."
- Verified: "Identity Verified • Verified via Stripe"
- Failed: "Verification unsuccessful. Please try again."
- Needs Retry: "We couldn't verify your ID. You can attempt again."

### Evidence Collection Flows

**Connect Email Screen:**
- Title: "Verify your trading history"
- Description: "SilentID can securely scan your order receipts to build your trust profile.

We only read:
✔ Order confirmations
✔ Shipping confirmations
✔ Transaction receipts

We do **not** store personal emails."
- Buttons: "Connect Gmail", "Connect Outlook", "Connect via IMAP", "Forward emails instead"

**Upload Screenshot Screen:**
- Title: "Upload a screenshot"
- Subtitle: "We'll analyse it for verified activity."
- Button: "Choose screenshot"
- Accepted: Images, PDFs
- Warning: ⚠️ "This screenshot appears modified. Please upload a clean version." (if suspicious)

**Add Profile Screen:**
- Title: "Add your platform profile"
- Input: "Paste your public profile URL"
- Examples: https://vinted.com/member/123, https://www.ebay.com/usr/yourname
- Button: "Scan Profile"
- Errors: "This link isn't public." / "We couldn't scan this page." / "This link doesn't match your SilentID username."

### TrustScore Flows

**Overview Screen:**
- Title: "Your TrustScore"
- Big Number: 754
- Label: "High Trust"
- Sections: Identity (210/200), Evidence (180/300), Behaviour (240/300), Peer Verification (124/200)
- Button: "View Breakdown"

**Breakdown Screen:**
- Identity Verified via Stripe: +200
- 96 receipt-based transactions: +140
- 3 public profiles: +40
- 12 mutual verifications: +120
- No safety flags: +40

### Public Profile

**Example:**
- Title: "Sarah M. (@sarahtrusted)"
- TrustScore: 847 (Very High)
- Badges: Identity Verified, 500+ verified transactions, Excellent behaviour, Peer-verified user
- Button: "Share Profile"
- QR Code: "Scan to view this SilentID profile"

**Safety Warning Example:**
⚠️ **Safety Concern Reported**
Multiple users have submitted evidence about this profile.
Review carefully before proceeding.

### Safety Reports

**Create Report:**
- Title: "Report a safety concern"
- Options: Item never arrived, Evidence suggests misrepresentation, Aggressive behaviour, Payment issue, Other concern
- Upload Evidence: Screenshots, Receipts, Chat logs
- Button: "Submit Report"

**Report Submitted:**
"Thank you. Your report helps protect the community. A SilentID reviewer will examine it."

### Subscriptions

**Premium Paywall:**
- Title: "Upgrade to SilentID Premium"
- Body: "Get deeper insights into your trust profile, a larger evidence vault, and powerful tools to prove your reliability everywhere you trade."
- Bullets: Evidence Vault (100GB), Unlimited screenshots and receipts, Detailed TrustScore breakdown, Trust analytics & timeline, Premium profile badge
- Button: "Get Premium — £4.99/month"
- Subtext: "You can cancel anytime. Your plan will stay active until the end of the current billing period."

**Pro Paywall:**
- Title: "SilentID Pro — Built for power sellers and community leaders"
- Body: "Manage risk at scale, present a professional trust profile, and export organised evidence packs when you need them."
- Bullets: Everything in Premium, Bulk profile checks, Dispute & evidence pack generator, Trust certificate PDF, White-label sharing options, 500GB Evidence Vault
- Button: "Get Pro — £14.99/month"
- Subtext: "Ideal for high-volume sellers, landlords, and group admins."

---

## SECTION 7: ANTI-FRAUD ENGINE

### Architecture (9 Layers)
1. Evidence Integrity Layer
2. Identity & Behaviour Consistency Layer
3. Device/Browser Fingerprinting Layer
4. IP & Geo-Patterns Layer
5. Machine Learning Anomaly Detection (Phase 2)
6. Collusion Detection System (CDS)
7. Public Profile Mismatch Checker
8. Risk Scoring System (0–100)
9. Admin Review & Override System

### 9 Major Scam Methods & Defenses

**SCAM #1: Fake Screenshots**
- Attack: Photoshopped profiles, edited ratings, fake sales screenshots
- Defense: EXIF metadata check, pixel-level manipulation detection, edge inconsistency scanning, text alignment detection, OCR vs image mismatch, watermark validation
- If suspicious: TrustScore -40, RiskScore +30

**SCAM #2: Fake Email Receipts**
- Attack: Fabricated PDFs, edited order confirmations
- Defense: DKIM/SPF validation, sender domain authenticity, timestamp consistency, identical hash detection, HTML structure fingerprinting
- If fake: Receipts rejected, user flagged

**SCAM #3: Multiple Fake Accounts**
- Attack: Boost own profile, create mutual verifications, fake reputation
- Defense: Device fingerprint duplication, IP reuse, VPN/Tor patterns, same phone/email, same Stripe Identity ID
- If detected: All linked accounts frozen

**SCAM #4: Collusion / Reputation Boosting Rings**
- Attack: Groups confirm fake mutual transactions
- Defense: Collusion Detection System (CDS) - unusual verification density, circular patterns, amount pattern mismatches, IP/device/geo cross-referencing
- Result: TrustScore boost denied

**SCAM #5: Same ID on Many Accounts**
- Attack: One passport → many SilentID accounts
- Defense: Stripe Identity gives unique token, prohibit more than 1-2 accounts per verified person
- If detected: Auto-ban all except primary

**SCAM #6: Buying Verified Accounts**
- Attack: Attacker buys clean SilentID profile
- Defense: Behavior change detection (different device, typing rhythm, IP, time-of-day, marketplace mismatch)
- Response: Identity re-check, device re-auth, high-risk OTP-only mode, suspicious activity freeze

**SCAM #7: Fake Public Profiles**
- Attack: Enter link that belongs to someone else
- Defense: Username similarity matching, email fragment cross-verification, behavior patterns, transaction data mismatch
- Prompt: "This profile does not appear to belong to you."

**SCAM #8: Flooding with Fake Reports**
- Attack: Mass-report others
- Defense: Only accept reports from ID-verified users, require evidence, require ≥3 independent reports, require admin review, penalize malicious reporting
- If detected: TrustScore drop and temporary suspension

**SCAM #9: Account Takeover**
- Attack: Steal someone's SilentID account
- Defense: Passkeys, device fingerprinting, suspicious login detection, risk-based OTP checks, lockouts, IP mismatch alerts, forced identity re-verification
- Result: Account protected

### Device Fingerprinting
**Must log:**
- Device model, OS version, Browser version, Screen resolution, Hardware ID signature, Biometrics availability, Cookie-less fingerprint, IP & ASN, Known VPN patterns

**Detects:**
- Account farms, Fake user clusters, Device hopping, Suspicious identity matches

### Risk Score System (0–100)
**Risk Factor Points:**
- Fake evidence: +30
- ID mismatch: +20
- Device inconsistency: +10
- Collusion patterns: +20
- Public profile mismatch: +10
- Fraud reports: +10 each
- Suspicious login patterns: +5
- High-risk IP: +5

**Thresholds:**
- 0-15: Safe (normal operation)
- 16-40: Medium Risk (warning banner, encouraged ID verification, some features limited)
- 41-70: High Risk (mandatory identity re-check, evidence uploads disabled, mutual verification blocked)
- 71-100: Critical (account frozen, admin notified, user must provide additional evidence)

### The Unbreakable Rule
**"SilentID prioritizes safety over convenience."**
If it feels suspicious → block it, review it, or verify it.

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

---

## SECTION 8: DATABASE SCHEMA

### All Tables Use:
- **UUID/GUID** primary keys
- **CreatedAt / UpdatedAt** timestamps
- **SoftDelete** fields (where needed)
- Compatible with **PostgreSQL**

### 13 Core Tables

**1. Users**
- Id (UUID, PK)
- Email (string, unique, lowercase)
- Username (string, unique, @username)
- DisplayName (string, e.g., "Sarah M.")
- PhoneNumber (string, nullable)
- IsEmailVerified, IsPhoneVerified, IsPasskeyEnabled (bool)
- AccountStatus (enum: Active, Suspended, UnderReview)
- AccountType (enum: Free, Premium, Pro)
- SignupIP, SignupDeviceId (string, for risk analysis)
- CreatedAt, UpdatedAt (datetime)

**2. IdentityVerification**
- Id (UUID, PK)
- UserId (UUID, FK Users)
- StripeVerificationId (string, reference only)
- Status (enum: Pending, Verified, Failed, NeedsRetry)
- Level (enum: Basic, Enhanced)
- VerifiedAt (datetime, nullable)
- CreatedAt (datetime)

**3. AuthDevices**
- Id (UUID, PK)
- UserId (UUID, FK)
- DeviceId (string, hashed fingerprint)
- DeviceModel, OS, Browser (string)
- LastUsedAt (datetime)
- IsTrusted (bool)
- CreatedAt (datetime)

**4. Sessions**
- Id (UUID, PK)
- UserId (UUID, FK)
- RefreshTokenHash (string, hashed)
- ExpiresAt (datetime)
- IP, DeviceId (string)
- CreatedAt (datetime)

**5. ReceiptEvidence**
- Id (UUID, PK)
- UserId (UUID, FK)
- Source (enum: Gmail, Outlook, IMAP, Forwarded)
- Platform (enum: Vinted, eBay, Depop, Etsy, Other)
- RawHash (string, hash of source email to detect duplicates)
- OrderId (string, nullable), Item (string), Amount (decimal), Currency (string)
- Role (enum: Buyer, Seller)
- Date (datetime, actual transaction date)
- IntegrityScore (int, 0-100), FraudFlag (bool)
- EvidenceState (enum: Valid, Suspicious, Rejected)
- CreatedAt (datetime)

**6. ScreenshotEvidence**
- Id (UUID, PK)
- UserId (UUID, FK)
- FileUrl (string, Azure Blob)
- Platform (enum)
- OCRText (text, extracted)
- IntegrityScore (int, tamper score), FraudFlag (bool)
- EvidenceState (enum: Valid, Suspicious, Rejected)
- CreatedAt (datetime)

**7. ProfileLinkEvidence**
- Id (UUID, PK)
- UserId (UUID, FK)
- URL (string, public profile URL)
- Platform (enum)
- ScrapeDataJson (JSON, rating, reviews, join date)
- UsernameMatchScore (int, similarity percentage)
- IntegrityScore (int)
- EvidenceState (enum: Valid, Suspicious, Rejected)
- CreatedAt (datetime)

**8. MutualVerifications**
- Id (UUID, PK)
- UserAId, UserBId (UUID, FK)
- Item (string), Amount (decimal)
- RoleA, RoleB (enum: Buyer/Seller)
- Date (datetime)
- EvidenceId (UUID, nullable)
- Status (enum: Pending, Confirmed, Rejected, Blocked)
- FraudFlag (bool)
- CreatedAt (datetime)

**9. TrustScoreSnapshots**
- Id (UUID, PK)
- UserId (UUID, FK)
- Score (int), IdentityScore (int), EvidenceScore (int), BehaviourScore (int), PeerScore (int)
- BreakdownJson (JSON)
- CreatedAt (datetime)

**10. RiskSignals**
- Id (UUID, PK)
- UserId (UUID, FK)
- Type (enum: FakeReceipt, FakeScreenshot, Collusion, DeviceMismatch, IPRisk, Reported, etc.)
- Severity (int, 1-10)
- Message (string, human-readable)
- Metadata (JSON)
- CreatedAt (datetime)

**11. Reports**
- Id (UUID, PK)
- ReporterId (UUID, FK), ReportedUserId (UUID, FK)
- Category (enum: ItemNotReceived, AggressiveBehaviour, FraudConcern, etc.)
- Description (text)
- Status (enum: Pending, UnderReview, Verified, Dismissed)
- CreatedAt (datetime)

**12. ReportEvidence**
- Id (UUID, PK)
- ReportId (UUID, FK)
- FileUrl (string), OCRText (text)
- CreatedAt (datetime)

**13. Subscriptions**
- Id (UUID, PK)
- UserId (UUID, FK)
- Tier (enum: Free, Premium, Pro)
- RenewalDate (datetime)
- CancelAt (datetime, nullable)
- CreatedAt (datetime)

**14. AdminAuditLogs**
- Id (UUID, PK)
- AdminUser (string)
- Action (string)
- TargetUserId (UUID, nullable)
- Details (JSON)
- CreatedAt (datetime)

### Relationship Map
```
Users (hub)
 ├── IdentityVerification (1:1)
 ├── AuthDevices (1:many)
 ├── Sessions (1:many)
 ├── ReceiptEvidence (1:many)
 ├── ScreenshotEvidence (1:many)
 ├── ProfileLinkEvidence (1:many)
 ├── MutualVerifications (many-to-many via pair)
 ├── TrustScoreSnapshots (1:many)
 ├── RiskSignals (1:many)
 ├── Reports (1:many)
 ├── Subscriptions (1:1 or many if historical)
 └── AdminAuditLogs (admin-triggered)
```

### Data Privacy Rules (DB Level)
- No column stores legal full name
- No column stores ID documents
- Certain fields encrypted (email, IP, device ID)
- Hashing for sensitive fingerprints
- GDPR-compliant soft-delete
- Cascade-delete with caution

---

## SECTION 9: API ENDPOINTS

### Base URL
`https://api.silentid.app`

### Auth: Bearer JWT in `Authorization` header (or public where specified)
### Versioning: `/v1/...`

### 10 Endpoint Groups (~40 total endpoints)

**1. Auth & Session (8 endpoints)**
- POST /v1/auth/request-otp (Public)
- POST /v1/auth/verify-otp (Public)
- POST /v1/auth/refresh (Public)
- POST /v1/auth/logout (User)
- POST /v1/auth/passkey/register/challenge (User)
- POST /v1/auth/passkey/register/verify (User)
- POST /v1/auth/passkey/login/challenge (Public)
- POST /v1/auth/passkey/login/verify (Public)

**2. Identity Verification (2 endpoints)**
- POST /v1/identity/stripe/session (User)
- GET /v1/identity/status (User)

**3. User Profile (3 endpoints)**
- GET /v1/users/me (User)
- PATCH /v1/users/me (User)
- DELETE /v1/users/me (User)

**4. Evidence (8 endpoints)**
- POST /v1/evidence/receipts/connect (User)
- POST /v1/evidence/receipts/manual (User)
- GET /v1/evidence/receipts (User)
- POST /v1/evidence/screenshots/upload-url (User)
- POST /v1/evidence/screenshots (User)
- GET /v1/evidence/screenshots/{id} (User)
- POST /v1/evidence/profile-links (User)
- GET /v1/evidence/profile-links/{id} (User)

**5. Mutual Verifications (4 endpoints)**
- POST /v1/mutual-verifications (User)
- GET /v1/mutual-verifications/incoming (User)
- POST /v1/mutual-verifications/{id}/respond (User)
- GET /v1/mutual-verifications (User)

**6. TrustScore (3 endpoints)**
- GET /v1/trustscore/me (User)
- GET /v1/trustscore/me/breakdown (User)
- GET /v1/trustscore/me/history (User)

**7. Public Profile (2 endpoints)**
- GET /v1/public/profile/{username} (Public)
- GET /v1/public/availability/{username} (Public)

**8. Safety Reports (3 endpoints)**
- POST /v1/reports (User)
- POST /v1/reports/{id}/evidence (User)
- GET /v1/reports/mine (User)

**9. Subscriptions (3 endpoints)**
- GET /v1/subscriptions/me (User)
- POST /v1/subscriptions/upgrade (User)
- POST /v1/subscriptions/cancel (User)

**10. Admin (4 endpoints)**
- GET /v1/admin/users/{id} (Admin)
- GET /v1/admin/risk/users (Admin)
- POST /v1/admin/reports/{id}/decision (Admin)
- POST /v1/admin/users/{id}/action (Admin)

### API Design Rules
1. RESTful conventions
2. JSON for all bodies
3. HTTP Status Codes: 200, 201, 202, 400, 401, 403, 404, 409, 422, 429
4. Standard error response:
```json
{
  "error": "string_code",
  "message": "Human-readable explanation.",
  "details": {...}
}
```
5. Enforce authentication where required
6. Log important events (especially security-sensitive)

---

## SECTION 10: FRONTEND ARCHITECTURE

### Framework
Flutter with Material 3 theming, Custom SilentID theme, Dark & light mode support

### 10 Logical Modules
1. Core/Shell (app root, routing, theming, error handling)
2. Auth Module (onboarding, OTP, passkeys, risk prompts)
3. Identity Module (Stripe verification, ID status)
4. Evidence Module (receipts, screenshots, profile links)
5. Trust Module (TrustScore overview, breakdowns, history)
6. Mutual Verification Module (transaction requests, confirmations)
7. Public Profile Module (preview, share, QR)
8. Safety Module (reporting, my reports)
9. Settings & Account (profile, privacy, devices, export, delete, subscriptions)
10. Admin (future/hidden route)

### Navigation Structure
**Initial Stack:** Auth → Identity verification → First-time flows

**Bottom Navigation (4 tabs):**
1. Home (Trust overview)
2. Evidence (Receipts, screenshots, profiles)
3. Verify (Mutual transactions, scan profiles)
4. Settings (Account, privacy, subscription)

### 39 Key Screens
**Auth Module (5):** Welcome, EmailEntry, OTPVerification, PasskeySetupPrompt, SuspiciousLogin

**Identity Module (3):** IdentityIntro, IdentityStripeWebView, IdentityStatus

**Evidence Module (8):** EvidenceOverview, ConnectEmail, ReceiptScanProgress, ReceiptList, ScreenshotUpload, ScreenshotDetails, AddProfileLink, ProfileLinkDetails

**Trust Module (3):** TrustScoreOverview, TrustScoreBreakdown, TrustScoreHistory

**Mutual Verification Module (4):** MutualVerificationHome, CreateVerification, IncomingRequests, VerificationDetails

**Public Profile Module (3):** MyPublicProfilePreview, ShareProfile, PublicProfileViewer

**Safety Module (3):** ReportUser, MyReportsList, ReportDetails

**Settings & Account (10):** SettingsHome, AccountDetails, PrivacySettings, ConnectedDevices, DataExport, DeleteAccount, SubscriptionOverview, UpgradeToPremium, UpgradeToPro, LegalDocs

### Design Guidelines
1. **Consistent theming:** primaryColor = #5A3EB8, bank-grade neutrals, reuse common components
2. **Accessibility:** Large tappable buttons, high contrast, clear labels, dynamic text sizes, screen reader support
3. **Performance:** Lazy loading, cached data, debounced calls, loading skeletons
4. **Security:** Never log sensitive data, avoid showing raw IDs/tokens, obscure system errors
5. **Error & Empty States:** Every list has empty state message, every network call has user-friendly error

---

## SECTION 11: IMPLEMENTATION PHASES

### 17 Build Phases (Sequential, NO Skipping)

**Phase 0 — Environment & Tooling Setup**
- Confirm: OS, .NET SDK, Flutter version, VS Code
- Install if needed: .NET SDK, Flutter & Dart SDK, Git, VS Code extensions
- Verify installations
- Checkpoint: User can run basic .NET and flutter commands

**Phase 1 — Backend Skeleton**
- Create Web API project (SilentID.Api)
- Set up folder structure
- Basic /health endpoint
- Checkpoint: Backend runs locally, /health responds

**Phase 2 — Core Auth & Session Layer**
- Implement OTP-based login (request-otp → verify-otp → refresh → logout)
- Integrate email provider (SendGrid/SES)
- Device fingerprint storage
- JWT issuance (access + refresh tokens)
- Rate limiting for OTP
- Checkpoint: User can register/login via OTP using API client

**Phase 3 — Identity Verification (Stripe Identity)**
- Get Stripe test API keys
- Implement /v1/identity/stripe/session and /v1/identity/status
- Stripe webhooks/callback handler
- Checkpoint: Test user completes Stripe Identity demo, status shows Verified

**Phase 4 — Core Data Models & Migrations**
- Choose DB (PostgreSQL)
- Configure EF Core
- Create all 13 entities and mappings
- Generate and apply migrations
- Checkpoint: Database populated with all tables

**Phase 5 — Evidence APIs**
- Email Receipts: Connect email (stubbed), manual submission, list receipts
- Screenshots: Upload URL (Azure Blob), OCR (stubbed), status endpoint
- Profile Links: Add link (scraper stubbed), status endpoint
- Checkpoint: User can add receipt, upload screenshot, add profile link

**Phase 6 — TrustScore Engine**
- Create TrustScoreService (0-1000 calculation)
- Weekly recalculation job
- Implement /v1/trustscore/me endpoints (current, breakdown, history)
- Checkpoint: Test user sees properly computed TrustScore

**Phase 7 — Risk & Anti-Fraud Engine**
- Create RiskEngineService (rule-based, 0-100 RiskScore)
- Integrate risk checks into all evidence flows
- Thresholds and actions (freeze account)
- Checkpoint: Risk events trigger RiskScore changes, account actions work

**Phase 8 — Safety Reports & Admin Basics**
- Implement /v1/reports endpoints
- Implement /v1/admin/reports/{id}/decision
- Link reports → RiskSignals → TrustScore
- Checkpoint: User can file report; admin can review

**Phase 9 — Public Profile API & Privacy Controls**
- Implement /v1/public/profile/{username}
- Privacy settings (show/hide metrics)
- Checkpoint: Public GET returns clean, privacy-safe profile JSON

**Phase 10 — Flutter App Skeleton & Navigation**
- Create Flutter project with SilentID theme
- Bottom navigation (4 tabs: Home, Evidence, Verify, Settings)
- Navigation scaffolding for ~39 screens (placeholder content)
- Checkpoint: App runs on emulator/device, nav bar works

**Phase 11 — Auth Flows in Flutter**
- Connect app to backend (configurable API URL)
- Build Welcome, Email entry, OTP screens
- Secure token storage
- Optional passkey flows (can stub)
- Checkpoint: User can sign up/login via app, reach Home tab

**Phase 12 — Trust & Evidence UI in Flutter**
- Implement TrustScoreOverviewScreen (big score, badges)
- Implement EvidenceOverviewScreen (receipts, screenshots, profiles)
- List views for evidence
- Checkpoint: User sees TrustScore and evidence from backend

**Phase 13 — Mutual Verification & Public Profile UI**
- Implement mutual verification flows (create, accept, list)
- Implement My Public Profile preview
- QR code generation + share sheet
- Checkpoint: Two test users can mutually verify transaction

**Phase 14 — Safety Reports & Settings UI**
- Build ReportUserScreen (categories, evidence upload)
- Build MyReportsListScreen
- Settings screens (privacy, data export, delete account)
- Checkpoint: User can report another user, see status

**Phase 15 — Subscriptions & Monetisation**
- Integrate Stripe Billing (upgrade/cancel endpoints)
- Implement upgrade screens (Premium/Pro)
- Reflect subscription tier in UI
- Checkpoint: Test user can fake upgrade in sandbox

**Phase 16 — Hardening, Logging, Analytics & Polish**
- Add logging (structured, no sensitive data)
- Add metrics (logins, evidence, risk events)
- Crash reporting + analytics (privacy-safe)
- Security review, privacy review, UX polish
- Checkpoint: Production-ready (robust flows, meaningful logs, polished UI)

### Build Pattern (Small-Step Example)
1. Implement request-OTP only → test end to end
2. Then implement verify-OTP → test end to end
3. Then sessions & refresh tokens → test

### Checkpoint Pattern
Every phase ends with:
- A specific test
- A "what works now" summary
- User confirmation before proceeding

---

## SECTION 12: MONETISATION

### 3 Pricing Tiers
1. **Free** (default)
2. **Premium – £4.99/month**
3. **Pro – £14.99/month**

**Prices are base UK figures; must be configurable, NOT hard-coded.**

### Free Tier
**Can do:**
- Create account
- Verify identity via Stripe (basic)
- Set username and display name
- Add limited evidence: up to 10 manual receipts, up to 5 screenshots, up to 2 public profile links
- Get TrustScore (0-1000)
- See simple breakdown
- Create and confirm mutual verifications (up to 20 total)
- Have public profile URL
- File safety reports
- See if other profiles have safety concerns

**Limits:**
- Evidence Vault: 250MB total
- No automatic inbox scanning
- High-level TrustScore view only
- No bulk checks
- No exportable PDF trust certificate

### Premium Tier (£4.99/month)
**Entitlements:**
1. Evidence Vault – 100GB
2. Unlimited Evidence Sources
3. Advanced TrustScore Breakdown (detailed reasons, component analysis)
4. Trust Timeline & Analytics (graphs, platform-by-platform stats)
5. Premium Badge (subtle "SilentID Premium Member" - NOT implying safer by default)
6. Priority Evidence Processing (soft)

**Conditions:**
- Billed monthly, auto-renew
- Cancel anytime; continues until period end
- No refunds for partial months
- Upgrades immediate; downgrades at end of cycle

### Pro Tier (£14.99/month)
**Entitlements (All Premium +):**
1. Bulk Checks (up to 50 SilentID profiles at once)
2. Dispute & Evidence Pack Generator (PDF report for marketplace support/legal use)
3. Trust Certificate Export (branded PDF for landlord references, external markets)
4. White-Label Profile Option (remove branding on external materials, NOT core UI)
5. Higher Evidence Vault Limit (500GB)
6. Priority Support

**Conditions:**
- Same billing as Premium
- High RiskScore or fraud flags → Pro features may be throttled/removed even if user pays

**"Paid subscription does NOT override risk and safety systems."**

### Subscription Lifecycle
**Upgrades:** Effective immediately
**Downgrades:** Retain features until end of billing period, then apply new limits (existing evidence remains accessible, new uploads blocked if above limit)
**Grace Periods:** If payment fails, 7-14 days grace (keep access, retry payment), then auto-downgrade to Free
**Refund Policy:** NO automatic refunds for partial months

### Free Trials & Promotions
- 7-14 day free Premium trial (new users only)
- Pro trial for high-value users (e.g., 30 days for communities)
- Referral Rewards (e.g., "Refer 3, get 3 months Premium free")
- Implemented as optional flags & features, NOT hard-coded

### Anti-Fraud Rules for Subscriptions
1. **RiskScore is king:** High/critical RiskScore → Pro features limited/suspended/disabled
2. **Payment & Fraud Monitoring:** Stolen card/chargebacks → flag user, possibly lock account
3. **Mass-Action Safeguards:** Bulk checks rate-limited, malicious reports penalized
4. **No TrustScore Boost Pay-to-Win:** Paying NEVER directly increases TrustScore

**"Money does not buy safety."**

### UI Paywall Copy (Exact Examples Provided in Section 6)
- Premium: Focus on insights, vault, tools to prove reliability
- Pro: Focus on scale, professional profile, evidence packs
- Legal footer: "SilentID provides evidence-based trust signals and tools to help you make safer decisions. It does not guarantee outcomes or provide legal advice."

---

## SECTION 13: PRE-CODING CHECKLIST

### Mandatory Understanding Confirmation (13 Points)
1. ✅ SilentID is standalone trust passport (NOT connected to SilentSale in MVP)
2. ✅ Authentication: passwordless (Email OTP primary, Passkeys optional)
3. ✅ Database: PostgreSQL (local dev, Azure prod later, migrations auto-run in dev only)
4. ✅ Stripe Identity handles ID verification – SilentID stores only status, never documents
5. ✅ Evidence sources: email receipts, screenshot uploads, public profile URLs
6. ✅ TrustScore system (0-1000) with Identity, Evidence, Behaviour, Peer components
7. ✅ Anti-Fraud Engine with device fingerprinting, risk scoring, collusion detection
8. ✅ Public, shareable SilentID profile with privacy controls
9. ✅ Safety Reports with evidence and admin review
10. ✅ Subscriptions: Free, Premium £4.99/month, Pro £14.99/month, no free trial at launch, Stripe Billing only
11. ✅ Flutter mobile app (iOS + Android first)
12. ✅ UI design: Bank-grade, royal purple #5A3EB8, clean, secure, serious
13. ✅ Multi-phase build plan (17 phases), No SilentSale integration yet

### Security Checklist
- ✅ SilentID never stores passwords
- ✅ Only store: email, passkey public key
- ✅ Never store: identity documents, photos of IDs, full email content
- ✅ Stripe Identity results: only store status, sessionId, verifiedAt
- ✅ Sensitive fields encrypted: IP, device fingerprint, refresh tokens
- ✅ Logs never contain: OTPs, access tokens, raw evidence, device fingerprints, email contents

### Database Checklist
- ✅ Using PostgreSQL
- ✅ Local Postgres for development
- ✅ UUID/GUID primary keys for ALL tables
- ✅ Migrations auto-run in development only
- ✅ DB schema EXACTLY matches Section 8
- ✅ All models include: CreatedAt, UpdatedAt, soft-delete where applicable

### Important Defaults
**Backend & Deployment:**
- PostgreSQL in dev (local)
- PostgreSQL in prod (Azure later)
- Auto-migrations in dev only

**Frontend:**
- iOS + Android only
- No Firebase for MVP
- SilentID purple: #5A3EB8
- Logo top-centre or top-left (user's choice)

**Public Profiles:**
- Public profiles visible without login
- Usernames globally unique
- Username changes allowed (limited frequency)

**Safety:**
- New accounts restricted until: email verified, basic Stripe ID verified
- Suspicious accounts use soft limits first, full block only with strong signals

**Monetisation:**
- No free trial at launch
- £4.99 Premium / £14.99 Pro (static UK pricing)
- Stripe card payments only (no App Store billing yet)

**SilentSale:**
- NO integration for MVP
- Build SilentID as standalone system
- Keep APIs clean for future partner use

### 18 Mandatory Questions Before Coding

**Backend & Infra:**
1. Confirm PostgreSQL: Local Postgres for dev? Azure Postgres later?
2. Do you want Docker for local Postgres?
3. Auto-run migrations on startup in dev? (Default: YES)

**Frontend:**
4. Confirm platforms: iOS + Android only?
5. Skip Firebase for now?
6. Light mode default, dark mode later?

**Identity Verification:**
7. Do you already have Stripe Identity set up?
8. Start in test mode? (Default: YES)

**Subscriptions:**
9. Stripe Billing only for MVP?
10. Static prices (£4.99 / £14.99)?

**Profile:**
11. Username globally unique?
12. Allow username changes? (Default: YES, limited)
13. Public profiles visible without login?

**Safety & Risk:**
14. New accounts restricted until: email verified + basic ID?
15. Suspicious accounts: soft-limit first? Block only on strong signals?

**Branding:**
16. Logo position: top-left? Or top-centre?
17. Confirm Royal Purple: #5A3EB8 as primary colour?

**SilentSale:**
18. Confirm no SilentSale integration in MVP?

### Before Coding Process
Once you answer questions:
1. Repeat your choices
2. Validate nothing conflicts
3. Offer corrections if needed
4. Ask: "Should we proceed to Phase 0: Environment Setup?"

**CANNOT write code before you say yes.**

---

## QUICK REFERENCE TABLES

### TrustScore Components
| Component | Max Points | Sources |
|-----------|-----------|---------|
| Identity | 200 | Stripe verification, email/phone verified, device consistency |
| Evidence | 300 | Receipts, screenshots, public profile data, evidence quality |
| Behaviour | 300 | No reports, on-time patterns, account longevity, cross-platform consistency |
| Peer Verification | 200 | Mutual endorsements, returning partner transactions |

### Risk Score Thresholds
| Score | Level | Actions |
|-------|-------|---------|
| 0-15 | Safe | Normal operation |
| 16-40 | Medium Risk | Warning banner, encouraged ID verification, some features limited |
| 41-70 | High Risk | Mandatory identity re-check, evidence uploads disabled, mutual verification blocked |
| 71-100 | Critical | Account frozen, admin notified, user must provide additional evidence |

### Subscription Features Matrix
| Feature | Free | Premium | Pro |
|---------|------|---------|-----|
| Create account | ✅ | ✅ | ✅ |
| Basic ID verification | ✅ | ✅ | ✅ |
| TrustScore | ✅ | ✅ | ✅ |
| Manual receipts | 10 max | Unlimited | Unlimited |
| Screenshots | 5 max | Unlimited | Unlimited |
| Public profile links | 2 max | Unlimited | Unlimited |
| Evidence Vault | 250MB | 100GB | 500GB |
| Advanced TrustScore breakdown | ❌ | ✅ | ✅ |
| Trust Timeline & Analytics | ❌ | ✅ | ✅ |
| Premium Badge | ❌ | ✅ | ✅ |
| Bulk Checks (50 profiles) | ❌ | ❌ | ✅ |
| Evidence Pack Generator | ❌ | ❌ | ✅ |
| Trust Certificate PDF | ❌ | ❌ | ✅ |
| White-label options | ❌ | ❌ | ✅ |
| Priority Support | ❌ | ❌ | ✅ |

---

## SECTION 14: SILENTID ADMIN DASHBOARD

### SilentID Admin Dashboard — Web UI (Design, Scope & Access Model)

#### Purpose
The Admin Dashboard is a **separate web application** for internal SilentID staff to manage users, review reports, handle risk signals, and monitor system health.

**Critical Requirements:**
- Must run at: `https://admin.silentid.co.uk`
- Uses the **SAME ASP.NET Core backend** and PostgreSQL database
- Uses the SAME Stripe account (SILENTSALE LTD)
- Must **never** be part of the mobile app
- Must be **completely separate** from user-facing Flutter application

#### Admin Authentication

**Admin Login Methods:**
- Email OTP (same as users, but with admin role check)
- Google Workspace SSO (corporate accounts only)
- Passkeys (for trusted admin devices)

**Access Control Requirements:**
- User must have `AccountType = Admin` (new enum value)
- Optional: IP allowlisting for extra security layer
- All admin actions require re-authentication after 2 hours
- Admin sessions separate from user sessions

**Database Changes Required:**
```sql
-- Add Admin to AccountType enum in Users table
AccountType (enum: Free, Premium, Pro, Admin)

-- New table for admin-specific auth
CREATE TABLE AdminUsers (
  Id UUID PRIMARY KEY,
  UserId UUID REFERENCES Users(Id),
  Role VARCHAR(50), -- SuperAdmin, Moderator, Support
  Permissions JSONB, -- Granular permissions
  LastLogin TIMESTAMP,
  CreatedAt TIMESTAMP
);
```

#### Admin Dashboard Sections

**1. Dashboard Overview**
- Total users (Free, Premium, Pro)
- Active reports (Pending, Under Review)
- High-risk accounts (RiskScore > 70)
- Recent admin actions
- System health metrics

**2. Users Section**
**Features:**
- Search users by: email, username, ID, phone
- Filter by: AccountStatus, AccountType, TrustScore range, RiskScore range
- View full user profile:
  - Basic info (email, username, display name)
  - TrustScore breakdown
  - Identity verification status
  - All evidence (receipts, screenshots, profile links)
  - Risk signals history
  - Reports (filed by user, filed against user)
  - Subscription status
  - Device history
  - Login history

**Actions:**
- Freeze account (temporary suspension)
- Limit features (disable evidence upload, mutual verification)
- Unfreeze account
- Force identity re-verification
- View detailed audit log for specific user
- Export user data (for GDPR SAR requests)

**3. Reports Section**
**Features:**
- List all reports with filters:
  - Status (Pending, Under Review, Verified, Dismissed)
  - Category (ItemNotReceived, AggressiveBehaviour, etc.)
  - Date range
  - Reporter/Reported user
- View report details:
  - Reporter info
  - Reported user info
  - Evidence attached
  - Description
  - Timeline

**Actions:**
- Review report
- Mark as Verified (triggers RiskSignal, affects TrustScore)
- Mark as Dismissed (no action)
- Request more evidence
- Contact reporter
- Contact reported user

**4. Risk & Fraud Section**
**Features:**
- List all RiskSignals with filters:
  - Type (FakeReceipt, FakeScreenshot, Collusion, etc.)
  - Severity (1-10)
  - User
  - Date range
- Risk score distribution chart
- Collusion network visualization
- Suspicious account clusters

**Actions:**
- Review risk signal
- Override risk decision (with justification required)
- Add manual risk signal
- Link related accounts
- Escalate to senior admin

**5. Evidence Overview (Optional Future)**
- Statistics on evidence types
- Evidence integrity scores
- Suspicious evidence patterns

**6. Admin Audit Logs**
**Features:**
- List all admin actions with filters:
  - Admin user
  - Action type (FreezeAccount, VerifyReport, etc.)
  - Target user
  - Date range
- Full audit trail for compliance

**Cannot be modified or deleted** (append-only table)

**7. Settings Section**
**Features:**
- Manage admin users (add, remove, change roles)
- View system configuration (read-only)
- Manage risk thresholds (with caution)

#### Security Rules (Mandatory)

**1. All Admin Actions Must Be Logged**
Every action must create an entry in `AdminAuditLogs` table:
```sql
INSERT INTO AdminAuditLogs (
  AdminUser,
  Action,
  TargetUserId,
  Details,
  CreatedAt
) VALUES (
  '[admin@silentid.co.uk](mailto:admin@silentid.co.uk)',
  'FreezeAccount',
  'user-uuid-here',
  '{"reason": "Multiple fake screenshots", "duration": "7 days"}',
  NOW()
);
```

**2. Admin Endpoints Protected**
All admin endpoints must:
- Check JWT token is valid
- Check user has `AccountType = Admin`
- Check user has required permission for specific action
- Log the action
- Rate limit to prevent abuse

**3. No Secrets Exposed**
Admin dashboard must **NEVER** show:
- Stripe API keys
- Database connection strings
- Email provider credentials
- OAuth secrets
- User passwords (none exist anyway)
- Full ID document images (only verification status)

**4. Internal Staff Only**
Admin dashboard is **not** for:
- Premium/Pro users
- "Community moderators"
- External partners
- AI agents or bots

Only SilentID internal employees with background checks.

#### API Endpoints Required

**Admin User Management:**
- GET /v1/admin/users (list with pagination, filters)
- GET /v1/admin/users/{id} (full profile view)
- POST /v1/admin/users/{id}/freeze (freeze account)
- POST /v1/admin/users/{id}/unfreeze (unfreeze account)
- POST /v1/admin/users/{id}/limit-features (restrict actions)
- POST /v1/admin/users/{id}/force-reverify (trigger ID check)

**Admin Reports Management:**
- GET /v1/admin/reports (list with filters)
- GET /v1/admin/reports/{id} (report details)
- POST /v1/admin/reports/{id}/verify (mark as verified)
- POST /v1/admin/reports/{id}/dismiss (mark as dismissed)

**Admin Risk Management:**
- GET /v1/admin/risk/signals (list all RiskSignals)
- GET /v1/admin/risk/users (high-risk users)
- POST /v1/admin/risk/override (override risk decision)
- POST /v1/admin/risk/manual-signal (create manual risk signal)

**Admin Audit Logs:**
- GET /v1/admin/audit-logs (list with filters)

**Admin Settings:**
- GET /v1/admin/settings (read system config)
- POST /v1/admin/admins (add new admin user)
- DELETE /v1/admin/admins/{id} (remove admin)

**All endpoints return 403 if user is not admin.**

#### Multi-Agent Alignment

**Agent A (Architect):**
- Design admin dashboard architecture
- Define all admin API contracts
- Plan database schema changes (AdminUsers table)
- Ensure no conflicts with existing user-facing APIs

**Agent B (Backend):**
- Implement admin endpoints safely
- Add admin authorization checks to existing middleware
- Create AdminUsersController
- Update Users table with Admin enum value
- Ensure all admin actions are logged

**Agent C (Frontend - Future):**
- Build React/Next.js web admin UI (NOT Flutter)
- Admin login flow
- User management interface
- Report review interface
- Risk signal dashboard

**Agent D (QA):**
- Test admin authentication
- Verify admin actions are logged
- Test that non-admin users cannot access admin endpoints
- Use MCP tools to validate API responses

**Critical Rule:**
Before ANY agent implements admin features, they must:
1. Check existing code with MCP filesystem tools
2. Verify no duplicate logic exists
3. Confirm API endpoints don't conflict
4. Update CLAUDE.md if architecture changes

---

## SECTION 15: SILENTID SECURITY CENTER

### SilentID Security Center — Digital Protection Hub

#### Purpose
The **SilentID Security Center** is a comprehensive digital safety feature built into the SilentID mobile app that helps users protect their identity, detect threats, and maintain trust integrity.

**What It Is:**
- Digital protection hub within SilentID app
- Proactive security monitoring
- Identity breach detection
- Device integrity checking
- Login activity tracking

**What It Is NOT:**
- NOT a password manager (SilentID has no passwords)
- NOT antivirus software
- NOT a VPN or network security tool
- NOT credit monitoring

**Core Philosophy:**
"SilentID protects your trust identity across the internet by monitoring threats, detecting breaches, and ensuring device integrity."

#### Security Center Features

**1. Email Breach Scanner**

**What It Does:**
Checks if user's email appears in known data breaches using HaveIBeenPwned-style API.

**How It Works:**
- User enters email (or uses account email)
- SilentID queries breach database API
- Returns list of breaches where email appeared
- Shows: breach name, date, data types compromised

**Privacy Protection:**
- Uses k-anonymity (send hash prefix only)
- Never sends full email to third-party API
- Results stored locally only

**UI Copy:**
- Title: "Email Breach Check"
- Description: "See if your email has appeared in data breaches."
- Button: "Scan My Email"
- Results: "Your email appeared in 2 breaches: [List]. We recommend changing passwords on affected sites."

**API Endpoint:**
```
POST /v1/security/breach-check
Body: { "email": "user@example.com" }
Response: {
  "breaches": [
    {
      "name": "Adobe",
      "date": "2013-10-04",
      "compromisedData": ["email", "password"],
      "verified": true
    }
  ],
  "breachCount": 2
}
```

**2. Device Integrity Check**

**What It Does:**
Performs local device security checks to detect:
- Jailbreak/root detection
- OS version outdated
- Developer mode enabled
- USB debugging enabled (Android)
- Known malware indicators

**How It Works:**
- Runs locally on device (no backend)
- Uses Flutter platform-specific checks
- Results shown immediately
- Optional: Upload results to backend for RiskScore adjustment

**UI Copy:**
- Title: "Device Security Check"
- Description: "Verify your device hasn't been compromised."
- Button: "Check Device"
- Results: "✅ Device Secure" or "⚠️ Security Issues Detected: [List]"

**Security Checks:**
```dart
// Flutter implementation
- Jailbreak/Root: Use flutter_jailbreak_detection package
- OS Version: Check against minimum supported versions
- Developer Mode: Check system settings
- SilentID App Integrity: Verify app signature
```

**3. Login Activity Timeline**

**What It Does:**
Shows complete history of SilentID account logins with:
- Date/time
- Device (model, OS)
- Location (city/country from IP)
- Login method (OTP, Passkey, Apple, Google)
- Success/failure status

**How It Works:**
- Backend logs all login attempts in `Sessions` and `AuthDevices` tables
- Frontend displays chronological timeline
- User can mark suspicious logins
- Can revoke device access

**UI Copy:**
- Title: "Login Activity"
- Description: "See where and when you've signed in to SilentID."
- List Item Example:
  ```
  iPhone 13 Pro (iOS 17.2)
  London, UK
  Nov 21, 2025 at 3:42 PM
  Signed in with Passkey
  [Mark as Suspicious] [Revoke Device]
  ```

**API Endpoint:**
```
GET /v1/security/login-history
Response: {
  "logins": [
    {
      "timestamp": "2025-11-21T15:42:00Z",
      "device": "iPhone 13 Pro",
      "os": "iOS 17.2",
      "location": "London, UK",
      "method": "Passkey",
      "ipAddress": "185.x.x.x" (masked),
      "success": true
    }
  ]
}
```

**4. Identity Status Page**

**What It Does:**
Central view of all identity verification status:
- Stripe Identity status (Verified, Pending, Failed)
- Email verification status
- Phone verification status (if added)
- Passkey enrollment status
- Last identity check date

**UI Copy:**
- Title: "Identity Status"
- Description: "Your verification status across SilentID."
- Status Items:
  - "✅ Identity Verified via Stripe"
  - "✅ Email Verified"
  - "❌ Phone Not Added"
  - "✅ Passkey Enabled"

**5. User RiskScore Summary**

**What It Does:**
Simplified, user-friendly view of their own RiskScore and RiskSignals.

**Transparency Rules:**
- Show current RiskScore (0-100)
- Explain what it means in plain language
- List active risk signals with explanations
- Provide actions to improve risk standing

**UI Copy:**
- Title: "Your Risk Status"
- Description: "SilentID monitors for suspicious activity to protect your account."
- Display: "Your Risk Score: 12 (Low Risk)"
- Risk Signals:
  - "✅ No suspicious activity detected"
  - OR: "⚠️ Device inconsistency detected. Reason: [Explanation]. Action: [What to do]"

**API Endpoint:**
```
GET /v1/security/risk-score
Response: {
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

**6. Security Alerts**

**What It Does:**
Push notifications and in-app alerts for:
- Email appears in new breach
- Suspicious login detected
- Device security issue found
- High-risk RiskSignal added
- Identity verification expiring

**How It Works:**
- Backend generates alerts based on events
- Stored in new `SecurityAlerts` table
- Push notifications via Firebase/APNs
- In-app badge on Security Center tab

**Database Schema:**
```sql
CREATE TABLE SecurityAlerts (
  Id UUID PRIMARY KEY,
  UserId UUID REFERENCES Users(Id),
  Type VARCHAR(50), -- Breach, SuspiciousLogin, DeviceIssue, RiskSignal
  Title VARCHAR(200),
  Message TEXT,
  Severity INT, -- 1-10
  IsRead BOOLEAN DEFAULT FALSE,
  CreatedAt TIMESTAMP
);
```

**7. Evidence Vault Health Check**

**What It Does:**
Verifies integrity of user's uploaded evidence:
- Check if files still exist in Azure Blob
- Detect corruption
- Verify hashes match
- Warn if evidence has integrity issues

**UI Copy:**
- Title: "Evidence Vault Health"
- Description: "Verify your uploaded evidence is intact."
- Button: "Run Health Check"
- Results: "✅ All evidence intact (124 receipts, 12 screenshots)"

**8. Social Engineering Warning System**

**What It Does:**
Flags when user is about to interact with high-risk SilentID profiles:
- Before viewing profile with RiskScore > 70
- Before confirming mutual verification with flagged user
- Before sharing evidence with reported user

**UI Copy:**
- Warning: "⚠️ This user has multiple safety reports. Review carefully before proceeding."
- Options: "View Reports" | "Continue Anyway" | "Cancel"

#### Where Security Center Lives

**Option 1: Separate Tab (Recommended for MVP)**
- Add 5th tab to bottom navigation: "Security"
- Icon: Shield
- Badge: Shows unread alert count

**Option 2: Inside Settings**
- Add "Security Center" section in Settings
- Expandable menu with all features

**MVP Recommendation:**
Start with Security Center inside Settings, promote to separate tab in Phase 2.

#### Backend Requirements

**New Service Layer:**
```
SecurityCenterService
├── BreachCheckService (integrates HaveIBeenPwned API)
├── DeviceIntegrityService (validates device checks)
├── LoginHistoryService (queries Sessions/AuthDevices)
├── RiskScoreViewService (formats RiskSignals for users)
└── SecurityAlertsService (generates and manages alerts)
```

**New API Endpoints:**
- POST /v1/security/breach-check (check email breaches)
- GET /v1/security/login-history (login timeline)
- GET /v1/security/risk-score (user's own risk data)
- GET /v1/security/alerts (list security alerts)
- POST /v1/security/alerts/{id}/mark-read (dismiss alert)
- GET /v1/security/vault-health (evidence integrity check)

**IMPORTANT:**
All new endpoints must:
- Follow existing API patterns
- Use existing authentication middleware
- Not duplicate logic from other services
- Be added safely without breaking existing backend

#### Multi-Agent Integration

**Agent A (Architect):**
- Define Security Center architecture
- Design API contracts for all endpoints
- Plan database schema changes (SecurityAlerts table)
- Ensure no conflicts with existing TrustScore/RiskScore systems

**Agent B (Backend):**
- Implement SecurityCenterService
- Create new API endpoints
- Integrate HaveIBeenPwned API (or similar)
- Add SecurityAlerts table
- Ensure breach checks use k-anonymity

**Agent C (Frontend):**
- Build Security Center UI in Flutter
- Implement device integrity checks (local)
- Display login history timeline
- Show security alerts with badges
- Create breach scanner interface

**Agent D (QA):**
- Test all security endpoints
- Verify breach checks work correctly
- Test device integrity checks on real devices
- Validate login history accuracy
- Use MCP tools to test API responses

---

## SECTION 16: MONETIZATION — SECURITY CENTER INTEGRATION

### SilentID Premium & Pro — Security Center Integration

#### Premium Tier Security Features (£4.99/month)

In addition to existing Premium features, Premium users get:

**1. Real-Time Breach Monitoring**
- Automatic breach scanning (weekly checks)
- Push notifications when email appears in new breach
- Historical breach timeline

**2. Advanced Login Activity Timeline**
- Extended login history (12 months vs 3 months for Free)
- Export login history as CSV
- Detailed IP geolocation data

**3. Device Integrity Scanning**
- Scheduled device checks (weekly)
- Security score trend over time
- Device security recommendations

**4. Security Alerts**
- Priority security notifications
- Real-time suspicious login alerts
- Device change alerts

**5. Evidence Vault Storage**
- Already included: 100GB storage
- Adds: Evidence integrity monitoring
- Automated evidence backup verification

#### Pro Tier Security Features (£14.99/month)

In addition to all Premium features, Pro users get:

**1. Full RiskScore Insights**
- Detailed breakdown of all RiskSignals
- Historical risk trend analysis
- Explanation for each risk factor
- Actionable steps to improve risk standing

**2. Social Engineering Warning System**
- Advanced risk detection when interacting with users
- Network analysis (mutual connections with high-risk users)
- Pattern detection (unusual transaction requests)

**3. Exportable Security Report**
- Generate PDF security report:
  - Identity verification status
  - Login history
  - Device security status
  - Breach check results
  - RiskScore explanation
- Useful for: landlord references, employer background checks

**4. Investigation Toolkit**
- Bulk profile risk checking (50 profiles at once)
- Compare multiple users' risk profiles
- Export risk comparison reports

**5. Priority Security Alerts**
- Instant alerts (vs delayed for Free/Premium)
- SMS/Email backup alerts
- Dedicated security support contact

#### Subscription Tier Matrix (Updated)

| Security Feature | Free | Premium (£4.99/mo) | Pro (£14.99/mo) |
|------------------|------|-------------------|-----------------|
| Email Breach Check (Manual) | ✅ | ✅ | ✅ |
| Real-Time Breach Monitoring | ❌ | ✅ | ✅ |
| Device Integrity Check | ✅ Basic | ✅ Advanced | ✅ Advanced |
| Login History | 3 months | 12 months | Unlimited |
| Identity Status View | ✅ | ✅ | ✅ |
| RiskScore Summary | Basic | Detailed | Full Insights |
| Security Alerts | In-app only | Push + In-app | Push + SMS/Email |
| Evidence Vault Health | Manual | Automated | Automated + Backup |
| Social Engineering Warnings | Basic | Advanced | Advanced + Network Analysis |
| Exportable Security Report | ❌ | ❌ | ✅ PDF |
| Investigation Toolkit | ❌ | ❌ | ✅ 50 profiles |

#### Stripe Billing Integration

**No New Stripe Products Required:**
- Security Center features tied to existing Premium/Pro subscriptions
- Use same Stripe account (SILENTSALE LTD)
- Feature flags control access:
  ```
  if (user.AccountType === 'Premium' || user.AccountType === 'Pro') {
    enableRealtimeBreachMonitoring();
  }
  ```

**Implementation Notes:**
- Security Center features are **enhancements** to existing tiers
- No separate "Security Center" subscription
- Premium/Pro already defined in Stripe
- Backend checks user's AccountType to enable features

---

## SECTION 17: SAFE DEVELOPMENT RULES

### Mandatory Development Safety Protocols

**CRITICAL: Before ANY agent makes a code change, they MUST:**

**1. Check Existing Code First**
- Use MCP filesystem tools to read relevant files
- Use MCP code-index to search for existing logic
- Use MCP grep to find similar patterns
- NEVER assume code doesn't exist

**2. Detect Conflicts**
- Search for duplicate functions
- Check for conflicting API endpoints
- Verify no namespace collisions
- Ensure no duplicate database tables/columns

**3. Follow Existing Architecture**
- Match existing code patterns
- Use existing services/controllers
- Follow existing naming conventions
- Respect existing folder structure

**4. Validate Before Implementation**
- If conflict detected → Stop and report to Agent A (Architect)
- Agent A must resolve and update CLAUDE.md
- Only proceed after conflict resolution

**5. Document Changes**
- Update API documentation
- Add code comments for complex logic
- Update database schema documentation
- Log architectural decisions

### Agent Responsibilities

**Agent A (Architect):**
- **MUST** review all architecture changes before implementation
- **MUST** detect conflicts between different agents' work
- **MUST** update CLAUDE.md when architecture evolves
- **MUST** ensure no duplicate endpoints/services/tables

**Agent B (Backend):**
- **MUST** check existing backend code before adding new endpoints
- **MUST** reuse existing services where possible
- **MUST** follow existing authentication/authorization patterns
- **MUST** not create duplicate database tables

**Agent C (Frontend):**
- **MUST** check existing Flutter code before adding new screens
- **MUST** reuse existing widgets/components
- **MUST** follow existing navigation patterns
- **MUST** not duplicate API calls

**Agent D (QA):**
- **MUST** test using MCP tools (playwright, code-executor)
- **MUST** validate API contracts match documentation
- **MUST** check for security vulnerabilities
- **MUST** report inconsistencies to Agent A

### Conflict Resolution Process

**When Conflict Detected:**

1. **Stop Implementation** - Do not proceed with conflicting code
2. **Document Conflict** - Write clear description of issue
3. **Report to Agent A** - Let Architect resolve
4. **Wait for Resolution** - Do not guess or proceed anyway
5. **Update CLAUDE.md** - Document resolution for future reference

**Example Conflict Scenarios:**

**Scenario 1: Duplicate Endpoint**
- Agent B wants to create: `POST /v1/admin/users/freeze`
- But endpoint already exists in different controller
- **Resolution:** Reuse existing endpoint, add admin authorization check

**Scenario 2: Duplicate Service Logic**
- Agent B wants to create: `RiskScoreCalculator`
- But `TrustScoreService` already calculates risk factors
- **Resolution:** Extend existing service, don't duplicate

**Scenario 3: Database Schema Conflict**
- Agent B wants to add: `AdminUsers` table
- But admin logic should use existing `Users` table with role
- **Resolution:** Add `Admin` enum to existing `AccountType` field

### Code Quality Standards

**All Code Must:**
- Follow C# conventions for backend (.NET)
- Follow Dart/Flutter conventions for frontend
- Include error handling for all API calls
- Never log sensitive data (OTPs, tokens, passwords)
- Use existing database context (don't create new connections)
- Follow existing authentication patterns
- Validate all inputs
- Return consistent error responses

**Forbidden Practices:**
- Creating duplicate logic
- Hardcoding secrets/keys
- Storing passwords anywhere
- Bypassing authentication
- Creating parallel implementations of same feature
- Ignoring existing patterns

---

## SECTION 18: DOMAIN STRUCTURE

### Official Domain Configuration

**Primary Domain:**
- `silentid.co.uk` (main domain)

**Subdomains:**
- `www.silentid.co.uk` (marketing landing page)
- `api.silentid.co.uk` (backend API - ASP.NET Core)
- `admin.silentid.co.uk` (admin dashboard web UI)
- `app.silentid.co.uk` (future web app if needed)

**NOT Used:**
- `silentid.app` (mentioned in examples, but actual domain is .co.uk)
- Correct all references: `https://silentid.app/` → `https://silentid.co.uk/`

### Company Information

**Legal Entity:**
SILENTSALE LTD (UK registered company)

**Operates:**
- SilentID (trust identity platform)
- SilentSale (marketplace platform - separate, not integrated in MVP)

**Stripe Account:**
- Single Stripe account for SILENTSALE LTD
- Handles both SilentID billing (Premium/Pro subscriptions)
- Handles SilentSale payments (future)

**Important:**
SilentID and SilentSale are **separate products** under same company.
- SilentID: Trust passport (standalone)
- SilentSale: Marketplace (future integration)
- MVP: SilentID only, no SilentSale integration

### URL Structure

**Public Profile URLs:**
```
https://silentid.co.uk/u/sarahtrusted
https://silentid.co.uk/@sarahtrusted (alternative)
```

**API Base URL:**
```
https://api.silentid.co.uk/v1/
```

**Admin Dashboard:**
```
https://admin.silentid.co.uk/
```

**Marketing Site:**
```
https://www.silentid.co.uk/ (homepage)
https://www.silentid.co.uk/about
https://www.silentid.co.uk/pricing
https://www.silentid.co.uk/privacy
https://www.silentid.co.uk/terms
```

### DNS Configuration (Future Reference)

**Required DNS Records:**
```
silentid.co.uk           A      → Azure App Service IP
www.silentid.co.uk       CNAME  → silentid.co.uk
api.silentid.co.uk       CNAME  → silentid-api.azurewebsites.net
admin.silentid.co.uk     CNAME  → silentid-admin.azurewebsites.net
```

**SSL Certificates:**
- Wildcard certificate: `*.silentid.co.uk`
- Managed by Azure App Service
- Auto-renewal enabled

---

## SECTION 19: SILENTID HELP CENTER SYSTEM

### SilentID Help Center System — Auto-Generated Support Content

#### 1. Purpose

The Help Center must:
- Automatically explain how SilentID works
- Guide users through common actions
- Provide troubleshooting steps
- Reduce support tickets
- Stay synchronized with claude.md as features evolve
- NEVER invent features that do not exist

#### 2. Source of Truth Rules

**CRITICAL RULES:**
- The Help Center must ONLY use information contained in claude.md
- If something is unclear or missing, Claude MUST ask for clarification before writing
- Claude must never guess, assume, or hallucinate features
- When claude.md is updated, the Help Center must update accordingly
- All Help Center content must be verifiable against claude.md sections

**Verification Process:**
- Before generating any article, Claude must reference the specific claude.md section
- Every claim must be traceable to a section number and line reference
- If a feature is mentioned in passing but not fully specified, mark it as "Coming Soon" not as active
- Never extrapolate or infer functionality beyond what is explicitly documented

#### 3. Structure of the Help Center

**Required Default Categories:**

**1) Getting Started**
- What SilentID is
- Who it is for
- Passwordless login methods (Apple, Google, Passkey, Email OTP only)
- Creating an account
- Verifying identity via Stripe

**2) Using SilentID**
- TrustScore explanation (0-1000 scale, 4 components)
- Security Center overview (if implemented)
- Evidence Vault usage (receipts, screenshots, profile links)
- Sharing your SilentID verification

**3) Account & Security**
- Lost device flow
- Login issues troubleshooting
- Email OTP problems
- Biometric/Passkey troubleshooting
- Device fingerprinting explanation

**4) Privacy & Data**
- What SilentID stores (email, verification status, evidence metadata)
- What SilentID does NOT store (passwords, ID documents, full emails)
- Stripe Identity handling (documents stored by Stripe only)
- How deletion works (GDPR rights: access, rectification, erasure, portability)

**5) Reporting & Safety**
- Reporting another user
- Scam warnings and risk flags
- RiskScore meaning (0-100 scale)
- Security alerts and notifications
- What happens after you report

**6) FAQs**
- Short, simple answers to common questions
- Updated as features evolve
- Examples:
  - "Why doesn't SilentID have passwords?"
  - "What's the difference between TrustScore and RiskScore?"
  - "Can I use SilentID on multiple devices?"
  - "How do I cancel Premium/Pro subscription?"

**7) Glossary**
- Definitions for technical terms:
  - **TrustScore:** 0-1000 point score based on Identity, Evidence, Behaviour, Peer Verification
  - **RiskScore:** 0-100 point fraud detection score (higher = more suspicious)
  - **Verification:** Identity check via Stripe Identity
  - **Passkey:** Biometric authentication using WebAuthn/FIDO2
  - **Evidence Vault:** Storage for receipts, screenshots, profile links
  - **Mutual Verification:** Both parties confirm a transaction occurred
  - **AccountType:** Free, Premium (£4.99/mo), Pro (£14.99/mo), Admin

#### 4. Article Format Requirements

**Every auto-generated article must follow this structure:**

```markdown
# [Article Title]

**Summary:** [1-2 sentence overview of what this article covers]

---

## What You'll Learn
- [Bullet point 1]
- [Bullet point 2]
- [Bullet point 3]

---

## Step-by-Step Instructions

### Step 1: [Action Name]
[Clear description of what to do]

### Step 2: [Action Name]
[Clear description of what to do]

### Step 3: [Action Name]
[Clear description of what to do]

---

## Troubleshooting

**Problem:** [Common issue users encounter]
**Solution:** [How to resolve it]

**Problem:** [Another common issue]
**Solution:** [How to resolve it]

---

## When to Contact Support

Contact SilentID support if:
- [Specific scenario where human help is needed]
- [Another scenario]

**Support:** support@silentid.co.uk

---

## Related Articles
- [Link to related article 1]
- [Link to related article 2]

---

**Last Updated:** [Date from claude.md update]
**Source:** Section [X] of SilentID Master Specification
```

**Image Placeholders:**
- Do NOT include actual images unless placeholders like:
  ```
  [Insert screenshot: screen_name_here]
  [Insert diagram: flow_name_here]
  ```
- Specify exactly what the screenshot should show

#### 5. Automatic Updating Rules

**Synchronization Protocol:**
- Whenever claude.md changes, the Help Center must be regenerated
- If a new feature is added to claude.md, a new article MUST be created
- If a feature is removed from claude.md, related articles MUST be updated or deleted
- If a feature changes significantly, existing articles MUST be rewritten
- Claude MUST confirm updates before applying changes

**Update Triggers:**
- claude.md version number changes
- New sections added to claude.md
- Existing sections significantly modified
- API endpoints added/changed/removed
- UI flows updated
- Subscription tiers modified

**Change Detection:**
- Compare current claude.md version with last Help Center generation version
- Identify changed sections by comparing section content hashes
- Generate diff report of what changed
- Ask user to confirm which changes should trigger Help Center updates

#### 6. Safety & Compliance Notes

**Content Restrictions (NEVER include in Help Center):**
- Legal advice
- Internal admin tools or endpoints
- Internal security logic or algorithms
- Risk scoring formulas or thresholds
- Backend implementation details
- Database schema or queries
- Stripe API keys or secrets
- Fraud detection methods
- Device fingerprinting techniques
- Anti-collusion algorithms

**Defamation-Safe Language:**
- Use same cautious language as specified in Section 4
- Never call users "scammers" or "fraudsters"
- Use: "safety concern flagged", "risk signals detected", "multiple reports received"

**Privacy Protection:**
- Never show how to access other users' private data
- Never reveal what data is stored in raw form
- Explain privacy controls clearly
- Emphasize GDPR rights

#### 7. Output Mode for Future Use

**Generation Command:**

When the operator runs:
```
Generate Help Center
```

Claude must:
1. **Read the entire claude.md first** (all sections, current version)
2. **Extract features and flows** from relevant sections
3. **Cross-reference** Section 5 (Core Features), Section 6 (Feature Flows), Section 9 (API Endpoints)
4. **Generate articles ONLY based on confirmed content** (no speculation)
5. **Ask questions if anything is unclear** (e.g., "Section 15 mentions Security Center but doesn't specify if it's implemented yet. Should I include this in Help Center?")
6. **Create article list** with titles and which claude.md sections they reference
7. **Wait for user confirmation** before generating full articles
8. **Generate articles** following the format in Section 4 of this specification
9. **Include source references** (section number, line range) at bottom of each article

**Validation Checklist Before Generation:**
- [ ] claude.md has been read completely
- [ ] Version number noted
- [ ] All referenced features exist in claude.md
- [ ] No hallucinated features included
- [ ] Defamation-safe language used
- [ ] No internal/security details exposed
- [ ] Privacy rules followed
- [ ] Article format followed exactly
- [ ] Source sections referenced correctly

**Output Format:**
```
Help Center Generation Report
==============================

Source: claude.md v1.2.0
Generated: [Date]
Articles Created: [Number]

Category: Getting Started
- Article 1: "Creating Your SilentID Account" (Source: Section 5, Section 6)
- Article 2: "Passwordless Login Methods" (Source: Section 5)
- Article 3: "Verifying Your Identity with Stripe" (Source: Section 5, Section 6)

Category: Using SilentID
- Article 4: "Understanding Your TrustScore" (Source: Section 3, Section 5, Section 6)
- Article 5: "Adding Evidence to Your Profile" (Source: Section 5, Section 6)

[etc...]

Next Steps:
1. Review article list above
2. Confirm articles to generate
3. Claude will generate full markdown for each article
```

#### 8. Example Articles (Templates)

**Example 1: "Creating Your SilentID Account"**

```markdown
# Creating Your SilentID Account

**Summary:** Learn how to create a SilentID account using passwordless authentication methods.

---

## What You'll Learn
- The 4 ways to create a SilentID account
- How passwordless authentication works
- What happens after you sign up

---

## Step-by-Step Instructions

### Step 1: Choose Your Sign-Up Method

SilentID offers 4 passwordless login methods:
1. **Apple Sign-In** - Use your Apple ID
2. **Google Sign-In** - Use your Google account
3. **Email OTP** - Receive a 6-digit code via email
4. **Passkey** - Use Face ID, Touch ID, or fingerprint

**Important:** SilentID never uses passwords. Your account is secured with modern authentication.

### Step 2: Complete Sign-Up Flow

**For Apple/Google:**
- Tap "Continue with Apple" or "Continue with Google"
- Authorize SilentID to access your email
- You'll be logged in automatically

**For Email OTP:**
- Enter your email address
- Check your inbox for a 6-digit code
- Enter the code within 5 minutes
- You're in!

**For Passkey:**
- Available after initial sign-up via another method
- Enable in Settings > Security > Set Up Passkey

### Step 3: Verify Your Identity (Optional but Recommended)

After signing up, you can verify your identity via Stripe:
- Increases your TrustScore
- Unlocks advanced features
- Takes 2-3 minutes

[Insert screenshot: identity_verification_intro_screen]

---

## Troubleshooting

**Problem:** "Email OTP code not arriving"
**Solution:**
- Check spam/junk folder
- Wait 2-3 minutes (email delays happen)
- Request a new code (max 3 per 5 minutes)

**Problem:** "This email already has an account"
**Solution:**
- SilentID allows only one account per email
- Try logging in instead of signing up
- If you forgot which method you used, try all 4 methods

---

## When to Contact Support

Contact SilentID support if:
- You're locked out after multiple failed OTP attempts
- You believe your account was created by someone else
- You need to merge multiple accounts (requires verification)

**Support:** support@silentid.co.uk

---

## Related Articles
- "Passwordless Login Methods Explained"
- "Verifying Your Identity with Stripe"
- "Understanding Your TrustScore"

---

**Last Updated:** 2025-11-21
**Source:** Section 5 (Core Features), Section 6 (Feature Flows & UI Copy)
```

**Example 2: "Understanding Your TrustScore"**

```markdown
# Understanding Your TrustScore

**Summary:** Learn how SilentID calculates your TrustScore and what it means.

---

## What You'll Learn
- What a TrustScore is and why it matters
- The 4 components of your TrustScore
- How to improve your TrustScore

---

## What is a TrustScore?

Your **TrustScore** is a 0-1000 point score that represents how trustworthy you are to deal with online.

**Score Ranges:**
- 801-1000: Very High Trust
- 601-800: High Trust
- 401-600: Moderate Trust
- 201-400: Low Trust
- 0-200: High Risk

[Insert screenshot: trustscore_overview_screen]

---

## The 4 Components

Your TrustScore is calculated from 4 areas:

### 1. Identity (200 points max)
- ✅ Stripe Identity verification: +200
- ✅ Email verified: included
- ✅ Phone verified: included
- ✅ Device consistency: included

### 2. Evidence (300 points max)
- Email receipts from marketplaces
- Screenshots of your seller profiles
- Public profile links (Vinted, eBay, Depop, etc.)
- Quality and integrity of evidence

### 3. Behaviour (300 points max)
- No safety reports against you
- On-time shipping patterns
- Account longevity
- Cross-platform consistency

### 4. Peer Verification (200 points max)
- Mutual verifications with other users
- Returning transaction partners
- Confirmed deals

---

## How to Improve Your TrustScore

**Quick Wins:**
1. Complete Stripe Identity verification (+200 points)
2. Add email receipts from past marketplace sales
3. Link your public seller profiles
4. Request mutual verifications from people you've traded with

**Long-Term:**
- Maintain a clean record (no reports)
- Build consistent transaction history
- Stay active across multiple platforms

---

## Troubleshooting

**Problem:** "My TrustScore is lower than expected"
**Solution:**
- Check the breakdown to see which components are low
- Add more evidence if Evidence score is low
- Complete identity verification if Identity score is low
- TrustScore regenerates weekly, so changes take time

**Problem:** "My TrustScore went down"
**Solution:**
- Check if you have new safety reports
- Check if evidence integrity issues were detected
- Review Risk Status in Security Center
- Contact support if you believe it's an error

---

## When to Contact Support

Contact SilentID support if:
- Your TrustScore dropped significantly without explanation
- You believe evidence was incorrectly flagged
- You have questions about a specific TrustScore component

**Support:** support@silentid.co.uk

---

## Related Articles
- "Adding Evidence to Your Profile"
- "Understanding Risk Signals"
- "Mutual Transaction Verification"

---

**Last Updated:** 2025-11-21
**Source:** Section 3 (System Overview), Section 5 (Core Features), Section 6 (Feature Flows)
```

#### 9. Content Generation Workflow

**Phase 1: Discovery**
1. Read claude.md completely
2. Extract all user-facing features
3. Map features to Help Center categories
4. Identify gaps (features without help articles)

**Phase 2: Planning**
1. Generate article list with titles
2. Assign each article to category
3. Reference source sections for each article
4. Present plan to user for approval

**Phase 3: Generation**
1. Generate full markdown for each approved article
2. Follow article format exactly
3. Include troubleshooting for complex topics
4. Add cross-references between related articles

**Phase 4: Validation**
1. Verify all claims against claude.md
2. Check for hallucinated features
3. Ensure defamation-safe language
4. Confirm no internal details exposed
5. Mark with source references

**Phase 5: Delivery**
1. Output all articles as markdown files
2. Generate index page with category structure
3. Include generation metadata (date, version, source sections)
4. Provide update instructions for future changes

---

## SECTION 20: CRITICAL SYSTEM REQUIREMENTS

### Critical System Requirements (Missing Items)

This section defines essential system requirements that must be implemented to ensure SilentID operates securely, legally, and reliably in production.

---

#### 20.1 ACCOUNT RECOVERY (NO PASSWORDS)

**Problem:**
Users may lose access to their SilentID account if they:
- Lose their device
- Delete their passkey
- Lose access to their email account
- Factory reset their phone

**CRITICAL RULE: No password-based recovery allowed.**

##### Recovery Methods (Secure Alternatives)

**Method 1: Stripe Identity Re-Verification**
- User must complete Stripe Identity verification again
- Must match original verified identity
- System compares:
  - Name
  - Date of birth
  - Document type
  - Biometric selfie
- If match confirmed → grant access to account

**Method 2: Secondary Identity Challenge**
- Selfie + liveness check
- Comparison against original Stripe Identity verification
- Device fingerprint re-binding required
- Email ownership confirmation (if email still accessible)

##### Recovery Flow

**Step 1: User Initiates Recovery**
- User taps "I lost my device" or "Can't access my account"
- System asks: "Do you still have access to your email?"

**Step 2: Email Access Check**
- **If YES:** Send OTP to registered email
  - User enters OTP
  - System triggers Stripe Identity re-verification
  - User completes ID + selfie
  - System compares with original verification
  - If match → grant access

- **If NO:** Escalate to manual admin review
  - User must contact support with proof of identity
  - Admin manually reviews case
  - Admin triggers Stripe Identity re-verification
  - If verified → admin grants access

**Step 3: Mandatory Security Actions**
- Force session reset (logout all devices)
- Require device re-binding
- Require new passkey setup (if previously enabled)
- Log recovery event in AdminAuditLogs

##### Security Rules

- Maximum 3 recovery attempts per 30 days
- Each failed recovery attempt increases cooldown period
- Recovery attempts logged with:
  - Timestamp
  - IP address
  - Device fingerprint
  - Stripe verification result
  - Admin decision (if manual review)

**Database Schema Addition:**
```sql
CREATE TABLE AccountRecoveries (
  Id UUID PRIMARY KEY,
  UserId UUID REFERENCES Users(Id),
  Method VARCHAR(50), -- StripeReverify, ManualReview
  Status VARCHAR(50), -- Pending, Approved, Denied
  RequestedAt TIMESTAMP,
  ResolvedAt TIMESTAMP,
  AdminUserId UUID NULL,
  StripeVerificationId VARCHAR(255) NULL,
  IPAddress VARCHAR(50),
  DeviceFingerprint VARCHAR(500),
  Reason TEXT,
  CreatedAt TIMESTAMP
);
```

**API Endpoints:**
```
POST /v1/account/recovery/request (Public)
POST /v1/account/recovery/verify (Public)
GET /v1/account/recovery/status/{id} (Public)
POST /v1/admin/account/recovery/{id}/approve (Admin)
POST /v1/admin/account/recovery/{id}/deny (Admin)
```

---

#### 20.2 ACCOUNT DELETION (GDPR COMPLIANT)

**GDPR Rights:**
Users have the right to:
- Request deletion of their personal data
- Receive confirmation of deletion
- Export their data before deletion

##### Deletion Flow

**Step 1: User Requests Deletion**
- User navigates to Settings > Account > Delete Account
- System shows warning:
  - "This action is permanent and cannot be undone"
  - "Your TrustScore and evidence will be permanently deleted"
  - "You have 30 days to cancel this request"
- User must type "DELETE" to confirm
- System sends email confirmation with cancellation link

**Step 2: Pending Deletion Period (30 Days)**
- Account marked as `AccountStatus = PendingDeletion`
- User cannot:
  - Add evidence
  - Create mutual verifications
  - File reports
  - Upgrade subscription
- User can:
  - Login (to cancel deletion)
  - Export data
  - View TrustScore (read-only)

**Step 3: Irreversible Deletion (After 30 Days)**
- System permanently deletes:
  - User profile (email, username, display name)
  - All evidence (receipts, screenshots, profile links)
  - TrustScore snapshots
  - Mutual verifications (user's side)
  - Sessions and auth devices
  - Subscription records (if no active disputes)

**What is RETAINED (Lawful Basis):**
- **Fraud & Security Logs (Anonymized):**
  - RiskSignals (UserId replaced with `[DELETED_USER]`)
  - AdminAuditLogs (for legal/compliance audits)
  - Security events (anonymized)
  - Retention: 7 years (UK legal requirement)

- **Dispute Evidence (If Active):**
  - If user has active Reports against them
  - Evidence tied to those reports retained
  - Lawful basis: Legal obligation + Legitimate interest (fraud prevention)
  - Retention: Until dispute resolved + 6 months

- **Financial Records (Stripe):**
  - Stripe retains billing records per legal requirements
  - SilentID only stores reference IDs, not full payment details

##### Database Implementation

**Soft Delete Strategy:**
```sql
-- Users table updated
ALTER TABLE Users ADD COLUMN DeletedAt TIMESTAMP NULL;
ALTER TABLE Users ADD COLUMN DeletionRequestedAt TIMESTAMP NULL;

-- Anonymization function
CREATE FUNCTION anonymize_user(user_id UUID) RETURNS VOID AS $$
BEGIN
  UPDATE Users SET
    Email = CONCAT('deleted_', user_id, '@deleted.local'),
    Username = CONCAT('deleted_', LEFT(user_id::TEXT, 8)),
    DisplayName = 'Deleted User',
    PhoneNumber = NULL,
    DeletedAt = NOW()
  WHERE Id = user_id;

  -- Anonymize all related data
  UPDATE RiskSignals SET UserId = NULL, Metadata = '{"user":"deleted"}' WHERE UserId = user_id;
  -- ... (similar for other tables)
END;
$$ LANGUAGE plpgsql;
```

**API Endpoints:**
```
POST /v1/account/deletion/request (User)
POST /v1/account/deletion/cancel (User)
GET /v1/account/deletion/status (User)
POST /v1/account/export (User) -- GDPR data export before deletion
```

##### User Data Export Format

Before deletion, user receives:
```json
{
  "export_date": "2025-11-21",
  "user": {
    "email": "user@example.com",
    "username": "@johndoe",
    "display_name": "John D.",
    "created_at": "2025-01-15",
    "account_type": "Premium"
  },
  "identity_verification": {
    "status": "Verified",
    "verified_at": "2025-01-15"
  },
  "trust_score": {
    "current_score": 754,
    "breakdown": {...}
  },
  "evidence": {
    "receipts": [...],
    "screenshots": [...],
    "profile_links": [...]
  },
  "mutual_verifications": [...],
  "reports_filed": [...],
  "subscription_history": [...]
}
```

---

#### 20.3 DUPLICATE ACCOUNT APPEALS

**Problem:**
SilentID's anti-duplicate logic may incorrectly block legitimate users if:
- Multiple family members share same device/IP
- User legitimately has multiple emails
- False positive from device fingerprinting

##### Appeal Process

**Step 1: User Blocked from Creating Account**
- System shows: "This device is already associated with a SilentID account"
- Button: "This is incorrect - Submit Appeal"

**Step 2: Appeal Submission**
- User enters:
  - Email they're trying to register
  - Reason for appeal
  - Optional: existing SilentID username (if they know it)
- System creates `DuplicateAccountAppeal` record

**Step 3: Admin Review**
- Admin reviews:
  - Device fingerprint match details
  - IP patterns
  - Email similarity
  - Stripe Identity results (if available)
  - Risk signals on existing account
- Admin options:
  - **Approve:** Allow user to create account (whitelist device/IP)
  - **Deny:** Confirm block is correct (fraud prevention)
  - **Request More Info:** Ask user for additional verification

**Step 4: Resolution**
- User notified via email
- If approved:
  - User can proceed with signup
  - Device/IP whitelisted for this specific email
  - Logged in AdminAuditLogs
- If denied:
  - User informed with reason
  - Can re-appeal after 30 days

##### Database Schema

```sql
CREATE TABLE DuplicateAccountAppeals (
  Id UUID PRIMARY KEY,
  Email VARCHAR(255) NOT NULL,
  DeviceFingerprint VARCHAR(500),
  IPAddress VARCHAR(50),
  Reason TEXT,
  Status VARCHAR(50), -- Pending, Approved, Denied, MoreInfoRequested
  ReviewedBy UUID NULL REFERENCES Users(Id), -- Admin user
  ReviewNotes TEXT,
  CreatedAt TIMESTAMP,
  ResolvedAt TIMESTAMP NULL
);
```

**API Endpoints:**
```
POST /v1/account/duplicate-appeal (Public)
GET /v1/admin/duplicate-appeals (Admin)
POST /v1/admin/duplicate-appeals/{id}/approve (Admin)
POST /v1/admin/duplicate-appeals/{id}/deny (Admin)
POST /v1/admin/duplicate-appeals/{id}/request-info (Admin)
```

---

#### 20.4 RATE LIMITING (GLOBAL & ENDPOINT-LEVEL)

**Purpose:**
Prevent abuse, brute-force attacks, and system overload.

##### Rate Limit Strategy

**Global Limits (Per IP Address):**
- 100 requests per minute
- 1000 requests per hour
- 5000 requests per day

**Endpoint-Specific Limits:**

| Endpoint | Limit | Window | Lockout |
|----------|-------|--------|---------|
| POST /v1/auth/request-otp | 3 requests | 5 minutes | 15 minutes |
| POST /v1/auth/verify-otp | 5 attempts | 10 minutes | 30 minutes |
| POST /v1/auth/passkey/login/challenge | 10 requests | 5 minutes | 10 minutes |
| POST /v1/identity/stripe/session | 3 requests | 1 hour | 24 hours |
| POST /v1/reports | 5 requests | 1 hour | None |
| POST /v1/evidence/* | 20 requests | 1 hour | None |
| GET /v1/public/profile/* | 100 requests | 1 minute | None |
| POST /v1/subscriptions/upgrade | 3 requests | 1 hour | None |

**Progressive Penalties:**
- 1st violation: Warning header in response
- 2nd violation: 5-minute timeout
- 3rd violation: 30-minute timeout
- 4th violation: 24-hour timeout
- 5th+ violation: RiskSignal created, account flagged

##### Implementation (ASP.NET Middleware)

```csharp
// Rate limiting using AspNetCoreRateLimit package
services.AddMemoryCache();
services.Configure<IpRateLimitOptions>(Configuration.GetSection("IpRateLimiting"));
services.Configure<IpRateLimitPolicies>(Configuration.GetSection("IpRateLimitPolicies"));
services.AddInMemoryRateLimiting();
services.AddSingleton<IRateLimitConfiguration, RateLimitConfiguration>();
```

**Configuration (appsettings.json):**
```json
{
  "IpRateLimiting": {
    "EnableEndpointRateLimiting": true,
    "StackBlockedRequests": false,
    "RealIpHeader": "X-Real-IP",
    "HttpStatusCode": 429,
    "GeneralRules": [
      {
        "Endpoint": "POST:/v1/auth/request-otp",
        "Period": "5m",
        "Limit": 3
      }
    ]
  }
}
```

**Logging:**
- All rate limit violations logged to AdminAuditLogs
- IP address, endpoint, timestamp, user (if authenticated)

---

#### 20.5 BOT & BRUTE-FORCE DEFENSE

**Multi-Layer Defense:**

**Layer 1: Silent CAPTCHA**
- Use Cloudflare Turnstile or hCaptcha (invisible mode)
- Triggered on:
  - Signup (after entering email)
  - Login (after 2 failed OTP attempts)
  - Report submission
  - Evidence upload (if suspicious patterns detected)

**Layer 2: IP & Device Anomaly Detection**
- Monitor for:
  - Same IP creating multiple accounts in short time
  - VPN/Tor exit nodes (flag, don't block)
  - Data center IPs (flag for review)
  - Unusual user-agent patterns
  - Device fingerprint mismatches

**Layer 3: Behaviour-Based Throttling**
- Track patterns:
  - Account created but never used (within 7 days)
  - Rapid sequential actions (< 1 second between requests)
  - Mouse/touch patterns (if frontend can detect)
  - Copy-paste detection on OTP field

**Layer 4: Automatic Flagging via RiskSignals**
- If anomaly detected:
  - Create RiskSignal with type `BotBehavior` or `BruteForce`
  - Increase RiskScore
  - If RiskScore > 40: Require Stripe Identity verification before account use
  - If RiskScore > 70: Temporary account freeze

**Integration:**
```csharp
// Cloudflare Turnstile verification
public async Task<bool> VerifyTurnstileToken(string token)
{
    var response = await _httpClient.PostAsync(
        "https://challenges.cloudflare.com/turnstile/v0/siteverify",
        new FormUrlEncodedContent(new[] {
            new KeyValuePair<string, string>("secret", _config.TurnstileSecretKey),
            new KeyValuePair<string, string>("response", token)
        })
    );

    var result = await response.Content.ReadAsAsync<TurnstileResponse>();
    return result.Success;
}
```

---

#### 20.6 INCIDENT RESPONSE REQUIREMENTS

**Critical Failures & Response Protocols:**

##### Failure Scenario 1: Stripe Outage

**Impact:**
- Cannot verify new identities
- Cannot process subscriptions
- Existing verified users unaffected

**Response:**
1. **Detection:** Health check endpoint fails (every 60 seconds)
2. **Automatic Fallback:**
   - Show banner: "Identity verification temporarily unavailable"
   - Allow users to:
     - Sign up (without verification)
     - Use app with limited TrustScore (max 200 points)
     - Queue verification for when Stripe recovers
3. **Communication:**
   - Email to admins
   - Status page update
   - User notification in-app
4. **Recovery:**
   - When Stripe recovers, process queued verifications
   - Update TrustScores automatically

##### Failure Scenario 2: Azure Region Failure

**Impact:**
- Database unavailable
- API unavailable
- Evidence files (Blob storage) unavailable

**Response:**
1. **Detection:** Database connection fails
2. **Automatic Failover:**
   - Route traffic to secondary Azure region (if configured)
   - Or: Display maintenance page
3. **Communication:**
   - Automated status page update
   - Email to all admins
   - Twitter/social media update (if prolonged)
4. **Data Protection:**
   - All databases backed up daily
   - Blob storage geo-redundant by default
5. **Recovery:**
   - Follow Azure disaster recovery plan
   - Restore from most recent backup if needed
   - Run integrity checks before reopening

##### Failure Scenario 3: Database Corruption

**Impact:**
- Data inconsistency
- Potential data loss
- System instability

**Response:**
1. **Detection:**
   - Automated data integrity checks (daily)
   - User reports of missing data
2. **Immediate Actions:**
   - Take system offline (maintenance mode)
   - Identify scope of corruption
   - Restore from latest clean backup
3. **Investigation:**
   - Review database logs
   - Identify root cause
   - Document in incident report
4. **Recovery:**
   - Restore data
   - Verify integrity
   - Inform affected users (if any)

##### Failure Scenario 4: System Compromise (Security Breach)

**Impact:**
- Unauthorized access to user data
- Potential data theft
- Regulatory notification requirements

**Response:**
1. **Detection:**
   - Intrusion detection alerts
   - Unusual admin activity
   - User reports
2. **Containment:**
   - Isolate affected systems
   - Revoke all sessions
   - Disable compromised accounts/credentials
3. **Investigation:**
   - Forensic analysis
   - Identify what was accessed
   - Document timeline
4. **Notification:**
   - **Within 72 hours:** Notify ICO (UK GDPR requirement)
   - **Within 7 days:** Notify affected users
   - Provide guidance on protective actions
5. **Remediation:**
   - Patch vulnerabilities
   - Reset all admin credentials
   - Enhanced monitoring for 90 days

**Incident Response Team:**
- **Incident Commander:** CTO or designated technical lead
- **Communications:** CEO (for public/regulatory communication)
- **Technical:** Lead backend engineer
- **Legal:** Company solicitor or external counsel
- **Support:** Customer support lead (user communication)

**Documentation Requirements:**
- All incidents logged in `IncidentLog` table
- Post-mortem document within 7 days
- Action items tracked and resolved

---

#### 20.7 AUDIT TRAIL EXTENSION

**Current Audit Coverage:**
- Admin actions only (AdminAuditLogs table)

**Extended Audit Coverage Required:**

##### Security Events

```sql
CREATE TABLE SecurityEvents (
  Id UUID PRIMARY KEY,
  UserId UUID NULL REFERENCES Users(Id),
  EventType VARCHAR(100), -- LoginSuccess, LoginFailure, OTPRequested, PasskeyUsed, SuspiciousActivity
  IPAddress VARCHAR(50),
  DeviceFingerprint VARCHAR(500),
  UserAgent TEXT,
  Metadata JSONB,
  CreatedAt TIMESTAMP
);
```

**Logged Events:**
- All login attempts (success + failure)
- OTP requests and verifications
- Passkey registrations and usage
- Device changes
- Suspicious login patterns
- Account recovery attempts
- Password-related attempts (should be zero - log as anomaly)

##### TrustScore Changes

```sql
CREATE TABLE TrustScoreChanges (
  Id UUID PRIMARY KEY,
  UserId UUID REFERENCES Users(Id),
  OldScore INT,
  NewScore INT,
  Reason VARCHAR(255), -- EvidenceAdded, ReportReceived, VerificationCompleted
  TriggeredBy VARCHAR(100), -- System, Admin, User
  Metadata JSONB,
  CreatedAt TIMESTAMP
);
```

**Logged Changes:**
- Every TrustScore recalculation
- Reason for change (evidence added, report filed, etc.)
- Component breakdown (Identity/Evidence/Behaviour/Peer)
- Who/what triggered the change

##### Verification Status Changes

```sql
CREATE TABLE VerificationChanges (
  Id UUID PRIMARY KEY,
  UserId UUID REFERENCES Users(Id),
  VerificationType VARCHAR(50), -- Identity, Email, Phone
  OldStatus VARCHAR(50),
  NewStatus VARCHAR(50),
  StripeVerificationId VARCHAR(255) NULL,
  AdminUserId UUID NULL,
  Reason TEXT,
  CreatedAt TIMESTAMP
);
```

**Logged Changes:**
- Identity verification status changes
- Email verification events
- Phone verification events
- Manual admin overrides

##### Recovery Attempts

All account recovery attempts logged in `AccountRecoveries` table (already defined in 20.1).

**Immutability Rules:**
- All audit tables are append-only (no UPDATE or DELETE allowed)
- Database triggers prevent modification
- Only admins with SuperAdmin role can access raw audit data
- Regular users can see their own security events (filtered view)

**Retention:**
- SecurityEvents: 2 years
- TrustScoreChanges: Indefinite (or until account deletion)
- VerificationChanges: 7 years (compliance requirement)
- AccountRecoveries: 7 years

**API Endpoints for User Access:**
```
GET /v1/account/security-events (User) -- User's own security events
GET /v1/account/trustscore-history (User) -- Already exists, ensure change log included
GET /v1/account/verification-history (User) -- New endpoint for verification changes
```

---

#### 20.8 FIRST-TIME ONBOARDING

**Purpose:**
Educate users about SilentID before requesting sensitive data.

**Onboarding Screens (Mandatory Sequence):**

**Screen 1: Welcome to SilentID**
- Title: "Your Portable Trust Passport"
- Description: "Build a verified reputation that works everywhere you trade online."
- Image: [Illustration of trust across platforms]
- Button: "Next"

**Screen 2: What is SilentID?**
- Title: "One Identity, Everywhere"
- Bullet points:
  - ✅ Prove you're trustworthy to buyers and sellers
  - ✅ Use across all marketplaces (Vinted, eBay, Depop, etc.)
  - ✅ Build your TrustScore with real evidence
  - ✅ Stay safe with verified identity checks
- Button: "Next"

**Screen 3: Why Verification Matters**
- Title: "Real People, Real Trust"
- Description: "SilentID uses Stripe to verify your identity. This helps everyone stay safe and builds confidence in your profile."
- Reassurance:
  - 🔒 Your ID documents are stored by Stripe, not SilentID
  - 🔒 Only you control what information is shared
  - 🔒 Verification takes 2-3 minutes
- Button: "Next"

**Screen 4: Your Privacy is Protected**
- Title: "Bank-Grade Security"
- Description: "We never store passwords, ID documents, or sensitive personal data."
- What we store:
  - ✅ Your email and verification status
  - ✅ Evidence you choose to add (receipts, screenshots)
  - ✅ Your TrustScore
- What we DON'T store:
  - ❌ Passwords (we don't use them!)
  - ❌ ID photos or documents
  - ❌ Your full personal details
- Button: "I Understand"

**Screen 5: How SilentID Benefits You**
- Title: "Start Building Trust Today"
- Benefits:
  - 📈 Higher TrustScore = More Sales
  - 🛡️ Verified badge shows you're legitimate
  - 💰 Earn trust across all platforms
  - 🎯 Stand out from scammers
- Button: "Create My SilentID"

**After Onboarding:**
- User proceeds to authentication (Apple/Google/Passkey/OTP)
- Onboarding screens never shown again
- User can review info in Settings > About SilentID

**UI Requirements:**
- Clean, minimal design
- Progress indicator (1 of 5, 2 of 5, etc.)
- "Skip" button disabled (must complete onboarding)
- Animations smooth and professional
- Royal purple #5A3EB8 accents

---

#### 20.9 FAILED ID VERIFICATION FLOW

**Stripe Identity Failure Reasons:**

| Reason | Description | User Action |
|--------|-------------|-------------|
| Blurry Document | Photo quality too poor | Retake photo in good lighting |
| Document Mismatch | Name/DOB doesn't match user info | Contact support |
| Unsupported ID Type | ID not accepted by Stripe | Try different document |
| Failed Liveness | Selfie doesn't match ID | Retake selfie, ensure face visible |
| Expired Document | ID has expired | Use current, valid ID |
| Technical Error | Stripe service issue | Try again later |

##### Retry Rules

**Automatic Retries Allowed:**
- Maximum 3 attempts per 24 hours
- Cooldown between attempts:
  - 1st retry: Immediate
  - 2nd retry: 1 hour wait
  - 3rd retry: 4 hours wait
- After 3 failures: 24-hour cooldown

**Manual Review Escalation:**
- After 3 failed attempts, user can request manual admin review
- Admin reviews:
  - Failure reasons
  - Submitted documents (via Stripe dashboard)
  - User account details
- Admin can:
  - Approve verification manually (with justification)
  - Extend retry limit
  - Deny permanently (with reason)

##### User Flow

**Step 1: Verification Fails**
- User sees: "Verification Unsuccessful"
- Reason displayed (from Stripe)
- Helpful tips:
  - "Make sure your ID is clear and well-lit"
  - "Ensure your face is fully visible in the selfie"
  - "Use a current, valid ID document"
- Button: "Try Again" (if retries available)

**Step 2: User Retries**
- Stripe Identity flow launches again
- User submits new photos
- System checks retry count

**Step 3: Max Retries Reached**
- User sees: "Maximum attempts reached"
- Message: "Please wait 24 hours before trying again, or contact support for help."
- Button: "Contact Support"

**Step 4: Manual Review Request**
- User submits support ticket
- Admin reviews within 48 hours
- Admin makes decision
- User notified via email

##### Database Tracking

```sql
CREATE TABLE IdentityVerificationAttempts (
  Id UUID PRIMARY KEY,
  UserId UUID REFERENCES Users(Id),
  StripeVerificationId VARCHAR(255),
  Status VARCHAR(50), -- Pending, Success, Failed
  FailureReason VARCHAR(255) NULL,
  AttemptNumber INT,
  CreatedAt TIMESTAMP,
  ResolvedAt TIMESTAMP NULL
);
```

**API Endpoints:**
```
GET /v1/identity/verification-attempts (User)
POST /v1/identity/manual-review/request (User)
GET /v1/admin/identity/manual-reviews (Admin)
POST /v1/admin/identity/manual-reviews/{id}/approve (Admin)
POST /v1/admin/identity/manual-reviews/{id}/deny (Admin)
```

---

#### 20.10 USER EDUCATION

**In-App Education Screens (Accessible from Settings > Learn About SilentID):**

**Topic 1: Why No Passwords?**
- Title: "SilentID is 100% Passwordless"
- Content:
  - Passwords are the #1 cause of account hacks
  - SilentID uses modern authentication instead:
    - 🍎 Apple Sign-In
    - 🔐 Google Sign-In
    - 🔑 Passkeys (Face ID / Touch ID)
    - 📧 Email OTP (one-time codes)
  - Your account is more secure without passwords
  - You can use multiple login methods at once

**Topic 2: How to Share Your SilentID Safely**
- Title: "Sharing Your Profile"
- Content:
  - Your public profile shows:
    - ✅ Username and display name (e.g., Sarah M.)
    - ✅ TrustScore
    - ✅ Verification badges
    - ✅ General activity metrics
  - Your public profile NEVER shows:
    - ❌ Full legal name
    - ❌ Email or phone
    - ❌ Address or location
    - ❌ ID documents
  - Safe sharing options:
    - Share profile link: silentid.co.uk/u/yourusername
    - Share QR code (in person)
    - Add to marketplace listings

**Topic 3: What is TrustScore?**
- Title: "Understanding Your TrustScore"
- Content:
  - TrustScore = 0-1000 points showing how trustworthy you are
  - Made up of 4 parts:
    - 🆔 Identity (200 pts): Verified via Stripe
    - 📦 Evidence (300 pts): Receipts, screenshots, profiles
    - ✨ Behaviour (300 pts): No reports, consistent activity
    - 🤝 Peer Verification (200 pts): Confirmed transactions
  - Score updates weekly
  - Higher score = more trust = more sales!
  - How to improve:
    1. Complete identity verification
    2. Add email receipts
    3. Link your marketplace profiles
    4. Get mutual verifications
    5. Maintain clean record (no reports)

**Access:**
- Settings > Help & Support > Learn About SilentID
- Also shown as tooltips/hints in relevant screens

---

#### 20.11 PRIVACY POLICY REQUIREMENTS

**SilentID Privacy Policy Must Include:**

##### Section 1: Introduction
- Who we are (SILENTSALE LTD)
- What SilentID does
- Contact details for privacy questions

##### Section 2: Data We Collect

**Personal Data:**
- Email address (required)
- Username (chosen by user)
- Display name (first name + initial)
- Phone number (optional)
- Device information (for security)
- IP address (for security and fraud prevention)

**Identity Verification Data (via Stripe):**
- IMPORTANT: "We do NOT store your ID documents"
- Stored by Stripe: ID photos, selfie, biometric data
- Stored by SilentID: Verification status, reference ID only

**Evidence Data:**
- Receipts (transaction details extracted, not full emails)
- Screenshots (images stored, OCR text extracted)
- Public profile URLs (scraped data, not credentials)

**Usage Data:**
- Login times and devices
- Feature usage patterns
- Error logs (anonymized)

##### Section 3: How We Use Your Data

**Lawful Bases:**

| Data Type | Lawful Basis | Purpose |
|-----------|--------------|---------|
| Email, account details | Legitimate Interest | Provide SilentID service |
| Email receipt scanning | Consent | Build evidence vault |
| Screenshot uploads | Consent + Legitimate Interest | Trust verification |
| Public profile scraping | Legitimate Interest | User requested verification |
| Identity verification | Legitimate Interest | Fraud prevention |
| Risk & anti-fraud | Legitimate Interest | Protect users |
| Subscription billing | Contract | Process payments |

##### Section 4: Third-Party Processors

**Stripe:**
- Identity verification
- Subscription billing
- Data location: EU/UK
- Privacy policy: stripe.com/privacy

**Microsoft Azure:**
- Database hosting
- File storage
- Data location: UK region
- Privacy policy: microsoft.com/privacy

**SendGrid / AWS SES:**
- Email delivery (OTP codes, notifications)
- Data location: EU
- Privacy policy: [provider-specific]

##### Section 5: Data Retention

| Data Type | Retention Period | Reason |
|-----------|------------------|--------|
| User accounts | Until deletion requested | Service provision |
| Evidence | Until user deletes or account deleted | Trust verification |
| Security logs | 7 years (anonymized after account deletion) | Legal requirement (UK) |
| Financial records | 7 years | Tax/legal requirement |
| Audit logs | 7 years | Compliance |

##### Section 6: Your Rights (GDPR)

**You have the right to:**
- ✅ **Access** your data (request full export)
- ✅ **Rectification** (correct inaccurate data)
- ✅ **Erasure** (delete your account)
- ✅ **Restriction** (limit how we use data)
- ✅ **Objection** (object to profiling/automated decisions)
- ✅ **Portability** (export in machine-readable format)
- ✅ **Withdraw consent** (e.g., stop email receipt scanning)

**How to exercise rights:**
- Email: privacy@silentid.co.uk
- In-app: Settings > Privacy > Request My Data
- Response time: Within 30 days

##### Section 7: Data Protection Officer (DPO)

- DPO Name: [To be appointed]
- Email: dpo@silentid.co.uk
- Address: [SILENTSALE LTD registered address]

##### Section 8: Complaints

If you're unhappy with how we handle your data:
1. Contact us first: privacy@silentid.co.uk
2. If unresolved, contact the ICO:
   - Website: ico.org.uk
   - Phone: 0303 123 1113

##### Section 9: Changes to Privacy Policy

- We'll notify users of material changes
- Updated policy posted in-app and on website
- Continued use = acceptance of changes

##### Section 10: Children's Privacy

- SilentID is not for users under 18
- We do not knowingly collect data from minors
- If we discover under-18 user, account deleted immediately

---

#### 20.12 DPIA REQUIREMENT

**Data Protection Impact Assessment (DPIA):**

**Why Required:**
- Identity verification = high-risk processing
- Special category data: Biometric data (via Stripe)
- Large-scale profiling (TrustScore system)
- Risk scoring affects user access/reputation

**DPIA Must Cover:**

1. **Description of Processing:**
   - What data is processed
   - How it's collected
   - Who has access
   - How long it's retained

2. **Necessity and Proportionality:**
   - Why processing is necessary
   - Whether less intrusive alternatives exist
   - Balance between user privacy and fraud prevention

3. **Risks to Individuals:**
   - Identity theft if data breached
   - Reputational harm from incorrect TrustScore
   - Exclusion from services if verification fails
   - Profiling discrimination concerns

4. **Mitigation Measures:**
   - Encryption (data at rest and in transit)
   - Access controls (role-based admin access)
   - Regular security audits
   - Incident response plan
   - User rights (access, correction, deletion)
   - Clear privacy notices

5. **Consultation:**
   - DPO consulted
   - Security team consulted
   - Legal team consulted
   - Users informed of processing

**DPIA Review Schedule:**
- Initial DPIA before launch
- Review annually
- Review when:
  - New features added
  - Data processing changes
  - New third-party processors added
  - Security incident occurs

**Responsibility:** CTO + DPO

---

#### 20.13 ICO REGISTRATION CONFIRMATION

**UK ICO Registration Required:**

**Legal Requirement:**
- SILENTSALE LTD must be registered with the UK Information Commissioner's Office (ICO)
- Required for all organizations processing personal data in the UK

**Registration Details:**
- Organization: SILENTSALE LTD
- Data protection fee: £40-60/year (depends on size/turnover)
- Registration renewal: Annual
- ICO registration number: [To be obtained]

**What to Register:**
- Purposes of processing:
  - Identity verification
  - Fraud prevention
  - Subscription billing
  - User account management
  - Marketing (if applicable)
- Categories of data subjects:
  - App users (18+)
  - Marketplace sellers/buyers
- Categories of data:
  - Identity data
  - Contact details
  - Financial data (via Stripe)
  - Device/usage data
- Third-party recipients:
  - Stripe
  - Microsoft Azure
  - Email providers

**Compliance Actions:**
1. Complete ICO registration before launch
2. Display registration number in Privacy Policy
3. Renew annually
4. Update ICO if processing activities change significantly

---

#### 20.14 AGE RESTRICTION ENFORCEMENT

**Rule: No users under 18 allowed.**

**Why:**
- Identity verification requires adult consent
- Marketplaces generally 18+
- GDPR additional protections for minors
- Legal liability concerns

##### Enforcement Methods

**Method 1: Stripe Identity Verification**
- Stripe extracts date of birth from ID document
- System calculates age
- If under 18 → Automatic account deletion

**Method 2: Self-Declaration (Pre-Verification)**
- During signup, user must confirm:
  - "I am 18 years of age or older"
  - Checkbox required to proceed
- Not legally binding, but creates awareness

**Method 3: Post-Signup Age Check**
- After Stripe verification completes:
  - System receives DOB from Stripe
  - Calculates age
  - If under 18:
    - Account immediately suspended
    - User notified: "SilentID is only available to users 18+"
    - Account deleted after 7 days (to allow appeal)

##### Appeal Process (Edge Cases)

**Scenario:** User is actually 18+, but Stripe misread DOB

**Steps:**
1. User contacts support: support@silentid.co.uk
2. Admin reviews:
   - Stripe verification data
   - User's claim
3. Admin can:
   - Request manual re-verification
   - Override if clear error
   - Maintain block if under 18 confirmed

##### Database Enforcement

```sql
-- Add age check to Users table
ALTER TABLE Users ADD COLUMN DateOfBirth DATE NULL;
ALTER TABLE Users ADD COLUMN IsAgeVerified BOOLEAN DEFAULT FALSE;

-- Trigger to check age after Stripe verification
CREATE FUNCTION check_user_age() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.DateOfBirth IS NOT NULL THEN
    IF EXTRACT(YEAR FROM AGE(NEW.DateOfBirth)) < 18 THEN
      UPDATE Users SET AccountStatus = 'Suspended', IsAgeVerified = FALSE WHERE Id = NEW.Id;
      -- Trigger notification to user
    ELSE
      UPDATE Users SET IsAgeVerified = TRUE WHERE Id = NEW.Id;
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER age_verification_trigger
AFTER UPDATE ON Users
FOR EACH ROW
WHEN (NEW.DateOfBirth IS NOT NULL)
EXECUTE FUNCTION check_user_age();
```

##### Admin Override (Exceptional Cases Only)

**Admin can manually approve under-18 user IF:**
- Legal guardian consent provided (written, notarized)
- Special circumstances (e.g., business registration for 16-17 year olds in UK)
- Full documentation retained
- Admin approval logged in AdminAuditLogs

**Database Logging:**
```sql
CREATE TABLE AgeExceptions (
  Id UUID PRIMARY KEY,
  UserId UUID REFERENCES Users(Id),
  DateOfBirth DATE,
  Reason TEXT,
  ApprovedBy UUID REFERENCES Users(Id),
  DocumentationUrl VARCHAR(500),
  CreatedAt TIMESTAMP
);
```

---

#### 20.15 SUBSCRIPTION FAILURE HANDLING

**Stripe Billing Failure Scenarios:**

**Scenario 1: Payment Method Declined**
- User's card declined
- Insufficient funds
- Expired card
- Bank rejected payment

**Scenario 2: Subscription Expired**
- User forgot to update payment method
- Bank changed card number

**Scenario 3: Chargeback / Dispute**
- User disputes charge with bank
- Card reported stolen

##### Handling Flow

**Step 1: Payment Fails**
- Stripe webhook notifies SilentID
- System creates `SubscriptionFailure` record
- User notified via email + in-app notification

**Step 2: Grace Period (7 Days)**
- User retains Premium/Pro features
- Banner shown: "Payment failed - please update payment method"
- Stripe automatically retries payment:
  - Day 3
  - Day 5
  - Day 7

**Step 3: Retry Schedule**
- If payment succeeds during grace period:
  - User remains Premium/Pro
  - No interruption
- If all retries fail:
  - Downgrade to Free tier
  - Email notification sent
  - User can manually retry in Settings

**Step 4: Feature Access After Downgrade**
- User immediately loses:
  - Premium badge
  - Bulk checks
  - Advanced analytics
  - Evidence vault over 250MB (read-only until space freed)
- User retains:
  - Existing TrustScore (read-only)
  - Existing evidence (cannot add more until Free limits)
  - Account access

##### Database Schema

```sql
CREATE TABLE SubscriptionFailures (
  Id UUID PRIMARY KEY,
  UserId UUID REFERENCES Users(Id),
  StripeSubscriptionId VARCHAR(255),
  FailureReason VARCHAR(255),
  AttemptedAt TIMESTAMP,
  RetryCount INT,
  Status VARCHAR(50), -- Pending, Resolved, Downgraded
  ResolvedAt TIMESTAMP NULL,
  CreatedAt TIMESTAMP
);
```

##### User Notifications

**Email:**
```
Subject: Action Required: SilentID Payment Failed

Hi [Name],

We couldn't process your SilentID Premium payment.

Reason: [Card declined / Insufficient funds / etc.]

What happens next:
- You have 7 days to update your payment method
- Your Premium features remain active during this time
- We'll automatically retry your payment

To update: https://silentid.co.uk/settings/subscription

Questions? Reply to this email.

Thanks,
SilentID Team
```

**In-App Banner:**
```
⚠️ Payment Failed
Your Premium subscription payment couldn't be processed.
[Update Payment Method] [Dismiss]
```

##### API Endpoints

```
GET /v1/subscriptions/payment-status (User)
POST /v1/subscriptions/retry-payment (User)
POST /v1/subscriptions/update-payment-method (User)
```

---

#### 20.16 REFUND POLICY

**Default Policy: No Refunds**

**Why:**
- Identity verification is a service, not a product
- Stripe charges are non-refundable
- User receives immediate value (verification, TrustScore)

##### Exceptions (Case-by-Case)

**Exception 1: Failed Verification (No Fault of User)**
- User paid for Premium to unlock verification
- Stripe verification repeatedly fails due to technical issues
- User unable to use primary value proposition
- **Action:** Refund subscription fee for that month

**Exception 2: Duplicate Charge**
- Stripe accidentally double-charged user
- **Action:** Immediate refund of duplicate charge

**Exception 3: System Error**
- SilentID bug caused incorrect charge
- **Action:** Full refund + apology credit

**Exception 4: Account Incorrectly Suspended**
- User suspended in error
- Lost paid subscription period
- **Action:** Refund pro-rated amount + extend subscription

##### Refund Request Process

**Step 1: User Requests Refund**
- Email: support@silentid.co.uk
- Subject: "Refund Request - [Reason]"
- Include:
  - Email address
  - Username
  - Reason for refund
  - Supporting evidence (screenshots, etc.)

**Step 2: Admin Review**
- Admin reviews:
  - Payment history
  - Subscription usage
  - Reason provided
- Admin decides:
  - Approve (full or partial refund)
  - Deny (with explanation)
- Response within 5 business days

**Step 3: Refund Processed**
- If approved:
  - Refund via Stripe (to original payment method)
  - Takes 5-10 business days to appear
  - User notified via email
- If denied:
  - Explanation provided
  - User can appeal to CTO if unsatisfied

##### Database Tracking

```sql
CREATE TABLE RefundRequests (
  Id UUID PRIMARY KEY,
  UserId UUID REFERENCES Users(Id),
  SubscriptionId UUID REFERENCES Subscriptions(Id),
  Reason TEXT,
  Amount DECIMAL,
  Status VARCHAR(50), -- Pending, Approved, Denied
  ReviewedBy UUID NULL REFERENCES Users(Id),
  ReviewNotes TEXT,
  ProcessedAt TIMESTAMP NULL,
  CreatedAt TIMESTAMP
);
```

**API Endpoints:**
```
POST /v1/subscriptions/refund/request (User)
GET /v1/admin/refunds (Admin)
POST /v1/admin/refunds/{id}/approve (Admin)
POST /v1/admin/refunds/{id}/deny (Admin)
```

---

#### 20.17 VAT HANDLING (UK)

**VAT Requirement:**
- Digital services sold in UK subject to VAT
- Current UK VAT rate: 20%
- Must be added to subscription prices
- SILENTSALE LTD must be VAT-registered (if turnover > £90,000/year)

##### Pricing with VAT

**Displayed Prices (VAT Inclusive):**
- Free: £0.00
- Premium: £4.99/month (£4.16 + £0.83 VAT)
- Pro: £14.99/month (£12.49 + £2.50 VAT)

**Stripe Configuration:**
```json
{
  "price": {
    "unit_amount": 499,
    "currency": "gbp",
    "tax_behavior": "inclusive"
  }
}
```

##### VAT Invoice Requirements

**Stripe Invoices Must Include:**
- SILENTSALE LTD company details
- VAT registration number
- Customer billing address
- Itemized charges
- VAT amount breakdown
- Total amount including VAT

**Example Invoice:**
```
Invoice #INV-12345
Date: 21 Nov 2025

Bill To:
John Doe
john@example.com

SILENTSALE LTD
VAT No: GB123456789
[Company Address]

Description: SilentID Premium Subscription
Period: 21 Nov 2025 - 21 Dec 2025

Subtotal: £4.16
VAT (20%): £0.83
Total: £4.99
```

##### Stripe Tax Configuration

Enable Stripe Tax for automatic VAT calculation:
```csharp
var options = new PriceCreateOptions
{
    Currency = "gbp",
    UnitAmount = 499, // £4.99 in pence
    Recurring = new PriceRecurringOptions
    {
        Interval = "month"
    },
    TaxBehavior = "inclusive" // VAT included in displayed price
};
```

##### EU Customers (If Selling Outside UK)

**Not in scope for MVP, but plan for:**
- Different VAT rates per EU country
- VAT MOSS registration (if EU sales > €10,000/year)
- Reverse charge mechanism for B2B sales

##### Record Keeping

**Legal Requirement:**
- Keep all VAT invoices for 6 years
- HMRC audit compliance
- Stripe provides invoice archive automatically

**Database:**
- Stripe stores all invoices
- SilentID stores reference to Stripe invoice ID only
- No need to duplicate VAT records

**API Endpoints:**
```
GET /v1/subscriptions/invoices (User) -- List user's invoices
GET /v1/subscriptions/invoices/{id} (User) -- Download specific invoice
```

---

## SECTION 21: SILENTID LANDING PAGE

### SilentID Landing Page — Sync Rules & Specification

#### Purpose

The SilentID landing page is the **primary public-facing website** for SilentID, hosted at `https://www.silentid.co.uk`. It serves as:
- First impression for potential users
- Product education and value proposition
- Trust and credibility builder
- Entry point to app download/signup

#### Location & Technology

**Project Location:**
- Directory: `/web/silentid-landing`
- Separate from SilentSale, admin dashboard, and Flutter app
- Technology: Next.js (React) with static export capability
- Hosting: Azure Static Web Apps or Vercel

**Domain Routing:**
- Production: `https://www.silentid.co.uk`
- API: `https://api.silentid.co.uk`
- Admin: `https://admin.silentid.co.uk`

#### Source of Truth Rules

**CRITICAL: `claude.md` is the single source of truth for ALL landing page content.**

**Synchronization Protocol:**
1. Landing page must NEVER define its own product spec
2. All product descriptions, features, flows, and terminology MUST come from `claude.md`
3. When `claude.md` is updated:
   - Landing page content MUST be reviewed and updated
   - Outdated features MUST be removed
   - New features MUST be added
4. No conflicting descriptions allowed
5. If feature removed from `claude.md` → remove from landing page
6. If feature added to `claude.md` → add to landing page
7. **AUTO-UPDATE RULE:** If any core product content changes in `claude.md`, automatically update landing page copy and regenerate UI components without duplication

**What to Extract from `claude.md`:**
- Section 1: Vision & Purpose → Hero messaging, core value proposition
- Section 2: Branding → All colors, typography, design tokens
- Section 3: System Overview → Feature descriptions
- Section 5: Core Features → Passwordless auth, identity verification, TrustScore, Evidence Vault
- Section 15: Security Center → Security Center features
- Section 12 & 16: Monetization → Pricing tiers (if displayed)
- Section 18: Domain Structure → URLs and legal entity

#### Content Structure

**Required Sections:**

**1. Hero Section**
- Headline: "Your Passport to Digital Trust" or "The Digital Trust Passport"
- Subheadline: "Verify your identity once, carry your trust everywhere you go online"
- Primary CTA: "Get Your SilentID" or "Join the Waitlist"
- Secondary CTA: "How It Works"
- Visual: SilentID app mockup showing TrustScore

**2. How It Works (4 Steps)**
Based on Section 5 & 6 from `claude.md`:
1. **Sign Up Passwordless** - Apple/Google/Passkey/Email OTP (no passwords)
2. **Verify Your Identity** - One-time Stripe Identity verification
3. **Build Your Trust Passport** - Add evidence, build TrustScore
4. **Use Everywhere** - Share via link, QR code, or profile badge

**3. Key Features Section**
Extract from Section 3 & 5:
- **Digital Trust Passport** - Portable reputation across platforms
- **TrustScore (0-1000)** - Identity + Evidence + Behaviour + Peer Verification
- **Security Center** - Breach monitoring, login alerts, device checks
- **Evidence Vault** - Receipts, screenshots, public profiles
- **100% Passwordless** - Apple, Google, Passkeys, Email OTP
- **Works Everywhere** - Marketplaces, dating apps, rentals, communities

**4. Safety & Anti-Scam Section**
Based on Section 4 & 7:
- Stripe Identity verification prevents fake accounts
- No passwords = no password breaches
- Device-bound security with passkeys
- GDPR compliant, UK-based
- Evidence-based trust (not claims)

**5. Use Cases**
Based on Section 1 (Primary Audiences):
- **For Individuals:** Prove trustworthiness, avoid scams, safer trading
- **For Platforms:** Optional integration, reduce fraud, trust signal

**6. App Preview**
- Screenshots of key screens (from Section 10 & 6):
  - Trust Passport screen
  - Security Center screen
  - Evidence Vault screen
  - Passwordless login screen

**7. FAQ Section**
Common questions with answers from `claude.md`:
- "What is SilentID?"
- "Is SilentID a password manager?" → NO
- "How is my identity verified?" → Stripe Identity
- "How does SilentID protect me from scams?" → Identity verification + evidence
- "Which platforms can I use SilentID on?" → Anywhere (link/QR/badge)
- "Do I have to show my real name?" → NO (display name only, e.g., "Sarah M.")
- "How does SilentID make money?" → Free, Premium (£4.99/mo), Pro (£14.99/mo)

**8. Footer**
- Legal: "SilentID is a product of SILENTSALE LTD. Company No. 16457502. Registered in England & Wales."
- Links: Terms, Privacy Policy, Contact
- Copyright notice
- SilentID logo

#### Design Tokens & Brand Consistency

**Must match Section 2 exactly:**

**Colors:**
```css
--primary-purple: #5A3EB8;
--dark-purple: #462F8F;
--soft-lilac: #E8E2FF;
--neutral-black: #0A0A0A;
--white: #FFFFFF;
--gray-900: #111111;
--gray-700: #4C4C4C;
--gray-300: #DADADA;
--success-green: #1FBF71;
--warning-amber: #FFC043;
--danger-red: #D04C4C;
```

**Typography:**
```css
--font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
--font-weight-bold: 700;
--font-weight-semibold: 600;
--font-weight-medium: 500;
--font-weight-regular: 400;
--font-weight-light: 300;
```

**Buttons:**
```css
--button-primary-bg: #5A3EB8;
--button-primary-text: #FFFFFF;
--button-radius: 12px;
--button-height: 52px;
--button-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
```

**Spacing:**
```css
--spacing-xs: 8px;
--spacing-sm: 16px;
--spacing-md: 24px;
--spacing-lg: 48px;
--spacing-xl: 64px;
```

#### Brand Personality Enforcement

**MUST feel:**
- Serious, calm, professional
- High-trust, evidence-driven
- Premium, minimal, precise
- Bank-grade security

**NEVER feel:**
- Juvenile or playful
- Social media style
- Cartoonish or loud
- "Startup cheap"

**Reference:** "Apple × Stripe × Revolut × Bank-level identity"

#### Quality Requirements

**Technical:**
- Lighthouse score: >90 (performance, accessibility, SEO)
- Fully responsive (mobile-first)
- Fast page load (<3s)
- Semantic HTML
- ARIA labels for accessibility

**Content:**
- All copy verified against `claude.md`
- No marketing fluff or unsubstantiated claims
- Clear, simple language
- Defamation-safe wording (same as Section 4)

**SEO:**
- Meta title: "SilentID - Your Digital Trust Passport"
- Meta description: "Verify your identity once, carry your trust everywhere. Passwordless, secure, portable reputation across marketplaces, dating apps, and communities."
- Open Graph tags
- Schema.org markup

#### Maintenance & Updates

**When `claude.md` changes:**
1. Review updated sections
2. Identify affected landing page content
3. Update text, features, or sections accordingly
4. Test for consistency
5. Deploy updated landing page

**Version Tracking:**
- Landing page should reference `claude.md` version
- Note in footer or metadata: "Reflects SilentID Specification v1.3.0"

#### File Structure

```
/web/silentid-landing/
├── package.json
├── next.config.js
├── tailwind.config.js
├── public/
│   ├── images/
│   ├── icons/
│   └── mockups/
├── src/
│   ├── app/
│   │   ├── page.tsx (home)
│   │   ├── layout.tsx
│   │   └── globals.css
│   ├── components/
│   │   ├── Hero.tsx
│   │   ├── HowItWorks.tsx
│   │   ├── Features.tsx
│   │   ├── Safety.tsx
│   │   ├── UseCases.tsx
│   │   ├── AppPreview.tsx
│   │   ├── FAQ.tsx
│   │   └── Footer.tsx
│   ├── config/
│   │   ├── tokens.ts (design tokens)
│   │   ├── content.ts (extracted from claude.md)
│   │   └── metadata.ts (SEO)
│   └── styles/
│       └── globals.css
└── README.md
```

#### Deployment

**Development:**
```bash
npm install
npm run dev
```

**Production Build:**
```bash
npm run build
npm run export  # Static export for Azure Static Web Apps
```

**Hosting:**
- Azure Static Web Apps (recommended)
- Vercel (alternative)
- Custom domain: www.silentid.co.uk

#### Documentation

**README.md must include:**
- How to run locally
- How content syncs with `claude.md`
- How to update when spec changes
- Deployment process
- Design token usage

---


---

## SECTION 22: PARTNER TRUSTSIGNAL API (EXTERNAL INTEGRATION)

### 22.1 Purpose

The Partner TrustSignal API enables external platforms to query high-level trust and risk summaries for SilentID users through a secure, server-to-server interface.

**Post-MVP / Phase 2+:** Not required for initial MVP delivery.

### 22.2 Access Model

**Authentication:**
- OAuth2 Client Credentials flow
- Or signed server-to-server API keys
- Partners receive unique credentials with defined scopes
- Configurable rate limits per partner
- No browser or client-side access permitted

**Partner Onboarding:**
- Manual approval process
- Signed data processing agreement
- API credentials issued
- Rate limits configured
- Access logs monitored

### 22.3 User Identifiers

**Partner queries MUST reference users by:**
- Public username (e.g., `@alice123`)
- Or public profile URL (`https://silentid.co.uk/u/alice123`)

**Internal user IDs must NEVER be exposed to partners.**

### 22.4 Conceptual API Endpoints

**1. GET /api/partner/v1/trust-summary**

Request:
```json
{
  "username": "@alice123"
}
```

Response:
```json
{
  "username": "@alice123",
  "trust_level": "high",
  "trust_score_band": "801-900",
  "identity_verified": true,
  "account_age_days": 180,
  "last_activity_days": 2
}
```

**2. GET /api/partner/v1/risk-summary**

Request:
```json
{
  "username": "@alice123"
}
```

Response:
```json
{
  "username": "@alice123",
  "risk_level": "low",
  "safety_reports_count": 0,
  "risk_signals_active": false,
  "recommendation": "proceed_normal"
}
```

**3. GET /api/partner/v1/public-profile**

Request:
```json
{
  "username": "@alice123"
}
```

Response:
```json
{
  "username": "@alice123",
  "display_name": "Alice M.",
  "trust_score": 847,
  "identity_verified": true,
  "verified_platforms_count": 3,
  "account_created": "2025-05-15"
}
```

**Response Fields Must:**
- Be high-level aggregates only
- Avoid exposing personal data
- Avoid revealing algorithmic details
- Use defamation-safe language
- Never include reporter information

### 22.5 Privacy & Data Protection Rules

**NEVER return:**
- Raw screenshots, receipts, or uploaded evidence
- Public profile URLs that were scraped
- IP addresses, device fingerprints, or location data
- Names or details of users who filed reports
- Exact TrustScore calculation formulas
- Internal risk signal weights or thresholds

**Only return:**
- Aggregated trust/risk bands
- Public profile information already visible on silentid.co.uk
- Account age and verification status
- High-level safety signal counts (not details)

### 22.6 Abuse Prevention

**Rate Limiting:**
- Per-partner limits (e.g., 100 requests/minute)
- Burst limits to prevent scraping
- Dynamic throttling on suspicious patterns

**Security Monitoring:**
- Log all API requests with timestamps
- Detect anomalous query patterns
- Alert on excessive failed requests
- Automatic key suspension on abuse detection

**Key Management:**
- Partners can rotate keys via admin portal
- SilentID can revoke keys immediately if abuse detected
- All key operations logged in AdminAuditLogs

### 22.7 Use Cases

**Primary Use Cases:**
- **Marketplaces:** SilentSale, rental platforms validating user trust before allowing transactions
- **Dating Apps:** Optional trust badge integration
- **Community Platforms:** Moderators checking new member trust levels
- **Service Providers:** Tradesperson platforms verifying service provider reliability

**NOT for:**
- Mass profiling or surveillance
- Credit decisions
- Employment screening (unless explicitly permitted)
- Law enforcement (must use legal channels)

### 22.8 Legal & Compliance

**Data Processing Agreement Required:**
- Partner must sign DPA covering:
  - Lawful basis for processing
  - User consent requirements
  - Data retention limits
  - Security measures
  - Incident response obligations

**GDPR Compliance:**
- Partners must respect user rights (access, deletion, etc.)
- Partners must display privacy notices to users
- Partners must NOT combine SilentID data with sensitive categories

**Liability:**
- SilentID provides signals, NOT guarantees
- Partners responsible for their own decision-making
- API terms must include liability limitations

---

## SECTION 23: QR TRUST PASSPORT SYSTEM

### 23.1 Purpose

Enable SilentID users to share their trust profile in-person via QR codes for local trades, meetups, rental viewings, and community events.

**Post-MVP / Phase 2+:** Static QR generation may be included in MVP; dynamic time-bound QR is future-only.

### 23.2 QR Code Types

**1. Static QR Code**
- Encodes the user's public profile URL
- Format: `https://silentid.co.uk/u/username`
- Never expires
- No tracking or analytics
- Can be generated client-side

**2. Dynamic QR Code (Future)**
- Generates a time-bound signed token
- Token includes:
  - User ID (encrypted)
  - Expiry timestamp
  - Optional context metadata (e.g., "viewing at 3pm")
- Scanner redirects to public profile after validation
- Token expires after configurable duration (e.g., 15 minutes)
- Enables analytics (how many times scanned, when, where)

### 23.3 Security & Privacy

**Static QR:**
- Contains NO personal data beyond public username
- User can disable public profile to invalidate QR
- No tracking possible

**Dynamic QR (Future):**
- Signed with server-side secret key
- Token cannot be forged or reused after expiry
- User can revoke all issued tokens in Settings
- Scanner sees only public profile, never raw token data

**User Controls:**
- Settings toggle: "Allow QR code sharing"
- Option to hide public profile (disables QR)
- View QR scan history (for dynamic QR only)

### 23.4 User Experience

**Share Profile Screen (Mobile App):**
- "Share Your SilentID" button
- Options:
  - Copy Link
  - Show QR Code
  - Share via messaging app

**QR Display Screen:**
- Full-screen QR code
- Username displayed below
- TrustScore badge shown
- "Scan this code to view my SilentID profile"
- Dynamic QR shows expiry timer (future)

**QR Scanning:**
- Any standard QR scanner app works
- Redirects to public profile in browser
- Mobile deep link to SilentID app (if installed)

### 23.5 Use Cases

**Local Meetups:**
- Marketplace buyers/sellers meeting in person
- Roommate viewings
- Community group introductions
- Parent groups verifying other parents

**Events:**
- Networking events with trust verification
- Trade shows (for professional profiles, future)

**Emergency Verification:**
- Quick trust check before accepting a ride/delivery
- Verifying service provider identity

---

## SECTION 24: TRUSTSCORE APPEAL & REVIEW SYSTEM

### 24.1 Purpose

Provide users with a formal, transparent pathway to challenge evidence, flags, reports, or TrustScore outcomes they believe are incorrect or unfair.

**Post-MVP / Phase 2+:** Not required in initial MVP.

### 24.2 What Can Be Appealed

**Eligible for Appeal:**
1. **Specific Evidence Items:**
   - Receipt marked as suspicious/invalid
   - Screenshot flagged as tampered
   - Public profile link rejected

2. **Safety Reports:**
   - Report filed against user
   - Public safety warning on profile

3. **TrustScore Components:**
   - Identity score (if verification failed incorrectly)
   - Evidence score (if evidence wrongly excluded)
   - Behaviour score (if pattern detection error)
   - Peer verification score (if mutual verification disputed)

4. **Account Actions:**
   - Temporary suspension
   - Feature restrictions
   - Public profile visibility

**NOT Eligible for Appeal:**
- Overall TrustScore number (derived from components)
- Other users' profiles or scores
- Marketplace/platform decisions (outside SilentID)

### 24.3 User Appeal Flow

**Step 1: Initiate Appeal**
- User navigates to Settings > Appeals & Reviews
- Selects appeal target (evidence, report, score component)
- Views current status and reason

**Step 2: Submit Explanation**
- Text field: "Explain why you believe this is incorrect"
- Character limit: 500 words
- Optional: Upload supporting evidence (e.g., proof of correction)
- Acknowledge: "Appeals are reviewed by SilentID staff within 5 business days"

**Step 3: Appeal Submitted**
- Appeal created with status: Pending
- User receives email confirmation
- Appeal tracked in Settings > My Appeals

**Step 4: Track Progress**
- Appeal status: Pending / Under Review / Resolved
- User can view admin notes (sanitised)
- User cannot submit duplicate appeals for same item

### 24.4 Admin Review Flow

**Step 1: Admin Reviews Appeal**
- Admin accesses Appeals Queue in admin dashboard
- Filters: Pending / Priority / Oldest first
- Views:
  - User's explanation
  - Original evidence/report/score component
  - System logs and integrity checks
  - Risk signals and fraud indicators
  - User's appeal history

**Step 2: Admin Decision**

**Decision Options:**
1. **Uphold Original Decision**
   - Reason: Evidence supports original assessment
   - Action: No changes made
   - User notified with neutral explanation

2. **Adjust or Correct**
   - Reason: Error identified or new evidence provided
   - Action: Evidence re-scored, report removed, TrustScore recalculated
   - User notified: "Your appeal has been upheld"

3. **Partially Uphold**
   - Reason: Some aspects correct, others not
   - Action: Partial adjustment
   - User notified with detailed breakdown

4. **Escalate to Senior Review**
   - Reason: Complex case requiring additional expertise
   - Action: Routed to senior admin or legal review
   - User notified: "Your appeal is under extended review"

**Step 3: Communication**
- Admin writes response (max 200 words)
- Response must use:
  - Neutral, factual language
  - Evidence-based reasoning
  - Defamation-safe wording
  - Clear next steps (if any)

**Step 4: Closure**
- Appeal status set to: Resolved
- User and admin notified
- All actions logged in AdminAuditLogs

### 24.5 Language Requirements

**MUST use:**
- "Based on the evidence provided..."
- "Our review identified..."
- "The original assessment stands because..."
- "We have adjusted..."

**MUST NOT use:**
- "You are wrong"
- "This is fraudulent"
- "You are lying"
- "This is obviously fake"

**Tone:** Professional, neutral, evidence-based, respectful.

### 24.6 Appeal Limits

**To prevent abuse:**
- Maximum 3 appeals per 30 days per user
- Cannot appeal same item twice
- Frivolous appeals may result in temporary appeal suspension
- Users with RiskScore > 80 have appeals manually reviewed for patterns

### 24.7 Database Schema

```sql
CREATE TABLE Appeals (
  Id UUID PRIMARY KEY,
  UserId UUID REFERENCES Users(Id),
  TargetType VARCHAR(50), -- Evidence, Report, ScoreComponent, AccountAction
  TargetId UUID, -- Reference to specific item
  Reason TEXT, -- User's explanation
  Status VARCHAR(50), -- Pending, UnderReview, Resolved, Escalated
  AdminUserId UUID NULL REFERENCES Users(Id),
  AdminDecision VARCHAR(50) NULL, -- Upheld, Adjusted, PartiallyUpheld, Escalated
  AdminNotes TEXT NULL,
  CreatedAt TIMESTAMP,
  ReviewedAt TIMESTAMP NULL,
  ResolvedAt TIMESTAMP NULL
);
```

---

## SECTION 25: RISK & ANOMALY SIGNALS (DETAILED SPECIFICATION)

### 25.1 Purpose

Define all risk signals used by the Risk Engine to calculate RiskScore (0-100) and inform admin decisions.

**Post-MVP:** Full catalogue is future work; basic subset may appear in MVP.

### 25.2 Signal Categories

**1. Identity & Device Signals**
- Multiple accounts from same device
- VPN/Tor usage patterns
- Device fingerprint mismatch
- Rapid IP geo-location changes
- Suspicious user-agent patterns
- Known fraud device database matches

**2. Behaviour & Transaction Signals**
- Account created but never used (7+ days inactive)
- Rapid sequential actions (< 1 second between requests)
- Evidence upload patterns (e.g., 50 receipts uploaded in 1 minute)
- Mutual verification circular patterns
- Multiple failed login attempts
- Unusual time-of-day activity (e.g., 3am bulk uploads)

**3. Evidence Integrity Signals**
- Screenshot tampering detected
- Receipt DKIM/SPF validation failed
- Duplicate evidence across multiple users
- Evidence timestamp inconsistencies
- Public profile URL mismatch with username
- Evidence quality score below threshold

**4. Network & Location Signals**
- IP address on known fraud list
- Country mismatch with claimed location
- High-risk ASN (data center, hosting provider)
- Shared IP with other flagged accounts
- Location impossible travel (e.g., UK → Australia in 2 hours)

**5. Reporting & Safety Signals**
- User has 1+ verified reports against them
- User has 3+ unverified reports (pending review)
- User filed 5+ reports that were dismissed (possible false reporting)
- User reported by high-trust users

### 25.3 RiskScore Calculation

**RiskScore Range:** 0-100 (higher = more risky)

**Weight Examples:**
- Fake evidence detected: +30
- Identity verification mismatch: +20
- Device fingerprint inconsistency: +10
- VPN usage (non-malicious): +5
- 1 verified report: +10
- 3+ verified reports: +30
- Collusion pattern detected: +20

**RiskScore Bands:**

| Score | Level | Internal Action |
|-------|-------|-----------------|
| 0-20 | Low | No action |
| 21-40 | Mild | Monitoring only |
| 41-60 | Elevated | Warning banner on profile, encourage ID verification |
| 61-80 | High | Mandatory identity re-check, evidence uploads disabled |
| 81-100 | Critical | Account frozen, admin notified immediately |

**External API Simplified Bands:**
- 0-40: "OK"
- 41-70: "CAUTION"
- 71-100: "REVIEW"

### 25.4 Signal Tuning & Configuration

**Risk signal weights stored in database configuration table:**
```sql
CREATE TABLE RiskSignalWeights (
  Id UUID PRIMARY KEY,
  SignalType VARCHAR(100),
  Weight INT, -- Points added to RiskScore
  IsActive BOOLEAN,
  UpdatedAt TIMESTAMP,
  UpdatedBy UUID REFERENCES Users(Id)
);
```

**All weight changes:**
- Must be logged in AdminAuditLogs
- Require admin justification
- Automatically recalculate affected user RiskScores

### 25.5 Signal Display Rules

**Internal Admin View:**
- Full list of active signals
- Signal severity (low/medium/high)
- Timestamp of detection
- Linked evidence or events

**User View (Settings > Risk Status):**
- Sanitised, high-level summary
- Example: "Device inconsistency detected"
- Clear actions to resolve (e.g., "Verify your identity")
- NO exposure of internal detection logic

**External API:**
- Only return aggregated risk level ("low", "medium", "high")
- Never return specific signals or weights

---

## SECTION 26: EVIDENCE INTEGRITY ENGINE

### 26.1 Purpose

Ensure all uploaded evidence is authentic, consistent, and not duplicated fraudulently across the platform.

**Post-MVP:** Basic checks in MVP; full engine in Phase 2+.

### 26.2 Evidence Types Covered

1. **Screenshots** (marketplace reviews, profile stats, messages)
2. **Email Receipts** (order confirmations, shipping notifications)
3. **Public Profile URLs** (Vinted, eBay, Depop, etc.)

### 26.3 Screenshot Integrity Checks

**Level 1: Metadata Validation**
- EXIF data extraction
- Image resolution and format checks
- Timestamp plausibility (not future-dated)
- File size consistency with resolution

**Level 2: Visual Consistency**
- OCR text extraction and layout analysis
- Known UI pattern matching (e.g., Vinted app screenshots)
- Color palette consistency with platform branding
- Font rendering consistency

**Level 3: Tampering Detection**
- Pixel-level manipulation analysis (e.g., clone stamping)
- Edge inconsistency detection (copy-paste artifacts)
- Noise pattern analysis
- Compression artifact detection

**Level 4: Content Validation**
- Username consistency across screenshots
- Rating/review count plausibility
- Date consistency with other evidence

**Integrity Score:** 0-100 (higher = more trustworthy)

| Score | Classification | Action |
|-------|---------------|---------|
| 90-100 | High Quality | Full weight in TrustScore |
| 70-89 | Acceptable | Partial weight |
| 50-69 | Questionable | Flagged for review, reduced weight |
| 0-49 | Suspicious | Rejected, creates RiskSignal |

### 26.4 Email Receipt Integrity Checks

**DKIM/SPF Validation:**
- Verify sender domain authenticity
- Check DKIM signature (if available)
- Validate SPF records

**Content Validation:**
- Sender domain matches known marketplaces (vinted.com, ebay.com, etc.)
- Email structure matches known templates
- Order ID format validation
- Amount/date/item plausibility

**Duplicate Detection:**
- Hash email content
- Check if same receipt uploaded by multiple users
- Check if same receipt uploaded multiple times by same user

**Integrity Score:** 0-100

### 26.5 Public Profile URL Integrity

**Validation Checks:**
- URL format matches platform (e.g., https://vinted.com/member/123456)
- Profile is publicly accessible (not 404/private)
- Username on profile matches SilentID username (fuzzy matching)
- Profile metrics consistent with other evidence

**Scraping Verification:**
- Playwright headless browser scrape
- Extract: username, reviews, rating, join date, listings count
- Compare with user-provided data
- Detect discrepancies

**Duplicate Detection:**
- Check if same URL claimed by multiple SilentID users (fraud flag)
- Check if URL changes after initial verification (suspicious)

### 26.6 Cross-Evidence Consistency

**Consistency Checks:**
- Do screenshots match public profile data?
- Do receipt dates align with account age?
- Do transaction counts across evidence types match?
- Do usernames across all evidence types match?

**Inconsistency Examples:**
- User claims 500 transactions in receipts but public profile shows 50
- Screenshots show username "alice123" but profile URL is "bob456"
- Receipt dates are all from 2020 but account created in 2025

**Action on Inconsistency:**
- Create RiskSignal
- Flag evidence for admin review
- Reduce TrustScore until resolved

### 26.7 Deduplication System

**Hash-Based Deduplication:**
```sql
CREATE TABLE EvidenceHashes (
  Id UUID PRIMARY KEY,
  EvidenceId UUID REFERENCES Evidence(Id),
  HashType VARCHAR(50), -- MD5, SHA256, PerceptualHash
  HashValue VARCHAR(255),
  CreatedAt TIMESTAMP,
  INDEX(HashValue)
);
```

**Deduplication Rules:**
- Same evidence within same user:
  - First instance: Full weight
  - Duplicates: Zero weight, warning shown
- Same evidence across different users:
  - Both users flagged
  - Evidence invalidated
  - RiskSignal created
  - Admin review triggered

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

---

## SECTION 27: EVIDENCE DELETION & EVIDENCE LIFECYCLE

### 27.1 Purpose

Define how evidence is retained, deleted, and expired to ensure GDPR compliance and system integrity.

**Post-MVP:** Basic delete only; full lifecycle management in Phase 2+.

### 27.2 User-Initiated Evidence Deletion

**Flow:**
1. User navigates to Evidence Vault
2. Selects evidence item (receipt, screenshot, profile link)
3. Taps "Delete Evidence"
4. Confirmation prompt: "This evidence will be removed from your TrustScore calculation"
5. User confirms

**System Actions:**
- Soft delete evidence record (DeletedAt timestamp set)
- Remove file from Azure Blob Storage (schedule for batch deletion)
- Recalculate TrustScore immediately
- Log deletion in user audit trail

**Impact:**
- TrustScore updated within seconds
- Deleted evidence NOT shown in public profile
- Deleted evidence NOT returned in API responses
- Deleted evidence retained in logs for fraud investigation (anonymised after 30 days)

### 27.3 Automatic Evidence Expiry (Future)

**Expiry Rules (Configurable):**
- Receipts: No expiry (permanent unless user deletes)
- Screenshots: Expire after 2 years (configurable)
- Public profile links: Re-verified every 6 months

**Expiry Actions:**
- Evidence marked as Expired
- User notified: "Your screenshot evidence has expired. Upload a new one to maintain your TrustScore."
- TrustScore recalculated with expired evidence excluded
- Expired evidence soft-deleted after 30 days

### 27.4 Account Deletion Cascade

**When user deletes account (Section 20.2):**

**Immediate Actions:**
1. User profile anonymised
2. All evidence soft-deleted
3. TrustScore snapshots retained (anonymised)
4. Public profile removed

**30-Day Grace Period:**
- User can cancel deletion
- Evidence NOT permanently deleted yet
- Public profile remains inaccessible

**After 30 Days (Irreversible):**
1. Permanently delete:
   - All evidence files from Azure Blob
   - User personal data (email, username, etc.)
   - Sessions and auth devices
2. Retain (anonymised):
   - RiskSignals (UserId replaced with `[DELETED_USER]`)
   - AdminAuditLogs (for legal compliance)
   - Anonymised TrustScore snapshots (for fraud research)
3. Retention period: 7 years (UK legal requirement)

### 27.5 Admin-Initiated Evidence Removal

**Reason: Fraudulent or Harmful Evidence**

**Admin Actions:**
1. Admin reviews evidence
2. Decision: Remove Evidence
3. Justification required (text field)
4. Evidence status set to: AdminRemoved
5. User notified: "One of your evidence items has been removed following review"

**System Actions:**
- Evidence excluded from TrustScore
- RiskSignal created (type: FraudulentEvidence)
- File retained for investigation (not deleted)
- User cannot re-upload same evidence (hash-blocked)

**All admin removals logged in AdminAuditLogs.**

### 27.6 Evidence Lifecycle States

**Lifecycle State Machine:**

```
Uploaded → Pending Review → Verified → Active
                           ↓
                      Flagged → Under Review → AdminRemoved
                                              ↓
                                         Deleted (Soft)
                                              ↓
                                  Permanently Deleted (30 days)
```

**State Definitions:**
- **Uploaded:** Evidence just uploaded, awaiting integrity checks
- **Pending Review:** Integrity checks running
- **Verified:** Passed integrity checks, contributes to TrustScore
- **Flagged:** Integrity concerns detected, awaiting admin review
- **Under Review:** Admin currently reviewing
- **AdminRemoved:** Admin determined evidence is fraudulent/invalid
- **Deleted (Soft):** User or system soft-deleted, file scheduled for removal
- **Permanently Deleted:** File removed from storage, record anonymised

### 27.7 Retention Policy Summary

| Evidence Type | Retention While Active | Post-Deletion Retention |
|---------------|------------------------|-------------------------|
| Screenshots | Until deleted or expired | 30 days soft-delete, then permanent |
| Receipts | Until deleted | 30 days soft-delete, then permanent |
| Public Profile Links | Until deleted or re-verification fails | 30 days soft-delete, then permanent |
| Fraud-Flagged Evidence | Indefinite (investigation) | 7 years (anonymised) |

---

## SECTION 28: ADMIN ROLES, PERMISSIONS & AUDIT LOGGING

### 28.1 Purpose

Define a secure, role-based admin hierarchy with comprehensive audit logging for all administrative actions.

**Post-MVP:** Basic admin panel only; full RBAC in Phase 2+.

### 28.2 Admin Role Definitions

**1. Support Agent (Tier 1)**
- **Can:**
  - View user profiles (limited)
  - View evidence (read-only)
  - View reports (read-only)
  - Respond to support tickets
  - Create support notes
- **Cannot:**
  - Modify TrustScore
  - Delete evidence
  - Ban users
  - Access RiskScore details

**2. Risk/Trust Analyst (Tier 2)**
- **Can (all of Tier 1 +):**
  - View full user profiles
  - View RiskScore and RiskSignals
  - Review flagged evidence
  - Approve/reject evidence
  - Escalate reports
  - Request identity re-verification
- **Cannot:**
  - Ban users permanently
  - Delete accounts
  - Modify audit logs
  - Change admin permissions

**3. Senior Moderator (Tier 3)**
- **Can (all of Tier 2 +):**
  - Freeze/unfreeze accounts
  - Remove evidence
  - Resolve safety reports
  - Issue temporary bans (up to 30 days)
  - Override RiskScore thresholds (with justification)
- **Cannot:**
  - Delete accounts permanently
  - Modify admin permissions
  - Access system configuration

**4. Super Admin (Tier 4)**
- **Can (all of Tier 3 +):**
  - Permanently delete accounts
  - Add/remove admin users
  - Modify admin permissions
  - Access system configuration
  - Override all safety checks (with mandatory justification)
  - View all audit logs

**Assigned only to:** CTO, designated senior staff.

### 28.3 Permission Matrix

| Action | Support | Analyst | Senior Mod | Super Admin |
|--------|---------|---------|------------|-------------|
| View user profile | ✅ Limited | ✅ Full | ✅ Full | ✅ Full |
| View evidence | ✅ Read | ✅ Read | ✅ Read | ✅ Full |
| Approve/reject evidence | ❌ | ✅ | ✅ | ✅ |
| Delete evidence | ❌ | ❌ | ✅ | ✅ |
| View RiskScore | ❌ | ✅ | ✅ | ✅ |
| Freeze account | ❌ | ❌ | ✅ | ✅ |
| Ban user (temp) | ❌ | ❌ | ✅ | ✅ |
| Delete account | ❌ | ❌ | ❌ | ✅ |
| Manage admins | ❌ | ❌ | ❌ | ✅ |
| View audit logs | ❌ | ✅ Limited | ✅ Full | ✅ Full |
| Modify system config | ❌ | ❌ | ❌ | ✅ |

### 28.4 Audit Logging Requirements

**Every admin action MUST create an audit log entry:**

**Database Schema:**
```sql
CREATE TABLE AdminAuditLogs (
  Id UUID PRIMARY KEY,
  AdminUserId UUID REFERENCES Users(Id), -- Admin who performed action
  AdminRole VARCHAR(50), -- Support, Analyst, SeniorMod, SuperAdmin
  Action VARCHAR(100), -- FreezeAccount, DeleteEvidence, BanUser, etc.
  TargetType VARCHAR(50), -- User, Evidence, Report, etc.
  TargetId UUID, -- ID of affected entity
  Justification TEXT, -- Admin's reason (mandatory for critical actions)
  Metadata JSONB, -- Additional context (old/new values, etc.)
  IPAddress VARCHAR(50),
  CreatedAt TIMESTAMP NOT NULL,
  INDEX(AdminUserId, CreatedAt),
  INDEX(TargetId, TargetType)
);
```

**Audit Log Content:**
- **Who:** Admin user ID and role
- **What:** Action performed
- **When:** Timestamp (UTC)
- **Where:** IP address
- **Why:** Justification (mandatory for high-risk actions)
- **Target:** Affected user/evidence/report
- **Metadata:** Old/new values, additional context

**Mandatory Justification for:**
- Freezing accounts
- Banning users
- Deleting evidence
- Overriding RiskScore
- Deleting accounts
- Modifying admin permissions

**Justification Field:**
- Minimum 20 characters
- Must be professional and factual
- Examples:
  - "User submitted 10 fake screenshots detected by integrity engine"
  - "User requested account deletion via support ticket #1234"
  - "Safety report verified with supporting evidence from 3 users"

### 28.5 Audit Log Retention

**Retention Period:** 7 years (UK legal compliance)

**Immutability:**
- Audit logs are **append-only**
- No UPDATE or DELETE operations allowed
- Database triggers prevent modification
- Only Super Admins can view raw audit logs
- Other admins see sanitised versions

**Access Control:**
- Support Agents: No access
- Analysts: Limited (own actions + related cases)
- Senior Moderators: Full access to action logs
- Super Admins: Full access to all logs

### 28.6 Admin Onboarding & Offboarding

**Onboarding:**
1. Background check completed
2. Signed confidentiality agreement
3. Super Admin creates admin account
4. Assign role (Support/Analyst/SeniorMod)
5. Issue credentials (email + passkey)
6. Log creation in AdminAuditLogs

**Offboarding:**
1. Super Admin disables account
2. Revoke all sessions
3. Remove from admin role
4. Retain audit logs (anonymise admin ID after 1 year if departed)
5. Log deactivation in AdminAuditLogs

### 28.7 Admin Session Security

**Authentication:**
- Email + passkey (mandatory)
- No password-based admin logins

**Session Management:**
- 2-hour session timeout
- Re-authentication required for critical actions
- IP-based session binding
- Anomaly detection (e.g., login from new country)

**Critical Action Re-Authentication:**
- Freeze/ban user
- Delete evidence
- Delete account
- Modify admin permissions

**Prompt:** "Please confirm your identity to continue" → Passkey/OTP challenge

---

## SECTION 29: SECURITY ALERTS & NOTIFICATIONS

### 29.1 Purpose

Notify users of critical account security events to enable rapid response and maintain trust.

**Post-MVP:** Limited alerts in MVP (new device, suspicious login); full system in Phase 2+.

### 29.2 Alert Types

**1. New Device Login**
- Trigger: User logs in from unrecognised device
- Notification: "New device detected: [Device Name] in [Location]"
- Action: "Was this you? If not, secure your account immediately."

**2. New Location Login**
- Trigger: Login from significantly different location (e.g., UK → US)
- Notification: "Login detected from [City, Country]"
- Action: "Review recent activity"

**3. Evidence Flagged**
- Trigger: Uploaded evidence fails integrity checks
- Notification: "One of your evidence items could not be verified"
- Action: "Review and re-upload if needed"

**4. Multiple Failed Login Attempts**
- Trigger: 5+ failed OTP/passkey attempts in 10 minutes
- Notification: "Multiple failed login attempts detected"
- Action: "Change your email password and review account security"

**5. Account Frozen**
- Trigger: Admin freezes account due to risk signals
- Notification: "Your account has been temporarily restricted"
- Action: "Contact support for more information"

**6. Safety Report Filed**
- Trigger: Another user files report against this user
- Notification: "A safety report has been filed regarding your account"
- Action: "You can respond via Settings > My Reports"

**7. TrustScore Significant Change**
- Trigger: TrustScore drops by 100+ points
- Notification: "Your TrustScore has decreased"
- Action: "Review your Evidence Vault and Risk Status"

**8. Identity Verification Expiry (Future)**
- Trigger: Identity verification approaching expiry (e.g., 30 days before)
- Notification: "Your identity verification expires soon"
- Action: "Re-verify to maintain your TrustScore"

### 29.3 Notification Channels

**In-App Notifications:**
- Bell icon badge with unread count
- Notifications list in Settings > Notifications
- Tap notification → navigate to relevant screen

**Email Notifications:**
- Critical alerts only (new device, account frozen, failed logins)
- HTML formatted with clear subject lines
- Unsubscribe NOT allowed for security alerts

**Push Notifications (Future):**
- iOS/Android push for real-time critical alerts
- User can disable non-critical push notifications

### 29.4 User Controls

**Settings > Notifications:**
- Toggle: "New device alerts" (default: ON, cannot disable)
- Toggle: "TrustScore change alerts" (default: ON, can disable)
- Toggle: "Evidence status updates" (default: ON, can disable)
- Toggle: "Safety report notifications" (default: ON, cannot disable)

**Cannot Disable:**
- New device logins
- Multiple failed login attempts
- Account frozen
- Safety reports

### 29.5 Alert Delivery Timing

**Immediate (Real-Time):**
- New device login
- Multiple failed logins
- Account frozen

**Batched (Daily Summary):**
- TrustScore changes
- Evidence status updates (unless critical)

**Scheduled (Weekly):**
- Account activity summary (optional)

### 29.6 Database Schema

```sql
CREATE TABLE SecurityAlerts (
  Id UUID PRIMARY KEY,
  UserId UUID REFERENCES Users(Id),
  AlertType VARCHAR(100), -- NewDevice, SuspiciousLogin, EvidenceFlagged, etc.
  Severity VARCHAR(50), -- Low, Medium, High, Critical
  Title VARCHAR(200),
  Message TEXT,
  ActionUrl VARCHAR(500) NULL, -- Deep link to relevant screen
  IsRead BOOLEAN DEFAULT FALSE,
  SentViaEmail BOOLEAN DEFAULT FALSE,
  SentViaPush BOOLEAN DEFAULT FALSE,
  CreatedAt TIMESTAMP,
  ReadAt TIMESTAMP NULL,
  INDEX(UserId, IsRead),
  INDEX(CreatedAt)
);
```

### 29.7 Alert Display (Mobile App)

**Notifications Screen:**
- Group by date (Today, Yesterday, This Week, Older)
- Unread alerts highlighted
- Tap alert → mark as read, navigate to action screen
- Swipe to dismiss (for non-critical alerts)

**Alert Card:**
```
[Icon] New Device Detected
iPhone 14 Pro in London, UK
2 hours ago

Was this you? [Review] [Dismiss]
```

---

## SECTION 30: WEB & DESKTOP ACCESS RULES

### 30.1 Purpose

Define where and how SilentID can be accessed across platforms.

### 30.2 Mobile Apps (Primary Platform)

**iOS + Android:**
- Full functionality
- 100% passwordless authentication
- Biometric login (Face ID, Touch ID, fingerprint)
- Push notifications
- Camera for evidence uploads
- QR code scanning and generation

**Priority:** Mobile-first design and development.

### 30.3 Public Web Profiles

**URL:** `https://silentid.co.uk/u/username`

**Access:**
- No login required
- Publicly accessible
- Privacy-compliant display (display name only, no full name)
- SEO optimised
- Social media preview (Open Graph, Twitter Card)

**Features:**
- View TrustScore
- View verification badges
- View public metrics (transaction count, platforms, account age)
- QR code display
- Share button

**NOT accessible on web:**
- Evidence uploads
- Settings
- Admin dashboard (separate admin.silentid.co.uk)

### 30.4 Future Web App (Phase 2+)

**URL:** `https://app.silentid.co.uk`

**Purpose:**
- Read-only access to SilentID profile
- View TrustScore breakdown
- View evidence (limited)
- Manage basic settings

**Authentication:**
- Same passwordless model (email OTP, passkeys)
- WebAuthn for passkey support in browser

**Limitations:**
- Cannot upload evidence (mobile only)
- Cannot use camera features (mobile only)
- No push notifications (email fallback)

**Technology:**
- Next.js or React SPA
- Same ASP.NET Core API backend
- Responsive design

### 30.5 Admin Dashboard (Web Only)

**URL:** `https://admin.silentid.co.uk`

**Access:**
- Admin users only
- Passwordless authentication (email OTP + passkey)
- IP allowlisting (optional)

**Platform:**
- Web only (no mobile admin app in MVP)

### 30.6 Platform Decision Summary

| Feature | iOS App | Android App | Web (Public Profile) | Web App (Future) | Admin (Web) |
|---------|---------|-------------|----------------------|------------------|-------------|
| View TrustScore | ✅ Full | ✅ Full | ✅ Public | ✅ Full | ✅ Full |
| Upload Evidence | ✅ | ✅ | ❌ | ❌ | ❌ |
| Identity Verification | ✅ | ✅ | ❌ | ✅ | ❌ |
| Mutual Verification | ✅ | ✅ | ❌ | ✅ | ❌ |
| Settings | ✅ | ✅ | ❌ | ✅ Limited | ❌ |
| Admin Tools | ❌ | ❌ | ❌ | ❌ | ✅ |

---

## SECTION 31: INTERNATIONALISATION (i18n) PLAN

### 31.1 Purpose

Prepare SilentID for international expansion and multi-language support.

**Post-MVP:** English (UK) only for MVP; other languages in Phase 2+.

### 31.2 Source Language

**Canonical Language:** English (UK)

**Rationale:**
- SILENTSALE LTD registered in UK
- Primary market is UK initially
- Legal documents in English (UK)

**Spelling & Grammar:**
- Use British English conventions (e.g., "colour" not "color")
- Currency: GBP (£)
- Date format: DD/MM/YYYY

### 31.3 Future Languages (Priority Order)

**Phase 2:**
1. **Albanian** - Core market expansion
2. **French** - EU market
3. **German** - EU market

**Phase 3:**
4. Spanish
5. Italian
6. Polish
7. Romanian

**Rationale:** Target countries with active marketplace usage (Vinted, eBay, etc.).

### 31.4 Technical Implementation

**Frontend (Flutter):**
- Use `flutter_localizations` package
- All strings extracted to `.arb` files (Application Resource Bundle)
- No hard-coded strings in UI components

**Backend (ASP.NET Core):**
- Use `IStringLocalizer<T>` for API error messages
- Store UI strings in resource files (`.resx`)
- Accept `Accept-Language` header from client

**Database:**
- Store user's preferred language in `Users` table
- Legal docs and help center content in multiple languages (future)

### 31.5 What Needs Translation

**Must Translate:**
- All UI strings (buttons, labels, headings)
- Error messages
- Push notifications
- Email templates
- Help center articles

**Do NOT Translate:**
- Usernames
- Display names
- Evidence content
- Admin notes

**Special Cases:**
- Legal documents: Must be translated AND reviewed by local legal counsel
- TrustScore labels: Standardised translations (e.g., "High Trust" → "Haute Confiance")

### 31.6 Legal & Compliance

**GDPR in Non-English Markets:**
- Privacy Policy must be available in local language
- Terms & Conditions must be available in local language
- Consent prompts must be in user's language

**Localised Support:**
- Email support in local language (Phase 2+)
- Help center articles translated

---

## SECTION 32: DATA RETENTION & PRIVACY DURATIONS

### 32.1 Purpose

Define how long SilentID stores different categories of data to ensure GDPR compliance and legal obligations.

### 32.2 Data Retention by Category

**1. User Account Data**
- **What:** Email, username, display name, phone
- **Retention:** Until account deletion requested
- **Post-Deletion:** Anonymised within 30 days

**2. Evidence (Screenshots, Receipts, Profile Links)**
- **What:** Uploaded evidence files and metadata
- **Retention:** Until user deletes OR account deleted
- **Post-Deletion:** Files removed within 30 days, metadata anonymised

**3. TrustScore Snapshots**
- **What:** Weekly TrustScore calculations
- **Retention:** Until account deletion
- **Post-Deletion:** Anonymised for fraud research (7 years max)

**4. RiskSignals**
- **What:** Fraud detection signals and risk events
- **Retention:** Until account deletion
- **Post-Deletion:** Anonymised for fraud prevention (7 years)

**5. Safety Reports**
- **What:** User-submitted reports and evidence
- **Retention:** 7 years (legal requirement for fraud investigations)
- **Post-Deletion:** Retained even if reporter/reported user deletes account (anonymised)

**6. Admin Audit Logs**
- **What:** All admin actions
- **Retention:** 7 years (UK compliance requirement)
- **Post-Deletion:** Never deleted (anonymised admin/user IDs after 1 year)

**7. Authentication Logs (Sessions, Devices)**
- **What:** Login history, device info, IP addresses
- **Retention:** 90 days (active logs), 2 years (archived)
- **Post-Deletion:** Deleted after retention period

**8. Billing/Subscription Records**
- **What:** Stripe payment records, invoices
- **Retention:** 7 years (UK tax law requirement)
- **Post-Deletion:** Retained for legal compliance (anonymised user IDs)

**9. Support Tickets**
- **What:** User correspondence with support
- **Retention:** 3 years
- **Post-Deletion:** Anonymised after retention period

**10. Analytics & Aggregated Data**
- **What:** Platform usage metrics (non-personal)
- **Retention:** Indefinite (anonymised)
- **Post-Deletion:** Not affected (no PII)

### 32.3 Retention Principles

**Data Minimisation:**
- Only store what's necessary for service delivery
- Delete unnecessary metadata after processing

**Purpose Limitation:**
- Data retained only for original purpose
- Cannot be repurposed without consent

**Lawful Retention:**
- Legal obligations override user deletion requests (e.g., fraud logs, billing records)
- Lawful basis documented for each retention category

### 32.4 Automated Deletion Jobs

**Daily Jobs:**
- Delete soft-deleted evidence files > 30 days old
- Delete expired sessions
- Delete temporary OTP tokens

**Weekly Jobs:**
- Delete archived authentication logs > 2 years old
- Anonymise deleted user records > 30 days old

**Monthly Jobs:**
- Anonymise admin audit logs for departed staff > 1 year
- Anonymise support tickets > 3 years old

**Annual Jobs:**
- Review retention policies for compliance
- Update legal retention periods if regulations change

---

## SECTION 33: LEGAL DOCUMENTS PLAN (T&Cs, PRIVACY, COOKIES)

### 33.1 Purpose

Define structure and requirements for all legal documents required by SilentID.

**Post-MVP:** Basic legal docs for MVP; comprehensive updates in Phase 2.

### 33.2 Required Legal Documents

**1. Terms & Conditions**
**2. Privacy Policy**
**3. Cookie Policy** (if cookies used)
**4. Acceptable Use Policy** (future)
**5. Data Processing Agreement** (for Partner API, future)

### 33.3 Terms & Conditions Content

**Must Include:**
- What SilentID is (and is NOT)
- User eligibility (18+ only)
- Prohibited activities (fraud, impersonation, etc.)
- Account termination conditions
- Limitation of liability
- Dispute resolution (UK jurisdiction)
- Subscription terms (Free, Premium, Pro)
- Refund policy
- Changes to terms
- Contact information

**Critical Clauses:**
- "SilentID provides trust signals, NOT guarantees"
- "SilentID is not responsible for third-party decisions based on trust data"
- "Users are responsible for accuracy of uploaded evidence"

### 33.4 Privacy Policy Content

**Must Include:**
- What data we collect (Section 20.11)
- Lawful basis for processing (GDPR Article 6)
- How we use data
- Who we share data with (Stripe, Azure, email providers)
- Data retention periods (Section 32)
- User rights (access, rectification, erasure, portability, objection)
- How to exercise rights (privacy@silentid.co.uk)
- Cookie usage (if applicable)
- International transfers (if applicable)
- DPO contact details
- ICO registration number
- Complaints process

**Privacy Policy Sections:**
1. Introduction
2. Data Controller Details (SILENTSALE LTD)
3. What Data We Collect
4. How We Use Your Data
5. Legal Basis for Processing
6. Third-Party Processors
7. Data Retention
8. Your Rights
9. Security Measures
10. Changes to Policy
11. Contact Us

### 33.5 Cookie Policy Content

**If Cookies Used:**
- What cookies are used (session, analytics, etc.)
- Purpose of each cookie
- How to disable cookies
- Impact of disabling cookies

**SilentID Cookie Strategy:**
- Minimal cookie usage (session only if needed)
- No tracking cookies
- No advertising cookies

### 33.6 Alignment with CLAUDE.md

**Critical Rule:**
Legal documents MUST reflect actual system behaviour as defined in `CLAUDE.md`.

**Examples:**
- If Section 4 says "SilentID stores only verification status", Privacy Policy must match
- If Section 5 says "100% passwordless", Terms must prohibit password creation
- If Section 12 says "£4.99/month Premium", Terms must reflect exact pricing

**Conflict Resolution:**
- If legal text conflicts with `CLAUDE.md`, update legal text to match
- If legal requirement conflicts with `CLAUDE.md`, update `CLAUDE.md` first, then legal docs

### 33.7 Review & Update Process

**Initial Creation:**
- Legal counsel reviews `CLAUDE.md`
- Drafts legal documents aligned with spec
- Internal review by CTO + CEO
- Final approval by legal counsel

**Updates:**
- When `CLAUDE.md` changes materially, legal docs updated
- Users notified of changes via email
- Continued use = acceptance of new terms
- Version history maintained

**Version Control:**
- Legal docs versioned (e.g., v1.0, v1.1)
- Previous versions archived
- Change log published

---

## SECTION 34: PERFORMANCE, RATE LIMITING & SCALABILITY REQUIREMENTS

### 34.1 Purpose

Ensure SilentID performs reliably and scales gracefully as user base grows.

### 34.2 Performance Targets (P95 Latency)

**Authentication Endpoints:**
- POST /v1/auth/request-otp: < 500ms
- POST /v1/auth/verify-otp: < 800ms
- POST /v1/auth/passkey/login: < 600ms

**Read Operations:**
- GET /v1/trustscore/me: < 300ms
- GET /v1/users/me: < 200ms
- GET /v1/public/profile/{username}: < 500ms

**Write Operations:**
- POST /v1/evidence/screenshots: < 2000ms (includes upload)
- POST /v1/evidence/receipts: < 1000ms
- POST /v1/mutual-verifications: < 800ms

**Heavy Operations:**
- TrustScore recalculation: < 5000ms (background job acceptable)
- Evidence integrity check: < 10000ms (background job)

### 34.3 Rate Limiting Strategy

**Per-User Limits:**
- OTP requests: 3 per 5 minutes
- Evidence uploads: 20 per hour
- Mutual verification requests: 10 per hour
- Profile views: 100 per hour
- API calls (general): 60 per minute

**Per-IP Limits:**
- Public profile views: 100 per minute
- OTP requests: 10 per 5 minutes
- Failed login attempts: 5 per 10 minutes

**Partner API Limits:**
- Configurable per partner (e.g., 100 requests/minute)
- Burst allowance: 150 requests/minute for 10 seconds
- Daily cap: 100,000 requests/day

**Rate Limit Response:**
```json
HTTP 429 Too Many Requests
{
  "error": "rate_limit_exceeded",
  "message": "Too many requests. Please try again in 60 seconds.",
  "retry_after": 60
}
```

### 34.4 Scalability Requirements

**Horizontal Scaling:**
- Backend API: Stateless, can scale to N instances
- Database: Managed PostgreSQL with read replicas
- File storage: Azure Blob (auto-scaling)

**Caching Strategy:**
- TrustScore: Cache for 1 hour (invalidate on evidence change)
- Public profiles: Cache for 15 minutes
- Static assets: CDN caching (logo, favicon, etc.)

**Database Optimisation:**
- Indexes on frequently queried fields (UserId, Email, Username)
- Partitioning for large tables (Evidence, TrustScoreSnapshots)
- Read replicas for analytics and reporting

**Background Jobs:**
- TrustScore recalculation: Queue-based (Azure Service Bus or equivalent)
- Evidence integrity checks: Queue-based
- Email sending: Queue-based

**Load Testing Targets:**
- 1000 concurrent users
- 10,000 requests per minute
- < 1% error rate
- < 3% request timeout rate

---

## SECTION 35: BACKUP, RESILIENCE & DISASTER RECOVERY

### 35.1 Purpose

Protect SilentID data against hardware failures, human error, and catastrophic events.

### 35.2 Backup Strategy

**Database Backups:**
- **Frequency:** Automated daily backups (3am UTC)
- **Retention:** 30 days rolling
- **Type:** Full database snapshots
- **Storage:** Azure Backup (geo-redundant)
- **Encryption:** Encrypted at rest and in transit

**Evidence File Backups:**
- **Frequency:** Continuous replication (Azure Blob geo-redundant storage)
- **Retention:** Until file deleted + 30 days
- **Regions:** Primary (UK South), Secondary (UK West)

**Configuration Backups:**
- **Frequency:** On every change
- **Storage:** Git repository + Azure Key Vault
- **Retention:** Indefinite

**Audit Log Backups:**
- **Frequency:** Daily
- **Retention:** 7 years (immutable)
- **Storage:** Azure Archive Storage

### 35.3 Backup Testing

**Monthly Tests:**
- Restore database backup to staging environment
- Verify data integrity and completeness
- Test application functionality on restored database

**Quarterly Tests:**
- Full disaster recovery drill
- Restore from backup to new environment
- Measure RTO and RPO

**Test Documentation:**
- Document restore process step-by-step
- Maintain runbook for disaster recovery
- Update based on test findings

### 35.4 Resilience

**Database:**
- Managed PostgreSQL (Azure Database for PostgreSQL)
- Automatic failover to standby replica
- Multi-zone deployment (future)

**Backend API:**
- Multiple instances behind load balancer
- Auto-scaling based on CPU/memory
- Health checks and automatic restart

**File Storage:**
- Azure Blob Storage (geo-redundant by default)
- Automatic replication across regions

**Monitoring:**
- Azure Monitor for infrastructure
- Application Insights for app-level monitoring
- Alerts on high error rates, latency spikes, downtime

### 35.5 Disaster Recovery

**Recovery Time Objective (RTO):** 4 hours
**Recovery Point Objective (RPO):** 24 hours (daily backups)

**Disaster Scenarios:**

**1. Database Corruption**
- **Response:** Restore from most recent clean backup
- **Steps:**
  1. Identify corruption scope
  2. Take offline (maintenance mode)
  3. Restore from backup
  4. Verify integrity
  5. Bring back online
- **RTO:** 2 hours

**2. Azure Region Failure**
- **Response:** Failover to secondary region (if configured)
- **Steps:**
  1. DNS failover to secondary region
  2. Restore database from geo-redundant backup
  3. Verify application functionality
  4. Communicate with users
- **RTO:** 4 hours

**3. Data Breach / Ransomware**
- **Response:** Isolate, restore, investigate
- **Steps:**
  1. Isolate affected systems
  2. Restore from clean backup
  3. Forensic investigation
  4. Notify ICO and users (within 72 hours if required)
  5. Implement additional security measures
- **RTO:** 8 hours (extended for investigation)

**4. Human Error (Accidental Deletion)**
- **Response:** Restore specific data from backup
- **Steps:**
  1. Identify scope of deletion
  2. Restore from most recent backup before deletion
  3. Verify restored data
  4. Document incident
- **RTO:** 1 hour

### 35.6 Business Continuity

**Communication Plan:**
- Status page: status.silentid.co.uk
- Email notifications to all users
- Social media updates (Twitter, LinkedIn)

**Incident Response Team:**
- Incident Commander: CTO
- Technical Lead: Senior Backend Engineer
- Communications: CEO
- Legal: Company Solicitor

**Escalation Process:**
- Severity 1 (Critical): Immediate escalation to CTO
- Severity 2 (High): Escalate within 1 hour
- Severity 3 (Medium): Escalate within 4 hours
- Severity 4 (Low): Handle in normal workflow

---

## SECTION 36: SECURITY INCIDENT & BREACH RESPONSE

### 36.1 Purpose

Define how SilentID detects, responds to, and recovers from security incidents and data breaches.

**Post-MVP:** Basic incident response in MVP; full playbook in Phase 2.

### 36.2 Incident Types

**1. Infrastructure Compromise**
- Server breach
- Database access by unauthorised party
- Admin account takeover

**2. Data Breach**
- Unauthorised access to user data
- Data exfiltration
- Accidental data exposure

**3. Credential Leakage**
- API keys exposed
- Stripe keys leaked
- Database credentials compromised

**4. Abusive Admin Behaviour**
- Admin misusing access
- Unauthorised data access
- Malicious admin actions

**5. Application Vulnerability**
- SQL injection
- XSS attack
- Authentication bypass

### 36.3 Incident Response Process

**Phase 1: Detection**
- **Automated Monitoring:**
  - Azure Monitor alerts
  - Unusual API traffic patterns
  - Multiple failed admin login attempts
  - Database query anomalies
- **Manual Reporting:**
  - User reports suspicious activity
  - Internal staff notices irregularity
- **External Notification:**
  - Security researcher reports vulnerability

**Phase 2: Containment**
- **Immediate Actions:**
  - Isolate affected systems
  - Revoke compromised credentials
  - Block malicious IP addresses
  - Disable affected user accounts (if needed)
  - Take affected services offline if necessary

**Phase 3: Investigation**
- **Evidence Collection:**
  - Review audit logs
  - Analyse network traffic
  - Examine database query logs
  - Interview involved staff
- **Scope Determination:**
  - What data was accessed?
  - How many users affected?
  - When did breach occur?
  - How was breach executed?

**Phase 4: Notification**
- **Internal Notification:**
  - Incident Commander (CTO)
  - CEO
  - Legal counsel
  - Affected staff

- **External Notification:**
  - **ICO (UK GDPR):**
    - Within 72 hours if personal data breach
    - Required info: nature of breach, categories of data, approximate number affected, contact details
  - **Affected Users:**
    - Within 7 days if high risk to rights/freedoms
    - Email notification with: what happened, what data affected, what we're doing, what they should do
  - **Partner API Users:**
    - If partner data affected
  - **Public Statement:**
    - If breach is public/media coverage

**Phase 5: Remediation**
- **Fix Vulnerability:**
  - Patch software
  - Update configurations
  - Strengthen authentication
  - Review access controls
- **Restore Services:**
  - Bring systems back online
  - Verify functionality
  - Monitor for repeat incidents

**Phase 6: Post-Incident Review**
- **Post-Mortem Document:**
  - Timeline of events
  - Root cause analysis
  - Impact assessment
  - Response effectiveness
  - Lessons learned
  - Action items
- **Update Procedures:**
  - Improve detection mechanisms
  - Update incident response plan
  - Train staff on new procedures

### 36.4 Notification Templates

**Email to Affected Users:**
```
Subject: Important Security Notice - SilentID Account

Dear [User],

We are writing to inform you of a security incident affecting your SilentID account.

What Happened:
[Brief description of incident]

What Data Was Affected:
[List of data types: email, TrustScore, evidence, etc.]

What We're Doing:
- [Action 1]
- [Action 2]

What You Should Do:
- [User action 1]
- [User action 2]

We sincerely apologise for this incident and are committed to preventing future occurrences.

For more information: support@silentid.co.uk

SILENTSALE LTD
```

**ICO Notification Template:**
- Nature of breach
- Categories and approximate number of data subjects
- Categories and approximate number of records
- Contact point for more information
- Likely consequences of breach
- Measures taken or proposed

### 36.5 Security Incident Severity Levels

**Severity 1: Critical**
- Database compromised
- Mass data exfiltration
- Authentication bypass affecting all users
- **Response Time:** Immediate (< 15 minutes)

**Severity 2: High**
- Individual user account compromised
- Admin account takeover
- API key leaked
- **Response Time:** < 1 hour

**Severity 3: Medium**
- Attempted breach (unsuccessful)
- Suspicious activity detected
- Minor vulnerability discovered
- **Response Time:** < 4 hours

**Severity 4: Low**
- Security best practice deviation
- Minor configuration issue
- **Response Time:** < 24 hours

### 36.6 Logging & Evidence Preservation

**All incidents MUST:**
- Be logged in `SecurityIncidents` table
- Preserve all evidence (logs, screenshots, communications)
- Document timeline of events
- Document all actions taken
- Retain for 7 years (legal requirement)

**Database Schema:**
```sql
CREATE TABLE SecurityIncidents (
  Id UUID PRIMARY KEY,
  IncidentType VARCHAR(100),
  Severity VARCHAR(50),
  Description TEXT,
  AffectedUsers INT,
  AffectedData TEXT,
  DetectedAt TIMESTAMP,
  ContainedAt TIMESTAMP NULL,
  ResolvedAt TIMESTAMP NULL,
  ICONotified BOOLEAN DEFAULT FALSE,
  UsersNotified BOOLEAN DEFAULT FALSE,
  PostMortemUrl VARCHAR(500),
  CreatedAt TIMESTAMP
);
```

---

## SECTION 37: FRAUD CASE BUNDLING & CROSS-PLATFORM PATTERN DETECTION

### 37.1 Purpose

Detect organised fraud rings and repeated bad actors by correlating signals across devices, evidence, and platforms.

**Post-MVP / Phase 2+:** Advanced fraud detection.

### 37.2 Case Bundling Concept

**Definition:** Grouping multiple users/accounts that exhibit correlated fraud signals.

**Bundling Criteria:**
- Shared device fingerprints
- Shared IP addresses (excluding common IPs like public WiFi)
- Shared evidence files (identical hashes)
- Circular mutual verification patterns
- Similar behavioural patterns (e.g., all accounts created same day, all upload evidence at exact same times)

**Example Case:**
- User A, User B, User C share device fingerprint
- All three verify each other mutually
- All three submit same screenshot (different filenames, identical hash)
- **Conclusion:** Likely fraud ring → bundle into Case #123 for investigation

### 37.3 Detection Signals for Bundling

**Device-Based Signals:**
- Device fingerprint reuse (same browser/OS/resolution across accounts)
- IP address clustering (accounts frequently log in from same IPs)
- Geolocation consistency (accounts always from same city)

**Evidence-Based Signals:**
- Identical evidence hashes across accounts
- Evidence files uploaded within minutes of each other
- Evidence metadata patterns (e.g., same camera model EXIF)

**Behaviour-Based Signals:**
- Account creation timestamps within hours
- Mutual verification chains (A verifies B, B verifies C, C verifies A)
- Similar TrustScore trajectories
- Identical platform profiles linked (same Vinted/eBay accounts across multiple SilentID users)

**Transaction-Based Signals:**
- Same transaction verified by multiple SilentID accounts
- Receipt evidence for same order ID from different users

### 37.4 Cross-Platform Pattern Detection

**Purpose:** Detect users with repeated fraud/dispute history across multiple marketplaces.

**Data Sources:**
- Public profile URLs (Vinted, eBay, Depop, etc.)
- User-reported platform usernames
- Scraped marketplace data (if available)

**Patterns to Detect:**
1. **Serial Disputer:**
   - Multiple disputes on Vinted
   - Multiple disputes on eBay
   - Multiple disputes on Depop
   - **Action:** Flag as high-risk, reduce TrustScore

2. **Account Hopping:**
   - User has 5+ different marketplace accounts
   - All created within 2 years
   - Possible indicator of being banned/warned
   - **Action:** Request explanation, manual review

3. **Rating Manipulation:**
   - User's SilentID profile shows high transactions
   - Marketplace profiles show low/negative ratings
   - Inconsistency suggests fake evidence
   - **Action:** Flag evidence, manual review

4. **Geo-Inconsistency:**
   - SilentID location: UK
   - All marketplace profiles: Poland
   - Possible account sharing/selling
   - **Action:** Request identity re-verification

### 37.5 Case Investigation Flow

**Step 1: Automated Detection**
- System runs fraud detection jobs daily
- Identifies potential fraud cases based on signals
- Creates `FraudCase` record with status: Detected

**Step 2: Admin Review**
- Admin assigned to case
- Reviews:
  - All accounts in bundle
  - Shared signals
  - Evidence integrity
  - TrustScore patterns
  - Risk history

**Step 3: Decision**
- **False Positive:** Close case, no action
- **Suspicious:** Flag accounts, increase monitoring
- **Confirmed Fraud:** Freeze all accounts, notify users, permanently ban

**Step 4: Action**
- Freeze all accounts in bundle
- Invalidate all evidence from bundled accounts
- Remove mutual verifications between bundled accounts
- Create RiskSignals for all affected users
- Log in AdminAuditLogs

**Step 5: Communication**
- Notify affected users: "Your account has been restricted due to suspicious activity"
- Provide appeal pathway (Section 24)

### 37.6 Database Schema

```sql
CREATE TABLE FraudCases (
  Id UUID PRIMARY KEY,
  CaseType VARCHAR(100), -- DeviceCluster, EvidenceReuse, MutualVerificationRing, etc.
  Status VARCHAR(50), -- Detected, UnderReview, Confirmed, FalsePositive, Closed
  UserIds JSONB, -- Array of affected user IDs
  DetectionSignals JSONB, -- Array of signals that triggered detection
  AssignedAdminId UUID NULL REFERENCES Users(Id),
  Decision VARCHAR(100) NULL,
  Notes TEXT,
  CreatedAt TIMESTAMP,
  ReviewedAt TIMESTAMP NULL,
  ResolvedAt TIMESTAMP NULL
);
```

### 37.7 Impact on TrustScore

**Users in Confirmed Fraud Cases:**
- TrustScore set to 0
- All evidence invalidated
- Public profile shows: "This account has been restricted"
- Cannot create new evidence
- Cannot create mutual verifications

**Users in Suspicious Cases:**
- RiskScore increased by 40
- Evidence weight reduced by 50%
- Public profile shows: "Safety concern flagged"
- Manual admin review required for any new evidence

---

## SECTION 38: BUSINESS / PROFESSIONAL PROFILES (FUTURE EXTENSION)

### 38.1 Purpose

Enable SilentID to support professional sellers, registered businesses, and organisations while maintaining the individual trust identity model.

**Post-MVP / Phase 3+:** Not required for MVP or Phase 2.

### 38.2 Business Account Type

**Definition:** A SilentID account type for registered businesses, sole traders, or professional sellers.

**Differences from Individual Accounts:**
- Display company/business name
- Show business registration number (optional)
- Link to individual staff profiles (e.g., owner, employees)
- Higher transaction volume expectations
- Different trust signals (business-specific)

**Eligibility:**
- Must provide business registration number
- Must verify business entity (e.g., Companies House lookup for UK)
- Must link to at least one verified individual profile (owner/director)

### 38.3 Business Profile Display

**Public Profile:**
- Business Name (e.g., "Smith's Vintage Shop")
- Business TrustScore (0-1000, separate calculation)
- Business Verified Badge
- Registration Number (optional visibility toggle)
- Linked Individual Profiles (owner, staff)
- Business Evidence Vault (invoices, shipping records, etc.)

**Example:**
```
Smith's Vintage Shop
Business TrustScore: 892 (Very High)
✅ Business Verified (Companies House)
Registered in England & Wales - Company No. 12345678

Owner: John Smith (@johnsmith) - TrustScore 847
Staff: Sarah M. (@sarahtrusted) - TrustScore 754

500+ verified transactions
Active since 2024
```

### 38.4 Business TrustScore Calculation

**Components:**
1. **Business Identity (200 pts):**
   - Companies House verification
   - VAT number verification
   - Business address verification
2. **Business Evidence (300 pts):**
   - Invoices
   - Shipping records
   - Customer reviews (external)
   - Business profile links (eBay store, Etsy shop, etc.)
3. **Business Behaviour (300 pts):**
   - No consumer complaints
   - Consistent shipping/delivery
   - Low return/refund rates
4. **Staff Trust (200 pts):**
   - Average TrustScore of linked individual profiles
   - Staff background checks (optional)

### 38.5 Link to Individual Profiles

**Linking Model:**
- Business account can link to multiple individual profiles
- Each individual must consent to link
- Individual TrustScore remains separate
- Business TrustScore influenced by staff TrustScores

**Use Case:**
- Buyer sees: "This item is sold by Smith's Vintage Shop (TrustScore 892). The seller is Sarah M. (TrustScore 754)."
- Transparency: Both business and individual trust visible

### 38.6 Legal & Compliance Differences

**Business-Specific Legal Requirements:**
- Terms & Conditions must include business-specific clauses
- VAT compliance (if applicable)
- Consumer Rights Act 2015 compliance (UK)
- Business GDPR obligations (data controller vs processor)

**Business Privacy:**
- Business registration details are public (less privacy protection)
- Individual staff profiles maintain full privacy protections

### 38.7 Subscriptions for Businesses

**Business Tier (Future):**
- £49.99/month
- Features:
  - Unlimited business evidence
  - Multiple staff profiles linked
  - Bulk transaction verification
  - Business analytics dashboard
  - Export financial reports
  - White-label trust badge
  - API access (limited)

### 38.8 Use Cases

**1. Professional Sellers:**
- High-volume eBay/Vinted sellers
- Vintage shop owners
- Resellers and traders

**2. Service Providers:**
- Cleaners, tutors, tradespeople
- Freelancers
- Gig workers

**3. Community Organisations:**
- Parent groups
- Local buy/sell/trade groups
- Neighbourhood associations

**4. Future Expansion:**
- Rental agencies
- Estate agents
- Recruitment firms

---


---

## SECTION 39: SILENTID APP UI — PROFILE, SETTINGS & NAVIGATION RULES

### 39.1 Purpose

Define canonical UI design rules for SilentID's Profile, Settings, and Navigation systems to ensure consistency across all development phases and agents.

**Scope:** Flutter mobile app (iOS + Android)
**Applies to:** MVP and all future phases

### 39.2 Role of Profile / Settings Area

**Definition:**
The Profile/Settings area is the **control centre** for a user's identity, trust, security, and account management.

**Core Responsibilities:**
- Identity & verification status (Stripe Identity)
- TrustScore and breakdown
- Risk & Security Center access
- Evidence Vault management
- Devices & login methods (passkeys, Apple/Google, email OTP)
- Subscriptions (Free / Premium / Pro)
- Privacy, data export, account deletion
- Help, support, and safety reporting

**Design Philosophy:**
This area must feel like a **bank account dashboard**:
- Serious, calm, professional
- High-trust, evidence-driven
- Premium, minimal, precise
- Never juvenile, playful, or social-media style

### 39.3 Navigation Placement

**Canonical Pattern (MANDATORY):**

**Bottom Navigation Bar (4 tabs):**
1. **Home** - TrustScore overview, quick actions, recent activity
2. **Evidence** - Receipts, screenshots, profile links
3. **Verify** - Mutual verifications, scan profiles, QR codes
4. **Profile** - Settings, account, security, help

**Profile Tab Entry:**
- Icon: User avatar or profile icon
- Label: "Profile" or "Account"
- Badge: Shows unread notifications count (if any)

**Alternative Access (Secondary):**
- From Home screen: Avatar icon (top-right) → Profile/Settings
- From any screen: Menu → Profile/Settings

**Rule:** All UI agents must implement the **bottom navigation pattern** as primary access. Alternative access is optional enhancement.

### 39.4 Grouping Rules

**Mandatory Section Structure:**

All Profile/Settings items must be grouped into these **7 sections** in this **exact order**:

#### **1. Account & Identity**
- Profile header (avatar, display name, username)
- Identity verification status (Stripe Identity)
  - Status: Verified / Pending / Failed / Not Started
  - CTA: "Verify your identity" (if not verified)
- Public profile settings
  - Toggle: "Public profile visible"
  - Link: "View my public profile"
- Edit profile (display name, avatar)

#### **2. Trust & Evidence**
- TrustScore overview
  - Score display (0-1000)
  - Score label (Very High / High / Moderate / Low / High Risk)
  - CTA: "View breakdown"
- Evidence Vault
  - Email receipts count
  - Screenshots count
  - Profile links count
  - CTA: "Add evidence"
- Mutual verification
  - Verified transactions count
  - CTA: "Request verification"

#### **3. Security & Risk**
- Security Center (Section 15)
  - Risk status indicator
  - Active alerts count
  - CTA: "Open Security Center"
- Devices & sessions
  - Trusted devices count
  - CTA: "Manage devices"
- Login methods
  - Passkey status (enabled/disabled)
  - Connected accounts (Apple, Google)
  - Email OTP status
  - CTA: "Manage login methods"

#### **4. Subscriptions & Billing**
- Current plan
  - Free / Premium / Pro badge
  - Benefits summary
- Subscription management
  - CTA: "Upgrade to Premium" (if Free)
  - CTA: "Upgrade to Pro" (if Premium)
  - CTA: "Manage subscription" (if Premium/Pro)
- Billing history (Premium/Pro only)

#### **5. Privacy & Data**
- Connected services
  - Email connection status
  - Permissions granted
  - CTA: "Manage permissions"
- Data export
  - CTA: "Download my data" (GDPR SAR)
- Privacy preferences
  - Toggle: "Allow profile indexing"
  - Toggle: "Show verification badges publicly"
- Delete account
  - CTA: "Delete my account" (red/danger color)

#### **6. Help & Legal**
- Help Center
  - CTA: "Browse help articles"
- Contact support
  - CTA: "Get help"
- Report a safety concern
  - CTA: "Report user"
- My reports
  - Filed reports count
  - CTA: "View my reports"

#### **7. About & Legal**
- Terms & Conditions
- Privacy Policy
- Cookie Policy (future)
- Licenses & credits
- App version
- SilentID specification version (displays current CLAUDE.md version)

**Grouping Rules:**
- ✅ Related items must appear in the same section
- ✅ Sections must appear in the order above
- ❌ Do NOT mix financial, safety, and cosmetic settings in a single random list
- ❌ Do NOT create custom groupings that conflict with this structure
- ❌ Do NOT split sections into multiple screens unless complexity requires it

### 39.5 Header & Primary CTAs

**Profile Screen Header (Top Section):**

```
┌─────────────────────────────────────────────┐
│  [Avatar]  Sarah M.                         │
│            @sarahtrusted                    │
│            ✅ Identity Verified             │
│            🎯 TrustScore: 847 (High)        │
│            💎 Premium Member                │
├─────────────────────────────────────────────┤
│  [Primary CTA: Improve TrustScore]          │
│  [Secondary CTA: Open Security Center]      │
└─────────────────────────────────────────────┘
```

**Header Components:**
1. **Avatar** (64×64 or 80×80, circular)
2. **Display Name** (Inter Semibold, 20-24pt)
3. **Username** (Inter Regular, 14-16pt, muted gray)
4. **Trust Badges** (1-3 badges max):
   - Identity Verified ✅
   - TrustScore level 🎯
   - Subscription tier 💎 (if Premium/Pro)
5. **Primary CTA Button** (full-width or 90% width):
   - Text: Dynamic based on user state
   - Examples:
     - "Verify your identity" (if not verified)
     - "Improve your TrustScore" (if verified but score < 800)
     - "Open Security Center" (if risk alerts active)
     - "Upgrade to Premium" (if Free tier)
6. **Secondary CTA Button** (optional, text button style):
   - Examples:
     - "View public profile"
     - "Manage subscription"

**CTA Selection Logic:**
- Show the **most actionable** CTA based on user state
- Priority order:
  1. Critical actions (verify identity, resolve security alerts)
  2. Growth actions (improve TrustScore, add evidence)
  3. Monetization (upgrade subscription)
  4. Information (view profile, help)

**Visual Rules:**
- Primary CTA: Royal purple `#5A3EB8` background, white text
- Secondary CTA: Transparent background, purple text, purple border
- Spacing: 16px between header content and CTAs, 12px between CTAs

### 39.6 Icons & Visual Consistency

**Icon System Requirements:**

**Mandatory Rules:**
1. **Single Icon Family:**
   - Use ONE icon set only (e.g., Lucide Icons, Feather Icons, Material Icons)
   - DO NOT mix multiple icon families on the same screen
   - Recommended: Lucide Icons (MIT license, clean, modern)

2. **Icon Size:**
   - Standard size: **24×24 dp** (or 24sp in Flutter)
   - Small size: **16×16 dp** (for inline badges)
   - Large size: **32×32 dp** (for header/feature icons)

3. **Icon Style:**
   - Stroke weight: 1.5-2px (consistent across all icons)
   - Fill: Outline only (no filled icons unless specifically for active states)
   - Corner radius: Matches brand (rounded, not sharp)
   - Color: Neutral gray `#4C4C4C` (default), royal purple `#5A3EB8` (active/selected)

4. **Icon-Text Alignment:**
   - Icons always **left-aligned** with text
   - Vertical center alignment
   - Gap between icon and text: **12px**

**Required Icons by Section:**

| Section | Item | Icon | Color |
|---------|------|------|-------|
| **Account & Identity** | Identity verification | shield-check | purple (verified) / gray (not verified) |
| | Public profile | user-check | gray |
| | Edit profile | edit | gray |
| **Trust & Evidence** | TrustScore | award | purple |
| | Evidence Vault | folder | gray |
| | Mutual verification | check-circle-2 | gray |
| **Security & Risk** | Security Center | shield | purple (alerts) / gray (safe) |
| | Devices | smartphone | gray |
| | Login methods | key | gray |
| **Subscriptions** | Current plan | credit-card | purple (Premium/Pro) / gray (Free) |
| | Upgrade | arrow-up-circle | purple |
| **Privacy & Data** | Connected services | link | gray |
| | Data export | download | gray |
| | Delete account | trash-2 | red `#D04C4C` |
| **Help & Legal** | Help Center | help-circle | gray |
| | Contact support | message-circle | gray |
| | Report | flag | red (if active reports) / gray |
| **About** | Terms | file-text | gray |
| | Privacy | lock | gray |
| | App version | info | gray |

**Accessibility:**
- All icons must have semantic labels for screen readers
- Icon + text together = minimum tap target of 44×44 dp

### 39.7 Spacing & Layout Rules

**Design Token System (Flutter):**

Based on a **4-point grid**:

```dart
class AppSpacing {
  static const double xxs = 4.0;   // Tiny gaps
  static const double xs = 8.0;    // Small gaps within items
  static const double sm = 12.0;   // Medium gaps within items
  static const double md = 16.0;   // Standard gaps between items
  static const double lg = 24.0;   // Gaps between item groups
  static const double xl = 32.0;   // Gaps between major sections
  static const double xxl = 48.0;  // Extra large gaps (rare)
}
```

**Spacing Rules:**

1. **Horizontal Padding (Screen Edges):**
   - Standard: **16px** (AppSpacing.md)
   - Content must NOT touch screen edges

2. **Vertical Spacing:**
   - Between major section groups: **24-32px** (AppSpacing.lg or .xl)
   - Between items within a group: **8-12px** (AppSpacing.xs or .sm)
   - Between header and first section: **24px** (AppSpacing.lg)
   - Between last section and bottom: **32px** (AppSpacing.xl)

3. **Item Internal Spacing:**
   - Icon to text: **12px** (AppSpacing.sm)
   - Text to chevron/badge: **8px** (AppSpacing.xs)
   - Padding inside item rows: **16px vertical**, **16px horizontal**

4. **CTA Button Spacing:**
   - Height: **52-56px**
   - Horizontal padding: **24px**
   - Between buttons (stacked): **12px**

**Layout Grid:**

```
┌─────────────────────────────────────────────┐
│ [16px padding]                  [16px]      │
│                                              │
│  HEADER (avatar, name, badges, CTAs)        │
│                                              │
├─────────────────────────────────────────────┤
│ [24px gap]                                   │
│                                              │
│  SECTION 1: Account & Identity              │
│  ┌────────────────────────────────────────┐ │
│  │ [icon 24×24] [12px] Item text [8px] ›  │ │ (16px padding)
│  ├────────────────────────────────────────┤ │
│  │ [icon] [12px] Item text [8px] ›        │ │
│  └────────────────────────────────────────┘ │
│                                              │
├─────────────────────────────────────────────┤
│ [24px gap]                                   │
│                                              │
│  SECTION 2: Trust & Evidence                │
│  ┌────────────────────────────────────────┐ │
│  │ [icon] [12px] Item text [8px] ›        │ │
│  └────────────────────────────────────────┘ │
│                                              │
└─────────────────────────────────────────────┘
```

**Minimum Tap Targets:**
- All interactive items: **44×44 dp minimum** (iOS/Android accessibility)
- Buttons: **52-56px height**
- Icons alone (if tappable): **40×40 dp** with padding

### 39.8 Tone & Brand Enforcement

**Profile/Settings UI Must:**

1. **Feel Like a Bank Account:**
   - Clean white backgrounds
   - Royal purple `#5A3EB8` accents only (no other colors except red for danger)
   - Inter font throughout
   - Generous white space
   - Professional, calm animations (subtle, smooth)

2. **Avoid:**
   - ❌ Playful language or emojis (except info point icons: ⓘ)
   - ❌ Social media style (likes, hearts, streaks, gamification)
   - ❌ Cartoonish icons or illustrations
   - ❌ Loud colors or gradients
   - ❌ Excessive animations or transitions

3. **Language Rules:**
   - Use **defamation-safe wording** from Section 4
   - Examples:
     - ✅ "Safety concern flagged"
     - ❌ "This user is a scammer"
   - Use **GDPR-compliant privacy language** from Section 20
   - Use **subscription wording** from Section 12/16

4. **Trust Signals:**
   - Display verification badges prominently
   - Show TrustScore clearly
   - Use subtle colors for risk indicators (amber/red only when necessary)

### 39.9 Responsive Design Rules

**Screen Size Considerations:**

**Small Screens (<375px width):**
- Reduce horizontal padding to **12px**
- Stack CTAs vertically
- Reduce avatar size to **56×56**
- Use smaller font sizes (scale down by 10%)

**Large Screens (>600px width, tablets):**
- Increase horizontal padding to **24px**
- Use 2-column layout for Settings sections (optional)
- Increase avatar size to **96×96**
- Use larger font sizes (scale up by 10%)

**Portrait vs Landscape:**
- Profile header remains top-fixed (not side-fixed)
- Bottom navigation remains visible (except during scrolling, optional hide)

### 39.10 Accessibility Requirements

**Mandatory Accessibility Features:**

1. **Screen Reader Support:**
   - All icons have semantic labels
   - All interactive elements have clear labels
   - Section headers announced correctly
   - Navigation hints provided ("Tap to manage devices")

2. **Dynamic Text Sizing:**
   - Support iOS Dynamic Type
   - Support Android font scaling
   - Test with 200% text size

3. **Color Contrast:**
   - All text meets WCAG AA standards (4.5:1 for normal text)
   - Icons meet 3:1 contrast ratio
   - Interactive elements have clear focus states

4. **Touch Targets:**
   - Minimum 44×44 dp for all interactive elements
   - Clear spacing between tappable items (minimum 8px)

5. **Focus Indicators:**
   - Clear visual focus states for keyboard navigation (future web app)
   - Highlighted state for selected items

### 39.11 Interaction Patterns

**Standard Interactions:**

1. **Tapping a Settings Row:**
   - Visual feedback: Brief background color change (light purple tint)
   - Navigation: Push to detail screen (right-to-left animation)
   - Loading: Show spinner only if >500ms delay

2. **Toggles:**
   - Standard Material/Cupertino toggle switches
   - Immediate feedback (no confirmation unless destructive)
   - Toast message for confirmation ("Public profile hidden")

3. **Danger Actions (Delete Account, Remove Evidence):**
   - Show confirmation dialog
   - Clear warning text
   - Require explicit confirmation ("Type DELETE to confirm")
   - Red/danger button color

4. **CTAs:**
   - Tap feedback: Scale down slightly (95%) with subtle bounce
   - Disabled state: 40% opacity, no interaction
   - Loading state: Show spinner inside button, disable interaction

### 39.12 Error & Empty States

**Error States:**
- Identity verification failed: Show retry CTA, link to Help Center
- Evidence upload failed: Clear error message, suggest troubleshooting
- Network error: "Unable to load. Pull to refresh."

**Empty States:**
- No evidence uploaded: "Add your first evidence to build your TrustScore"
- No devices: "Your current device is your only trusted device"
- No mutual verifications: "Request verification from someone you've traded with"

**Consistency Rule:**
- All error/empty states must follow the same visual pattern
- Include icon, title, description, CTA (optional)

### 39.13 Migration & Implementation Rules

**For All UI Agents (Flutter, Future Web):**

1. **Before implementing Profile/Settings:**
   - Read this section (39) completely
   - Read Section 2 (Branding)
   - Read Section 10 (Frontend Architecture)
   - Understand which features already exist in the backend

2. **During implementation:**
   - Follow the exact section order and grouping
   - Use the specified icon system
   - Apply spacing tokens correctly
   - Test with accessibility features enabled

3. **After implementation:**
   - Verify against brand checklist (Section 2)
   - Test all interaction patterns
   - Validate against GDPR/privacy rules (Section 4, 20)

---

## SECTION 40: UI INFO POINTS & IN-APP EDUCATION SYSTEM

### 40.1 Purpose

Define a canonical **UI Info Point System** to provide short, contextual explanations for complex SilentID concepts directly within the app UI.

**Goals:**
- Reduce user confusion
- Improve trust transparency
- Educate users about security, privacy, and trust mechanisms
- Reduce support tickets
- Complement Help Center (Section 19) with in-app education

### 40.2 Visual & Interaction Design

**Info Point Icon:**
- Symbol: **ⓘ** (circled lowercase "i")
- Size: **20×20 dp** (slightly smaller than navigation icons)
- Color:
  - Default: Neutral gray `#4C4C4C`
  - Hover/Tap: Royal purple `#5A3EB8`
- Style: Outline (not filled), consistent with icon system (Section 39.6)

**Placement Rules:**
- Always appear **immediately after** or **to the right of** the term being explained
- Gap between term and info icon: **4-6px**
- Vertically centered with text baseline

**Examples:**
```
TrustScore ⓘ
Risk Status ⓘ
Identity Verified ⓘ
Evidence Vault ⓘ
```

**Interaction:**
- **Tap:** Opens info modal/bottom sheet
- **Long press:** (optional) Shows tooltip preview
- **Keyboard focus:** (future web) Tab-accessible, Enter to open

### 40.3 Info Modal Design

**Modal Structure:**

```
┌─────────────────────────────────────────────┐
│  ✕ (close button, top-right)                │
│                                              │
│  [Icon] Modal Title                         │
│                                              │
│  Explanatory text (2-4 lines)               │
│  Clear, simple language                     │
│  No jargon without translation              │
│                                              │
│  [Optional: Learn More Link]                │
│                                              │
│  [Primary Action Button (optional)]         │
└─────────────────────────────────────────────┘
```

**Modal Properties:**
- **Type:** Bottom sheet (mobile), centered modal (web/tablet)
- **Background:** White with subtle shadow/blur backdrop
- **Max width:** 90% screen width or 400px (whichever is smaller)
- **Padding:** 24px all sides
- **Animation:** Slide up from bottom (300ms ease-out)

**Components:**
1. **Close Button** (top-right, 24×24, gray X icon)
2. **Icon** (optional, 32×32, matches the concept - e.g., shield for Identity)
3. **Title** (Inter Semibold, 18-20pt, black)
4. **Body Text** (Inter Regular, 14-16pt, dark gray, line height 1.5)
5. **Learn More Link** (optional, Inter Medium, 14pt, purple, underlined)
   - Opens relevant Help Center article
6. **Action Button** (optional, e.g., "Verify Now", "Add Evidence")

**Interaction:**
- **Tap outside modal:** Closes modal
- **Swipe down (mobile):** Closes modal
- **Tap close button:** Closes modal
- **Tap Learn More:** Opens Help Center in new screen (or in-app browser)
- **Tap Action Button:** Navigates to relevant screen, closes modal

### 40.4 Required Info Point Locations

**Mandatory Info Points (Must Exist):**

#### **1. TrustScore UI**

**Overall TrustScore:**
- **Location:** Next to "TrustScore" label on Home screen and Profile screen
- **Title:** "What is TrustScore?"
- **Body:**
  ```
  Your TrustScore (0-1000) shows how trustworthy you are to deal with online.

  It's calculated from:
  • Identity verification
  • Evidence you upload
  • Your behaviour
  • Peer confirmations

  Higher score = more trust = better reputation.
  ```
- **Link:** "Learn More" → Help Center: "Understanding Your TrustScore"

**Identity Component:**
- **Title:** "Identity Component"
- **Body:**
  ```
  Worth up to 200 points.

  Earned by verifying your identity with Stripe and confirming your email/phone.
  ```
- **Link:** "Learn More" → Help Center: "How Identity Verification Works"

**Evidence Component:**
- **Title:** "Evidence Component"
- **Body:**
  ```
  Worth up to 300 points.

  Earned by uploading receipts, screenshots, and linking your marketplace profiles.
  ```
- **Link:** "Learn More" → Help Center: "Adding Evidence to Your Profile"

**Behaviour Component:**
- **Title:** "Behaviour Component"
- **Body:**
  ```
  Worth up to 300 points.

  Based on having no safety reports, consistent activity, and account longevity.
  ```

**Peer Verification Component:**
- **Title:** "Peer Verification Component"
- **Body:**
  ```
  Worth up to 200 points.

  Earned by getting mutual confirmations from people you've traded with.
  ```
- **Link:** "Learn More" → Help Center: "Mutual Transaction Verification"

#### **2. RiskScore & Security Center**

**RiskScore:**
- **Title:** "What is RiskScore?"
- **Body:**
  ```
  RiskScore (0-100) measures potential fraud signals. Higher = more risk.

  It's based on device patterns, evidence integrity checks, and user reports.

  High RiskScore may restrict account features until resolved.
  ```
- **Link:** "Learn More" → Help Center: "Understanding Risk Signals"
- **Action:** "Open Security Center"

**Risk Signals:**
- **Title:** "Risk Signals"
- **Body:**
  ```
  Risk signals are automated fraud detection alerts.

  Examples: suspicious evidence, device inconsistency, or reports from other users.

  You can review and resolve these in Security Center.
  ```
- **Link:** "Learn More" → Help Center: "What Are Risk Signals?"

**Device Fingerprinting:**
- **Title:** "Device Security"
- **Body:**
  ```
  SilentID monitors your devices for security.

  If you log in from a new device, we'll alert you to prevent account takeover.
  ```
- **Link:** "Learn More" → Help Center: "Device & Session Security"

**Account Restrictions:**
- **Title:** "Why is my account restricted?"
- **Body:**
  ```
  Accounts may be temporarily restricted if:
  • High RiskScore detected
  • Multiple safety reports filed
  • Evidence integrity concerns

  Contact support to resolve.
  ```
- **Action:** "Contact Support"

#### **3. Identity Verification (Stripe)**

**Stripe Identity:**
- **Title:** "Identity Verification with Stripe"
- **Body:**
  ```
  SilentID uses Stripe to verify your identity.

  Your ID documents and selfie are stored by Stripe (not SilentID). We only receive confirmation that you're verified.

  This prevents fake accounts and boosts your TrustScore.
  ```
- **Link:** "Learn More" → Help Center: "How Identity Verification Works"
- **Action:** "Verify Now" (if not verified)

**Verification Retry:**
- **Title:** "Verification Failed"
- **Body:**
  ```
  Your identity verification was unsuccessful.

  Reasons: blurry photo, document mismatch, or expired ID.

  You can retry up to 3 times per 24 hours.
  ```
- **Link:** "Learn More" → Help Center: "Troubleshooting Identity Verification"
- **Action:** "Try Again"

#### **4. Evidence Vault**

**Evidence Vault:**
- **Title:** "What is Evidence Vault?"
- **Body:**
  ```
  Your Evidence Vault stores proof of your trustworthy behaviour:

  • Email receipts from marketplaces
  • Screenshots of reviews/ratings
  • Links to public seller profiles

  All evidence is integrity-checked and contributes to your TrustScore.
  ```
- **Link:** "Learn More" → Help Center: "Adding Evidence to Your Profile"

**Email Receipt Scanning:**
- **Title:** "How Email Scanning Works"
- **Body:**
  ```
  We scan your inbox for order confirmations from marketplaces like Vinted, eBay, and Depop.

  We only read receipts—not personal emails.

  You can disconnect anytime.
  ```
- **Link:** "Learn More" → Help Center: "Email Receipt Scanning"

**Screenshot Integrity:**
- **Title:** "Screenshot Verification"
- **Body:**
  ```
  All screenshots are checked for tampering using image analysis.

  Suspicious or edited screenshots may be rejected.

  Upload clear, unedited screenshots for best results.
  ```

**Evidence Storage:**
- **Title:** "What SilentID Stores"
- **Body:**
  ```
  We store:
  ✅ Summary of transactions (date, amount, platform)
  ✅ Screenshot images
  ✅ Public profile data

  We do NOT store:
  ❌ Full email content
  ❌ ID documents (handled by Stripe)
  ❌ Your passwords (we don't use passwords!)
  ```
- **Link:** "Learn More" → Help Center: "Privacy & Data Storage"

#### **5. Passwordless Authentication**

**Why No Passwords:**
- **Title:** "Why Doesn't SilentID Use Passwords?"
- **Body:**
  ```
  Passwords are the #1 cause of account hacks.

  SilentID is 100% passwordless. You log in with:
  • Apple Sign-In
  • Google Sign-In
  • Passkeys (Face ID / Touch ID)
  • Email OTP (6-digit code)

  Your account is more secure this way.
  ```
- **Link:** "Learn More" → Help Center: "Passwordless Authentication"

**Email OTP:**
- **Title:** "How Email OTP Works"
- **Body:**
  ```
  We send a 6-digit code to your email.

  Enter it within 5 minutes to log in.

  You can request up to 3 codes per 5 minutes.
  ```

**Passkeys:**
- **Title:** "What are Passkeys?"
- **Body:**
  ```
  Passkeys use Face ID, Touch ID, or fingerprint to log in.

  They're device-bound and extremely secure.

  You can enable passkeys in Settings → Security.
  ```
- **Link:** "Learn More" → Help Center: "Setting Up Passkeys"
- **Action:** "Enable Passkey"

**Account Recovery:**
- **Title:** "What if I lose my device?"
- **Body:**
  ```
  If you lose access, you can recover your account by:

  1. Entering your email
  2. Verifying your identity via Stripe again

  Your TrustScore and evidence will be restored.
  ```
- **Link:** "Learn More" → Help Center: "Account Recovery"

#### **6. Public Profile**

**Public Profile Visibility:**
- **Title:** "What's Public?"
- **Body:**
  ```
  Your public profile shows:
  ✅ Display name (e.g., "Sarah M.")
  ✅ Username (@sarahtrusted)
  ✅ TrustScore
  ✅ Verification badges
  ✅ General activity metrics

  Your public profile does NOT show:
  ❌ Full legal name
  ❌ Email or phone
  ❌ Address or location
  ❌ ID documents
  ```
- **Link:** "Learn More" → Help Center: "Public Profile Privacy"

**Safety Labels:**
- **Title:** "Safety Warnings"
- **Body:**
  ```
  If multiple users report a profile, we may display:

  ⚠️ "Safety concern flagged"

  This means other users have submitted verified evidence about this person.

  We recommend extra caution.
  ```
- **Link:** "Learn More" → Help Center: "Safety Reports & Warnings"

#### **7. Subscriptions (Free / Premium / Pro)**

**Subscription Tiers:**
- **Title:** "What's the difference?"
- **Body:**
  ```
  Free: Basic TrustScore, limited evidence (10 receipts, 5 screenshots)

  Premium (£4.99/mo): Unlimited evidence, advanced analytics, 100GB vault

  Pro (£14.99/mo): Everything in Premium + bulk checks, dispute tools, 500GB vault
  ```
- **Link:** "Learn More" → Help Center: "Subscription Plans"
- **Action:** "Upgrade Now"

**Subscription & Safety:**
- **Title:** "Does paying increase my TrustScore?"
- **Body:**
  ```
  NO.

  Paying for Premium or Pro does NOT directly increase your TrustScore or override safety systems.

  Subscriptions only unlock features like larger Evidence Vault and analytics.
  ```
- **Link:** "Learn More" → Help Center: "How Subscriptions Work"

**Refund Policy:**
- **Title:** "Refund Policy"
- **Body:**
  ```
  We do not offer refunds for partial months.

  You can cancel anytime. Your plan remains active until the end of your billing period.
  ```
- **Link:** "Learn More" → Help Center: "Cancellation & Refunds"

### 40.5 Copy Source & Constraints

**Mandatory Rules:**

1. **All info point text MUST:**
   - Be derived from existing content in CLAUDE.md (Sections 3, 5, 6, 11, 15, 16, 19, 20)
   - Never define new product behaviour not specified in CLAUDE.md
   - Respect all legal, privacy, and defamation constraints from Section 4

2. **Language Requirements:**
   - Use **defamation-safe wording** (Section 4)
     - ✅ "Safety concern flagged"
     - ❌ "This user is a scammer"
   - Use **GDPR-compliant language** (Section 20)
     - ✅ "We store transaction summaries"
     - ❌ "We read all your emails"
   - Use **subscription wording from Section 12/16**
     - ✅ "Paid subscription does NOT override risk systems"

3. **Copy Length Limits:**
   - Title: Maximum 6 words
   - Body: Maximum 100 words (4-5 sentences)
   - Bullet points: Maximum 5 items
   - Learn More link text: Maximum 6 words

4. **Tone:**
   - Professional, calm, educational
   - Bank-grade seriousness (not playful)
   - Simple language (avoid jargon)
   - Empowering (not condescending)

### 40.6 Integration with Help Center (Section 19)

**Link Behavior:**

1. **"Learn More" Links:**
   - Must point to specific Help Center article (Section 19)
   - Opens in:
     - **Mobile:** In-app web view (preferred) or native browser
     - **Web:** New tab
   - Back button returns to info modal (mobile)

2. **Help Center Article Mapping:**

| Info Point Topic | Help Center Article |
|------------------|---------------------|
| TrustScore | "Understanding Your TrustScore" |
| Identity Verification | "How Identity Verification Works" |
| Evidence Vault | "Adding Evidence to Your Profile" |
| Passwordless Auth | "Passwordless Authentication" |
| RiskScore | "Understanding Risk Signals" |
| Public Profile | "Public Profile Privacy" |
| Subscriptions | "Subscription Plans" |
| Safety Reports | "Safety Reports & Warnings" |

3. **Help Center Content Sync:**
   - When Help Center articles are updated (Section 19), info point text should be reviewed for consistency
   - Info points provide **short summaries**, Help Center provides **full details**

### 40.7 Testing & Validation

**Before Shipping Info Points:**

1. **Content Validation:**
   - ✅ All text derived from CLAUDE.md
   - ✅ No new product behaviour invented
   - ✅ Defamation-safe language used
   - ✅ GDPR-compliant wording
   - ✅ All "Learn More" links point to correct Help Center articles

2. **UI Validation:**
   - ✅ Info icons use correct size/color/style
   - ✅ Modals render correctly on all screen sizes
   - ✅ Tap targets meet 44×44 dp minimum
   - ✅ Modal close interaction works (tap outside, swipe down)
   - ✅ Animations smooth (300ms or less)

3. **Accessibility Validation:**
   - ✅ Screen readers announce info point purpose
   - ✅ Modal content readable by screen readers
   - ✅ Keyboard navigation works (future web)

### 40.8 Implementation Checklist for UI Agents

**Before Implementing Info Points:**

1. Read Section 40 completely
2. Read all referenced sections (3, 5, 6, 11, 15, 16, 19, 20)
3. Verify Help Center articles exist (Section 19)
4. Confirm all info point locations from Section 40.4

**During Implementation:**

1. Create reusable InfoPoint component/widget
2. Create reusable InfoModal component/widget
3. Add info points to all required locations
4. Link to Help Center articles correctly
5. Test modal behavior on all screen sizes

**After Implementation:**

1. Validate all copy against CLAUDE.md
2. Test all info point interactions
3. Verify Help Center links work
4. Test with screen readers enabled
5. Get legal review for any new copy (if needed)

### 40.9 Future Extensions

**Post-MVP Enhancements:**

1. **Interactive Tutorials:**
   - First-time user onboarding with info point highlights
   - "Tap here to learn about TrustScore" tooltips

2. **Contextual Info Points:**
   - Show different info based on user state
   - Example: "Your TrustScore is low" → Info point explains how to improve

3. **Info Point Analytics:**
   - Track which info points users tap most
   - Use data to improve Help Center content

4. **Video Info Points:**
   - Short 15-30 second explainer videos
   - Embedded in info modals (future)

5. **Personalised Info:**
   - Info point text adapts based on user's subscription tier
   - Example: Free users see "Upgrade to unlock" in Evidence Vault info

---

## SECTION 41: AI ARCHITECTURE & MODEL USAGE (AZURE-HOSTED)

### 41.1 Purpose

Define SilentID's AI architecture, model usage strategy, data handling rules, and integration points across the platform to ensure:
- Privacy-compliant AI assistance for trust analysis, risk detection, and user support
- Clear boundaries between AI-assisted operations and deterministic business logic
- Secure Azure-hosted infrastructure with appropriate model selection per use case
- Compliance with all legal, privacy, and defamation constraints defined throughout this specification

**Critical Principle:** AI models **assist** but never override hard safety rules, legal constraints, or admin review processes defined in other sections of CLAUDE.md.

### 41.2 Hosting & Infrastructure

**Primary AI Infrastructure:**
- **Platform:** Microsoft Azure (same tenant as SilentID backend/database)
- **Primary Region:** UK South or West Europe (GDPR compliance)
- **Failover Region:** Secondary EU region (disaster recovery)
- **Network:** Private endpoints, no public internet exposure for AI processing
- **Data Residency:** All AI processing must occur within EU/UK Azure regions

**Azure Services Used:**
- Azure OpenAI Service (primary reasoning engine)
- Azure Cognitive Services (OCR, image verification)
- Azure Kubernetes Service (AKS) - for optional self-hosted models
- Azure AI Studio - for model deployment, monitoring, version control

### 41.3 Layered AI Model Strategy

SilentID uses a **4-layer AI architecture**, each with specific responsibilities, data access permissions, and privacy constraints:

---

#### **Layer A: Primary Reasoning Engine (Azure OpenAI)**

**Models:**
- GPT-4 Turbo (gpt-4-0125-preview or later)
- GPT-4o (multimodal capabilities for future use)
- Future: GPT-5.x as available in Azure OpenAI

**Use Cases:**
1. **TrustScore Reasoning & Explanation**
   - Analyze aggregated evidence signals (not raw data) to generate human-readable explanations
   - Example: "Your TrustScore increased by 40 points because you added 5 verified receipts from Vinted"
   - Input: Anonymized transaction summaries, evidence counts, platform names
   - Output: Plain-language explanations for Info Point modals, Help Center articles

2. **Risk Pattern Interpretation**
   - Assist RiskEngine (Section 25) by interpreting complex fraud patterns
   - Example: Detect circular mutual verification rings, collusion signals
   - Input: Anonymized device fingerprints, IP patterns, transaction graphs
   - Output: Risk signal descriptions, suggested admin review priorities

3. **Scam Detection & Evidence Analysis**
   - Analyze text from screenshots (OCR output) for scam indicators
   - Example: Detect fake tracking numbers, inconsistent dates, fraudulent language patterns
   - Input: OCR text from screenshots (never ID documents), public profile scraped data
   - Output: Integrity score contributions, fraud flags for admin review

4. **Help Center Content Generation**
   - Generate draft help articles based on CLAUDE.md specifications (Section 19)
   - Input: CLAUDE.md sections, user question templates
   - Output: Draft help articles (must be reviewed before publishing)

5. **Admin Support Tooling**
   - Summarize complex user disputes for admin review
   - Suggest resolution pathways based on evidence patterns
   - Input: Anonymized report details, evidence summaries
   - Output: Admin dashboard insights, suggested actions (final decision always human)

**Data Access Permissions:**
✅ **CAN access:**
- Aggregated TrustScore component values (numbers only, no raw evidence)
- OCR text from marketplace screenshots (no ID documents)
- Anonymized risk signals (device fingerprint patterns, IP clusters)
- Public profile scraped data (marketplace usernames, ratings, review counts)
- Summarized transaction metadata (date, amount, platform - no full receipts)

❌ **CANNOT access:**
- Raw ID documents or Stripe Identity verification images
- Full email content (only extracted summaries: date, amount, platform)
- User's full legal name, address, date of birth, phone number
- Raw session logs, authentication tokens, device IDs
- Individual user queries without anonymization

**Privacy & Security Rules:**
- All requests to Azure OpenAI must include `user_id` hash (not actual user ID) for abuse monitoring
- No model training on SilentID user data (Azure OpenAI enterprise agreement)
- All prompts logged for compliance audits (stored separately, 90-day retention)
- Rate limiting: 100 requests/minute per endpoint, 10,000/day per user context
- Prompt injection detection: Filter user-provided text before sending to model
- Response validation: Check for PII leakage, defamation-unsafe language before displaying

**API Integration Pattern:**
```csharp
// Example: TrustScore explanation generation
var prompt = $@"
Context: User's TrustScore increased from {oldScore} to {newScore}.
Changes: Added {receiptCount} receipts, {screenshotCount} screenshots.
Platforms: {string.Join(", ", platforms)}.

Generate a concise (2-3 sentence) explanation for why the score changed.
Use defamation-safe language (Section 4 rules). No marketing fluff.
";

var response = await azureOpenAIClient.GetCompletionAsync(
    deploymentName: "gpt-4-turbo",
    prompt: prompt,
    maxTokens: 150,
    temperature: 0.3, // Low temperature for consistency
    user: HashUserId(userId) // Anonymized tracking
);
```

---

#### **Layer B: Internal Risk Engine (Optional Self-Hosted Llama)**

**Models:**
- Llama 3.1 70B (or smaller variants for cost optimization)
- Hosted on Azure Kubernetes Service (AKS) within SilentID's private network
- Never exposed to public internet or external APIs

**Use Cases:**
1. **Anomaly Detection**
   - Detect unusual device fingerprint patterns (Section 7, 25)
   - Identify IP geo-location anomalies (impossible travel detection)
   - Flag suspicious timing patterns (bulk evidence uploads at 3am)

2. **Collusion Detection**
   - Analyze mutual verification graphs for circular patterns (Section 7)
   - Detect fake account clusters (same device, same IP, same evidence hashes)
   - Identify reputation boosting rings

3. **Behavior Pattern Clustering**
   - Group similar fraud patterns for improved detection
   - Learn from admin-confirmed fraud cases (supervised learning on flagged accounts)
   - Predict high-risk account creation attempts

**Data Access Permissions:**
✅ **CAN access:**
- Device fingerprints (hashed)
- IP addresses and ASN patterns
- Transaction timing patterns
- Evidence upload patterns (file sizes, timestamps, metadata - not content)
- Account creation patterns (signup IP, device, timing)

❌ **CANNOT access:**
- User personal data (names, emails, addresses)
- Evidence content (screenshots, receipt images, OCR text)
- TrustScore or RiskScore final values (only input signals)
- Stripe Identity verification results

**Privacy & Security Rules:**
- Model trained ONLY on anonymized, aggregated patterns
- No individual user data used for training (only pattern clusters)
- All data processed in-memory (no disk writes except encrypted model weights)
- Model outputs are internal signals only (never shown directly to users or partners)
- Human admin review required before acting on high-severity risk signals

**Output Format:**
- Risk signals sent to RiskSignals table (Section 25)
- Each signal includes: type, severity (1-10), confidence score, evidence pointers
- Admin dashboard shows signals with explainability: "Flagged due to device cluster pattern X"

---

#### **Layer C: Vision & OCR (Azure Cognitive + Optional External Models)**

**Models:**
- **Primary:** Azure Computer Vision (OCR, image integrity checks)
- **Secondary (Optional):** Google Gemini Vision 1.5 Pro (for complex marketplace screenshots)

**Use Cases:**
1. **Screenshot OCR & Text Extraction**
   - Extract text from marketplace screenshots (reviews, ratings, transaction history)
   - Detect tampering indicators (pixel-level manipulation, edge inconsistencies)
   - Validate screenshot authenticity (metadata checks, device consistency)

2. **Receipt Image Processing**
   - Extract transaction details from email receipt images (date, amount, platform)
   - Verify receipt format matches known marketplace templates
   - Detect duplicate receipts (perceptual hashing)

3. **Image Integrity Verification**
   - Detect Photoshop artifacts, clone stamping, copy-paste manipulation
   - Analyze color palette consistency with known platform branding
   - Validate screenshot resolution matches claimed device

**Data Access Permissions:**
✅ **CAN access:**
- Marketplace screenshot images (Vinted, eBay, Depop profiles)
- Email receipt images (order confirmations, shipping labels)
- Public profile screenshots (reviews, ratings, join dates)

❌ **CANNOT access:**
- ID documents (passport, driver's license, national ID)
- Selfies or biometric images (Stripe Identity handles these, SilentID never sees them)
- Screenshots containing full personal addresses or phone numbers (must be redacted first)
- Private messages or DMs (only transaction-related content allowed)

**Privacy-Filtered Input Process:**
1. **Pre-Processing (Before AI):**
   - User uploads screenshot → SilentID frontend redacts sensitive fields (address, phone)
   - Backend validates file type, size, metadata
   - Check if image contains ID document indicators (flag and reject if detected)

2. **AI Processing:**
   - Send privacy-filtered image to Azure Computer Vision for OCR
   - If Azure OCR fails or confidence < 80%, optionally send to Gemini Vision
   - Extract: marketplace name, username, rating, review count, join date, transaction details

3. **Post-Processing:**
   - Store only extracted metadata (text summary, integrity score)
   - Delete original image after 30 days (or immediately if user deletes evidence)
   - Never send extracted data to external models for training

**Azure Computer Vision API Pattern:**
```csharp
var ocrResult = await computerVisionClient.ReadInStreamAsync(imageStream);
var text = string.Join(" ", ocrResult.AnalyzeResult.ReadResults.SelectMany(r => r.Lines.Select(l => l.Text)));

// Integrity check
var integrityScore = CalculateImageIntegrity(imageMetadata, ocrResult);

// Store summary only
var screenshotEvidence = new ScreenshotEvidence {
    OCRText = text,
    IntegrityScore = integrityScore,
    Platform = DetectPlatform(text),
    FileUrl = azureBlobUrl, // Will be deleted after 30 days
    EvidenceState = integrityScore > 70 ? "Valid" : "Suspicious"
};
```

**External Model Usage (Gemini Vision) - Optional:**
- Only used when Azure OCR confidence < 80% or complex layout detected
- Google Gemini API called via Azure API Management (rate limiting, logging)
- Same privacy filtering rules apply
- User data NOT used for Gemini model training (Google Vertex AI enterprise agreement)

---

#### **Layer D: Safe Text & User-Facing Explanations (Azure OpenAI + Optional Claude)**

**Models:**
- **Primary:** Azure OpenAI GPT-4 Turbo (same as Layer A)
- **Secondary (Optional):** Anthropic Claude 3.5 Sonnet (via Azure Bedrock or API)

**Use Cases:**
1. **Info Point Modal Content (Section 40)**
   - Generate short explanations for info point (ⓘ) modals
   - Example: "What is TrustScore?" → 2-3 sentence explanation
   - Input: Section references from CLAUDE.md, user's current context (e.g., score = 450)
   - Output: Plain-language text (max 100 words, defamation-safe)

2. **Help Center Article Drafting (Section 19)**
   - Auto-generate help articles from CLAUDE.md sections
   - Example: "How to add email receipts" → Step-by-step guide
   - Input: CLAUDE.md Section 5, 6 (feature descriptions)
   - Output: Structured help article (requires human review before publishing)

3. **TrustScore Improvement Suggestions**
   - Personalized suggestions based on user's current evidence
   - Example: "Add 5 more receipts to reach High Trust (600+ score)"
   - Input: User's current TrustScore breakdown (anonymized)
   - Output: Actionable suggestions list

4. **Defamation-Safe Report Wording**
   - Assist admins in writing neutral, evidence-based report summaries
   - Input: Admin-selected evidence, report category
   - Output: Suggested wording following Section 4 guidelines

**Data Access Permissions:**
✅ **CAN access:**
- CLAUDE.md specification text (for Help Center generation)
- User's TrustScore component breakdown (numbers only)
- Evidence counts (number of receipts, screenshots - not content)
- Public profile metrics (platforms verified, account age)

❌ **CANNOT access:**
- User's full name, email, phone, address
- Raw evidence content (screenshot images, receipt details)
- Other users' data (except for comparative examples like "Users with similar scores have...")

**Legal & Safety Constraints:**
- All generated text MUST follow defamation-safe language rules (Section 4)
- Never use: "scammer", "fraudster", "untrustworthy", "criminal", "dangerous"
- Always use: "safety concern flagged", "risk signals detected", "multiple reports received"
- Generated content reviewed by automated safety filter before display
- Admin review required for: public-facing help articles, legal disclaimers, safety warnings

**Claude Usage (Optional):**
- If Azure OpenAI produces marketing-style or overly promotional text, use Claude 3.5 Sonnet
- Claude API called via Azure API Management or direct Anthropic API
- Same data access restrictions apply
- Use temperature=0.2 for consistency, strict prompt for defamation-safe language

---

### 41.4 Data Handling Rules (Comprehensive)

**Anonymization Requirements:**

| Data Type | AI Layer Access | Anonymization Required | Example |
|-----------|-----------------|------------------------|---------|
| User ID | All layers | ✅ Hash to UUID | `user_12345` → `hash(user_12345)` |
| Email | None | ✅ Never sent to AI | `user@example.com` → (not provided) |
| Full Name | None | ✅ Never sent to AI | `John Smith` → (not provided) |
| Display Name | Layer A, D | ⚠️ Partial (first name + initial only) | `Sarah M.` (OK), `Sarah Mitchell` (not OK) |
| Device Fingerprint | Layer B | ✅ Hash to UUID | `device_abc123` → `hash(device_abc123)` |
| IP Address | Layer B | ✅ Anonymize to /24 subnet | `192.168.1.50` → `192.168.1.0/24` |
| OCR Text | Layer A, C | ✅ Redact PII first | Remove phone, address before AI |
| Screenshot Image | Layer C only | ✅ Privacy-filter first | Blur sensitive fields before AI |
| Receipt Details | Layer A | ✅ Summary only | "Transaction: £45.99, Vinted, 2025-01-15" |
| TrustScore | Layer A, D | ⚠️ Numbers only | "TrustScore: 754" (OK), with user name (not OK) |

**Model Training Restrictions:**
- ✅ Azure OpenAI: Enterprise agreement, no training on customer data
- ✅ Azure Cognitive Services: No training on customer data
- ✅ Self-hosted Llama: Trained only on anonymized pattern clusters, never raw user data
- ❌ External APIs (Gemini, Claude): Data must NOT be used for training (verify in service agreements)

**Logging & Audit:**
- All AI requests logged to separate audit database (90-day retention)
- Log format: `{ timestamp, model, user_hash, prompt_hash, response_hash, latency, cost }`
- Never log full prompts or responses containing PII
- Admin access to logs requires SuperAdmin role + justification
- Logs used for: abuse detection, cost monitoring, performance optimization

---

### 41.5 Responsibilities & Decision Authority

**What AI Models DO:**
- ✅ Assist in TrustScore explanation generation (plain-language summaries)
- ✅ Detect fraud patterns and generate risk signals for admin review
- ✅ Extract text from screenshots (OCR) and verify image integrity
- ✅ Suggest admin actions (freeze account, request more evidence)
- ✅ Draft Help Center articles and Info Point content
- ✅ Provide comparative insights ("Users with similar TrustScores have...")

**What AI Models DO NOT DO:**
- ❌ Make final TrustScore calculations (deterministic formula in TrustScoreService)
- ❌ Make final RiskScore decisions (deterministic rules in RiskEngine)
- ❌ Automatically freeze/ban accounts (admin approval required)
- ❌ Override legal constraints or defamation-safe language rules
- ❌ Bypass Stripe Identity verification (ID checks always via Stripe)
- ❌ Approve/reject evidence without admin review (for high-risk cases)

**Decision Authority Hierarchy:**
1. **Hard Business Rules** (Code) - Highest authority
   - TrustScore formula (Section 5)
   - RiskScore thresholds (Section 25)
   - Account suspension triggers (Section 28)

2. **Admin Review** (Human)
   - Safety report verification (Section 8, 24)
   - Evidence rejection appeals (Section 24)
   - Account freeze/ban decisions (Section 28)

3. **AI Assistance** (Advisory Only)
   - Risk signal suggestions
   - Fraud pattern detection
   - Admin workflow optimization

**Example Decision Flow:**
```
1. AI (Layer B) detects collusion pattern → Creates RiskSignal (severity=8)
2. RiskEngine (Code) evaluates RiskSignal → Increases RiskScore to 75
3. RiskScore > 70 threshold → Triggers account freeze (automatic, per Section 25)
4. Admin receives notification → Reviews evidence, AI explanation, user history
5. Admin makes final decision:
   - Confirm freeze (permanent ban if fraud confirmed)
   - Unfreeze (false positive, adjust detection rules)
   - Request more evidence (user must re-verify identity)
```

---

### 41.6 Integration Points with Existing Sections

**Section 5 (Core Features):**
- AI assists with TrustScore explanations but does NOT calculate TrustScore
- TrustScore formula remains deterministic: Identity (200) + Evidence (300) + Behaviour (300) + Peer (200)

**Section 7 (Anti-Fraud Engine):**
- Layer B (Llama) feeds signals into existing 9-layer fraud detection system
- AI-detected patterns create RiskSignals in database (same table as rule-based signals)
- Final RiskScore calculation combines AI signals + deterministic rules

**Section 19 (Help Center):**
- Layer D generates draft help articles from CLAUDE.md
- All articles reviewed by admin before publishing
- Article generation follows Section 19 format requirements

**Section 24 (Appeals & Review):**
- AI provides admin with suggested resolution pathways
- Final appeal decisions made by human admin
- AI explanation included in admin notes for transparency

**Section 25 (Risk & Anomaly Signals):**
- Layer B generates new signal types: `AIAnomalyDetected`, `AICollisionPattern`, `AIDeviceCluster`
- Signals include confidence score (0.0-1.0) and explainability text
- Low confidence signals (< 0.7) flagged for admin review before action

**Section 28 (Admin Roles & Permissions):**
- AI-suggested actions require admin approval
- SuperAdmin can override AI risk signals (with justification)
- All AI-triggered actions logged in AdminAuditLogs

**Section 40 (Info Points):**
- Layer D generates dynamic info point content
- Content filtered through defamation-safe language checker
- Cached for 24 hours (regenerated if underlying data changes)

**Partner API (Section 22):**
- AI explanations NOT exposed to partners (only aggregated trust/risk levels)
- Partners receive static risk bands: "Low", "Medium", "High"
- No AI-generated text in partner-facing API responses

---

### 41.7 Performance & Cost Management

**Model Selection Strategy:**

| Use Case | Model | Reasoning |
|----------|-------|-----------|
| Simple explanations (< 50 words) | GPT-4o-mini | Fast, low-cost, sufficient quality |
| Complex fraud analysis | GPT-4 Turbo | High reasoning capability needed |
| Bulk pattern detection | Self-hosted Llama | Cost-effective for high-volume internal processing |
| Image OCR (simple) | Azure Computer Vision | Optimized for text extraction |
| Image OCR (complex layouts) | Gemini Vision 1.5 Pro | Better multi-modal understanding |

**Cost Optimization:**
- Caching: Store AI-generated Help Center articles for 30 days
- Batch processing: Group similar risk analysis requests (process 100 accounts together)
- Rate limiting: 10 AI requests per user per hour (prevents abuse)
- Smart routing: Use GPT-4o-mini for 80% of requests, GPT-4 Turbo only when needed
- Self-hosting: Llama for internal risk processing (avoids per-token costs)

**Performance Targets:**
- Info Point explanations: < 500ms response time (cached)
- Risk signal generation: < 5s for batch of 100 accounts
- Screenshot OCR: < 3s per image
- Help Center article generation: < 10s (async, background job)

**Monitoring:**
- Track token usage per endpoint (alert if usage spikes)
- Monitor AI response latency (P95 < 2s for user-facing requests)
- Log model version for each request (enables A/B testing)
- Cost dashboard: $ spent per AI layer per day

---

### 41.8 Security & Compliance

**Prompt Injection Defense:**
- All user-provided text sanitized before including in prompts
- Blacklist: `ignore previous instructions`, `system:`, `<|endoftext|>`, etc.
- Whitelist approach for structured inputs (e.g., platform names must match enum)
- Output validation: Reject responses containing PII patterns

**PII Leakage Prevention:**
- Automated PII detector runs on all AI responses before display
- Regex patterns for: email, phone, full address, credit card, passport numbers
- If PII detected: Block response, log incident, alert admin
- User never sees raw AI output (always filtered through safety layer)

**GDPR Compliance:**
- AI processing covered under "Legitimate Interest" lawful basis (fraud prevention, service improvement)
- Users informed via Privacy Policy (Section 33) that AI assists with trust analysis
- Right to object: Users can opt out of AI-assisted explanations (fallback to static text)
- Data retention: AI request logs deleted after 90 days (anonymized summaries retained)

**Audit Trail:**
- Every AI decision logged: what data was sent, what model was used, what output was generated
- Admin can trace: "Why was this user flagged?" → View AI risk signal + prompt/response summary
- Compliance team can audit: AI usage patterns, data access, model versions

---

### 41.9 Future Extensions (Phase 2+)

**Conversational Trust Assistant (Not MVP):**
- User asks: "How can I improve my TrustScore?"
- AI (Layer D) provides personalized, actionable suggestions
- Requires: Conversation history storage, user consent for chat analysis

**Predictive Risk Scoring (Not MVP):**
- Layer B predicts likelihood of future fraud based on early signals
- Example: "New account with high-risk device pattern → 80% chance of fraud attempt"
- Requires: Historical fraud case dataset, supervised learning pipeline

**Automated Evidence Categorization (Not MVP):**
- Layer C automatically tags screenshots: "Vinted review screenshot", "eBay sales history"
- Reduces manual user input during evidence upload
- Requires: Fine-tuned vision model on marketplace screenshot dataset

**Multi-Language Support (Not MVP):**
- AI translates Help Center articles, Info Points into user's language
- Maintains defamation-safe language rules across translations
- Requires: Translation memory, legal review per language

---

### 41.10 Implementation Checklist

**Before ANY agent implements AI features:**

✅ **Phase 0: Azure Infrastructure Setup**
- [ ] Provision Azure OpenAI Service in UK South/West Europe region
- [ ] Create Azure Computer Vision resource
- [ ] Set up private endpoints (no public internet access)
- [ ] Configure Azure Key Vault for API keys
- [ ] Enable logging to Azure Monitor + Application Insights

✅ **Phase 1: Layer A (Primary Reasoning)**
- [ ] Implement AzureOpenAIService wrapper class
- [ ] Add PII filtering middleware
- [ ] Create prompt templates for TrustScore explanations
- [ ] Build defamation-safe language validator
- [ ] Test with sample data (no real user data yet)

✅ **Phase 2: Layer C (Vision/OCR)**
- [ ] Integrate Azure Computer Vision API
- [ ] Build screenshot privacy filter (redact sensitive fields)
- [ ] Implement image integrity checker
- [ ] Optional: Add Gemini Vision fallback
- [ ] Test with marketplace screenshot samples

✅ **Phase 3: Layer B (Risk Engine - Optional)**
- [ ] Deploy Llama 3.1 to AKS cluster
- [ ] Build anonymization pipeline for training data
- [ ] Train model on fraud pattern clusters
- [ ] Create RiskSignal generation API
- [ ] Integrate with existing RiskEngine (Section 25)

✅ **Phase 4: Layer D (User-Facing Text)**
- [ ] Generate Help Center articles from CLAUDE.md
- [ ] Implement Info Point content API
- [ ] Add human review workflow for generated content
- [ ] Cache generated text (Redis/Azure Cache)

✅ **Validation & Testing:**
- [ ] Security audit: Verify no PII leakage, prompt injection protection
- [ ] Legal review: Ensure defamation-safe language in all outputs
- [ ] Performance testing: Measure latency, cost per request
- [ ] GDPR compliance check: Data retention, user rights (access, deletion)

---

### 41.11 Non-Implementation Constraints

**This section is a SPECIFICATION ONLY.**

Future implementation agents must:
- ✅ Follow this AI architecture exactly (no deviation without updating CLAUDE.md first)
- ✅ Respect all data access permissions defined in Section 41.4
- ✅ Use Azure-hosted models as primary option (external models only as fallback)
- ✅ Never bypass legal/privacy constraints defined in Section 4, 20, 32, 33
- ✅ Implement AI features in phases (do NOT build all layers at once)

Implementation agents must NOT:
- ❌ Add new AI use cases not listed in this section (update spec first)
- ❌ Change model selection strategy without cost/performance justification
- ❌ Send user data to external AI services without privacy filtering
- ❌ Use AI outputs to make irreversible decisions without admin review

---

## END OF SECTION 41

**Related Sections:**
- Section 4: Legal & Compliance (defamation-safe language rules)
- Section 5: Core Features (TrustScore, Evidence Vault)
- Section 7: Anti-Fraud Engine (fraud detection, RiskScore)
- Section 19: Help Center System (AI-generated content)
- Section 20: Critical System Requirements (privacy, GDPR)
- Section 24: TrustScore Appeal & Review (AI-assisted admin decisions)
- Section 25: Risk & Anomaly Signals (AI-generated risk signals)
- Section 28: Admin Roles & Permissions (AI action approval workflow)
- Section 32: Data Retention & Privacy (AI request logs, 90-day retention)
- Section 33: Legal Documents (Privacy Policy must mention AI usage)
- Section 40: UI Info Points (AI-generated explanatory content)

**Implementation Phase:** Phase 2+ (Not required for MVP)

**Next Steps for Implementation Agents:**
1. Review this section completely before implementing ANY AI feature
2. Start with Phase 0 (Azure infrastructure) - do NOT build AI features without proper hosting
3. Implement layers sequentially: A → C → D → B (not all at once)
4. Test with sample data first, never use real user data in development
5. Security audit and legal review required before production deployment

---

## SECTION 42: SILENTID LEGAL & COMPLIANCE OVERVIEW (CONSUMER)

### Purpose

This section provides a comprehensive legal framework for SilentID's consumer-facing trust identity service, ensuring compliance with UK and EU data protection law while protecting both users and SILENTSALE LTD.

### Legal Entity & Jurisdiction

**Service Provider:**
- **Company Name:** SILENTSALE LTD
- **Company Number:** 16457502
- **Registered in:** England & Wales
- **Registered Office:** [Insert registered address]
- **Trading as:** SilentID
- **Website:** www.silentid.co.uk
- **Contact Email:** legal@silentid.co.uk

**Governing Law:**
All legal relationships between SilentID and users are governed exclusively by the laws of England and Wales. Users agree to the exclusive jurisdiction of the courts of England and Wales for any disputes.

### What SilentID Is

SilentID is a **passwordless digital trust identity platform** that enables users to:
- Verify their identity once (via Stripe Identity)
- Build a portable reputation profile (TrustScore 0-1000)
- Share their trust profile across marketplaces, dating apps, rental platforms, and community groups
- Store evidence of trustworthy behaviour (receipts, screenshots, marketplace profiles)

### What SilentID Is NOT

**Critical Legal Position:**

SilentID is **NOT**:
- ❌ A credit reference agency
- ❌ A criminal records provider
- ❌ An insurance provider or guarantee service
- ❌ A background check or clearance service
- ❌ A financial institution or bank
- ❌ A marketplace or transaction platform
- ❌ A law enforcement agency
- ❌ A password manager

SilentID provides **evidence-based trust signals and tools** to help users make safer decisions. **SilentID does not guarantee outcomes, verify accuracy of third-party information, or provide legal, financial, or insurance advice.**

### Regulatory Compliance

**UK GDPR (General Data Protection Regulation):**
- SilentID complies with UK GDPR and the Data Protection Act 2018
- ICO Registration Number: [To be inserted upon registration]
- Data Protection Officer: dpo@silentid.co.uk

**Payment Services:**
- Payment processing handled exclusively by Stripe (regulated payment processor)
- SILENTSALE LTD is NOT a payment service provider

**Age Restriction:**
- SilentID is available ONLY to users aged 18 and over
- Users under 18 are prohibited from creating accounts

### Consumer Rights

**UK Consumer Law:**
Users are protected by:
- Consumer Rights Act 2015
- Consumer Contracts (Information, Cancellation and Additional Charges) Regulations 2013
- Electronic Commerce (EC Directive) Regulations 2002

**Right to Cancel:**
Users may cancel Premium or Pro subscriptions at any time. Subscription access continues until the end of the current billing period. No refunds for partial months.

**Right to Complain:**
Users may complain to:
1. SilentID Support: support@silentid.co.uk
2. If unresolved, the Information Commissioner's Office (ICO): ico.org.uk

### Limitation of Liability

**To the maximum extent permitted by UK law:**

1. **No Guarantee of Outcomes:**
   SilentID provides trust signals based on evidence and algorithms but does NOT guarantee the accuracy, reliability, or trustworthiness of any user.

2. **Third-Party Reliance:**
   SilentID is NOT responsible for decisions made by third parties (marketplaces, landlords, employers, etc.) based on TrustScores or profiles.

3. **Excluded Losses:**
   SilentID is not liable for:
   - Indirect, consequential, or incidental losses
   - Loss of profits, revenue, data, or business opportunities
   - Losses caused by third-party fraud or misrepresentation

4. **Maximum Liability:**
   SILENTSALE LTD's total liability to any user is limited to the amount paid by that user in the 12 months preceding the claim (or £100, whichever is greater).

**Exceptions:**
Nothing in these terms excludes liability for:
- Death or personal injury caused by negligence
- Fraud or fraudulent misrepresentation
- Any other liability that cannot be excluded by UK law

### Data Protection & Privacy

**GDPR Compliance:**
- Privacy by Design: SilentID is built with data minimisation and privacy protection
- User Rights: Access, Rectification, Erasure, Restriction, Portability, Objection
- Data Retention: Minimum necessary retention periods (see Section 32)
- Third-Party Processors: Stripe, Microsoft Azure, email providers

**No ID Documents Stored:**
SilentID uses Stripe Identity for identity verification. **ID documents and selfies are stored by Stripe, NOT by SilentID.** SilentID stores ONLY the verification result.

**No Passwords Stored:**
SilentID is 100% passwordless. **No passwords are ever stored.** Authentication uses Apple Sign-In, Google Sign-In, Passkeys, or Email OTP only.

### Prohibited Activities

Users must NOT:
- Create multiple accounts (one person = one account)
- Upload fake, tampered, or fraudulent evidence
- Impersonate others or create fake profiles
- Engage in collusion or reputation manipulation
- Use SilentID for illegal activities
- Harass, threaten, or abuse other users
- Attempt to hack, reverse engineer, or compromise the platform

**Consequences:**
Violation may result in account suspension, permanent ban, and legal action.

### Intellectual Property

**SilentID Ownership:**
All intellectual property in SilentID (software, logos, content, designs) belongs to SILENTSALE LTD. Users are granted a limited, non-exclusive, revocable licence to use the service.

**User Content:**
Users retain ownership of evidence they upload but grant SilentID a licence to process, store, and display it for service provision.

### Changes to Terms & Service

**Updates:**
SILENTSALE LTD reserves the right to update terms, policies, or service features at any time. Material changes will be communicated via email or in-app notification.

**Continued Use:**
Continued use of SilentID after changes constitutes acceptance of new terms.

---

## SECTION 43: SILENTID CONSUMER TERMS OF USE

**Last Updated:** [Insert date]
**Effective Date:** [Insert date]
**Version:** 1.0

These Terms of Use ("**Terms**") govern your access to and use of SilentID, a digital trust identity service provided by **SILENTSALE LTD** (Company No. 16457502), a company registered in England and Wales.

By creating a SilentID account or using our service, you agree to these Terms. If you do not agree, you must not use SilentID.

---

### 1. DEFINITIONS

**1.1 Definitions:**

- **"SilentID", "we", "us", "our"** means SILENTSALE LTD.
- **"You", "your", "user"** means the person or entity using SilentID.
- **"Service"** means the SilentID mobile application, website, and all related services.
- **"Account"** means your registered SilentID user account.
- **"TrustScore"** means the 0-1000 numerical trust rating calculated by SilentID.
- **"Evidence"** means receipts, screenshots, and marketplace profiles you upload.
- **"Public Profile"** means your publicly accessible SilentID profile at silentid.co.uk/u/[username].

---

### 2. ELIGIBILITY

**2.1 Age Requirement:**
You must be at least **18 years old** to use SilentID. By creating an account, you confirm you are 18 or older.

**2.2 Capacity:**
You confirm you have the legal capacity to enter into these Terms under the laws of England and Wales.

**2.3 Geographic Availability:**
SilentID is primarily intended for users in the United Kingdom. Use from other jurisdictions is at your own risk and subject to local laws.

---

### 3. ACCOUNT CREATION & SECURITY

**3.1 Account Registration:**
To use SilentID, you must create an account using one of these **passwordless** methods:
- Apple Sign-In
- Google Sign-In
- Passkeys (Face ID, Touch ID, fingerprint)
- Email OTP (one-time code)

**SilentID does NOT use passwords.** Any attempt to create or use passwords is prohibited.

**3.2 One Account Per Person:**
Each person may have **only ONE SilentID account**. Creating multiple accounts is prohibited and may result in all accounts being suspended.

**3.3 Account Security:**
You are responsible for:
- Keeping your email account secure
- Protecting your devices (passkey-enabled devices must be secured)
- Immediately reporting suspicious activity to support@silentid.co.uk

**3.4 Account Sharing:**
You must NOT share your account with others. Your account is personal and non-transferable.

---

### 4. IDENTITY VERIFICATION

**4.1 Stripe Identity:**
SilentID uses **Stripe Identity** (a third-party service) to verify your identity. When you choose to verify, you submit:
- A photo of your government-issued ID (passport, driver's licence, national ID)
- A selfie for liveness detection

**4.2 What SilentID Stores:**
SilentID stores ONLY:
- Verification status (Verified, Pending, Failed)
- Stripe verification reference ID
- Timestamp of verification

**SilentID does NOT store your ID documents or selfie photos.** These are stored by Stripe and governed by Stripe's privacy policy.

**4.3 Verification Requirement:**
Identity verification is **optional but strongly recommended**. Failure to verify will result in a lower TrustScore.

---

### 5. TRUSTSCORE SYSTEM

**5.1 What is TrustScore:**
TrustScore is a numerical score (0-1000) calculated based on:
- **Identity (200 points):** Stripe verification, email/phone verification
- **Evidence (300 points):** Receipts, screenshots, marketplace profiles
- **Behaviour (300 points):** No safety reports, account longevity, consistent activity
- **Peer Verification (200 points):** Mutual confirmations from trading partners

**5.2 No Guarantee:**
TrustScore is an **indicator only** and does NOT guarantee trustworthiness, reliability, or safety. Third parties (marketplaces, landlords, etc.) make their own decisions.

**5.3 Score Changes:**
Your TrustScore may increase or decrease based on:
- Adding or removing evidence
- Safety reports filed against you
- Changes in verification status
- Platform-detected fraud signals

**5.4 Recalculation:**
TrustScores are recalculated weekly. You can view your score breakdown in the app.

---

### 6. EVIDENCE VAULT

**6.1 What You Can Upload:**
You may upload:
- **Email Receipts:** Order confirmations from marketplaces (Vinted, eBay, Depop, etc.)
- **Screenshots:** Marketplace reviews, ratings, seller profiles
- **Public Profile Links:** URLs to your public seller profiles

**6.2 Evidence Integrity:**
All evidence is subject to automated integrity checks. Tampered, fake, or fraudulent evidence will be rejected and may result in account suspension.

**6.3 Storage Limits:**
- **Free:** 250MB
- **Premium (£4.99/month):** 100GB
- **Pro (£14.99/month):** 500GB

**6.4 What SilentID Stores:**
- Summary of transactions (date, amount, platform, item)
- Screenshot images (integrity-checked)
- Public profile data (username, rating, review count, join date)

**SilentID does NOT store:**
- Full email content (only transaction summaries)
- Private messages or DMs
- Passwords or credentials

**6.5 Email Scanning (Optional):**
If you connect your email account, SilentID scans ONLY for:
- Order confirmations
- Shipping notifications
- Transaction receipts

**We do NOT read personal emails.** You can disconnect your email at any time.

---

### 7. PUBLIC PROFILE

**7.1 What is Public:**
Your Public Profile at `silentid.co.uk/u/[username]` shows:
- Display name (e.g., "Sarah M.")
- Username (e.g., @sarahtrusted)
- TrustScore
- Verification badges
- Account age
- Number of verified transactions (approximate)

**7.2 What is NOT Public:**
Your Public Profile does NOT show:
- Full legal name
- Email address or phone number
- Home address or location
- Date of birth
- ID documents
- Raw evidence content

**7.3 Visibility Control:**
You can hide your Public Profile in Settings. This will prevent others from viewing your profile via link or QR code.

---

### 8. SUBSCRIPTIONS & BILLING

**8.1 Subscription Tiers:**
- **Free:** Basic features, limited evidence storage (250MB)
- **Premium (£4.99/month):** Unlimited evidence, advanced analytics, 100GB storage
- **Pro (£14.99/month):** All Premium features + bulk checks, dispute tools, 500GB storage

**8.2 Payment Processing:**
All payments are processed by **Stripe**. SilentID does NOT store your credit card details.

**8.3 Billing:**
Subscriptions are billed monthly and auto-renew unless cancelled. You will be charged on the same day each month.

**8.4 VAT:**
Prices include UK VAT (20%). VAT invoices are provided by Stripe.

**8.5 Cancellation:**
You may cancel your subscription at any time via Settings > Subscription > Cancel. Your subscription remains active until the end of the current billing period.

**8.6 No Refunds:**
We do NOT provide refunds for partial months. If you cancel, you retain access until period end.

**8.7 Payment Failures:**
If payment fails, you have a 7-day grace period. After 7 days, you will be automatically downgraded to Free.

**8.8 No Pay-to-Win:**
**Paid subscriptions do NOT increase your TrustScore or override risk/safety systems.** Subscriptions only unlock features like advanced analytics and larger storage.

---

### 9. SAFETY REPORTS & RISK SIGNALS

**9.1 Reporting:**
You may report safety concerns about other users if you have evidence of:
- Item not received
- Fraudulent behaviour
- Aggressive or threatening conduct
- Payment issues

**9.2 Evidence Required:**
Reports must include evidence (screenshots, receipts, messages). SilentID reviews all reports before taking action.

**9.3 False Reporting:**
Filing false or malicious reports is prohibited and may result in account suspension.

**9.4 Risk Signals:**
SilentID's automated fraud detection system may flag suspicious activity. Risk signals may result in:
- Account restrictions
- Evidence upload disabled
- Mandatory identity re-verification
- Account freeze (temporary or permanent)

**9.5 Appeals:**
If you believe a risk signal or report is incorrect, you may appeal via Settings > Appeals.

---

### 10. PROHIBITED ACTIVITIES

**10.1 You Must NOT:**
- Create multiple accounts
- Upload fake, tampered, or fraudulent evidence
- Impersonate others or create fake profiles
- Engage in collusion or reputation manipulation
- Use SilentID for illegal activities (fraud, scams, money laundering)
- Harass, threaten, defame, or abuse other users or staff
- Attempt to hack, reverse engineer, or compromise the platform
- Scrape, copy, or extract data from SilentID without permission
- Use automated tools (bots, scripts) to access SilentID

**10.2 Consequences:**
Violation may result in:
- Warning
- Account suspension (temporary)
- Permanent ban
- Legal action
- Reporting to law enforcement

---

### 11. INTELLECTUAL PROPERTY

**11.1 SilentID Ownership:**
All intellectual property in SilentID (software, logos, designs, content, algorithms) belongs to SILENTSALE LTD. You are granted a limited, non-exclusive, revocable licence to use the Service.

**11.2 User Content:**
You retain ownership of evidence you upload. By uploading, you grant SilentID a worldwide, non-exclusive, royalty-free licence to:
- Process, store, and display your evidence
- Use evidence to calculate TrustScore
- Display evidence on your Public Profile (if applicable)

This licence ends when you delete your account or remove the evidence.

**11.3 Restrictions:**
You must NOT:
- Copy, modify, or distribute SilentID's software or content
- Use SilentID's trademarks or logos without permission
- Reverse engineer or decompile the app

---

### 12. DATA PROTECTION & PRIVACY

**12.1 Privacy Policy:**
Your use of SilentID is governed by our **Privacy Policy** (Section 44), which explains:
- What data we collect
- How we use it
- Your rights under UK GDPR

**12.2 Your Rights:**
You have the right to:
- **Access** your data (request a copy)
- **Rectify** inaccurate data
- **Erase** your data (delete your account)
- **Restrict** processing
- **Object** to processing
- **Port** your data to another service

To exercise your rights, contact privacy@silentid.co.uk.

**12.3 Data Retention:**
We retain your data for as long as your account is active. After deletion, most data is deleted within 30 days. Some data (anonymised fraud logs) is retained for up to 7 years for legal compliance.

---

### 13. DISCLAIMERS & LIMITATION OF LIABILITY

**13.1 Service "As Is":**
SilentID is provided **"as is" and "as available"** without warranties of any kind, express or implied, including but not limited to:
- Merchantability
- Fitness for a particular purpose
- Non-infringement
- Accuracy, reliability, or completeness of TrustScores or user data

**13.2 No Guarantee:**
SilentID does NOT guarantee:
- The accuracy or reliability of any user's TrustScore or profile
- That use of SilentID will prevent fraud or scams
- Continuous, uninterrupted, or error-free operation
- That defects will be corrected

**13.3 Limitation of Liability:**
**To the maximum extent permitted by UK law:**

SILENTSALE LTD is NOT liable for:
- Indirect, consequential, incidental, or punitive damages
- Loss of profits, revenue, data, or business opportunities
- Losses arising from third-party reliance on TrustScores
- Losses caused by user error, fraud, or misrepresentation
- Losses caused by internet outages, device failures, or third-party services

**13.4 Maximum Liability:**
SILENTSALE LTD's total liability to you is limited to the lesser of:
- The amount you paid to SilentID in the 12 months before the claim; or
- £100

**13.5 Exceptions:**
Nothing in these Terms excludes liability for:
- Death or personal injury caused by negligence
- Fraud or fraudulent misrepresentation
- Any other liability that cannot be excluded under UK law

---

### 14. TERMINATION

**14.1 Your Right to Terminate:**
You may delete your account at any time via Settings > Account > Delete Account. You have a 30-day grace period to cancel deletion.

**14.2 Our Right to Terminate:**
We may suspend or terminate your account if:
- You violate these Terms
- We detect fraudulent or illegal activity
- We receive a valid legal order
- You pose a risk to other users or the platform

**14.3 Effect of Termination:**
Upon termination:
- Your access to SilentID is immediately revoked
- Your Public Profile is hidden
- Your data is deleted within 30 days (except as required by law)
- Paid subscriptions are non-refundable

---

### 15. DISPUTE RESOLUTION

**15.1 Governing Law:**
These Terms are governed by the laws of **England and Wales**.

**15.2 Jurisdiction:**
You agree to the **exclusive jurisdiction** of the courts of England and Wales for any disputes.

**15.3 Informal Resolution:**
Before filing a legal claim, you agree to attempt informal resolution by contacting legal@silentid.co.uk.

**15.4 No Class Actions:**
You agree to resolve disputes individually, not as part of a class action or representative proceeding.

---

### 16. CHANGES TO TERMS

**16.1 Updates:**
We may update these Terms at any time. Material changes will be communicated via:
- Email notification
- In-app notification
- Website posting

**16.2 Continued Use:**
Continued use of SilentID after changes constitutes acceptance of the new Terms.

**16.3 Disagreement:**
If you do not agree to changes, you must stop using SilentID and delete your account.

---

### 17. GENERAL PROVISIONS

**17.1 Entire Agreement:**
These Terms, together with the Privacy Policy and Cookie Policy, constitute the entire agreement between you and SILENTSALE LTD.

**17.2 Severability:**
If any provision is found invalid, the remaining provisions remain in full effect.

**17.3 No Waiver:**
Failure to enforce any provision does not constitute a waiver of that provision.

**17.4 Assignment:**
You may NOT assign these Terms. We may assign them to a successor or affiliate.

**17.5 Force Majeure:**
We are not liable for delays or failures caused by events beyond our reasonable control (e.g., natural disasters, pandemics, government actions, internet outages).

**17.6 Contact:**
For questions about these Terms, contact:
**SILENTSALE LTD**
Email: legal@silentid.co.uk
Website: www.silentid.co.uk

---

**END OF CONSUMER TERMS OF USE**

---

## SECTION 44: SILENTID PRIVACY POLICY (UK GDPR-ALIGNED)

**Last Updated:** [Insert date]
**Effective Date:** [Insert date]
**Version:** 1.0

This Privacy Policy explains how **SILENTSALE LTD** (Company No. 16457502) ("**SilentID**", "**we**", "**us**", "**our**") collects, uses, stores, and protects your personal data when you use the SilentID service.

---

### 1. INTRODUCTION

**1.1 Our Commitment:**
SilentID is committed to protecting your privacy and complying with the **UK General Data Protection Regulation (UK GDPR)** and the **Data Protection Act 2018**.

**1.2 Data Controller:**
SILENTSALE LTD is the data controller responsible for your personal data.

**1.3 Contact:**
For privacy questions, contact:
**Data Protection Officer**
Email: dpo@silentid.co.uk
Website: www.silentid.co.uk

**1.4 ICO Registration:**
ICO Registration Number: [To be inserted upon registration]

---

### 2. WHAT DATA WE COLLECT

**2.1 Account Information:**
When you create an account, we collect:
- **Email address** (required)
- **Username** (chosen by you, publicly visible)
- **Display name** (e.g., "Sarah M." - publicly visible)
- **Phone number** (optional)
- **Date of Birth** (from identity verification - NOT publicly visible)

**2.2 Authentication Data:**
Depending on your login method:
- **Apple Sign-In:** Apple User ID
- **Google Sign-In:** Google User ID
- **Passkey:** Public key stored on our servers (private key stays on your device)
- **Email OTP:** No additional data (one-time codes are not stored)

**We do NOT store passwords. SilentID is 100% passwordless.**

**2.3 Identity Verification Data (via Stripe):**
When you verify your identity:
- **Stripe Verification Reference ID** (we store ONLY the reference, NOT your ID documents)
- **Verification Status** (Verified, Pending, Failed)
- **Timestamp** of verification

**ID documents and selfies are stored by Stripe, NOT by SilentID.** Stripe's handling of this data is governed by Stripe's privacy policy.

**2.4 Evidence Data:**
If you upload evidence:
- **Email Receipts:** Date, amount, platform, item description, buyer/seller role (NOT full email content)
- **Screenshots:** Image files, OCR-extracted text, integrity scores
- **Public Profile URLs:** Marketplace username, ratings, reviews, join date (scraped from public pages)

**2.5 Device & Usage Data:**
- **Device Information:** Device model, operating system, browser type
- **Device Fingerprint:** Hashed identifier for fraud prevention
- **IP Address:** For security, fraud detection, and geo-location (not exact location)
- **Login History:** Timestamps, device, location (city/country)
- **App Usage:** Features used, screens viewed (anonymous analytics)

**2.6 Payment Data:**
- **Stripe Customer ID** (for subscription billing)
- **Subscription Tier** (Free, Premium, Pro)
- **Payment History** (stored by Stripe, not SilentID)

**We do NOT store your credit card details.** Stripe handles all payment processing.

**2.7 Risk & Safety Data:**
- **RiskSignals:** Fraud detection signals (device patterns, evidence integrity flags)
- **Safety Reports:** Reports you file or reports filed against you (including evidence)

---

### 3. LEGAL BASIS FOR PROCESSING

Under UK GDPR, we must have a lawful basis for processing your personal data. We rely on:

| Data Type | Lawful Basis | Purpose |
|-----------|--------------|---------|
| Account information (email, username) | **Contract** + **Legitimate Interest** | Provide SilentID service, prevent fraud |
| Authentication data | **Contract** | Secure account access |
| Identity verification (Stripe result) | **Legitimate Interest** | Prevent fake accounts, fraud |
| Evidence (receipts, screenshots, profiles) | **Consent** + **Legitimate Interest** | Build TrustScore, fraud prevention |
| Device & usage data | **Legitimate Interest** | Security, fraud detection, service improvement |
| Payment data | **Contract** | Process subscriptions |
| Risk & safety data | **Legitimate Interest** + **Legal Obligation** | Fraud prevention, safety, legal compliance |

**Consent:**
Where we rely on consent (e.g., email inbox scanning), you can withdraw consent at any time via Settings.

---

### 4. HOW WE USE YOUR DATA

**4.1 Service Provision:**
- Create and manage your account
- Calculate your TrustScore
- Display your Public Profile
- Store and display your evidence
- Process subscriptions

**4.2 Security & Fraud Prevention:**
- Detect fake accounts and fraudulent activity
- Monitor for suspicious device patterns
- Verify evidence integrity
- Respond to safety reports

**4.3 Communication:**
- Send account notifications (login alerts, security warnings)
- Send subscription emails (payment confirmations, renewal reminders)
- Respond to support requests
- Send service updates (important changes to Terms or Privacy Policy)

**We do NOT send marketing emails without your explicit consent.**

**4.4 Service Improvement:**
- Analyse usage patterns (anonymous analytics)
- Improve TrustScore algorithms
- Test new features

**4.5 Legal Compliance:**
- Comply with legal obligations (e.g., responding to valid legal orders)
- Enforce our Terms of Use
- Protect our rights and interests

---

### 5. WHO WE SHARE DATA WITH

**5.1 Third-Party Service Providers:**

| Provider | Purpose | Data Shared | Location |
|----------|---------|-------------|----------|
| **Stripe** | Identity verification, payment processing | Email, name, DOB, ID documents (for verification only) | EU/UK |
| **Microsoft Azure** | Database hosting, file storage | All user data (encrypted) | UK |
| **Email Provider** (SendGrid or AWS SES) | Send OTP codes, notifications | Email address | EU |
| **Azure Cognitive Services** | Screenshot OCR, image verification | Screenshot images (no ID documents) | UK/EU |

**5.2 Legal Disclosures:**
We may disclose your data if required by law or in response to:
- Valid court orders or subpoenas
- Law enforcement requests (with proper legal basis)
- Protecting our rights, safety, or property

**5.3 Business Transfers:**
If SILENTSALE LTD is acquired or merged, your data may be transferred to the new owner (you will be notified).

**5.4 We Do NOT:**
- Sell your data to third parties
- Share your data for advertising or marketing purposes
- Provide your data to partner platforms (unless you explicitly request it)

---

### 6. DATA RETENTION

**6.1 Active Accounts:**
We retain your data for as long as your account is active.

**6.2 After Account Deletion:**
- **Most data:** Deleted within **30 days**
- **Anonymised fraud logs:** Retained for **7 years** (UK legal requirement for fraud prevention)
- **Financial records (Stripe):** Retained for **7 years** (UK tax law requirement)

**6.3 Specific Retention Periods:**
- **Authentication logs:** 90 days (active), 2 years (archived)
- **Evidence files:** Deleted 30 days after removal
- **Safety reports:** 7 years (legal compliance)
- **Admin audit logs:** 7 years (immutable, anonymised after account deletion)

---

### 7. YOUR RIGHTS UNDER UK GDPR

**7.1 Right of Access:**
You can request a copy of all personal data we hold about you.

**7.2 Right to Rectification:**
You can correct inaccurate or incomplete data.

**7.3 Right to Erasure ("Right to be Forgotten"):**
You can request deletion of your data. We will delete it within 30 days, except where:
- We have a legal obligation to retain it (e.g., fraud logs, financial records)
- It's needed to defend legal claims

**7.4 Right to Restrict Processing:**
You can ask us to limit how we use your data (e.g., stop using it for certain purposes).

**7.5 Right to Object:**
You can object to processing based on legitimate interest (e.g., fraud detection). We will stop unless we have compelling reasons.

**7.6 Right to Data Portability:**
You can request your data in a machine-readable format (JSON) to transfer to another service.

**7.7 Right to Withdraw Consent:**
If processing is based on consent (e.g., email scanning), you can withdraw consent at any time.

**7.8 How to Exercise Your Rights:**
Email: **privacy@silentid.co.uk**
In-app: **Settings > Privacy > Request My Data**

We will respond within **30 days**.

---

### 8. DATA SECURITY

**8.1 Security Measures:**
We protect your data using:
- **Encryption:** Data encrypted in transit (TLS) and at rest (AES-256)
- **Access Controls:** Role-based access, admin authentication
- **Device Fingerprinting:** Detect unauthorised access
- **Automated Monitoring:** Suspicious activity alerts
- **Regular Security Audits**

**8.2 No Passwords:**
SilentID never stores passwords. Passwordless authentication eliminates the #1 cause of data breaches.

**8.3 Incident Response:**
If a data breach occurs, we will:
- Notify the ICO within **72 hours** (if required by law)
- Notify affected users within **7 days** (if high risk)
- Take immediate action to contain the breach

---

### 9. COOKIES & TRACKING

**9.1 What Cookies We Use:**
SilentID uses **minimal cookies**:
- **Session Cookies:** Keep you logged in (essential, cannot be disabled)
- **Analytics Cookies:** Anonymous usage statistics (optional, can be disabled)

**9.2 No Advertising Cookies:**
We do NOT use advertising or tracking cookies.

**9.3 Managing Cookies:**
You can disable non-essential cookies via Settings > Privacy > Cookie Preferences.

**Full Cookie Policy:** See Section 45.

---

### 10. CHILDREN'S PRIVACY

**10.1 Age Restriction:**
SilentID is **NOT intended for users under 18**. We do not knowingly collect data from children.

**10.2 Parental Discovery:**
If we discover a user is under 18, we will immediately delete their account and data.

---

### 11. INTERNATIONAL TRANSFERS

**11.1 Data Location:**
Your data is stored in **UK and EU data centres** (Microsoft Azure - UK South region).

**11.2 Transfers Outside UK/EU:**
We do NOT routinely transfer data outside the UK/EU. If necessary (e.g., for support services), we ensure:
- **Adequate protection** (UK GDPR-approved mechanisms)
- **Standard Contractual Clauses** with third parties

---

### 12. AUTOMATED DECISION-MAKING

**12.1 TrustScore Calculation:**
Your TrustScore is calculated by **automated algorithms** based on:
- Identity verification status
- Evidence quality and quantity
- Safety reports
- Account behaviour

**12.2 Right to Human Review:**
If you believe your TrustScore is incorrect, you can:
- Appeal via Settings > Appeals
- Request human admin review

**12.3 Risk Signals:**
Automated fraud detection may flag suspicious activity. You can appeal via Settings > Risk Status.

---

### 13. CHANGES TO THIS PRIVACY POLICY

**13.1 Updates:**
We may update this Privacy Policy at any time. Material changes will be communicated via:
- Email notification
- In-app notification
- Website posting

**13.2 Continued Use:**
Continued use of SilentID after changes constitutes acceptance.

---

### 14. COMPLAINTS

**14.1 Contact Us First:**
If you have concerns about how we handle your data, please contact:
**dpo@silentid.co.uk**

**14.2 ICO Complaint:**
If unresolved, you may complain to the **Information Commissioner's Office (ICO)**:
Website: ico.org.uk
Phone: 0303 123 1113
Address: Information Commissioner's Office, Wycliffe House, Water Lane, Wilmslow, Cheshire SK9 5AF

---

### 15. CONTACT

**SILENTSALE LTD**
**Data Protection Officer:** dpo@silentid.co.uk
**Privacy Enquiries:** privacy@silentid.co.uk
**Website:** www.silentid.co.uk

---

**END OF PRIVACY POLICY**

---

## SECTION 45: SILENTID COOKIE & TRACKING POLICY

**Last Updated:** [Insert date]
**Effective Date:** [Insert date]
**Version:** 1.0

This Cookie Policy explains how **SILENTSALE LTD** ("**SilentID**", "**we**", "**us**", "**our**") uses cookies and similar tracking technologies when you use the SilentID mobile app and website.

---

### 1. WHAT ARE COOKIES?

**1.1 Definition:**
Cookies are small text files stored on your device (phone, tablet, computer) when you visit a website or use an app. They help websites remember your preferences and improve your experience.

**1.2 Similar Technologies:**
We also use:
- **Local Storage:** Data stored in your browser or app
- **Session Tokens:** Temporary authentication tokens
- **Device Fingerprints:** Unique device identifiers for security

---

### 2. COOKIES WE USE

**2.1 Essential Cookies (Cannot be Disabled):**
These cookies are necessary for SilentID to function.

| Cookie Name | Purpose | Duration |
|-------------|---------|----------|
| `session_token` | Keep you logged in | 7 days |
| `device_fingerprint` | Detect unauthorised access | Permanent |
| `csrf_token` | Prevent cross-site request forgery attacks | Session |

**2.2 Analytics Cookies (Optional):**
These cookies help us understand how users use SilentID.

| Cookie Name | Purpose | Duration |
|-------------|---------|----------|
| `analytics_id` | Anonymous usage statistics | 2 years |
| `feature_usage` | Track which features are used | 1 year |

**Analytics cookies are:**
- **Anonymous** (not linked to your account)
- **Optional** (can be disabled in Settings)

**2.3 Cookies We Do NOT Use:**
- ❌ Advertising cookies
- ❌ Third-party tracking cookies
- ❌ Social media cookies

---

### 3. HOW WE USE COOKIES

**3.1 Security & Authentication:**
- Keep you logged in securely
- Detect suspicious login attempts
- Prevent fraud and account takeover

**3.2 Service Functionality:**
- Remember your preferences (e.g., language, display settings)
- Store temporary data during your session

**3.3 Analytics & Improvement:**
- Understand how users navigate the app
- Identify features that need improvement
- Measure performance

---

### 4. MANAGING COOKIES

**4.1 Mobile App:**
You can manage cookies via:
**Settings > Privacy > Cookie Preferences**

**4.2 Website:**
You can manage cookies via your browser settings:
- **Chrome:** Settings > Privacy and Security > Cookies
- **Safari:** Preferences > Privacy > Manage Website Data
- **Firefox:** Settings > Privacy & Security > Cookies

**4.3 Disabling Cookies:**
If you disable essential cookies, you will NOT be able to log in or use SilentID.

If you disable analytics cookies, your experience will not be affected (we just won't collect anonymous usage data).

---

### 5. THIRD-PARTY COOKIES

**5.1 Stripe:**
When you make a payment, Stripe may set cookies for fraud prevention and payment processing. These are governed by Stripe's privacy policy.

**5.2 Azure:**
Our hosting provider (Microsoft Azure) may set cookies for performance monitoring. These are governed by Microsoft's privacy policy.

**5.3 No Advertising Networks:**
We do NOT use third-party advertising networks or tracking services.

---

### 6. DATA PROTECTION

**6.1 Cookie Data:**
Cookie data is subject to the same protections as other personal data (see Privacy Policy, Section 44).

**6.2 Encryption:**
Session tokens and authentication cookies are encrypted.

**6.3 Retention:**
Cookies are deleted when they expire or when you log out (for session cookies).

---

### 7. CHANGES TO THIS POLICY

**7.1 Updates:**
We may update this Cookie Policy at any time. Changes will be posted on this page.

**7.2 Notification:**
Material changes will be communicated via email or in-app notification.

---

### 8. CONTACT

For questions about cookies, contact:
**SILENTSALE LTD**
Email: privacy@silentid.co.uk
Website: www.silentid.co.uk

---

**END OF COOKIE POLICY**

---

## SECTION 46: ABOUT SILENTID – ABOUT US / LEGAL IMPRINT

**Last Updated:** [Insert date]

---

### WHO WE ARE

**SilentID** is a passwordless digital trust identity platform that helps people build portable, evidence-based reputations across marketplaces, dating apps, rental platforms, and community groups.

We believe that **honest people should rise, and scammers should fail.**

---

### OUR MISSION

**To create a safer internet** where trust is portable, verifiable, and transparent.

SilentID empowers users to:
- Verify their identity **once** (via Stripe Identity)
- Build a **TrustScore (0-1000)** based on real evidence
- Share their trust profile **everywhere** they trade or interact online

---

### WHAT MAKES US DIFFERENT

**1. 100% Passwordless:**
SilentID **never** uses passwords. We use Apple Sign-In, Google Sign-In, Passkeys, and Email OTP for maximum security.

**2. Privacy-First:**
We **do NOT store** your ID documents or passwords. Identity verification is handled by Stripe, and we store only the verification result.

**3. Evidence-Based Trust:**
TrustScores are built on **real evidence**:
- Email receipts from marketplaces
- Screenshots of reviews and ratings
- Links to your public seller profiles

**4. Bank-Grade Security:**
SilentID is designed with the same security standards as financial institutions.

---

### OUR VALUES

- **Trust:** We are transparent about how TrustScores are calculated.
- **Safety:** We prioritise fraud prevention and user protection.
- **Privacy:** We minimise data collection and protect what we do collect.
- **Fairness:** No pay-to-win. Paid subscriptions do NOT increase TrustScores.

---

### COMPANY INFORMATION

**Legal Name:** SILENTSALE LTD
**Company Number:** 16457502
**Registered in:** England & Wales
**Registered Office:** [Insert registered address]
**Trading As:** SilentID
**VAT Number:** [To be inserted if VAT-registered]

**Contact:**
Website: www.silentid.co.uk
Email: hello@silentid.co.uk
Support: support@silentid.co.uk
Legal: legal@silentid.co.uk
Privacy: dpo@silentid.co.uk

---

### REGULATORY COMPLIANCE

**Data Protection:**
ICO Registration Number: [To be inserted]
We comply with UK GDPR and the Data Protection Act 2018.

**Payment Processing:**
Payments are processed by Stripe, a regulated payment service provider. SILENTSALE LTD is NOT a payment service provider.

---

### WHAT WE ARE NOT

SilentID is **NOT**:
- A credit reference agency
- A background check service
- A financial institution or bank
- An insurance provider
- A marketplace or transaction platform
- A guarantee of trustworthiness

**SilentID provides trust signals to help you make safer decisions. We do not guarantee outcomes or verify accuracy of third-party information.**

---

### OUR TEAM

SilentID is built by a small team in the UK dedicated to making the internet safer for everyone.

We're always looking for talented people to join us. If you're passionate about trust, security, and user privacy, get in touch: careers@silentid.co.uk

---

### GET IN TOUCH

**Support:**
If you need help, visit our Help Center or email support@silentid.co.uk

**Press & Media:**
For press enquiries, email press@silentid.co.uk

**Partnerships:**
Interested in integrating SilentID into your platform? Email partnerships@silentid.co.uk

**Legal:**
For legal matters, email legal@silentid.co.uk

---

### LEGAL DOCUMENTS

- **Terms of Use:** Section 43
- **Privacy Policy:** Section 44
- **Cookie Policy:** Section 45

---

### COPYRIGHT

© 2025 SILENTSALE LTD. All rights reserved.

**SilentID**, the SilentID logo, and **"Honest people rise. Scammers fail."** are trademarks of SILENTSALE LTD.

---

**END OF ABOUT US / LEGAL IMPRINT**

---

## SECTION 47: SILENTID DIGITAL TRUST PASSPORT — PUBLIC PROFILE & STAR DISPLAY RULES

### 47.1 Purpose

Define how SilentID publicly displays verified marketplace ratings (stars) and trust credentials on user profiles, ensuring:
- Factual accuracy (never inflate, estimate, or round up stars)
- Legal safety (display facts, not editorial judgments)
- User control (users choose what's public)
- Platform resilience (handle platform HTML changes, account issues, edge cases)
- Privacy protection (TrustScore calculation kept private, only stars shown)

**Core Philosophy:** SilentID's public profile is a **"Digital Trust Passport"** — a verifiable, portable credential showing real-world marketplace performance.

---

### 47.2 Core Principle: Facts vs. Judgments

**Public = Verified Facts (Low Legal Risk)**
- ✅ Star ratings from verified marketplace profiles (e.g., "4.9 ★ on Vinted")
- ✅ Review counts (e.g., "327 reviews")
- ✅ Account age (e.g., "Member since Jan 2023")
- ✅ Identity verification status (e.g., "Identity Verified via Stripe")

**Private = SilentID Calculations (Higher Legal Risk)**
- ❌ TrustScore (0-1000) — Internal calculation, NOT shown publicly
- ❌ URS (Unified Reputation Score) — Internal weighted average, NOT shown publicly
- ❌ Risk signals or fraud flags — Internal only

**Why?**
- **Factual reporting** (displaying stars from Vinted) = minimal legal exposure
- **Editorial judgment** (saying "this person is trustworthy") = defamation risk
- By keeping TrustScore **private** (user sees it, public doesn't), SilentID avoids making public trust judgments

---

### 47.3 Digital Trust Passport — Public Profile Specification

**Public Profile URL:**
```
silentid.co.uk/u/{username}
```

**Example:**
```
silentid.co.uk/u/sarahtrusted
```

**Visual Layout:**

```
┌─────────────────────────────────────────────────────┐
│  [SilentID Logo]          DIGITAL TRUST PASSPORT    │
├─────────────────────────────────────────────────────┤
│                                                     │
│   [Avatar]    Sarah M.                              │
│               @sarahtrusted                         │
│               ✅ Identity Verified                  │
│               🌍 Active on 3 platforms              │
│               📅 Member since Jan 2024              │
│                                                     │
├─────────────────────────────────────────────────────┤
│  VERIFIED MARKETPLACE RATINGS                       │
├─────────────────────────────────────────────────────┤
│                                                     │
│  🛍️ Vinted                                          │
│     ★★★★★ 4.9  (327 reviews)                        │
│     Last updated: 2 days ago                        │
│     [Level 3 Verified ✓]                            │
│                                                     │
│  📦 eBay                                             │
│     ★★★★★ 99.2% positive  (542 ratings)             │
│     Last updated: 5 days ago                        │
│     [Level 3 Verified ✓]                            │
│                                                     │
│  👗 Depop                                            │
│     ★★★★★ 5.0  (89 reviews)                         │
│     Last updated: 1 day ago                         │
│     [Level 3 Verified ✓]                            │
│                                                     │
├─────────────────────────────────────────────────────┤
│  VERIFICATION BADGES                                │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ✅ Identity Verified (Stripe)                      │
│  📧 Email Verified                                  │
│  🔗 3 Platforms Connected                           │
│  ⏱️ Account Active 287 days                        │
│                                                     │
├─────────────────────────────────────────────────────┤
│  [QR Code]                                          │
│  Scan to verify this Digital Trust Passport        │
└─────────────────────────────────────────────────────┘
```

---

### 47.4 What is Shown Publicly

**Always Shown (Default):**
1. **Display Name:** "Sarah M." (first name + initial, never full surname)
2. **Username:** "@sarahtrusted"
3. **Identity Verification Badge:** "✅ Identity Verified" (if completed)
4. **Star Ratings from Verified Platforms:**
   - Platform name (Vinted, eBay, Depop, etc.)
   - Star rating (exact, e.g., "4.9 ★" or "99.2% positive")
   - Review/rating count
   - Freshness indicator ("Last updated: X days ago")
   - Level 3 verification badge
5. **Account Age:** "Member since [Month Year]" or "Active for X days"
6. **Platform Count:** "Active on X platforms"
7. **QR Code:** For in-person verification

**Optional (User Can Enable/Disable in Settings):**
- Profile photo/avatar
- Bio text (max 160 characters)
- Location (city/region only, e.g., "London, UK" — never full address)

---

### 47.5 What is Never Shown Publicly

**Absolutely Private (Never Displayed):**
1. **TrustScore (0-1000):** Internal calculation, user sees it in private dashboard
2. **URS (Unified Reputation Score):** Internal weighted average
3. **Evidence Vault Contents:** Screenshots, receipts, documents
4. **Email Receipts:** Transaction summaries
5. **Risk Signals or Fraud Flags:** Internal risk data
6. **Full Legal Name:** Only first name + initial shown
7. **Date of Birth:** Never displayed
8. **Email Address or Phone Number:** Never displayed
9. **Home Address:** Never displayed (city/region at most, if user opts in)
10. **Device IDs or IP Addresses:** Never displayed

**Why TrustScore is Private:**
- **Legal Protection:** Public TrustScores = editorial judgment = potential defamation claims
- **User Control:** Users share verified facts (stars), not SilentID's opinion
- **Platform Neutrality:** Stars come from external platforms (Vinted, eBay), not SilentID
- **Privacy:** TrustScore may include sensitive behavior patterns

---

### 47.6 Private Dashboard — User's View

**What User Sees (Logged In):**

```
┌─────────────────────────────────────────────────────┐
│  YOUR SILENTID DASHBOARD                            │
├─────────────────────────────────────────────────────┤
│                                                     │
│  YOUR TRUSTSCORE (PRIVATE)                          │
│  ████████████████████░░░ 847 / 1000                 │
│  Very High Trust                                    │
│                                                     │
│  [View Breakdown]  [Improve Score]                  │
│                                                     │
├─────────────────────────────────────────────────────┤
│  WHAT OTHERS SEE (Public Profile Preview)          │
├─────────────────────────────────────────────────────┤
│                                                     │
│  [Public Profile Card - Same as 47.3]               │
│                                                     │
│  Note: Your TrustScore (847) is PRIVATE.            │
│  Only star ratings from verified platforms are      │
│  shown publicly.                                    │
│                                                     │
├─────────────────────────────────────────────────────┤
│  [Share Your Passport]  [Edit Visibility]           │
└─────────────────────────────────────────────────────┘
```

**Transparency Message (Shown to User):**
> "Your TrustScore (847) is **private** — only you can see it. Your public profile shows your **verified star ratings** from marketplaces (Vinted, eBay, etc.). This protects your privacy and reduces legal risk."

---

### 47.7 Star Rating Display Rules

**Accuracy Requirements:**

1. **Never Round Up:**
   - Actual rating: 4.87 → Display: "4.9 ★" (rounded to 1 decimal)
   - Actual rating: 4.84 → Display: "4.8 ★" (NOT 4.9)
   - Actual rating: 4.00 → Display: "4.0 ★" (show decimal even if zero)

2. **Never Estimate:**
   - If platform rating unavailable → Show "Rating unavailable" (NOT "~4.5 ★")
   - If scraping fails → Show "Last known: 4.9 ★ (as of [date])"

3. **Never Inflate:**
   - If user has 4.9★ on Vinted → Display exactly "4.9 ★"
   - Do NOT aggregate across platforms into a single "average" star rating

4. **Show Freshness:**
   - "Last updated: 2 days ago" (scraped recently)
   - "Last updated: 14 days ago" (older, but still valid)
   - "Last updated: 90+ days ago" (stale, user should re-verify)

5. **Platform-Specific Formats:**
   - **Vinted:** "4.9 ★ (327 reviews)"
   - **eBay:** "99.2% positive (542 ratings)"
   - **Depop:** "5.0 ★ (89 reviews)"
   - **Etsy:** "4.8 ★ (1,204 sales)"
   - **Amazon:** "4.6 ★ (89 ratings)" (future)

**Visual Design Rules:**
- Use exact star count: ★★★★★ (5 stars), ★★★★☆ (4 stars), etc.
- Color: Gold `#FFD700` for filled stars, Gray `#DADADA` for empty stars
- Font: Inter Semibold, 18-20pt
- Never use half-star icons (round to nearest 0.1)

---

### 47.8 Digital Passport Visual Design Requirements

**Brand Identity:**
- Must feel like a **real passport** — official, trustworthy, verifiable
- Color scheme: Royal Purple `#5A3EB8` for header, white background, neutral grays
- Typography: Inter (consistent with SilentID brand)
- Layout: Clean, structured, scannable

**Header:**
```
┌─────────────────────────────────────────────────────┐
│  [SilentID Logo]          DIGITAL TRUST PASSPORT    │
└─────────────────────────────────────────────────────┘
```
- "DIGITAL TRUST PASSPORT" in bold, uppercase
- Royal purple background `#5A3EB8`, white text

**Profile Section:**
- Avatar: 80×80px circular, top-left
- Name: Inter Bold, 24pt, black
- Username: Inter Regular, 16pt, gray
- Badges: Small icons with text labels (✅, 📧, 🌍)

**Marketplace Ratings Section:**
- Each platform: Card-style layout
- Platform icon/logo (if available)
- Star rating: Large, gold stars
- Review count: Gray text below stars
- Freshness indicator: Small text, gray
- Level 3 Verified badge: Green checkmark

**Verification Badges Section:**
- List format, each badge on separate line
- Icon + text label
- Gray background for secondary badges

**QR Code:**
- 200×200px, bottom-center
- Label: "Scan to verify this Digital Trust Passport"
- QR encodes: `https://silentid.co.uk/u/{username}`

**Responsive Design:**
- Mobile: Single column, full-width cards
- Desktop: Two-column layout (profile left, ratings right)

---

### 47.9 QR Code Passport Feature

**Purpose:** Enable in-person trust verification (meetups, rental viewings, local trades)

**How It Works:**
1. User opens SilentID app → "Share Profile" → "Show QR Code"
2. QR code displayed full-screen
3. Other person scans with phone camera
4. Redirects to public profile: `silentid.co.uk/u/{username}`
5. Scanner sees Digital Trust Passport (star ratings, verification badges)

**Security:**
- QR code is **static** (encodes public profile URL only)
- No personal data embedded in QR code
- User can disable public profile to invalidate QR code
- QR code regenerates if username changes

**Use Cases:**
- Marketplace meetups (Vinted, Facebook Marketplace)
- Rental viewings (landlord verifies tenant, or vice versa)
- Community group introductions
- Dating app pre-meet verification (optional)

**Design:**
- Full-screen QR code
- Username displayed below: "@sarahtrusted"
- Star summary: "4.9 ★ across 3 platforms"
- Instruction text: "Scan to view my verified marketplace ratings"

---

### 47.10 Marketing Language — Keep Your Stars

**Tagline:** "Your stars. Your proof. Your passport."

**User Messaging:**
> "You've earned those 5-star reviews on Vinted, eBay, and Depop. Now carry them with you — everywhere you trade online."

> "Your Digital Trust Passport shows your real marketplace performance. No fluff. Just facts."

> "SilentID doesn't give you a score — it shows the world the scores you've already earned."

**Public Profile Sharing Copy:**
- "Share your verified marketplace ratings"
- "Let others see your 4.9★ reputation before you meet"
- "Prove you're trustworthy — with receipts."

**In-App Prompts:**
- "Connect your Vinted account to show your 4.9★ rating publicly"
- "Your 327 5-star reviews on eBay? Show them off."
- "Make your marketplace success portable."

---

### 47.11 Legal Positioning for Public Star Display

**Why This is Legally Safe:**

1. **Factual Reporting (Not Editorial):**
   - SilentID displays **facts** (e.g., "4.9 ★ on Vinted, verified via Level 3 ownership proof")
   - SilentID does NOT say "This person is trustworthy" (editorial judgment)
   - Legal precedent: Displaying factual ratings from public sources = protected speech

2. **User Consent:**
   - User explicitly connects their marketplace accounts
   - User chooses to make ratings public
   - User can revoke public display anytime

3. **Source Attribution:**
   - Each rating clearly labeled with platform (Vinted, eBay, etc.)
   - "Level 3 Verified" badge proves ownership
   - Freshness indicator shows data recency

4. **No Aggregation into Single Score:**
   - SilentID does NOT combine stars into one "SilentID Rating"
   - Each platform shown separately
   - User's internal TrustScore kept **private** (not shown publicly)

5. **Defamation-Safe Language:**
   - Never say "scammer," "fraudster," "untrustworthy"
   - Always use neutral, factual language: "Multiple reports received" (NOT "This person is dangerous")

**Legal Disclaimer (Displayed on Public Profile):**
> "Star ratings are sourced from verified marketplace accounts and displayed factually. SilentID does not endorse, guarantee, or make judgments about users. Use marketplace ratings as one factor in your decision-making."

---

### 47.12 Integration with Partner Marketplaces

**Purpose:** Enable partner platforms to request and display SilentID Digital Trust Passports for their users.

**Integration Model:**

**Option A: Partner API Access (Recommended)**
- Partner platforms use Partner TrustSignal API (Section 22)
- Partner requests: `GET /api/partner/v1/passport/{username}`
- Response includes:
  - Public profile data (display name, username, verification badges)
  - Verified star ratings from external platforms
  - QR code link
  - Profile freshness indicator

**Option B: Embeddable Widget (Future)**
- Partner platforms embed SilentID widget on user profiles
- Widget displays Digital Trust Passport (read-only)
- Updates automatically when user's ratings change
- Requires partner API key and user consent

**Option C: Deep Link Integration**
- Partner platforms link to SilentID public profile: `silentid.co.uk/u/{username}`
- User taps link → Opens SilentID web view or app
- Seamless for users already on SilentID

**Data Shared with Partners:**
✅ **CAN Share (with user consent):**
- Display name, username
- Identity verification status
- Star ratings from verified platforms
- Review counts
- Account age
- Platform count

❌ **CANNOT Share:**
- TrustScore (private)
- URS (internal calculation)
- Evidence Vault contents
- Risk signals
- Email address or phone number
- Full legal name

**User Control:**
- User must explicitly enable "Share with [Partner Name]" in SilentID settings
- User can revoke access anytime
- User sees audit log of which partners accessed their passport

**Partner Branding:**
- Partner platforms can customize widget appearance (colors, fonts) within brand guidelines
- SilentID logo and "Verified via SilentID" badge must remain visible
- No white-labeling (SilentID branding must be present)

**Rate Limiting (Partner API):**
- 100 requests/minute per partner
- 10,000 requests/day per partner
- Burst allowance: 150 requests/minute for 10 seconds

**Legal Agreement Required:**
- Partner must sign Data Processing Agreement (DPA)
- Partner must respect user privacy (no scraping or unauthorized use)
- Partner must display SilentID attribution
- Violation = API key revoked

---

### 47.13 Edge Case Handling — Platform HTML Changes

**Problem:** External marketplace (e.g., Vinted) changes their website HTML structure, breaking SilentID's scraper.

**5-Layer Resilience System:**

**Layer 1: Selector Redundancy**
- Store **3-5 fallback CSS selectors** for each data point
- Example for Vinted star rating:
  - Primary: `.user-rating .stars`
  - Fallback 1: `[data-testid="user-rating"]`
  - Fallback 2: `.profile-stats .rating-value`
  - Fallback 3: Text extraction from `<span>` containing "★"
- If primary fails → Try fallback selectors sequentially

**Layer 2: Platform Health Monitoring**
- Canary profiles: 5-10 known-good test accounts per platform
- Check canaries every 6 hours
- If >50% of canaries fail → Platform HTML likely changed
- Trigger alert to engineering team

**Layer 3: Graceful Degradation**
- If scraping fails → Don't delete existing star rating
- Display: "Last known: 4.9 ★ (as of [date])"
- Add freshness warning: "⚠️ Rating not recently updated (90+ days)"
- User sees stale data, but profile doesn't go blank

**Layer 4: User Notification**
- If scraping fails for 14+ days → Email user:
  > "We couldn't update your Vinted rating. Please re-verify your profile or contact support."
- Provide "Re-verify" button in app

**Layer 5: Engineering Fix SLA**
- **Critical platforms** (Vinted, eBay, Depop): Fix within 24 hours
- **Secondary platforms** (Etsy, Poshmark): Fix within 72 hours
- **Niche platforms** (local marketplaces): Fix within 7 days

**Fallback: Manual Admin Override**
- If automated scraping broken, admin can manually enter star rating
- Requires: Screenshot proof from user + admin verification
- Marked as "Manually verified" with timestamp

---

### 47.14 Edge Case Handling — Account Hacked and Reviews Deleted

**Problem:** User's marketplace account (e.g., Vinted) is hacked. Hacker deletes all reviews, tanking star rating from 4.9★ to 0★. SilentID scrapes the compromised profile, updating user's passport to show "0★" or "No rating."

**Protection System:**

**Detection: Anomaly Detection**
- Monitor for sudden, drastic rating changes:
  - Rating drops by >1.0 stars in <7 days
  - Review count drops by >50% in <7 days
  - Account suspension detected
- If anomaly detected → **Don't auto-update star rating**

**Action: Freeze & Investigate**
1. Freeze star rating at last known good value
2. Add warning badge: "⚠️ Rating under review (unusual activity detected)"
3. Email user:
   > "We noticed unusual changes to your Vinted account (rating dropped from 4.9★ to 0★). This may indicate a security issue. Please verify your account and contact support if needed."

**User Recovery Options:**
1. **User confirms account compromised:**
   - User files report with SilentID support
   - Provides proof of account recovery (e.g., marketplace support email)
   - SilentID temporarily displays: "Rating unavailable (account recovery in progress)"
   - After recovery confirmed → Re-scrape profile

2. **User confirms changes are legitimate:**
   - User clicks "These changes are correct"
   - SilentID updates star rating to new value
   - Logs user confirmation for audit trail

**Grace Period:**
- If user doesn't respond within 14 days → SilentID updates rating to new value (but flags as "Recently changed" for 60 days)
- If user responds within 14 days → Rating frozen until resolved

**Historical Baseline Protection:**
- Store **12 months of rating snapshots** (weekly)
- If current rating is statistical outlier (>2 standard deviations from historical average) → Trigger anomaly detection
- Example: User had 4.8-4.9★ for 10 months, suddenly 0★ → Likely fraud/hack, not legitimate change

---

### 47.15 Edge Case Handling — Shared Device Between Legitimate Users

**Problem:** Two legitimate users (e.g., housemates, siblings, business partners) share the same device. SilentID's fraud detection flags them as duplicate accounts due to matching device fingerprints.

**Solution: Household Declaration**

**User Flow:**
1. User A creates SilentID account from Device X
2. User B tries to create account from same Device X
3. System detects duplicate device fingerprint
4. Instead of blocking, show prompt:
   > "This device is already associated with another SilentID account (@user-a). Do you share this device with someone?"
   >
   > [Yes, we share this device] [No, this is my device only]

**If "Yes, we share this device":**
- Allow account creation
- Link both accounts with "Household" flag
- Store relationship: Device X → User A (primary), User B (secondary, household member)
- Both users can use Device X without fraud flags

**Fraud Prevention (Household Model):**
- **Limit: Max 3 accounts per device** (reasonable for household)
- **Cross-check:** If User A and User B mutually verify each other → Flag for admin review (possible collusion)
- **Behavioral monitoring:** If User A and User B always log in at same times, upload evidence simultaneously → Flag for review
- **Legitimacy indicators:**
  - Different email providers (user-a@gmail.com vs user-b@outlook.com) = more legitimate
  - Different identity verification IDs (different people in Stripe) = legitimate
  - Same identity verification ID (same person) = fraud

**Admin Review Trigger:**
- If 2+ household accounts:
  - Mutually verify each other's transactions
  - Both have high TrustScores (>800)
  - Both actively trade on same platforms
- → Flag for admin review to confirm not collusion ring

**Transparency:**
- User sees in Settings: "Shared Device: This device is also used by @user-b (household member)"
- User can report "I no longer share this device" → Unlink accounts

---

### 47.16 Edge Case Handling — Unfair Platform Suspension

**Problem:** User is unfairly suspended from marketplace (e.g., Vinted) due to false report or platform error. SilentID scrapes the profile and sees "Account suspended," potentially displaying this on public passport.

**Protection System:**

**Detection:**
- Scraper detects account suspension indicators:
  - Profile shows "This account has been suspended"
  - Profile is no longer accessible (404 error)
  - Star rating/reviews hidden by platform

**Action: Isolation (Don't Propagate Suspension to SilentID):**
1. **Don't auto-update star rating to "Suspended"**
2. Keep last known good star rating displayed
3. Add neutral note: "Profile verification temporarily unavailable"
4. **Do NOT display**: "Account suspended" (assumes guilt)

**User Notification:**
- Email user:
  > "We couldn't access your Vinted profile during our recent verification check. If your account has been suspended or restricted, you can provide proof of resolution to restore full verification."

**User Response Options:**

**Option A: User confirms suspension is legitimate:**
- User acknowledges: "Yes, my account was suspended"
- SilentID removes Vinted rating from public passport
- Other platforms (eBay, Depop) remain visible
- User's TrustScore recalculated without Vinted data

**Option B: User disputes suspension (unfair):**
- User provides proof of appeal/resolution (e.g., marketplace support email)
- SilentID temporarily marks Vinted as "Under dispute"
- If user successfully appeals and account restored → SilentID re-verifies profile
- If appeal denied → SilentID removes Vinted rating

**Option C: User doesn't respond:**
- After 60 days of profile inaccessibility → SilentID auto-removes Vinted rating
- User notified: "Vinted verification removed due to prolonged unavailability"

**Multi-Platform Resilience:**
- If user has **3+ verified platforms**, loss of 1 platform (Vinted) has minimal impact
- Example: User loses Vinted (4.9★) but keeps eBay (99% positive), Depop (5.0★), Etsy (4.8★)
- Public passport still shows strong ratings
- **This is why multi-platform verification is critical** — one bad platform doesn't tank entire reputation

**Grace Period:**
- **60 days** from first detection of suspension
- During grace period: Last known rating displayed with note: "Verification in progress"
- After 60 days: Rating removed if still inaccessible

---

### 47.17 Edge Case Design Principles

**5 Core Principles for Handling Edge Cases:**

1. **Assume Innocence First:**
   - Don't assume account issues = user fraud
   - Could be platform error, hack, or legitimate dispute
   - Give user benefit of doubt + chance to explain

2. **Preserve Context, Don't Blank Data:**
   - If rating unavailable → Show "Last known: 4.9 ★ (as of [date])"
   - Don't delete historical data
   - Don't display "0★" or "No rating" unless confirmed accurate

3. **Multi-Platform Resilience:**
   - Encourage users to verify 3+ platforms
   - Loss of 1 platform shouldn't destroy entire passport
   - Diversification = robustness

4. **Transparent Communication:**
   - Always tell user what happened: "Vinted profile unavailable"
   - Explain impact: "Your Vinted rating is temporarily hidden"
   - Provide action steps: "Re-verify your account" or "Contact support"

5. **Manual Override Available:**
   - Admin can manually adjust ratings with justification
   - User can appeal automated decisions
   - Human judgment available for complex cases

---

### 47.18 Integration with Existing Sections

**Section 47 connects with:**

**Section 3 (System Overview):**
- Digital Trust Passport is the **Public Profile Layer**
- Star ratings sourced from Level 3 verified profiles (Section 3)
- TrustScore remains private (internal calculation), stars shown publicly

**Section 5 (Core Features - Level 3 Verification):**
- Only Level 3 verified profiles contribute stars to public passport
- Token-in-Bio and Share-Intent methods ensure ownership
- Ownership locking prevents profile impersonation

**Section 5 (URS - Unified Reputation Score):**
- URS calculates weighted average of star ratings (0-200 points)
- URS is **private** (used in TrustScore calculation)
- Public passport shows **raw stars** from each platform, NOT aggregated URS

**Section 22 (Partner TrustSignal API):**
- Partner platforms can request public passport data via API
- Section 47.12 defines integration model and data sharing rules
- User consent required for partner access

**Section 23 (QR Trust Passport System):**
- QR code encodes public profile URL (silentid.co.uk/u/{username})
- Section 47.9 defines QR code visual design and use cases
- QR code displays Digital Trust Passport when scanned

**Section 26 (Evidence Integrity Engine):**
- Evidence Vault contributes max 15% of TrustScore (45 points)
- Vault evidence **not shown publicly** (only stars from verified platforms)
- Reinforcement-only rule applies (vault matches verified behavior)

**Section 39 (UI Navigation Rules):**
- "Profile" tab in bottom navigation shows user's private TrustScore dashboard
- "Share Profile" option generates QR code and public profile link
- Public profile preview shown to user before sharing

**Section 40 (UI Info Points):**
- Info point (ⓘ) next to "Digital Trust Passport" explains: "Your verified marketplace ratings shown publicly. Your TrustScore is private."
- Info point next to star ratings explains: "Stars sourced from Level 3 verified profiles. Updated weekly."

---

### 47.19 Summary

**What Section 47 Defines:**

1. **Digital Trust Passport:** A passport-like public profile showing verified marketplace star ratings
2. **Facts vs. Judgments:** Public = facts (stars), Private = calculations (TrustScore)
3. **Star Display Rules:** Accuracy requirements (never round up, never estimate, show freshness)
4. **Visual Design:** Passport-inspired layout with header, star ratings, verification badges, QR code
5. **QR Code Feature:** In-person verification for meetups and local trades
6. **Legal Positioning:** Factual reporting (low risk) vs. editorial judgment (high risk)
7. **Partner Integration:** API access for partner platforms to display passports
8. **Edge Case Handling:** Platform HTML changes, account hacks, shared devices, unfair suspensions
9. **Integration:** Connects with Level 3 Verification, URS, Partner API, QR Passport, UI systems

**Key Takeaway:**
SilentID's Digital Trust Passport is a **portable, verifiable credential** that displays users' real-world marketplace performance (star ratings) while keeping internal trust calculations (TrustScore, URS) **private** for legal protection and user privacy.

---

**END OF SECTION 47**

---

# SECTION 48: MODULAR PLATFORM CONFIGURATION SYSTEM

-----

## 48.1 Purpose

Make platform scraping configurable rather than hardcoded. When a marketplace changes their HTML structure, admin updates a configuration file instead of deploying new code. This dramatically reduces recovery time from hours or days to minutes.

-----

## 48.2 The Problem with Hardcoded Scraping

**Current approach in most systems:**

Platform logic is embedded in code. Each platform has a dedicated scraper class. Selectors are hardcoded as strings in code files. When Vinted changes CSS classes, developers must modify code, test changes, deploy to staging, test again, and deploy to production. Recovery time is 6 to 12 hours minimum. Requires developer intervention every time.

**This creates risk.**

Platform changes happen without warning. Changes can occur during weekends or holidays. One platform change can break thousands of verifications. User trust erodes when profiles show stale data or errors.

-----

## 48.3 Solution: Configuration-Driven Platform System

**Core concept:**

Store all platform-specific logic in database configuration rather than code. Each platform has a configuration record defining selectors, extraction rules, rating formats, and verification methods. When a platform changes, admin updates the configuration through admin dashboard. Changes take effect immediately without code deployment.

-----

## 48.4 Platform Configuration Schema

**Database Table: PlatformConfigurations**

Store one record per platform with the following fields.

**Platform Identifier**

Platform name such as Vinted or eBay or Depop or Etsy or Facebook Marketplace. Platform ID as unique identifier. Status as active or deprecated or maintenance or disabled.

**Base Configuration**

Platform base URL pattern for profile pages. Example pattern for Vinted is http://vinted.co.uk/member/{username} or http://vinted.com/member/{username}. Platform display name for UI showing as Vinted or eBay. Platform logo URL for display. Platform colour hex code for badges and UI elements.

**Scraping Configuration**

This is the critical section that makes the system modular.

**Selector Sets with Priority**

Each data point such as rating or review count or join date or username has multiple selector sets ordered by priority.

For rating extraction, define primary selector as the first choice such as `div.rating-stars > span.score`. Define fallback selector 1 as the second choice such as data attribute with `data-testid="user-rating"`. Define fallback selector 2 as the third choice such as XPath expression `//div[contains(@class, 'rating')]//span[1]`. Define fallback selector 3 as the fourth choice using regex pattern on page text `(\d\.\d)\s*stars?`. Define fallback selector 4 as the fifth choice using JSON-LD structured data extraction if platform provides it.

For review count extraction, define primary selector such as `span.review-count`. Define fallback selectors using similar multi-layer approach.

For join date extraction, define primary selector such as `div.member-since > time`. Define fallback selectors using similar approach.

For username extraction, define primary selector such as `h1.username`. Define fallback selectors using similar approach.

**Extraction Rules**

Define how to parse extracted text into usable data.

For rating scale, specify whether platform uses 1 to 5 stars or 0 to 100 percent or other scale. Define conversion formula to normalize to 0 to 100 scale for URS calculation.

For review count parsing, define regex pattern to extract number from text such as extracting 487 from "487 reviews" or "487 total ratings".

For date parsing, define expected date format such as ISO 8601 or DD/MM/YYYY or relative dates like "Member for 3 years".

For username normalization, define rules such as remove @ symbol or lowercase or trim whitespace.

**Validation Rules**

Define sanity checks for extracted data.

For rating validation, rating must be between 0 and maximum for platform such as 5.0 for star systems. Flag as suspicious if rating is exactly 5.0 with fewer than 10 reviews suggesting fake or new account.

For review count validation, review count must be non-negative integer. Flag as suspicious if count drops by more than 30 percent between checks suggesting deleted reviews or hack.

For join date validation, join date cannot be in the future. Join date cannot change by more than 7 days between checks as platform might adjust dates slightly. Flag if join date resets to recent date suggesting account recreated or hacked.

**Platform-Specific Features**

Each platform has unique characteristics that configuration must capture.

Rate limiting configuration defines requests per minute allowed such as 10 for Vinted or 20 for eBay. Define backoff strategy when rate limited such as exponential backoff or fixed delay.

Authentication requirements define whether scraping requires login such as some Facebook Marketplace profiles require login. Define whether platform allows public scraping or requires API key.

Verification method defines how user proves ownership. Token-in-bio platforms like Vinted and eBay and Depop allow users to add token to bio text. Share-intent platforms like Facebook allow share button verification. API-based platforms like eBay provide official verification API.

-----

## 48.5 Configuration Management Interface

**Admin Dashboard: Platform Configuration Manager**

Location is `admin.silentid.co.uk/platforms/config`.

**List View**

Display all configured platforms with platform name and logo, current status as active or maintenance or disabled, last successful scrape timestamp, current failure rate as percentage, selector version number, and quick actions to edit or test or disable.

**Edit Platform Configuration**

Click edit on any platform to open configuration editor.

**Selector Editor Interface**

For each data point such as rating or reviews or join date, display current selectors in priority order showing selector 1 primary as the main selector with success rate percentage, selector 2 fallback showing alternate selector with success rate percentage, and similar for additional fallback selectors.

Provide add new selector button to insert additional fallback. Provide test selector button to test against live profiles. Provide reorder buttons to change priority. Provide delete button to remove selector.

**Real-Time Selector Testing**

Admin enters test profile URLs such as 3 to 5 known working profiles. System attempts extraction using each selector in priority order. Display results showing which selector succeeded, what data was extracted, and extraction time in milliseconds. Colour-code results as green for successful extraction, yellow for extracted but suspicious value, and red for extraction failed.

Admin can immediately see if new selectors work before saving configuration.

**Version Control**

Each configuration change creates new version. Store complete history of all selector changes with change timestamp, admin who made change, reason for change as free text, and rollback capability to previous version.

If new selectors break more than current selectors, admin rolls back to previous version with one click.

-----

## 48.6 Automatic Selector Rotation

**When Primary Selector Fails**

System automatically tries fallback selectors in priority order. If primary selector fails but fallback 2 succeeds, system logs the failure of primary and success of fallback. If fallback succeeds for more than 50 percent of attempts over 24 hours, system sends alert to admin suggesting primary selector may be broken. Admin reviews and potentially promotes fallback to primary position.

**Success Rate Tracking**

Track success rate per selector over rolling 7-day window. Display in admin dashboard as percentage. Primary selector with success rate below 80 percent triggers warning. Primary selector with success rate below 50 percent triggers critical alert and automatic investigation.

-----

## 48.7 Platform Health Monitoring with Configuration

**Canary Profile System**

For each platform, maintain list of 10 to 20 canary profiles. These are real profiles with known expected values. Store expected values in configuration such as expected rating of 4.9, expected review count of 487, expected username, and expected join date.

**Automated Health Checks**

Every 6 hours, scrape all canary profiles for each platform. Compare extracted values to expected values. Calculate match percentage as number of successful matches divided by total canaries.

Health status determined by match percentage. Healthy is 90 to 100 percent matches. Degraded is 70 to 89 percent matches triggering warning to admins. Down is below 70 percent matches triggering critical alert and auto-disable scraping. Maintenance is manually set by admin when updating configuration.

**Automatic Recovery Attempt**

When platform status becomes degraded, system automatically attempts recovery. Try each fallback selector in sequence against canary profiles. If any fallback selector achieves more than 90 percent success rate, temporarily promote that selector to primary. Alert admin of automatic promotion. Continue monitoring to ensure promoted selector remains stable.

-----

## 48.8 Configuration Deployment Process

**When Admin Updates Configuration**

Admin edits selectors or extraction rules in dashboard. Admin clicks save configuration. System validates configuration structure ensuring all required fields present, selectors have valid CSS or XPath syntax, and extraction rules have valid regex patterns.

If validation passes, system creates new configuration version, deploys immediately to scraping system with no code deployment required, and begins health check using canary profiles.

If canary health check shows more than 90 percent success rate, configuration is marked as verified and becomes active. If canary health check shows less than 90 percent success rate, system alerts admin of potential issue and offers rollback option but does not auto-rollback to allow admin investigation.

**Staged Rollout Option**

For major selector changes, admin can enable staged rollout. New selectors apply to 10 percent of scraping requests for first hour. If success rate remains above 85 percent, expand to 50 percent for next 2 hours. If success rate remains above 85 percent, expand to 100 percent. If success rate drops below 85 percent at any stage, halt rollout and alert admin.

-----

## 48.9 Emergency Override System

**When Platform Breaks and Admin Not Available**

System includes emergency failsafe mode. If platform health drops below 50 percent and remains there for more than 2 hours, system sends escalating alerts via email to all admins, SMS to on-call admin, and Slack alert to engineering channel.

If health remains below 50 percent for 6 hours with no admin response, system automatically enters graceful degradation as described in edge case handling. Freeze all TrustScores using that platform data. Display last known good data with staleness indicator. Extend re-verification deadline for affected users. Prevent new Level 3 verifications for that platform until health restored.

**Manual Override**

Admin can manually force platform into maintenance mode from anywhere using admin mobile app or emergency dashboard. This immediately stops scraping, preserves user scores, and displays maintenance message to users attempting to verify that platform.

-----

## 48.10 Multi-Region Platform Support

**Same Platform, Different Regions**

Vinted operates in UK as `vinted.co.uk` and in France as `vinted.fr` and in US as `vinted.com`. Each region may have different HTML structure, different selectors, and different rate limits.

**Configuration Approach**

Treat each region as separate platform configuration. Vinted UK has configuration ID `vinted-uk` with base URL `vinted.co.uk` and UK-specific selectors. Vinted France has configuration ID `vinted-fr` with base URL `vinted.fr` and France-specific selectors. Vinted US has configuration ID `vinted-us` with base URL `vinted.com` and US-specific selectors.

User enters Vinted profile URL during verification. System detects region from URL domain. System selects appropriate configuration for that region. System applies region-specific selectors and rules.

**Shared Fallbacks**

If regions share common structure, configuration can reference shared selector sets. Primary selectors may differ by region but fallback selectors can be shared if HTML structure is similar across regions.

-----

## 48.11 Platform API Integration

**Some Platforms Provide Official APIs**

eBay has public API for seller feedback at `api.ebay.com/commerce/reputation/v1`. Etsy has seller API at `openapi.etsy.com/v3/public`. These APIs are more reliable than scraping.

**Configuration for API-Based Platforms**

For platforms with APIs, configuration includes API endpoint URL, authentication method such as API key or OAuth, rate limit from API provider such as 5000 requests per day, request format as JSON or XML, and response parsing rules to extract rating and reviews from API response.

**Hybrid Approach**

Configuration can specify API as primary method and scraping as fallback. If API is available and working, use API for all extractions. If API is rate-limited or down, fall back to scraping. This provides best reliability while respecting API provider limits.

-----

## 48.12 Configuration Backup and Disaster Recovery

**Automatic Configuration Backup**

Every configuration change is backed up automatically. Store full configuration history in database. Export configuration snapshots to Azure Blob Storage daily. Retention policy keeps all versions for 90 days and monthly snapshots for 7 years to meet compliance requirements.

**Configuration Restoration**

If configuration becomes corrupted or all selectors break simultaneously, admin can restore from any previous backup. Select backup from list showing timestamp and admin who made change. Preview backup configuration before restoring. Restore with one click returning all selectors to previous working state.

**Cross-Platform Configuration Templates**

Create templates for common platform patterns. Star-based marketplace template for platforms using 1 to 5 star ratings. Percentage-based marketplace template for platforms using percent positive ratings. Social profile template for platforms with follower counts and engagement metrics.

When adding new platform, admin selects appropriate template as starting point. Template provides pre-configured selector patterns that admin customizes for specific platform. This dramatically reduces configuration time for new platforms from hours to minutes.

-----

## 48.13 Performance Optimization

**Configuration Caching**

Platform configurations are loaded into memory cache at application startup. Cache expires every 5 minutes or when configuration changes. This ensures scraping system always uses latest configuration while minimizing database queries. Cache hit rate should exceed 99.9 percent for production system.

**Selector Compilation**

CSS selectors and XPath expressions are pre-compiled when configuration loads. Compiled selectors are cached for faster execution. Regular expressions are compiled once and reused across all scraping requests. This reduces extraction time by 40 to 60 percent compared to runtime compilation.

-----

## 48.14 Documentation and Training

**Configuration Documentation**

Each platform configuration includes documentation field. Admin documents what each selector extracts and why specific selector pattern was chosen. Document known issues such as "Vinted sometimes nests rating in additional div on profile pages with >1000 reviews". Document date of last successful extraction. Document admin contact for platform-specific questions.

**Admin Training**

Provide admin training guide covering how to identify broken selectors from monitoring alerts, how to test new selectors using canary system, how to deploy configuration changes safely, how to rollback if changes break scraping, and when to use staged rollout versus immediate deployment.

**Runbook for Platform Breaks**

Create incident response runbook. Step 1 is check platform health dashboard to confirm which platform is affected. Step 2 is review recent configuration changes to see if internal change caused issue. Step 3 is manually visit platform to confirm HTML structure changed. Step 4 is use browser developer tools to identify new selectors. Step 5 is add new selectors to configuration as fallbacks. Step 6 is test new selectors against canary profiles. Step 7 is deploy configuration update. Step 8 is monitor health dashboard to confirm recovery. Step 9 is document incident and resolution for future reference.

-----

## 48.15 Benefits of Modular Configuration System

**Faster Recovery from Platform Changes**

Without modular system, recovery requires code changes and full deployment cycle taking 6 to 12 hours. With modular system, recovery requires configuration update through dashboard taking 15 to 30 minutes. This 20x improvement in recovery time dramatically reduces user impact from platform changes.

**Non-Technical Admin Can Fix Issues**

Without modular system, only developers can update selectors requiring technical knowledge of codebase. With modular system, trained admin can update selectors using web interface requiring no coding knowledge. This enables 24/7 response even when developers are unavailable.

**Reduced Code Complexity**

Without modular system, codebase contains platform-specific logic scattered across multiple files creating maintenance burden. With modular system, single generic scraper reads configuration making codebase simpler and more maintainable. Adding new platform requires zero code changes only configuration entry.

**Better Testing and Validation**

Without modular system, testing selector changes requires full development cycle. With modular system, admin tests selectors in real-time against live profiles before deployment. This catches issues immediately rather than discovering them in production.

**Audit Trail and Rollback**

Without modular system, selector changes are buried in git commits requiring developer to trace history. With modular system, every configuration change is tracked with timestamp, admin name, and reason. Rollback to any previous version takes one click.

**Scaling to Many Platforms**

Without modular system, adding 10 new platforms means writing 10 new scraper classes taking weeks of development. With modular system, adding 10 new platforms means creating 10 configuration entries taking hours. This enables rapid expansion to support more marketplaces.

-----

## 48.16 Implementation Priority

**Phase 1: Core Configuration System**

Build PlatformConfigurations database table. Build configuration API for CRUD operations. Build configuration caching layer. Build basic selector rotation logic. Estimated 2 weeks development time.

**Phase 2: Admin Dashboard Interface**

Build platform list view in admin dashboard. Build configuration editor UI. Build real-time selector testing. Build version history and rollback. Estimated 2 weeks development time.

**Phase 3: Health Monitoring Integration**

Build canary profile system. Build automated health checks. Build automatic selector promotion. Build alert system. Estimated 1 week development time.

**Phase 4: Advanced Features**

Build staged rollout system. Build emergency override. Build configuration templates. Build API integration support. Estimated 2 weeks development time.

**Total estimated time is 7 weeks for complete modular configuration system.**

This investment pays for itself after first major platform change. Without this system, one Vinted HTML change could break 50,000 verifications for 12 hours causing massive user trust damage. With this system, same change is resolved in 20 minutes with zero user impact.

-----

## 48.17 Integration with Existing Sections

This section integrates with Section 5 Core Features where Level 3 verification relies on platform scraping now made configurable.

This section integrates with Section 14 Admin Dashboard where platform configuration manager is added as new admin tool.

This section integrates with Section 47 Edge Case Handling where graceful degradation depends on platform health monitoring enabled by configuration system.

**No Conflicts**

Level 3 verification logic unchanged. Scraping functionality unchanged. Only implementation method changes from hardcoded to configuration-driven. All existing features continue working with improved reliability and maintainability.

-----

## 48.18 Summary

The modular platform configuration system transforms platform scraping from fragile hardcoded implementation to flexible configuration-driven system. When marketplaces change HTML structure, admin updates configuration through dashboard instead of waiting for code deployment. Recovery time reduces from hours to minutes. Non-technical admin can fix issues. System scales easily to support many platforms. This system is essential for maintaining user trust when external platforms change without warning.

-----

**END OF SECTION 48**

---

# SECTION 49: LEVEL 3 VERIFICATION - MARKETPLACE PROFILE VERIFICATION FLOWS

## 49.1 Purpose & Overview

**Level 3 Verification** is the highest trust tier for marketplace profile verification in SilentID. It proves **cryptographic ownership** of external marketplace accounts and extracts verified star ratings for the user's Digital Trust Passport.

**Core Principle: Ownership-First, Then Extract**

All data extraction MUST occur AFTER ownership verification, never before. Users must explicitly confirm "This is my profile" and consent to SilentID checking their public marketplace profile.

**Key Changes from Previous Versions:**
- **Share-Intent** is now the **PRIMARY** verification method (fastest, most user-friendly)
- **Token-in-Bio** is **SECONDARY** fallback method (when share doesn't work)
- **Screenshot + OCR** is **PRIMARY** extraction method (automated, privacy-respecting)
- **HTML/DOM extraction** is **SECONDARY** (internal technical term, never shown to users)
- **Manual screenshot upload (up to 3)** is **LAST RESORT** (user-driven, lower confidence)
- Word **"scraping"** is **FORBIDDEN** in all user-facing, help, and marketing content
- **"Scraping"** allowed ONLY in internal technical sections clearly marked as such

**Three Modes of Operation:**

1. **API Mode** (Highest confidence: 100%)
   - Platform provides official API (e.g., eBay Commerce API)
   - Rating extracted directly from API response
   - Most reliable, no HTML parsing needed
   - Stored in Azure Key Vault (API credentials)

2. **Screenshot + HTML Mode** (High confidence: 95%)
   - Automated headless browser (Playwright/Puppeteer) takes screenshot
   - OCR extracts text from screenshot (ratings, reviews, username)
   - HTML/DOM extraction as secondary validation
   - 3 automated attempts before manual fallback

3. **Manual Screenshot Mode** (Medium confidence: 75%)
   - User uploads up to 3 screenshots manually
   - OCR extracts data from user-provided screenshots
   - Lower confidence due to potential tampering
   - Used only when automated methods fail or unsupported platform

---

## 49.2 Ownership-First Rule (Absolute Requirement)

**CRITICAL RULE: SilentID MUST NEVER extract data from a marketplace profile until ownership is verified.**

**Why This Rule Exists:**
- **Legal Protection:** Prevents impersonation, identity theft, profile hijacking
- **User Trust:** Users control what data is checked and when
- **Privacy Compliance:** Explicit consent before any data collection
- **Fraud Prevention:** Stops users from linking to others' high-rated profiles

**Enforcement:**

1. **Ownership Verification FIRST:**
   - User initiates Share-Intent flow OR Token-in-Bio flow
   - System verifies ownership cryptographically
   - Only after successful verification does extraction begin

2. **No Speculative Extraction:**
   - System does NOT pre-fetch profile data "just in case"
   - System does NOT extract data to "test" if profile is valid
   - Extraction begins ONLY after ownership verified

3. **Consent Required:**
   - User must explicitly confirm: "This is my profile"
   - User must consent: "I allow SilentID to check my public marketplace profile"
   - Consent captured with timestamp and stored in database

4. **Ownership Locks Profile:**
   - Once verified, profile URL is locked to that user's SilentID account
   - No other user can verify the same profile URL
   - Prevents multiple users claiming same marketplace account

**Database Enforcement:**

```sql
-- ProfileLinkEvidence table
OwnershipVerifiedAt TIMESTAMP NULL,  -- Must be non-null before extraction
OwnershipMethod VARCHAR(50),  -- ShareIntent | TokenInBio | Manual
OwnershipLockHash VARCHAR(64),  -- SHA-256 of profile URL to prevent duplicates
ConsentConfirmedAt TIMESTAMP NULL,  -- User consent timestamp
ConsentIPAddress VARCHAR(50)  -- IP where consent was given
```

**Code Pattern:**

```csharp
// CORRECT: Ownership verified first
if (profileLink.OwnershipVerifiedAt == null)
{
    throw new InvalidOperationException("Ownership must be verified before extraction.");
}

// Only proceed if ownership confirmed
var extractedData = await ExtractProfileDataAsync(profileLink.URL);
```

```csharp
// WRONG: Extraction before ownership verification
var extractedData = await ExtractProfileDataAsync(url);  // FORBIDDEN
if (IsOwnershipVerified(url))
{
    SaveExtractedData(extractedData);
}
```

---

## 49.3 Method A: Token-in-Bio (SECONDARY Verification Method)

**When to Use:**
- Share-Intent not available on platform (desktop-only platforms)
- Share-Intent failed or unsupported by user's device/browser
- User prefers manual verification method
- Platform has editable bio/description field

**Flow:**

**Step 1: User Initiates Verification**
- User taps "Connect Marketplace Profile" in SilentID app
- User selects platform (Vinted, eBay, Depop, etc.)
- User selects verification method:
  - **"Share from App" (RECOMMENDED)** ← Primary option, emphasized
  - **"Add Code to Bio" (MANUAL)** ← Secondary option, smaller button

**Step 2: Generate Unique Verification Token**
- System generates unique token: `SILENTID-VERIFY-{random-8-chars}`
- Example: `SILENTID-VERIFY-A7B3C9X2`
- Token stored in database with:
  - UserId
  - Platform
  - Expiry (24 hours from generation)
  - Status (Pending, Verified, Expired)

**Step 3: User Instructions (UI)**
```
Add This Code to Your Vinted Bio:
──────────────────────────────────
SILENTID-VERIFY-A7B3C9X2
──────────────────────────────────
[Copy Code]

How to Add:
1. Open Vinted app
2. Go to Settings → Edit Profile
3. Paste the code anywhere in your bio
4. Save your profile
5. Come back here and tap "I've Added the Code"

You can remove the code after verification.
```

**Step 4: User Confirms Code Added**
- User taps "I've Added the Code"
- System prompts: "Please confirm this is your profile"
  - Checkbox: ☐ "This is my marketplace profile"
  - Button: "Verify Ownership"

**Step 5: Automated Verification**
- System uses headless browser (Playwright) to visit profile URL
- Searches for exact token match in bio text using multiple methods:
  - Primary: Direct text search in bio field
  - Fallback 1: Case-insensitive regex: `/SILENTID-VERIFY-[A-Z0-9]{8}/i`
  - Fallback 2: Full page text search (in case bio location changed)
- If token found:
  - Ownership verified ✓
  - `OwnershipVerifiedAt` timestamp set
  - `OwnershipMethod` set to "TokenInBio"
  - `OwnershipLockHash` created (SHA-256 of profile URL)
  - Token marked as "Used"
- If token NOT found:
  - Show error: "We couldn't find your verification code. Please check you added it correctly."
  - Offer retry (max 3 attempts)

**Step 6: Proceed to Extraction**
- After ownership verified, system proceeds to **49.6 Screenshot + OCR Extraction**
- User can now remove token from bio (optional, but recommended for privacy)

**Security:**
- Token expires after 24 hours if not used
- Token can only be used once
- Profile URL locked after successful verification (prevents re-use by others)

**Database Schema:**

```sql
CREATE TABLE VerificationTokens (
  Id UUID PRIMARY KEY,
  UserId UUID REFERENCES Users(Id),
  Platform VARCHAR(50),
  Token VARCHAR(100) UNIQUE,  -- SILENTID-VERIFY-{random}
  ProfileURL VARCHAR(500),
  Status VARCHAR(50),  -- Pending, Verified, Expired, Failed
  GeneratedAt TIMESTAMP,
  ExpiresAt TIMESTAMP,  -- 24 hours from generation
  VerifiedAt TIMESTAMP NULL,
  AttemptCount INT DEFAULT 0
);
```

---

## 49.4 Method B: Share-Intent (PRIMARY Verification Method)

**When to Use:**
- Platform supports share functionality (Vinted, Facebook, Instagram, eBay app, etc.)
- User has platform app installed on mobile device
- Fastest and easiest method (recommended first)

**Flow:**

**Step 1: User Initiates Verification**
- User taps "Connect Marketplace Profile" in SilentID app
- User selects platform (Vinted, Facebook Marketplace, etc.)
- **PRIMARY OPTION** displayed prominently:
  ```
  ┌─────────────────────────────────────┐
  │ ✅ FASTEST METHOD (RECOMMENDED)    │
  │                                     │
  │ Share from App                      │
  │ Takes 10 seconds                    │
  │                                     │
  │ [Share My Profile] ← Large button  │
  └─────────────────────────────────────┘

  ┌─────────────────────────────────────┐
  │ OR                                  │
  │                                     │
  │ Add Code to Bio (Manual)            │
  │ Takes 2-3 minutes                   │
  │                                     │
  │ [Use Manual Method] ← Small button  │
  └─────────────────────────────────────┘
  ```

**Step 2: Generate Deep Link**
- System generates unique verification deep link:
  ```
  https://silentid.co.uk/verify/{unique-token}
  ```
- Token contains encrypted payload:
  - UserId (encrypted)
  - Platform name
  - Timestamp
  - Signature (prevents tampering)
- Token expires after 5 minutes

**Step 3: Share Intent Instructions (UI)**
```
Share Your Vinted Profile

1. Open Vinted app on this device
2. Go to your profile
3. Tap the "Share" button (usually 3 dots or share icon)
4. Select "Copy Link" or "Share to SilentID"
5. Come back here

[Open Vinted App] ← Opens Vinted app via deep link

Waiting for share...
[Cancel]
```

**Step 4: User Shares Profile**
- User opens marketplace app (Vinted, Facebook, etc.)
- User navigates to their profile
- User taps "Share" button in marketplace app
- Options appear:
  - "Copy Link" ← User taps this
  - OR "Share to SilentID" ← If deep link integration configured

**Step 5: User Returns to SilentID**
- If "Copy Link" was used:
  - User returns to SilentID app
  - SilentID detects clipboard contains marketplace URL
  - Prompt: "Paste your profile link here"
  - User pastes or auto-fills
- If "Share to SilentID" was used:
  - SilentID app receives URL directly via deep link
  - Auto-populates profile URL field

**Step 6: Automated Verification**
- System validates shared URL:
  - URL matches expected platform domain (vinted.com, facebook.com/marketplace, etc.)
  - URL format matches platform profile pattern
  - URL is publicly accessible (not private/404)
- System prompts user:
  ```
  Confirm This Is Your Profile

  Profile URL: https://vinted.com/member/sarahtrusted

  ☐ This is my marketplace profile
  ☐ I allow SilentID to check my public profile for ratings

  [Verify Ownership]
  ```

**Step 7: Ownership Confirmation**
- User checks both boxes and taps "Verify Ownership"
- System records:
  - `OwnershipVerifiedAt` = current timestamp
  - `OwnershipMethod` = "ShareIntent"
  - `OwnershipLockHash` = SHA-256(profile URL)
  - `ConsentConfirmedAt` = current timestamp
  - `ConsentIPAddress` = user's IP
- System locks profile URL (prevents other users from verifying same URL)

**Step 8: Device Fingerprint Validation (Security Layer)**
- System compares device fingerprint from:
  - Device that initiated verification
  - Device that shared the link
- If fingerprints match → High confidence, ownership verified
- If fingerprints don't match → Flag for review (possible device change, but still proceed)

**Step 9: Proceed to Extraction**
- After ownership verified, system proceeds to **49.6 Screenshot + OCR Extraction**
- User notified: "Ownership verified! Checking your profile..."

**Security:**
- Deep link token expires after 5 minutes
- Device fingerprint validation prevents link sharing fraud
- Profile URL locked to prevent multiple accounts claiming same profile
- Consent timestamp and IP logged for audit trail

**Database Schema:**

```sql
CREATE TABLE ShareIntentVerifications (
  Id UUID PRIMARY KEY,
  UserId UUID REFERENCES Users(Id),
  Platform VARCHAR(50),
  SharedURL VARCHAR(500),
  DeepLinkToken VARCHAR(255) UNIQUE,
  DeviceFingerprintInitiation VARCHAR(500),
  DeviceFingerprintShare VARCHAR(500),
  FingerprintMatch BOOLEAN,
  Status VARCHAR(50),  -- Pending, Verified, Expired, Failed
  GeneratedAt TIMESTAMP,
  ExpiresAt TIMESTAMP,  -- 5 minutes from generation
  VerifiedAt TIMESTAMP NULL
);
```

---

## 49.5 Offering Both Methods (Share First, Token Second)

**UI Design Pattern:**

When user selects "Connect Marketplace Profile", show platform selection first, then method selection with Share-Intent PROMINENTLY featured:

```
Connect Your Vinted Profile
─────────────────────────────

┌────────────────────────────────────────┐
│ ⭐ RECOMMENDED (10 SECONDS)           │
│                                        │
│ Share from Vinted App                  │
│ • Fastest method                       │
│ • No typing required                   │
│ • Works on mobile                      │
│                                        │
│ [Share My Profile] ← Royal purple btn │
└────────────────────────────────────────┘

┌────────────────────────────────────────┐
│ OR                                     │
│                                        │
│ Add Code to Bio (Manual)               │
│ • Takes 2-3 minutes                    │
│ • Works on desktop                     │
│ • Requires editing your bio            │
│                                        │
│ [Use Manual Method] ← Gray outline btn│
└────────────────────────────────────────┘

[Cancel]
```

**Fallback Logic:**

If Share-Intent fails (e.g., platform doesn't support share, clipboard blocked, etc.):
- Show error: "Share didn't work on this device. Try the manual method instead."
- Auto-switch to Token-in-Bio flow
- Button: "Switch to Manual Verification"

**Platform Support Matrix:**

| Platform | Share-Intent Support | Token-in-Bio Support | Notes |
|----------|---------------------|---------------------|-------|
| Vinted | ✅ Yes (mobile app) | ✅ Yes (bio field) | Share primary |
| eBay | ✅ Yes (mobile app) | ✅ Yes (bio field) | Share primary |
| Depop | ✅ Yes (mobile app) | ✅ Yes (bio field) | Share primary |
| Facebook Marketplace | ✅ Yes (mobile app) | ❌ No (no bio field) | Share only |
| Etsy | ⚠️ Partial (shop URL) | ✅ Yes (shop description) | Token primary |
| Instagram (future) | ✅ Yes (profile share) | ❌ No (bio changes frequently) | Share only |

**Configuration in Section 48:**

Add new field to PlatformConfigurations:

```sql
verification_methods_supported JSONB DEFAULT '["token_in_bio"]'
-- Examples:
-- ["share_intent", "token_in_bio"]  -- Both supported
-- ["share_intent"]  -- Share only
-- ["token_in_bio"]  -- Token only
-- ["manual_screenshot_only"]  -- Neither share nor token (unsupported platform)
```

---

## 49.6 Screenshot + OCR as Primary Extraction Method

**AFTER ownership verified** (via Share-Intent OR Token-in-Bio), SilentID extracts star ratings using **automated screenshot + OCR** as the PRIMARY method.

**Why Screenshot + OCR is Primary:**

1. **Privacy-Respecting:** Only captures what user sees publicly
2. **Tamper-Resistant:** Harder to fake than HTML manipulation
3. **Platform-Agnostic:** Works even if HTML structure changes
4. **Visual Verification:** Can detect UI inconsistencies (fake profiles often have misaligned elements)
5. **User-Friendly Explanation:** Easy to explain to users ("We take a photo of your profile")

**How It Works:**

**Step 1: Automated Screenshot (Headless Browser)**

After ownership verified:
- System launches headless browser (Playwright or Puppeteer)
- Navigates to verified profile URL
- Waits for page to fully load (max 10 seconds)
- Takes screenshot of profile area containing:
  - Username
  - Star rating (e.g., "4.9 ★")
  - Review count (e.g., "327 reviews")
  - Join date (e.g., "Member since Jan 2023")
- Screenshot saved to Azure Blob Storage (temporary, deleted after extraction)

**Step 2: OCR Extraction (Azure Computer Vision or Tesseract)**

- Screenshot sent to Azure Computer Vision OCR API
- Extracted text parsed using platform-specific regex patterns:
  - **Rating:** `(\d\.\d)\s*★` or `(\d+)%\s*positive`
  - **Review Count:** `(\d+)\s*(reviews?|ratings?|sales?)`
  - **Username:** Platform-specific selector from config
  - **Join Date:** `(Member since|Joined)\s+(.+?)` or ISO date format
- Multiple extraction attempts:
  - Attempt 1: Azure Computer Vision (primary)
  - Attempt 2: Tesseract OCR (fallback if Azure fails)
  - Attempt 3: Google Cloud Vision API (optional, if enabled)

**Step 3: HTML/DOM Extraction (SECONDARY Validation)**

- Simultaneously (not instead of screenshot), system extracts same data from HTML:
  - Use CSS selectors from Section 48 platform configuration
  - Extract rating, reviews, username, join date from DOM
  - Compare HTML extraction with OCR extraction
- If OCR and HTML match → High confidence (95%)
- If OCR and HTML differ slightly (< 10% variance) → Medium confidence (85%)
- If OCR and HTML differ significantly (> 10% variance) → Flag for manual review

**Step 4: Cross-Validation**

- Compare extracted username with user's claimed username
- Compare extracted rating with expected range (0-5 or 0-100%)
- Validate review count is non-negative integer
- Check join date is in past (not future)

**Step 5: Confidence Scoring**

```
Confidence Score = Base (95%) + Bonuses - Penalties

Bonuses:
+ OCR and HTML match exactly: +5%
+ Screenshot integrity high (no tampering detected): +0%
+ Multiple OCR engines agree: +0%

Penalties:
- OCR and HTML differ: -10%
- Screenshot quality low (blurry, dark): -5%
- Platform recently changed HTML (within 7 days): -5%

Final Confidence: 75% - 100%
```

**Step 6: Store Extracted Data**

```sql
UPDATE ProfileLinkEvidence
SET
  PlatformRating = 4.9,  -- Extracted from OCR
  ReviewCount = 327,
  JoinDate = '2023-01-15',
  ExtractionMethod = 'ScreenshotOCR',
  ExtractionConfidence = 95,
  ScreenshotURL = 'https://blob.azure.com/...',
  HTMLExtractionMatch = TRUE,
  ExtractedAt = NOW(),
  NextReverifyAt = NOW() + INTERVAL '90 days'
WHERE Id = {profileLinkId};
```

**Step 7: Delete Screenshot (Privacy)**

- After successful extraction, delete screenshot from Azure Blob Storage
- Retain only:
  - Extracted metadata (rating, reviews, join date)
  - Screenshot hash (for integrity checking, not image itself)
  - Extraction confidence score

**Retry Logic:**

If extraction fails (OCR returns no rating, HTML selectors broken):
- **Attempt 1:** Wait 5 seconds, retry screenshot + OCR
- **Attempt 2:** Wait 10 seconds, retry with different OCR engine
- **Attempt 3:** Wait 30 seconds, retry with platform-specific fallback selectors
- **After 3 failures:** Fall back to Manual Screenshot Upload (49.10)

**User-Facing Language (NO "SCRAPING"):**

✅ **CORRECT USER-FACING COPY:**
- "We're checking your public profile..."
- "Taking a snapshot of your ratings..."
- "Extracting your star rating from your profile..."
- "Verifying your marketplace performance..."

❌ **FORBIDDEN USER-FACING COPY:**
- "Scraping your profile..."
- "Crawling your data..."
- "Harvesting your ratings..."

**Technical Documentation (INTERNAL ONLY):**

In internal technical docs and code comments, you MAY use "scraping" or "HTML extraction":
```csharp
// Internal comment: Scrape profile using Playwright headless browser
// User will never see this term
var scrapedData = await ScrapeProfileAsync(url);
```

But in logs visible to users or support staff, use neutral language:
```csharp
Logger.LogInformation("Extracting profile data from {Platform} for user {UserId}", platform, userId);
```

---

## 49.7 HTML/DOM Extraction as Secondary (Internal Only)

**HTML/DOM extraction** is performed ALONGSIDE screenshot+OCR, never instead of it. It serves as:
1. **Validation:** Cross-check OCR results
2. **Fallback:** If screenshot quality is poor
3. **Speed:** Faster than OCR (no image processing)

**When HTML/DOM is Used:**

- **Primary:** Screenshot + OCR extracts rating
- **Simultaneously:** HTML/DOM extraction runs in parallel
- **Comparison:** If OCR = 4.9★ and HTML = 4.9★ → High confidence
- **Fallback:** If OCR fails (blurry image, OCR timeout), use HTML/DOM result

**How It Works:**

**Step 1: Platform Configuration (Section 48)**

Each platform has selector configuration defining how to extract rating from HTML:

```json
{
  "platform": "vinted-uk",
  "rating_selectors": [
    {
      "priority": 1,
      "selector": "div.rating-stars > span.score",
      "extraction_type": "text",
      "regex": "(\\d\\.\\d)"
    },
    {
      "priority": 2,
      "selector": "[data-testid='user-rating']",
      "extraction_type": "attribute",
      "attribute_name": "data-rating"
    },
    {
      "priority": 3,
      "selector": "//div[contains(@class, 'rating')]//span[1]",
      "extraction_type": "xpath",
      "regex": "(\\d\\.\\d)"
    }
  ]
}
```

**Step 2: Selector Rotation**

System tries selectors in priority order:
1. Try primary selector (`div.rating-stars > span.score`)
2. If fails, try fallback 1 (`[data-testid='user-rating']`)
3. If fails, try fallback 2 (XPath)
4. If all fail, log warning and rely on OCR result

**Step 3: Data Normalization**

Different platforms use different scales:
- **Vinted:** 0-5 stars
- **eBay:** 0-100% positive
- **Depop:** 0-5 stars
- **Etsy:** 0-5 stars

Normalize all to 0-100 scale for internal URS calculation:
```csharp
decimal normalizedRating = (platformRating / platformMax) * 100;
// Example: Vinted 4.9/5.0 → (4.9/5.0) * 100 = 98%
```

**Step 4: Store HTML Extraction Result**

```sql
UPDATE ProfileLinkEvidence
SET
  HTMLExtractionRating = 4.9,
  HTMLExtractionMethod = 'CSS Selector (Priority 1)',
  HTMLExtractionTimestamp = NOW(),
  HTMLExtractionMatch = (PlatformRating = HTMLExtractionRating)  -- Compare with OCR result
WHERE Id = {profileLinkId};
```

**CRITICAL USER-FACING RULE:**

**NEVER mention "HTML extraction" or "scraping" to users.**

When explaining how verification works:
- ✅ "We check your public profile"
- ✅ "We extract your star rating"
- ✅ "We verify your marketplace performance"
- ❌ "We scrape your profile's HTML"
- ❌ "We extract DOM elements"

**Why This Matters:**
- "Scraping" has negative connotations (invasive, unauthorized)
- "HTML extraction" sounds technical and scary
- Users don't care HOW data is extracted, only THAT it's accurate and private
- Neutral language builds trust

---

## 49.8 Platform Detection & URL Matching

**When user submits profile URL** (via Share-Intent or manual entry), system must detect which platform it belongs to.

**URL Pattern Matching:**

Each platform configuration (Section 48) includes URL patterns:

```json
{
  "platform": "vinted-uk",
  "url_patterns": [
    "https?://(?:www\\.)?vinted\\.co\\.uk/member/([^/]+)",
    "https?://(?:www\\.)?vinted\\.co\\.uk/membres/([^/]+)"
  ],
  "share_intent_patterns": [
    "vinted://profile/([^/]+)",
    "https://vinted\\.app\\.link/profile/([^/]+)"
  ]
}
```

**Detection Flow:**

**Step 1: User Submits URL**
```
Input: https://www.vinted.co.uk/member/sarahtrusted
```

**Step 2: Normalize URL**
- Remove tracking parameters (`?utm_source=...`)
- Convert to lowercase
- Trim whitespace

**Step 3: Match Against Platform Patterns**

System loops through all platform configurations:
```csharp
foreach (var platform in platformConfigs)
{
    foreach (var pattern in platform.UrlPatterns)
    {
        var match = Regex.Match(normalizedUrl, pattern);
        if (match.Success)
        {
            return new PlatformMatch
            {
                Platform = platform.Name,
                Username = match.Groups[1].Value,  // Extracted from regex group
                Confidence = 100
            };
        }
    }
}
```

**Step 4: Fuzzy Matching (Fallback)**

If no exact pattern match, try fuzzy matching:
- Check if domain contains known platform name (e.g., "vinted" in URL)
- Check if URL structure resembles known patterns
- Flag for manual review if confidence < 80%

**Step 5: Platform-Specific Validation**

After detecting platform, validate URL is accessible:
- HTTP HEAD request to check if URL exists (200 OK)
- Check if page requires login (some Facebook profiles are private)
- Verify URL points to user profile, not shop/listing/other

**Example Matches:**

| Input URL | Detected Platform | Username | Confidence |
|-----------|------------------|----------|------------|
| `https://vinted.co.uk/member/sarahtrusted` | vinted-uk | sarahtrusted | 100% |
| `https://www.ebay.com/usr/john_seller` | ebay-us | john_seller | 100% |
| `https://depop.com/@alice123` | depop | alice123 | 100% |
| `https://facebook.com/marketplace/profile/12345` | facebook-marketplace | 12345 | 100% |
| `https://vintedapp.link/profile/xyz` | vinted-uk | xyz | 95% (deep link) |
| `https://unknown-marketplace.com/user/bob` | Unknown | bob | 0% (unsupported) |

**Unsupported Platform Handling:**

If platform not recognized:
- Show error: "This marketplace isn't supported yet. We're adding new platforms regularly!"
- Button: "Request Platform Support"
- Log platform domain for future support consideration

---

## 49.9 Consent & "This Is My Profile" Confirmation Flow

**EXPLICIT CONSENT REQUIRED** before any data extraction.

**Two-Step Confirmation:**

**Step 1: Profile Ownership Confirmation**

After user completes Share-Intent or Token-in-Bio:
```
Confirm This Is Your Profile
─────────────────────────────

Profile URL: https://vinted.co.uk/member/sarahtrusted
Platform: Vinted UK

☐ This is my marketplace profile

[Continue]  ← Disabled until checkbox checked
[Cancel]
```

**Step 2: Data Access Consent**

After checkbox checked:
```
Allow SilentID to Check Your Profile?
─────────────────────────────────────

We'll securely check your public Vinted profile to extract:
• Your star rating
• Your review count
• Your account join date

We will NOT access:
• Your private messages
• Your purchase history
• Your personal details
• Your payment information

☐ I allow SilentID to check my public marketplace profile

[Verify & Extract Data]  ← Disabled until checkbox checked
[Cancel]
```

**Step 3: Record Consent**

When user taps "Verify & Extract Data":
```sql
UPDATE ProfileLinkEvidence
SET
  OwnershipConfirmedAt = NOW(),
  ConsentConfirmedAt = NOW(),
  ConsentIPAddress = '{user IP}',
  ConsentUserAgent = '{browser/app info}',
  ConsentVersion = 'v1.0',  -- Track consent form version for legal compliance
  Status = 'OwnershipVerified'
WHERE Id = {profileLinkId};
```

**Step 4: Proceed to Extraction**

Only after BOTH checkboxes checked and consent recorded:
- Launch screenshot + OCR extraction (49.6)
- Show progress: "Checking your profile... (this may take 10-20 seconds)"

**Legal Protection:**

This two-step consent:
1. Proves user intentionally verified ownership
2. Proves user consented to data extraction
3. Creates audit trail for GDPR compliance
4. Protects against "I didn't know SilentID would check my profile" claims

**Consent Withdrawal:**

User can revoke consent later:
- Settings → Connected Platforms → Vinted → "Remove Verification"
- Deletes extracted data
- Removes ownership lock
- Logs revocation timestamp

---

## 49.10 Manual Screenshot Upload (Last Resort - Up to 3 Screenshots)

**When Used:**

- Automated screenshot + OCR failed 3 times
- Platform not supported for automated extraction
- User prefers manual upload for privacy reasons
- Ownership verified but extraction impossible

**Flow:**

**Step 1: Automated Extraction Failed**

After 3 failed automated attempts:
```
We Couldn't Extract Your Rating Automatically
──────────────────────────────────────────────

This can happen if:
• The platform's page layout changed recently
• Your profile has privacy settings enabled
• Network connection issues

You can upload screenshots manually instead.

[Upload Screenshots Manually]
[Try Automatic Extraction Again]
[Cancel]
```

**Step 2: Manual Upload Instructions**

User taps "Upload Screenshots Manually":
```
Upload Screenshots of Your Profile
───────────────────────────────────

To verify your ratings, upload up to 3 clear screenshots showing:

✅ Screenshot 1: Your profile page with star rating visible
✅ Screenshot 2: Your reviews/feedback page (if separate)
✅ Screenshot 3: Your account details showing username and join date

Requirements:
• Screenshots must be clear and readable
• Must show your username matching your claim
• Must show star rating and review count
• No editing or cropping important details

[Choose Screenshot 1]
[Choose Screenshot 2 (Optional)]
[Choose Screenshot 3 (Optional)]

[Submit Screenshots]  ← Disabled until at least 1 uploaded
```

**Step 3: User Uploads Screenshots**

- User selects image from photo library or takes new photo
- Each screenshot uploaded to Azure Blob Storage (temporary)
- System runs OCR on each screenshot
- System runs image integrity checks (tamper detection)

**Step 4: OCR Extraction from Manual Screenshots**

For each screenshot:
```csharp
var ocrResult = await AzureComputerVision.AnalyzeImageAsync(screenshot);
var extractedText = string.Join(" ", ocrResult.Lines.Select(l => l.Text));

// Extract rating using regex
var ratingMatch = Regex.Match(extractedText, @"(\d\.\d)\s*★");
if (ratingMatch.Success)
{
    var rating = decimal.Parse(ratingMatch.Groups[1].Value);
    // Store rating with confidence = 75% (manual screenshot)
}

// Extract review count
var reviewMatch = Regex.Match(extractedText, @"(\d+)\s*reviews?");
if (reviewMatch.Success)
{
    var reviewCount = int.Parse(reviewMatch.Groups[1].Value);
}
```

**Step 5: Image Integrity Check**

Run tampering detection on each screenshot:
- Check EXIF metadata (timestamp, device model)
- Detect Photoshop artifacts (clone stamping, copy-paste)
- Check for pixel-level manipulation
- Validate screenshot resolution matches claimed device

If tampering detected:
```
⚠️ Screenshot Quality Issue

We detected potential editing on Screenshot 1.

This could be:
• Cropping or resizing
• Filters applied
• Editing software artifacts

Please upload an unedited screenshot directly from your device.

[Upload New Screenshot]
```

**Step 6: Cross-Validate Screenshots**

If user uploaded multiple screenshots, cross-validate data:
- Username must match across all screenshots
- Rating should be consistent (allow ±0.1 difference for timing)
- Review count should be consistent (allow ±5% difference)

If inconsistency detected:
```
⚠️ Inconsistent Data Detected

Screenshot 1 shows: 4.9 ★ (327 reviews)
Screenshot 2 shows: 4.7 ★ (312 reviews)

These screenshots may be from different profiles or taken at different times.

Please upload screenshots from the same profile taken within a few minutes of each other.

[Upload New Screenshots]
```

**Step 7: Store Manual Evidence**

```sql
UPDATE ProfileLinkEvidence
SET
  PlatformRating = 4.9,
  ReviewCount = 327,
  ExtractionMethod = 'ManualScreenshot',
  ExtractionConfidence = 75,  -- Lower confidence for manual
  ManualScreenshotCount = 3,
  ManualScreenshotURLs = ARRAY['https://blob.azure.com/1', 'https://blob.azure.com/2', 'https://blob.azure.com/3'],
  IntegrityScore = 85,  -- From tamper detection
  ExtractedAt = NOW(),
  NextReverifyAt = NOW() + INTERVAL '60 days'  -- Shorter re-verify period for manual
WHERE Id = {profileLinkId};
```

**Step 8: Delete Screenshots (Privacy)**

After 30 days or when user deletes verification:
- Delete all manual screenshots from Azure Blob Storage
- Retain only extracted metadata (rating, reviews, join date)
- Retain screenshot hashes for audit trail

**Confidence Scoring:**

```
Manual Screenshot Confidence = Base (75%) + Bonuses - Penalties

Base: 75% (lower than automated 95%)

Bonuses:
+ 3 screenshots uploaded (all consistent): +5%
+ High integrity score (no tampering): +5%
+ Screenshots taken within 5 minutes of each other: +5%

Penalties:
- Only 1 screenshot uploaded: -10%
- Low integrity score (possible editing): -15%
- Username mismatch across screenshots: -20%
- Inconsistent rating/review count: -10%

Final Confidence: 50% - 90%
```

**User-Facing Language:**

✅ **CORRECT:**
- "Upload screenshots of your profile"
- "Manually verify your ratings"
- "Provide screenshots showing your star rating"

❌ **FORBIDDEN:**
- "Upload scraped profile screenshots"
- "Manually scrape your profile"

---

## 49.11 Confidence Levels for Each Extraction Method

**Three Confidence Tiers:**

| Extraction Method | Base Confidence | Max Confidence | Notes |
|------------------|----------------|----------------|-------|
| **API Mode** | 100% | 100% | Official platform API, highest trust |
| **Screenshot + OCR (Automated)** | 95% | 100% | Headless browser, cross-validated with HTML |
| **Screenshot + OCR (Manual)** | 75% | 90% | User-uploaded, tamper detection applied |

**Detailed Confidence Calculation:**

### **API Mode (100%)**

```
Confidence = 100% (fixed)

Why:
- Data comes directly from platform's official API
- No parsing, no OCR, no HTML extraction needed
- Platform guarantees data accuracy
- Rate-limited and authenticated (stored in Azure Key Vault)

Example: eBay Commerce API returns:
{
  "feedbackScore": 542,
  "positiveFeedbackPercent": 99.2,
  "feedbackRatingStar": "TurquoiseStar"
}

Confidence: 100% (no bonuses or penalties apply)
```

### **Screenshot + OCR Automated (95-100%)**

```
Base Confidence: 95%

Bonuses:
+ OCR and HTML extraction match exactly: +5%
+ Screenshot integrity score > 95: +0% (already high base)
+ Multiple OCR engines agree: +0% (redundant)

Penalties:
- OCR and HTML differ by >10%: -10%
- Screenshot quality low (blurry, poor contrast): -5%
- Platform HTML changed within 7 days: -5%
- Username extracted doesn't match claimed: -20%

Final Confidence Range: 75% - 100%

Example 1 (Perfect Match):
- OCR: 4.9 ★ (327 reviews)
- HTML: 4.9 ★ (327 reviews)
- Screenshot integrity: 98%
- Final: 95% + 5% = 100%

Example 2 (Slight Mismatch):
- OCR: 4.9 ★ (327 reviews)
- HTML: 4.8 ★ (325 reviews)  ← Slight difference (timing issue?)
- Screenshot integrity: 92%
- Final: 95% - 10% = 85%
```

### **Screenshot + OCR Manual (75-90%)**

```
Base Confidence: 75%

Bonuses:
+ 3 screenshots uploaded (all consistent): +5%
+ High integrity score (>90): +5%
+ Screenshots taken within 5 minutes: +5%
+ Username matches across all screenshots: +0% (expected)

Penalties:
- Only 1 screenshot uploaded: -10%
- Low integrity score (<70, possible editing): -15%
- Username mismatch: -20%
- Inconsistent rating across screenshots: -10%
- Screenshot EXIF metadata missing (possible fake): -10%

Final Confidence Range: 50% - 90%

Example 1 (High Quality Manual):
- 3 screenshots uploaded
- All show 4.9 ★ (327 reviews)
- Integrity scores: 92%, 94%, 91%
- All taken within 3 minutes
- Final: 75% + 5% + 5% + 5% = 90%

Example 2 (Low Quality Manual):
- 1 screenshot uploaded
- Integrity score: 68% (possible editing detected)
- EXIF metadata missing
- Final: 75% - 10% - 15% - 10% = 40%  ← Below minimum threshold (50%)
→ Rejected, user must re-upload
```

**Minimum Confidence Threshold:**

- **50%** = Minimum to accept verification
- Below 50% = Rejected, user must re-verify or upload better screenshots

**Public Display:**

Confidence is **INTERNAL ONLY**. Users and public never see confidence percentage.

Instead, show trust badges:
- API Mode (100%): "✅ Verified via Official API"
- Automated Screenshot (95-100%): "✅ Automatically Verified"
- Automated Screenshot (85-94%): "✅ Verified"
- Manual Screenshot (75-90%): "✅ Manually Verified"
- Manual Screenshot (50-74%): "⚠️ Verification Pending Review"

---

## 49.12 Platform Matching Rules

**How SilentID determines which platform configuration to use for a given profile URL.**

**Matching Hierarchy:**

1. **Exact Domain Match** (Priority 1)
   - URL: `https://vinted.co.uk/member/alice`
   - Config: `vinted-uk` with domain `vinted.co.uk`
   - Match: 100%

2. **Regex Pattern Match** (Priority 2)
   - URL: `https://www.vinted.com/member/alice`
   - Config: `vinted-us` with pattern `https?://(?:www\.)?vinted\.com/member/(.+)`
   - Match: 100%

3. **Fuzzy Domain Match** (Priority 3)
   - URL: `https://vinted.fr/membres/alice`
   - Config: `vinted-fr` with domain `vinted.fr`
   - Match: 95%

4. **Share-Intent Deep Link Match** (Priority 4)
   - URL: `vinted://profile/alice`
   - Config: `vinted-uk` with share pattern `vinted://profile/(.+)`
   - Match: 90%

5. **No Match** (Unsupported Platform)
   - URL: `https://newmarketplace.com/user/alice`
   - No config found
   - Match: 0% → Show "Platform not supported" error

**Example Configurations (from Section 48):**

```json
{
  "platforms": [
    {
      "id": "vinted-uk",
      "name": "Vinted UK",
      "domain": "vinted.co.uk",
      "url_patterns": [
        "https?://(?:www\\.)?vinted\\.co\\.uk/member/([^/]+)",
        "https?://(?:www\\.)?vinted\\.co\\.uk/membres/([^/]+)"
      ],
      "share_intent_patterns": [
        "vinted://profile/([^/]+)",
        "https://vinted\\.app\\.link/profile/([^/]+)"
      ],
      "verification_methods_supported": ["share_intent", "token_in_bio"],
      "rating_source_mode": "screenshot_plus_html"
    },
    {
      "id": "ebay-us",
      "name": "eBay US",
      "domain": "ebay.com",
      "url_patterns": [
        "https?://(?:www\\.)?ebay\\.com/usr/([^/]+)",
        "https?://(?:www\\.)?ebay\\.com/fdbk/feedback_profile/([^/?]+)"
      ],
      "share_intent_patterns": [
        "ebay://user/([^/]+)"
      ],
      "verification_methods_supported": ["share_intent", "token_in_bio", "api"],
      "rating_source_mode": "api",
      "api_config": {
        "base_url": "https://api.ebay.com/commerce/reputation/v1",
        "auth_type": "oauth",
        "credentials_location": "azure_key_vault",
        "rate_limit_per_day": 5000
      }
    },
    {
      "id": "facebook-marketplace",
      "name": "Facebook Marketplace",
      "domain": "facebook.com",
      "url_patterns": [
        "https?://(?:www\\.)?facebook\\.com/marketplace/profile/(\\d+)",
        "https?://m\\.facebook\\.com/marketplace/profile/(\\d+)"
      ],
      "share_intent_patterns": [
        "fb://profile/(\\d+)",
        "https://fb\\.me/marketplace/([^/]+)"
      ],
      "verification_methods_supported": ["share_intent"],
      "rating_source_mode": "screenshot_plus_html"
    }
  ]
}
```

**Matching Algorithm:**

```csharp
public PlatformMatch DetectPlatform(string profileUrl)
{
    var normalizedUrl = NormalizeUrl(profileUrl);

    // Priority 1: Exact domain match
    foreach (var platform in _platforms)
    {
        if (normalizedUrl.Contains(platform.Domain))
        {
            return new PlatformMatch
            {
                PlatformId = platform.Id,
                Confidence = 100,
                Method = "ExactDomain"
            };
        }
    }

    // Priority 2: Regex pattern match
    foreach (var platform in _platforms)
    {
        foreach (var pattern in platform.UrlPatterns)
        {
            var match = Regex.Match(normalizedUrl, pattern);
            if (match.Success)
            {
                return new PlatformMatch
                {
                    PlatformId = platform.Id,
                    Username = match.Groups[1].Value,
                    Confidence = 100,
                    Method = "RegexPattern"
                };
            }
        }
    }

    // Priority 3: Share-intent deep link match
    foreach (var platform in _platforms)
    {
        foreach (var pattern in platform.ShareIntentPatterns)
        {
            var match = Regex.Match(normalizedUrl, pattern);
            if (match.Success)
            {
                return new PlatformMatch
                {
                    PlatformId = platform.Id,
                    Username = match.Groups[1].Value,
                    Confidence = 90,
                    Method = "ShareIntent"
                };
            }
        }
    }

    // No match found
    return new PlatformMatch
    {
        PlatformId = null,
        Confidence = 0,
        Method = "None",
        Error = "Platform not supported"
    };
}
```

**Ambiguous URL Handling:**

If URL could match multiple platforms (e.g., `vinted.com` could be US or international):

1. **Check User Location** (IP geolocation)
   - User in UK → Suggest `vinted-uk`
   - User in US → Suggest `vinted-us`

2. **Prompt User to Clarify**
   ```
   Which Vinted Region?

   Your profile URL could be:
   • Vinted UK (vinted.co.uk)
   • Vinted US (vinted.com)
   • Vinted France (vinted.fr)

   Select your region:
   [UK] [US] [France] [Other]
   ```

3. **Store Region with Profile**
   ```sql
   UPDATE ProfileLinkEvidence
   SET Platform = 'vinted-uk'
   WHERE URL LIKE '%vinted.co.uk%';
   ```

---

## 49.13 Consent & "This Is My Profile" Confirmation (Detailed Flow)

**Already covered in 49.9**, but expanding with specific UI mockups and legal language.

**UI Mockup 1: Ownership Confirmation**

```
┌──────────────────────────────────────────┐
│ Confirm Profile Ownership                │
├──────────────────────────────────────────┤
│                                          │
│ [Vinted Logo]                            │
│                                          │
│ Profile URL:                             │
│ https://vinted.co.uk/member/sarahtrusted │
│                                          │
│ ┌──────────────────────────────────────┐ │
│ │ ☐ This is my marketplace profile    │ │
│ └──────────────────────────────────────┘ │
│                                          │
│ By confirming, you declare under        │
│ penalty of fraud that you own this       │
│ profile and have the right to verify it. │
│                                          │
│ [Continue] ← Disabled until checked     │
│ [Cancel]                                 │
└──────────────────────────────────────────┘
```

**UI Mockup 2: Data Access Consent**

```
┌──────────────────────────────────────────┐
│ Allow SilentID to Check Your Profile?   │
├──────────────────────────────────────────┤
│                                          │
│ We'll securely check your public         │
│ Vinted profile to verify:                │
│                                          │
│ ✅ Star rating                           │
│ ✅ Review count                          │
│ ✅ Account join date                     │
│ ✅ Username                              │
│                                          │
│ We will NOT access:                      │
│ ❌ Private messages                      │
│ ❌ Purchase/sale history                 │
│ ❌ Personal contact details              │
│ ❌ Payment information                   │
│                                          │
│ ┌──────────────────────────────────────┐ │
│ │ ☐ I consent to SilentID checking my │ │
│ │   public marketplace profile         │ │
│ └──────────────────────────────────────┘ │
│                                          │
│ You can revoke this consent anytime in   │
│ Settings → Connected Platforms.          │
│                                          │
│ [Verify & Extract Data] ← Disabled      │
│ [Cancel]                                 │
└──────────────────────────────────────────┘
```

**Legal Text (Terms & Conditions Reference):**

Add to Section 43 (Consumer Terms of Use):

```markdown
### 8. MARKETPLACE PROFILE VERIFICATION

**8.1 Ownership Declaration:**
When you verify a marketplace profile (Vinted, eBay, etc.), you declare that:
- You are the rightful owner of the marketplace account
- You have the legal right to verify this profile
- All information provided is accurate and truthful

**8.2 Data Access Consent:**
By verifying a profile, you consent to SilentID:
- Checking your public marketplace profile
- Extracting star rating, review count, join date, and username
- Storing this data in your SilentID Trust Passport

**8.3 What We Do NOT Access:**
SilentID does NOT access:
- Private messages or communications
- Purchase or sale history
- Personal contact details
- Payment information
- Private account settings

**8.4 Consent Withdrawal:**
You may withdraw consent and remove verification at any time via:
Settings → Connected Platforms → [Platform] → Remove Verification

**8.5 False Verification:**
Verifying a profile you do not own is:
- Prohibited under these Terms
- Potentially illegal (identity fraud)
- Grounds for immediate account suspension
```

**Database Consent Tracking:**

```sql
CREATE TABLE ConsentLogs (
  Id UUID PRIMARY KEY,
  UserId UUID REFERENCES Users(Id),
  ProfileLinkId UUID REFERENCES ProfileLinkEvidence(Id),
  ConsentType VARCHAR(50),  -- OwnershipConfirmation, DataAccessConsent
  ConsentVersion VARCHAR(20),  -- v1.0, v1.1, etc. (for legal compliance)
  ConsentText TEXT,  -- Full consent language shown to user
  ConsentGivenAt TIMESTAMP,
  ConsentIPAddress VARCHAR(50),
  ConsentUserAgent VARCHAR(500),
  ConsentRevoked BOOLEAN DEFAULT FALSE,
  RevokedAt TIMESTAMP NULL,
  CreatedAt TIMESTAMP
);
```

**GDPR Compliance:**

This two-step consent satisfies GDPR Article 7 requirements:
1. **Freely given** - User can choose not to verify
2. **Specific** - Clearly states what data is accessed
3. **Informed** - Explains purpose and limitations
4. **Unambiguous** - Requires explicit checkbox action
5. **Revocable** - Can withdraw consent anytime

---

## 49.14 Help Centre Article: "Connecting Your Marketplace Profile"

**Location:** Help Center (Section 19) → Using SilentID → Connecting Marketplace Profiles

**Article Title:** How to Connect Your Marketplace Profile to SilentID

**Summary:** Learn how to verify your Vinted, eBay, or other marketplace profiles to add your star ratings to your SilentID Trust Passport.

---

### What You'll Learn
- How to connect marketplace profiles (Vinted, eBay, Depop, etc.)
- Two ways to verify ownership: Share or Manual Code
- What SilentID checks on your profile
- How to keep your star ratings up to date

---

### Why Connect Your Marketplace Profile?

Your marketplace star ratings (like your 4.9★ on Vinted) are powerful trust signals. By connecting your profiles to SilentID, you:
- **Show your verified ratings** on your Trust Passport
- **Prove your trustworthiness** across all platforms
- **Keep your reputation** even if marketplace accounts change
- **Stand out** when trading with new people

---

### Two Ways to Verify Ownership

#### Method 1: Share from App (⭐ RECOMMENDED - Takes 10 seconds)

**How It Works:**
1. Tap "Connect Marketplace Profile" in SilentID
2. Select your platform (e.g., Vinted)
3. Tap "Share from App"
4. Open your marketplace app (e.g., Vinted)
5. Go to your profile
6. Tap "Share" → "Copy Link"
7. Return to SilentID
8. Confirm "This is my profile"
9. Done! We'll check your ratings automatically.

**Best For:**
- Mobile users
- Fastest method
- No typing required

#### Method 2: Add Code to Bio (Takes 2-3 minutes)

**How It Works:**
1. Tap "Connect Marketplace Profile" in SilentID
2. Select your platform (e.g., Vinted)
3. Tap "Add Code to Bio"
4. Copy the unique code shown (e.g., `SILENTID-VERIFY-A7B3C9X2`)
5. Open your marketplace app
6. Go to Settings → Edit Profile
7. Paste the code anywhere in your bio
8. Save your profile
9. Return to SilentID
10. Tap "I've Added the Code"
11. Done! You can remove the code after verification.

**Best For:**
- Desktop users
- When share doesn't work
- Platforms without share button

---

### What SilentID Checks

When you connect a profile, SilentID securely checks your **public** marketplace profile to verify:

✅ **What We Check:**
- Your star rating (e.g., 4.9 ★)
- Your review count (e.g., 327 reviews)
- Your account join date (e.g., Member since Jan 2023)
- Your username (to ensure it matches)

❌ **What We DON'T Check:**
- Private messages
- Purchase or sale history
- Personal contact details
- Payment information
- Account passwords

**Your Privacy is Protected:**
We only check what's already public on your marketplace profile. We never access private data or account settings.

---

### Keeping Your Ratings Up to Date

**Automatic Updates:**
- SilentID re-checks your profile every **90 days**
- If your star rating improves, your Trust Passport updates automatically
- You'll get notified: "Your Vinted rating increased to 5.0 ★!"

**Manual Re-Verification:**
You can manually update anytime:
1. Settings → Connected Platforms
2. Tap your platform (e.g., Vinted)
3. Tap "Update Ratings"

**If Your Rating Drops:**
If your marketplace rating drops (e.g., from 4.9★ to 4.7★), your Trust Passport will reflect the change. This ensures honesty and accuracy.

---

### Supported Marketplaces

**Currently Supported:**
- ✅ Vinted (UK, US, France, Germany, etc.)
- ✅ eBay (All regions)
- ✅ Depop
- ✅ Facebook Marketplace
- ✅ Etsy
- ✅ More coming soon!

**Request a Platform:**
If your marketplace isn't listed, tap "Request Platform Support" and we'll consider adding it.

---

### Troubleshooting

**Problem:** Share didn't work on my device
**Solution:**
- Try the "Add Code to Bio" method instead
- Ensure you have the marketplace app installed
- Check you're using the latest app version

**Problem:** "We couldn't find your verification code"
**Solution:**
- Double-check you pasted the code correctly in your bio
- Make sure you saved your profile after adding the code
- Wait 1-2 minutes and try again (profile updates take time)

**Problem:** "This profile is already verified by another user"
**Solution:**
- Each marketplace profile can only be verified once
- If you believe this is your profile, contact support
- Provide proof of ownership (screenshot of your account settings)

**Problem:** "Platform not supported"
**Solution:**
- We're adding new platforms regularly
- Tap "Request Platform Support" to let us know
- You can still manually upload screenshots (up to 3) in the meantime

---

### Removing a Connected Profile

**To Remove:**
1. Settings → Connected Platforms
2. Tap the platform you want to remove (e.g., Vinted)
3. Tap "Remove Verification"
4. Confirm removal

**What Happens:**
- Your star rating from that platform is removed from your Trust Passport
- Other platform ratings remain unchanged
- You can re-verify the profile later if you change your mind

---

### When to Contact Support

Contact SilentID support if:
- Your profile won't verify after multiple attempts
- You see someone else's rating on your Trust Passport
- You need to verify a profile already claimed by another account
- You have questions about what data we check

**Support:** support@silentid.co.uk

---

### Related Articles
- "Understanding Your Trust Passport"
- "What is TrustScore?"
- "Privacy & Data: What SilentID Stores"

---

**Last Updated:** 2025-11-24
**Source:** Section 49.14 of SilentID Master Specification

---

**END OF HELP CENTRE ARTICLE**

---

## 49.15 Marketing Copy: Landing Page & In-App Messaging

**CRITICAL RULE: NO "SCRAPING" LANGUAGE**

All marketing and user-facing content must use neutral, user-friendly language that emphasizes **control, consent, and protection**.

### Landing Page Section: "Bring Your Stars With You"

```markdown
## Your Stars. Your Proof. Your Passport.

You've earned those 5-star reviews on Vinted, eBay, and Depop.
**Now carry them with you** — everywhere you trade online.

[Connect My Marketplace Profiles]

### How It Works

**1. Connect Your Profiles**
Share your Vinted, eBay, or Depop profile in 10 seconds.
We'll verify you own it, then check your public ratings.

**2. Build Your Trust Passport**
Your star ratings from all platforms appear in one place.
Show your 4.9★ reputation to anyone, anytime.

**3. Share Everywhere**
Use your Trust Passport on Facebook Marketplace, rental viewings, or local meetups.
Your verified ratings go with you.

[Get Started Free]

---

### Why Trust Passport?

✅ **Portable Trust** - Your marketplace success isn't locked in one platform
✅ **Verified Ratings** - Cryptographically proven ownership, not fake screenshots
✅ **Privacy Protected** - We only check what's already public
✅ **Always Up to Date** - Ratings refresh every 90 days automatically

---

### Protect Your Reputation

**What if your Vinted account gets suspended?**
With SilentID, your verified star ratings are safely stored in your Trust Passport.
Even if a marketplace closes your account, your reputation history remains.

**What if you switch platforms?**
Bring your 5-star eBay rating to Facebook Marketplace trades.
Your trust travels with you.

[Start Building Your Trust Passport]

---

### Trusted by Honest Traders

> "I had 500+ 5-star reviews on Vinted. When my account got wrongly suspended, I lost everything. With SilentID, that won't happen again."
> — **Sarah M., London**

> "Buyers on Facebook Marketplace used to doubt me. Now I show my SilentID Trust Passport with my verified eBay 99% rating. Sales doubled."
> — **James T., Manchester**

[Join 50,000+ Verified Traders]
```

---

### In-App Onboarding: First-Time Users

**Screen 1: Welcome**
```
Welcome to SilentID

Build your portable Trust Passport
by connecting your marketplace profiles.

[Continue]
```

**Screen 2: What is Trust Passport?**
```
Your Digital Trust Passport

Your verified star ratings from:
🛍️ Vinted
📦 eBay
👗 Depop
📱 Facebook Marketplace
...and more!

All in one portable profile.

[Next]
```

**Screen 3: How Verification Works**
```
We Verify Your Ownership

1. You share your marketplace profile
2. You confirm "This is my profile"
3. We check your public ratings
4. Your stars appear on your Passport

Your privacy is protected.
We only check what's already public.

[Got It]
```

**Screen 4: Connect Your First Profile**
```
Connect Your First Profile

Choose a marketplace to start:

[Vinted]  [eBay]  [Depop]  [Facebook]

You can add more later.

[Skip for Now]
```

---

### In-App Prompts: Encouraging Connections

**After User Creates Account:**
```
🌟 Add Your Star Ratings!

You've earned those 5-star reviews.
Show them off in your Trust Passport.

[Connect Vinted]  [Connect eBay]
[Maybe Later]
```

**After User Views Another Profile:**
```
This user has 4.9 ★ on Vinted (327 reviews)

Want to show your ratings too?

[Connect My Profiles]  [Not Now]
```

**After User Completes Transaction:**
```
Great transaction!

Did you know you can bring your marketplace ratings to SilentID?

If you're a 5-star seller on Vinted or eBay, connect your profile to prove it.

[Connect Profiles]  [Dismiss]
```

---

### Feature Highlight: Protection Against Account Loss

```markdown
### Your Ratings. Protected.

Marketplace accounts can be:
- Suspended by mistake
- Hacked and deleted
- Closed when platforms shut down

**SilentID protects your reputation history.**

Once verified, your star ratings are safely stored in your Trust Passport—even if your marketplace account disappears.

[Connect Your Profiles Now]
```

---

### Email Campaign: "Bring Your Stars With You"

**Subject:** Your 5-star reviews deserve a permanent home

**Body:**
```
Hi [Name],

You've worked hard to earn those 5-star reviews on Vinted, eBay, and Depop.

But what if:
- Your account gets suspended?
- The platform shuts down?
- You want to trade on a different marketplace?

**Your trust shouldn't be locked in one platform.**

With SilentID, you can:
✅ Verify your marketplace profiles in 10 seconds
✅ Store your verified star ratings in your Trust Passport
✅ Share your reputation anywhere you trade

[Connect Your Profiles]

Your stars. Your proof. Your passport.

— The SilentID Team

P.S. We only check what's already public on your profile. No passwords, no private data.
```

---

### Social Media Copy

**Twitter/X:**
```
Your 5-star @Vinted rating shouldn't disappear if your account gets suspended.

With @SilentID, your verified marketplace ratings are stored in your portable Trust Passport.

Bring your stars with you. Everywhere.

[Link to signup]
```

**Instagram:**
```
[Image: Trust Passport mockup showing multiple platform ratings]

Caption:
You've earned those stars. ⭐
Now carry them everywhere. 📱

Connect your Vinted, eBay, and Depop profiles to SilentID.
Your verified ratings in one portable Trust Passport.

Link in bio 👆

#TrustPassport #VerifiedSeller #VintedSeller #EbaySeller
```

**LinkedIn:**
```
Marketplace sellers, listen up:

Your 5-star eBay rating with 500+ reviews?
It's locked in eBay.

Your 4.9★ Vinted rating with 300+ reviews?
It's locked in Vinted.

**What if you could bring all your verified marketplace ratings into one portable profile?**

That's what SilentID does.

Verify ownership of your marketplace profiles (Vinted, eBay, Depop, etc.) and we extract your public star ratings into your Trust Passport.

Then share your Trust Passport anywhere:
→ Facebook Marketplace trades
→ Local meetups
→ Rental viewings
→ Community groups

Your trust travels with you.

Learn more: [link]
```

---

### Key Messaging Principles

1. **Emphasize Control:**
   - "You choose what to connect"
   - "You confirm ownership"
   - "You can remove anytime"

2. **Emphasize Protection:**
   - "Your ratings are safe even if accounts get suspended"
   - "We only check what's already public"
   - "Your privacy is protected"

3. **Emphasize Portability:**
   - "Your stars go with you"
   - "Trust travels across platforms"
   - "One portable reputation"

4. **Avoid Technical Jargon:**
   - ❌ "We scrape your profile"
   - ❌ "HTML extraction"
   - ❌ "DOM parsing"
   - ✅ "We check your public profile"
   - ✅ "We verify your star rating"
   - ✅ "We extract your ratings"

5. **Honest About Limitations:**
   - "We only check public data"
   - "Ownership must be verified first"
   - "Ratings update every 90 days"

---

**END OF MARKETING COPY**

---

## 49.16 Admin UI: Platform Management (Additions to Section 48)

**This subsection defines admin UI enhancements for managing platforms in the Modular Configuration System.**

**Location:** `admin.silentid.co.uk/platforms`

### New UI Components:

#### **1. Platform List View (Enhanced)**

Add new columns to existing Section 48 list view:

| Column | Description |
|--------|-------------|
| **Rating Source Mode** | `API` | `Screenshot+HTML` | `Unsupported` |
| **Verification Methods** | Icons: 📱 Share-Intent, 🔤 Token-in-Bio, 📸 Manual Only |
| **API Status** | If API mode: ✅ Connected | ⚠️ Rate Limited | ❌ Failing |
| **Last Extraction** | Timestamp of last successful rating extraction |
| **Avg Confidence** | Average confidence score across all extractions (95%, 87%, etc.) |

**Quick Actions:**
- **Test API** (if API mode enabled)
- **Test Share-Intent** (if supported)
- **Test Token Verification** (if supported)
- **View Extraction Logs**

---

#### **2. Add/Edit Platform Form (Enhanced)**

**Tab 1: Basic Configuration** (existing from Section 48)
- Platform name, logo, domain, URL patterns

**Tab 2: Rating Source Mode** (NEW)

```
Rating Extraction Method
────────────────────────

How should SilentID extract star ratings from this platform?

○ API Mode
  Platform provides official API
  [Configure API]

○ Screenshot + HTML Mode
  Automated screenshot with OCR + HTML extraction
  [Configure Selectors]

○ Unsupported
  Platform not yet ready for automated extraction
  (Users can upload manual screenshots only)

[Save Configuration]
```

**If "API Mode" selected:**

```
API Configuration
─────────────────

Base URL:
[https://api.ebay.com/commerce/reputation/v1]

Authentication:
○ API Key   ○ OAuth 2.0   ○ Basic Auth

API Credentials (stored in Azure Key Vault):
Key Vault Secret Name: [ebay-api-key]
[Test Connection]

Rate Limit:
[5000] requests per [day ▼]

Response Format:
○ JSON   ○ XML

Rating Field Path:
[feedbackScore.positiveFeedbackPercent]

Review Count Field Path:
[feedbackScore.count]

[Save API Config]
```

**If "Screenshot + HTML Mode" selected:**

Uses existing Section 48 selector configuration UI.

---

**Tab 3: Verification Methods** (NEW)

```
Supported Verification Methods
───────────────────────────────

How can users prove ownership of profiles on this platform?

☑ Share-Intent (Recommended)
  User shares profile URL from platform app

  Share-Intent Deep Link Pattern:
  [vinted://profile/{username}]

  Alternative Deep Link:
  [https://vinted.app.link/profile/{username}]

☑ Token-in-Bio
  User adds verification code to profile bio

  Bio Field Selector (CSS):
  [div.user-bio > p.bio-text]

  Bio Field XPath:
  [//div[@class='user-bio']//p[1]]

☐ Manual Screenshot Only
  No automated verification available
  (User uploads screenshots manually)

[Save Verification Config]
```

---

**Tab 4: Extraction Testing** (NEW)

```
Test Extraction
───────────────

Test live extraction against real profiles to verify configuration works.

Test Profile URLs (enter 3-5 known working profiles):

1. [https://vinted.co.uk/member/testuser1]
2. [https://vinted.co.uk/member/testuser2]
3. [https://vinted.co.uk/member/testuser3]

[Run Test Extraction]

Results:
───────
Profile 1: ✅ Success
  Rating: 4.9 ★
  Reviews: 327
  Extraction Time: 3.2s
  Confidence: 95%
  Method: Screenshot+OCR

Profile 2: ⚠️ Partial Success
  Rating: 4.7 ★
  Reviews: NOT EXTRACTED (selector failed)
  Extraction Time: 5.1s
  Confidence: 75%
  Method: Screenshot+OCR (HTML fallback failed)

Profile 3: ❌ Failed
  Error: Timeout after 10s
  Recommendation: Check if platform is rate-limiting

[View Detailed Logs]
```

---

**Tab 5: Monitoring & Health** (existing from Section 48, no changes)

---

#### **3. API Connection Testing**

**For API-enabled platforms:**

```
Test eBay API Connection
────────────────────────

API Base URL:
https://api.ebay.com/commerce/reputation/v1

Credentials:
🔐 ebay-api-key (Azure Key Vault)

Test User:
[testuser_ebay_verified]

[Run API Test]

Results:
────────
✅ Connection Successful

Response:
{
  "feedbackScore": 542,
  "positiveFeedbackPercent": 99.2,
  "feedbackRatingStar": "TurquoiseStar",
  "sellerInfo": {
    "feedbackCount": 542
  }
}

Extraction:
  Rating: 99.2% ★
  Reviews: 542
  Confidence: 100% (API mode)

[Save & Enable API Mode]
```

**If API test fails:**

```
❌ API Connection Failed

Error: 401 Unauthorized

Possible causes:
• API key expired or invalid
• Rate limit exceeded
• eBay API endpoint changed

Recommendations:
1. Check API key in Azure Key Vault
2. Verify API base URL is correct
3. Check rate limit status
4. Fall back to Screenshot+HTML mode

[Retry]  [Switch to Screenshot Mode]
```

---

#### **4. Platform Marketplace Admin View**

**New Admin Screen:** `admin.silentid.co.uk/platforms/marketplace`

Shows all platforms grouped by support status:

```
Platform Marketplace
────────────────────

📊 Fully Supported (API Mode) — 3 platforms
  • eBay (All Regions)
  • Etsy
  • Amazon (Beta)

🤖 Automated Extraction (Screenshot+HTML) — 8 platforms
  • Vinted (UK, US, FR, DE)
  • Depop
  • Facebook Marketplace
  • Poshmark
  • Mercari

⏳ In Development — 2 platforms
  • Instagram (Awaiting API approval)
  • TikTok Shop (Testing selectors)

❌ Manual Only — 1 platform
  • Local Marketplace XYZ (No public profiles)

🔧 Requested by Users — 12 platforms
  • Wallapop (34 requests)
  • Shpock (28 requests)
  • Gumtree (19 requests)
  • ...

[Add New Platform]
```

---

#### **5. Enable/Disable Platform Toggle**

**Quick Toggle for Admins:**

In platform list view, add toggle switch:

```
Platform: Vinted UK
Status: ✅ Enabled  ⚪ Disabled

If disabled:
• New verifications blocked
• Existing verifications show "Last updated: X days ago (verification paused)"
• Users notified: "Vinted verification temporarily unavailable"
```

**Use Cases:**
- Platform API is down → Disable temporarily
- Platform changed HTML drastically → Disable until selectors updated
- Legal issue with platform → Disable until resolved

---

### Database Schema Updates (Section 48)

Add new fields to `PlatformConfigurations` table:

```sql
ALTER TABLE PlatformConfigurations ADD COLUMN rating_source_mode VARCHAR(50) DEFAULT 'screenshot_plus_html';
-- Values: 'api' | 'screenshot_plus_html' | 'unsupported'

ALTER TABLE PlatformConfigurations ADD COLUMN verification_methods_supported JSONB DEFAULT '["token_in_bio"]';
-- Example: ["share_intent", "token_in_bio"]

ALTER TABLE PlatformConfigurations ADD COLUMN api_config JSONB NULL;
-- Example: {"base_url": "...", "auth_type": "oauth", "credentials_location": "azure_key_vault", ...}

ALTER TABLE PlatformConfigurations ADD COLUMN share_intent_patterns JSONB NULL;
-- Example: ["vinted://profile/{username}", "https://vinted.app.link/profile/{username}"]

ALTER TABLE PlatformConfigurations ADD COLUMN token_bio_selector JSONB NULL;
-- Example: {"css": "div.user-bio > p", "xpath": "//div[@class='user-bio']//p[1]"}

ALTER TABLE PlatformConfigurations ADD COLUMN is_enabled BOOLEAN DEFAULT TRUE;
-- Admin can disable platform temporarily

ALTER TABLE PlatformConfigurations ADD COLUMN avg_confidence_score DECIMAL(5,2) NULL;
-- Average confidence across all extractions (calculated weekly)

ALTER TABLE PlatformConfigurations ADD COLUMN last_extraction_at TIMESTAMP NULL;
-- Last successful rating extraction timestamp
```

---

**END OF ADMIN UI ADDITIONS**

---

## 49.17 Integration with Existing Sections

**Section 49 integrates with:**

### **Section 5 (Core Features):**
- Level 3 Verification defined here (49.1-49.17)
- Replaces/extends existing Level 3 spec with Share-Intent primary + Token-in-Bio secondary
- Ownership-first rule (49.2) enforces legal and privacy compliance

### **Section 47 (Digital Trust Passport):**
- Star ratings extracted via Section 49 methods
- Ratings displayed on public Trust Passport
- Confidence levels (49.11) determine display badges

### **Section 48 (Modular Platform Configuration):**
- Section 49.16 adds new fields to PlatformConfigurations table:
  - `rating_source_mode` (api | screenshot_plus_html | unsupported)
  - `verification_methods_supported` (share_intent, token_in_bio)
  - `api_config` (for API-enabled platforms)
  - `share_intent_patterns` (deep link patterns)
  - `token_bio_selector` (CSS/XPath for bio field)
- Admin UI enhanced with API testing, verification method config

### **Section 19 (Help Center):**
- New help article (49.14) added: "Connecting Your Marketplace Profile"
- Uses user-friendly language (no "scraping")
- Explains Share-Intent + Token-in-Bio methods

### **Section 21 (Landing Page):**
- Marketing copy (49.15) added to landing page
- "Bring Your Stars With You" messaging
- Trust Passport value proposition

### **Section 26 (Evidence Integrity Engine):**
- Screenshot integrity checks (49.6) use existing Section 26 tampering detection
- OCR extraction confidence (49.11) feeds into Section 26 integrity scores

### **Section 41 (AI Architecture):**
- OCR extraction (49.6) uses Azure Computer Vision (Layer C - Vision & OCR)
- Screenshot analysis for tampering detection
- Text extraction from manual screenshots (49.10)

### **Section 43 (Consumer Terms):**
- New clause (49.13) added: "Marketplace Profile Verification"
- Ownership declaration requirements
- Data access consent terms

### **Section 44 (Privacy Policy):**
- Update Section 2.3 (Evidence Data) to include:
  - "Public Profile URLs: Marketplace username, ratings, reviews, join date (extracted from public pages after ownership verification)"
  - "Verification Method: Share-Intent or Token-in-Bio ownership proof"

---

**Conflict Resolution:**

**No conflicts** with existing sections. Section 49 is an expansion and modernization of Level 3 Verification, not a replacement.

**Previous Level 3 Specification (if any):**
- If earlier sections mentioned Level 3 Verification, Section 49 supersedes them
- Previous "Token-in-Bio only" approach updated to "Share-Intent primary, Token-in-Bio secondary"
- Previous "scraping-first" approach updated to "ownership-first"

---

**END OF SECTION 49**

---

## SECTION 50 — Strategy to Get Users Into the App

### 50.1 Purpose
A phased, psychological and behavioural strategy to guide new users from first login → value discovery → habit formation → long-term TrustScore growth.

---

### 50.2 Phase 1 – Activation (First 5 Minutes)

**Problem:** New users don't understand what SilentID does or why they should care about their TrustScore.

#### 50.2.1 Interactive Onboarding Tour
- Replace static intro screens with a short, interactive journey.
- Use micro-lessons (20–30 seconds each) with light animations.
- Core messages:
  - "Your TrustScore is your digital reputation passport."
  - "It helps you prove you're a trustworthy person online."
- Trigger: only on first login.

#### 50.2.2 Quick Wins on Home Screen
- Add a progress bar on-boarding checklist:
  1. Verify identity
  2. Connect one external profile
  3. Get first mutual verification
- Each completed step triggers:
  - Haptics
  - Small celebration
  - Visible TrustScore jump

#### 50.2.3 Demo Mode with Realistic Data
- First-time users see a "sample premium profile":
  - TrustScore example (e.g., 650)
  - Sample connected accounts
  - Sample mutual verifications
- CTA: "This could be you in 7 days. Here's how you start."

---

### 50.3 Phase 2 – Engagement (First 2 Weeks)

**Problem:** Users verify identity and then disappear.

#### 50.3.1 Notification Triggers
Implement meaningful push notifications:
- New mutual verification request
- TrustScore milestones
- Weekly TrustScore summary
- Successful external profile verification

#### 50.3.2 Gamifying the TrustScore
Add:
- Progress rings showing category scoring (Evidence, Peer Verification, Identity)
- Nudges:
  - "You have 1 pending verification request"
  - "Complete your remaining connections to boost your score"

#### 50.3.3 Social Proof
Add in-app trust-building:
- "1,200+ users have verified their profiles"
- Recently verified list
- Mini success stories:
  - "Anna improved her TrustScore from 380 → 720 in 3 weeks"

---

### 50.4 Phase 3 – Monetisation (After 2 Weeks)

**Problem:** Users feel the free tier is 'enough'.

#### 50.4.1 Smart Paywall Triggers
Show upgrade modal only when user hits real value points:
- 500+ TrustScore
- 10th piece of evidence
- 5th mutual verification

#### 50.4.2 Clear Value Proposition
Before showing prices, display:
- Free tier benefits
- Premium tier:
  - Unlimited external connections
  - Larger evidence vault
  - Priority support
- Pro tier:
  - API access
  - Advanced analytics
  - Custom trust profiles

#### 50.4.3 Soft Limits (Freemium Lock-In)
Free tier keeps:
- Up to 5 profile connections
- Up to 20 mutual verifications per month
- Up to 250MB evidence storage
Visual counters encourage upgrades without blocking usage.

---

### 50.5 Phase 4 – Retention (After 1 Month)

#### 50.5.1 Weekly Digest
Send automated summaries:
- TrustScore change
- Pending verifications
- Suggested next steps

#### 50.5.2 Retention Badges
Achievements displayed on profile:
- Verified Identity
- Connected External Profile
- First Mutual Verification
- Trust Milestone (750+)
- Multi-platform Verified

#### 50.5.3 Sharing Features
Let users share:
- TrustScore milestone cards
- Profile badge achievements
- Deep links to their public trust profile

#### 50.5.4 Smart Review Request
Ask for an App Store review only when:
- First mutual verification is confirmed
- TrustScore milestone achieved

---

### 50.6 Phase 5 – Network Growth (Referrals)

#### 50.6.1 Referral Program
Reward system:
- "Invite a friend → both get +50 TrustScore bonus once identity is verified."

#### 50.6.2 Mutual Verification Loop
Allow users to easily invite:
- People they've transacted with
- Friends and community members

#### 50.6.3 Community Achievement Badges
Examples:
- "Trusted Community Member"
- "Top Verifier"
- "Most Verified in Your Network"

This creates a natural viral loop.

---

### 50.7 Integration with Existing Sections

**Section 50 integrates with:**

- **Section 5 (Core Features):** Onboarding flow (50.2) aligns with core authentication and verification features
- **Section 19 (Help Center):** Interactive tour content (50.2.1) feeds into Help Center articles
- **Section 39 (App UI):** Home screen checklist (50.2.2), progress rings (50.3.2), and notification system (50.3.1)
- **Section 40 (UI Info Points):** Demo mode (50.2.3) uses Info Point system for education
- **Section 16 (Monetization):** Paywall triggers (50.4) integrate with existing subscription tiers

---

**END OF SECTION 50**

---

## SECTION 51 — Public Trust Passport Sharing, Verified Badge System & TrustScore Visibility Control

### 51.1 Purpose
Provide a universal, platform-safe way for SilentID users to share their digital trust identity.
Support both **link-based sharing** and **visual badge sharing**, and give users **full control** over whether their TrustScore is public or private.

This feature must be easy to understand, simple to use, compliant with all platform restrictions, and integrate into marketing, onboarding, and growth loops.

---

### 51.2 Public Trust Passport (Link Sharing)

SilentID generates a **public identity URL** that contains:
- TrustScore (only if user has chosen public visibility)
- Verification tiers
- Connected profile proofs (privacy-safe)
- Mutual verifications
- Achievement badges
- Limited information when TrustScore is private

The link is classified as a **digital identity profile**, not a commercial link, making it allowed on platforms like:
- Depop (bio)
- eBay (profile)
- Instagram (bio, stories)
- TikTok (bio, posts)
- X/Twitter (bio, tweets)
- LinkedIn (bio, feature section)

If a platform blocks external links (e.g., certain marketplaces), SilentID automatically falls back to image-based sharing.

---

### 51.3 Verified Badge Image (QR-Enabled)

SilentID creates a **premium, shareable badge image** containing:
- "SilentID Verified" header
- User initials / username
- TrustScore (if public)
- Verification tier
- Mutual verification count
- QR code leading to public passport
- Optional dark/light mode variants

Because it is **an image**, it is allowed everywhere, including platforms that block links.

Use Cases:
- Profile photo
- Listing gallery
- WhatsApp/SMS
- Instagram story
- TikTok post
- Facebook groups
- Community forums

Benefits:
- Bypasses link restrictions
- Works across all ecosystems
- Easy to understand visually
- Highly viral

---

### 51.4 Auto Smart Sharing Logic

SilentID detects the user's context and chooses the safest sharing format.

#### **When the platform supports links:**
→ Share public passport URL

#### **When the platform restricts links:**
→ Share the Verified Badge image automatically

#### **When user tries to paste the link into a restricted platform:**
→ App displays friendly fallback:
  "This platform may block links. Use your Verified Badge instead — works everywhere."

#### **When user has TrustScore private:**
→ App automatically shares the "Private Identity Badge".

---

### 51.5 TrustScore Visibility Control (Public or Private)

SilentID provides a visibility toggle:

#### **Public Mode (Default)**
- TrustScore is visible on the Public Passport.
- Badge displays numerical TrustScore.
- QR leads to full identity overview.
- Recommended for users wanting strong trust reputation.

#### **Private Mode**
- TrustScore is hidden from the public passport.
- Badge switches to "SilentID Verified" without numeric score.
- QR leads to a limited identity card:
  - Verified identity status
  - Connected proofs
  - Mutual verifications
- Internally, the TrustScore system still functions for safety and matching.
- User can switch visibility at any time.

#### **Required UI Messages**
- "Your TrustScore belongs to you."
- "Choose what others can see."
- "You can toggle visibility anytime."

---

### 51.6 Marketing & Landing Page Integration

Add a dedicated section to the landing page titled:

#### **"Show Your Trust Anywhere"**

Explain:
- Share your SilentID Public Passport
- Use your Verified Badge where links are blocked
- Prove identity with a scannable QR code
- Works across all platforms and communities
- TrustScore visibility is optional and user-controlled

Showcase:
- Example badge cards (public & private versions)
- Example Trust Passport previews
- QR scan demonstration
- IG/TikTok bio examples
- User testimonials

Marketing Messages:
- "One identity. Everywhere."
- "Prove who you are instantly."
- "Your trust, in your control."

---

### 51.7 In-App UX & Education

Add:
- "How sharing works" walkthrough
- Tooltip explaining private vs public TrustScore
- Preview showing both badge modes
- Mini-demo showing QR scan in action
- Help-centre article:
  "How to Share Your SilentID Public Trust Passport"

---

### 51.8 Growth Loop

Each shared badge or passport includes:
- QR linking back to SilentID
- User's identity/verification summary
- Small footer:
  "Public Trust Identity — Verified via SilentID"
  (non-commercial, allowed everywhere)

This produces organic viral growth without violating the rules of major platforms.

---

### 51.9 Integration with Existing Sections

**Section 51 integrates with:**

- **Section 21 (Landing Page):** "Show Your Trust Anywhere" section added to marketing copy (51.6)
- **Section 19 (Help Center):** New help article for sharing Trust Passport (51.7)
- **Section 47 (Digital Trust Passport):** Public/private visibility modes extend existing passport functionality
- **Section 50 (User Growth Strategy):** Badge sharing creates viral loop for Phase 5 (Network Growth)
- **Section 39 (App UI):** Share controls and visibility toggle in Profile/Settings screens
- **Section 40 (UI Info Points):** Education tooltips for public vs private modes (51.7)

---

**END OF SECTION 51**

---
## END OF MASTER SPECIFICATION

This document contains the complete, authoritative specification for SilentID.

**Updated Sections:**
- **Section 14:** SilentID Admin Dashboard (Complete System Design)
- **Section 15:** SilentID Security Center (Full Feature Specification)
- **Section 16:** Monetization — Security Center Integration
- **Section 17:** Safe Development Rules (Mandatory)
- **Section 18:** Domain Structure (Official Configuration)
- **Section 19:** SilentID Help Center System (Auto-Generated Support Content)
- **Section 20:** Critical System Requirements (Missing Items)
- **Section 21:** SilentID Landing Page (Sync Rules & Specification)
- **Section 22:** Partner TrustSignal API (External Integration)
- **Section 23:** QR Trust Passport System
- **Section 24:** TrustScore Appeal & Review System
- **Section 25:** Risk & Anomaly Signals (Detailed Specification)
- **Section 26:** Evidence Integrity Engine
- **Section 27:** Evidence Deletion & Evidence Lifecycle
- **Section 28:** Admin Roles, Permissions & Audit Logging
- **Section 29:** Security Alerts & Notifications
- **Section 30:** Web & Desktop Access Rules
- **Section 31:** Internationalisation (i18n) Plan
- **Section 32:** Data Retention & Privacy Durations
- **Section 33:** Legal Documents Plan (T&Cs, Privacy, Cookies)
- **Section 34:** Performance, Rate Limiting & Scalability Requirements
- **Section 35:** Backup, Resilience & Disaster Recovery
- **Section 36:** Security Incident & Breach Response
- **Section 37:** Fraud Case Bundling & Cross-Platform Pattern Detection
- **Section 38:** Business / Professional Profiles (Future Extension)
- **Section 39:** SilentID App UI — Profile, Settings & Navigation Rules
- **Section 40:** UI Info Points & In-App Education System
- **Section 41:** AI Architecture & Model Usage (Azure-Hosted)
- **Section 42:** SilentID Legal & Compliance Overview (Consumer) — NEW (Publication-Ready)
- **Section 43:** SilentID Consumer Terms of Use — NEW (Publication-Ready)
- **Section 44:** SilentID Privacy Policy (UK GDPR-Aligned) — NEW (Publication-Ready)
- **Section 45:** SilentID Cookie & Tracking Policy — NEW (Publication-Ready)
- **Section 46:** About SilentID – About Us / Legal Imprint — NEW (Publication-Ready)
- **Section 47:** SilentID Digital Trust Passport — Public Profile & Star Display Rules — NEW



**Document Version:** 1.8.0
**Last Updated:** 2025-11-23
**Created:** 2025-11-21
**Purpose:** Master reference for SilentID development
- For all future SilentID and SilentSale work, only read specific sections of CLAUDE.md on demand. Never load the entire file.