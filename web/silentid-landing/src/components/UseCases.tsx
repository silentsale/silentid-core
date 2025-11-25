/**
 * Use Cases Section (For Individuals / For Platforms)
 * Source: claude.md Section 1 (Primary Audiences)
 */

'use client';

import { useCases } from '@/config/content';

export default function UseCases() {
  return (
    <section id="use-cases" className="relative bg-neutral-900 text-white section-padding overflow-hidden">
      {/* Subtle background pattern */}
      <div className="absolute inset-0 opacity-5">
        <div className="absolute top-0 left-0 w-96 h-96 bg-primary rounded-full blur-3xl" />
        <div className="absolute bottom-0 right-0 w-96 h-96 bg-primary-light rounded-full blur-3xl" />
      </div>

      <div className="container-custom relative z-10">
        <div className="grid lg:grid-cols-2 gap-12 lg:gap-16">
          {/* For Individuals */}
          <div className="space-y-8">
            <div className="space-y-4">
              {/* Icon badge */}
              <div className="inline-flex items-center gap-2 px-4 py-2 bg-primary/20 rounded-full mb-2">
                <svg className="w-5 h-5 text-primary-light" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                </svg>
                <span className="text-sm font-semibold text-primary-light">For Individuals</span>
              </div>

              <h2 className="text-white">{useCases.individuals.title}</h2>
              <p className="text-xl text-neutral-300">
                {useCases.individuals.description}
              </p>
            </div>

            <ul className="space-y-3">
              {useCases.individuals.benefits.map((benefit, index) => (
                <li
                  key={index}
                  className="flex items-start gap-3 group"
                  style={{ animationDelay: `${index * 50}ms` }}
                >
                  <div className="flex-shrink-0 w-7 h-7 rounded-full bg-success/20 flex items-center justify-center group-hover:bg-success/30 transition-colors duration-300">
                    <svg className="w-4 h-4 text-success" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                  </div>
                  <span className="text-lg text-neutral-200 group-hover:text-white transition-colors duration-300">{benefit}</span>
                </li>
              ))}
            </ul>

            <button className="btn-primary mt-6 shadow-lg hover:shadow-xl">
              Get Your SilentID
            </button>
          </div>

          {/* For Platforms */}
          <div className="space-y-8 lg:border-l-2 lg:border-neutral-700/50 lg:pl-12">
            <div className="space-y-4">
              {/* Icon badge */}
              <div className="inline-flex items-center gap-2 px-4 py-2 bg-primary-light/20 rounded-full mb-2">
                <svg className="w-5 h-5 text-primary-light" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                </svg>
                <span className="text-sm font-semibold text-primary-light">For Platforms</span>
              </div>

              <h2 className="text-white">{useCases.platforms.title}</h2>
              <p className="text-xl text-neutral-300">
                {useCases.platforms.description}
              </p>
            </div>

            <ul className="space-y-3">
              {useCases.platforms.benefits.map((benefit, index) => (
                <li
                  key={index}
                  className="flex items-start gap-3 group"
                  style={{ animationDelay: `${index * 50}ms` }}
                >
                  <div className="flex-shrink-0 w-7 h-7 rounded-full bg-primary-light/20 flex items-center justify-center group-hover:bg-primary-light/30 transition-colors duration-300">
                    <svg className="w-4 h-4 text-primary-light" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                  </div>
                  <span className="text-lg text-neutral-200 group-hover:text-white transition-colors duration-300">{benefit}</span>
                </li>
              ))}
            </ul>

            <button className="btn-secondary border-2 border-white text-white hover:bg-white/10 mt-6 shadow-lg hover:shadow-xl">
              Learn About Integration
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
