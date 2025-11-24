'use client';

import { motion, useMotionValue, useTransform } from 'framer-motion';
import { useState } from 'react';
import SectionShell from '@/components/landing/SectionShell';

const evidenceTypes = [
  {
    title: 'Email Receipts',
    description: 'Connect your inbox to automatically scan order confirmations from marketplaces like Vinted, eBay, and Depop.',
    icon: (
      <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
      </svg>
    ),
    color: 'from-[#5A3EB8] to-[#462F8F]',
    examples: ['Vinted order', 'eBay purchase', 'Depop sale']
  },
  {
    title: 'Screenshots',
    description: 'Upload screenshots of your marketplace reviews, ratings, and sales history. AI verifies authenticity.',
    icon: (
      <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
      </svg>
    ),
    color: 'from-[#1FBF71] to-[#0E9F5E]',
    examples: ['Profile stats', '5-star review', 'Sales history']
  },
  {
    title: 'Public Profiles',
    description: 'Link your public seller profiles. We verify your ratings, reviews, and account history across platforms.',
    icon: (
      <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
      </svg>
    ),
    color: 'from-[#FFC043] to-[#FF9F1C]',
    examples: ['Vinted profile', 'eBay seller', 'Etsy shop']
  }
];

export default function EvidenceVaultSection() {
  const [hoveredIndex, setHoveredIndex] = useState<number | null>(null);
  const mouseX = useMotionValue(0);
  const mouseY = useMotionValue(0);

  const rotateX = useTransform(mouseY, [-100, 100], [5, -5]);
  const rotateY = useTransform(mouseX, [-100, 100], [-5, 5]);

  const handleMouseMove = (e: React.MouseEvent<HTMLDivElement>) => {
    const rect = e.currentTarget.getBoundingClientRect();
    const x = e.clientX - rect.left - rect.width / 2;
    const y = e.clientY - rect.top - rect.height / 2;
    mouseX.set(x);
    mouseY.set(y);
  };

  return (
    <SectionShell background="white" className="py-24">
      <div className="grid lg:grid-cols-2 gap-16 items-center">
        {/* Left: Stacking Cards Visualization */}
        <motion.div
          initial={{ opacity: 0, x: -50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8 }}
          className="relative flex justify-center"
          onMouseMove={handleMouseMove}
          onMouseLeave={() => {
            mouseX.set(0);
            mouseY.set(0);
          }}
        >
          <div className="relative w-full max-w-md">
            {/* Glow effect */}
            <div className="absolute inset-0 bg-gradient-to-r from-[#5A3EB8] to-[#1FBF71] opacity-20 blur-3xl" />

            {/* Stacked Cards */}
            <div className="relative" style={{ perspective: 1000 }}>
              {evidenceTypes.map((type, index) => (
                <motion.div
                  key={index}
                  initial={{ opacity: 0, y: 50, rotateX: -20 }}
                  whileInView={{ opacity: 1, y: 0, rotateX: 0 }}
                  viewport={{ once: true }}
                  transition={{ delay: index * 0.2, duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
                  style={{
                    rotateX: hoveredIndex === index ? rotateX : 0,
                    rotateY: hoveredIndex === index ? rotateY : 0,
                    transformStyle: 'preserve-3d',
                    zIndex: hoveredIndex === index ? 30 : 20 - index,
                  }}
                  whileHover={{
                    y: -20,
                    scale: 1.05,
                    transition: { duration: 0.3 }
                  }}
                  onMouseEnter={() => setHoveredIndex(index)}
                  onMouseLeave={() => setHoveredIndex(null)}
                  className={`absolute top-0 left-0 right-0 bg-white rounded-2xl shadow-2xl border border-neutral-200 p-8 cursor-pointer`}
                  animate={{
                    y: index * 24,
                    scale: 1 - index * 0.05,
                  }}
                >
                  {/* Icon */}
                  <div className={`w-16 h-16 mb-6 rounded-2xl bg-gradient-to-br ${type.color} flex items-center justify-center text-white shadow-lg`}>
                    {type.icon}
                  </div>

                  {/* Title */}
                  <h3 className="text-2xl font-bold text-neutral-900 mb-3">
                    {type.title}
                  </h3>

                  {/* Description */}
                  <p className="text-neutral-600 mb-4 leading-relaxed">
                    {type.description}
                  </p>

                  {/* Examples */}
                  <div className="flex flex-wrap gap-2">
                    {type.examples.map((example, i) => (
                      <span
                        key={i}
                        className="px-3 py-1 rounded-full bg-neutral-100 text-neutral-700 text-sm"
                      >
                        {example}
                      </span>
                    ))}
                  </div>

                  {/* AI Verified Badge (for Screenshots) */}
                  {index === 1 && (
                    <div className="mt-4 flex items-center gap-2 text-sm text-[#1FBF71]">
                      <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M11 3a1 1 0 10-2 0v1a1 1 0 102 0V3zM15.657 5.757a1 1 0 00-1.414-1.414l-.707.707a1 1 0 001.414 1.414l.707-.707zM18 10a1 1 0 01-1 1h-1a1 1 0 110-2h1a1 1 0 011 1zM5.05 6.464A1 1 0 106.464 5.05l-.707-.707a1 1 0 00-1.414 1.414l.707.707zM5 10a1 1 0 01-1 1H3a1 1 0 110-2h1a1 1 0 011 1zM8 16v-1h4v1a2 2 0 11-4 0zM12 14c.015-.34.208-.646.477-.859a4 4 0 10-4.954 0c.27.213.462.519.476.859h4.002z" />
                      </svg>
                      <span className="font-medium">AI Integrity Check</span>
                    </div>
                  )}
                </motion.div>
              ))}

              {/* Spacer to prevent layout collapse */}
              <div className="opacity-0 pointer-events-none">
                <div className="rounded-2xl p-8" style={{ marginTop: '120px' }}>
                  <div className="w-16 h-16 mb-6" />
                  <div className="h-8 mb-3" />
                  <div className="h-20 mb-4" />
                  <div className="flex gap-2">
                    <div className="w-20 h-6" />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </motion.div>

        {/* Right: Content */}
        <motion.div
          initial={{ opacity: 0, x: 50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8 }}
        >
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6 }}
            className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-[#FFC043]/10 text-[#FFC043] text-sm font-medium mb-6"
          >
            <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
              <path d="M7 3a1 1 0 000 2h6a1 1 0 100-2H7zM4 7a1 1 0 011-1h10a1 1 0 110 2H5a1 1 0 01-1-1zM2 11a2 2 0 012-2h12a2 2 0 012 2v4a2 2 0 01-2 2H4a2 2 0 01-2-2v-4z" />
            </svg>
            Evidence Vault
          </motion.div>

          <h2 className="text-4xl md:text-5xl font-bold text-neutral-900 mb-6">
            Build trust with{' '}
            <span className="bg-gradient-to-r from-[#5A3EB8] to-[#462F8F] bg-clip-text text-transparent">
              real evidence
            </span>
          </h2>

          <p className="text-xl text-neutral-600 mb-8 leading-relaxed">
            Your TrustScore isn't based on claims—it's built on verified proof of your trading history across marketplaces.
          </p>

          {/* Features List */}
          <div className="space-y-4 mb-8">
            <motion.div
              initial={{ opacity: 0, x: 20 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ delay: 0.2, duration: 0.6 }}
              className="flex items-start gap-4"
            >
              <div className="flex-shrink-0 w-10 h-10 rounded-xl bg-[#5A3EB8]/10 flex items-center justify-center text-[#5A3EB8]">
                <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                </svg>
              </div>
              <div>
                <h3 className="font-semibold text-neutral-900 mb-1">
                  Automatic Scanning
                </h3>
                <p className="text-neutral-600">
                  Connect your email once—we automatically find and verify marketplace receipts.
                </p>
              </div>
            </motion.div>

            <motion.div
              initial={{ opacity: 0, x: 20 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ delay: 0.3, duration: 0.6 }}
              className="flex items-start gap-4"
            >
              <div className="flex-shrink-0 w-10 h-10 rounded-xl bg-[#1FBF71]/10 flex items-center justify-center text-[#1FBF71]">
                <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                </svg>
              </div>
              <div>
                <h3 className="font-semibold text-neutral-900 mb-1">
                  AI Integrity Check
                </h3>
                <p className="text-neutral-600">
                  Every screenshot is verified for tampering. Fake evidence is automatically rejected.
                </p>
              </div>
            </motion.div>

            <motion.div
              initial={{ opacity: 0, x: 20 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true }}
              transition={{ delay: 0.4, duration: 0.6 }}
              className="flex items-start gap-4"
            >
              <div className="flex-shrink-0 w-10 h-10 rounded-xl bg-[#FFC043]/10 flex items-center justify-center text-[#FFC043]">
                <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                </svg>
              </div>
              <div>
                <h3 className="font-semibold text-neutral-900 mb-1">
                  Cross-Platform Verification
                </h3>
                <p className="text-neutral-600">
                  We verify your username, ratings, and review count match across all your linked profiles.
                </p>
              </div>
            </motion.div>
          </div>

          {/* Privacy Notice */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.6, duration: 0.6 }}
            className="p-6 rounded-2xl bg-[#5A3EB8]/5 border border-[#5A3EB8]/20"
          >
            <div className="flex items-start gap-3">
              <svg className="w-6 h-6 text-[#5A3EB8] flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clipRule="evenodd" />
              </svg>
              <div>
                <p className="text-sm text-neutral-700 leading-relaxed">
                  <strong>Privacy First:</strong> We only scan receipts—not personal emails. You can disconnect anytime. We store transaction summaries, not full emails.
                </p>
              </div>
            </div>
          </motion.div>

          {/* Storage Info */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.7, duration: 0.6 }}
            className="mt-6 flex items-center gap-4 text-sm text-neutral-600"
          >
            <div className="flex items-center gap-2">
              <svg className="w-5 h-5 text-[#5A3EB8]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4" />
              </svg>
              <span>Free: 250MB vault</span>
            </div>
            <div className="flex items-center gap-2">
              <svg className="w-5 h-5 text-[#1FBF71]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
              </svg>
              <span>Premium: 100GB vault</span>
            </div>
          </motion.div>
        </motion.div>
      </div>
    </SectionShell>
  );
}
