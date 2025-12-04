'use client';

import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import SectionShell from '@/components/landing/SectionShell';
import { faq } from '@/config/content';

export default function FAQSection() {
  const [openIndex, setOpenIndex] = useState<number | null>(0);

  return (
    <SectionShell background="subtle" className="py-24" id="faq">
      <div className="text-center mb-16">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-[#5A3EB8]/10 text-[#5A3EB8] text-sm font-medium mb-6"
        >
          <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
            <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-3a1 1 0 00-.867.5 1 1 0 11-1.731-1A3 3 0 0113 8a3.001 3.001 0 01-2 2.83V11a1 1 0 11-2 0v-1a1 1 0 011-1 1 1 0 100-2zm0 8a1 1 0 100-2 1 1 0 000 2z" clipRule="evenodd" />
          </svg>
          FAQ
        </motion.div>

        <motion.h2
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.1, duration: 0.6 }}
          className="text-4xl md:text-5xl font-bold text-neutral-900 mb-6"
        >
          {faq.title}
        </motion.h2>

        <motion.p
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.2, duration: 0.6 }}
          className="text-xl text-neutral-600 max-w-3xl mx-auto"
        >
          {faq.subtitle}
        </motion.p>
      </div>

      {/* FAQ Grid - Two columns on desktop */}
      <div className="max-w-5xl mx-auto">
        <div className="space-y-4">
          {faq.questions.map((item, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, margin: '-50px' }}
              transition={{ delay: index * 0.05, duration: 0.4 }}
              className="bg-white rounded-2xl shadow-sm border border-neutral-200 overflow-hidden"
            >
              <button
                onClick={() => setOpenIndex(openIndex === index ? null : index)}
                className="w-full p-6 text-left flex items-start justify-between gap-4 hover:bg-[#5A3EB8]/5 transition-colors duration-200"
                aria-expanded={openIndex === index}
                aria-controls={`faq-answer-${index}`}
              >
                <div className="flex items-start gap-4">
                  <div className={`flex-shrink-0 w-8 h-8 rounded-lg flex items-center justify-center transition-colors ${
                    openIndex === index ? 'bg-[#5A3EB8] text-white' : 'bg-[#5A3EB8]/10 text-[#5A3EB8]'
                  }`}>
                    <span className="text-sm font-bold">{index + 1}</span>
                  </div>
                  <h3 className="text-lg font-semibold text-neutral-900 text-left">
                    {item.question}
                  </h3>
                </div>
                <motion.div
                  animate={{ rotate: openIndex === index ? 180 : 0 }}
                  transition={{ duration: 0.2 }}
                  className="flex-shrink-0 w-8 h-8 rounded-lg bg-neutral-100 flex items-center justify-center"
                >
                  <svg className="w-5 h-5 text-neutral-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                  </svg>
                </motion.div>
              </button>

              <AnimatePresence>
                {openIndex === index && (
                  <motion.div
                    id={`faq-answer-${index}`}
                    initial={{ height: 0, opacity: 0 }}
                    animate={{ height: 'auto', opacity: 1 }}
                    exit={{ height: 0, opacity: 0 }}
                    transition={{ duration: 0.3 }}
                    className="overflow-hidden"
                  >
                    <div className="px-6 pb-6 pt-0">
                      <div className="pl-12">
                        <p className="text-neutral-600 leading-relaxed">
                          {item.answer}
                        </p>
                        {/* SEO: Keywords as tags (visible but subtle) */}
                        {'keywords' in item && item.keywords && (
                          <div className="mt-4 flex flex-wrap gap-2">
                            {(item.keywords as string[]).slice(0, 5).map((keyword, kidx) => (
                              <span
                                key={kidx}
                                className="text-xs px-2 py-1 bg-neutral-100 text-neutral-500 rounded-full"
                              >
                                {keyword}
                              </span>
                            ))}
                          </div>
                        )}
                      </div>
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>
            </motion.div>
          ))}
        </div>
      </div>

      {/* CTA below FAQ */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ delay: 0.5, duration: 0.6 }}
        className="mt-16 text-center"
      >
        <div className="bg-white rounded-2xl p-8 shadow-lg border border-neutral-200 max-w-2xl mx-auto">
          <h3 className="text-xl font-bold text-neutral-900 mb-3">
            Still have questions?
          </h3>
          <p className="text-neutral-600 mb-6">
            Our support team is here to help you protect your online reputation.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <button className="px-6 py-3 bg-[#5A3EB8] text-white font-medium rounded-xl hover:bg-[#462F8F] transition-colors">
              Contact Support
            </button>
            <button className="px-6 py-3 bg-neutral-100 text-neutral-700 font-medium rounded-xl hover:bg-neutral-200 transition-colors">
              Visit Help Center
            </button>
          </div>
        </div>
      </motion.div>
    </SectionShell>
  );
}
