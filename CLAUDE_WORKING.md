# SILENTID Working Reference

> **Important**: This is a compact summary. Full specifications are in `CLAUDE.md`. Only load specific sections when needed.

---

## What is SilentID?

**SilentID** is a standalone passwordless trust-identity platform. Users build a portable reputation profile (TrustScore 0-1000) across marketplaces, dating apps, rental platforms, and communities.

**Core Promise**: "Honest people rise. Scammers fail."

**What SilentID is NOT**: Credit agency, background check service, or marketplace.

---

## What is SilentSale?

**SilentSale** is a separate marketplace platform under SILENTSALE LTD. **NOT integrated in MVP** - SilentID is built standalone first.

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter (iOS + Android) |
| Backend | ASP.NET Core Web API |
| Database | PostgreSQL |
| Auth | 100% Passwordless (Apple, Google, Passkeys, Email OTP) |
| Identity | Stripe Identity |
| Billing | Stripe Billing |
| Storage | Azure Blob Storage |

---

## Key Architecture Flows

### Authentication (100% Passwordless)
- Apple Sign-In, Google Sign-In, Passkeys, Email OTP only
- **NO passwords anywhere** - forbidden in database and UI
- Single account per email (duplicate detection enforced)
- See: `CLAUDE.md Section 5 - Authentication`

### TrustScore Engine (0-1000)
Five components, normalized from 1200 raw points:
- **Identity (200 pts)**: Stripe verification, email/phone verified
- **Evidence (300 pts)**: Receipts, screenshots, profile links
- **Behaviour (300 pts)**: No reports, account longevity
- **Peer (200 pts)**: Mutual verifications
- **URS (200 pts)**: Cross-platform ratings from Level 3 profiles
- See: `CLAUDE.md Section 3 & 5 - TrustScore Engine`

### Evidence Collection
Three streams:
1. **Email Receipts**: Forwarding alias model (Expensify-style)
2. **Screenshots**: OCR + integrity checks
3. **Profile Links**: Level 1/2/3 verification
- See: `CLAUDE.md Section 5 - Evidence Collection`

### Level 3 Verification (Profile Ownership)
- **Share-Intent** (PRIMARY): User shares profile URL from app
- **Token-in-Bio** (SECONDARY): User adds `SILENTID-VERIFY-{8chars}` to bio
- Ownership locks profile to one SilentID account
- 90-day re-verification required
- See: `CLAUDE.md Section 49 - Level 3 Verification`

### User Growth Strategy (5 Phases)

- **Phase 1 - Activation (5 min)**: Interactive onboarding, quick wins checklist, demo mode
- **Phase 2 - Engagement (2 weeks)**: Push notifications, gamification, social proof
- **Phase 3 - Monetization (2+ weeks)**: Smart paywall at 500+ score, 10th evidence
- **Phase 4 - Retention (1+ month)**: Weekly digest, badges, sharing features
- **Phase 5 - Network Growth**: Referrals (+50 TrustScore bonus), viral loop
- See: `CLAUDE.md Section 50 - User Growth Strategy`

### Anti-Fraud Engine
9 layers including: evidence integrity, device fingerprinting, collusion detection, RiskScore (0-100)
- See: `CLAUDE.md Section 7 & 25 - Anti-Fraud`

---

## Database Core Tables

| Table | Purpose |
|-------|---------|
| Users | Account data, auth methods |
| IdentityVerification | Stripe verification status |
| ReceiptEvidence | Email receipt metadata |
| ScreenshotEvidence | Uploaded screenshots + OCR |
| ProfileLinkEvidence | Marketplace profile links + Level 3 fields |
| MutualVerifications | Peer confirmations |
| TrustScoreSnapshots | Weekly score history |
| RiskSignals | Fraud detection flags |

See: `CLAUDE.md Section 8 - Database Schema`

---

## API Endpoint Groups

