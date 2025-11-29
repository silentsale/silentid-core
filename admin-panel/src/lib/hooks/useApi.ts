'use client';

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import {
  usersApi,
  evidenceApi,
  platformsApi,
  securityApi,
  dashboardApi,
} from '@/lib/api';

// ============================================
// Dashboard Hooks
// ============================================

export function useDashboardStats() {
  return useQuery({
    queryKey: ['dashboard', 'stats'],
    queryFn: async () => {
      const response = await dashboardApi.getStats();
      if (!response.success) throw new Error(response.error?.message);
      return response.data;
    },
    staleTime: 1000 * 60, // 1 minute
  });
}

export function useDashboardActivity() {
  return useQuery({
    queryKey: ['dashboard', 'activity'],
    queryFn: async () => {
      const response = await dashboardApi.getRecentActivity();
      if (!response.success) throw new Error(response.error?.message);
      return response.data;
    },
    staleTime: 1000 * 30, // 30 seconds
  });
}

// ============================================
// Users Hooks
// ============================================

export function useUsers(params?: {
  page?: number;
  pageSize?: number;
  status?: string;
  level?: string;
  search?: string;
}) {
  return useQuery({
    queryKey: ['users', params],
    queryFn: async () => {
      const response = await usersApi.list(params);
      if (!response.success) throw new Error(response.error?.message);
      return response.data;
    },
  });
}

export function useUser(id: string) {
  return useQuery({
    queryKey: ['users', id],
    queryFn: async () => {
      const response = await usersApi.getById(id);
      if (!response.success) throw new Error(response.error?.message);
      return response.data;
    },
    enabled: !!id,
  });
}

export function useSuspendUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, justification }: { id: string; justification: string }) =>
      usersApi.suspend(id, justification),
    onSuccess: (_, { id }) => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
      queryClient.invalidateQueries({ queryKey: ['users', id] });
    },
  });
}

export function useRecalculateTrustScore() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: string) => usersApi.recalculateTrustScore(id),
    onSuccess: (_, id) => {
      queryClient.invalidateQueries({ queryKey: ['users', id] });
    },
  });
}

// ============================================
// Evidence Hooks
// ============================================

export function useEvidence(params?: {
  page?: number;
  pageSize?: number;
  type?: string;
  status?: string;
  userId?: string;
}) {
  return useQuery({
    queryKey: ['evidence', params],
    queryFn: async () => {
      const response = await evidenceApi.list(params);
      if (!response.success) throw new Error(response.error?.message);
      return response.data;
    },
  });
}

export function useApproveEvidence() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, justification }: { id: string; justification: string }) =>
      evidenceApi.approve(id, justification),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['evidence'] });
    },
  });
}

export function useRejectEvidence() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, justification }: { id: string; justification: string }) =>
      evidenceApi.reject(id, justification),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['evidence'] });
    },
  });
}

// ============================================
// Platforms Hooks
// ============================================

export function usePlatforms() {
  return useQuery({
    queryKey: ['platforms'],
    queryFn: async () => {
      const response = await platformsApi.list();
      if (!response.success) throw new Error(response.error?.message);
      return response.data;
    },
  });
}

export function usePlatform(id: string) {
  return useQuery({
    queryKey: ['platforms', id],
    queryFn: async () => {
      const response = await platformsApi.getById(id);
      if (!response.success) throw new Error(response.error?.message);
      return response.data;
    },
    enabled: !!id,
  });
}

export function usePlatformVersions(platformId: string) {
  return useQuery({
    queryKey: ['platforms', platformId, 'versions'],
    queryFn: async () => {
      const response = await platformsApi.getVersions(platformId);
      if (!response.success) throw new Error(response.error?.message);
      return response.data;
    },
    enabled: !!platformId,
  });
}

export function useRunShadowTest() {
  return useMutation({
    mutationFn: ({
      platformId,
      sampleUrls,
    }: {
      platformId: string;
      sampleUrls: string[];
    }) => platformsApi.runShadowTest(platformId, sampleUrls),
  });
}

export function usePromoteDraft() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({
      platformId,
      versionId,
      justification,
    }: {
      platformId: string;
      versionId: string;
      justification: string;
    }) => platformsApi.promoteDraftToActive(platformId, versionId, justification),
    onSuccess: (_, { platformId }) => {
      queryClient.invalidateQueries({ queryKey: ['platforms', platformId] });
    },
  });
}

// ============================================
// Security Hooks
// ============================================

export function useRiskAlerts(params?: {
  page?: number;
  pageSize?: number;
  severity?: string;
  category?: string;
  status?: 'open' | 'resolved';
}) {
  return useQuery({
    queryKey: ['security', 'alerts', params],
    queryFn: async () => {
      const response = await securityApi.listAlerts(params);
      if (!response.success) throw new Error(response.error?.message);
      return response.data;
    },
  });
}

export function useResolveAlert() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, justification }: { id: string; justification: string }) =>
      securityApi.resolveAlert(id, justification),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['security', 'alerts'] });
    },
  });
}
