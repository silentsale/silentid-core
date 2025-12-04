'use client';

import { motion } from 'framer-motion';
import SectionShell from '@/components/landing/SectionShell';
import PhoneMockup from '@/components/landing/PhoneMockup';
import {
  HorrorStatsScreen,
  TrustScoreScreen,
  ConnectProfilesScreen,
  VerifiedBadgeScreen,
} from '@/components/landing/AppScreens';
import { howItWorks } from '@/config/content';

const stepScreens = [
  <HorrorStatsScreen key="horror" />,
  <TrustScoreScreen key="trust" />,
  <ConnectProfilesScreen key="connect" />,
  <VerifiedBadgeScreen key="badge" />,
];

const stepColors = [
  'from-[#5A3EB8] to-[#462F8F]',
  'from-[#1FBF71] to-[#0E9F5E]',
  'from-[#FFC043] to-[#FF9F1C]',
  'from-[#5A3EB8] to-[#7C3AED]',
];

const stepIcons = [
  <svg key="1" className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z" />
  </svg>,
  <svg key="2" className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
  </svg>,
  <svg key="3" className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
  </svg>,
  <svg key="4" className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
  </svg>,
];

export default function HowItWorksSection() {
  return (
    <SectionShell background="white" className="py-24" id="how-it-works">
      <div className="text-center mb-16">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-[#5A3EB8]/10 text-[#5A3EB8] text-sm font-medium mb-6"
        >
          <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
            <path fillRule="evenodd" d="M11.3 1.046A1 1 0 0112 2v5h4a1 1 0 01.82 1.573l-7 10A1 1 0 018 18v-5H4a1 1 0 01-.82-1.573l7-10a1 1 0 011.12-.38z" clipRule="evenodd" />
          </svg>
          {howItWorks.title}
        </motion.div>

        <motion.h2
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.1, duration: 0.6 }}
          className="text-4xl md:text-5xl font-bold text-neutral-900 mb-6"
        >
          Protect your reputation in{' '}
          <span className="bg-gradient-to-r from-[#5A3EB8] to-[#462F8F] bg-clip-text text-transparent">
            four simple steps
          </span>
        </motion.h2>

        <motion.p
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.2, duration: 0.6 }}
          className="text-xl text-neutral-600 max-w-3xl mx-auto"
        >
          {howItWorks.subtitle}
        </motion.p>
      </div>

      <div className="relative max-w-6xl mx-auto">
        {/* Connection line */}
        <div className="absolute top-0 left-8 md:left-1/2 h-full w-px bg-gradient-to-b from-transparent via-[#5A3EB8]/30 to-transparent hidden md:block" />

        <div className="space-y-16 md:space-y-32">
          {howItWorks.steps.map((step, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, x: index % 2 === 0 ? -50 : 50 }}
              whileInView={{ opacity: 1, x: 0 }}
              viewport={{ once: true, margin: '-100px' }}
              transition={{ delay: index * 0.15, duration: 0.6 }}
              className={`relative grid md:grid-cols-2 gap-8 lg:gap-16 items-center ${
                index % 2 === 1 ? 'md:flex-row-reverse' : ''
              }`}
            >
              {/* Content */}
              <div className={`${index % 2 === 1 ? 'md:col-start-2' : ''}`}>
                <div className={`flex items-start gap-4 ${index % 2 === 1 ? 'md:flex-row-reverse md:text-right' : ''}`}>
                  <div className={`flex-shrink-0 w-16 h-16 rounded-2xl bg-gradient-to-br ${stepColors[index]} text-white flex items-center justify-center shadow-lg`}>
                    {stepIcons[index]}
                  </div>

                  <div className="flex-1">
                    <div className={`text-6xl font-bold bg-gradient-to-br ${stepColors[index]} bg-clip-text text-transparent opacity-20 mb-2`}>
                      {step.number}
                    </div>

                    <h3 className="text-2xl font-bold text-neutral-900 mb-3">
                      {step.title}
                    </h3>

                    <p className="text-neutral-600 leading-relaxed text-lg">
                      {step.description}
                    </p>
                  </div>
                </div>
              </div>

              {/* Phone mockup with real app screen */}
              <div className={`${index % 2 === 1 ? 'md:col-start-1 md:row-start-1' : ''}`}>
                <motion.div
                  whileHover={{ scale: 1.02, rotate: index % 2 === 0 ? 1 : -1 }}
                  transition={{ type: 'spring', stiffness: 300, damping: 20 }}
                  className="relative"
                >
                  <PhoneMockup variant={index % 2 === 0 ? 'tilted' : 'default'}>
                    {stepScreens[index]}
                  </PhoneMockup>

                  {/* Glow effect behind phone */}
                  <div className={`absolute inset-0 -z-10 blur-3xl opacity-20 bg-gradient-to-br ${stepColors[index]} rounded-full scale-75`} />
                </motion.div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ delay: 0.6, duration: 0.6 }}
        className="mt-20 text-center"
      >
        <p className="text-neutral-600 mb-4 text-lg">Ready to protect your reputation?</p>
        <button className="px-8 py-4 bg-[#5A3EB8] text-white font-medium rounded-xl hover:bg-[#462F8F] transition-colors shadow-lg shadow-[#5A3EB8]/25 text-lg">
          Get Started Free
        </button>
      </motion.div>
    </SectionShell>
  );
}
