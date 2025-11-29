import { Metadata } from 'next';
import { Header } from '@/components/layout';
import { AnalyticsContent } from './AnalyticsContent';

export const metadata: Metadata = {
  title: 'Analytics',
};

export default function AnalyticsPage() {
  return (
    <>
      <Header
        title="Analytics"
        subtitle="System metrics and performance insights"
      />
      <div className="p-6">
        <AnalyticsContent />
      </div>
    </>
  );
}
