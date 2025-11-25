/**
 * Safety & Anti-Scam Section
 * Source: claude.md Section 4 & 7 (Legal & Compliance, Anti-Fraud Engine)
 */

'use client';

import { safety } from '@/config/content';

export default function Safety() {
  return (
    <section id="safety" className="bg-white section-padding">
      <div className="container-custom">
        <div className="text-center space-y-4 mb-16">
          <div className="inline-flex items-center gap-2 px-4 py-2 bg-success/10 rounded-full mb-4">
            <svg className="w-5 h-5 text-success" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
            </svg>
            <span className="text-sm font-semibold text-success">Trusted & Verified</span>
          </div>
          <h2>{safety.title}</h2>
          <p className="text-xl text-neutral-700 max-w-3xl mx-auto">
            {safety.subtitle}
          </p>
        </div>

        <div className="max-w-4xl mx-auto space-y-4">
          {safety.points.map((point, index) => (
            <div
              key={index}
              className="group flex gap-4 p-6 bg-white border-2 border-neutral-200 rounded-xl hover:border-success/40 hover:shadow-xl transition-all duration-300 hover:-translate-y-1"
              style={{ animationDelay: `${index * 100}ms` }}
            >
              {/* Check Icon with animated ring */}
              <div className="flex-shrink-0 relative">
                <div className="w-12 h-12 rounded-full bg-success/20 flex items-center justify-center group-hover:bg-success/30 transition-colors duration-300">
                  <svg className="w-7 h-7 text-success" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                  </svg>
                </div>
                {/* Decorative ring on hover */}
                <div className="absolute inset-0 rounded-full border-2 border-success/0 group-hover:border-success/30 group-hover:scale-125 transition-all duration-300" />
              </div>

              {/* Content */}
              <div className="flex-1 space-y-2">
                <h3 className="text-xl font-semibold text-neutral-black group-hover:text-success transition-colors duration-300">
                  {point.title}
                </h3>
                <p className="text-neutral-700 leading-relaxed">
                  {point.description}
                </p>
              </div>

              {/* Subtle arrow indicator */}
              <div className="flex-shrink-0 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                <svg className="w-5 h-5 text-success" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                </svg>
              </div>
            </div>
          ))}
        </div>

        {/* Trust Badge - Enhanced */}
        <div className="mt-16 relative overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-r from-primary/5 via-primary-light/30 to-primary/5 blur-xl" />
          <div className="relative p-8 bg-white/80 backdrop-blur-sm rounded-2xl border-2 border-primary/20 max-w-4xl mx-auto shadow-xl">
            <div className="space-y-6">
              {/* Badge header */}
              <div className="flex items-center justify-center gap-3">
                <div className="w-12 h-12 rounded-full bg-primary/20 flex items-center justify-center">
                  <svg className="w-7 h-7 text-primary" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                  </svg>
                </div>
                <h3 className="text-2xl font-bold text-primary">Bank-Grade Security</h3>
              </div>

              {/* Trust indicators */}
              <div className="grid md:grid-cols-3 gap-4">
                <div className="text-center p-4 bg-primary-light/50 rounded-lg">
                  <div className="text-sm font-semibold text-primary mb-1">GDPR Compliant</div>
                  <div className="text-xs text-neutral-700">Full data protection</div>
                </div>
                <div className="text-center p-4 bg-primary-light/50 rounded-lg">
                  <div className="text-sm font-semibold text-primary mb-1">Stripe Verified</div>
                  <div className="text-xs text-neutral-700">Industry-leading ID check</div>
                </div>
                <div className="text-center p-4 bg-primary-light/50 rounded-lg">
                  <div className="text-sm font-semibold text-primary mb-1">UK Regulated</div>
                  <div className="text-xs text-neutral-700">SILENTSALE LTD</div>
                </div>
              </div>

              <p className="text-center text-neutral-700 leading-relaxed">
                SilentID is operated by SILENTSALE LTD (UK). Full GDPR compliance, Stripe Identity verification, and passwordless authentication ensure your safety.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
