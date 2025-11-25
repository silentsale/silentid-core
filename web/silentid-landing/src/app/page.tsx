import HeroSection from '@/sections/HeroSection';
import ProblemSection from '@/sections/ProblemSection';
import HowItWorksSection from '@/sections/HowItWorksSection';
import TrustScoreSection from '@/sections/TrustScoreSection';
import PasskeySection from '@/sections/PasskeySection';
import IdentitySection from '@/sections/IdentitySection';
import EvidenceVaultSection from '@/sections/EvidenceVaultSection';
import RiskSignalsSection from '@/sections/RiskSignalsSection';
import PassportSection from '@/sections/PassportSection';
import PricingSection from '@/sections/PricingSection';
import TestimonialsSection from '@/sections/TestimonialsSection';
import FooterSection from '@/sections/FooterSection';

/**
 * SilentID Landing Page - Main Entry Point
 *
 * Source: claude.md Section 21
 * Version: 2.0.0
 *
 * This page assembles all 12 sections of the complete SilentID landing page.
 * Each section is a self-contained component with Framer Motion animations.
 *
 * Section Order:
 * 1. Hero - Cinematic introduction with primary CTA
 * 2. Problem - "Trust online is broken" messaging
 * 3. How It Works - 4-step user journey
 * 4. TrustScore - Core value proposition with animated score card
 * 5. Passkey - 100% passwordless authentication
 * 6. Identity - Stripe verification process
 * 7. Evidence Vault - Building trust through evidence
 * 8. Risk Signals - Security Center features
 * 9. Passport - Portable trust (QR codes, sharing)
 * 10. Pricing - Free, Premium, Pro tiers
 * 11. Testimonials - Social proof and user stats
 * 12. Footer - Legal links, company info, navigation
 */
export default function Home() {
  return (
    <main className="min-h-screen">
      <HeroSection />
      <ProblemSection />
      <HowItWorksSection />
      <TrustScoreSection />
      <PasskeySection />
      <IdentitySection />
      <EvidenceVaultSection />
      <RiskSignalsSection />
      <PassportSection />
      <PricingSection />
      <TestimonialsSection />
      <FooterSection />
    </main>
  );
}
