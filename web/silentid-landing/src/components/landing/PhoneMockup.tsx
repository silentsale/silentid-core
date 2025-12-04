'use client';

import { motion } from 'framer-motion';

interface PhoneMockupProps {
  children: React.ReactNode;
  className?: string;
  variant?: 'default' | 'tilted' | 'floating';
}

/**
 * Realistic iPhone-style mockup with customizable content
 * Used to showcase app screens throughout the landing page
 */
export default function PhoneMockup({
  children,
  className = '',
  variant = 'default'
}: PhoneMockupProps) {
  const variants = {
    default: '',
    tilted: 'transform rotate-3 hover:rotate-0 transition-transform duration-500',
    floating: '',
  };

  return (
    <motion.div
      className={`relative ${variants[variant]} ${className}`}
      initial={variant === 'floating' ? { y: 0 } : undefined}
      animate={variant === 'floating' ? { y: [0, -10, 0] } : undefined}
      transition={variant === 'floating' ? { duration: 3, repeat: Infinity, ease: 'easeInOut' } : undefined}
    >
      {/* Phone frame */}
      <div className="relative mx-auto w-[280px] h-[580px] bg-gradient-to-b from-neutral-800 to-neutral-900 rounded-[3rem] p-2 shadow-2xl">
        {/* Inner bezel */}
        <div className="relative w-full h-full bg-neutral-950 rounded-[2.5rem] overflow-hidden">
          {/* Dynamic Island / Notch */}
          <div className="absolute top-3 left-1/2 -translate-x-1/2 w-28 h-7 bg-black rounded-full z-20" />

          {/* Screen content */}
          <div className="w-full h-full overflow-hidden bg-white rounded-[2.5rem]">
            {children}
          </div>

          {/* Screen reflection overlay */}
          <div className="absolute inset-0 bg-gradient-to-br from-white/5 via-transparent to-transparent pointer-events-none rounded-[2.5rem]" />
        </div>

        {/* Side buttons */}
        <div className="absolute -left-1 top-24 w-1 h-8 bg-neutral-700 rounded-l" />
        <div className="absolute -left-1 top-36 w-1 h-12 bg-neutral-700 rounded-l" />
        <div className="absolute -left-1 top-52 w-1 h-12 bg-neutral-700 rounded-l" />
        <div className="absolute -right-1 top-32 w-1 h-16 bg-neutral-700 rounded-r" />
      </div>

      {/* Shadow */}
      <div className="absolute -bottom-4 left-1/2 -translate-x-1/2 w-[200px] h-4 bg-black/20 blur-xl rounded-full" />
    </motion.div>
  );
}

/**
 * Mini phone mockup for smaller displays
 */
export function PhoneMockupMini({
  children,
  className = ''
}: {
  children: React.ReactNode;
  className?: string;
}) {
  return (
    <div className={`relative mx-auto w-[180px] h-[370px] bg-gradient-to-b from-neutral-800 to-neutral-900 rounded-[2rem] p-1.5 shadow-xl ${className}`}>
      <div className="relative w-full h-full bg-neutral-950 rounded-[1.7rem] overflow-hidden">
        <div className="absolute top-2 left-1/2 -translate-x-1/2 w-16 h-5 bg-black rounded-full z-20" />
        <div className="w-full h-full overflow-hidden bg-white rounded-[1.7rem]">
          {children}
        </div>
      </div>
    </div>
  );
}
