'use client';

import { useState } from 'react';
import {
  Search,
  Plus,
  Settings,
  Play,
  GitBranch,
  CheckCircle,
  AlertTriangle,
  XCircle,
} from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle, Button, Badge, InfoPoint } from '@/components/ui';
import { formatTableDate } from '@/lib/utils';
import type { PlatformStatus } from '@/types';

interface PlatformItem {
  id: string;
  slug: string;
  displayName: string;
  status: PlatformStatus;
  activeVersion: string;
  draftVersion: string | null;
  lastUpdatedAt: string;
  selectorHealthScore: number;
  verificationMethods: string[];
}

// Mock data
const mockPlatforms: PlatformItem[] = [
  {
    id: 'plt_001',
    slug: 'vinted',
    displayName: 'Vinted',
    status: 'Active',
    activeVersion: '2.4.1',
    draftVersion: '2.5.0-draft',
    lastUpdatedAt: '2024-11-25T14:30:00Z',
    selectorHealthScore: 98,
    verificationMethods: ['TokenInBio', 'ShareLink', 'Screenshot'],
  },
  {
    id: 'plt_002',
    slug: 'ebay',
    displayName: 'eBay',
    status: 'Active',
    activeVersion: '3.1.0',
    draftVersion: null,
    lastUpdatedAt: '2024-11-20T10:15:00Z',
    selectorHealthScore: 95,
    verificationMethods: ['ShareLink', 'Screenshot'],
  },
  {
    id: 'plt_003',
    slug: 'depop',
    displayName: 'Depop',
    status: 'Active',
    activeVersion: '1.8.2',
    draftVersion: '1.9.0-draft',
    lastUpdatedAt: '2024-11-28T09:00:00Z',
    selectorHealthScore: 87,
    verificationMethods: ['TokenInBio', 'Screenshot'],
  },
  {
    id: 'plt_004',
    slug: 'facebook-marketplace',
    displayName: 'Facebook Marketplace',
    status: 'Active',
    activeVersion: '1.2.0',
    draftVersion: null,
    lastUpdatedAt: '2024-11-15T16:45:00Z',
    selectorHealthScore: 45,
    verificationMethods: ['Screenshot'],
  },
  {
    id: 'plt_005',
    slug: 'instagram',
    displayName: 'Instagram',
    status: 'Inactive',
    activeVersion: '0.9.0',
    draftVersion: '1.0.0-draft',
    lastUpdatedAt: '2024-10-30T11:20:00Z',
    selectorHealthScore: 0,
    verificationMethods: ['TokenInBio'],
  },
];

