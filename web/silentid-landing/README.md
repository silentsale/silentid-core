# SilentID Landing Page

**Version:** 1.4.0
**Last Updated:** 2025-11-21
**Production URL:** https://www.silentid.co.uk

## Overview

This is the official landing page for **SilentID - Your Digital Trust Passport**.

All content, branding, and features are extracted from [`claude.md`](../../CLAUDE.md) (Section 21) to ensure perfect synchronization with the product specification.

## Technology Stack

- **Framework:** Next.js 14 (React 18)
- **Styling:** Tailwind CSS
- **TypeScript:** Full type safety
- **Deployment:** Azure Static Web Apps (static export)

## Getting Started

### Prerequisites

- Node.js 18+ (check: `node --version`)
- npm or pnpm

### Installation

```bash
# From the project root
cd web/silentid-landing

# Install dependencies
npm install
```

### Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### Build for Production

```bash
npm run build
npm run export
```

Static files will be generated in the `out/` directory.

## Project Structure

```
/web/silentid-landing/
├── src/
│   ├── app/                  # Next.js App Router
│   │   ├── layout.tsx        # Root layout with metadata
│   │   ├── page.tsx          # Home page (assembles all sections)
│   │   └── globals.css       # Global styles & Tailwind
│   ├── components/           # React components
│   │   ├── Hero.tsx          # Hero section
│   │   ├── HowItWorks.tsx    # 4-step process
│   │   ├── Features.tsx      # Key features grid
│   │   ├── Safety.tsx        # Anti-scam section
│   │   ├── UseCases.tsx      # For Individuals/Platforms
│   │   ├── FAQ.tsx           # FAQ accordion
│   │   └── Footer.tsx        # Footer with legal info
│   └── config/               # Configuration files
│       ├── tokens.ts         # Design tokens (from claude.md Section 2)
│       └── content.ts        # All page content (from claude.md)
├── public/                   # Static assets
│   ├── images/
│   ├── icons/
│   └── mockups/
├── package.json
├── next.config.js
├── tailwind.config.js
├── tsconfig.json
└── README.md
```

## Sync with claude.md

**CRITICAL:** This landing page is synchronized with `claude.md` (SilentID Master Specification).

### Source of Truth Rules

1. **ALL content comes from `claude.md`**
   - Section 1: Vision & Purpose → Hero messaging
   - Section 2: Branding → Colors, typography, design tokens
   - Section 3 & 5: Features → Feature descriptions
   - Section 21: Landing Page → Structure and requirements

2. **When claude.md changes:**
   - Review affected sections
   - Update `src/config/content.ts` with new copy
   - Update `src/config/tokens.ts` if branding changes
   - Rebuild and redeploy

3. **Never invent features or copy**
   - If something isn't in `claude.md`, don't add it
   - If unsure, check the spec first

### Sync Workflow

```bash
# 1. After claude.md is updated
# 2. Review changes
git diff ../../CLAUDE.md

# 3. Update content/tokens files as needed
# 4. Test locally
npm run dev

# 5. Build and verify
npm run build
npm run export

# 6. Deploy to production
# (See deployment section)
```

## Design Tokens

All design tokens are defined in `src/config/tokens.ts` and match `claude.md` Section 2 exactly:

- **Primary Color:** #5A3EB8 (Royal Purple)
- **Font:** Inter (Google Fonts)
- **Button Radius:** 12px
- **Button Height:** 52px
- **Spacing:** xs(8px), sm(16px), md(24px), lg(48px), xl(64px)

**Brand Personality:**
- MUST feel: Serious, calm, professional, bank-grade security
- NEVER feel: Juvenile, playful, cartoonish, "startup cheap"
- Reference: "Apple × Stripe × Revolut × Bank-level identity"

## Content Configuration

All page content is in `src/config/content.ts`:

- `hero` - Hero section text
- `howItWorks` - 4-step process
- `features` - Key features list
- `safety` - Anti-scam points
- `useCases` - Individuals/Platforms benefits
- `faq` - FAQ questions/answers
- `footer` - Legal info, links
- `metadata` - SEO tags

**When updating:**
1. Never edit component files directly
2. Update `content.ts` instead
3. Components automatically reflect changes

## SEO

All SEO metadata is configured in `src/app/layout.tsx`:

- **Title:** "SilentID - Your Digital Trust Passport"
- **Description:** "Verify your identity once, carry your trust everywhere..."
- **Keywords:** silentid, trust passport, identity verification, passwordless, etc.
- **Open Graph:** Configured for social media sharing
- **Schema.org:** Markup for rich results (future enhancement)

## Deployment

### Azure Static Web Apps (Recommended)

```bash
# 1. Build static export
npm run export

# 2. Deploy out/ directory to Azure Static Web Apps
# Use Azure CLI or GitHub Actions
```

### Vercel (Alternative)

```bash
vercel --prod
```

### Custom Domain Setup

Point `www.silentid.co.uk` to your hosting provider.

## Quality Checklist

Before deploying, ensure:

- [ ] All content verified against `claude.md`
- [ ] Design tokens match Section 2
- [ ] No marketing fluff or unsubstantiated claims
- [ ] Lighthouse score >90 (performance, accessibility, SEO)
- [ ] Fully responsive (mobile, tablet, desktop)
- [ ] All links functional
- [ ] Legal entity correct (SILENTSALE LTD, Company No. 16457502)
- [ ] Spec version noted in footer

## Maintenance

### Regular Updates

- Review `claude.md` for changes monthly
- Update content.ts when product features change
- Keep dependencies updated (security)
- Monitor Lighthouse scores

### Version Tracking

Landing page version should match `claude.md` version (currently 1.4.0).

Update `package.json` and `footer.specVersion` when claude.md updates.

## Support

For questions about:
- **Landing page content:** Check `claude.md` first
- **Technical issues:** See Next.js documentation
- **Brand guidelines:** See `claude.md` Section 2

## License

This landing page is part of the SilentID product by SILENTSALE LTD. All rights reserved.

---

**Built with Next.js • Powered by claude.md • Deployed on Azure**
