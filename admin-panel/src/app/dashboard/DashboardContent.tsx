'use client';

import {
  Users,
  FileCheck,
  AlertTriangle,
  Globe,
  TrendingUp,
  Shield,
  Clock,
  CheckCircle,
} from 'lucide-react';
import { StatCard, Card, CardHeader, CardTitle, CardContent, TrustBadge, RiskSeverityBadge } from '@/components/ui';
import { formatRelativeTime, formatNumber } from '@/lib/utils';
import type { TrustLevel, RiskSeverity } from '@/types';

// Mock data - replace with real API calls
const mockStats = {
  totalUsers: 12847,
  activeUsers: 11234,
  verifiedUsers: 8456,
  suspendedUsers: 156,
  averageTrustScore: 687,
  evidenceSubmittedToday: 342,
  alertsToReview: 23,
  platformsActive: 8,
};

const mockRecentUsers = [
  {
    id: '1',
    displayName: 'Sarah Johnson',
    email: 's.johnson@email.com',
    trustScore: 892,
    trustLevel: 'Exceptional' as TrustLevel,
    joinedAt: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: '2',
    displayName: 'Mike Chen',
    email: 'm.chen@email.com',
    trustScore: 645,
    trustLevel: 'High' as TrustLevel,
    joinedAt: new Date(Date.now() - 5 * 60 * 60 * 1000).toISOString(),
  },
  {
    id: '3',
    displayName: 'Emma Wilson',
    email: 'e.wilson@email.com',
    trustScore: 423,
    trustLevel: 'Moderate' as TrustLevel,
    joinedAt: new Date(Date.now() - 8 * 60 * 60 * 1000).toISOString(),
  },
];

const mockAlerts = [
  {
    id: '1',
    userId: 'usr_12345',
    category: 'ImpossibleTravel',
    severity: 'High' as RiskSeverity,
    description: 'Login from London, then Paris within 30 minutes',
    detectedAt: new Date(Date.now() - 15 * 60 * 1000).toISOString(),
  },
  {
    id: '2',
    userId: 'usr_67890',
    category: 'FailedVerifications',
    severity: 'Medium' as RiskSeverity,
    description: '5 failed verification attempts in 24 hours',
    detectedAt: new Date(Date.now() - 45 * 60 * 1000).toISOString(),
  },
  {
    id: '3',
    userId: 'usr_11223',
    category: 'SuspiciousEvidence',
    severity: 'Critical' as RiskSeverity,
    description: 'Potential forged receipt detected',
    detectedAt: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(),
  },
];

const mockPlatformHealth = [
  { name: 'Vinted', health: 98, status: 'healthy' },
  { name: 'eBay', health: 95, status: 'healthy' },
  { name: 'Depop', health: 87, status: 'warning' },
  { name: 'Facebook Marketplace', health: 45, status: 'critical' },
];

