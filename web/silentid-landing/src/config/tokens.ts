/**
 * Design Tokens for SilentID Landing Page
 * Source: claude.md Section 2 (Branding & Visual Identity)
 * Version: 1.4.0
 *
 * CRITICAL: These tokens MUST match claude.md exactly.
 * When claude.md branding changes, update these tokens accordingly.
 */

export const colors = {
  // Primary Brand Color
  primary: {
    DEFAULT: '#5A3EB8', // Royal Purple
    dark: '#462F8F',
    light: '#E8E2FF', // Soft Lilac (backgrounds)
  },

  // Neutral Colors
  neutral: {
    black: '#0A0A0A',
    white: '#FFFFFF',
    900: '#111111',
    700: '#4C4C4C',
    300: '#DADADA',
  },

  // Status Colors
  status: {
    success: '#1FBF71',
    warning: '#FFC043',
    danger: '#D04C4C',
  },
} as const;

export const typography = {
  fontFamily: {
    primary: "'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif",
  },
  fontWeight: {
    light: 300,
    regular: 400,
    medium: 500,
    semibold: 600,
    bold: 700,
  },
} as const;

export const buttons = {
  primary: {
    background: colors.primary.DEFAULT,
    text: colors.neutral.white,
    radius: '12px',
    height: '52px',
    shadow: '0 2px 4px rgba(0, 0, 0, 0.1)',
  },
  secondary: {
    background: 'transparent',
    border: `1.5px solid ${colors.primary.DEFAULT}`,
    text: colors.primary.DEFAULT,
    radius: '12px',
    height: '52px',
  },
  danger: {
    background: colors.status.danger,
    text: colors.neutral.white,
    radius: '12px',
    height: '52px',
  },
} as const;

export const spacing = {
  xs: '8px',
  sm: '16px',
  md: '24px',
  lg: '48px',
  xl: '64px',
  '2xl': '96px',
  '3xl': '128px',
} as const;

export const layout = {
  padding: {
    horizontal: '20px', // Mobile
    horizontalTablet: '40px',
    horizontalDesktop: '80px',
  },
  maxWidth: '1440px',
  containerPadding: '24px',
} as const;

export const brandPersonality = {
  MUST_FEEL: [
    'Serious',
    'Calm',
    'Professional',
    'High-trust',
    'Evidence-driven',
    'Premium',
    'Minimal',
    'Precise',
    'Bank-grade security',
  ],
  NEVER_FEEL: [
    'Juvenile',
    'Social media style',
    'Cartoonish',
    'Overly marketing',
    'Playful',
    'Loud',
    'Startup cheap',
  ],
  reference: 'Apple × Stripe × Revolut × Bank-level identity',
} as const;
