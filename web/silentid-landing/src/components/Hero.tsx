/**
 * Hero Section Component
 * Source: claude.md Section 1 (Vision & Purpose) + Section 21 (Landing Page)
 */

import { hero } from '@/config/content';

export default function Hero() {
  return (
    <section className="relative overflow-hidden bg-gradient-to-b from-primary-light to-white">
      <div className="container-custom section-padding">
        <div className="grid lg:grid-cols-2 gap-12 items-center min-h-[calc(100vh-80px)]">
          {/* Left Column: Text Content */}
          <div className="space-y-8">
            <div className="space-y-4">
              <h1 className="text-5xl md:text-6xl lg:text-7xl font-bold text-neutral-black leading-tight">
                {hero.headline}
              </h1>
              <p className="text-xl md:text-2xl text-neutral-700 leading-relaxed max-w-2xl">
                {hero.subheadline}
              </p>
            </div>

            {/* Brand Promise */}
            <div className="p-6 bg-white/80 backdrop-blur-sm rounded-lg border border-primary/20 max-w-xl">
              <p className="text-lg text-neutral-900 font-medium">
                {hero.brandPromise}
              </p>
            </div>

            {/* CTA Buttons */}
            <div className="flex flex-col sm:flex-row gap-4 pt-4">
              <button className="btn-primary text-lg">
                {hero.primaryCTA}
              </button>
              <a
                href="#how-it-works"
                className="btn-secondary text-lg"
              >
                {hero.secondaryCTA}
              </a>
            </div>

            {/* Trust Indicators */}
            <div className="flex flex-wrap gap-6 pt-8 border-t border-neutral-300">
              <div className="flex items-center gap-2">
                <svg className="w-5 h-5 text-success" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                </svg>
                <span className="text-sm text-neutral-700 font-medium">100% Passwordless</span>
              </div>
              <div className="flex items-center gap-2">
                <svg className="w-5 h-5 text-success" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                </svg>
                <span className="text-sm text-neutral-700 font-medium">Stripe Verified</span>
              </div>
              <div className="flex items-center gap-2">
                <svg className="w-5 h-5 text-success" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                </svg>
                <span className="text-sm text-neutral-700 font-medium">GDPR Compliant</span>
              </div>
            </div>
          </div>

          {/* Right Column: Visual/Mockup */}
          <div className="relative lg:order-last">
            <div className="relative z-10">
              {/* Placeholder for app mockup */}
              <div className="bg-white rounded-2xl shadow-2xl p-8 border border-neutral-300">
                <div className="aspect-[9/16] bg-gradient-to-br from-primary-light to-primary/10 rounded-lg flex items-center justify-center">
                  <div className="text-center space-y-4 p-8">
                    <div className="w-24 h-24 mx-auto bg-primary rounded-full flex items-center justify-center text-white text-4xl font-bold">
                      S
                    </div>
                    <div className="space-y-2">
                      <p className="text-3xl font-bold text-primary">847</p>
                      <p className="text-sm text-neutral-700 font-medium">TrustScore</p>
                      <div className="inline-block px-4 py-2 bg-success/20 text-success rounded-full text-sm font-semibold">
                        Very High Trust
                      </div>
                    </div>
                    <div className="pt-4 text-xs text-neutral-700">
                      [App Mockup Placeholder]
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Background Decoration */}
            <div className="absolute top-0 right-0 -z-10 w-72 h-72 bg-primary/20 rounded-full blur-3xl"></div>
            <div className="absolute bottom-0 left-0 -z-10 w-96 h-96 bg-primary-light rounded-full blur-3xl"></div>
          </div>
        </div>
      </div>
    </section>
  );
}
