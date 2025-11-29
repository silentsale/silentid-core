'use client';

import { useState } from 'react';
import { Search, Filter, Eye, CheckCircle, XCircle, AlertTriangle } from 'lucide-react';
import {
  Card,
  CardContent,
  Badge,
  EvidenceStatusBadge,
} from '@/components/ui';
import { formatTableDate, formatPercent } from '@/lib/utils';
import type { EvidenceType, EvidenceStatus } from '@/types';

interface EvidenceItem {
  id: string;
  userId: string;
  userEmail: string;
  type: EvidenceType;
  status: EvidenceStatus;
  confidence: number;
  platformName: string;
  createdAt: string;
  reviewedAt: string | null;
  details: string;
}

// Mock data
const mockEvidence: EvidenceItem[] = [
  {
    id: 'evd_001',
    userId: 'usr_001',
    userEmail: 'sarah.johnson@email.com',
    type: 'Receipt',
    status: 'Valid',
    confidence: 95,
    platformName: 'Vinted',
    createdAt: '2024-11-28T10:30:00Z',
    reviewedAt: '2024-11-28T11:00:00Z',
    details: 'Order #VIN-2024-12345, GBP 45.00',
  },
  {
    id: 'evd_002',
    userId: 'usr_002',
    userEmail: 'mike.chen@email.com',
    type: 'Screenshot',
    status: 'Pending',
    confidence: 72,
    platformName: 'eBay',
    createdAt: '2024-11-28T09:15:00Z',
    reviewedAt: null,
    details: 'Profile screenshot showing 4.9 rating',
  },
  {
    id: 'evd_003',
    userId: 'usr_003',
    userEmail: 'emma.wilson@email.com',
    type: 'ProfileLink',
    status: 'Suspicious',
    confidence: 35,
    platformName: 'Depop',
    createdAt: '2024-11-27T16:45:00Z',
    reviewedAt: null,
    details: 'Profile URL mismatch detected',
  },
  {
    id: 'evd_004',
    userId: 'usr_004',
    userEmail: 'john.doe@email.com',
    type: 'Receipt',
    status: 'Invalid',
    confidence: 15,
    platformName: 'Facebook',
    createdAt: '2024-11-27T14:20:00Z',
    reviewedAt: '2024-11-27T15:30:00Z',
    details: 'Forged receipt detected - metadata inconsistent',
  },
];

