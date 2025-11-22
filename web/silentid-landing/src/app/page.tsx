import Hero from '@/components/Hero';
import Stats from '@/components/Stats';
import HowItWorks from '@/components/HowItWorks';
import Features from '@/components/Features';
import TrustExamples from '@/components/TrustExamples';
import Safety from '@/components/Safety';
import UseCases from '@/components/UseCases';
import FAQ from '@/components/FAQ';
import Footer from '@/components/Footer';

/**
 * SilentID Landing Page - Main Entry Point
 *
 * Source: claude.md Section 21
 * Version: 1.4.0
 *
 * This page assembles all sections of the SilentID landing page.
 * Dynamic content fetched from backend API keeps stats and examples current.
 */
export default function Home() {
  return (
    <main className="min-h-screen">
      <Hero />
      <Stats />
      <HowItWorks />
      <Features />
      <TrustExamples />
      <Safety />
      <UseCases />
      <FAQ />
      <Footer />
    </main>
  );
}
