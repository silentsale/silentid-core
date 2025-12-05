<div align="center">

# 🔐 SilentID

### Your Portable Trust Passport for the Digital World

**100% Passwordless • Evidence-Based • Privacy-First • GDPR-Compliant**

[![Status](https://img.shields.io/badge/status-pre--production-orange)]()
[![Version](https://img.shields.io/badge/version-1.9.0-purple)]()
[![License](https://img.shields.io/badge/license-proprietary-red)]()

[Website](https://silentid.co.uk) • [API Docs](https://api.silentid.co.uk) • [Admin](https://admin.silentid.co.uk)

---

</div>

## 🎯 What is SilentID?

**SilentID is a universal trust passport** that allows you to build a portable, evidence-backed reputation profile across marketplaces, dating apps, rental platforms, and community groups.

### The Problem We Solve

People are forced to trust complete strangers across marketplaces, dating apps, Facebook groups, and real-world meetups with **zero independent verification**. Traditional platforms keep trust *locked inside their ecosystem*.

### Our Solution

A **portable, evidence-backed trust profile** that works everywhere:

- 🛍️ **Marketplaces** — Vinted, Depop, eBay, Etsy, Facebook Marketplace
- 💑 **Dating & Social** — Tinder, Bumble, Hinge, Instagram DMs
- 🏠 **Renting** — Rooms, apartments, roommate matching
- 🛠️ **Services** — Cleaners, tutors, tradespeople, freelancers
- 👥 **Communities** — Parent groups, local communities
- 🤝 **In-Person** — Meetups, local trades, safety verification

---

## 🌟 Core Principles

> **"Honest people rise. Scammers fail."**

| Principle | Implementation |
|-----------|----------------|
| **NO Passwords** | 100% passwordless authentication — Apple, Google, Passkeys, Email OTP |
| **NO ID Storage** | Stripe Identity handles verification — we store only status |
| **Evidence-Based** | Trust built on receipts, screenshots, marketplace profiles |
| **Anti-Fraud First** | 9-layer fraud detection with AI-assisted analysis |
| **GDPR Compliant** | Privacy by design, data minimization, UK-based |
| **Defamation-Safe** | Never accuse — only present evidence |

---

## 🏗️ Architecture

### Technology Stack

#### Backend
```
Framework:    ASP.NET Core Web API (.NET 8)
Database:     PostgreSQL (Azure managed)
Auth:         Passwordless (Apple/Google/Passkeys/OTP)
Identity:     Stripe Identity (ID verification)
Billing:      Stripe Billing
Storage:      Azure Blob Storage (UK region)
Hosting:      Azure (UK South - GDPR compliant)
AI:           Azure OpenAI (GPT-4 Turbo for fraud analysis)
Scraping:     Playwright Capture Service (Node.js/Express)
```

#### Frontend
```
Mobile App:         Flutter (iOS + Android)
Landing Page:       Next.js 14 + Tailwind CSS
Admin Dashboard:    React/Next.js (future)
Design System:      Inter font, Royal Purple #5A3EB8
```

#### Authentication (100% Passwordless)
- 🍎 **Apple Sign-In** — OAuth integration
- 🔐 **Google Sign-In** — OAuth integration
- 🔑 **Passkeys** — Face ID / Touch ID / Windows Hello
- 📧 **Email OTP** — 6-digit one-time codes

---

## 🎨 Brand Identity

**Inspiration:** "Apple × Stripe × Revolut × Bank-level identity"

### Colors
```css
Primary:    Royal Purple     #5A3EB8
Dark Mode:  Dark Purple      #462F8F
Background: Soft Lilac       #E8E2FF
Success:    Green            #1FBF71
Warning:    Amber            #FFC043
Danger:     Red              #D04C4C
```

### Typography
- **Primary Font:** Inter (only font used)
- **Style:** Bank-grade, clean, secure, professional
- **Must Feel:** Serious, calm, high-trust, minimal
- **Never Feel:** Playful, social-media, cartoonish

---

## 🔑 Key Features

### TrustScore System (0-1000)

**Version 1.8.0:** 5-component system normalized from 1200 raw points to 1000.

```
Formula: (Identity + Evidence + Behaviour + Peer + URS) / 1200 × 1000
```

| Component | Max Points | Description |
|-----------|-----------|-------------|
| **Identity** | 200 pts | Stripe verification, email/phone verified, device consistency |
| **Evidence** | 300 pts | Email receipts, screenshots, marketplace profiles (15% vault cap) |
| **Behaviour** | 300 pts | No reports, on-time patterns, account longevity, consistency |
| **Peer Verification** | 200 pts | Mutual endorsements, returning partner transactions |
| **URS** | 200 pts | Universal Reputation Score from verified external profiles |

**Score Labels:**
- 🏆 850-1000: **Exceptional Trust**
- ✨ 700-849: **Very High Trust**
- ⭐ 550-699: **High Trust**
- ✅ 400-549: **Moderate Trust**
- ⚠️ 250-399: **Low Trust**
- 🚫 0-249: **High Risk**

### Evidence Vault

Store proof of trustworthy behaviour:
- 📧 **Email Receipts** — Order confirmations (DKIM/SPF validated)
- 📸 **Screenshots** — Reviews, ratings, sales history (OCR + integrity checks)
- 🔗 **Public Profiles** — Vinted, eBay, Depop, Etsy (Level 3 verification with ownership proof)

### Security Center

- 🔍 **Email Breach Scanner** — Check if your email appears in known breaches
- 🛡️ **Device Integrity** — Detect jailbreak, root, suspicious patterns
- 📍 **Login Activity** — Complete history with location and device tracking
- ⚠️ **Risk Alerts** — Real-time notifications for suspicious activity

### Anti-Fraud Engine (9 Layers)

1. **Evidence Integrity** — EXIF metadata, pixel manipulation detection
2. **Identity Consistency** — Stripe verification cross-checking
3. **Device Fingerprinting** — Detect account farms, fake clusters
4. **IP & Geo-Patterns** — VPN detection, impossible travel
5. **ML Anomaly Detection** — AI-powered pattern recognition
6. **Collusion Detection** — Circular verification rings
7. **Profile Mismatch** — Username consistency across platforms
8. **Risk Scoring (0-100)** — Automated fraud signals
9. **Admin Review** — Human oversight for complex cases

### Public Profiles

**URL:** `silentid.co.uk/u/username`

**Public Display:**
- Display name (e.g., "Sarah M.")
- Username (@sarahtrusted)
- TrustScore + label
- Identity Verified badge
- Verified platforms count
- Account age
- QR code for in-person verification

**Never Shown:**
- Full legal name
- Email, phone, address
- ID documents
- Raw evidence content

---

## 💰 Monetization

| Tier | Price | Features |
|------|-------|----------|
| **Free** | £0 | Basic TrustScore, up to 5 profile connections, basic verified badge |
| **Pro** | £4.99/mo | Unlimited profile connections, premium verified badge with QR, combined star rating, trust timeline, rating alerts, dispute evidence pack, priority support |

> **Note:** Paid subscriptions do **NOT** increase TrustScore or override safety systems.

---

## 🚀 Quick Start

### Prerequisites

```bash
# Required
- .NET 8 SDK
- Flutter SDK (latest stable)
- Node.js 18+
- PostgreSQL 14+
- Git

# Optional (for production)
- Docker
- Azure CLI
- Stripe CLI
```

### 1. Clone Repository

```bash
git clone https://github.com/silentsale/silentid.git
cd silentid
```

### 2. Backend Setup

```bash
cd src/SilentID.Api

# Restore dependencies
dotnet restore

# Update database (local PostgreSQL required)
dotnet ef database update

# Run API
dotnet run
```

API will be available at `https://localhost:5001`

### 3. Flutter App Setup

```bash
cd silentid_app

# Install dependencies
flutter pub get

# Run on iOS simulator
flutter run -d ios

# Or Android emulator
flutter run -d android
```

### 4. Landing Page Setup

```bash
cd web/silentid-landing

# Install dependencies
npm install

# Run development server
npm run dev
```

Landing page will be available at `http://localhost:3000`

### 5. Playwright Capture Service Setup

```bash
cd services/playwright-capture

# Install dependencies
npm install

# Install Playwright browsers
npx playwright install chromium

# Run service
node index.js
```

Capture service will be available at `http://localhost:3000`

---

## 📚 Documentation

### Master Specification
📖 **[CLAUDE.md](./CLAUDE.md)** — **Single Source of Truth**
- 48 sections covering entire system architecture
- Complete API contracts, database schema, UI specifications
- Legal & compliance requirements
- Implementation phases and timelines

### Project Status
📊 **[MVP_STATUS.md](./MVP_STATUS.md)** — Current development progress
- Phase completion status
- Feature implementation checklist
- Known issues and blockers

### Additional Docs
- 🎨 **[LOGO_USAGE.md](./assets/branding/LOGO_USAGE.md)** — Branding guidelines
- 🚀 **[IMPLEMENTATION_PHASES.md](./docs/IMPLEMENTATION_PHASES.md)** — 17 build phases
- 🔐 **[SECURITY.md](./docs/SECURITY.md)** — Security architecture (if exists)
- 🧪 **[TESTING.md](./docs/TESTING.md)** — Test strategy (if exists)

---

## 🗺️ Roadmap

### ✅ Phase 1 - MVP (Completed)
- [x] Backend skeleton (ASP.NET Core)
- [x] Passwordless authentication (Apple/Google/Passkeys/OTP)
- [x] Stripe Identity integration
- [x] TrustScore engine (5-component system)
- [x] Evidence collection (receipts, screenshots, profiles)
- [x] Flutter app (core screens)
- [x] Landing page (Next.js)
- [x] Azure Blob Storage integration
- [x] Basic anti-fraud engine

### 🔄 Phase 2 - Post-MVP (In Progress)
- [ ] Security Center (breach scanner, device checks)
- [ ] Admin Dashboard (user management, risk review)
- [ ] Help Center system (auto-generated articles)
- [ ] Level 3 Profile Verification (ownership proof)
- [ ] URS (Universal Reputation Score) calculation
- [ ] AI-assisted fraud detection (Azure OpenAI)
- [ ] Digital Trust Passport (Section 47)
- [ ] Modular Platform Configuration (Section 48)

### 🔮 Phase 3 - Future
- [ ] Partner API (external integrations)
- [ ] Business/Professional profiles
- [ ] Multi-language support (Albanian, French, German)
- [ ] Advanced analytics dashboard
- [ ] Web app (full features)
- [ ] Conversational Trust Assistant (AI chatbot)
- [ ] Multi-region platform support

---

## 🛡️ Security & Privacy

### What SilentID **STORES**
✅ Email address (encrypted)
✅ Username and display name
✅ Verification status (Stripe reference ID only)
✅ Evidence metadata (transaction summaries, OCR text)
✅ Device fingerprints (hashed)
✅ Login history (anonymized after 90 days)

### What SilentID **NEVER STORES**
❌ Passwords (we don't use them!)
❌ ID documents (Stripe handles this)
❌ Full email content (only receipt summaries)
❌ Credit card details (Stripe handles payments)
❌ Biometric data (stored on your device only)

### GDPR Compliance
- **ICO Registration:** [Number to be inserted]
- **Data Controller:** SILENTSALE LTD
- **Data Protection Officer:** dpo@silentid.co.uk
- **Your Rights:** Access, Rectification, Erasure, Portability, Objection
- **Data Retention:** 6-7 years max (fraud prevention), 30-day deletion grace period

### Legal Positioning

**SilentID IS:**
- ✅ A trust-support tool
- ✅ A reputation aggregator
- ✅ A safety indicator layer

**SilentID IS NOT:**
- ❌ A credit reference agency
- ❌ A criminal records provider
- ❌ An insurance or guarantee provider
- ❌ A background check service
- ❌ A marketplace or transaction platform

---

## 🏢 Legal Entity

**Company Name:** SILENTSALE LTD
**Company Number:** 16457502
**Registered:** England & Wales
**Trading As:** SilentID

**Domains:**
- **Website:** silentid.co.uk
- **API:** api.silentid.co.uk
- **Admin:** admin.silentid.co.uk

**Contact:**
- **Support:** support@silentid.co.uk
- **Legal:** legal@silentid.co.uk
- **Privacy:** dpo@silentid.co.uk
- **Press:** press@silentid.co.uk

---

## 🧪 Development

### Project Structure

```
SILENTID/
├── src/
│   └── SilentID.Api/          # ASP.NET Core backend
│       ├── Controllers/        # API endpoints
│       ├── Services/           # Business logic
│       ├── Models/             # Database entities
│       ├── Data/               # DbContext & migrations
│       └── Migrations/         # EF Core migrations
├── services/
│   └── playwright-capture/    # Profile scraping service (Node.js)
│       ├── index.js           # Express server
│       ├── services/          # Capture logic
│       └── screenshots/       # Captured screenshots
├── silentid_app/              # Flutter mobile app
│   ├── lib/
│   │   ├── features/          # Feature modules
│   │   ├── services/          # API clients
│   │   └── widgets/           # Reusable components
├── web/
│   └── silentid-landing/      # Next.js landing page
├── docs/                      # Additional documentation
├── assets/                    # Branding assets
├── CLAUDE.md                  # Master specification (48 sections)
└── README.md                  # This file
```

### Key Technologies

**Backend:**
- ASP.NET Core 8.0
- Entity Framework Core
- PostgreSQL
- Azure Blob Storage
- Stripe SDK
- Azure OpenAI SDK
- Playwright (Profile Scraping)

**Frontend (Mobile):**
- Flutter 3.x
- Dart 3.x
- Material Design 3
- State Management: Provider/Riverpod

**Frontend (Web):**
- Next.js 14
- React 18
- Tailwind CSS
- TypeScript

### Development Guidelines

📌 **CLAUDE.md is Law** — All features defined in master specification
📌 **Code > Documentation** — Implementation is the documentation
📌 **No Passwords** — This is non-negotiable
📌 **Privacy First** — GDPR compliance mandatory
📌 **Brand Consistency** — Royal purple, Inter font, bank-grade design
📌 **Evidence-Based** — All trust claims must be verifiable
📌 **Defamation-Safe** — Never accuse, only present facts

---

## 🧩 Integration

### Supported Platforms (Evidence Collection)

**Marketplaces:**
- Vinted (UK, FR, US, DE, ES, IT)
- eBay (UK, US, DE, FR, IT)
- Depop
- Etsy
- Facebook Marketplace
- Poshmark
- Mercari (future)

**Social Platforms (Future):**
- Instagram
- TikTok
- X/Twitter
- LinkedIn

### API Integration (Partner API - Future)

```bash
# Get user's trust summary
GET /api/partner/v1/trust-summary
Authorization: Bearer {partner_api_key}
{
  "username": "@alice123"
}

# Response
{
  "username": "@alice123",
  "trust_level": "high",
  "trust_score_band": "801-900",
  "identity_verified": true,
  "account_age_days": 180
}
```

---

## 🤝 Contributing

This is a **private project**. All development follows the specification in **CLAUDE.md**.

**For Internal Development:**
1. Read CLAUDE.md completely before starting any feature
2. Follow the 17 implementation phases (Section 11)
3. Use the safe development rules (Section 17)
4. Test with sample data first, never real user data in development
5. Security audit required before production deployment

---

## 📜 License

**Proprietary** — All rights reserved by SILENTSALE LTD.

This software and associated documentation are confidential and proprietary to SILENTSALE LTD. Unauthorized copying, modification, distribution, or use is strictly prohibited.

---

## 🔗 Links

- 🌐 **Website:** [silentid.co.uk](https://silentid.co.uk)
- 📚 **Documentation:** [CLAUDE.md](./CLAUDE.md)
- 🎨 **Branding:** [Logo Usage Guide](./assets/branding/LOGO_USAGE.md)
- 📊 **Status:** [MVP_STATUS.md](./MVP_STATUS.md)
- 📧 **Support:** support@silentid.co.uk

---

## 📈 Status

| Metric | Value |
|--------|-------|
| **Version** | 1.9.0 |
| **Status** | Pre-Production Development |
| **Last Updated** | 2025-12-04 |
| **Spec Sections** | 48 sections |
| **Total Lines** | ~11,318 lines (CLAUDE.md) |
| **Target Launch** | Q1 2026 |

---

<div align="center">

### 💜 Built with care by SILENTSALE LTD

**"Honest people rise. Scammers fail."**

[Website](https://silentid.co.uk) • [Support](mailto:support@silentid.co.uk) • [Legal](mailto:legal@silentid.co.uk)

</div>
