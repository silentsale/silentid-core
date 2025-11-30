/**
 * Loading skeleton for public profile page
 */

export default function PublicProfileLoading() {
  return (
    <div className="min-h-screen bg-neutral-50">
      <main className="container mx-auto px-4 py-8 max-w-2xl">
        {/* Profile Card Skeleton */}
        <div className="bg-white rounded-2xl border border-neutral-200 overflow-hidden shadow-sm animate-pulse">
          {/* Header gradient placeholder */}
          <div className="h-24 bg-neutral-200" />

          {/* Profile Info */}
          <div className="px-6 pb-6">
            {/* Avatar skeleton */}
            <div className="relative -mt-12 mb-4">
              <div className="w-24 h-24 bg-neutral-200 rounded-full border-4 border-white" />
            </div>

            {/* Name & Username skeleton */}
            <div className="mb-6">
              <div className="h-8 w-40 bg-neutral-200 rounded mb-2" />
              <div className="h-5 w-28 bg-neutral-200 rounded" />
            </div>

            {/* TrustScore skeleton */}
            <div className="bg-neutral-50 rounded-xl p-6 mb-6">
              <div className="flex items-center justify-between mb-3">
                <div className="h-4 w-20 bg-neutral-200 rounded" />
                <div className="h-4 w-24 bg-neutral-200 rounded" />
              </div>
              <div className="flex items-end gap-2 mb-3">
                <div className="h-12 w-24 bg-neutral-200 rounded" />
              </div>
              <div className="h-3 bg-neutral-200 rounded-full" />
            </div>

            {/* Badges skeleton */}
            <div className="mb-6">
              <div className="h-4 w-16 bg-neutral-200 rounded mb-3" />
              <div className="flex flex-wrap gap-2">
                <div className="h-8 w-32 bg-neutral-200 rounded-full" />
                <div className="h-8 w-40 bg-neutral-200 rounded-full" />
                <div className="h-8 w-28 bg-neutral-200 rounded-full" />
              </div>
            </div>

            {/* Stats grid skeleton */}
            <div className="grid grid-cols-2 gap-4 mb-6">
              <div className="bg-neutral-50 rounded-xl p-4">
                <div className="h-8 w-16 bg-neutral-200 rounded mb-2" />
                <div className="h-4 w-32 bg-neutral-200 rounded" />
              </div>
              <div className="bg-neutral-50 rounded-xl p-4">
                <div className="h-8 w-20 bg-neutral-200 rounded mb-2" />
                <div className="h-4 w-24 bg-neutral-200 rounded" />
              </div>
            </div>

            {/* Platforms skeleton */}
            <div className="mb-6">
              <div className="h-4 w-20 bg-neutral-200 rounded mb-3" />
              <div className="flex flex-wrap gap-2">
                <div className="h-8 w-20 bg-neutral-200 rounded-lg" />
                <div className="h-8 w-16 bg-neutral-200 rounded-lg" />
                <div className="h-8 w-18 bg-neutral-200 rounded-lg" />
              </div>
            </div>
          </div>
        </div>

        {/* Branding skeleton */}
        <div className="mt-8 flex flex-col items-center">
          <div className="h-5 w-40 bg-neutral-200 rounded" />
          <div className="h-4 w-56 bg-neutral-200 rounded mt-2" />
        </div>
      </main>
    </div>
  );
}
