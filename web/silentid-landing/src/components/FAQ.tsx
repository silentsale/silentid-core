/**
 * FAQ Section
 * Source: claude.md Section 21 (Landing Page FAQ)
 */

'use client';

import { useState } from 'react';
import { faq } from '@/config/content';

export default function FAQ() {
  const [openIndex, setOpenIndex] = useState<number | null>(0);

  return (
    <section id="faq" className="bg-white section-padding">
      <div className="container-custom">
        <div className="text-center space-y-4 mb-16">
          <h2>{faq.title}</h2>
          <p className="text-xl text-neutral-700 max-w-3xl mx-auto">
            {faq.subtitle}
          </p>
        </div>

        <div className="max-w-3xl mx-auto space-y-4">
          {faq.questions.map((item, index) => (
            <div
              key={index}
              className="border border-neutral-300 rounded-lg overflow-hidden"
            >
              <button
                onClick={() => setOpenIndex(openIndex === index ? null : index)}
                className="w-full p-6 text-left flex items-center justify-between gap-4 hover:bg-primary-light/30 transition-colors duration-200"
              >
                <span className="text-lg font-semibold text-neutral-black">
                  {item.question}
                </span>
                <svg
                  className={`w-6 h-6 text-primary flex-shrink-0 transition-transform duration-200 ${
                    openIndex === index ? 'transform rotate-180' : ''
                  }`}
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                </svg>
              </button>

              {openIndex === index && (
                <div className="px-6 pb-6">
                  <p className="text-neutral-700 leading-relaxed">
                    {item.answer}
                  </p>
                </div>
              )}
            </div>
          ))}
        </div>

        {/* CTA Below FAQ */}
        <div className="mt-16 text-center">
          <p className="text-lg text-neutral-700 mb-6">
            Still have questions?
          </p>
          <button className="btn-secondary">
            Contact Support
          </button>
        </div>
      </div>
    </section>
  );
}
