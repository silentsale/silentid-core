import { format, formatDistanceToNow, parseISO } from 'date-fns';
import type { TrustLevel } from '@/types';

/**
 * Format a date string to a human-readable format
 */
export function formatDate(date: string | Date, formatStr: string = 'PPP'): string {
  const d = typeof date === 'string' ? parseISO(date) : date;
  return format(d, formatStr);
}

/**
 * Format a date as relative time (e.g., "2 hours ago")
 */
export function formatRelativeTime(date: string | Date): string {
  const d = typeof date === 'string' ? parseISO(date) : date;
  return formatDistanceToNow(d, { addSuffix: true });
}

/**
 * Format a date for display in tables (short format)
 */
export function formatTableDate(date: string | Date): string {
  const d = typeof date === 'string' ? parseISO(date) : date;
  return format(d, 'MMM d, yyyy');
}

/**
 * Format date and time for detailed views
 */
export function formatDateTime(date: string | Date): string {
  const d = typeof date === 'string' ? parseISO(date) : date;
  return format(d, 'MMM d, yyyy HH:mm');
}

/**
 * Format a number with thousands separator
 */
export function formatNumber(num: number): string {
  return new Intl.NumberFormat('en-US').format(num);
}

/**
 * Format a percentage
 */
export function formatPercent(value: number, decimals: number = 1): string {
  return `${value.toFixed(decimals)}%`;
}

/**
 * Format currency
 */
export function formatCurrency(amount: number, currency: string = 'GBP'): string {
  return new Intl.NumberFormat('en-GB', {
    style: 'currency',
    currency,
  }).format(amount);
}

/**
 * Get TrustLevel label from score
 */
export function getTrustLevelFromScore(score: number): TrustLevel {
  if (score >= 850) return 'Exceptional';
  if (score >= 700) return 'VeryHigh';
  if (score >= 550) return 'High';
  if (score >= 400) return 'Moderate';
  if (score >= 250) return 'Low';
  return 'HighRisk';
}

/**
 * Get human-readable trust level label
 */
export function getTrustLevelLabel(level: TrustLevel): string {
  const labels: Record<TrustLevel, string> = {
    Exceptional: 'Exceptional',
    VeryHigh: 'Very High',
    High: 'High',
    Moderate: 'Moderate',
    Low: 'Low',
    HighRisk: 'High Risk',
  };
  return labels[level];
}

/**
 * Get CSS class for trust level badge
 */
export function getTrustLevelClass(level: TrustLevel): string {
  const classes: Record<TrustLevel, string> = {
    Exceptional: 'trust-exceptional',
    VeryHigh: 'trust-very-high',
    High: 'trust-high',
    Moderate: 'trust-moderate',
    Low: 'trust-low',
    HighRisk: 'trust-high-risk',
  };
  return classes[level];
}

/**
 * Truncate a string with ellipsis
 */
export function truncate(str: string, maxLength: number): string {
  if (str.length <= maxLength) return str;
  return `${str.slice(0, maxLength - 3)}...`;
}

/**
 * Format file size
 */
export function formatFileSize(bytes: number): string {
  const units = ['B', 'KB', 'MB', 'GB'];
  let size = bytes;
  let unitIndex = 0;

  while (size >= 1024 && unitIndex < units.length - 1) {
    size /= 1024;
    unitIndex++;
  }

  return `${size.toFixed(1)} ${units[unitIndex]}`;
}