export function PlatformsContent() {
  const [searchQuery, setSearchQuery] = useState('');

  const filteredPlatforms = mockPlatforms.filter(
    (platform) =>
      searchQuery === '' ||
      platform.displayName.toLowerCase().includes(searchQuery.toLowerCase()) ||
      platform.slug.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const getHealthColor = (score: number) => {
    if (score >= 90) return 'text-status-success';
    if (score >= 70) return 'text-status-warning';
    return 'text-status-danger';
  };

  const getHealthIcon = (score: number) => {
    if (score >= 90) return <CheckCircle className="h-4 w-4 text-status-success" />;
    if (score >= 70) return <AlertTriangle className="h-4 w-4 text-status-warning" />;
    return <XCircle className="h-4 w-4 text-status-danger" />;
  };

  return (
    <div className="space-y-6">
      {/* Header Actions */}
      <div className="flex items-center justify-between">
        <div className="relative w-80">
          <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" />
          <input
            type="text"
            placeholder="Search platforms..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="input pl-10"
          />
        </div>
        <Button icon={<Plus className="h-4 w-4" />}>
          Add Platform
        </Button>
      </div>

      {/* Platform Cards Grid */}
      <div className="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
        {filteredPlatforms.map((platform) => (
          <Card key={platform.id} hover className="overflow-hidden">
            <CardHeader className="pb-3">
              <div className="flex items-center gap-3">
                <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-silentid-purple-50 text-lg font-semibold text-silentid-purple">
                  {platform.displayName[0]}
                </div>
                <div>
                  <CardTitle className="text-base">{platform.displayName}</CardTitle>
                  <p className="text-sm text-gray-500">{platform.slug}</p>
                </div>
              </div>
              <Badge
                variant={platform.status === 'Active' ? 'success' : 'default'}
              >
                {platform.status}
              </Badge>
            </CardHeader>

            <CardContent className="pt-0">
              {/* Health Score */}
              <div className="mb-4">
                <div className="flex items-center justify-between mb-2">
                  <div className="flex items-center gap-2">
                    <span className="text-sm text-gray-600">Selector Health</span>
                    <InfoPoint content="Percentage of successful data extractions over the last 24 hours" />
                  </div>
                  <div className="flex items-center gap-1">
                    {getHealthIcon(platform.selectorHealthScore)}
                    <span className={`font-medium ${getHealthColor(platform.selectorHealthScore)}`}>
                      {platform.selectorHealthScore}%
                    </span>
                  </div>
                </div>
                <div className="h-2 w-full overflow-hidden rounded-full bg-gray-100">
                  <div
                    className={`h-full rounded-full transition-all ${
                      platform.selectorHealthScore >= 90
                        ? 'bg-status-success'
                        : platform.selectorHealthScore >= 70
                        ? 'bg-status-warning'
                        : 'bg-status-danger'
                    }`}
                    style={{ width: `${platform.selectorHealthScore}%` }}
                  />
                </div>
              </div>

              {/* Versions */}
              <div className="space-y-2 mb-4">
                <div className="flex items-center justify-between text-sm">
                  <span className="text-gray-600">Active Version</span>
                  <Badge variant="purple">{platform.activeVersion}</Badge>
                </div>
                {platform.draftVersion && (
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-gray-600">Draft Version</span>
                    <Badge variant="warning">{platform.draftVersion}</Badge>
                  </div>
                )}
              </div>

              {/* Verification Methods */}
              <div className="mb-4">
                <p className="text-sm text-gray-600 mb-2">Verification Methods</p>
                <div className="flex flex-wrap gap-1">
                  {platform.verificationMethods.map((method) => (
                    <Badge key={method} variant="default" className="text-xs">
                      {method.replace(/([A-Z])/g, ' $1').trim()}
                    </Badge>
                  ))}
                </div>
              </div>

              {/* Last Updated */}
              <p className="text-xs text-gray-400 mb-4">
                Last updated: {formatTableDate(platform.lastUpdatedAt)}
              </p>

              {/* Actions */}
              <div className="flex items-center gap-2 pt-4 border-t border-admin-border">
                <Button variant="ghost" size="sm" className="flex-1" icon={<Settings className="h-4 w-4" />}>
                  Configure
                </Button>
                {platform.draftVersion && (
                  <Button variant="ghost" size="sm" className="flex-1" icon={<Play className="h-4 w-4" />}>
                    Test Draft
                  </Button>
                )}
                <Button variant="ghost" size="sm" icon={<GitBranch className="h-4 w-4" />}>
                  History
                </Button>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Info Banner */}
      <Card className="bg-silentid-purple-50 border-silentid-purple/20">
        <CardContent className="py-4">
          <div className="flex items-start gap-3">
            <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-silentid-purple text-white">
              <InfoPoint content="" className="hidden" />
              <Settings className="h-4 w-4" />
            </div>
            <div>
              <h4 className="font-medium text-silentid-purple-dark">
                Section 48: Modular Platform Configuration System
              </h4>
              <p className="text-sm text-silentid-purple/80 mt-1">
                This system manages platform-specific selectors with version control, shadow testing,
                and safe deployment. Draft versions can be tested against sample URLs before promotion
                to active status. All changes are audit-logged with rollback capability.
              </p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
