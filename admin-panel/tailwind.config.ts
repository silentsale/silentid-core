import type { Config } from 'tailwindcss';

const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        // SilentID Brand Colors
        'silentid': {
          purple: '#5A3EB8',
          'purple-dark': '#4A32A0',
          'purple-light': '#7B5CD4',
          'purple-50': '#F3F0FB',
          'purple-100': '#E8E1F7',
        },
        // Admin Panel Semantic Colors
        'admin': {
          bg: '#F8F9FA',
          'bg-dark': '#1A1B1E',
          card: '#FFFFFF',
          'card-dark': '#25262B',
          border: '#E9ECEF',
          'border-dark': '#373A40',
        },
        // Status Colors
        'status': {
          success: '#10B981',
          'success-light': '#D1FAE5',
          warning: '#F59E0B',
          'warning-light': '#FEF3C7',
          danger: '#EF4444',
          'danger-light': '#FEE2E2',
          info: '#3B82F6',
          'info-light': '#DBEAFE',
        },
        // Trust Level Colors
        'trust': {
          exceptional: '#10B981',
          'very-high': '#22C55E',
          high: '#84CC16',
          moderate: '#F59E0B',
          low: '#EF4444',
          'high-risk': '#DC2626',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
      spacing: {
        '18': '4.5rem',
        '88': '22rem',
        '100': '25rem',
      },
      borderRadius: {
        'xl': '12px',
        '2xl': '16px',
        '3xl': '24px',
      },
      boxShadow: {
        'card': '0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)',
        'card-hover': '0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)',
        'modal': '0 25px 50px -12px rgb(0 0 0 / 0.25)',
      },
      animation: {
        'fade-in': 'fadeIn 0.2s ease-out',
        'slide-in': 'slideIn 0.3s ease-out',
        'pulse-slow': 'pulse 3s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideIn: {
          '0%': { opacity: '0', transform: 'translateY(-10px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
      },
    },
  },
  plugins: [],
};

export default config;
