'use client';

import { motion } from 'framer-motion';
import { useState } from 'react';
import SectionShell from '@/components/landing/SectionShell';
import CTAButton from '@/components/landing/CTAButton';

const sharingMethods = [
  {
    title: 'Share Link',
    description: 'Copy and paste your personal SilentID URL',
    icon: (
      <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
      </svg>
    ),
    example: 'silentid.co.uk/u/sarahtrusted',
    color: 'from-[#5A3EB8] to-[#462F8F]'
  },
  {
    title: 'Show QR Code',
    description: 'Scan in person for instant verification',
    icon: (
      <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z" />
      </svg>
    ),
    example: 'Perfect for meetups & trades',
    color: 'from-[#1FBF71] to-[#0E9F5E]'
  },
  {
    title: 'Embed Badge',
    description: 'Add your TrustScore to listings',
    icon: (
      <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
      </svg>
    ),
    example: 'Copy embed code',
    color: 'from-[#FFC043] to-[#FF9F1C]'
  }
];

const useCases = [
  { platform: 'Vinted', icon: '👕' },
  { platform: 'eBay', icon: '🛍️' },
  { platform: 'Depop', icon: '👗' },
  { platform: 'Facebook Marketplace', icon: '📱' },
  { platform: 'Tinder', icon: '💕' },
  { platform: 'Bumble', icon: '🐝' },
  { platform: 'Meetup', icon: '🤝' },
  { platform: 'WhatsApp', icon: '💬' }
];

