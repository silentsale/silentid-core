import { Metadata } from 'next';
import { Header } from '@/components/layout';
import { SettingsContent } from './SettingsContent';

export const metadata: Metadata = {
  title: 'Settings',
};

export default function SettingsPage() {
  return (
    <>
      <Header
        title="Settings"
        subtitle="System configuration and admin management"
      />
      <div className="p-6">
        <SettingsContent />
      </div>
    </>
  );
}
