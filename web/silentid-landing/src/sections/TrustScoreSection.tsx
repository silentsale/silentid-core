'use client';

import { motion, useMotionValue, useTransform, animate } from 'framer-motion';
import { useEffect, useState } from 'react';
import SectionShell from '@/components/landing/SectionShell';

const components = [
  {
    name: 'Identity',
    max: 300,
    description: 'Stripe Identity verification, email confirmed, passkey setup',
    color: '#5A3EB8',
    example: 280
  },
  {
    name: 'Profiles',
    max: 400,
    description: 'Verified marketplace and social profiles (Vinted, eBay, Instagram, etc.)',
    color: '#1FBF71',
    example: 320
  },
  {
    name: 'Behaviour',
    max: 300,
    description: 'No safety reports, consistent activity, account longevity',
    color: '#FFC043',
    example: 247
  }
];

function CircularScore({ score }: { score: number }) {
  const [mounted, setMounted] = useState(false);
  const count = useMotionValue(0);
  const rounded = useTransform(count, Math.round);

  useEffect(() => {
    setMounted(true);
    const animation = animate(count, score, {
      duration: 2,
      ease: [0.16, 1, 0.3, 1]
    });

    return animation.stop;
  }, [count, score]);

  if (!mounted) return <div className="text-7xl font-bold text-[#5A3EB8]">{score}</div>;

  const circumference = 2 * Math.PI * 120;
  const offset = circumference - (score / 1000) * circumference;

  return (
    <div className="relative w-80 h-80">
      {/* Background circle */}
      <svg className="absolute inset-0 -rotate-90" width="320" height="320">
        <circle
          cx="160"
          cy="160"
          r="120"
          stroke="#E8E2FF"
          strokeWidth="24"
          fill="none"
        />
        <motion.circle
          cx="160"
          cy="160"
          r="120"
          stroke="url(#scoreGradient)"
          strokeWidth="24"
          fill="none"
          strokeLinecap="round"
          initial={{ strokeDashoffset: circumference }}
          animate={{ strokeDashoffset: offset }}
          transition={{ duration: 2, ease: [0.16, 1, 0.3, 1] }}
          style={{
            strokeDasharray: circumference
          }}
        />
        <defs>
          <linearGradient id="scoreGradient" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stopColor="#5A3EB8" />
            <stop offset="100%" stopColor="#7C3AED" />
          </linearGradient>
        </defs>
      </svg>

      {/* Score text */}
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        <motion.div className="text-7xl font-bold text-[#5A3EB8]">
          {rounded}
        </motion.div>
        <div className="text-xl text-neutral-600 mt-2">High Trust</div>
        <div className="text-sm text-neutral-400">out of 1000</div>
      </div>
    </div>
  );
}

export default function TrustScoreSection() {
  const totalScore = components.reduce((sum, c) => sum + c.example, 0);

  return (
    <SectionShell background="subtle" className="py-24">
      <div className="grid lg:grid-cols-2 gap-16 items-center">
        {/* Left: Animated score */}
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          whileInView={{ opacity: 1, scale: 1 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
          className="flex justify-center"
        >
          <div className="relative">
            {/* Glow effect */}
            <div className="absolute inset-0 bg-gradient-to-r from-[#5A3EB8] to-[#7C3AED] opacity-20 blur-3xl" />

            <CircularScore score={totalScore} />
          </div>
        </motion.div>

        {/* Right: Explanation */}
        <motion.div
          initial={{ opacity: 0, x: 50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8 }}
        >
          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-[#5A3EB8]/10 text-[#5A3EB8] text-sm font-medium mb-6">
            <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
              <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
            </svg>
            TrustScore System
          </div>

          <h2 className="text-4xl md:text-5xl font-bold text-neutral-900 mb-6">
            Your trust,{' '}
            <span className="bg-gradient-to-r from-[#5A3EB8] to-[#7C3AED] bg-clip-text text-transparent">
              quantified
            </span>
          </h2>

          <p className="text-xl text-neutral-600 mb-8 leading-relaxed">
            Your TrustScore (0–1000) is calculated from evidence, not claims.
            Higher score = more trust = better reputation everywhere you trade.
          </p>

          {/* Components breakdown */}
          <div className="space-y-4">
            {components.map((component, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, x: 30 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.1, duration: 0.6 }}
                className="group"
              >
                <div className="flex items-center justify-between mb-2">
                  <div className="flex items-center gap-3">
                    <div
                      className="w-3 h-3 rounded-full"
                      style={{ backgroundColor: component.color }}
                    />
                    <span className="font-semibold text-neutral-900">
                      {component.name}
                    </span>
                  </div>
                  <span className="text-sm font-medium text-neutral-600">
                    {component.example}/{component.max} pts
                  </span>
                </div>

                {/* Progress bar */}
                <div className="relative h-2 bg-neutral-200 rounded-full overflow-hidden">
                  <motion.div
                    className="absolute inset-y-0 left-0 rounded-full"
                    style={{ backgroundColor: component.color }}
                    initial={{ width: 0 }}
                    whileInView={{ width: `${(component.example / component.max) * 100}%` }}
                    viewport={{ once: true }}
                    transition={{ delay: index * 0.1 + 0.3, duration: 1, ease: [0.16, 1, 0.3, 1] }}
                  />
                </div>

                <p className="text-sm text-neutral-500 mt-1 opacity-0 group-hover:opacity-100 transition-opacity">
                  {component.description}
                </p>
              </motion.div>
            ))}
          </div>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.6, duration: 0.6 }}
            className="mt-8 p-4 rounded-xl bg-[#5A3EB8]/5 border border-[#5A3EB8]/20"
          >
            <p className="text-sm text-neutral-700">
              <span className="font-semibold text-[#5A3EB8]">Important:</span> Paid subscriptions do NOT increase your TrustScore.
              Your score is based purely on evidence and behavior.
            </p>
          </motion.div>
        </motion.div>
      </div>
    </SectionShell>
  );
}
