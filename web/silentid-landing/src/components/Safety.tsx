/**
 * Safety & Anti-Scam Section
 * Source: claude.md Section 4 & 7 (Legal & Compliance, Anti-Fraud Engine)
 */

import { safety } from '@/config/content';

export default function Safety() {
  return (
    <section id="safety" className="bg-white section-padding">
      <div className="container-custom">
        <div className="text-center space-y-4 mb-16">
          <h2>{safety.title}</h2>
          <p className="text-xl text-neutral-700 max-w-3xl mx-auto">
            {safety.subtitle}
          </p>
        </div>

        <div className="max-w-4xl mx-auto space-y-6">
          {safety.points.map((point, index) => (
            <div
              key={index}
              className="flex gap-4 p-6 bg-white border border-neutral-300 rounded-lg hover:border-primary/40 hover:shadow-lg transition-all duration-200"
            >
              {/* Check Icon */}
              <div className="flex-shrink-0">
                <div className="w-10 h-10 rounded-full bg-success/20 flex items-center justify-center">
                  <svg className="w-6 h-6 text-success" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                  </svg>
                </div>
              </div>

              {/* Content */}
              <div className="flex-1 space-y-2">
                <h3 className="text-xl font-semibold text-neutral-black">
                  {point.title}
                </h3>
                <p className="text-neutral-700 leading-relaxed">
                  {point.description}
                </p>
              </div>
            </div>
          ))}
        </div>

        {/* Trust Badge */}
        <div className="mt-12 p-8 bg-primary-light/50 rounded-xl border border-primary/20 max-w-4xl mx-auto text-center">
          <div className="space-y-4">
            <div className="flex items-center justify-center gap-2">
              <svg className="w-6 h-6 text-primary" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
              </svg>
              <span className="text-lg font-semibold text-primary">Bank-Grade Security</span>
            </div>
            <p className="text-neutral-700">
              SilentID is operated by SILENTSALE LTD (UK). Full GDPR compliance, Stripe Identity verification, and passwordless authentication ensure your safety.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
}
