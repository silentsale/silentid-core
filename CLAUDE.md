# SILENTID - MASTER SPECIFICATION DOCUMENT

**Version:** 1.0.0
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

---

## PROJECT OVERVIEW

**SilentID** is a standalone passwordless trust-identity application that allows users to build a portable reputation profile across marketplaces, dating apps, rental platforms, and community groups.

### Core Technology Stack
- **Frontend:** Flutter (iOS + Android)
- **Backend:** ASP.NET Core Web API
- **Database:** PostgreSQL (Local dev, Azure prod later)
- **Auth:** Passwordless (Email OTP + Passkeys)
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
2. **Authentication** (Passwordless + Passkeys)
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

### Authentication System (Bank-Grade Passwordless)
**Supported Methods:**
1. **Email OTP (Primary):** Enter email → 6-digit code → logged in
2. **Passkeys (WebAuthn/FIDO2):** Optional setup with Face ID/Touch ID/Windows Hello/Android Biometrics
3. **Magic Link (Fallback):** Email link for one-time login

**NOT Allowed:**
- Passwords
- SMS-only login (SMS allowed as fallback 2FA, not primary)

**Security:**
- Short-lived access tokens
- Refresh tokens in secure local storage
- Intercept suspicious/repeated OTP attempts
- Device fingerprinting

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
- Buttons: "Continue with Email" (primary), "Use a Passkey" (secondary)
- Footer: "By continuing, you agree to SilentID's Terms & Privacy Policy."

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

## END OF MASTER SPECIFICATION

This document contains the complete, authoritative specification for SilentID.

**Next Steps:**
1. Answer the 18 mandatory questions from Section 13
2. Confirm readiness to proceed
3. Begin Phase 0: Environment Setup

**Document Version:** 1.0.0
**Created:** 2025-11-21
**Purpose:** Master reference for SilentID development

---
