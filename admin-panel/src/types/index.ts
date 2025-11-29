// SilentID Admin Panel - Core Types

// ============================================
// User & Identity Types
// ============================================

export type VerificationLevel = 'L1' | 'L2' | 'L3';

export type AccountStatus = 'Active' | 'Suspended' | 'UnderReview' | 'Deleted';

export type TrustLevel =
  | 'Exceptional'    // 850-1000
  | 'VeryHigh'       // 700-849
  | 'High'           // 550-699
  | 'Moderate'       // 400-549
  | 'Low'            // 250-399
  | 'HighRisk';      // 0-249

export interface User {
  id: string;
  email: string;
  displayName: string | null;
  createdAt: string;
  lastLoginAt: string | null;
  accountStatus: AccountStatus;
  verificationLevel: VerificationLevel;
  trustScore: number;
  trustLevel: TrustLevel;
  riskScore: number;
  isEmailVerified: boolean;
  hasPasskey: boolean;
  hasStripeIdentity: boolean;
}

export interface UserDetail extends User {
  trustScoreBreakdown: TrustScoreBreakdown;
  linkedPlatforms: LinkedPlatform[];
  evidenceSummary: EvidenceSummary;
  loginHistory: LoginEvent[];
  riskAlerts: RiskAlert[];
  adminNotes: AdminNote[];
}

// ============================================
// TrustScore Types
// ============================================

export interface TrustScoreBreakdown {
  total: number;
  identity: {
    score: number;
    maxScore: number;
    emailVerified: boolean;
    stripeIdentityVerified: boolean;
    passkeyConfigured: boolean;
  };
  evidence: {
    score: number;
    maxScore: number;
    receiptsCount: number;
    screenshotsCount: number;
    verifiedProfilesCount: number;
  };
  behaviour: {
    score: number;
    maxScore: number;
    accountAgeDays: number;
    loginConsistency: number;
    platformEngagement: number;
    riskSignals: number;
  };
  lastCalculatedAt: string;
}

// ============================================
// Platform & Verification Types
// ============================================

export type PlatformStatus = 'Active' | 'Inactive' | 'Deprecated';

export type LinkStatus = 'Linked' | 'Verified' | 'Failed' | 'Pending';

export type VerificationMethod = 'TokenInBio' | 'ShareLink' | 'Screenshot' | 'Manual';

export interface Platform {
  id: string;
  slug: string;
  displayName: string;
  baseUrl: string;
  status: PlatformStatus;
  activeVersion: string;
  lastUpdatedAt: string;
  selectorHealthScore: number;
  supportedVerificationMethods: VerificationMethod[];
}

export interface LinkedPlatform {
  id: string;
  platformId: string;
  platformName: string;
  platformSlug: string;
  profileUrl: string;
  profileUsername: string;
  linkStatus: LinkStatus;
  verificationMethod: VerificationMethod | null;
  verifiedAt: string | null;
  lastCheckedAt: string | null;
  extractedData: PlatformExtractedData | null;
  confidence: number;
}

export interface PlatformExtractedData {
  username: string | null;
  rating: number | null;
  reviewCount: number | null;
  followersCount: number | null;
  salesCount: number | null;
  joinDate: string | null;
  [key: string]: string | number | null;
}

// ============================================
// Evidence Types
// ============================================

export type EvidenceType = 'Receipt' | 'Screenshot' | 'ProfileLink';

export type EvidenceStatus = 'Valid' | 'Invalid' | 'Pending' | 'Suspicious';

export interface EvidenceSummary {
  totalCount: number;
  receiptsCount: number;
  screenshotsCount: number;
  verifiedProfilesCount: number;
  pendingReviewCount: number;
  averageConfidence: number;
}

export interface Evidence {
  id: string;
  userId: string;
  type: EvidenceType;
  status: EvidenceStatus;
  confidence: number;
  createdAt: string;
  reviewedAt: string | null;
  reviewedBy: string | null;
}

export interface Receipt extends Evidence {
  type: 'Receipt';
  platformName: string;
  orderId: string | null;
  amount: number | null;
  currency: string | null;
  transactionDate: string | null;
  sellerName: string | null;
}

export interface Screenshot extends Evidence {
  type: 'Screenshot';
  thumbnailUrl: string;
  extractedText: string | null;
  platformDetected: string | null;
}

// ============================================
// Security & Risk Types
// ============================================

export type RiskSeverity = 'Critical' | 'High' | 'Medium' | 'Low';

