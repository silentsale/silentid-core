'use client';

import { Card, CardHeader, CardTitle, CardContent, StatCard } from '@/components/ui';
import { Users, TrendingUp, Shield, FileCheck } from 'lucide-react';

// Placeholder for charts - would use recharts in production
const PlaceholderChart = ({ title, height = 200 }: { title: string; height?: number }) => (
  <div
    className="flex items-center justify-center bg-gray-50 rounded-lg border-2 border-dashed border-gray-200"
    style={{ height }}
  >
    <p className="text-gray-400 text-sm">{title} Chart</p>
  </div>
);

export function AnalyticsContent() {
  return (
    <div className="space-y-6">
      {/* Key Metrics */}
      <div className="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-4">
        <StatCard
          title="User Growth"
          value="+12.5%"
          change={12.5}
          changeLabel="vs last month"
          icon={<Users className="h-6 w-6" />}
          iconColor="bg-silentid-purple-50 text-silentid-purple"
        />
        <StatCard
          title="Avg Trust Score"
          value="687"
          change={3.2}
          changeLabel="vs last month"
          icon={<TrendingUp className="h-6 w-6" />}
          iconColor="bg-status-success-light text-status-success"
        />
        <StatCard
          title="Verification Rate"
          value="78%"
          change={5.1}
          changeLabel="vs last month"
          icon={<Shield className="h-6 w-6" />}
          iconColor="bg-status-info-light text-status-info"
        />
        <StatCard
          title="Evidence Submissions"
          value="1,234"
          change={-2.3}
          changeLabel="vs last week"
          icon={<FileCheck className="h-6 w-6" />}
          iconColor="bg-status-warning-light text-status-warning"
        />
      </div>

      {/* Charts Row 1 */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>User Registrations Over Time</CardTitle>
          </CardHeader>
          <CardContent>
            <PlaceholderChart title="Line" height={300} />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Trust Score Distribution</CardTitle>
          </CardHeader>
          <CardContent>
            <PlaceholderChart title="Bar" height={300} />
          </CardContent>
        </Card>
      </div>

      {/* Charts Row 2 */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-3">
        <Card>
          <CardHeader>
            <CardTitle>Verification Levels</CardTitle>
          </CardHeader>
          <CardContent>
            <PlaceholderChart title="Pie" height={250} />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Evidence by Type</CardTitle>
          </CardHeader>
          <CardContent>
            <PlaceholderChart title="Donut" height={250} />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Platform Usage</CardTitle>
          </CardHeader>
          <CardContent>
            <PlaceholderChart title="Horizontal Bar" height={250} />
          </CardContent>
        </Card>
      </div>

      {/* Activity Table */}
      <Card>
        <CardHeader>
          <CardTitle>Recent Activity Summary</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="table-container">
            <table className="table">
              <thead>
                <tr>
                  <th>Metric</th>
                  <th>Today</th>
                  <th>Yesterday</th>
                  <th>This Week</th>
                  <th>This Month</th>
                  <th>Trend</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td className="font-medium">New Registrations</td>
                  <td>156</td>
                  <td>142</td>
                  <td>1,023</td>
                  <td>4,521</td>
                  <td className="text-status-success">+9.8%</td>
                </tr>
                <tr>
                  <td className="font-medium">Verifications Completed</td>
                  <td>89</td>
                  <td>76</td>
                  <td>612</td>
                  <td>2,845</td>
                  <td className="text-status-success">+17.1%</td>
                </tr>
                <tr>
                  <td className="font-medium">Evidence Submitted</td>
                  <td>342</td>
                  <td>298</td>
                  <td>2,156</td>
                  <td>9,234</td>
                  <td className="text-status-success">+14.7%</td>
                </tr>
                <tr>
                                  <tr>
                  <td className="font-medium">Share Imports</td>
                  <td>67</td>
                  <td>54</td>
                  <td>412</td>
                  <td>1,823</td>
                  <td className="text-status-success">+24.0%</td>
                </tr>
                <td className="font-medium">Risk Alerts Generated</td>
                  <td>23</td>
                  <td>31</td>
                  <td>178</td>
                  <td>645</td>
                  <td className="text-status-danger">-25.8%</td>
                </tr>
                <tr>
                  <td className="font-medium">Avg Session Duration</td>
                  <td>4m 32s</td>
                  <td>4m 18s</td>
                  <td>4m 25s</td>
                  <td>4m 12s</td>
                  <td className="text-status-success">+3.2%</td>
                </tr>
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
