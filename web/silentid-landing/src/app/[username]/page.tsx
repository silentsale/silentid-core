/**
 * Public Profile Page
 * Route: /[username]
 * Displays a user's public SilentID Trust Passport
 *
 * Source: CLAUDE_FULL.md Section 9 (API Endpoints), Section 3 (Public Profile System)
 */

import Link from 'next/link';
import { notFound } from 'next/navigation';
import type { Metadata } from 'next';

// Types for public profile data
interface PublicProfile {
  username: string;
  displayName: string;
  trustScore: number;
  trustScoreLabel: string;
  identityVerified: boolean;
  accountAge: string;
  verifiedPlatforms: string[];
  verifiedTransactionCount: number;
  mutualVerificationCount: number;
  badges: string[];
  riskWarning: string | null;
  createdAt: string;
}

interface PageProps {
  params: Promise<{ username: string }>;
}

// Reserved routes that should not be treated as usernames
const RESERVED_ROUTES = [
  'about',
  'terms',
  'privacy',
  'cookies',
  'help',
  'api',
  'admin',
  'login',
  'signup',
  'contact',
  'pricing',
  'features',
  'blog',
];

// Fetch public profile from API
async function getPublicProfile(username: string): Promise<PublicProfile | null> {
  // Don't fetch for reserved routes
  if (RESERVED_ROUTES.includes(username.toLowerCase())) {
    return null;
  }

  const apiUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:5249';

  try {
    const response = await fetch(`${apiUrl}/v1/public/profile/${username}`, {
      next: { revalidate: 60 }, // Cache for 60 seconds
    });

    if (!response.ok) {
      return null;
    }

    return response.json();
  } catch {
    return null;
  }
}

// Generate dynamic metadata for SEO and social sharing
export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { username } = await params;
  const profile = await getPublicProfile(username);

  if (!profile) {
    return {
      title: 'Profile Not Found | SilentID',
    };
  }

  const cleanUsername = profile.username.replace('@', '');
  const description = `${profile.displayName}'s SilentID Trust Passport - TrustScore: ${profile.trustScore}/1000 (${profile.trustScoreLabel}). ${profile.identityVerified ? 'Identity Verified.' : ''} ${profile.verifiedPlatforms.length > 0 ? `Active on: ${profile.verifiedPlatforms.join(', ')}.` : ''}`;

  return {
    title: `${profile.displayName} (@${cleanUsername}) | SilentID`,
    description,
    openGraph: {
      title: `${profile.displayName} - SilentID Trust Passport`,
      description,
      url: `https://silentid.co.uk/${cleanUsername}`,
      siteName: 'SilentID',
      type: 'profile',
      images: [
        {
          url: '/images/og-profile.png',
          width: 1200,
          height: 630,
          alt: `${profile.displayName}'s SilentID Profile`,
        },
      ],
    },
    twitter: {
      card: 'summary_large_image',
      title: `${profile.displayName} - SilentID Trust Passport`,
      description,
      images: ['/images/og-profile.png'],
    },
  };
}

// TrustScore color based on score
function getTrustScoreColor(score: number): string {
  if (score >= 850) return 'from-emerald-500 to-emerald-600';
  if (score >= 700) return 'from-green-500 to-green-600';
  if (score >= 550) return 'from-blue-500 to-blue-600';
  if (score >= 400) return 'from-yellow-500 to-yellow-600';
  if (score >= 250) return 'from-orange-500 to-orange-600';
  return 'from-red-500 to-red-600';
}

// Platform icon helper
function getPlatformIcon(platform: string): string {
  const icons: Record<string, string> = {
    Vinted: '/icons/vinted.svg',
    eBay: '/icons/ebay.svg',
    Depop: '/icons/depop.svg',
    Instagram: '/icons/instagram.svg',
    TikTok: '/icons/tiktok.svg',
    LinkedIn: '/icons/linkedin.svg',
    Discord: '/icons/discord.svg',
  };
  return icons[platform] || '/icons/link.svg';
}

