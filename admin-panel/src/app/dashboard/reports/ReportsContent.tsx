'use client';

import { useState } from 'react';
import {
  Search,
  Filter,
  Eye,
  CheckCircle,
  Shield,
  AlertTriangle,
  MapPin,
  Smartphone,
  UserX,
  FileWarning,
} from 'lucide-react';
import {
  Card,
  CardContent,
  StatCard,
  Button,
  RiskSeverityBadge,
} from '@/components/ui';
import { formatRelativeTime, formatNumber } from '@/lib/utils';
import type { RiskSeverity, RiskCategory } from '@/types';

interface RiskAlertItem {
  id: string;
  userId: string;
  userEmail: string;
  category: RiskCategory;
  severity: RiskSeverity;
  description: string;
  detectedAt: string;
  resolvedAt: string | null;
  metadata: Record<string, unknown>;
}

const mockAlerts: RiskAlertItem[] = [
  {
    id: 'alert_001',
    userId: 'usr_12345',
    userEmail: 'suspicious.user@email.com',
    category: 'ImpossibleTravel',
    severity: 'Critical',
    description: 'Login from London, UK then Paris, France within 30 minutes',
    detectedAt: new Date(Date.now() - 15 * 60 * 1000).toISOString(),
    resolvedAt: null,
    metadata: {
      fromLocation: 'London, UK',
      toLocation: 'Paris, France',
      timeDiff: '28 minutes',
    },
  },
  {
    id: 'alert_002',
    userId: 'usr_67890',
    userEmail: 'user.two@email.com',
    category: 'FailedVerifications',
    severity: 'High',
    description: '5 failed verification attempts for Vinted profile',
    detectedAt: new Date(Date.now() - 45 * 60 * 1000).toISOString(),
    resolvedAt: null,
    metadata: {
      platform: 'Vinted',
      attempts: 5,
      lastAttempt: 'Token expired',
    },
  },
  {
    id: 'alert_003',
    userId: 'usr_11223',
    userEmail: 'another.user@email.com',
    category: 'SuspiciousEvidence',
    severity: 'High',
    description: 'Receipt metadata indicates potential forgery',
    detectedAt: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(),
    resolvedAt: null,
    metadata: {
      evidenceId: 'evd_456',
      confidence: 15,
      reason: 'Metadata timestamp inconsistent',
    },
  },
  {
    id: 'alert_004',
    userId: 'usr_44556',
    userEmail: 'device.user@email.com',
    category: 'DeviceAnomaly',
    severity: 'Medium',
    description: 'Login from new device after 3 failed OTP attempts',
    detectedAt: new Date(Date.now() - 4 * 60 * 60 * 1000).toISOString(),
    resolvedAt: null,
    metadata: {
      newDevice: 'iPhone 15 Pro',
      previousDevice: 'Samsung Galaxy S23',
      failedAttempts: 3,
    },
  },
  {
    id: 'alert_005',
    userId: 'usr_77889',
    userEmail: 'resolved.user@email.com',
    category: 'LocationAnomaly',
    severity: 'Low',
    description: 'VPN detected during verification',
    detectedAt: new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString(),
    resolvedAt: new Date(Date.now() - 20 * 60 * 60 * 1000).toISOString(),
    metadata: {
      vpnProvider: 'NordVPN',
      realLocation: 'Unknown',
    },
  },
];

const getCategoryIcon = (category: RiskCategory) => {
  switch (category) {
    case 'ImpossibleTravel':
      return <MapPin className="h-5 w-5" />;
    case 'DeviceAnomaly':
      return <Smartphone className="h-5 w-5" />;
    case 'FailedVerifications':
      return <UserX className="h-5 w-5" />;
    case 'SuspiciousEvidence':
      return <FileWarning className="h-5 w-5" />;
    case 'LocationAnomaly':
      return <MapPin className="h-5 w-5" />;
    case 'AccountTakeover':
      return <Shield className="h-5 w-5" />;
    case 'FraudPattern':
      return <AlertTriangle className="h-5 w-5" />;
    default:
      return <AlertTriangle className="h-5 w-5" />;
  }
};

const getCategoryLabel = (category: RiskCategory) => {
  return category.replace(/([A-Z])/g, ' $1').trim();
};

