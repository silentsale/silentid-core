# SilentID

**Your Portable Trust Passport** - 100% passwordless identity & reputation platform.

## 🎯 What is SilentID?

SilentID is a standalone trust-identity application that allows users to build a portable reputation profile across marketplaces, dating apps, rental platforms, and community groups.

**Core Principle:** Verify your identity once, carry your trust everywhere you go online.

## 📚 Documentation

- **[CLAUDE.md](./CLAUDE.md)** - Complete specification (41 sections) - **Single Source of Truth**
- **[MVP_STATUS.md](./MVP_STATUS.md)** - Current development status & progress
- **[assets/branding/LOGO_USAGE.md](./assets/branding/LOGO_USAGE.md)** - Branding guidelines & logo usage

## 🏗️ Tech Stack

### Backend
- **Framework:** ASP.NET Core Web API (.NET 8)
- **Database:** PostgreSQL
- **Identity:** Stripe Identity (ID verification)
- **Billing:** Stripe Billing
- **Storage:** Azure Blob Storage
- **Hosting:** Azure (UK region for GDPR compliance)

### Frontend
- **Mobile:** Flutter (iOS + Android)
- **Landing Page:** Next.js + Tailwind CSS
- **Admin Dashboard:** Web (React/Next.js - future)

### Authentication
**100% Passwordless** - No passwords stored anywhere:
- Apple Sign-In
- Google Sign-In
- Passkeys (Face ID / Touch ID / Windows Hello)
- Email OTP (6-digit one-time codes)

## 🎨 Brand Identity

- **Primary Color:** Royal Purple `#5A3EB8`
- **Font:** Inter (only font used)
- **Style:** Bank-grade, clean, secure, professional
- **Inspiration:** "Apple × Stripe × Revolut × Bank-level identity"

## 🚀 Quick Start

### Prerequisites
- .NET 8 SDK
- Flutter SDK (latest stable)
- Node.js 18+ (for landing page)
- PostgreSQL (local or Docker)
- Git

### Backend Setup
```bash
cd src/SilentID.Api
dotnet restore
dotnet run
```

### Flutter App Setup
```bash
cd silentid_app
flutter pub get
flutter run
```

### Landing Page Setup
```bash
cd web/silentid-landing
npm install
npm run dev
```

## 🔑 Key Features

- **TrustScore (0-1000)** - Identity + Evidence + Behaviour + Peer Verification
- **Evidence Vault** - Email receipts, screenshots, public profiles
- **Security Center** - Breach monitoring, device checks, login alerts
- **Mutual Verification** - Peer-to-peer transaction confirmations
- **Anti-Fraud Engine** - 9-layer fraud detection system
- **Public Profiles** - Shareable trust profiles via link or QR code
- **GDPR Compliant** - Privacy by design, UK-based

## 💰 Monetisation

- **Free** - Basic features, limited evidence (10 receipts, 5 screenshots)
- **Premium** - £4.99/mo - Unlimited evidence, analytics, 100GB vault
- **Pro** - £14.99/mo - Bulk checks, dispute tools, 500GB vault

## 🛡️ Security & Privacy

- **NO passwords stored** - ever
- **NO ID documents stored** - Stripe Identity handles verification
- **Evidence-based trust** - receipts, screenshots, public profiles
- **GDPR compliant** - privacy by design, data minimization
- **Defamation-safe language** - never accuse, only present evidence

## 📱 Supported Platforms

### Mobile App (MVP)
- ✅ iOS (iPhone)
- ✅ Android

### Web (Future)
- 🔜 Public profiles (read-only)
- 🔜 Web app (limited features)
- 🔜 Admin dashboard

## 🏢 Legal Entity

**SILENTSALE LTD** (UK registered company)
- Company No: 16457502
- Domain: silentid.co.uk
- API: api.silentid.co.uk
- Admin: admin.silentid.co.uk

## 🗺️ Roadmap

**Phase 1 (MVP):**
- ✅ Backend skeleton
- ✅ Passwordless auth
- ✅ Stripe Identity integration
- ✅ TrustScore engine
- ✅ Evidence collection
- ✅ Flutter app (core screens)
- ✅ Landing page

**Phase 2 (Post-MVP):**
- 🔜 Security Center
- 🔜 Admin dashboard
- 🔜 Help Center system
- 🔜 Partner API
- 🔜 Business profiles

**Phase 3 (Future):**
- 🔜 Multi-language support
- 🔜 Advanced analytics
- 🔜 AI-assisted fraud detection
- 🔜 Web app (full features)

## 📖 Developer Notes

- **Code > Documentation** - Implementation is the documentation
- **CLAUDE.md is law** - All features defined in master spec
- **No passwords** - This is non-negotiable
- **Privacy first** - GDPR compliance mandatory
- **Brand consistency** - Royal purple, Inter font, bank-grade design

## 🤝 Contributing

This is a private project. All development follows the specification in CLAUDE.md.

## 📄 License

Proprietary - All rights reserved by SILENTSALE LTD.

---

**Version:** 1.0.0
**Last Updated:** 2025-11-23
**Status:** Pre-Production Development
