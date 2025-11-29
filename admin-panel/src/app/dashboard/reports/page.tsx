import { Metadata } from 'next';
import { Header } from '@/components/layout';
import { ReportsContent } from './ReportsContent';

export const metadata: Metadata = {
  title: 'Security Reports',
};

export default function ReportsPage() {
  return (
    <>
      <Header
        title="Security Reports"
        subtitle="Monitor risk alerts and security incidents"
      />
      <div className="p-6">
        <ReportsContent />
      </div>
    </>
  );
}
