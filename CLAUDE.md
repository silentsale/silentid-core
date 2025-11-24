# SILENTID - MASTER SPECIFICATION DOCUMENT

**Version:** 1.7.0
**Last Updated:** 2025-11-23
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



**Document Version:** 1.8.0
**Last Updated:** 2025-11-23
**Created:** 2025-11-21
**Purpose:** Master reference for SilentID development