export default function PassportSection() {
  const [scanProgress, setScanProgress] = useState(0);

  // Simulate QR code scan animation
  useState(() => {
    const interval = setInterval(() => {
      setScanProgress((prev) => (prev >= 100 ? 0 : prev + 2));
    }, 50);
    return () => clearInterval(interval);
  });

  return (
    <SectionShell background="white" className="py-24">
      <div className="grid lg:grid-cols-2 gap-16 items-center">
        {/* Left: Content */}
        <motion.div
          initial={{ opacity: 0, x: -50 }}
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
              <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
            </svg>
            Your Digital Trust Passport
          </motion.div>

          <h2 className="text-4xl md:text-5xl font-bold text-neutral-900 mb-6">
            Portable{' '}
            <span className="bg-gradient-to-r from-[#5A3EB8] to-[#462F8F] bg-clip-text text-transparent">
              Everywhere
            </span>
          </h2>

          <p className="text-xl text-neutral-600 mb-8 leading-relaxed">
            Your SilentID profile works across all platforms. Share via link, QR code, or embed your TrustScore badge directly in marketplace listings.
          </p>

          {/* Sharing Methods */}
          <div className="space-y-4 mb-8">
            {sharingMethods.map((method, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, x: -20 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.1, duration: 0.6 }}
                className="group"
              >
                <div className="flex items-start gap-4 p-4 rounded-xl bg-white border border-neutral-200 hover:border-[#5A3EB8]/50 transition-all hover:shadow-lg">
                  <div className={`w-14 h-14 rounded-xl bg-gradient-to-br ${method.color} flex items-center justify-center text-white flex-shrink-0`}>
                    {method.icon}
                  </div>
                  <div className="flex-1">
                    <h3 className="font-semibold text-neutral-900 mb-1">
                      {method.title}
                    </h3>
                    <p className="text-sm text-neutral-600 mb-2">
                      {method.description}
                    </p>
                    <code className="text-xs text-[#5A3EB8] bg-[#E8E2FF] px-2 py-1 rounded">
                      {method.example}
                    </code>
                  </div>
                </div>
              </motion.div>
            ))}
          </div>

          {/* Use Cases */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.4, duration: 0.6 }}
          >
            <p className="text-sm text-neutral-500 mb-3">Works everywhere:</p>
            <div className="flex flex-wrap gap-2">
              {useCases.map((useCase, index) => (
                <motion.div
                  key={index}
                  initial={{ opacity: 0, scale: 0.8 }}
                  whileInView={{ opacity: 1, scale: 1 }}
                  viewport={{ once: true }}
                  transition={{ delay: 0.4 + index * 0.05, duration: 0.4 }}
                  className="inline-flex items-center gap-2 px-3 py-2 rounded-full bg-neutral-100 text-sm text-neutral-700"
                >
                  <span>{useCase.icon}</span>
                  <span>{useCase.platform}</span>
                </motion.div>
              ))}
            </div>
          </motion.div>
        </motion.div>

        {/* Right: QR Code + Profile Card Visualization */}
        <motion.div
          initial={{ opacity: 0, x: 50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8 }}
          className="relative"
        >
          {/* Glow effect */}
          <div className="absolute inset-0 bg-gradient-to-r from-[#5A3EB8] to-[#462F8F] opacity-20 blur-3xl" />

          {/* Main visualization container */}
          <div className="relative flex flex-col items-center gap-8">
            {/* QR Code */}
            <motion.div
              initial={{ opacity: 0, scale: 0.9 }}
              whileInView={{ opacity: 1, scale: 1 }}
              viewport={{ once: true }}
              transition={{ delay: 0.2, duration: 0.6 }}
              className="relative"
            >
              <div className="w-64 h-64 bg-white rounded-3xl shadow-2xl p-6 border border-neutral-200">
                {/* QR Code Pattern (simplified visual) */}
                <div className="w-full h-full bg-gradient-to-br from-neutral-900 to-neutral-700 rounded-2xl relative overflow-hidden">
                  {/* QR code squares pattern */}
                  <div className="absolute inset-4 grid grid-cols-8 grid-rows-8 gap-1">
                    {Array.from({ length: 64 }).map((_, i) => (
                      <motion.div
                        key={i}
                        className="bg-white rounded-sm"
                        initial={{ opacity: Math.random() > 0.3 ? 1 : 0 }}
                        animate={{ opacity: Math.random() > 0.3 ? 1 : 0 }}
                        transition={{ duration: 2, repeat: Infinity, delay: i * 0.02 }}
                      />
                    ))}
                  </div>

                  {/* Scan line animation */}
                  <motion.div
                    className="absolute left-0 right-0 h-1 bg-gradient-to-r from-transparent via-[#1FBF71] to-transparent opacity-75"
                    style={{ top: `${scanProgress}%` }}
                    animate={{ opacity: [0.5, 1, 0.5] }}
                    transition={{ duration: 1, repeat: Infinity }}
                  />

                  {/* Corner markers */}
                  <div className="absolute top-2 left-2 w-8 h-8 border-4 border-white rounded" />
                  <div className="absolute top-2 right-2 w-8 h-8 border-4 border-white rounded" />
                  <div className="absolute bottom-2 left-2 w-8 h-8 border-4 border-white rounded" />
                </div>
              </div>

              {/* Scan indicator */}
              <motion.div
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.8, duration: 0.6 }}
                className="absolute -bottom-4 left-1/2 -translate-x-1/2 whitespace-nowrap"
              >
                <div className="flex items-center gap-2 px-4 py-2 rounded-full bg-[#1FBF71] text-white text-sm font-medium shadow-lg">
                  <motion.div
                    animate={{ scale: [1, 1.2, 1] }}
                    transition={{ duration: 2, repeat: Infinity }}
                    className="w-2 h-2 rounded-full bg-white"
                  />
                  <span>Ready to scan</span>
                </div>
              </motion.div>
            </motion.div>

            {/* Profile Card Preview */}
            <motion.div
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: 0.4, duration: 0.6 }}
              className="w-full max-w-sm"
            >
              <div className="bg-white rounded-2xl shadow-xl border border-neutral-200 p-6">
                {/* Profile header */}
                <div className="flex items-center gap-4 mb-4">
                  <div className="w-16 h-16 rounded-full bg-gradient-to-br from-[#5A3EB8] to-[#462F8F] flex items-center justify-center text-white text-2xl font-bold">
                    SM
                  </div>
                  <div>
                    <h3 className="font-bold text-neutral-900">Sarah M.</h3>
                    <p className="text-sm text-neutral-500">@sarahtrusted</p>
                  </div>
                </div>

                {/* TrustScore Badge */}
                <div className="mb-4 p-4 rounded-xl bg-gradient-to-r from-[#5A3EB8]/10 to-[#462F8F]/10 border border-[#5A3EB8]/20">
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-sm font-medium text-neutral-700">TrustScore</span>
                    <span className="text-2xl font-bold text-[#5A3EB8]">847</span>
                  </div>
                  <div className="flex items-center gap-2 text-sm text-[#1FBF71]">
                    <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                    </svg>
                    <span className="font-medium">High Trust</span>
                  </div>
                </div>

                {/* Badges */}
                <div className="flex flex-wrap gap-2">
                  <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-[#1FBF71]/10 text-[#1FBF71] text-xs font-medium">
                    <svg className="w-3.5 h-3.5" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                    </svg>
                    Identity Verified
                  </span>
                  <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-[#5A3EB8]/10 text-[#5A3EB8] text-xs font-medium">
                    500+ trades
                  </span>
                  <span className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-neutral-100 text-neutral-700 text-xs font-medium">
                    3 platforms
                  </span>
                </div>
              </div>
            </motion.div>
          </div>
        </motion.div>
      </div>

      {/* Bottom CTA */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ delay: 0.6, duration: 0.6 }}
        className="mt-16 text-center"
      >
        <CTAButton href="#" variant="primary" size="lg">
          Create Your Trust Passport
        </CTAButton>
      </motion.div>
    </SectionShell>
  );
}