export type RiskCategory =
  | 'DeviceAnomaly'
  | 'LocationAnomaly'
  | 'ImpossibleTravel'
  | 'FailedVerifications'
  | 'SuspiciousEvidence'
  | 'AccountTakeover'
  | 'FraudPattern';

export interface RiskAlert {
  id: string;
  userId: string;
  category: RiskCategory;
  severity: RiskSeverity;
  description: string;
  detectedAt: string;
  resolvedAt: string | null;
  resolvedBy: string | null;
  metadata: Record<string, unknown>;
}

export interface LoginEvent {
  id: string;
  userId: string;
  timestamp: string;
  method: 'Passkey' | 'AppleSignIn' | 'GoogleSignIn' | 'EmailOTP';
  ipAddress: string;
  deviceFingerprint: string;
  deviceInfo: {
    platform: string;
    browser: string;
    appVersion: string;
  };
  location: {
    country: string;
    city: string;
    coordinates: [number, number] | null;
  } | null;
  success: boolean;
  failureReason: string | null;
}

// ============================================
// Admin Types
// ============================================

export type AdminRole =
  | 'Support'               // Read-only + light actions
  | 'VerificationSpecialist'
  | 'TrustAnalyst'
  | 'SecurityAnalyst'
  | 'SuperAdmin';

export interface AdminUser {
  id: string;
  email: string;
  displayName: string;
  role: AdminRole;
  isActive: boolean;
  lastLoginAt: string | null;
  permissions: AdminPermission[];
}

export type AdminPermission =
  | 'users.read'
  | 'users.suspend'
  | 'users.edit'
  | 'evidence.read'
  | 'evidence.review'
  | 'evidence.delete'
  | 'platforms.read'
  | 'platforms.edit'
  | 'platforms.deploy'
  | 'security.read'
  | 'security.resolve'
  | 'admin.manage';

export interface AdminNote {
  id: string;
  userId: string;
  authorId: string;
  authorName: string;
  content: string;
  createdAt: string;
}

export interface AuditLogEntry {
  id: string;
  adminId: string;
  adminEmail: string;
  action: string;
  targetType: 'User' | 'Evidence' | 'Platform' | 'RiskAlert' | 'Admin';
  targetId: string;
  details: Record<string, unknown>;
  justification: string | null;
  timestamp: string;
  ipAddress: string;
}

// ============================================
// Platform Configuration Types (Section 48)
// ============================================

export type SelectorType = 'CSS' | 'XPath' | 'JSONPath' | 'JsonLD' | 'Regex';

export interface PlatformSelector {
  id: string;
  dataPoint: string;
  expression: string;
  type: SelectorType;
  priority: number;
  isActive: boolean;
  successRate: number;
  lastSuccessAt: string | null;
}

export interface PlatformConfigVersion {
  id: string;
  platformId: string;
  version: string;
  status: 'Draft' | 'Active' | 'Archived';
  createdAt: string;
  createdBy: string;
  activatedAt: string | null;
  activatedBy: string | null;
  selectors: PlatformSelector[];
  verificationMethods: VerificationMethod[];
  changelog: string | null;
}

export interface ShadowTestResult {
  sampleUrl: string;
  activeVersionResult: PlatformExtractedData;
  draftVersionResult: PlatformExtractedData;
  differences: {
    dataPoint: string;
    activeValue: string | number | null;
    draftValue: string | number | null;
    match: boolean;
  }[];
  overallPass: boolean;
  executedAt: string;
}

// ============================================
// API Response Types
// ============================================

export interface PaginatedResponse<T> {
  data: T[];
  page: number;
  pageSize: number;
  totalCount: number;
  totalPages: number;
  hasNextPage: boolean;
  hasPreviousPage: boolean;
}

export interface ApiError {
  code: string;
  message: string;
  details?: Record<string, string[]>;
}

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: ApiError;
}

// ============================================
// Dashboard Analytics Types
// ============================================

export interface DashboardStats {
  totalUsers: number;
  activeUsers: number;
  verifiedUsers: number;
  suspendedUsers: number;
  averageTrustScore: number;
  evidenceSubmittedToday: number;
  alertsToReview: number;
  platformsActive: number;
}

export interface TrustScoreDistribution {
  label: TrustLevel;
  count: number;
  percentage: number;
}

export interface TimeSeriesData {
  date: string;
  value: number;
}

export interface ActivityMetric {
  label: string;
  current: number;
  previous: number;
  changePercent: number;
}
