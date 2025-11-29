'use client';

import { useState } from 'react';
import {
  Search,
  Bell,
  ChevronDown,
  Settings,
  User,
  LogOut,
  X,
} from 'lucide-react';
import { cn } from '@/lib/utils';

interface HeaderProps {
  title?: string;
  subtitle?: string;
}

export function Header({ title, subtitle }: HeaderProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [showNotifications, setShowNotifications] = useState(false);
  const [showUserMenu, setShowUserMenu] = useState(false);

  // Mock notifications - replace with real data
  const notifications = [
    {
      id: '1',
      title: 'High-risk user detected',
      message: 'User #12345 flagged for suspicious activity',
      time: '5 min ago',
      unread: true,
    },
    {
      id: '2',
      title: 'Platform selector failing',
      message: 'Vinted username selector at 45% success rate',
      time: '1 hour ago',
      unread: true,
    },
    {
      id: '3',
      title: 'Evidence review pending',
      message: '23 new evidence items awaiting review',
      time: '2 hours ago',
      unread: false,
    },
  ];

  const unreadCount = notifications.filter((n) => n.unread).length;

  return (
    <header className="sticky top-0 z-30 flex h-16 items-center justify-between border-b border-admin-border bg-white px-6">
      {/* Title Section */}
      <div className="flex items-center gap-4">
        {title && (
          <div>
            <h1 className="text-xl font-semibold text-gray-900">{title}</h1>
            {subtitle && (
              <p className="text-sm text-gray-500">{subtitle}</p>
            )}
          </div>
        )}
      </div>

      {/* Right Section */}
      <div className="flex items-center gap-4">
        {/* Search */}
        <div className="relative">
          <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" />
          <input
            type="text"
            placeholder="Search users, evidence..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="h-9 w-64 rounded-lg border border-admin-border bg-gray-50 pl-9 pr-4 text-sm focus:border-silentid-purple focus:bg-white focus:outline-none focus:ring-1 focus:ring-silentid-purple"
          />
          {searchQuery && (
            <button
              onClick={() => setSearchQuery('')}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
            >
              <X className="h-4 w-4" />
            </button>
          )}
        </div>

        {/* Notifications */}
        <div className="relative">
          <button
            onClick={() => {
              setShowNotifications(!showNotifications);
              setShowUserMenu(false);
            }}
            className={cn(
              'relative flex h-9 w-9 items-center justify-center rounded-lg transition-colors',
              showNotifications
                ? 'bg-silentid-purple-50 text-silentid-purple'
                : 'text-gray-500 hover:bg-gray-100 hover:text-gray-700'
            )}
          >
            <Bell className="h-5 w-5" />
            {unreadCount > 0 && (
              <span className="absolute right-1 top-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-status-danger text-[10px] font-medium text-white">
                {unreadCount}
              </span>
            )}
          </button>

          {/* Notifications Dropdown */}
          {showNotifications && (
            <div className="absolute right-0 top-full mt-2 w-80 rounded-xl border border-admin-border bg-white shadow-modal animate-fade-in">
              <div className="flex items-center justify-between border-b border-admin-border px-4 py-3">
                <h3 className="font-medium text-gray-900">Notifications</h3>
                <button className="text-xs text-silentid-purple hover:text-silentid-purple-dark">
                  Mark all read
                </button>
              </div>
              <div className="max-h-80 overflow-y-auto">
                {notifications.map((notification) => (
                  <div
                    key={notification.id}
                    className={cn(
                      'flex gap-3 border-b border-admin-border px-4 py-3 last:border-b-0 hover:bg-gray-50 cursor-pointer',
                      notification.unread && 'bg-silentid-purple-50/30'
                    )}
                  >
                    {notification.unread && (
                      <div className="mt-1.5 h-2 w-2 flex-shrink-0 rounded-full bg-silentid-purple" />
                    )}
                    <div className={cn(!notification.unread && 'ml-5')}>
                      <p className="text-sm font-medium text-gray-900">
                        {notification.title}
                      </p>
                      <p className="text-sm text-gray-500">
                        {notification.message}
                      </p>
                      <p className="mt-1 text-xs text-gray-400">
                        {notification.time}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
              <div className="border-t border-admin-border p-2">
                <button className="w-full rounded-lg py-2 text-sm font-medium text-silentid-purple hover:bg-silentid-purple-50">
                  View all notifications
                </button>
              </div>
            </div>
          )}
        </div>

        {/* User Menu */}
        <div className="relative">
          <button
            onClick={() => {
              setShowUserMenu(!showUserMenu);
              setShowNotifications(false);
            }}
            className={cn(
              'flex items-center gap-2 rounded-lg px-2 py-1.5 transition-colors',
              showUserMenu
                ? 'bg-silentid-purple-50'
                : 'hover:bg-gray-100'
            )}
          >
            <div className="flex h-7 w-7 items-center justify-center rounded-full bg-silentid-purple text-white text-xs font-medium">
              SA
            </div>
            <ChevronDown
              className={cn(
                'h-4 w-4 text-gray-500 transition-transform',
                showUserMenu && 'rotate-180'
              )}
            />
          </button>

          {/* User Dropdown */}
          {showUserMenu && (
            <div className="absolute right-0 top-full mt-2 w-56 rounded-xl border border-admin-border bg-white shadow-modal animate-fade-in">
              <div className="border-b border-admin-border p-4">
                <p className="font-medium text-gray-900">Super Admin</p>
                <p className="text-sm text-gray-500">admin@silentid.io</p>
                <span className="mt-2 inline-flex rounded-full bg-silentid-purple-50 px-2 py-0.5 text-xs font-medium text-silentid-purple">
                  SuperAdmin
                </span>
              </div>
              <div className="p-2">
                <button className="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm text-gray-700 hover:bg-gray-100">
                  <User className="h-4 w-4" />
                  Profile
                </button>
                <button className="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm text-gray-700 hover:bg-gray-100">
                  <Settings className="h-4 w-4" />
                  Settings
                </button>
              </div>
              <div className="border-t border-admin-border p-2">
                <button className="flex w-full items-center gap-3 rounded-lg px-3 py-2 text-sm text-status-danger hover:bg-status-danger-light">
                  <LogOut className="h-4 w-4" />
                  Sign out
                </button>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Click outside handler */}
      {(showNotifications || showUserMenu) && (
        <div
          className="fixed inset-0 z-[-1]"
          onClick={() => {
            setShowNotifications(false);
            setShowUserMenu(false);
          }}
        />
      )}
    </header>
  );
}
