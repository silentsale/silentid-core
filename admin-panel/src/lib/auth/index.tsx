'use client';

import {
  createContext,
  useContext,
  useCallback,
  useEffect,
  useState,
  useMemo,
  ReactNode,
} from 'react';
import { useRouter } from 'next/navigation';
import type { AdminUser, AdminRole, AdminPermission, ApiResponse } from '@/types';
import { authApi } from '@/lib/api/auth';

// ============================================
// Types
// ============================================

interface AuthState {
  user: AdminUser | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  error: string | null;
}

interface LoginMethods {
  checkAdmin: (email: string) => Promise<ApiResponse<{ hasPasskey: boolean }>>;
}

interface AuthContextValue extends AuthState {
  login: LoginMethods;
  initiatePasskeyAuth: (email: string) => Promise<ApiResponse<void>>;
  verifyOtp: (email: string, otp: string) => Promise<ApiResponse<void>>;
  requestOtp: (email: string) => Promise<ApiResponse<void>>;
  logout: () => Promise<void>;
  hasPermission: (permission: AdminPermission) => boolean;
  hasRole: (role: AdminRole | AdminRole[]) => boolean;
  refreshSession: () => Promise<void>;
}

// ============================================
// Context
// ============================================

const AuthContext = createContext<AuthContextValue | null>(null);

// ============================================
// Provider
// ============================================

interface AuthProviderProps {
  children: ReactNode;
}

export function AuthProvider({ children }: AuthProviderProps) {
  const router = useRouter();

  const [state, setState] = useState<AuthState>({
    user: null,
    isAuthenticated: false,
    isLoading: true,
    error: null,
  });

  // Check existing session on mount
  useEffect(() => {
    const initAuth = async () => {
      try {
        const result = await authApi.getSession();

        if (result.success && result.data) {
          setState({
            user: result.data.user,
            isAuthenticated: true,
            isLoading: false,
            error: null,
          });
        } else {
          setState({
            user: null,
            isAuthenticated: false,
            isLoading: false,
            error: null,
          });
        }
      } catch (_err) {
        setState({
          user: null,
          isAuthenticated: false,
          isLoading: false,
          error: null,
        });
      }
    };

    initAuth();
  }, []);

  // Check if admin exists and has passkey
  const checkAdmin = useCallback(async (email: string) => {
    return authApi.checkAdmin(email);
  }, []);

  // Login methods object
  const login = useMemo<LoginMethods>(() => ({
    checkAdmin,
  }), [checkAdmin]);

  // Initiate passkey authentication
  const initiatePasskeyAuth = useCallback(async (email: string): Promise<ApiResponse<void>> => {
    setState(prev => ({ ...prev, error: null }));

    try {
      // Step 1: Get challenge from server
      const challengeResult = await authApi.getPasskeyChallenge(email);

      if (!challengeResult.success || !challengeResult.data) {
        return {
          success: false,
          error: challengeResult.error || { code: 'PASSKEY_ERROR', message: 'Failed to get passkey challenge' },
        };
      }

      // Step 2: Use WebAuthn API to authenticate
      const credential = await navigator.credentials.get({
        publicKey: {
          challenge: base64ToArrayBuffer(challengeResult.data.challenge),
          rpId: challengeResult.data.rpId,
          allowCredentials: challengeResult.data.allowCredentials.map((cred) => ({
            id: base64ToArrayBuffer(cred.id),
            type: 'public-key' as const,
            transports: cred.transports as AuthenticatorTransport[],
          })),
          timeout: 60000,
          userVerification: 'preferred',
        },
      }) as PublicKeyCredential | null;

      if (!credential) {
        return {
          success: false,
          error: { code: 'PASSKEY_CANCELLED', message: 'Authentication was cancelled' },
        };
      }

      const response = credential.response as AuthenticatorAssertionResponse;

      // Step 3: Verify with server
      const verifyResult = await authApi.verifyPasskey({
        email,
        credentialId: arrayBufferToBase64(credential.rawId),
        clientDataJSON: arrayBufferToBase64(response.clientDataJSON),
        authenticatorData: arrayBufferToBase64(response.authenticatorData),
        signature: arrayBufferToBase64(response.signature),
        userHandle: response.userHandle ? arrayBufferToBase64(response.userHandle) : undefined,
      });

      if (!verifyResult.success || !verifyResult.data) {
        return {
          success: false,
          error: verifyResult.error || { code: 'PASSKEY_VERIFY_FAILED', message: 'Passkey verification failed' },
        };
      }

      // Update state with authenticated user
      setState({
        user: verifyResult.data.user,
        isAuthenticated: true,
        isLoading: false,
        error: null,
      });

      return { success: true };
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Passkey authentication failed';

      setState(prev => ({ ...prev, error: errorMessage }));

      return {
        success: false,
        error: { code: 'PASSKEY_ERROR', message: errorMessage },
      };
    }
  }, []);

  // Request OTP
  const requestOtp = useCallback(async (email: string): Promise<ApiResponse<void>> => {
    setState(prev => ({ ...prev, error: null }));

    try {
      const result = await authApi.requestOtp(email);

      if (!result.success) {
        return {
          success: false,
          error: result.error || { code: 'OTP_REQUEST_FAILED', message: 'Failed to send OTP' },
        };
      }

      return { success: true };
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Failed to request OTP';

      return {
        success: false,
        error: { code: 'OTP_REQUEST_FAILED', message: errorMessage },
      };
    }
  }, []);

  // Verify OTP
  const verifyOtp = useCallback(async (email: string, otp: string): Promise<ApiResponse<void>> => {
    setState(prev => ({ ...prev, error: null }));

    try {
      const result = await authApi.verifyOtp(email, otp);

      if (!result.success || !result.data) {
        return {
          success: false,
          error: result.error || { code: 'OTP_VERIFY_FAILED', message: 'Invalid or expired code' },
        };
      }

      // Update state with authenticated user
      setState({
        user: result.data.user,
        isAuthenticated: true,
        isLoading: false,
        error: null,
      });

      return { success: true };
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'OTP verification failed';

      setState(prev => ({ ...prev, error: errorMessage }));

      return {
        success: false,
        error: { code: 'OTP_VERIFY_FAILED', message: errorMessage },
      };
    }
  }, []);

  // Logout
  const logout = useCallback(async () => {
    try {
      await authApi.logout();
    } finally {
      setState({
        user: null,
        isAuthenticated: false,
        isLoading: false,
        error: null,
      });

      router.push('/login');
    }
  }, [router]);

  // Check permission
  const hasPermission = useCallback((permission: AdminPermission): boolean => {
    if (!state.user) return false;

    // SuperAdmin has all permissions
    if (state.user.role === 'SuperAdmin') return true;

    return state.user.permissions.includes(permission);
  }, [state.user]);

  // Check role
  const hasRole = useCallback((role: AdminRole | AdminRole[]): boolean => {
    if (!state.user) return false;

    // SuperAdmin matches all roles
    if (state.user.role === 'SuperAdmin') return true;

    const roles = Array.isArray(role) ? role : [role];
    return roles.includes(state.user.role);
  }, [state.user]);

  // Refresh session
  const refreshSession = useCallback(async () => {
    try {
      const result = await authApi.refreshSession();

      if (result.success && result.data) {
        setState(prev => ({
          ...prev,
          user: result.data!.user,
        }));
      }
    } catch (_err) {
      // Silent fail - let session expire naturally
    }
  }, []);

  // Refresh session periodically
  useEffect(() => {
    if (!state.isAuthenticated) return;

    const interval = setInterval(refreshSession, 5 * 60 * 1000); // Every 5 minutes

    return () => clearInterval(interval);
  }, [state.isAuthenticated, refreshSession]);

  const value = useMemo<AuthContextValue>(() => ({
    ...state,
    login,
    initiatePasskeyAuth,
    verifyOtp,
    requestOtp,
    logout,
    hasPermission,
    hasRole,
    refreshSession,
  }), [
    state,
    login,
    initiatePasskeyAuth,
    verifyOtp,
    requestOtp,
    logout,
    hasPermission,
    hasRole,
    refreshSession,
  ]);

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
}

