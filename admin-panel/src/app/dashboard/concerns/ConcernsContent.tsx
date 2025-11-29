'use client';

import { useState, useEffect } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { AlertTriangle, CheckCircle, Clock, XCircle, Eye, Filter } from 'lucide-react';

// Mock data - replace with API calls
const mockConcerns = [
  {
    id: '1',
    reportedUsername: '@john_seller',
    reportedDisplayName: 'John S.',
    reporterUsername: '@jane_buyer',
    reason: 'Profile might not belong to this person',
    notes: 'The profile photo looks different from other platforms.',
    status: 'New',
    createdAt: '2025-11-29T10:30:00Z',
  },
  {
    id: '2',
    reportedUsername: '@seller_123',
    reportedDisplayName: 'Michael T.',
    reporterUsername: '@buyer_456',
    reason: 'Suspicious or inconsistent information',
    notes: null,
    status: 'UnderReview',
    createdAt: '2025-11-28T14:20:00Z',
  },
  {
    id: '3',
    reportedUsername: '@vintage_finds',
    reportedDisplayName: 'Sarah M.',
    reporterUsername: '@collector_99',
    reason: 'Something feels unsafe',
    notes: 'Very pushy about meeting in person.',
    status: 'Reviewed',
    createdAt: '2025-11-27T09:15:00Z',
  },
];

const statusColors: Record<string, string> = {
  New: 'bg-blue-100 text-blue-800',
  UnderReview: 'bg-yellow-100 text-yellow-800',
  Reviewed: 'bg-green-100 text-green-800',
  Dismissed: 'bg-gray-100 text-gray-800',
};

const statusIcons: Record<string, React.ReactNode> = {
  New: <Clock className="h-4 w-4" />,
  UnderReview: <AlertTriangle className="h-4 w-4" />,
  Reviewed: <CheckCircle className="h-4 w-4" />,
  Dismissed: <XCircle className="h-4 w-4" />,
};

export function ConcernsContent() {
  const [concerns, setConcerns] = useState(mockConcerns);
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [isLoading, setIsLoading] = useState(false);

  const filteredConcerns = statusFilter === 'all'
    ? concerns
    : concerns.filter(c => c.status === statusFilter);

  const stats = {
    total: concerns.length,
    new: concerns.filter(c => c.status === 'New').length,
    underReview: concerns.filter(c => c.status === 'UnderReview').length,
    reviewed: concerns.filter(c => c.status === 'Reviewed').length,
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-GB', {
      day: '2-digit',
      month: 'short',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  };

  return (
    <div className="space-y-6">
      {/* Stats Cards */}
      <div className="grid gap-4 md:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Concerns</CardTitle>
            <AlertTriangle className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.total}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">New</CardTitle>
            <Clock className="h-4 w-4 text-blue-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-blue-600">{stats.new}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Under Review</CardTitle>
            <AlertTriangle className="h-4 w-4 text-yellow-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-yellow-600">{stats.underReview}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Reviewed</CardTitle>
            <CheckCircle className="h-4 w-4 text-green-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-green-600">{stats.reviewed}</div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle className="text-lg">All Concerns</CardTitle>
            <div className="flex items-center gap-2">
              <Filter className="h-4 w-4 text-muted-foreground" />
              <Select value={statusFilter} onValueChange={setStatusFilter}>
                <SelectTrigger className="w-[180px]">
                  <SelectValue placeholder="Filter by status" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Statuses</SelectItem>
                  <SelectItem value="New">New</SelectItem>
                  <SelectItem value="UnderReview">Under Review</SelectItem>
                  <SelectItem value="Reviewed">Reviewed</SelectItem>
                  <SelectItem value="Dismissed">Dismissed</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Reported User</TableHead>
                <TableHead>Reporter</TableHead>
                <TableHead>Reason</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Date</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filteredConcerns.map((concern) => (
                <TableRow key={concern.id}>
                  <TableCell>
                    <div>
                      <div className="font-medium">{concern.reportedDisplayName}</div>
                      <div className="text-sm text-muted-foreground">{concern.reportedUsername}</div>
                    </div>
                  </TableCell>
                  <TableCell className="text-muted-foreground">
                    {concern.reporterUsername}
                  </TableCell>
                  <TableCell>
                    <div className="max-w-[200px]">
                      <div className="font-medium text-sm">{concern.reason}</div>
                      {concern.notes && (
                        <div className="text-xs text-muted-foreground truncate">{concern.notes}</div>
                      )}
                    </div>
                  </TableCell>
                  <TableCell>
                    <Badge className={statusColors[concern.status]}>
                      <span className="flex items-center gap-1">
                        {statusIcons[concern.status]}
                        {concern.status}
                      </span>
                    </Badge>
                  </TableCell>
                  <TableCell className="text-muted-foreground text-sm">
                    {formatDate(concern.createdAt)}
                  </TableCell>
                  <TableCell className="text-right">
                    <Button variant="outline" size="sm">
                      <Eye className="h-4 w-4 mr-1" />
                      View
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
              {filteredConcerns.length === 0 && (
                <TableRow>
                  <TableCell colSpan={6} className="text-center py-8 text-muted-foreground">
                    No concerns found
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      {/* Note about privacy */}
      <Card className="border-purple-200 bg-purple-50">
        <CardContent className="pt-6">
          <div className="flex items-start gap-3">
            <AlertTriangle className="h-5 w-5 text-purple-600 flex-shrink-0 mt-0.5" />
            <div>
              <h4 className="font-semibold text-purple-900">Privacy Notice</h4>
              <p className="text-sm text-purple-700">
                Reporter identities are kept confidential. Never share reporter information with the reported user.
                All concerns use neutral, non-accusatory language. No automatic penalties are applied.
              </p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
