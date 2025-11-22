/**
 * Use Cases Section (For Individuals / For Platforms)
 * Source: claude.md Section 1 (Primary Audiences)
 */

import { useCases } from '@/config/content';

export default function UseCases() {
  return (
    <section id="use-cases" className="bg-neutral-900 text-white section-padding">
      <div className="container-custom">
        <div className="grid lg:grid-cols-2 gap-12">
          {/* For Individuals */}
          <div className="space-y-6">
            <div className="space-y-4">
              <h2 className="text-white">{useCases.individuals.title}</h2>
              <p className="text-xl text-neutral-300">
                {useCases.individuals.description}
              </p>
            </div>

            <ul className="space-y-4">
              {useCases.individuals.benefits.map((benefit, index) => (
                <li key={index} className="flex items-start gap-3">
                  <svg className="w-6 h-6 text-success flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                  </svg>
                  <span className="text-lg text-neutral-200">{benefit}</span>
                </li>
              ))}
            </ul>

            <button className="btn-primary mt-6">
              Get Your SilentID
            </button>
          </div>

          {/* For Platforms */}
          <div className="space-y-6 lg:border-l lg:border-neutral-700 lg:pl-12">
            <div className="space-y-4">
              <h2 className="text-white">{useCases.platforms.title}</h2>
              <p className="text-xl text-neutral-300">
                {useCases.platforms.description}
              </p>
            </div>

            <ul className="space-y-4">
              {useCases.platforms.benefits.map((benefit, index) => (
                <li key={index} className="flex items-start gap-3">
                  <svg className="w-6 h-6 text-primary-light flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                  </svg>
                  <span className="text-lg text-neutral-200">{benefit}</span>
                </li>
              ))}
            </ul>

            <button className="btn-secondary border-white text-white hover:bg-white/10 mt-6">
              Learn About Integration
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
