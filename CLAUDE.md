# SILENTID - MASTER SPECIFICATION DOCUMENT

**Version:** 1.3.0
**Last Updated:** 2025-11-21
**Status:** Pre-Development - Complete Specification

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
- Connection: Gmail OAuth, Outlook OAuth, IMAP, Forward to my@silentid.app
- Parsing: date, platform, amount, item, buyer/seller role, order ID
- AI fraud checks: fake headers, DKIM, SPF, hash detection

**2. Screenshot OCR:**
- Upload: marketplace reviews, profile stats, sales history, ratings, badges
- Processing: Azure OCR, image forensics, screen consistency checks, metadata verification
- Must be tamper-resistant

**3. Public Profile URL Scraper:**
- Input: Vinted, Depop, eBay, Etsy, Facebook Marketplace, LinkedIn URLs
- Scraping: Playwright-based, headless, rate-limited, anti-fraud aware
- Extracts: ratings, review count, join date, listing patterns, username consistency

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
- **Section 21:** SilentID Landing Page (Sync Rules & Specification) — NEW

**Next Steps:**
1. Answer the 18 mandatory questions from Section 13
2. Confirm readiness to proceed
3. Begin Phase 0: Environment Setup

**Document Version:** 1.4.0
**Last Updated:** 2025-11-21
**Created:** 2025-11-21
**Purpose:** Master reference for SilentID development

---
- You are an ORCHESTRATOR and TEAM LEAD for the SilentID project.

Your job is to spin up and coordinate FOUR specialist agents that work IN PARALLEL using all available MCP tools (filesystem, code index, git, http, playwright, etc.).

Very important:
- SilentID already has some code and specs.
- Before changing anything, agents MUST check what is already implemented and documented.
- Agents must not duplicate work; they must extend and improve what exists.

====================
PROJECT CONTEXT
====================

Product: SilentID – a standalone, bank-grade, passwordless “trust passport” app.

Key points:
- 100% PASSWORDLESS. No passwords anywhere in code or UI.
- Allowed auth methods ONLY:
  1) Apple Sign-In
  2) Google Sign-In
  3) Passkeys (WebAuthn / FIDO2)
  4) Email OTP (6-digit code)

- Backend: ASP.NET Core Web API
- Database: PostgreSQL (local DB in dev)
- Frontend: Flutter (iOS + Android)
- Identity verification: Stripe Identity
- Subscriptions: Stripe Billing (Free / Premium / Pro)
- Hosting: local dev for now; Azure later
- Critical: Anti-duplicate-account logic (one real person = one SilentID account).

Use the existing repo and docs as the source of truth. Wherever possible, follow the design already captured in claude.md / ARCHITECTURE files, and only change them deliberately.

====================
AGENT SETUP
====================

Create and coordinate these 4 agents:

1) AGENT A – ARCHITECT & COORDINATOR
   - Responsibilities:
     - First, use filesystem/code-index MCPs to scan the repo:
       - Find existing docs (claude.md, ARCHITECTURE.md, PRDs, etc.)
       - Find existing backend and frontend structure.
       - Produce a concise summary of “what is already implemented” in a central doc.
     - Maintain and update a single architecture file (e.g. /docs/ARCHITECTURE.md).
     - Maintain a shared task board (e.g. /docs/TASK_BOARD.md) with small, clear tickets for Agents B, C, D.
     - Define and keep API contracts and data models consistent between backend and frontend.
     - Resolve conflicts if agents disagree (Architect makes final decision, updates docs).
     - Regularly ask other agents to report progress and integrate their findings into the docs.

