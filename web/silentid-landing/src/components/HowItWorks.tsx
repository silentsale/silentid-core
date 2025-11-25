/**
 * How It Works Section
 * Source: claude.md Section 5 & 6 (Core Features, Feature Flows)
 */

'use client';

import { howItWorks } from '@/config/content';

// Icon components for each step
const StepIcon = ({ stepNumber }: { stepNumber: number }) => {
  const icons = {
    1: (
      <svg className="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
      </svg>
    ),
    2: (
      <svg className="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
      </svg>
    ),
    3: (
      <svg className="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
      </svg>
    ),
    4: (
      <svg className="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>
    )
  };

  return icons[stepNumber as keyof typeof icons] || null;
};

export default function HowItWorks() {
  return (
    <section id="how-it-works" className="bg-white section-padding scroll-mt-20">
      <div className="container-custom">
        <div className="text-center space-y-4 mb-16 animate-fade-in">
          <h2>{howItWorks.title}</h2>
          <p className="text-xl text-neutral-700 max-w-3xl mx-auto">
            {howItWorks.subtitle}
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8">
          {howItWorks.steps.map((step, index) => (
            <div
              key={index}
              className="relative group"
              style={{ animationDelay: `${index * 100}ms` }}
            >
              {/* Step Card */}
              <div className="card space-y-4 h-full border border-transparent hover:border-primary/30 transition-all duration-300 hover:-translate-y-1">
                {/* Icon Circle with Step Number */}
                <div className="relative">
                  <div className="w-20 h-20 rounded-full bg-primary-light flex items-center justify-center text-primary group-hover:scale-110 transition-transform duration-300">
                    <StepIcon stepNumber={parseInt(step.number)} />
                  </div>
                  <div className="absolute -bottom-2 -right-2 w-10 h-10 rounded-full bg-primary text-white flex items-center justify-center font-bold text-lg shadow-lg">
                    {step.number}
                  </div>
                </div>

                {/* Content */}
                <div className="space-y-3 pt-2">
                  <h3 className="text-xl font-semibold text-neutral-black">
                    {step.title}
                  </h3>
                  <p className="text-neutral-700 leading-relaxed text-sm">
                    {step.description}
                  </p>
                </div>
              </div>

              {/* Connector Arrow (desktop only) */}
              {index < howItWorks.steps.length - 1 && (
                <div className="hidden lg:block absolute top-20 -right-4 transform -translate-y-1/2 z-10">
                  <div className="w-8 h-8 bg-white rounded-full flex items-center justify-center border-2 border-primary/20 group-hover:border-primary/40 transition-colors duration-300">
                    <svg className="w-5 h-5 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M13 7l5 5m0 0l-5 5m5-5H6" />
                    </svg>
                  </div>
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
