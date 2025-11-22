/**
 * Stats Section - Live statistics from SilentID backend
 * Automatically updates when backend data changes
 */

import { fetchLandingStats } from '@/lib/api';

export default async function Stats() {
  const stats = await fetchLandingStats();

  return (
    <section className="bg-primary text-white section-padding">
      <div className="container-custom">
        <div className="text-center space-y-4 mb-12">
          <h2 className="text-white">Trusted by Real People</h2>
          <p className="text-xl text-primary-light max-w-3xl mx-auto">
            Join thousands building their digital trust passport
          </p>
        </div>

        <div className="grid grid-cols-2 md:grid-cols-4 gap-8 max-w-5xl mx-auto">
          {/* Total Users */}
          <div className="text-center space-y-2">
            <div className="text-5xl md:text-6xl font-bold">
              {stats.totalUsers.toLocaleString()}+
            </div>
            <div className="text-primary-light text-lg">
              Total Users
            </div>
          </div>

          {/* Verified Users */}
          <div className="text-center space-y-2">
            <div className="text-5xl md:text-6xl font-bold">
              {stats.verifiedUsers.toLocaleString()}+
            </div>
            <div className="text-primary-light text-lg">
              Verified Identities
            </div>
          </div>

          {/* Transactions */}
          <div className="text-center space-y-2">
            <div className="text-5xl md:text-6xl font-bold">
              {stats.totalTransactions.toLocaleString()}+
            </div>
            <div className="text-primary-light text-lg">
              Verified Transactions
            </div>
          </div>

          {/* Average TrustScore */}
          <div className="text-center space-y-2">
            <div className="text-5xl md:text-6xl font-bold">
              {stats.averageTrustScore}
            </div>
            <div className="text-primary-light text-lg">
              Average TrustScore
            </div>
          </div>
        </div>

        {/* Platforms Supported */}
        <div className="mt-12 text-center">
          <p className="text-lg text-primary-light">
            Works across <span className="font-bold text-white">{stats.platformsSupported}+ platforms</span> including Vinted, eBay, Depop, Etsy, and more
          </p>
        </div>
      </div>
    </section>
  );
}
