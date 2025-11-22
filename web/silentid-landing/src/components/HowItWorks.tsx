/**
 * How It Works Section
 * Source: claude.md Section 5 & 6 (Core Features, Feature Flows)
 */

import { howItWorks } from '@/config/content';

export default function HowItWorks() {
  return (
    <section id="how-it-works" className="bg-white section-padding">
      <div className="container-custom">
        <div className="text-center space-y-4 mb-16">
          <h2>{howItWorks.title}</h2>
          <p className="text-xl text-neutral-700 max-w-3xl mx-auto">
            {howItWorks.subtitle}
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
          {howItWorks.steps.map((step, index) => (
            <div key={index} className="relative">
              {/* Step Card */}
              <div className="card space-y-4">
                {/* Step Number */}
                <div className="inline-block">
                  <span className="text-6xl font-bold text-primary/20">
                    {step.number}
                  </span>
                </div>

                {/* Content */}
                <div className="space-y-3">
                  <h3 className="text-2xl font-semibold text-neutral-black">
                    {step.title}
                  </h3>
                  <p className="text-neutral-700 leading-relaxed">
                    {step.description}
                  </p>
                </div>
              </div>

              {/* Connector Arrow (desktop only) */}
              {index < howItWorks.steps.length - 1 && (
                <div className="hidden lg:block absolute top-1/2 -right-4 transform -translate-y-1/2 text-primary/30">
                  <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
                  </svg>
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
