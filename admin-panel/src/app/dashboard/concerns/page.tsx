import { Metadata } from 'next';
import { Header } from '@/components/layout';
import { ConcernsContent } from './ConcernsContent';

export const metadata: Metadata = {
  title: 'Profile Concerns',
};

export default function ConcernsPage() {
  return (
    <>
      <Header
        title="Profile Concerns"
        subtitle="Review user concerns about public profiles"
      />
      <div className="p-6">
        <ConcernsContent />
      </div>
    </>
  );
}
