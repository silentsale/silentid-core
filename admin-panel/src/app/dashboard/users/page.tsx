import { Metadata } from 'next';
import { Header } from '@/components/layout';
import { UsersContent } from './UsersContent';

export const metadata: Metadata = {
  title: 'Users Management',
};

export default function UsersPage() {
  return (
    <>
      <Header
        title="Users Management"
        subtitle="Search, view, and manage SilentID users"
      />
      <div className="p-6">
        <UsersContent />
      </div>
    </>
  );
}