1. Auth & Session (`/v1/auth/*`)
2. Identity Verification (`/v1/identity/*`)
3. User Profile (`/v1/users/*`)
4. Evidence (`/v1/evidence/*`)
5. Mutual Verifications (`/v1/mutual-verifications/*`)
6. TrustScore (`/v1/trustscore/*`)
7. Public Profile (`/v1/public/*`)
8. Safety Reports (`/v1/reports/*`)
9. Subscriptions (`/v1/subscriptions/*`)
10. Admin (`/v1/admin/*`)

See: `CLAUDE.md Section 9 - API Endpoints`

---

## Subscription Tiers

| Tier | Price | Vault | Key Features |
|------|-------|-------|--------------|
| Free | £0 | 250MB | 10 receipts, 5 screenshots, 2 profiles |
| Premium | £4.99/mo | 100GB | Unlimited evidence, analytics |
| Pro | £14.99/mo | 500GB | Bulk checks, evidence packs, certificates |

See: `CLAUDE.md Section 12 & 16 - Monetisation`

---

## Current MVP Tasks

### Implementation Priority
1. Core passwordless auth flows
2. Stripe Identity integration
3. Evidence upload APIs (receipts, screenshots, profiles)
4. Level 3 verification (Share-Intent + Token-in-Bio)
5. TrustScore calculation engine
6. Public profile display
7. Flutter mobile app (iOS + Android)

### Section 49 Implementation Status
**Already Implemented** (in `EvidenceService.cs`):
- `GenerateVerificationTokenAsync`
- `ConfirmTokenInBioAsync`
- `VerifyShareIntentAsync`
- `IsProfileAlreadyVerifiedByAnotherUserAsync`
- Helper methods (hash, normalize URL)

**Gaps to Implement**:
- Platform scraping/extraction logic
- Screenshot + OCR extraction
- Manual screenshot upload (3 max)
- Confidence scoring system
- Platform configuration system (Section 48)

---

## Key CLAUDE.md Section References

| Topic | Section |
|-------|---------|
| Project Overview | Section 0-3 |
| Legal & Compliance | Section 4, 42-46 |
| Core Features | Section 5 |
| Feature Flows & UI Copy | Section 6 |
| Anti-Fraud Engine | Section 7 |
| Database Schema | Section 8 |
| API Endpoints | Section 9 |
| Frontend Architecture | Section 10 |
| Build Phases | Section 11 |
| Monetisation | Section 12, 16 |
| Admin Dashboard | Section 14 |
| Security Center | Section 15 |
| Help Center | Section 19 |
| Critical Requirements | Section 20 |
| Partner API | Section 22 |
| Risk Signals | Section 25 |
| Evidence Integrity | Section 26 |
| Admin Roles | Section 28 |
| UI Navigation Rules | Section 39 |
| UI Info Points | Section 40 |
| AI Architecture | Section 41 |
| Digital Trust Passport | Section 47 |
| Platform Configuration | Section 48 |
| Level 3 Verification | Section 49 |
| User Growth Strategy | Section 50 |

---

## Development Rules Reminder

- **Read CLAUDE.md sections on demand** - never load entire file
- **Ownership-first rule**: Never extract profile data before ownership verified
- **Defamation-safe language**: Never say "scammer" - use "safety concern flagged"
- **No "scraping" in user-facing copy**: Use "check your public profile"
- **Evidence Vault max 15% of TrustScore** (45 pts cap)
- **All admin actions logged** in AdminAuditLogs

See: `CLAUDE.md Section 17 - Safe Development Rules`

---

## Domain Structure

- **Main**: silentid.co.uk
- **API**: api.silentid.co.uk
- **Admin**: admin.silentid.co.uk
- **Company**: SILENTSALE LTD (Company No. 16457502)

---

*Last Updated: 2025-11-26 (Added Section 50 - User Growth Strategy)*
*Full Spec: CLAUDE.md v1.8.0*
