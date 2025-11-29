import { NextRequest, NextResponse } from 'next/server';

// ============================================
// Route Configuration
// ============================================

/**
 * Routes that require authentication
 */
export const protectedRoutes = [
  '/dashboard',
  '/dashboard/users',
  '/dashboard/evidence',
  '/dashboard/platforms',
  '/dashboard/reports',
  '/dashboard/analytics',
  '/dashboard/settings',
];

/**
 * Routes that should redirect to dashboard if already authenticated
 */
export const authRoutes = [
  '/login',
  '/',
];

/**
 * API routes that don't require authentication
 */
export const publicApiRoutes = [
  '/admin/auth/check',
  '/admin/auth/passkey/challenge',
  '/admin/auth/passkey/verify',
  '/admin/auth/otp/request',
  '/admin/auth/otp/verify',
];

// ============================================
// Session Cookie Config
// ============================================

export const SESSION_COOKIE_NAME = 'silentid_admin_session';

// ============================================
// Route Matching Helpers
// ============================================

/**
 * Check if a path matches any pattern in the list
 */
function matchesRoute(path: string, routes: string[]): boolean {
  return routes.some(route => {
    // Exact match
    if (path === route) return true;

    // Prefix match for nested routes
    if (path.startsWith(route + '/')) return true;

    return false;
  });
}

/**
 * Check if request is for an API route
 */
function isApiRoute(path: string): boolean {
  return path.startsWith('/api/') || path.startsWith('/admin/');
}

/**
 * Check if request is for a static asset
 */
function isStaticAsset(path: string): boolean {
  return (
    path.startsWith('/_next/') ||
    path.startsWith('/static/') ||
    path.includes('.') // Has file extension
  );
}

// ============================================
// Session Verification
// ============================================

interface SessionPayload {
  adminId: string;
  email: string;
  role: string;
  exp: number;
}

/**
 * Verify session cookie and extract payload
 * Note: Full JWT verification should be done server-side
 * This is a lightweight check for middleware routing
 */
function getSessionFromCookie(request: NextRequest): SessionPayload | null {
  const sessionCookie = request.cookies.get(SESSION_COOKIE_NAME);

  if (!sessionCookie?.value) {
    return null;
  }

  try {
    // Decode JWT payload (without verification - server will verify)
    const parts = sessionCookie.value.split('.');
    if (parts.length !== 3) return null;

    const payload = JSON.parse(atob(parts[1]));

    // Check if expired
    if (payload.exp && payload.exp * 1000 < Date.now()) {
      return null;
    }

    return payload as SessionPayload;
  } catch {
    return null;
  }
}

// ============================================
// Middleware Handler
// ============================================

export interface AuthMiddlewareConfig {
  loginUrl?: string;
  dashboardUrl?: string;
}

const defaultConfig: AuthMiddlewareConfig = {
  loginUrl: '/login',
  dashboardUrl: '/dashboard',
};

/**
 * Create auth middleware handler
 */
export function createAuthMiddleware(config: AuthMiddlewareConfig = {}) {
  const { loginUrl, dashboardUrl } = { ...defaultConfig, ...config };

  return function authMiddleware(request: NextRequest): NextResponse | null {
    const { pathname } = request.nextUrl;

    // Skip static assets
    if (isStaticAsset(pathname)) {
      return null;
    }

    // Skip public API routes
    if (isApiRoute(pathname)) {
      return null;
    }

    // Get session from cookie
    const session = getSessionFromCookie(request);
    const isAuthenticated = !!session;

    // Protected routes - redirect to login if not authenticated
    if (matchesRoute(pathname, protectedRoutes)) {
      if (!isAuthenticated) {
        const url = request.nextUrl.clone();
        url.pathname = loginUrl!;
        url.searchParams.set('redirect', pathname);
        return NextResponse.redirect(url);
      }
    }

    // Auth routes - redirect to dashboard if already authenticated
    if (matchesRoute(pathname, authRoutes)) {
      if (isAuthenticated) {
        const redirectTo = request.nextUrl.searchParams.get('redirect');
        const url = request.nextUrl.clone();
        url.pathname = redirectTo || dashboardUrl!;
        url.searchParams.delete('redirect');
        return NextResponse.redirect(url);
      }
    }

    // Allow request to proceed
    return null;
  };
}

// ============================================
// Default Middleware Instance
// ============================================

export const authMiddleware = createAuthMiddleware();

// ============================================
// Middleware Response Helpers
// ============================================

/**
 * Create redirect response
 */
export function redirectTo(request: NextRequest, path: string): NextResponse {
  const url = request.nextUrl.clone();
  url.pathname = path;
  return NextResponse.redirect(url);
}

/**
 * Create unauthorized response for API routes
 */
export function unauthorized(): NextResponse {
  return NextResponse.json(
    {
      success: false,
      error: {
        code: 'UNAUTHORIZED',
        message: 'Authentication required',
      },
    },
    { status: 401 }
  );
}

/**
 * Create forbidden response for API routes
 */
export function forbidden(message = 'Access denied'): NextResponse {
  return NextResponse.json(
    {
      success: false,
      error: {
        code: 'FORBIDDEN',
        message,
      },
    },
    { status: 403 }
  );
}
