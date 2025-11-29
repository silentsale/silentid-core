import type { AdminUser, ApiResponse } from '@/types';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'https://localhost:7001';

// ============================================
// Types
// ============================================

interface CheckAdminResponse {
  hasPasskey: boolean;
  email: string;
}

interface PasskeyChallengeResponse {
  challenge: string;
  rpId: string;
  allowCredentials: Array<{
    id: string;
    type: 'public-key';
    transports?: string[];
  }>;
}

interface PasskeyVerifyRequest {
  email: string;
  credentialId: string;
  clientDataJSON: string;
  authenticatorData: string;
  signature: string;
  userHandle?: string;
}

interface AuthResponse {
  user: AdminUser;
  expiresAt: string;
}

interface SessionResponse {
  user: AdminUser;
  expiresAt: string;
}

// ============================================
// API Client for Auth
// ============================================

async function fetchWithCredentials<T>(
  endpoint: string,
  options: RequestInit = {}
): Promise<ApiResponse<T>> {
  try {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      ...options,
      credentials: 'include', // Include httpOnly cookies
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
    });

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      return {
        success: false,
        error: {
          code: `HTTP_${response.status}`,
          message: errorData.message || response.statusText,
          details: errorData.details,
        },
      };
    }

    // Handle 204 No Content
    if (response.status === 204) {
      return { success: true, data: undefined as T };
    }

    const data = await response.json();
    return { success: true, data };
  } catch (error) {
    return {
      success: false,
      error: {
        code: 'NETWORK_ERROR',
        message: error instanceof Error ? error.message : 'An unexpected error occurred',
      },
    };
  }
}

// ============================================
// Auth API Methods
// ============================================

export const authApi = {
  /**
   * Check if an email belongs to a valid admin and if they have a passkey
   */
  checkAdmin: (email: string): Promise<ApiResponse<CheckAdminResponse>> => {
    return fetchWithCredentials<CheckAdminResponse>('/admin/auth/check', {
      method: 'POST',
      body: JSON.stringify({ email }),
    });
  },

  /**
   * Get passkey challenge for authentication
   */
  getPasskeyChallenge: (email: string): Promise<ApiResponse<PasskeyChallengeResponse>> => {
    return fetchWithCredentials<PasskeyChallengeResponse>('/admin/auth/passkey/challenge', {
      method: 'POST',
      body: JSON.stringify({ email }),
    });
  },

  /**
   * Verify passkey response
   */
  verifyPasskey: (request: PasskeyVerifyRequest): Promise<ApiResponse<AuthResponse>> => {
    return fetchWithCredentials<AuthResponse>('/admin/auth/passkey/verify', {
      method: 'POST',
      body: JSON.stringify(request),
    });
  },

  /**
   * Request OTP to be sent to email
   */
  requestOtp: (email: string): Promise<ApiResponse<void>> => {
    return fetchWithCredentials<void>('/admin/auth/otp/request', {
      method: 'POST',
      body: JSON.stringify({ email }),
    });
  },

  /**
   * Verify OTP and authenticate
   */
  verifyOtp: (email: string, otp: string): Promise<ApiResponse<AuthResponse>> => {
    return fetchWithCredentials<AuthResponse>('/admin/auth/otp/verify', {
      method: 'POST',
      body: JSON.stringify({ email, otp }),
    });
  },

  /**
   * Get current session (check if already authenticated)
   */
  getSession: (): Promise<ApiResponse<SessionResponse>> => {
    return fetchWithCredentials<SessionResponse>('/admin/auth/session', {
      method: 'GET',
    });
  },

  /**
   * Refresh session token
   */
  refreshSession: (): Promise<ApiResponse<SessionResponse>> => {
    return fetchWithCredentials<SessionResponse>('/admin/auth/session/refresh', {
      method: 'POST',
    });
  },

  /**
   * Logout and invalidate session
   */
  logout: (): Promise<ApiResponse<void>> => {
    return fetchWithCredentials<void>('/admin/auth/logout', {
      method: 'POST',
    });
  },
};

// ============================================
// Session Cookie Helpers (for middleware use)
// ============================================

export const SESSION_COOKIE_NAME = 'silentid_admin_session';

/**
 * Check if session cookie exists (client-side check)
 */
export function hasSessionCookie(): boolean {
  if (typeof document === 'undefined') return false;

  // Note: httpOnly cookies are not accessible from JS
  // This is a fallback check for non-httpOnly session indicator
  return document.cookie.includes(SESSION_COOKIE_NAME);
}
