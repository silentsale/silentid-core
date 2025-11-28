# SILENTID / SILENTSALE - WORKING SPECIFICATION

**Version:** 1.8.0 (Condensed)
**Company:** SILENTSALE LTD (Company No. 16457502, England & Wales)
**Full Specification:** See CLAUDE_FULL.md (do NOT load entire file - open specific sections only)

---

## WHAT IS SILENTID?

**SilentID** is a standalone **passwordless trust-identity application** that allows users to build a portable reputation profile across marketplaces, dating apps, rental platforms, and community groups.

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
- Evidence-based trust - receipts, screenshots, public profiles
- Anti-fraud first - comprehensive risk engine
- GDPR compliant - privacy by design

---

## WHAT IS SILENTSALE?

**SilentSale** is a **separate marketplace platform** under development by SILENTSALE LTD.

**MVP Status:** NOT integrated with SilentID in MVP. SilentID is standalone.

**Relationship:**
- Both products owned by SILENTSALE LTD
- Same Stripe account used for both
- Future integration planned post-MVP

---

## KEY FLOWS

### 1. AUTHENTICATION (100% PASSWORDLESS)

**Supported Methods:** Apple Sign-In, Google Sign-In, Passkeys (WebAuthn/FIDO2), Email OTP

**FORBIDDEN:** Password creation, password login, password reset

**Single-Account Rule:** One email = one account. Duplicate detection enforced.

### 2. LEVEL 3 PROFILE VERIFICATION

**Purpose:** Prove ownership of external marketplace profiles (Vinted, eBay, Depop)

**Methods:** Token-in-Bio (add code to profile) or Share-Intent (mobile deep link)

**After Verification:** Profile locked, star ratings extracted for Trust Passport

### 3. TRUSTSCORE ENGINE (0-1000)

**Calculation Formula:**
```
Raw Score = Identity + Evidence + Behaviour + Peer + URS (max 1200)
Final TrustScore = (Raw Score / 1200) × 1000
```

**Components:** Identity (200), Evidence (300), Behaviour (300), Peer (200), URS (200)

**Labels:** 850-1000 Exceptional | 700-849 Very High | 550-699 High | 400-549 Moderate | 250-399 Low | 0-249 High Risk

**Regenerates weekly.**

### 4. USER GROWTH STRATEGY

**5 Phases (Section 50):**

- **Phase 1 - Activation (5 min):** Interactive onboarding tour, quick wins checklist, demo mode
- **Phase 2 - Engagement (2 weeks):** Push notifications, TrustScore gamification, social proof
- **Phase 3 - Monetization (2+ weeks):** Smart paywall triggers at value points (500+ score, 10th evidence)
- **Phase 4 - Retention (1+ month):** Weekly digest, achievement badges, sharing features
- **Phase 5 - Network Growth:** Referral bonuses (+50 TrustScore), viral loop mechanics

### 5. PUBLIC TRUST PASSPORT SHARING & VISIBILITY

Users can share their identity via a public link or a QR-enabled Verified Badge image. Smart fallback chooses the correct format depending on platform restrictions. TrustScore can be public or private; badges and passport adapt automatically. Includes landing-page marketing, QR demos, and in-app education.

### 6. UNIFIED PROFILE LINKING & PLATFORM VERIFICATION

SilentID lets users connect any external profile (Instagram, TikTok, LinkedIn, Depop, eBay, Discord, etc.) using a simple link-first flow. Profiles appear as **Linked** (user added) or **Verified** (SilentID confirmed ownership via token or screenshot). Clear info-points explain everything. Verified profiles boost TrustScore; users control what is shown on their public Passport.

### 7. SILENTID UI DESIGN LANGUAGE

SilentID uses a locked, premium Apple-style UI based on unified spacing (16px grid), card shapes, typography (Inter font), info-points, and scrollable sections. Royal Purple #5A3EB8 for accents only. All screens comply with Section 53 design system. **All UI generation MUST reference Section 53.**

---

## GLOBAL RULES (MANDATORY)

### Critical System Rules

1. **NO PASSWORDS:** SilentID NEVER stores passwords. All authentication is passwordless.
2. **NO ID DOCUMENTS:** Stripe Identity handles verification. SilentID stores ONLY the result.
3. **EMAIL = IDENTITY ANCHOR:** One email per account. Duplicate detection enforced.
4. **OWNERSHIP FIRST:** NEVER extract data from marketplace profile until ownership verified.
5. **DEFAMATION-SAFE LANGUAGE:** Never say "scammer", "fraudster". Use "safety concern flagged", "risk signals detected".
6. **EVIDENCE VAULT CAP:** Max 15% of TrustScore (45 points). Cannot override verified behavior.
7. **LEVEL 3 ONLY FOR URS:** Only Level 3 verified profiles contribute to Universal Reputation Score.

---

## FOR FULL DETAILS

**DO NOT load CLAUDE_FULL.md into the chat in its entirety.**

Instead:
- Open specific sections from CLAUDE_FULL.md only when needed
- Use Grep to search for specific topics
- Read specific line ranges using offset/limit parameters

**Full master specification:** CLAUDE_FULL.md (443.8KB)

---

**END OF WORKING SPECIFICATION**