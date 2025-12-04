# SILENTID / SILENTSALE - WORKING SPECIFICATION

**Version:** 2.0.0 (Simplified)
**Company:** SILENTSALE LTD (Company No. 16457502, England & Wales)
**Full Specification:** See CLAUDE_FULL.md (do NOT load entire file - open specific sections only)

---

## WHAT IS SILENTID?

**SilentID** is **reputation insurance for online sellers**. It backs up your hard-earned ratings from Vinted, eBay, Depop, and other marketplaces—so if the worst happens (account ban, platform shutdown, unfair removal), you have permanent proof of who you really are.

**Core Value Proposition:**
- "Never lose your reputation again"
- "Your stars, backed up forever"
- "Reputation insurance for serious sellers"

**Core Technology Stack:**
- Frontend: Flutter (iOS + Android)
- Backend: ASP.NET Core Web API
- Database: PostgreSQL
- Auth: 100% Passwordless (Apple Sign-In, Google Sign-In, Passkeys, Email OTP)
- Identity Verification: Stripe Identity
- Billing: Stripe Billing
- Primary Color: Royal Purple #5A3EB8

**Key Principles:**
- NO passwords stored - ever
- NO ID documents stored - Stripe Identity handles this
- Profile-based trust - verified external profiles from marketplaces
- Aggregated rating - combined star rating from all platforms
- Anti-fraud first - comprehensive risk engine
- GDPR compliant - privacy by design

---

## WHAT IS SILENTSALE?

**SilentSale** is a **separate marketplace platform** under development by SILENTSALE LTD.

**MVP Status:** NOT integrated with SilentID in MVP. SilentID is standalone.

**Relationship:**
- Both products owned by SILENTSALE LTD
- Same Stripe account used for both
- Future integration planned post-MVP (SilentID will connect to SilentSale marketplace for secondhand goods)

---

## KEY FLOWS

### 1. AUTHENTICATION (100% PASSWORDLESS)

**Supported Methods:** Apple Sign-In, Google Sign-In, Passkeys (WebAuthn/FIDO2), Email OTP

**FORBIDDEN:** Password creation, password login, password reset

**Single-Account Rule:** One email = one account. Duplicate detection enforced.

### 2. LEVEL 3 PROFILE VERIFICATION

**Purpose:** Prove ownership of external marketplace profiles (Vinted, eBay, Depop, Instagram, etc.)

**Methods:** Token-in-Bio (add code to profile) or Share-Intent (mobile deep link)

**After Verification:** Profile locked, star ratings extracted for Trust Passport

### 3. TRUSTSCORE ENGINE (0-1000)

**Calculation Formula:**
```
TrustScore = Identity + Profiles + Behaviour (max 1000)
```

**Components:**
- **Identity (300 pts):** Email verification, Stripe Identity verification, passkey setup
- **Profiles (400 pts):** Verified profile links from marketplaces and social platforms
- **Behaviour (300 pts):** Account age, login patterns, platform engagement, risk signals

**Labels:** 850-1000 Exceptional | 700-849 Very High | 550-699 High | 400-549 Moderate | 250-399 Low | 0-249 High Risk

**Regenerates weekly.**

### 4. SUBSCRIPTION MODEL (FREE + PRO)

**Two tiers only:**

**Free (£0 forever):**
- Identity verification via Stripe
- Basic TrustScore (0-1000)
- Connect up to 5 marketplace profiles
- Public Trust Passport URL
- Basic verified badge for social profiles
- File safety reports

**Pro (£4.99/month) - Full Reputation Protection:**
- Everything in Free
- Unlimited profile connections
- Premium verified badge with QR code and combined star rating
- **Combined star rating** from all platforms (e.g., "4.8★ across 5 platforms")
- **Rating drop alerts** - instant notification if any rating changes
- **Trust timeline** - historical graph of your reputation over time
- **Dispute evidence pack** - legal-ready PDF proof of your reputation history
- **Platform watchdog** - alerts when markets have mass bans/shutdowns
- Custom passport URL (silentid.co.uk/your-name)
- Priority verification & support

