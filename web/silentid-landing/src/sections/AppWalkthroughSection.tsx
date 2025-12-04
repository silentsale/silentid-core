'use client';

import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import SectionShell from '@/components/landing/SectionShell';
import PhoneMockup from '@/components/landing/PhoneMockup';
import {
  HorrorStatsScreen,
  TrustScoreScreen,
  ConnectProfilesScreen,
  VerifiedBadgeScreen,
  TrustPassportScreen,
} from '@/components/landing/AppScreens';
import { appWalkthrough } from '@/config/content';

const screens = [
  { component: <HorrorStatsScreen />, icon: '⚠️' },
  { component: <TrustScoreScreen />, icon: '📊' },
  { component: <ConnectProfilesScreen />, icon: '🔗' },
  { component: <VerifiedBadgeScreen />, icon: '✅' },
  { component: <TrustPassportScreen />, icon: '🛂' },
];

export default function AppWalkthroughSection() {
  const [activeIndex, setActiveIndex] = useState(0);
  const activeScreen = appWalkthrough.screens[activeIndex];

  return (
    <SectionShell background="gradient" className="py-24 overflow-hidden">
      <div className="text-center mb-12">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-white/20 text-white text-sm font-medium mb-6"
        >
          <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
            <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clipRule="evenodd" />
          </svg>
          Interactive Demo
        </motion.div>

        <motion.h2
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.1, duration: 0.6 }}
          className="text-4xl md:text-5xl font-bold text-white mb-6"
        >
          {appWalkthrough.title}
        </motion.h2>

        <motion.p
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.2, duration: 0.6 }}
          className="text-xl text-white/80 max-w-3xl mx-auto"
        >
          {appWalkthrough.subtitle}
        </motion.p>
      </div>

      <div className="grid lg:grid-cols-2 gap-12 items-center max-w-6xl mx-auto">
        {/* Phone mockup */}
        <motion.div
          initial={{ opacity: 0, x: -50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.3, duration: 0.6 }}
          className="relative order-2 lg:order-1"
        >
          <div className="relative">
            <PhoneMockup variant="floating">
              <AnimatePresence mode="wait">
                <motion.div
                  key={activeIndex}
                  initial={{ opacity: 0, scale: 0.95 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0, scale: 1.05 }}
                  transition={{ duration: 0.3 }}
                  className="w-full h-full"
                >
                  {screens[activeIndex].component}
                </motion.div>
              </AnimatePresence>
            </PhoneMockup>

            {/* Glow effect */}
            <div className="absolute inset-0 -z-10 blur-3xl opacity-30 bg-white rounded-full scale-75" />
          </div>
        </motion.div>

        {/* Screen descriptions */}
        <motion.div
          initial={{ opacity: 0, x: 50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.4, duration: 0.6 }}
          className="order-1 lg:order-2 space-y-4"
        >
          {appWalkthrough.screens.map((screen, index) => (
            <motion.button
              key={screen.id}
              onClick={() => setActiveIndex(index)}
              className={`w-full text-left p-5 rounded-2xl transition-all duration-300 ${
                activeIndex === index
                  ? 'bg-white shadow-xl'
                  : 'bg-white/10 hover:bg-white/20'
              }`}
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
            >
              <div className="flex items-start gap-4">
                <div className={`text-2xl ${activeIndex === index ? '' : 'opacity-60'}`}>
                  {screens[index].icon}
                </div>
                <div className="flex-1">
                  <h3 className={`text-lg font-bold mb-1 ${
                    activeIndex === index ? 'text-neutral-900' : 'text-white'
                  }`}>
                    {screen.title}
                  </h3>
                  <p className={`text-sm leading-relaxed ${
                    activeIndex === index ? 'text-neutral-600' : 'text-white/70'
                  }`}>
                    {screen.description}
                  </p>
                  {activeIndex === index && (
                    <motion.div
                      initial={{ opacity: 0, y: 10 }}
                      animate={{ opacity: 1, y: 0 }}
                      className="mt-3 p-3 bg-[#5A3EB8]/10 rounded-xl border border-[#5A3EB8]/20"
                    >
                      <p className="text-sm text-[#5A3EB8] font-medium">
                        💡 {screen.highlight}
                      </p>
                    </motion.div>
                  )}
                </div>
                {activeIndex === index && (
                  <motion.div
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    className="w-8 h-8 rounded-full bg-[#5A3EB8] flex items-center justify-center"
                  >
                    <svg className="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                  </motion.div>
                )}
              </div>
            </motion.button>
          ))}
        </motion.div>
      </div>

      {/* Screen navigation dots */}
      <div className="flex justify-center gap-2 mt-12">
        {appWalkthrough.screens.map((_, index) => (
          <button
            key={index}
            onClick={() => setActiveIndex(index)}
            className={`w-3 h-3 rounded-full transition-all duration-300 ${
              activeIndex === index
                ? 'bg-white w-8'
                : 'bg-white/30 hover:bg-white/50'
            }`}
            aria-label={`Go to screen ${index + 1}`}
          />
        ))}
      </div>

      {/* CTA */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ delay: 0.6, duration: 0.6 }}
        className="mt-16 text-center"
      >
        <button className="px-8 py-4 bg-white text-[#5A3EB8] font-medium rounded-xl hover:bg-neutral-100 transition-colors shadow-lg text-lg">
          Download the App
        </button>
        <p className="text-white/60 text-sm mt-4">
          Available on iOS and Android
        </p>
      </motion.div>
    </SectionShell>
  );
}
