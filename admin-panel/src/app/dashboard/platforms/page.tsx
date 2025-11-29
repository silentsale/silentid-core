import { Metadata } from 'next';
import { Header } from '@/components/layout';
import { PlatformsContent } from './PlatformsContent';

export const metadata: Metadata = {
  title: 'Platform Configuration',
};

export default function PlatformsPage() {
  return (
    <>
      <Header
        title="Platform Configuration"
        subtitle="Manage platform selectors and verification methods (Section 48)"
      />
      <div className="p-6">
        <PlatformsContent />
      </div>
    </>
  );
}
