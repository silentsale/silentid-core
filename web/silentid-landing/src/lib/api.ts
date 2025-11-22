/**
 * API Service - Connects landing page to SilentID backend
 * Fetches live statistics and updates content dynamically
 */

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:5000/api';

export interface LandingPageStats {
  totalUsers: number;
  verifiedUsers: number;
  totalTransactions: number;
  averageTrustScore: number;
  platformsSupported: number;
}

export interface TrustScoreExample {
  displayName: string;
  username: string;
  trustScore: number;
  trustLevel: string;
  badgeCount: number;
}

/**
 * Fetch landing page statistics from backend
 */
export async function fetchLandingStats(): Promise<LandingPageStats> {
  try {
    const response = await fetch(`${API_BASE_URL}/v1/public/landing-stats`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
      next: { revalidate: 300 }, // Revalidate every 5 minutes
    });

    if (!response.ok) {
      throw new Error(`Failed to fetch stats: ${response.status}`);
    }

    return await response.json();
  } catch (error) {
    console.error('Error fetching landing stats:', error);

    // Return fallback data if API unavailable
    return {
      totalUsers: 1247,
      verifiedUsers: 982,
      totalTransactions: 5680,
      averageTrustScore: 754,
      platformsSupported: 12,
    };
  }
}

/**
 * Fetch example TrustScore profiles for showcase
 */
export async function fetchTrustScoreExamples(): Promise<TrustScoreExample[]> {
  try {
    const response = await fetch(`${API_BASE_URL}/v1/public/trust-examples`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
      next: { revalidate: 3600 }, // Revalidate every hour
    });

    if (!response.ok) {
      throw new Error(`Failed to fetch examples: ${response.status}`);
    }

    return await response.json();
  } catch (error) {
    console.error('Error fetching trust examples:', error);

    // Return fallback examples if API unavailable
    return [
      {
        displayName: 'Sarah M.',
        username: '@sarahtrusted',
        trustScore: 847,
        trustLevel: 'Very High Trust',
        badgeCount: 4,
      },
      {
        displayName: 'James K.',
        username: '@jamesseller',
        trustScore: 756,
        trustLevel: 'High Trust',
        badgeCount: 3,
      },
      {
        displayName: 'Emma L.',
        username: '@emmaverified',
        trustScore: 692,
        trustLevel: 'High Trust',
        badgeCount: 2,
      },
    ];
  }
}

/**
 * Check API health status
 */
export async function checkApiHealth(): Promise<boolean> {
  try {
    const response = await fetch(`${API_BASE_URL}/health`, {
      method: 'GET',
      cache: 'no-store',
    });

    return response.ok;
  } catch (error) {
    console.error('API health check failed:', error);
    return false;
  }
}
