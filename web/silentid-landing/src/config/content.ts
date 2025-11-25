/**
 * Content Configuration for SilentID Landing Page
 * Source: claude.md (Various Sections)
 * Version: 1.8.0
 *
 * CRITICAL: All content is extracted from claude.md.
 * When claude.md changes, update this file accordingly.
 */

export const hero = {
  headline: 'Your Passport to Digital Trust',
  subheadline: 'Verify your identity once, carry your trust everywhere you go online',
  primaryCTA: 'Get Your SilentID',
  secondaryCTA: 'How It Works',
  // From claude.md Section 1
  brandSentence: 'SilentID is the passport of trust for the real world and the digital world.',
  brandPromise: 'Honest people rise. Scammers fail.',
};

export const howItWorks = {
  title: 'How SilentID Works',
  subtitle: 'Build your digital trust passport in four simple steps',
  steps: [
    {
      number: '01',
      title: 'Sign Up Passwordless',
      description: 'Use Apple Sign-In, Google Sign-In, Passkeys, or Email OTP. No passwords. Ever.',
      icon: 'shield-check',
    },
    {
      number: '02',
      title: 'Verify Your Identity',
      description: 'Complete one-time verification with Stripe Identity. Your documents stay with Stripe, not us.',
      icon: 'user-check',
    },
    {
      number: '03',
      title: 'Build Your Trust Passport',
      description: 'Add receipts, screenshots, and marketplace profiles to build your TrustScore (0-1000).',
      icon: 'award',
    },
    {
      number: '04',
      title: 'Use Everywhere',
      description: 'Share your SilentID via link, QR code, or profile badge across any platform.',
      icon: 'globe',
    },
  ],
};

export const features = {
  title: 'Built for Maximum Trust & Security',
  subtitle: 'Bank-grade security meets portable reputation',
  list: [
    {
      icon: 'passport',
      title: 'Digital Trust Passport',
      description: 'A verified, portable reputation profile that works across marketplaces, dating apps, rentals, and communities.',
    },
    {
      icon: 'chart-bar',
      title: 'TrustScore (0-1000)',
      description: 'Transparent score based on Identity (200 pts), Evidence (300 pts), Behaviour (300 pts), and Peer Verification (200 pts).',
    },
    {
      icon: 'shield',
      title: 'Security Center',
      description: 'Breach monitoring, login alerts, device checks, and security analytics to keep your identity safe.',
    },
    {
      icon: 'folder',
      title: 'Evidence Vault',
      description: 'Securely store receipts, screenshots, and marketplace profiles to prove your reputation.',
    },
    {
      icon: 'lock-open',
      title: '100% Passwordless',
      description: 'Apple Sign-In, Google Sign-In, Passkeys, or Email OTP. No passwords means no password breaches.',
    },
    {
      icon: 'check-circle',
      title: 'Works Everywhere',
      description: 'Use your SilentID on any platform via shareable link, QR code, or profile badge.',
    },
  ],
};

export const safety = {
  title: 'Why SilentID is Safe from Scammers',
  subtitle: 'Multiple layers of protection prevent fraud and fake accounts',
  points: [
    {
      title: 'Stripe Identity Verification',
      description: 'Every SilentID user is verified through Stripe Identity. Scammers cannot fake or reuse someone else\'s verified identity.',
    },
    {
      title: 'No Passwords, No Breaches',
      description: 'SilentID never stores passwords. Passwordless authentication with Apple, Google, Passkeys, and Email OTP means no password database to hack.',
    },
    {
      title: 'Device-Bound Security',
      description: 'Passkeys and device fingerprinting ensure accounts are tied to physical devices, making account takeover nearly impossible.',
    },
    {
      title: 'GDPR Compliant & UK-Based',
      description: 'Operated by SILENTSALE LTD (UK). Full GDPR compliance, privacy by design, and user rights protected.',
    },
    {
      title: 'Evidence-Based Trust',
      description: 'TrustScores are built on verifiable evidence (receipts, screenshots, public profiles), not empty claims.',
    },
  ],
};