### 5. PUBLIC TRUST PASSPORT & VERIFIED BADGE

**Trust Passport:** Users share their identity via a public link (silentid.co.uk/u/username) or QR code. Shows TrustScore, verified platforms, combined rating, and badges.

**Verified Badge for Social Profiles (Self-Explanatory Design):**
- Shareable badge image optimized for Instagram/Twitter/LinkedIn bios
- Contains QR code linking to full Trust Passport
- **Self-explanatory proof** - shows actual data without needing SilentID recognition:
  - Combined star rating (e.g., "4.8★")
  - Platform count (e.g., "5 Platforms")
  - ID Verified checkmark
  - TrustScore (if public)
- Available in light/dark modes and multiple sizes (profile, story, card)
- One-tap download and share to any platform
- Works even if viewers don't know what SilentID is

### 6. UNIFIED PROFILE LINKING & PLATFORM VERIFICATION

SilentID lets users connect any external profile (Instagram, TikTok, LinkedIn, Depop, eBay, Discord, etc.) using a simple link-first flow. Profiles appear as **Linked** (user added) or **Verified** (SilentID confirmed ownership via token). Verified profiles boost TrustScore; users control what is shown on their public Passport.

**Supported Platforms:**
- **Marketplaces:** Vinted, eBay, Depop, Etsy, Poshmark, Facebook Marketplace
- **Social:** Instagram, TikTok, Twitter/X, YouTube, LinkedIn
- **Professional:** GitHub, Behance, Dribbble
- **Gaming:** Discord, Twitch, Steam
- **Community:** Reddit, other platforms

### 7. SILENTID UI DESIGN LANGUAGE

SilentID uses a locked, premium Apple-style UI based on unified spacing (16px grid), card shapes, typography (Inter font), info-points, and scrollable sections. Royal Purple #5A3EB8 for accents only. All screens comply with Section 53 design system. **All UI generation MUST reference Section 53.**

### 8. LOGIN, DEVICES & SESSION SECURITY

**100% passwordless authentication** with intelligent method selection: Passkey → Apple/Google → Email OTP (fallback only). New or suspicious devices trigger step-up authentication using stronger methods. Sessions are short-lived, device-bound (fingerprint + app version), and renew silently only on trusted devices.

### 9. SHARE TARGET INTEGRATION

SilentID is a **native share target** on both iOS and Android. Users can share profile links from any app (Safari, Chrome, Vinted, eBay, Instagram, etc.) directly to SilentID.

**How it works:**
1. User taps "Share" on any profile link in another app
2. Selects "Import to SilentID" from share sheet
3. SilentID detects the platform (Vinted, eBay, Instagram, etc.)
4. Shows "Profile Link Detected" modal with Connect option
5. Routes to Connect Profile flow with pre-filled data

---

## GLOBAL RULES (MANDATORY)

### Critical System Rules

1. **NO PASSWORDS:** SilentID NEVER stores passwords. All authentication is passwordless.
2. **NO ID DOCUMENTS:** Stripe Identity handles verification. SilentID stores ONLY the result.
3. **EMAIL = IDENTITY ANCHOR:** One email per account. Duplicate detection enforced.
4. **OWNERSHIP FIRST:** NEVER extract data from marketplace profile until ownership verified.
5. **DEFAMATION-SAFE LANGUAGE:** Never say "scammer", "fraudster". Use "safety concern flagged", "risk signals detected".
6. **LEVEL 3 FOR TRUST BOOST:** Only Level 3 verified profiles contribute maximum points to TrustScore.
7. **TWO TIERS ONLY:** Free and Pro. No other subscription tiers.

---

## FOR FULL DETAILS

**DO NOT load CLAUDE_FULL.md into the chat in its entirety.**

Instead:
- Open specific sections from CLAUDE_FULL.md only when needed
- Use Grep to search for specific topics
- Read specific line ranges using offset/limit parameters

**Full master specification:** CLAUDE_FULL.md

---

**END OF WORKING SPECIFICATION**
