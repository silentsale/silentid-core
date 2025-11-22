/**
 * Key Features Section
 * Source: claude.md Section 3 & 5 (System Overview, Core Features)
 */

import { features } from '@/config/content';

export default function Features() {
  return (
    <section id="features" className="bg-primary-light/30 section-padding">
      <div className="container-custom">
        <div className="text-center space-y-4 mb-16">
          <h2>{features.title}</h2>
          <p className="text-xl text-neutral-700 max-w-3xl mx-auto">
            {features.subtitle}
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.list.map((feature, index) => (
            <div key={index} className="card group hover:border-primary/20">
              <div className="space-y-4">
                {/* Icon */}
                <div className="feature-icon">
                  <svg className="w-8 h-8" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                  </svg>
                </div>

                {/* Content */}
                <div className="space-y-2">
                  <h3 className="text-xl font-semibold text-neutral-black">
                    {feature.title}
                  </h3>
                  <p className="text-neutral-700">
                    {feature.description}
                  </p>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
