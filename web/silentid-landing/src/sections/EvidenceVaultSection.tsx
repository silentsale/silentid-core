'use client';

import { motion, useMotionValue, useTransform } from 'framer-motion';
import { useState } from 'react';
import SectionShell from '@/components/landing/SectionShell';

const platformTypes = [
  {
    title: 'Marketplaces',
    description: 'Connect your Vinted, eBay, Depop, Etsy, and Poshmark seller profiles. We verify your ratings and reviews.',
    icon: (
      <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z" />
      </svg>
    ),
    color: 'from-[#5A3EB8] to-[#462F8F]',
    examples: ['Vinted', 'eBay', 'Depop', 'Etsy']
  },
  {
    title: 'Social Media',
    description: 'Link your Instagram, TikTok, Twitter, and LinkedIn profiles to show your online presence and credibility.',
    icon: (
      <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
      </svg>
    ),
    color: 'from-[#1FBF71] to-[#0E9F5E]',
    examples: ['Instagram', 'TikTok', 'LinkedIn']
  },
  {
    title: 'Professional',
    description: 'Connect GitHub, Behance, or other professional profiles to showcase your skills and work history.',
    icon: (
      <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
      </svg>
    ),
    color: 'from-[#FFC043] to-[#FF9F1C]',
    examples: ['GitHub', 'Behance', 'Discord']
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
              {platformTypes.map((type, index) => (
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

                  {/* Verified Badge */}
                  {index === 0 && (
                    <div className="mt-4 flex items-center gap-2 text-sm text-[#5A3EB8]">
                      <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                      </svg>
                      <span className="font-medium">Ownership Verified</span>
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
            className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-[#5A3EB8]/10 text-[#5A3EB8] text-sm font-medium mb-6"
          >
            <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
              <path d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
            </svg>
            Profile Verification
          </motion.div>

          <h2 className="text-4xl md:text-5xl font-bold text-neutral-900 mb-6">
            Connect your{' '}
            <span className="bg-gradient-to-r from-[#5A3EB8] to-[#462F8F] bg-clip-text text-transparent">
              existing profiles
            </span>
          </h2>

          <p className="text-xl text-neutral-600 mb-8 leading-relaxed">
            Your TrustScore is built on your verified presence across marketplaces and social platforms. Link once, prove everywhere.
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
                  One-Click Verification
                </h3>
                <p className="text-neutral-600">
                  Add a unique code to your profile bio, and we instantly verify you own the account.
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
                  Ratings & Reviews Imported
                </h3>
                <p className="text-neutral-600">
                  Your 5-star Vinted rating or 100% eBay feedback automatically boosts your TrustScore.
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
                  Share Your Verified Badge
                </h3>
                <p className="text-neutral-600">
                  Get a verified badge image to add to your social media bio with a link to your Trust Passport.
                </p>
              </div>
            </motion.div>
          </div>

          {/* Trust Badge Preview */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.6, duration: 0.6 }}
            className="p-6 rounded-2xl bg-gradient-to-br from-[#5A3EB8]/5 to-[#1FBF71]/5 border border-[#5A3EB8]/20"
          >
            <div className="flex items-center gap-4">
              <div className="w-16 h-16 rounded-xl bg-gradient-to-br from-[#5A3EB8] to-[#462F8F] flex items-center justify-center text-white">
                <svg className="w-8 h-8" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                </svg>
              </div>
              <div>
                <p className="font-semibold text-neutral-900">SilentID Verified Badge</p>
                <p className="text-sm text-neutral-600">Perfect for Instagram, Twitter, or LinkedIn bios</p>
              </div>
            </div>
          </motion.div>

          {/* Platform Count */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.7, duration: 0.6 }}
            className="mt-6 flex items-center gap-4 text-sm text-neutral-600"
          >
            <div className="flex items-center gap-2">
              <svg className="w-5 h-5 text-[#5A3EB8]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
              </svg>
              <span>Free: 5 profiles</span>
            </div>
            <div className="flex items-center gap-2">
              <svg className="w-5 h-5 text-[#1FBF71]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
              </svg>
              <span>Pro: Unlimited profiles</span>
            </div>
          </motion.div>
        </motion.div>
      </div>
    </SectionShell>
  );
}
