import { Metadata } from 'next';
import { Header } from '@/components/layout';
import { DashboardContent } from './DashboardContent';

export const metadata: Metadata = {
  title: 'Dashboard',
};

export default function DashboardPage() {
  return (
    <>
      <Header
        title="Dashboard"
        subtitle="Overview of SilentID system health and metrics"
      />
      <div className="p-6">
        <DashboardContent />
      </div>
    </>
  );
}
