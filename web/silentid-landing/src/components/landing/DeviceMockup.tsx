'use client';

import { motion, useMotionValue, useTransform } from 'framer-motion';
import { useEffect, useState } from 'react';
import Image from 'next/image';

interface DeviceMockupProps {
  children?: React.ReactNode;
  className?: string;
  enableParallax?: boolean;
}

export default function DeviceMockup({
  children,
  className = '',
  enableParallax = true
}: DeviceMockupProps) {
  const [mounted, setMounted] = useState(false);
  const mouseX = useMotionValue(0);
  const mouseY = useMotionValue(0);

  const rotateX = useTransform(mouseY, [-300, 300], [10, -10]);
  const rotateY = useTransform(mouseX, [-300, 300], [-10, 10]);

  useEffect(() => {
    setMounted(true);

    if (!enableParallax) return;

    const handleMouseMove = (e: MouseEvent) => {
      const { clientX, clientY } = e;
      const { innerWidth, innerHeight } = window;

      const x = clientX - innerWidth / 2;
      const y = clientY - innerHeight / 2;

      mouseX.set(x);
      mouseY.set(y);
    };

    window.addEventListener('mousemove', handleMouseMove);
    return () => window.removeEventListener('mousemove', handleMouseMove);
  }, [enableParallax, mouseX, mouseY]);

  if (!mounted) {
    return (
      <div className={`relative ${className}`}>
        <div className="relative w-full max-w-[280px] mx-auto aspect-[9/19] bg-neutral-900 rounded-[3rem] shadow-2xl border-8 border-neutral-800">
          {children}
        </div>
      </div>
    );
  }

  return (
    <motion.div
      className={`relative ${className}`}
      style={enableParallax ? {
        rotateX,
        rotateY,
        transformStyle: 'preserve-3d',
        transformPerspective: 1000
      } : {}}
      initial={{ opacity: 0, y: 100 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
    >
      {/* Glow effect */}
      <div className="absolute inset-0 bg-gradient-to-r from-[#5A3EB8] to-[#462F8F] opacity-20 blur-3xl rounded-full" />

      {/* Phone mockup */}
      <div className="relative w-full max-w-[280px] mx-auto aspect-[9/19] bg-neutral-900 rounded-[3rem] shadow-2xl border-8 border-neutral-800">
        {/* Notch */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-32 h-6 bg-neutral-900 rounded-b-2xl z-10" />

        {/* Screen content */}
        <div className="absolute inset-2 bg-white rounded-[2.5rem] overflow-hidden">
          {children || (
            <div className="w-full h-full bg-gradient-to-br from-[#E8E2FF] to-white flex items-center justify-center">
              <div className="text-center">
                <div className="w-20 h-20 rounded-full bg-[#5A3EB8] mx-auto mb-4 flex items-center justify-center">
                  <svg className="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                  </svg>
                </div>
                <div className="text-2xl font-bold text-[#5A3EB8]">847</div>
                <div className="text-xs text-neutral-600 mt-1">High Trust</div>
              </div>
            </div>
          )}
        </div>
      </div>
    </motion.div>
  );
}
