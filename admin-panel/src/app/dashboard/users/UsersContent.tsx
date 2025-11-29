'use client';

import { useState } from 'react';
import { Search, Filter, Eye, Ban, RefreshCw } from 'lucide-react';
import {
  Card,
  CardContent,
  Button,
  TrustBadge,
  AccountStatusBadge,
  VerificationLevelBadge,
} from '@/components/ui';
import { formatTableDate, formatNumber } from '@/lib/utils';
import type { User, AccountStatus, VerificationLevel } from '@/types';

// Mock data - replace with API calls
const mockUsers: User[] = [
  {
    id: 'usr_001',
    email: 'sarah.johnson@email.com',
    displayName: 'Sarah Johnson',
    createdAt: '2024-01-15T10:30:00Z',
    lastLoginAt: '2024-11-28T14:20:00Z',
    accountStatus: 'Active',
    verificationLevel: 'L3',
    trustScore: 892,
    trustLevel: 'Exceptional',
    riskScore: 5,
    isEmailVerified: true,
    hasPasskey: true,
    hasStripeIdentity: true,
  },
  {
    id: 'usr_002',
    email: 'mike.chen@email.com',
    displayName: 'Mike Chen',
    createdAt: '2024-02-20T08:15:00Z',
    lastLoginAt: '2024-11-27T09:45:00Z',
    accountStatus: 'Active',
    verificationLevel: 'L2',
    trustScore: 645,
    trustLevel: 'High',
    riskScore: 15,
    isEmailVerified: true,
    hasPasskey: true,
    hasStripeIdentity: false,
  },
  {
    id: 'usr_003',
    email: 'emma.wilson@email.com',
    displayName: 'Emma Wilson',
    createdAt: '2024-03-10T15:45:00Z',
    lastLoginAt: '2024-11-26T18:30:00Z',
    accountStatus: 'UnderReview',
    verificationLevel: 'L1',
    trustScore: 423,
    trustLevel: 'Moderate',
    riskScore: 45,
    isEmailVerified: true,
    hasPasskey: false,
    hasStripeIdentity: false,
  },
  {
    id: 'usr_004',
    email: 'john.doe@email.com',
    displayName: 'John Doe',
    createdAt: '2024-04-05T11:20:00Z',
    lastLoginAt: '2024-11-20T12:00:00Z',
    accountStatus: 'Suspended',
    verificationLevel: 'L2',
    trustScore: 156,
    trustLevel: 'HighRisk',
    riskScore: 85,
    isEmailVerified: true,
    hasPasskey: false,
    hasStripeIdentity: true,
  },
];

