import { cn } from '@/lib/utils';
import { TrendingUp, TrendingDown, Minus } from 'lucide-react';

interface StatCardProps {
  title: string;
  value: string | number;
  change?: number;
  changeLabel?: string;
  icon?: React.ReactNode;
  iconColor?: string;
  className?: string;
}

export function StatCard({
  title,
  value,
  change,
  changeLabel,
  icon,
  iconColor = 'bg-silentid-purple-50 text-silentid-purple',
  className,
}: StatCardProps) {
  const isPositive = change !== undefined && change > 0;
  const isNegative = change !== undefined && change < 0;
  const isNeutral = change === 0;

  return (
    <div
      className={cn(
        'rounded-xl border border-admin-border bg-white p-6',
        className
      )}
    >
      <div className="flex items-start justify-between">
        <div>
          <p className="text-sm font-medium text-gray-500">{title}</p>
          <p className="mt-2 text-3xl font-semibold text-gray-900">{value}</p>

          {change !== undefined && (
            <div className="mt-2 flex items-center gap-1">
              {isPositive && (
                <TrendingUp className="h-4 w-4 text-status-success" />
              )}
              {isNegative && (
                <TrendingDown className="h-4 w-4 text-status-danger" />
              )}
              {isNeutral && (
                <Minus className="h-4 w-4 text-gray-400" />
              )}
              <span
                className={cn(
                  'text-sm font-medium',
                  isPositive && 'text-status-success',
                  isNegative && 'text-status-danger',
                  isNeutral && 'text-gray-500'
                )}
              >
                {isPositive && '+'}
                {change}%
              </span>
              {changeLabel && (
                <span className="text-sm text-gray-500">{changeLabel}</span>
              )}
            </div>
          )}
        </div>

        {icon && (
          <div
            className={cn(
              'flex h-12 w-12 items-center justify-center rounded-xl',
              iconColor
            )}
          >
            {icon}
          </div>
        )}
      </div>
    </div>
  );
}
