import { Metadata } from 'next';
import { Header } from '@/components/layout';
import { EvidenceContent } from './EvidenceContent';

export const metadata: Metadata = {
  title: 'Evidence Management',
};

export default function EvidencePage() {
  return (
    <>
      <Header
        title="Evidence Management"
        subtitle="Review and manage user evidence submissions"
      />
      <div className="p-6">
        <EvidenceContent />
      </div>
    </>
  );
}
