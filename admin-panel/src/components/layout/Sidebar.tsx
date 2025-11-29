'use client';

import { usePathname } from 'next/navigation';
import Link from 'next/link';
import {
  LayoutDashboard,
  Users,
  FileCheck,
  Shield,
  BarChart3,
  Settings,
  Globe,
  AlertTriangle,
  LogOut,
} from 'lucide-react';
import { cn } from '@/lib/utils';

interface NavItem {
  label: string;
  href: string;
  icon: React.ComponentType<{ className?: string }>;
  badge?: number;
  children?: Omit<NavItem, 'children'>[];
}

const navigation: NavItem[] = [
  {
    label: 'Dashboard',
    href: '/dashboard',
    icon: LayoutDashboard,
  },
  {
    label: 'Users',
    href: '/dashboard/users',
    icon: Users,
  },
  {
    label: 'Evidence',
    href: '/dashboard/evidence',
    icon: FileCheck,
  },
  {
    label: 'Platforms',
    href: '/dashboard/platforms',
    icon: Globe,
  },
  {
    label: 'Reports',
    href: '/dashboard/reports',
    icon: AlertTriangle,
  },
  {
    label: 'Analytics',
    href: '/dashboard/analytics',
    icon: BarChart3,
  },
  {
    label: 'Settings',
    href: '/dashboard/settings',
    icon: Settings,
  },
];

export function Sidebar() {
  const pathname = usePathname();

  return (
    <aside className="fixed left-0 top-0 z-40 h-screen w-64 bg-white border-r border-admin-border">
      {/* Logo */}
      <div className="flex h-16 items-center gap-2 border-b border-admin-border px-6">
        <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-silentid-purple">
          <Shield className="h-5 w-5 text-white" />
        </div>
        <div>
          <span className="text-lg font-semibold text-gray-900">SilentID</span>
          <span className="ml-1.5 text-xs font-medium text-gray-400">Admin</span>
        </div>
      </div>

      {/* Navigation */}
      <nav className="flex flex-col gap-1 p-4">
        {navigation.map((item) => {
          const isActive =
            pathname === item.href ||
            (item.href !== '/dashboard' && pathname.startsWith(item.href));
          const Icon = item.icon;

          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                isActive ? 'nav-item-active' : 'nav-item'
              )}
            >
              <Icon className="h-5 w-5" />
              <span>{item.label}</span>
              {item.badge !== undefined && item.badge > 0 && (
                <span className="ml-auto flex h-5 min-w-5 items-center justify-center rounded-full bg-status-danger text-xs font-medium text-white">
                  {item.badge > 99 ? '99+' : item.badge}
                </span>
              )}
            </Link>
          );
        })}
      </nav>

      {/* User Section */}
      <div className="absolute bottom-0 left-0 right-0 border-t border-admin-border p-4">
        <div className="flex items-center gap-3">
          <div className="flex h-9 w-9 items-center justify-center rounded-full bg-silentid-purple-50 text-silentid-purple font-medium text-sm">
            SA
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-sm font-medium text-gray-900 truncate">
              Super Admin
            </p>
            <p className="text-xs text-gray-500 truncate">
              admin@silentid.io
            </p>
          </div>
          <button
            className="p-1.5 text-gray-400 hover:text-gray-600 rounded-lg hover:bg-gray-100 transition-colors"
            title="Sign out"
          >
            <LogOut className="h-4 w-4" />
          </button>
        </div>
      </div>
    </aside>
  );
}