export const useCases = {
  individuals: {
    title: 'For Individuals',
    description: 'Build trust, avoid scams, trade with confidence',
    benefits: [
      'Prove you\'re a real, trustworthy person',
      'Get trusted faster on marketplaces and communities',
      'Feel safer when trading, renting, or meeting people',
      'Build portable reputation across platforms',
      'Stand out from scammers and fake accounts',
    ],
  },
  platforms: {
    title: 'For Platforms',
    description: 'Optional integration to reduce fraud',
    benefits: [
      'Let users bring verified identity from SilentID',
      'Reduce fraud, fake accounts, and disputes',
      'Use SilentID as a trust signal without heavy KYC',
      'Lightweight API integration',
      'Improve platform safety and trust',
    ],
  },
};

export const faq = {
  title: 'Frequently Asked Questions',
  subtitle: 'Everything you need to know about SilentID',
  questions: [
    {
      question: 'What is SilentID?',
      answer: 'SilentID is a universal trust passport for the internet. It verifies who you are (via Stripe Identity) and how you behave (via evidence like receipts and marketplace profiles) to create a portable reputation you can use anywhere online.',
    },
    {
      question: 'Is SilentID a password manager?',
      answer: 'No. SilentID is 100% passwordless and never stores passwords. It\'s an identity verification and trust reputation platform, not a password manager.',
    },
    {
      question: 'How is my identity verified?',
      answer: 'SilentID uses Stripe Identity for verification. You submit your ID document and a selfie to Stripe (not SilentID). Stripe verifies it\'s real and matches you. SilentID only receives confirmation that you\'re verified.',
    },
    {
      question: 'How does SilentID protect me from scams?',
      answer: 'SilentID combines identity verification (via Stripe), evidence-based trust (receipts, marketplace profiles), and behavioral analysis (no reports, consistent activity). Scammers cannot fake verified identities or fabricate evidence that passes integrity checks.',
    },
    {
      question: 'Which platforms can I use SilentID on?',
      answer: 'You can use SilentID anywhere. Share your SilentID link, QR code, or profile badge on marketplaces (Vinted, eBay, Depop), dating apps (Tinder, Bumble), rental platforms, community groups, or in-person meetups.',
    },
    {
      question: 'Do I have to show my real name?',
      answer: 'No. SilentID public profiles only show your display name (e.g., "Sarah M.") and username (e.g., @sarahtrusted). Your full legal name, address, phone, and email are never publicly displayed.',
    },
    {
      question: 'How does SilentID make money?',
      answer: 'SilentID offers three tiers: Free (basic features), Premium (£4.99/month with advanced analytics and larger Evidence Vault), and Pro (£14.99/month for power sellers with bulk checks and dispute tools).',
    },
    {
      question: 'Can I delete my SilentID account?',
      answer: 'Yes. You can delete your account anytime. You have a 30-day grace period to cancel deletion. After 30 days, your profile and evidence are permanently deleted (except anonymized fraud logs retained for legal compliance).',
    },
  ],
};

export const footer = {
  companyName: 'SilentID',
  legalEntity: 'SILENTSALE LTD',
  companyNumber: '16457502',
  registeredIn: 'England & Wales',
  copyright: `© ${new Date().getFullYear()} SILENTSALE LTD. All rights reserved.`,
  specVersion: '1.8.0',
  links: {
    legal: [
      { label: 'Terms & Conditions', href: '/terms' },
      { label: 'Privacy Policy', href: '/privacy' },
      { label: 'Cookie Policy', href: '/cookies' },
    ],
    support: [
      { label: 'Help Center', href: '/help' },
      { label: 'Contact Us', href: '/contact' },
      { label: 'FAQ', href: '#faq' },
    ],
    company: [
      { label: 'About SilentID', href: '/about' },
      { label: 'How It Works', href: '#how-it-works' },
      { label: 'Security', href: '#safety' },
    ],
  },
};

export const metadata = {
  title: 'SilentID - Your Digital Trust Passport',
  description: 'Verify your identity once, carry your trust everywhere. Passwordless, secure, portable reputation across marketplaces, dating apps, and communities.',
  keywords: [
    'silentid',
    'trust passport',
    'identity verification',
    'passwordless authentication',
    'digital trust',
    'marketplace verification',
    'scam protection',
    'trustscore',
    'stripe identity',
    'reputation system',
  ],
  ogImage: '/images/og-image.png',
  twitterCard: 'summary_large_image',
  siteUrl: 'https://www.silentid.co.uk',
};