export function DashboardContent() {
  return (
    <div className="space-y-6">
      {/* Stats Grid */}
      <div className="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-4">
        <StatCard
          title="Total Users"
          value={formatNumber(mockStats.totalUsers)}
          change={12.5}
          changeLabel="vs last month"
          icon={<Users className="h-6 w-6" />}
          iconColor="bg-silentid-purple-50 text-silentid-purple"
        />
        <StatCard
          title="Verified Users"
          value={formatNumber(mockStats.verifiedUsers)}
          change={8.3}
          changeLabel="vs last month"
          icon={<CheckCircle className="h-6 w-6" />}
          iconColor="bg-status-success-light text-status-success"
        />
        <StatCard
          title="Pending Alerts"
          value={mockStats.alertsToReview}
          change={-15}
          changeLabel="vs yesterday"
          icon={<AlertTriangle className="h-6 w-6" />}
          iconColor="bg-status-warning-light text-status-warning"
        />
        <StatCard
          title="Active Platforms"
          value={mockStats.platformsActive}
          icon={<Globe className="h-6 w-6" />}
          iconColor="bg-status-info-light text-status-info"
        />
      </div>

      {/* Middle Row */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Recent Users */}
        <Card>
          <CardHeader>
            <CardTitle>Recent Registrations</CardTitle>
            <a
              href="/dashboard/users"
              className="text-sm text-silentid-purple hover:text-silentid-purple-dark"
            >
              View all
            </a>
          </CardHeader>
          <CardContent className="p-0">
            <div className="divide-y divide-admin-border">
              {mockRecentUsers.map((user) => (
                <div
                  key={user.id}
                  className="flex items-center justify-between px-6 py-4 hover:bg-gray-50"
                >
                  <div className="flex items-center gap-3">
                    <div className="flex h-10 w-10 items-center justify-center rounded-full bg-silentid-purple-50 text-silentid-purple font-medium">
                      {user.displayName
                        .split(' ')
                        .map((n) => n[0])
                        .join('')}
                    </div>
                    <div>
                      <p className="font-medium text-gray-900">
                        {user.displayName}
                      </p>
                      <p className="text-sm text-gray-500">{user.email}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-4">
                    <TrustBadge level={user.trustLevel} score={user.trustScore} />
                    <span className="text-sm text-gray-500">
                      {formatRelativeTime(user.joinedAt)}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Risk Alerts */}
        <Card>
          <CardHeader>
            <CardTitle>Recent Alerts</CardTitle>
            <a
              href="/dashboard/reports"
              className="text-sm text-silentid-purple hover:text-silentid-purple-dark"
            >
              View all
            </a>
          </CardHeader>
          <CardContent className="p-0">
            <div className="divide-y divide-admin-border">
              {mockAlerts.map((alert) => (
                <div
                  key={alert.id}
                  className="flex items-start justify-between px-6 py-4 hover:bg-gray-50"
                >
                  <div className="flex items-start gap-3">
                    <div
                      className={`mt-0.5 flex h-8 w-8 items-center justify-center rounded-lg ${
                        alert.severity === 'Critical'
                          ? 'bg-status-danger-light text-status-danger'
                          : alert.severity === 'High'
                          ? 'bg-orange-100 text-orange-600'
                          : 'bg-status-warning-light text-status-warning'
                      }`}
                    >
                      <AlertTriangle className="h-4 w-4" />
                    </div>
                    <div>
                      <div className="flex items-center gap-2">
                        <p className="font-medium text-gray-900">
                          {alert.category.replace(/([A-Z])/g, ' $1').trim()}
                        </p>
                        <RiskSeverityBadge severity={alert.severity} />
                      </div>
                      <p className="mt-0.5 text-sm text-gray-600">
                        {alert.description}
                      </p>
                      <p className="mt-1 text-xs text-gray-400">
                        User: {alert.userId}
                      </p>
                    </div>
                  </div>
                  <span className="whitespace-nowrap text-sm text-gray-500">
                    {formatRelativeTime(alert.detectedAt)}
                  </span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Bottom Row */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
        {/* Platform Health */}
        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle>Platform Selector Health</CardTitle>
            <a
              href="/dashboard/platforms"
              className="text-sm text-silentid-purple hover:text-silentid-purple-dark"
            >
              Manage platforms
            </a>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {mockPlatformHealth.map((platform) => (
                <div key={platform.name} className="space-y-2">
                  <div className="flex items-center justify-between">
                    <span className="font-medium text-gray-900">
                      {platform.name}
                    </span>
                    <span
                      className={`text-sm font-medium ${
                        platform.status === 'healthy'
                          ? 'text-status-success'
                          : platform.status === 'warning'
                          ? 'text-status-warning'
                          : 'text-status-danger'
                      }`}
                    >
                      {platform.health}% success rate
                    </span>
                  </div>
                  <div className="h-2 w-full overflow-hidden rounded-full bg-gray-100">
                    <div
                      className={`h-full rounded-full transition-all ${
                        platform.status === 'healthy'
                          ? 'bg-status-success'
                          : platform.status === 'warning'
                          ? 'bg-status-warning'
                          : 'bg-status-danger'
                      }`}
                      style={{ width: `${platform.health}%` }}
                    />
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Quick Stats */}
        <Card>
          <CardHeader>
            <CardTitle>Today's Activity</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <div className="flex items-center justify-between rounded-lg bg-gray-50 p-4">
                <div className="flex items-center gap-3">
                  <FileCheck className="h-5 w-5 text-silentid-purple" />
                  <span className="text-sm text-gray-600">Evidence Submitted</span>
                </div>
                <span className="text-lg font-semibold text-gray-900">
                  {mockStats.evidenceSubmittedToday}
                </span>
              </div>
              <div className="flex items-center justify-between rounded-lg bg-gray-50 p-4">
                <div className="flex items-center gap-3">
                  <Shield className="h-5 w-5 text-status-success" />
                  <span className="text-sm text-gray-600">Verifications Completed</span>
                </div>
                <span className="text-lg font-semibold text-gray-900">89</span>
              </div>
              <div className="flex items-center justify-between rounded-lg bg-gray-50 p-4">
                <div className="flex items-center gap-3">
                  <TrendingUp className="h-5 w-5 text-status-info" />
                  <span className="text-sm text-gray-600">Avg Trust Score</span>
                </div>
                <span className="text-lg font-semibold text-gray-900">
                  {mockStats.averageTrustScore}
                </span>
              </div>
              <div className="flex items-center justify-between rounded-lg bg-gray-50 p-4">
                <div className="flex items-center gap-3">
                  <Clock className="h-5 w-5 text-status-warning" />
                  <span className="text-sm text-gray-600">Pending Reviews</span>
                </div>
                <span className="text-lg font-semibold text-gray-900">
                  {mockStats.alertsToReview}
                </span>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
