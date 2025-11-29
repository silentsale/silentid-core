'use client';

import { useState } from 'react';
import {
  User,
  Shield,
  Bell,
  Key,
  Users,
  Database,
  Globe,
  Clock,
} from 'lucide-react';
import { Card, CardHeader, CardTitle, CardContent, Button, Badge } from '@/components/ui';
import { cn } from '@/lib/utils';

type SettingsTab = 'profile' | 'security' | 'notifications' | 'admins' | 'system';

const tabs = [
  { id: 'profile' as SettingsTab, label: 'Profile', icon: User },
  { id: 'security' as SettingsTab, label: 'Security', icon: Shield },
  { id: 'notifications' as SettingsTab, label: 'Notifications', icon: Bell },
  { id: 'admins' as SettingsTab, label: 'Admin Users', icon: Users },
  { id: 'system' as SettingsTab, label: 'System', icon: Database },
];

export function SettingsContent() {
  const [activeTab, setActiveTab] = useState<SettingsTab>('profile');

  return (
    <div className="flex gap-6">
      {/* Sidebar */}
      <Card className="w-64 shrink-0 h-fit">
        <CardContent className="p-2">
          <nav className="space-y-1">
            {tabs.map((tab) => {
              const Icon = tab.icon;
              return (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={cn(
                    'flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm font-medium transition-colors',
                    activeTab === tab.id
                      ? 'bg-silentid-purple-50 text-silentid-purple'
                      : 'text-gray-600 hover:bg-gray-100 hover:text-gray-900'
                  )}
                >
                  <Icon className="h-4 w-4" />
                  {tab.label}
                </button>
              );
            })}
          </nav>
        </CardContent>
      </Card>

      {/* Content */}
      <div className="flex-1 space-y-6">
        {activeTab === 'profile' && <ProfileSettings />}
        {activeTab === 'security' && <SecuritySettings />}
        {activeTab === 'notifications' && <NotificationSettings />}
        {activeTab === 'admins' && <AdminSettings />}
        {activeTab === 'system' && <SystemSettings />}
      </div>
    </div>
  );
}

function ProfileSettings() {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Profile Settings</CardTitle>
      </CardHeader>
      <CardContent className="space-y-6">
        <div className="flex items-center gap-6">
          <div className="flex h-20 w-20 items-center justify-center rounded-full bg-silentid-purple text-white text-2xl font-semibold">
            SA
          </div>
          <div>
            <Button variant="secondary" size="sm">
              Change Avatar
            </Button>
          </div>
        </div>

        <div className="grid gap-4 md:grid-cols-2">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Display Name
            </label>
            <input
              type="text"
              defaultValue="Super Admin"
              className="input"
            />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Email
            </label>
            <input
              type="email"
              defaultValue="admin@silentid.io"
              className="input"
              disabled
            />
          </div>
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Role
          </label>
          <Badge variant="purple" className="text-sm">SuperAdmin</Badge>
        </div>

        <div className="pt-4 border-t border-admin-border">
          <Button>Save Changes</Button>
        </div>
      </CardContent>
    </Card>
  );
}

function SecuritySettings() {
  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>Authentication</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div className="flex items-center gap-3">
              <Key className="h-5 w-5 text-gray-400" />
              <div>
                <p className="font-medium text-gray-900">Passkey</p>
                <p className="text-sm text-gray-500">Use biometric or hardware key</p>
              </div>
            </div>
            <Badge variant="success">Configured</Badge>
          </div>

          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div className="flex items-center gap-3">
              <Shield className="h-5 w-5 text-gray-400" />
              <div>
                <p className="font-medium text-gray-900">Two-Factor Authentication</p>
                <p className="text-sm text-gray-500">Additional security layer</p>
              </div>
            </div>
            <Button variant="secondary" size="sm">Enable</Button>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Active Sessions</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
              <div>
                <p className="font-medium text-gray-900">Current Session</p>
                <p className="text-sm text-gray-500">Windows - Chrome - London, UK</p>
                <p className="text-xs text-gray-400">Started 2 hours ago</p>
              </div>
              <Badge variant="success">Active</Badge>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}