2) AGENT B – BACKEND & SECURITY ENGINEER
   - Responsibilities:
     - Use code-index/filesystem MCPs to examine existing ASP.NET backend and DB migrations.
       - Identify what endpoints, models, and auth flows already exist.
       - Do NOT re-implement features that are already there; extend/refactor them if needed.
     - Enforce passwordless auth (Apple, Google, Passkey, OTP) and remove any password-related remnants if present.
     - Implement and/or refine:
       - User model (no password fields).
       - IdentityVerification (Stripe Identity).
       - Evidence models and endpoints (receipts, screenshots, profile links).
       - Mutual transaction verification APIs.
       - TrustScore and RiskSignals logic.
       - Anti-duplicate-account logic (email as primary anchor, linking providers, device/IP checks).
     - Keep DB schema in sync with architecture docs and update migrations when needed.
     - After each change, write a short entry in /docs/BACKEND_CHANGELOG.md describing:
       - What changed
       - Which files were touched
       - How to test it (exact HTTP calls).

3) AGENT C – FRONTEND & UX ENGINEER (FLUTTER)
   - Responsibilities:
     - Use filesystem/code-index MCPs to inspect the existing Flutter project:
       - What screens, routes, and services exist already?
       - What auth UI is already wired?
     - Do not create duplicate screens; extend or clean up what’s already there.
     - Implement/complete:
       - Onboarding + auth flows for Apple, Google, Passkey, and Email OTP only.
       - Bottom navigation with 4 tabs: Home, Evidence, Verify, Settings.
       - Real API integration for login, TrustScore, evidence lists, mutual verifications, and settings.
     - Apply the brand:
       - Primary colour: royal purple #5A3EB8
       - Bank-grade, secure look (no cartoonish styles).
     - Document all added/updated screens in /docs/FRONTEND_NOTES.md, including:
       - Screen name
       - Route
       - API dependencies
       - Current TODOs.

4) AGENT D – QA, TEST & AUTOMATION
   - Responsibilities:
     - Use MCP tools (http, playwright/browser, code-index, etc.) to:
       - Probe backend endpoints and validate responses.
       - Confirm auth flows behave correctly (no passwords; only allowed methods).
       - Check for duplicate-account edge cases where the same email/provider could create multiple users.
     - Maintain /docs/QA_CHECKLIST.md with:
       - Test cases
       - Manual and automated checks
       - Bugs found and which agent should fix them.
     - Ensure that each major feature added by B and C has at least:
       - One happy-path test
       - One basic failure/edge-case test
     - Alert Architect (Agent A) when behaviour deviates from the spec so docs and code can be reconciled.

====================
WORKING MODE
====================

- All four agents must run CONCURRENTLY and COOPERATIVELY.
- Before starting new work, each agent must ALWAYS:
  - Check existing code and docs using MCP tools.
  - Confirm whether the feature already exists or partially exists.
  - Only then decide whether to extend, refactor, or add.

- Agents must frequently sync via:
  - ARCHITECTURE.md
  - TASK_BOARD.md
  - BACKEND_CHANGELOG.md
  - FRONTEND_NOTES.md
  - QA_CHECKLIST.md

- No agent is allowed to make major changes that contradict ARCHITECTURE.md without:
  - Updating the doc
  - Informing others via the task board

====================
FIRST STEPS
====================

1. Architect (Agent A):
   - Scan repo and docs via MCP.
   - Summarise current status: what backend, frontend, and infra already exist.
   - Create or update /docs/ARCHITECTURE.md and /docs/TASK_BOARD.md.

2. Backend (Agent B), Frontend (Agent C), QA (Agent D):
   - Each scans existing code with code-index/filesystem MCPs.
   - Each writes a short “CURRENT STATE” section into their own doc:
     - BACKEND_CHANGELOG.md (overview at top)
     - FRONTEND_NOTES.md (overview at top)
     - QA_CHECKLIST.md (what can already be tested).

3. Architect then:
   - Breaks next tasks into small items.
   - Assigns them on TASK_BOARD.md to B, C, D.
   - Ensures no duplication of effort.

Proceed now as the orchestrator: create and coordinate these 4 agents, run them in parallel, and start with the discovery phase (what already exists) before implementing new features.
 recconect any mcp if they are not connected and you need to use them. it is a must you need to recconect the mcp servers if they are disconnected.