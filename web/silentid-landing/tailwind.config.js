/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        // SilentID Brand Colors (from claude.md Section 2)
        primary: {
          DEFAULT: '#5A3EB8', // Royal Purple
          dark: '#462F8F',
          light: '#E8E2FF', // Soft Lilac
        },
        neutral: {
          black: '#0A0A0A',
          900: '#111111',
          700: '#4C4C4C',
          300: '#DADADA',
        },
        status: {
          success: '#1FBF71',
          warning: '#FFC043',
          danger: '#D04C4C',
        },
      },
      fontFamily: {
        sans: ['Inter', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'system-ui', 'sans-serif'],
      },
      fontWeight: {
        light: '300',
        regular: '400',
        medium: '500',
        semibold: '600',
        bold: '700',
      },
      spacing: {
        xs: '8px',
        sm: '16px',
        md: '24px',
        lg: '48px',
        xl: '64px',
      },
      borderRadius: {
        button: '12px',
      },
      boxShadow: {
        button: '0 2px 4px rgba(0, 0, 0, 0.1)',
        card: '0 4px 6px -1px rgba(0, 0, 0, 0.1)',
      },
    },
  },
  plugins: [],
}
