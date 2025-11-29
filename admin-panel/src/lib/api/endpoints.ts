import { apiClient } from './client';
import type {
  User,
  UserDetail,
  Evidence,
  Platform,
  PlatformConfigVersion,
  RiskAlert,
  AdminUser,
  AuditLogEntry,
  DashboardStats,
  PaginatedResponse,
  ShadowTestResult,
} from '@/types';

// ============================================
// Users API
// ============================================

export const usersApi = {
  list: (params?: {
    page?: number;
    pageSize?: number;
    status?: string;
    level?: string;
    search?: string;
  }) => apiClient.get<PaginatedResponse<User>>('/admin/users', params),

  getById: (id: string) => apiClient.get<UserDetail>(`/admin/users/${id}`),

  suspend: (id: string, justification: string) =>
    apiClient.post(`/admin/users/${id}/suspend`, { justification }),

  unsuspend: (id: string, justification: string) =>
    apiClient.post(`/admin/users/${id}/unsuspend`, { justification }),

  markUnderReview: (id: string, justification: string) =>
    apiClient.post(`/admin/users/${id}/mark-review`, { justification }),

  clearReview: (id: string, justification: string) =>
    apiClient.post(`/admin/users/${id}/clear-review`, { justification }),

  recalculateTrustScore: (id: string) =>
    apiClient.post(`/admin/users/${id}/recalculate-trust-score`),

  addNote: (id: string, content: string) =>
    apiClient.post(`/admin/users/${id}/notes`, { content }),

  getLoginHistory: (id: string, params?: { page?: number; pageSize?: number }) =>
    apiClient.get(`/admin/users/${id}/login-history`, params),
};

// ============================================
// Evidence API
// ============================================

export const evidenceApi = {
  list: (params?: {
    page?: number;
    pageSize?: number;
    type?: string;
    status?: string;
    userId?: string;
  }) => apiClient.get<PaginatedResponse<Evidence>>('/admin/evidence', params),

  getById: (id: string) => apiClient.get<Evidence>(`/admin/evidence/${id}`),

  approve: (id: string, justification: string) =>
    apiClient.post(`/admin/evidence/${id}/approve`, { justification }),

  reject: (id: string, justification: string) =>
    apiClient.post(`/admin/evidence/${id}/reject`, { justification }),

  markSuspicious: (id: string, justification: string) =>
    apiClient.post(`/admin/evidence/${id}/mark-suspicious`, { justification }),

  delete: (id: string, justification: string) =>
    apiClient.delete(`/admin/evidence/${id}?justification=${encodeURIComponent(justification)}`),

  requestReExtraction: (id: string) =>
    apiClient.post(`/admin/evidence/${id}/re-extract`),
};

// ============================================
// Platforms API (Section 48)
// ============================================

export const platformsApi = {
  list: () => apiClient.get<Platform[]>('/admin/platforms'),

  getById: (id: string) => apiClient.get<Platform>(`/admin/platforms/${id}`),

  // Version Management
  getVersions: (platformId: string) =>
    apiClient.get<PlatformConfigVersion[]>(`/admin/platforms/${platformId}/versions`),

  getVersion: (platformId: string, versionId: string) =>
    apiClient.get<PlatformConfigVersion>(`/admin/platforms/${platformId}/versions/${versionId}`),

  createDraftVersion: (platformId: string) =>
    apiClient.post<PlatformConfigVersion>(`/admin/platforms/${platformId}/versions/draft`),

  updateDraftVersion: (platformId: string, versionId: string, data: Partial<PlatformConfigVersion>) =>
    apiClient.put<PlatformConfigVersion>(`/admin/platforms/${platformId}/versions/${versionId}`, data),

  promoteDraftToActive: (platformId: string, versionId: string, justification: string) =>
    apiClient.post(`/admin/platforms/${platformId}/versions/${versionId}/promote`, { justification }),

  discardDraft: (platformId: string, versionId: string) =>
    apiClient.delete(`/admin/platforms/${platformId}/versions/${versionId}`),

  rollbackToVersion: (platformId: string, versionId: string, justification: string) =>
    apiClient.post(`/admin/platforms/${platformId}/versions/${versionId}/rollback`, { justification }),

  // Shadow Testing
  runShadowTest: (platformId: string, sampleUrls: string[]) =>
    apiClient.post<ShadowTestResult[]>(`/admin/platforms/${platformId}/shadow-test`, { sampleUrls }),

  getSampleUrls: (platformId: string) =>
    apiClient.get<string[]>(`/admin/platforms/${platformId}/sample-urls`),

  addSampleUrl: (platformId: string, url: string) =>
    apiClient.post(`/admin/platforms/${platformId}/sample-urls`, { url }),

  removeSampleUrl: (platformId: string, url: string) =>
    apiClient.delete(`/admin/platforms/${platformId}/sample-urls?url=${encodeURIComponent(url)}`),

  // Selectors
  validateSelector: (expression: string, type: string) =>
    apiClient.post<{ valid: boolean; error?: string }>('/admin/platforms/validate-selector', {
      expression,
      type,
    }),
};

