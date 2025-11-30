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
  }) => apiClient.get<PaginatedResponse<User>>('/v1/admin/users', params),

  getById: (id: string) => apiClient.get<UserDetail>(`/v1/admin/users/${id}`),

  suspend: (id: string, justification: string) =>
    apiClient.post(`/v1/admin/users/${id}/action`, { action: 'Freeze', reason: justification }),

  unsuspend: (id: string, justification: string) =>
    apiClient.post(`/v1/admin/users/${id}/action`, { action: 'Unfreeze', reason: justification }),

  markUnderReview: (id: string, justification: string) =>
    apiClient.post(`/v1/admin/users/${id}/action`, { action: 'Limit', reason: justification }),

  clearReview: (id: string, justification: string) =>
    apiClient.post(`/v1/admin/users/${id}/action`, { action: 'Unfreeze', reason: justification }),

  recalculateTrustScore: (id: string) =>
    apiClient.post(`/v1/admin/users/${id}/recalculate-trust-score`),

  addNote: (id: string, content: string) =>
    apiClient.post(`/v1/admin/users/${id}/notes`, { content }),

  getLoginHistory: (id: string, params?: { page?: number; pageSize?: number }) =>
    apiClient.get(`/v1/admin/users/${id}/login-history`, params),
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
  }) => apiClient.get<PaginatedResponse<Evidence>>('/v1/admin/evidence', params),

  getById: (id: string) => apiClient.get<Evidence>(`/v1/admin/evidence/${id}`),

  approve: (id: string, justification: string) =>
    apiClient.post(`/v1/admin/evidence/${id}/approve`, { justification }),

  reject: (id: string, justification: string) =>
    apiClient.post(`/v1/admin/evidence/${id}/reject`, { justification }),

  markSuspicious: (id: string, justification: string) =>
    apiClient.post(`/v1/admin/evidence/${id}/mark-suspicious`, { justification }),

  delete: (id: string, justification: string) =>
    apiClient.delete(`/v1/admin/evidence/${id}?justification=${encodeURIComponent(justification)}`),

  requestReExtraction: (id: string) =>
    apiClient.post(`/v1/admin/evidence/${id}/re-extract`),
};

// ============================================
// Platforms API (Section 48)
// ============================================

export const platformsApi = {
  list: () => apiClient.get<Platform[]>('/v1/admin/platforms'),

  getById: (id: string) => apiClient.get<Platform>(`/v1/admin/platforms/${id}`),

  // Version Management
  getVersions: (platformId: string) =>
    apiClient.get<PlatformConfigVersion[]>(`/v1/admin/platforms/${platformId}/versions`),

  getVersion: (platformId: string, versionId: string) =>
    apiClient.get<PlatformConfigVersion>(`/v1/admin/platforms/${platformId}/versions/${versionId}`),

  createDraftVersion: (platformId: string) =>
    apiClient.post<PlatformConfigVersion>(`/v1/admin/platforms/${platformId}/versions/draft`),

  updateDraftVersion: (platformId: string, versionId: string, data: Partial<PlatformConfigVersion>) =>
    apiClient.put<PlatformConfigVersion>(`/v1/admin/platforms/${platformId}/versions/${versionId}`, data),

  promoteDraftToActive: (platformId: string, versionId: string, justification: string) =>
    apiClient.post(`/v1/admin/platforms/${platformId}/versions/${versionId}/promote`, { justification }),

  discardDraft: (platformId: string, versionId: string) =>
    apiClient.delete(`/v1/admin/platforms/${platformId}/versions/${versionId}`),

  rollbackToVersion: (platformId: string, versionId: string, justification: string) =>
    apiClient.post(`/v1/admin/platforms/${platformId}/versions/${versionId}/rollback`, { justification }),

  // Shadow Testing
  runShadowTest: (platformId: string, sampleUrls: string[]) =>
    apiClient.post<ShadowTestResult[]>(`/v1/admin/platforms/${platformId}/shadow-test`, { sampleUrls }),

  getSampleUrls: (platformId: string) =>
    apiClient.get<string[]>(`/v1/admin/platforms/${platformId}/sample-urls`),

  addSampleUrl: (platformId: string, url: string) =>
    apiClient.post(`/v1/admin/platforms/${platformId}/sample-urls`, { url }),

  removeSampleUrl: (platformId: string, url: string) =>
    apiClient.delete(`/v1/admin/platforms/${platformId}/sample-urls?url=${encodeURIComponent(url)}`),

  // Selectors
  validateSelector: (expression: string, type: string) =>
    apiClient.post<{ valid: boolean; error?: string }>('/v1/admin/platforms/validate-selector', {
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
  }) => apiClient.get<PaginatedResponse<RiskAlert>>('/v1/admin/security/alerts', params),

  getAlert: (id: string) => apiClient.get<RiskAlert>(`/v1/admin/security/alerts/${id}`),

  resolveAlert: (id: string, justification: string) =>
    apiClient.post(`/v1/admin/security/alerts/${id}/resolve`, { justification }),

  escalateAlert: (id: string, justification: string) =>
    apiClient.post(`/v1/admin/security/alerts/${id}/escalate`, { justification }),

  lockUser: (userId: string, justification: string) =>
    apiClient.post(`/v1/admin/security/users/${userId}/lock`, { justification }),

  forceStepUpVerification: (userId: string, justification: string) =>
    apiClient.post(`/v1/admin/security/users/${userId}/force-step-up`, { justification }),

  clearRiskFlags: (userId: string, justification: string) =>
    apiClient.post(`/v1/admin/security/users/${userId}/clear-risk-flags`, { justification }),
};

// ============================================
// Admin Management API
// ============================================

export const adminApi = {
  list: () => apiClient.get<AdminUser[]>('/v1/admin/admins'),

  getById: (id: string) => apiClient.get<AdminUser>(`/v1/admin/admins/${id}`),

  invite: (email: string, role: string) =>
    apiClient.post('/v1/admin/admins/invite', { email, role }),

  updateRole: (id: string, role: string) =>
    apiClient.patch(`/v1/admin/admins/${id}`, { role }),

  deactivate: (id: string) => apiClient.post(`/v1/admin/admins/${id}/deactivate`),

  reactivate: (id: string) => apiClient.post(`/v1/admin/admins/${id}/reactivate`),
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
  }) => apiClient.get<PaginatedResponse<AuditLogEntry>>('/v1/admin/audit-logs', params),

  getById: (id: string) => apiClient.get<AuditLogEntry>(`/v1/admin/audit-logs/${id}`),
};

// ============================================
// Dashboard API
// ============================================

export const dashboardApi = {
  getStats: () => apiClient.get<DashboardStats>('/v1/admin/dashboard/stats'),

  getTrustDistribution: () =>
    apiClient.get<{ label: string; count: number; percentage: number }[]>(
      '/v1/admin/dashboard/trust-distribution'
    ),

  getUserGrowth: (period: 'day' | 'week' | 'month') =>
    apiClient.get<{ date: string; value: number }[]>('/v1/admin/dashboard/user-growth', { period }),

  getRecentActivity: () =>
    apiClient.get<{
      recentUsers: User[];
      recentAlerts: RiskAlert[];
      platformHealth: { name: string; health: number; status: string }[];
    }>('/v1/admin/dashboard/recent-activity'),
};