// ============================================
// Hook
// ============================================

export function useAuth(): AuthContextValue {
  const context = useContext(AuthContext);

  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }

  return context;
}

// ============================================
// Permission Guard Component
// ============================================

interface RequirePermissionProps {
  permission: AdminPermission | AdminPermission[];
  children: ReactNode;
  fallback?: ReactNode;
}

export function RequirePermission({
  permission,
  children,
  fallback = null,
}: RequirePermissionProps) {
  const { hasPermission } = useAuth();

  const permissions = Array.isArray(permission) ? permission : [permission];
  const hasAccess = permissions.some(p => hasPermission(p));

  if (!hasAccess) {
    return <>{fallback}</>;
  }

  return <>{children}</>;
}

// ============================================
// Role Guard Component
// ============================================

interface RequireRoleProps {
  role: AdminRole | AdminRole[];
  children: ReactNode;
  fallback?: ReactNode;
}

export function RequireRole({
  role,
  children,
  fallback = null,
}: RequireRoleProps) {
  const { hasRole } = useAuth();

  if (!hasRole(role)) {
    return <>{fallback}</>;
  }

  return <>{children}</>;
}

// ============================================
// Utility Functions
// ============================================

function base64ToArrayBuffer(base64: string): ArrayBuffer {
  // Handle URL-safe base64
  const standardBase64 = base64.replace(/-/g, '+').replace(/_/g, '/');
  const binaryString = atob(standardBase64);
  const bytes = new Uint8Array(binaryString.length);

  for (let i = 0; i < binaryString.length; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }

  return bytes.buffer;
}

function arrayBufferToBase64(buffer: ArrayBuffer): string {
  const bytes = new Uint8Array(buffer);
  let binary = '';

  for (let i = 0; i < bytes.byteLength; i++) {
    binary += String.fromCharCode(bytes[i]);
  }

  // Return URL-safe base64
  return btoa(binary).replace(/\+/g, '-').replace(/\//g, '_').replace(/=/g, '');
}