export default async function PublicProfilePage({ params }: PageProps) {
  const { username } = await params;

  // Don't render for reserved routes - let Next.js handle them
  if (RESERVED_ROUTES.includes(username.toLowerCase())) {
    notFound();
  }

  const profile = await getPublicProfile(username);

  if (!profile) {
    return (
      <div className="min-h-screen bg-neutral-50 flex items-center justify-center p-6">
        <div className="bg-white rounded-2xl p-8 max-w-md w-full text-center border border-neutral-200 shadow-sm">
          <div className="w-16 h-16 bg-neutral-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <svg className="w-8 h-8 text-neutral-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
            </svg>
          </div>
          <h1 className="text-2xl font-bold text-neutral-900 mb-2">Profile Not Found</h1>
          <p className="text-neutral-600 mb-6">
            This SilentID profile doesn&apos;t exist or may have been deleted.
          </p>
          <Link
            href="/"
            className="inline-flex items-center gap-2 px-6 py-3 bg-[#5A3EB8] text-white rounded-xl font-medium hover:bg-[#462F8F] transition-colors"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            Back to Home
          </Link>
        </div>
      </div>
    );
  }

  const cleanUsername = profile.username.replace('@', '');
  const trustScoreGradient = getTrustScoreColor(profile.trustScore);

  return (
    <div className="min-h-screen bg-neutral-50">
      {/* Profile Content */}
      <main className="container mx-auto px-4 py-8 max-w-2xl">
        {/* Safety Warning Banner */}
        {profile.riskWarning && (
          <div className="mb-6 p-4 bg-amber-50 border-2 border-amber-400 rounded-xl">
            <div className="flex items-start gap-3">
              <svg className="w-6 h-6 text-amber-500 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
              </svg>
              <div>
                <p className="font-semibold text-amber-800">Safety Concern Reported</p>
                <p className="text-sm text-amber-700 mt-1">{profile.riskWarning}</p>
              </div>
            </div>
          </div>
        )}

        {/* Profile Card */}
        <div className="bg-white rounded-2xl border border-neutral-200 overflow-hidden shadow-sm">
          {/* Header with gradient */}
          <div className={`h-24 bg-gradient-to-r ${trustScoreGradient}`} />

          {/* Profile Info */}
          <div className="px-6 pb-6">
            {/* Avatar */}
            <div className="relative -mt-12 mb-4">
              <div className="w-24 h-24 bg-white rounded-full border-4 border-white shadow-md flex items-center justify-center">
                <span className="text-3xl font-bold text-[#5A3EB8]">
                  {profile.displayName.charAt(0).toUpperCase()}
                </span>
              </div>
              {profile.identityVerified && (
                <div className="absolute bottom-0 right-0 w-8 h-8 bg-[#5A3EB8] rounded-full flex items-center justify-center border-2 border-white">
                  <svg className="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                  </svg>
                </div>
              )}
            </div>

            {/* Name & Username */}
            <div className="mb-6">
              <h1 className="text-2xl font-bold text-neutral-900">{profile.displayName}</h1>
              <p className="text-neutral-500">@{cleanUsername}</p>
            </div>

            {/* TrustScore */}
            <div className="bg-neutral-50 rounded-xl p-6 mb-6">
              <div className="flex items-center justify-between mb-3">
                <span className="text-sm font-medium text-neutral-600">TrustScore</span>
                <span className="text-sm font-medium text-neutral-600">{profile.trustScoreLabel}</span>
              </div>
              <div className="flex items-end gap-2 mb-3">
                <span className="text-5xl font-bold text-neutral-900">{profile.trustScore}</span>
                <span className="text-lg text-neutral-500 mb-1">/ 1000</span>
              </div>
              {/* Progress Bar */}
              <div className="h-3 bg-neutral-200 rounded-full overflow-hidden">
                <div
                  className={`h-full bg-gradient-to-r ${trustScoreGradient} rounded-full transition-all duration-500`}
                  style={{ width: `${(profile.trustScore / 1000) * 100}%` }}
                />
              </div>
            </div>

            {/* Badges */}
            {profile.badges.length > 0 && (
              <div className="mb-6">
                <h2 className="text-sm font-semibold text-neutral-700 mb-3">Badges</h2>
                <div className="flex flex-wrap gap-2">
                  {profile.badges.map((badge, index) => (
                    <span
                      key={index}
                      className="inline-flex items-center gap-1.5 px-3 py-1.5 bg-[#5A3EB8]/10 text-[#5A3EB8] rounded-full text-sm font-medium"
                    >
                      <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                        <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                      </svg>
                      {badge}
                    </span>
                  ))}
                </div>
              </div>
            )}

            {/* Stats Grid */}
            <div className="grid grid-cols-2 gap-4 mb-6">
              <div className="bg-neutral-50 rounded-xl p-4">
                <p className="text-2xl font-bold text-neutral-900">{profile.verifiedTransactionCount}</p>
                <p className="text-sm text-neutral-600">Verified Transactions</p>
              </div>
              <div className="bg-neutral-50 rounded-xl p-4">
                <p className="text-2xl font-bold text-neutral-900">{profile.accountAge}</p>
                <p className="text-sm text-neutral-600">Account Age</p>
              </div>
            </div>

            {/* Connected Platforms */}
            {profile.verifiedPlatforms.length > 0 && (
              <div className="mb-6">
                <h2 className="text-sm font-semibold text-neutral-700 mb-3">Verified On</h2>
                <div className="flex flex-wrap gap-2">
                  {profile.verifiedPlatforms.map((platform, index) => (
                    <span
                      key={index}
                      className="inline-flex items-center gap-2 px-3 py-1.5 bg-neutral-100 text-neutral-700 rounded-lg text-sm"
                    >
                      {platform}
                    </span>
                  ))}
                </div>
              </div>
            )}

            {/* Privacy Notice */}
            <div className="border-t border-neutral-200 pt-6 mt-6">
              <p className="text-xs text-neutral-500 text-center">
                This public profile shows display name, username, TrustScore, and general activity metrics.
                Full legal name, email, phone, address, and ID documents are never shown.
              </p>
            </div>
          </div>
        </div>

        {/* SilentID Branding */}
        <div className="mt-8 text-center">
          <Link href="/" className="inline-flex items-center gap-2 text-neutral-500 hover:text-[#5A3EB8] transition-colors">
            <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
              <path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5"/>
            </svg>
            <span className="text-sm font-medium">Verified by SilentID</span>
          </Link>
          <p className="text-xs text-neutral-400 mt-2">
            <Link href="/" className="hover:text-[#5A3EB8] transition-colors">
              Get your own SilentID Trust Passport
            </Link>
          </p>
        </div>
      </main>
    </div>
  );
}
