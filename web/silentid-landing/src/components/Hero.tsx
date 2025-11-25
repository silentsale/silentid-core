/**
 * Hero Section Component
 * Source: claude.md Section 1 (Vision & Purpose) + Section 21 (Landing Page)
 */

'use client';

import { hero } from '@/config/content';

export default function Hero() {
  return (
    <section id="home" className="relative overflow-hidden bg-gradient-to-b from-primary-light/40 via-white to-white pt-20">
      {/* Animated background elements */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-20 left-10 w-72 h-72 bg-primary/10 rounded-full blur-3xl animate-pulse" style={{ animationDuration: '4s' }} />
        <div className="absolute bottom-20 right-10 w-96 h-96 bg-primary-light/30 rounded-full blur-3xl animate-pulse" style={{ animationDuration: '5s', animationDelay: '1s' }} />
      </div>

      <div className="container-custom section-padding relative z-10">
        <div className="grid lg:grid-cols-2 gap-12 items-center min-h-[calc(100vh-160px)]">
          {/* Left Column: Text Content */}
          <div className="space-y-8 animate-slide-in-left">
            <div className="space-y-4">
              <h1 className="text-5xl md:text-6xl lg:text-7xl font-bold text-neutral-black leading-tight">
                {hero.headline}
              </h1>
              <p className="text-xl md:text-2xl text-neutral-700 leading-relaxed max-w-2xl">
                {hero.subheadline}
              </p>
            </div>

            {/* Brand Promise */}
            <div className="p-6 bg-white/90 backdrop-blur-sm rounded-xl border-2 border-primary/30 max-w-xl shadow-lg hover:shadow-xl hover:border-primary/50 transition-all duration-300">
              <p className="text-lg text-neutral-900 font-medium">
                {hero.brandPromise}
              </p>
            </div>

            {/* CTA Buttons */}
            <div className="flex flex-col sm:flex-row gap-4 pt-4">
              <button className="btn-primary text-lg shadow-lg hover:shadow-xl transform hover:-translate-y-0.5 transition-all">
                {hero.primaryCTA}
              </button>
              <a
                href="#how-it-works"
                className="btn-secondary text-lg hover:shadow-md transform hover:-translate-y-0.5 transition-all"
              >
                {hero.secondaryCTA}
              </a>
            </div>

            {/* Trust Indicators */}
            <div className="flex flex-wrap gap-6 pt-8 border-t border-neutral-300">
              {[
                { icon: 'check', text: '100% Passwordless' },
                { icon: 'check', text: 'Stripe Verified' },
                { icon: 'check', text: 'GDPR Compliant' }
              ].map((indicator, index) => (
                <div
                  key={index}
                  className="flex items-center gap-2 group"
                  style={{ animationDelay: `${index * 100}ms` }}
                >
                  <div className="w-6 h-6 rounded-full bg-success/20 flex items-center justify-center group-hover:bg-success/30 transition-colors duration-300">
                    <svg className="w-4 h-4 text-success" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                  </div>
                  <span className="text-sm text-neutral-700 font-medium group-hover:text-neutral-900 transition-colors duration-300">
                    {indicator.text}
                  </span>
                </div>
              ))}
            </div>
          </div>

          {/* Right Column: Visual/Mockup */}
          <div className="relative lg:order-last animate-slide-in-right">
            <div className="relative z-10 transform hover:scale-105 transition-transform duration-500">
              {/* Placeholder for app mockup */}
              <div className="bg-white rounded-2xl shadow-2xl p-8 border-2 border-neutral-200 hover:border-primary/30 transition-colors duration-300">
                <div className="aspect-[9/16] bg-gradient-to-br from-primary-light/50 to-primary/10 rounded-xl flex items-center justify-center overflow-hidden relative">
                  {/* Background pattern */}
                  <div className="absolute inset-0 opacity-5">
                    <div className="absolute inset-0" style={{ backgroundImage: 'radial-gradient(circle, #5a3eb8 1px, transparent 1px)', backgroundSize: '20px 20px' }} />
                  </div>

                  <div className="text-center space-y-4 p-8 relative z-10">
                    <div className="w-24 h-24 mx-auto bg-gradient-to-br from-primary to-primary-dark rounded-full flex items-center justify-center text-white text-4xl font-bold shadow-xl animate-pulse" style={{ animationDuration: '3s' }}>
                      S
                    </div>
                    <div className="space-y-2">
                      <p className="text-4xl font-bold text-primary">847</p>
                      <p className="text-sm text-neutral-700 font-semibold">TrustScore</p>
                      <div className="inline-block px-5 py-2 bg-success/20 text-success rounded-full text-sm font-bold shadow-md">
                        Very High Trust
                      </div>
                    </div>

                    {/* Mock verification badges */}
                    <div className="pt-6 flex justify-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-primary/20 flex items-center justify-center">
                        <svg className="w-5 h-5 text-primary" fill="currentColor" viewBox="0 0 20 20">
                          <path fillRule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                        </svg>
                      </div>
                      <div className="w-10 h-10 rounded-full bg-success/20 flex items-center justify-center">
                        <svg className="w-5 h-5 text-success" fill="currentColor" viewBox="0 0 20 20">
                          <path fillRule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                        </svg>
                      </div>
                      <div className="w-10 h-10 rounded-full bg-primary-light/50 flex items-center justify-center">
                        <svg className="w-5 h-5 text-primary" fill="currentColor" viewBox="0 0 20 20">
                          <path d="M9 6a3 3 0 11-6 0 3 3 0 016 0zM17 6a3 3 0 11-6 0 3 3 0 016 0zM12.93 17c.046-.327.07-.66.07-1a6.97 6.97 0 00-1.5-4.33A5 5 0 0119 16v1h-6.07zM6 11a5 5 0 015 5v1H1v-1a5 5 0 015-5z" />
                        </svg>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Background Decoration - positioned behind */}
            <div className="absolute top-10 right-10 -z-10 w-72 h-72 bg-primary/15 rounded-full blur-3xl animate-pulse" style={{ animationDuration: '6s' }} />
            <div className="absolute bottom-10 left-10 -z-10 w-80 h-80 bg-primary-light/40 rounded-full blur-3xl animate-pulse" style={{ animationDuration: '7s', animationDelay: '2s' }} />
          </div>
        </div>
      </div>
    </section>
  );
}
