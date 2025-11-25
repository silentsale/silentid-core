/**
 * Screenshot Service - Automatic Screenshot Integration
 *
 * This service fetches app screenshot metadata from the backend API.
 * When the Flutter app is deployed, screenshots are automatically
 * uploaded to Azure Blob Storage and served via the API.
 */

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:5249';

export interface AppScreenshot {
  id: string;
  screenName: string;
  title: string;
  description: string;
  imageUrl: string;
  platform: 'ios' | 'android';
  deviceType: string; // e.g., "iPhone 14 Pro", "Samsung Galaxy S23"
  resolution: {
    width: number;
    height: number;
  };
  order: number;
  category: 'hero' | 'feature' | 'preview';
  isActive: boolean;
  uploadedAt: string;
}

export interface ScreenshotsResponse {
  screenshots: AppScreenshot[];
  lastUpdated: string;
}

/**
 * Fetch all active app screenshots from the backend
 * Falls back to placeholders if API is unavailable
 */
export async function fetchAppScreenshots(): Promise<ScreenshotsResponse> {
  try {
    const response = await fetch(`${API_URL}/v1/public/app-screenshots`, {
      next: { revalidate: 3600 }, // Cache for 1 hour
    });

    if (!response.ok) {
      console.warn('Screenshots API not available, using placeholders');
      return getFallbackScreenshots();
    }

    return await response.json();
  } catch (error) {
    console.warn('Failed to fetch screenshots:', error);
    return getFallbackScreenshots();
  }
}

/**
 * Fetch screenshots for a specific category
 */
export async function fetchScreenshotsByCategory(
  category: 'hero' | 'feature' | 'preview'
): Promise<AppScreenshot[]> {
  const data = await fetchAppScreenshots();
  return data.screenshots.filter((s) => s.category === category && s.isActive);
}

/**
 * Fallback screenshots when API is unavailable
 * Returns placeholder data matching the expected structure
 */
function getFallbackScreenshots(): ScreenshotsResponse {
  return {
    screenshots: [
      {
        id: 'placeholder-hero',
        screenName: 'trust-passport',
        title: 'Trust Passport',
        description: 'Your complete trust profile at a glance',
        imageUrl: '/images/mockups/placeholder-home.png',
        platform: 'ios',
        deviceType: 'iPhone 14 Pro',
        resolution: { width: 1170, height: 2532 },
        order: 1,
        category: 'hero',
        isActive: true,
        uploadedAt: new Date().toISOString(),
      },
      {
        id: 'placeholder-login',
        screenName: 'passwordless-login',
        title: 'Passwordless Login',
        description: 'Secure authentication without passwords',
        imageUrl: '/images/mockups/placeholder-login.png',
        platform: 'ios',
        deviceType: 'iPhone 14 Pro',
        resolution: { width: 1170, height: 2532 },
        order: 2,
        category: 'preview',
        isActive: true,
        uploadedAt: new Date().toISOString(),
      },
      {
        id: 'placeholder-security',
        screenName: 'security-center',
        title: 'Security Center',
        description: 'Real-time protection and monitoring',
        imageUrl: '/images/mockups/placeholder-security.png',
        platform: 'ios',
        deviceType: 'iPhone 14 Pro',
        resolution: { width: 1170, height: 2532 },
        order: 3,
        category: 'preview',
        isActive: true,
        uploadedAt: new Date().toISOString(),
      },
    ],
    lastUpdated: new Date().toISOString(),
  };
}

/**
 * Check if real screenshots are available (not placeholders)
 */
export function hasRealScreenshots(screenshots: AppScreenshot[]): boolean {
  return screenshots.some((s) => !s.imageUrl.includes('placeholder'));
}
