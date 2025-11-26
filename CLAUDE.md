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

**Supported Methods (ONLY these 4):**
1. Apple Sign-In - Standard Apple OAuth
2. Google Sign-In - Standard Google OAuth
3. Passkeys (WebAuthn/FIDO2) - Face ID, Touch ID, biometrics
4. Email OTP - 6-digit one-time code

**FORBIDDEN:**
- ❌ Password creation
- ❌ Password login
- ❌ "Set password" or "change password" flows
- ❌ Password reset / forgot password

**Single-Account Rule:**
- One email = one SilentID account
- Duplicate detection via device fingerprinting, IP patterns
- Account merging available for legitimate users only

### 2. LEVEL 3 PROFILE VERIFICATION

**Purpose:** Cryptographically prove ownership of external marketplace profiles (Vinted, eBay, Depop, etc.)

**Two Verification Methods:**

**Method A: Token-in-Bio**
1. User generates unique token: `SILENTID-VERIFY-{random-8-chars}`
2. User adds token to marketplace profile bio
3. User confirms "I've added the code"
4. SilentID verifies token presence via automated check
5. Ownership verified ✓

**Method B: Share-Intent** (Mobile)
1. User shares marketplace profile URL from app
2. User confirms "This is my profile"
3. Device fingerprint validated
4. Ownership verified ✓

**After Verification:**
- Profile locked (cannot be claimed by another user)
- Star ratings extracted and displayed on Digital Trust Passport
- Profile snapshot hash stored for integrity

### 3. TRUSTSCORE ENGINE (0-1000)

**Calculation Formula:**
```
Raw Score = Identity + Evidence + Behaviour + Peer + URS (max 1200)
Final TrustScore = (Raw Score / 1200) × 1000
```

**5-Component Breakdown:**
- **Identity (200 pts):** Stripe verification, email verified, phone verified
- **Evidence (300 pts):** Receipts, screenshots, public profile data (capped at 15% per vault)
- **Behaviour (300 pts):** No reports, on-time patterns, account longevity
- **Peer Verification (200 pts):** Mutual endorsements, returning partners
- **URS - Universal Reputation Score (200 pts):** Cross-platform ratings from Level 3 verified profiles

**Score Labels:**
- 850–1000: Exceptional Trust
- 700–849: Very High Trust
- 550–699: High Trust
- 400–549: Moderate Trust
- 250–399: Low Trust
- 0–249: High Risk

**Regenerates weekly.**

---

## GLOBAL RULES (MANDATORY)

### Section 0: Claude Behavior - Vibe Coding Mode

**Core Rules:**
1. **Tiny steps only** - small, digestible chunks
2. **Always explain in simple language** - no jargon without translation
3. **No assumptions about user knowledge** - explain everything
4. **Explicit step boundaries** - clear labeling and expectations
5. **Interactive loop** - explain → action → expected result → wait for confirmation
6. **Error handling** - never ignore, always explain and fix
7. **No big leaps** - many small verify-as-you-go steps

**Tone:** Calm, professional, reassuring, respectful, non-patronizing

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