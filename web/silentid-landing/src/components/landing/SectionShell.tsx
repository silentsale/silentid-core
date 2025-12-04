'use client';

import { motion } from 'framer-motion';
import { ReactNode } from 'react';

interface SectionShellProps {
  children: ReactNode;
  className?: string;
  id?: string;
  background?: 'white' | 'subtle' | 'dark' | 'gradient';
}

export default function SectionShell({
  children,
  className = '',
  id,
  background = 'white'
}: SectionShellProps) {
  const bgColors = {
    white: 'bg-white',
    subtle: 'bg-gradient-to-b from-white via-[#E8E2FF]/10 to-white',
    dark: 'bg-neutral-900',
    gradient: 'bg-gradient-to-br from-[#5A3EB8] via-[#462F8F] to-[#2D1F5C]'
  };

  return (
    <motion.section
      id={id}
      className={`relative py-16 md:py-24 ${bgColors[background]} ${className}`}
      initial={{ opacity: 0, y: 40 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: '-100px' }}
      transition={{ duration: 0.6, ease: [0.16, 1, 0.3, 1] }}
    >
      <div className="container mx-auto px-6 max-w-7xl">
        {children}
      </div>
    </motion.section>
  );
}