export function ReportsContent() {
  const [searchQuery, setSearchQuery] = useState('');
  const [severityFilter, setSeverityFilter] = useState<RiskSeverity | 'all'>('all');
  const [statusFilter, setStatusFilter] = useState<'all' | 'open' | 'resolved'>('all');

  const openAlerts = mockAlerts.filter((a) => !a.resolvedAt);
  const criticalAlerts = mockAlerts.filter((a) => a.severity === 'Critical' && !a.resolvedAt);

  const filteredAlerts = mockAlerts.filter((alert) => {
    const matchesSearch =
      searchQuery === '' ||
      alert.userEmail.toLowerCase().includes(searchQuery.toLowerCase()) ||
      alert.userId.toLowerCase().includes(searchQuery.toLowerCase()) ||
      alert.description.toLowerCase().includes(searchQuery.toLowerCase());

    const matchesSeverity = severityFilter === 'all' || alert.severity === severityFilter;
    const matchesStatus =
      statusFilter === 'all' ||
      (statusFilter === 'open' && !alert.resolvedAt) ||
      (statusFilter === 'resolved' && alert.resolvedAt);

    return matchesSearch && matchesSeverity && matchesStatus;
  });

  return (
    <div className="space-y-6">
      {/* Stats */}
      <div className="grid grid-cols-1 gap-6 md:grid-cols-4">
        <StatCard
          title="Open Alerts"
          value={openAlerts.length}
          icon={<AlertTriangle className="h-6 w-6" />}
          iconColor="bg-status-warning-light text-status-warning"
        />
        <StatCard
          title="Critical"
          value={criticalAlerts.length}
          icon={<Shield className="h-6 w-6" />}
          iconColor="bg-status-danger-light text-status-danger"
        />
        <StatCard
          title="Resolved Today"
          value={mockAlerts.filter((a) => a.resolvedAt).length}
          icon={<CheckCircle className="h-6 w-6" />}
          iconColor="bg-status-success-light text-status-success"
        />
        <StatCard
          title="Avg Response Time"
          value="2.4h"
          icon={<Shield className="h-6 w-6" />}
          iconColor="bg-status-info-light text-status-info"
        />
      </div>

      {/* Filters */}
      <Card>
        <CardContent className="py-4">
          <div className="flex flex-wrap items-center gap-4">
            <div className="relative flex-1 min-w-64">
              <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                placeholder="Search by user, description..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="input pl-10"
              />
            </div>

            <div className="flex items-center gap-2">
              <Filter className="h-4 w-4 text-gray-400" />
              <select
                value={severityFilter}
                onChange={(e) => setSeverityFilter(e.target.value as RiskSeverity | 'all')}
                className="input w-auto"
              >
                <option value="all">All Severity</option>
                <option value="Critical">Critical</option>
                <option value="High">High</option>
                <option value="Medium">Medium</option>
                <option value="Low">Low</option>
              </select>
            </div>

            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value as 'all' | 'open' | 'resolved')}
              className="input w-auto"
            >
              <option value="all">All Status</option>
              <option value="open">Open</option>
              <option value="resolved">Resolved</option>
            </select>

            <span className="text-sm text-gray-500">
              {formatNumber(filteredAlerts.length)} alerts
            </span>
          </div>
        </CardContent>
      </Card>

      {/* Alerts List */}
      <div className="space-y-4">
        {filteredAlerts.map((alert) => (
          <Card key={alert.id} className={alert.resolvedAt ? 'opacity-60' : ''}>
            <CardContent className="py-4">
              <div className="flex items-start gap-4">
                {/* Icon */}
                <div
                  className={`flex h-12 w-12 items-center justify-center rounded-xl ${
                    alert.severity === 'Critical'
                      ? 'bg-status-danger-light text-status-danger'
                      : alert.severity === 'High'
                      ? 'bg-orange-100 text-orange-600'
                      : alert.severity === 'Medium'
                      ? 'bg-status-warning-light text-status-warning'
                      : 'bg-status-info-light text-status-info'
                  }`}
                >
                  {getCategoryIcon(alert.category)}
                </div>

                {/* Content */}
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-3 mb-1">
                    <h4 className="font-medium text-gray-900">
                      {getCategoryLabel(alert.category)}
                    </h4>
                    <RiskSeverityBadge severity={alert.severity} />
                    {alert.resolvedAt && (
                      <span className="badge-success">Resolved</span>
                    )}
                  </div>
                  <p className="text-gray-600 mb-2">{alert.description}</p>
                  <div className="flex items-center gap-4 text-sm text-gray-500">
                    <span>User: {alert.userEmail}</span>
                    <span>ID: {alert.userId}</span>
                    <span>{formatRelativeTime(alert.detectedAt)}</span>
                  </div>
                </div>

                {/* Actions */}
                <div className="flex items-center gap-2">
                  <Button variant="ghost" size="sm" icon={<Eye className="h-4 w-4" />}>
                    View
                  </Button>
                  {!alert.resolvedAt && (
                    <Button
                      variant="secondary"
                      size="sm"
                      icon={<CheckCircle className="h-4 w-4" />}
                    >
                      Resolve
                    </Button>
                  )}
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>
    </div>
  );
}
