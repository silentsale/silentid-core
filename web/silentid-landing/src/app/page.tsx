import HeroSection from '@/sections/HeroSection';
import ProblemSection from '@/sections/ProblemSection';
import HowItWorksSection from '@/sections/HowItWorksSection';
import AppWalkthroughSection from '@/sections/AppWalkthroughSection';
import TrustScoreSection from '@/sections/TrustScoreSection';
import PasskeySection from '@/sections/PasskeySection';
import IdentitySection from '@/sections/IdentitySection';
import PassportSection from '@/sections/PassportSection';
import PricingSection from '@/sections/PricingSection';
import TestimonialsSection from '@/sections/TestimonialsSection';
import FAQSection from '@/sections/FAQSection';
import FooterSection from '@/sections/FooterSection';

/**
 * SilentID Landing Page - Main Entry Point
 *
 * Source: claude.md
 * Version: 2.1.0 - SEO & AI Optimized
 *
 * This page assembles the SilentID landing page sections.
 * Each section is a self-contained component with Framer Motion animations.
 * Optimized for SEO and AI discoverability with comprehensive JSON-LD schemas.
 *
 * Section Order:
 * 1. Hero - Fear hook + insurance messaging with primary CTA
 * 2. Problem - Horror stats + pain points (reputation at risk)
 * 3. How It Works - 4-step journey with real app screen illustrations
 * 4. App Walkthrough - Interactive demo with 5 app screens
 * 5. TrustScore - Core value proposition with animated score card
 * 6. Passkey - 100% passwordless authentication
 * 7. Identity - Stripe verification process
 * 8. Passport - Portable trust (QR codes, verified badge)
 * 9. Pricing - Free + Pro tiers with new features
 * 10. Testimonials - Social proof and user stats
 * 11. FAQ - Comprehensive SEO-optimized FAQ (15 questions)
 * 12. Footer - Legal links, company info, navigation
 *
 * Removed Sections (simplified):
 * - Evidence Vault (consolidated into Pro features)
 * - Risk Signals (consolidated into TrustScore)
 */
export default function Home() {
  return (
    <main className="min-h-screen">
      {/* Above the fold - Hook visitors immediately */}
      <HeroSection />

      {/* The Problem - Fear-driven messaging */}
      <ProblemSection />

      {/* Solution Overview - How it works */}
      <HowItWorksSection />

      {/* Interactive Demo - See the app in action */}
      <AppWalkthroughSection />

      {/* Core Value Propositions */}
      <TrustScoreSection />
      <PasskeySection />
      <IdentitySection />
      <PassportSection />

      {/* Conversion - Pricing and Social Proof */}
      <PricingSection />
      <TestimonialsSection />

      {/* SEO & AI - Comprehensive FAQ */}
      <FAQSection />

      {/* Footer */}
      <FooterSection />
    </main>
  );
}
