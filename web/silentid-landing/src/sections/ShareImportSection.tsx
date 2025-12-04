'use client';

import { motion } from 'framer-motion';
import SectionShell from '@/components/landing/SectionShell';
import PhoneMockup from '@/components/landing/PhoneMockup';
import { ShareImportScreen } from '@/components/landing/AppScreens';
import { shareImport } from '@/config/content';

const platformColors: Record<string, string> = {
  Vinted: 'bg-[#09B1BA]',
  eBay: 'bg-[#E53238]',
  Depop: 'bg-[#FF2300]',
  Etsy: 'bg-[#F56400]',
  Instagram: 'bg-gradient-to-br from-[#E4405F] to-[#FD1D1D]',
  TikTok: 'bg-black',
  'Twitter/X': 'bg-[#1DA1F2]',
  LinkedIn: 'bg-[#0A66C2]',
  Discord: 'bg-[#5865F2]',
  YouTube: 'bg-[#FF0000]',
};

export default function ShareImportSection() {
  return (
    <SectionShell background="gradient" className="py-24" id="share-import">
      <div className="grid lg:grid-cols-2 gap-12 lg:gap-20 items-center">
        {/* Left: Phone Mockup */}
        <motion.div
          initial={{ opacity: 0, x: -50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="relative order-2 lg:order-1"
        >
          <PhoneMockup variant="tilted">
            <ShareImportScreen />
          </PhoneMockup>

          {/* Floating share indicators */}
          <motion.div
            className="absolute -top-4 right-8 bg-white rounded-xl p-3 shadow-xl"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.4 }}
          >
            <div className="flex items-center gap-2">
              <div className="w-8 h-8 bg-[#09B1BA] rounded-lg flex items-center justify-center text-white text-xs font-bold">
                V
              </div>
              <div className="text-xs">
                <div className="font-medium text-neutral-900">Profile shared!</div>
                <div className="text-neutral-500">Detecting Vinted...</div>
              </div>
            </div>
          </motion.div>

          <motion.div
            className="absolute bottom-20 -left-4 bg-white rounded-xl p-3 shadow-xl"
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.6 }}
          >
            <div className="flex items-center gap-2">
              <div className="w-6 h-6 bg-green-500 rounded-full flex items-center justify-center">
                <svg className="w-3.5 h-3.5 text-white" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                </svg>
              </div>
              <div className="text-xs font-medium text-green-700">Verified in 10s</div>
            </div>
          </motion.div>
        </motion.div>

        {/* Right: Content */}
        <motion.div
          initial={{ opacity: 0, x: 50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="order-1 lg:order-2"
        >
          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-amber-100 text-amber-800 text-sm font-medium mb-6">
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
            </svg>
            {shareImport.tagline}
          </div>

          <h2 className="text-4xl md:text-5xl font-bold text-white mb-6">
            {shareImport.title}
          </h2>

          <p className="text-xl text-white/80 mb-8">
            {shareImport.description}
          </p>

          {/* Steps */}
          <div className="space-y-4 mb-8">
            {shareImport.steps.map((step, index) => (
              <motion.div
                key={index}
                className="flex items-start gap-4 bg-white/10 backdrop-blur-sm rounded-xl p-4"
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: 0.2 + index * 0.1 }}
              >
                <div className="w-8 h-8 rounded-full bg-white text-[#5A3EB8] flex items-center justify-center font-bold text-sm flex-shrink-0">
                  {step.number}
                </div>
                <div>
                  <div className="font-semibold text-white">{step.title}</div>
                  <div className="text-sm text-white/70">{step.description}</div>
                </div>
              </motion.div>
            ))}
          </div>

          {/* Supported Platforms Grid */}
          <div className="mb-8">
            <div className="text-sm text-white/60 mb-3">Works with 20+ platforms</div>
            <div className="flex flex-wrap gap-2">
              {shareImport.platforms.map((platform, index) => (
                <motion.div
                  key={index}
                  className={`${platformColors[platform.name] || 'bg-neutral-500'} text-white text-sm px-3 py-1.5 rounded-full font-medium flex items-center gap-1.5 shadow-lg`}
                  initial={{ scale: 0 }}
                  whileInView={{ scale: 1 }}
                  viewport={{ once: true }}
                  transition={{ delay: 0.4 + index * 0.03 }}
                  whileHover={{ scale: 1.05 }}
                >
                  <span className="w-5 h-5 bg-white/20 rounded flex items-center justify-center text-xs font-bold">
                    {platform.name[0]}
                  </span>
                  {platform.name}
                </motion.div>
              ))}
              <motion.div
                className="bg-white/20 text-white text-sm px-3 py-1.5 rounded-full font-medium"
                initial={{ scale: 0 }}
                whileInView={{ scale: 1 }}
                viewport={{ once: true }}
                transition={{ delay: 0.7 }}
              >
                +10 more
              </motion.div>
            </div>
          </div>

          {/* Benefits */}
          <div className="space-y-2">
            {shareImport.benefits.map((benefit, index) => (
              <motion.div
                key={index}
                className="flex items-center gap-2 text-white/80"
                initial={{ opacity: 0, x: 20 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: 0.5 + index * 0.1 }}
              >
                <svg className="w-4 h-4 text-green-400 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                </svg>
                <span className="text-sm">{benefit}</span>
              </motion.div>
            ))}
          </div>
        </motion.div>
      </div>
    </SectionShell>
  );
}
