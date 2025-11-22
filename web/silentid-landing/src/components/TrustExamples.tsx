/**
 * TrustScore Examples - Real user profiles from backend
 * Shows anonymized examples of high-trust users
 */

import { fetchTrustScoreExamples } from '@/lib/api';

export default async function TrustExamples() {
  const examples = await fetchTrustScoreExamples();

  return (
    <section className="bg-neutral-50 section-padding">
      <div className="container-custom">
        <div className="text-center space-y-4 mb-16">
          <h2>Real TrustScore Examples</h2>
          <p className="text-xl text-neutral-700 max-w-3xl mx-auto">
            See how real people build trust across platforms
          </p>
        </div>

        <div className="grid md:grid-cols-3 gap-8 max-w-5xl mx-auto">
          {examples.map((profile, index) => (
            <div
              key={index}
              className="bg-white rounded-2xl p-8 border-2 border-neutral-300 hover:border-primary/40 hover:shadow-xl transition-all duration-300"
            >
              {/* Profile Header */}
              <div className="flex items-center gap-4 mb-6">
                <div className="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center">
                  <span className="text-2xl font-bold text-primary">
                    {profile.displayName.charAt(0)}
                  </span>
                </div>
                <div>
                  <div className="font-semibold text-lg text-neutral-black">
                    {profile.displayName}
                  </div>
                  <div className="text-sm text-neutral-700">
                    {profile.username}
                  </div>
                </div>
              </div>

              {/* TrustScore */}
              <div className="mb-6 p-6 bg-gradient-to-br from-primary-light to-white rounded-lg border border-primary/20">
                <div className="text-center space-y-2">
                  <div className="text-5xl font-bold text-primary">
                    {profile.trustScore}
                  </div>
                  <div className="inline-block px-4 py-2 bg-success/20 text-success rounded-full text-sm font-semibold">
                    {profile.trustLevel}
                  </div>
                </div>
              </div>

              {/* Badges */}
              <div className="flex flex-wrap gap-2 justify-center">
                {profile.badgeCount >= 1 && (
                  <div className="px-3 py-1 bg-primary/10 text-primary rounded-full text-xs font-medium">
                    ✓ ID Verified
                  </div>
                )}
                {profile.badgeCount >= 2 && (
                  <div className="px-3 py-1 bg-success/10 text-success rounded-full text-xs font-medium">
                    ✓ Email Verified
                  </div>
                )}
                {profile.badgeCount >= 3 && (
                  <div className="px-3 py-1 bg-primary/10 text-primary rounded-full text-xs font-medium">
                    ✓ 100+ Transactions
                  </div>
                )}
                {profile.badgeCount >= 4 && (
                  <div className="px-3 py-1 bg-success/10 text-success rounded-full text-xs font-medium">
                    ✓ Peer Verified
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>

        {/* CTA */}
        <div className="mt-12 text-center">
          <button className="btn-primary text-lg">
            Build Your Trust Passport
          </button>
          <p className="mt-4 text-sm text-neutral-700">
            Join {examples.length}+ verified users building portable trust
          </p>
        </div>
      </div>
    </section>
  );
}