export function UsersContent() {
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState<AccountStatus | 'all'>('all');
  const [levelFilter, setLevelFilter] = useState<VerificationLevel | 'all'>('all');

  const filteredUsers = mockUsers.filter((user) => {
    const matchesSearch =
      searchQuery === '' ||
      user.email.toLowerCase().includes(searchQuery.toLowerCase()) ||
      user.displayName?.toLowerCase().includes(searchQuery.toLowerCase()) ||
      user.id.toLowerCase().includes(searchQuery.toLowerCase());

    const matchesStatus = statusFilter === 'all' || user.accountStatus === statusFilter;
    const matchesLevel = levelFilter === 'all' || user.verificationLevel === levelFilter;

    return matchesSearch && matchesStatus && matchesLevel;
  });

  return (
    <div className="space-y-6">
      {/* Filters */}
      <Card>
        <CardContent className="py-4">
          <div className="flex flex-wrap items-center gap-4">
            {/* Search */}
            <div className="relative flex-1 min-w-64">
              <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                placeholder="Search by ID, email, or name..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="input pl-10"
              />
            </div>

            {/* Status Filter */}
            <div className="flex items-center gap-2">
              <Filter className="h-4 w-4 text-gray-400" />
              <select
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value as AccountStatus | 'all')}
                className="input w-auto"
              >
                <option value="all">All Status</option>
                <option value="Active">Active</option>
                <option value="Suspended">Suspended</option>
                <option value="UnderReview">Under Review</option>
              </select>
            </div>

            {/* Level Filter */}
            <select
              value={levelFilter}
              onChange={(e) => setLevelFilter(e.target.value as VerificationLevel | 'all')}
              className="input w-auto"
            >
              <option value="all">All Levels</option>
              <option value="L1">Level 1</option>
              <option value="L2">Level 2</option>
              <option value="L3">Level 3</option>
            </select>

            {/* Results count */}
            <span className="text-sm text-gray-500">
              {formatNumber(filteredUsers.length)} users
            </span>
          </div>
        </CardContent>
      </Card>

      {/* Users Table */}
      <Card>
        <div className="table-container">
          <table className="table">
            <thead>
              <tr>
                <th>User</th>
                <th>Status</th>
                <th>Level</th>
                <th>Trust Score</th>
                <th>Risk</th>
                <th>Created</th>
                <th>Last Login</th>
                <th className="w-20">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredUsers.map((user) => (
                <tr key={user.id}>
                  <td>
                    <div className="flex items-center gap-3">
                      <div className="flex h-10 w-10 items-center justify-center rounded-full bg-silentid-purple-50 text-silentid-purple font-medium text-sm">
                        {user.displayName
                          ?.split(' ')
                          .map((n) => n[0])
                          .join('') || '?'}
                      </div>
                      <div>
                        <p className="font-medium text-gray-900">
                          {user.displayName || 'No Name'}
                        </p>
                        <p className="text-sm text-gray-500">{user.email}</p>
                        <p className="text-xs text-gray-400">{user.id}</p>
                      </div>
                    </div>
                  </td>
                  <td>
                    <AccountStatusBadge status={user.accountStatus} />
                  </td>
                  <td>
                    <VerificationLevelBadge level={user.verificationLevel} />
                  </td>
                  <td>
                    <TrustBadge level={user.trustLevel} score={user.trustScore} />
                  </td>
                  <td>
                    <span
                      className={`font-medium ${
                        user.riskScore >= 70
                          ? 'text-status-danger'
                          : user.riskScore >= 40
                          ? 'text-status-warning'
                          : 'text-status-success'
                      }`}
                    >
                      {user.riskScore}%
                    </span>
                  </td>
                  <td className="text-gray-500">
                    {formatTableDate(user.createdAt)}
                  </td>
                  <td className="text-gray-500">
                    {user.lastLoginAt ? formatTableDate(user.lastLoginAt) : 'Never'}
                  </td>
                  <td>
                    <div className="flex items-center gap-1">
                      <button
                        className="p-1.5 text-gray-400 hover:text-silentid-purple hover:bg-silentid-purple-50 rounded-lg transition-colors"
                        title="View Details"
                      >
                        <Eye className="h-4 w-4" />
                      </button>
                      <button
                        className="p-1.5 text-gray-400 hover:text-status-warning hover:bg-status-warning-light rounded-lg transition-colors"
                        title="Recalculate Trust Score"
                      >
                        <RefreshCw className="h-4 w-4" />
                      </button>
                      <button
                        className="p-1.5 text-gray-400 hover:text-status-danger hover:bg-status-danger-light rounded-lg transition-colors"
                        title="Suspend User"
                      >
                        <Ban className="h-4 w-4" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        <div className="flex items-center justify-between border-t border-admin-border px-6 py-4">
          <span className="text-sm text-gray-500">
            Showing 1-{filteredUsers.length} of {mockUsers.length} users
          </span>
          <div className="flex items-center gap-2">
            <Button variant="outline" size="sm" disabled>
              Previous
            </Button>
            <Button variant="outline" size="sm" disabled>
              Next
            </Button>
          </div>
        </div>
      </Card>
    </div>
  );
}
