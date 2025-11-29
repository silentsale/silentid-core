import { Metadata } from 'next';
import { Header } from '@/components/layout';
import { SupportContent } from './SupportContent';

export const metadata: Metadata = {
  title: 'Support Tickets',
};

export default function SupportPage() {
  return (
    <>
      <Header
        title="Support Tickets"
        subtitle="Manage user support requests and inquiries"
      />
      <div className="p-6">
        <SupportContent />
      </div>
    </>
  );
}