export function EvidenceContent() {
  const [searchQuery, setSearchQuery] = useState('');
  const [typeFilter, setTypeFilter] = useState<EvidenceType | 'all'>('all');
  const [statusFilter, setStatusFilter] = useState<EvidenceStatus | 'all'>('all');

  const filteredEvidence = mockEvidence.filter((item) => {
    const matchesSearch =
      searchQuery === '' ||
      item.userEmail.toLowerCase().includes(searchQuery.toLowerCase()) ||
      item.userId.toLowerCase().includes(searchQuery.toLowerCase()) ||
      item.id.toLowerCase().includes(searchQuery.toLowerCase());

    const matchesType = typeFilter === 'all' || item.type === typeFilter;
    const matchesStatus = statusFilter === 'all' || item.status === statusFilter;

    return matchesSearch && matchesType && matchesStatus;
  });

  const getTypeIcon = (type: EvidenceType) => {
    switch (type) {
      case 'Receipt':
        return '📧';
      case 'Screenshot':
        return '📷';
      case 'ProfileLink':
        return '🔗';
      default:
        return '📄';
    }
  };

  const getConfidenceColor = (confidence: number) => {
    if (confidence >= 80) return 'text-status-success';
    if (confidence >= 50) return 'text-status-warning';
    return 'text-status-danger';
  };

  return (
    <div className="space-y-6">
      {/* Stats */}
      <div className="grid grid-cols-1 gap-4 md:grid-cols-4">
        <Card>
          <CardContent className="py-4">
            <div className="text-center">
              <p className="text-2xl font-semibold text-gray-900">
                {mockEvidence.filter((e) => e.status === 'Pending').length}
              </p>
              <p className="text-sm text-gray-500">Pending Review</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="py-4">
            <div className="text-center">
              <p className="text-2xl font-semibold text-status-success">
                {mockEvidence.filter((e) => e.status === 'Valid').length}
              </p>
              <p className="text-sm text-gray-500">Approved Today</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="py-4">
            <div className="text-center">
              <p className="text-2xl font-semibold text-status-danger">
                {mockEvidence.filter((e) => e.status === 'Suspicious').length}
              </p>
              <p className="text-sm text-gray-500">Suspicious</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="py-4">
            <div className="text-center">
              <p className="text-2xl font-semibold text-gray-900">
                {formatPercent(
                  mockEvidence.reduce((acc, e) => acc + e.confidence, 0) /
                    mockEvidence.length
                )}
              </p>
              <p className="text-sm text-gray-500">Avg Confidence</p>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <Card>
        <CardContent className="py-4">
          <div className="flex flex-wrap items-center gap-4">
            <div className="relative flex-1 min-w-64">
              <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                placeholder="Search by ID, user email..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="input pl-10"
              />
            </div>

            <div className="flex items-center gap-2">
              <Filter className="h-4 w-4 text-gray-400" />
              <select
                value={typeFilter}
                onChange={(e) => setTypeFilter(e.target.value as EvidenceType | 'all')}
                className="input w-auto"
              >
                <option value="all">All Types</option>
                <option value="Receipt">Receipts</option>
                <option value="Screenshot">Screenshots</option>
                <option value="ProfileLink">Profile Links</option>
              </select>
            </div>

            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value as EvidenceStatus | 'all')}
              className="input w-auto"
            >
              <option value="all">All Status</option>
              <option value="Pending">Pending</option>
              <option value="Valid">Valid</option>
              <option value="Invalid">Invalid</option>
              <option value="Suspicious">Suspicious</option>
            </select>
          </div>
        </CardContent>
      </Card>

      {/* Evidence Table */}
      <Card>
        <div className="table-container">
          <table className="table">
            <thead>
              <tr>
                <th>Evidence</th>
                <th>User</th>
                <th>Platform</th>
                <th>Status</th>
                <th>Confidence</th>
                <th>Submitted</th>
                <th className="w-32">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredEvidence.map((item) => (
                <tr key={item.id}>
                  <td>
                    <div className="flex items-center gap-3">
                      <span className="text-2xl">{getTypeIcon(item.type)}</span>
                      <div>
                        <p className="font-medium text-gray-900">{item.type}</p>
                        <p className="text-sm text-gray-500">{item.id}</p>
                        <p className="text-xs text-gray-400 max-w-xs truncate">
                          {item.details}
                        </p>
                      </div>
                    </div>
                  </td>
                  <td>
                    <p className="text-sm text-gray-900">{item.userEmail}</p>
                    <p className="text-xs text-gray-400">{item.userId}</p>
                  </td>
                  <td>
                    <Badge variant="purple">{item.platformName}</Badge>
                  </td>
                  <td>
                    <EvidenceStatusBadge status={item.status} />
                  </td>
                  <td>
                    <span className={`font-medium ${getConfidenceColor(item.confidence)}`}>
                      {item.confidence}%
                    </span>
                  </td>
                  <td className="text-gray-500">
                    {formatTableDate(item.createdAt)}
                  </td>
                  <td>
                    <div className="flex items-center gap-1">
                      <button
                        className="p-1.5 text-gray-400 hover:text-silentid-purple hover:bg-silentid-purple-50 rounded-lg transition-colors"
                        title="View Details"
                      >
                        <Eye className="h-4 w-4" />
                      </button>
                      {item.status === 'Pending' && (
                        <>
                          <button
                            className="p-1.5 text-gray-400 hover:text-status-success hover:bg-status-success-light rounded-lg transition-colors"
                            title="Approve"
                          >
                            <CheckCircle className="h-4 w-4" />
                          </button>
                          <button
                            className="p-1.5 text-gray-400 hover:text-status-danger hover:bg-status-danger-light rounded-lg transition-colors"
                            title="Reject"
                          >
                            <XCircle className="h-4 w-4" />
                          </button>
                        </>
                      )}
                      {item.status === 'Suspicious' && (
                        <button
                          className="p-1.5 text-gray-400 hover:text-status-warning hover:bg-status-warning-light rounded-lg transition-colors"
                          title="Investigate"
                        >
                          <AlertTriangle className="h-4 w-4" />
                        </button>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Card>
    </div>
  );
}
