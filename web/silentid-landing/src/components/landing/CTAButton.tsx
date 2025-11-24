'use client';

import { motion } from 'framer-motion';
import Link from 'next/link';

interface CTAButtonProps {
  children: React.ReactNode;
  href?: string;
  variant?: 'primary' | 'secondary' | 'text';
  size?: 'sm' | 'md' | 'lg';
  onClick?: () => void;
  className?: string;
}

export default function CTAButton({
  children,
  href,
  variant = 'primary',
  size = 'md',
  onClick,
  className = ''
}: CTAButtonProps) {
  const baseClasses = 'inline-flex items-center justify-center font-medium rounded-xl transition-all';

  const variantClasses = {
    primary: 'bg-[#5A3EB8] text-white hover:bg-[#462F8F] shadow-lg shadow-[#5A3EB8]/25',
    secondary: 'bg-white text-[#5A3EB8] border-2 border-[#5A3EB8] hover:bg-[#E8E2FF]',
    text: 'text-[#5A3EB8] hover:text-[#462F8F] underline-offset-4 hover:underline'
  };

  const sizeClasses = {
    sm: 'px-4 py-2 text-sm',
    md: 'px-6 py-3 text-base',
    lg: 'px-8 py-4 text-lg'
  };

  const buttonClasses = `${baseClasses} ${variantClasses[variant]} ${sizeClasses[size]} ${className}`;

  const MotionComponent = motion(href ? Link : 'button');

  return (
    <MotionComponent
      href={href || ''}
      onClick={onClick}
      className={buttonClasses}
      whileHover={{ scale: 1.02, y: -2 }}
      whileTap={{ scale: 0.98 }}
      transition={{ type: 'spring', stiffness: 400, damping: 17 }}
    >
      {children}
    </MotionComponent>
  );
}
