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
import {
  Ticket,
  Clock,
  CheckCircle,
  MessageSquare,
  AlertCircle,
  Eye,
  Filter,
  User,
  Lock,
  CreditCard,
  HelpCircle,
  Shield,
  Bug,
} from 'lucide-react';

// Mock data - replace with API calls
const mockTickets = [
  {
    id: '1',
    userEmail: 'sarah@example.com',
    userDisplayName: 'Sarah M.',
    category: 'Account/Login',
    subject: 'Cannot log in with passkey',
    status: 'New',
    priority: 'High',
    createdAt: '2025-11-29T11:00:00Z',
  },
  {
    id: '2',
    userEmail: 'john@example.com',
    userDisplayName: 'John D.',
    category: 'Verification Help',
    subject: 'Stripe Identity stuck at pending',
    status: 'InReview',
    priority: 'Normal',
    createdAt: '2025-11-29T09:30:00Z',
  },
  {
    id: '3',
    userEmail: 'mike@example.com',
    userDisplayName: 'Michael T.',
    category: 'Technical Issue',
    subject: 'App crashes when uploading receipt',
    status: 'InReview',
    priority: 'High',
    createdAt: '2025-11-28T16:45:00Z',
  },
  {
    id: '4',
    userEmail: 'emma@example.com',
    userDisplayName: 'Emma R.',
    category: 'General Question',
    subject: 'How to increase TrustScore?',
    status: 'Resolved',
    priority: 'Low',
    createdAt: '2025-11-28T14:20:00Z',
  },
  {
    id: '5',
    userEmail: 'alex@example.com',
    userDisplayName: 'Alex P.',
    category: 'Billing/Subscription',
    subject: 'Charged twice for Premium',
    status: 'New',
    priority: 'Urgent',
    createdAt: '2025-11-29T08:15:00Z',
  },
];

const statusColors: Record<string, string> = {
  New: 'bg-blue-100 text-blue-800',
  InReview: 'bg-yellow-100 text-yellow-800',
  WaitingForUser: 'bg-orange-100 text-orange-800',
  Resolved: 'bg-green-100 text-green-800',
  Closed: 'bg-gray-100 text-gray-800',
};

const priorityColors: Record<string, string> = {
  Low: 'bg-gray-100 text-gray-700',
  Normal: 'bg-blue-100 text-blue-700',
  High: 'bg-orange-100 text-orange-700',
  Urgent: 'bg-red-100 text-red-700',
};

const categoryIcons: Record<string, React.ReactNode> = {
  'Account/Login': <Lock className="h-4 w-4" />,
  'Verification Help': <Shield className="h-4 w-4" />,
  'Technical Issue': <Bug className="h-4 w-4" />,
  'General Question': <HelpCircle className="h-4 w-4" />,
  'Billing/Subscription': <CreditCard className="h-4 w-4" />,
  'Privacy/Data': <User className="h-4 w-4" />,
};

export function SupportContent() {
  const [tickets, setTickets] = useState(mockTickets);
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [categoryFilter, setCategoryFilter] = useState<string>('all');
  const [isLoading, setIsLoading] = useState(false);

  const filteredTickets = tickets.filter(t => {
    const statusMatch = statusFilter === 'all' || t.status === statusFilter;
    const categoryMatch = categoryFilter === 'all' || t.category === categoryFilter;
    return statusMatch && categoryMatch;
  });

  const stats = {
    total: tickets.length,
    new: tickets.filter(t => t.status === 'New').length,
    inReview: tickets.filter(t => t.status === 'InReview').length,
    urgent: tickets.filter(t => t.priority === 'Urgent').length,
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
            <CardTitle className="text-sm font-medium">Total Tickets</CardTitle>
            <Ticket className="h-4 w-4 text-muted-foreground" />
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
            <CardTitle className="text-sm font-medium">In Review</CardTitle>
            <MessageSquare className="h-4 w-4 text-yellow-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-yellow-600">{stats.inReview}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Urgent</CardTitle>
            <AlertCircle className="h-4 w-4 text-red-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-red-600">{stats.urgent}</div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle className="text-lg">All Tickets</CardTitle>
            <div className="flex items-center gap-2">
              <Filter className="h-4 w-4 text-muted-foreground" />
              <Select value={statusFilter} onValueChange={setStatusFilter}>
                <SelectTrigger className="w-[150px]">
                  <SelectValue placeholder="Status" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Statuses</SelectItem>
                  <SelectItem value="New">New</SelectItem>
                  <SelectItem value="InReview">In Review</SelectItem>
                  <SelectItem value="WaitingForUser">Waiting</SelectItem>
                  <SelectItem value="Resolved">Resolved</SelectItem>
                  <SelectItem value="Closed">Closed</SelectItem>
                </SelectContent>
              </Select>
              <Select value={categoryFilter} onValueChange={setCategoryFilter}>
                <SelectTrigger className="w-[180px]">
                  <SelectValue placeholder="Category" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Categories</SelectItem>
                  <SelectItem value="Account/Login">Account/Login</SelectItem>
                  <SelectItem value="Verification Help">Verification</SelectItem>
                  <SelectItem value="Technical Issue">Technical</SelectItem>
                  <SelectItem value="General Question">General</SelectItem>
                  <SelectItem value="Billing/Subscription">Billing</SelectItem>
                  <SelectItem value="Privacy/Data">Privacy/Data</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>User</TableHead>
                <TableHead>Category</TableHead>
                <TableHead>Subject</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Priority</TableHead>
                <TableHead>Date</TableHead>
                <TableHead className="text-right">Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filteredTickets.map((ticket) => (
                <TableRow key={ticket.id}>
                  <TableCell>
                    <div>
                      <div className="font-medium">{ticket.userDisplayName}</div>
                      <div className="text-sm text-muted-foreground">{ticket.userEmail}</div>
                    </div>
                  </TableCell>
                  <TableCell>
                    <div className="flex items-center gap-2">
                      {categoryIcons[ticket.category]}
                      <span className="text-sm">{ticket.category}</span>
                    </div>
                  </TableCell>
                  <TableCell>
                    <div className="max-w-[250px] truncate">{ticket.subject}</div>
                  </TableCell>
                  <TableCell>
                    <Badge className={statusColors[ticket.status]}>
                      {ticket.status === 'InReview' ? 'In Review' :
                       ticket.status === 'WaitingForUser' ? 'Waiting' :
                       ticket.status}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    <Badge className={priorityColors[ticket.priority]}>
                      {ticket.priority}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-muted-foreground text-sm">
                    {formatDate(ticket.createdAt)}
                  </TableCell>
                  <TableCell className="text-right">
                    <Button variant="outline" size="sm">
                      <Eye className="h-4 w-4 mr-1" />
                      View
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
              {filteredTickets.length === 0 && (
                <TableRow>
                  <TableCell colSpan={7} className="text-center py-8 text-muted-foreground">
                    No tickets found
                  </TableCell>
                </TableRow>
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      {/* Response Time Info */}
      <Card className="border-blue-200 bg-blue-50">
        <CardContent className="pt-6">
          <div className="flex items-start gap-3">
            <Clock className="h-5 w-5 text-blue-600 flex-shrink-0 mt-0.5" />
            <div>
              <h4 className="font-semibold text-blue-900">Response Time Guidelines</h4>
              <p className="text-sm text-blue-700">
                Urgent tickets should be addressed within 4 hours. High priority within 24 hours.
                Normal priority within 48 hours. All tickets should receive at least an initial response
                within 24-48 hours as communicated to users.
              </p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
