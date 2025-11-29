import { NextRequest, NextResponse } from 'next/server';

// ============================================
// Configuration
// ============================================

const SESSION_COOKIE_NAME = 'silentid_admin_session';
const LOGIN_URL = '/login';
const DASHBOARD_URL = '/dashboard';

/**
 * Routes that require authentication
 */
const protectedPaths = [
  '/dashboard',
];

/**
 * Routes that should redirect to dashboard if already authenticated
 */
const authPaths = [
  '/login',
];

// ============================================
// Helpers
// ============================================

function isProtectedPath(pathname: string): boolean {
  return protectedPaths.some(path => pathname.startsWith(path));
}

function isAuthPath(pathname: string): boolean {
  return authPaths.some(path => pathname === path || pathname.startsWith(path + '/'));
}

function isStaticAsset(pathname: string): boolean {
  return (
    pathname.startsWith('/_next/') ||
    pathname.startsWith('/static/') ||
    pathname.startsWith('/favicon') ||
    pathname.includes('.')
  );
}

function hasValidSession(request: NextRequest): boolean {
  const sessionCookie = request.cookies.get(SESSION_COOKIE_NAME);

  if (!sessionCookie?.value) {
    return false;
  }

  try {
    // Decode JWT payload to check expiration
    const parts = sessionCookie.value.split('.');
    if (parts.length !== 3) return false;

    const payload = JSON.parse(atob(parts[1]));

    // Check expiration
    if (payload.exp && payload.exp * 1000 < Date.now()) {
      return false;
    }

    return true;
  } catch {
    return false;
  }
}

// ============================================
// Middleware
// ============================================

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  // Skip static assets and API routes
  if (isStaticAsset(pathname)) {
    return NextResponse.next();
  }

  const isAuthenticated = hasValidSession(request);

  // Redirect root to login or dashboard
  if (pathname === '/') {
    const url = request.nextUrl.clone();
    url.pathname = isAuthenticated ? DASHBOARD_URL : LOGIN_URL;
    return NextResponse.redirect(url);
  }

  // Protected routes - require authentication
  if (isProtectedPath(pathname)) {
    if (!isAuthenticated) {
      const url = request.nextUrl.clone();
      url.pathname = LOGIN_URL;
      url.searchParams.set('redirect', pathname);
      return NextResponse.redirect(url);
    }
  }

  // Auth routes - redirect to dashboard if already authenticated
  if (isAuthPath(pathname)) {
    if (isAuthenticated) {
      const redirectTo = request.nextUrl.searchParams.get('redirect');
      const url = request.nextUrl.clone();
      url.pathname = redirectTo || DASHBOARD_URL;
      url.searchParams.delete('redirect');
      return NextResponse.redirect(url);
    }
  }

  return NextResponse.next();
}

// ============================================
// Matcher Configuration
// ============================================

export const config = {
  matcher: [
    /*
     * Match all request paths except:
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * - public files (public folder)
     */
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)',
  ],
};