function NotificationSettings() {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Notification Preferences</CardTitle>
      </CardHeader>
      <CardContent className="space-y-6">
        {[
          { label: 'Critical risk alerts', description: 'Immediate notification for critical security events', enabled: true },
          { label: 'High-risk user flags', description: 'When users are flagged for review', enabled: true },
          { label: 'Platform health warnings', description: 'Selector success rate drops below threshold', enabled: true },
          { label: 'Daily summary', description: 'End-of-day activity summary', enabled: false },
          { label: 'Weekly reports', description: 'Weekly analytics and trends', enabled: true },
        ].map((item) => (
          <div key={item.label} className="flex items-center justify-between">
            <div>
              <p className="font-medium text-gray-900">{item.label}</p>
              <p className="text-sm text-gray-500">{item.description}</p>
            </div>
            <label className="relative inline-flex items-center cursor-pointer">
              <input
                type="checkbox"
                defaultChecked={item.enabled}
                className="sr-only peer"
              />
              <div className="w-11 h-6 bg-gray-200 peer-focus:ring-2 peer-focus:ring-silentid-purple rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-silentid-purple"></div>
            </label>
          </div>
        ))}

        <div className="pt-4 border-t border-admin-border">
          <Button>Save Preferences</Button>
        </div>
      </CardContent>
    </Card>
  );
}

function AdminSettings() {
  const admins = [
    { name: 'Super Admin', email: 'admin@silentid.io', role: 'SuperAdmin', status: 'Active' },
    { name: 'John Smith', email: 'j.smith@silentid.io', role: 'SecurityAnalyst', status: 'Active' },
    { name: 'Sarah Wilson', email: 's.wilson@silentid.io', role: 'TrustAnalyst', status: 'Active' },
    { name: 'Mike Chen', email: 'm.chen@silentid.io', role: 'Support', status: 'Inactive' },
  ];

  return (
    <Card>
      <CardHeader>
        <CardTitle>Admin Users</CardTitle>
        <Button size="sm" icon={<Users className="h-4 w-4" />}>
          Invite Admin
        </Button>
      </CardHeader>
      <div className="table-container">
        <table className="table">
          <thead>
            <tr>
              <th>Admin</th>
              <th>Role</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {admins.map((admin) => (
              <tr key={admin.email}>
                <td>
                  <div>
                    <p className="font-medium text-gray-900">{admin.name}</p>
                    <p className="text-sm text-gray-500">{admin.email}</p>
                  </div>
                </td>
                <td>
                  <Badge variant="purple">{admin.role}</Badge>
                </td>
                <td>
                  <Badge variant={admin.status === 'Active' ? 'success' : 'default'}>
                    {admin.status}
                  </Badge>
                </td>
                <td>
                  <Button variant="ghost" size="sm">Edit</Button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </Card>
  );
}

function SystemSettings() {
  return (
    <div className="space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>API Configuration</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div className="flex items-center gap-3">
              <Globe className="h-5 w-5 text-gray-400" />
              <div>
                <p className="font-medium text-gray-900">Backend API URL</p>
                <p className="text-sm text-gray-500 font-mono">https://localhost:7001</p>
              </div>
            </div>
            <Badge variant="success">Connected</Badge>
          </div>

          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div className="flex items-center gap-3">
              <Clock className="h-5 w-5 text-gray-400" />
              <div>
                <p className="font-medium text-gray-900">Session Timeout</p>
                <p className="text-sm text-gray-500">30 minutes of inactivity</p>
              </div>
            </div>
            <Button variant="secondary" size="sm">Configure</Button>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>System Health</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid gap-4 md:grid-cols-3">
            <div className="p-4 bg-status-success-light rounded-lg text-center">
              <p className="text-2xl font-semibold text-status-success">99.9%</p>
              <p className="text-sm text-gray-600">API Uptime</p>
            </div>
            <div className="p-4 bg-status-info-light rounded-lg text-center">
              <p className="text-2xl font-semibold text-status-info">45ms</p>
              <p className="text-sm text-gray-600">Avg Response</p>
            </div>
            <div className="p-4 bg-status-success-light rounded-lg text-center">
              <p className="text-2xl font-semibold text-status-success">Healthy</p>
              <p className="text-sm text-gray-600">Database</p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