// ============================================
// Security / Risk Alerts API
// ============================================

export const securityApi = {
  listAlerts: (params?: {
    page?: number;
    pageSize?: number;
    severity?: string;
    category?: string;
    status?: 'open' | 'resolved';
  }) => apiClient.get<PaginatedResponse<RiskAlert>>('/admin/security/alerts', params),

  getAlert: (id: string) => apiClient.get<RiskAlert>(`/admin/security/alerts/${id}`),

  resolveAlert: (id: string, justification: string) =>
    apiClient.post(`/admin/security/alerts/${id}/resolve`, { justification }),

  escalateAlert: (id: string, justification: string) =>
    apiClient.post(`/admin/security/alerts/${id}/escalate`, { justification }),

  lockUser: (userId: string, justification: string) =>
    apiClient.post(`/admin/security/users/${userId}/lock`, { justification }),

  forceStepUpVerification: (userId: string, justification: string) =>
    apiClient.post(`/admin/security/users/${userId}/force-step-up`, { justification }),

  clearRiskFlags: (userId: string, justification: string) =>
    apiClient.post(`/admin/security/users/${userId}/clear-risk-flags`, { justification }),
};

// ============================================
// Admin Management API
// ============================================

export const adminApi = {
  list: () => apiClient.get<AdminUser[]>('/admin/admins'),

  getById: (id: string) => apiClient.get<AdminUser>(`/admin/admins/${id}`),

  invite: (email: string, role: string) =>
    apiClient.post('/admin/admins/invite', { email, role }),

  updateRole: (id: string, role: string) =>
    apiClient.patch(`/admin/admins/${id}`, { role }),

  deactivate: (id: string) => apiClient.post(`/admin/admins/${id}/deactivate`),

  reactivate: (id: string) => apiClient.post(`/admin/admins/${id}/reactivate`),
};

// ============================================
// Audit Logs API
// ============================================

export const auditApi = {
  list: (params?: {
    page?: number;
    pageSize?: number;
    adminId?: string;
    targetType?: string;
    targetId?: string;
    startDate?: string;
    endDate?: string;
  }) => apiClient.get<PaginatedResponse<AuditLogEntry>>('/admin/audit-logs', params),

  getById: (id: string) => apiClient.get<AuditLogEntry>(`/admin/audit-logs/${id}`),
};

// ============================================
// Dashboard API
// ============================================

export const dashboardApi = {
  getStats: () => apiClient.get<DashboardStats>('/admin/dashboard/stats'),

  getTrustDistribution: () =>
    apiClient.get<{ label: string; count: number; percentage: number }[]>(
      '/admin/dashboard/trust-distribution'
    ),

  getUserGrowth: (period: 'day' | 'week' | 'month') =>
    apiClient.get<{ date: string; value: number }[]>('/admin/dashboard/user-growth', { period }),

  getRecentActivity: () =>
    apiClient.get<{
      recentUsers: User[];
      recentAlerts: RiskAlert[];
      platformHealth: { name: string; health: number; status: string }[];
    }>('/admin/dashboard/recent-activity'),
};
