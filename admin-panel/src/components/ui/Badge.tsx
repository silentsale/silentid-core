import { cn } from '@/lib/utils';
import type { TrustLevel, AccountStatus, LinkStatus, EvidenceStatus, RiskSeverity } from '@/types';

type BadgeVariant = 'default' | 'success' | 'warning' | 'danger' | 'info' | 'purple';

interface BadgeProps {
  children: React.ReactNode;
  variant?: BadgeVariant;
  className?: string;
}

const variantClasses: Record<BadgeVariant, string> = {
  default: 'bg-gray-100 text-gray-700',
  success: 'bg-status-success-light text-status-success',
  warning: 'bg-status-warning-light text-status-warning',
  danger: 'bg-status-danger-light text-status-danger',
  info: 'bg-status-info-light text-status-info',
  purple: 'bg-silentid-purple-50 text-silentid-purple',
};

export function Badge({ children, variant = 'default', className }: BadgeProps) {
  return (
    <span
      className={cn(
        'inline-flex items-center px-2.5 py-0.5 text-xs font-medium rounded-full',
        variantClasses[variant],
        className
      )}
    >
      {children}
    </span>
  );
}

// Trust Level Badge
interface TrustBadgeProps {
  level: TrustLevel;
  score?: number;
  className?: string;
}

const trustLevelConfig: Record<TrustLevel, { label: string; className: string }> = {
  Exceptional: { label: 'Exceptional', className: 'bg-emerald-100 text-emerald-700' },
  VeryHigh: { label: 'Very High', className: 'bg-green-100 text-green-700' },
  High: { label: 'High', className: 'bg-lime-100 text-lime-700' },
  Moderate: { label: 'Moderate', className: 'bg-amber-100 text-amber-700' },
  Low: { label: 'Low', className: 'bg-orange-100 text-orange-700' },
  HighRisk: { label: 'High Risk', className: 'bg-red-100 text-red-700' },
};

export function TrustBadge({ level, score, className }: TrustBadgeProps) {
  const config = trustLevelConfig[level];
  return (
    <span
      className={cn(
        'inline-flex items-center gap-1.5 px-2.5 py-0.5 text-xs font-medium rounded-full',
        config.className,
        className
      )}
    >
      {score !== undefined && <span className="font-semibold">{score}</span>}
      {config.label}
    </span>
  );
}

// Account Status Badge
interface StatusBadgeProps {
  status: AccountStatus;
  className?: string;
}

const accountStatusConfig: Record<AccountStatus, { label: string; variant: BadgeVariant }> = {
  Active: { label: 'Active', variant: 'success' },
  Suspended: { label: 'Suspended', variant: 'danger' },
  UnderReview: { label: 'Under Review', variant: 'warning' },
  Deleted: { label: 'Deleted', variant: 'default' },
};

export function AccountStatusBadge({ status, className }: StatusBadgeProps) {
  const config = accountStatusConfig[status];
  return (
    <Badge variant={config.variant} className={className}>
      {config.label}
    </Badge>
  );
}

// Link Status Badge
interface LinkStatusBadgeProps {
  status: LinkStatus;
  className?: string;
}

const linkStatusConfig: Record<LinkStatus, { label: string; variant: BadgeVariant }> = {
  Linked: { label: 'Linked', variant: 'info' },
  Verified: { label: 'Verified', variant: 'success' },
  Failed: { label: 'Failed', variant: 'danger' },
  Pending: { label: 'Pending', variant: 'warning' },
};

export function LinkStatusBadge({ status, className }: LinkStatusBadgeProps) {
  const config = linkStatusConfig[status];
  return (
    <Badge variant={config.variant} className={className}>
      {config.label}
    </Badge>
  );
}

// Evidence Status Badge
interface EvidenceStatusBadgeProps {
  status: EvidenceStatus;
  className?: string;
}

const evidenceStatusConfig: Record<EvidenceStatus, { label: string; variant: BadgeVariant }> = {
  Valid: { label: 'Valid', variant: 'success' },
  Invalid: { label: 'Invalid', variant: 'danger' },
  Pending: { label: 'Pending', variant: 'warning' },
  Suspicious: { label: 'Suspicious', variant: 'danger' },
};

export function EvidenceStatusBadge({ status, className }: EvidenceStatusBadgeProps) {
  const config = evidenceStatusConfig[status];
  return (
    <Badge variant={config.variant} className={className}>
      {config.label}
    </Badge>
  );
}

// Risk Severity Badge
interface RiskSeverityBadgeProps {
  severity: RiskSeverity;
  className?: string;
}

const riskSeverityConfig: Record<RiskSeverity, { label: string; variant: BadgeVariant }> = {
  Critical: { label: 'Critical', variant: 'danger' },
  High: { label: 'High', variant: 'danger' },
  Medium: { label: 'Medium', variant: 'warning' },
  Low: { label: 'Low', variant: 'info' },
};

export function RiskSeverityBadge({ severity, className }: RiskSeverityBadgeProps) {
  const config = riskSeverityConfig[severity];
  return (
    <Badge variant={config.variant} className={className}>
      {config.label}
    </Badge>
  );
}

// Verification Level Badge
interface VerificationLevelBadgeProps {
  level: 'L1' | 'L2' | 'L3';
  className?: string;
}

export function VerificationLevelBadge({ level, className }: VerificationLevelBadgeProps) {
  const config = {
    L1: { label: 'Level 1', variant: 'default' as BadgeVariant },
    L2: { label: 'Level 2', variant: 'info' as BadgeVariant },
    L3: { label: 'Level 3', variant: 'purple' as BadgeVariant },
  };
  const levelConfig = config[level];
  return (
    <Badge variant={levelConfig.variant} className={className}>
      {levelConfig.label}
    </Badge>
  );
}
