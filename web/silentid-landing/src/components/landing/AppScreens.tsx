'use client';

import { motion } from 'framer-motion';

/**
 * SVG-based app screen illustrations
 * These represent real Flutter app screens in a web-friendly format
 */

// Horror Stats Screen (Onboarding Page 1)
export function HorrorStatsScreen() {
  return (
    <div className="w-full h-full bg-white flex flex-col">
      {/* Status bar placeholder */}
      <div className="h-12 bg-white" />

      {/* Content */}
      <div className="flex-1 px-6 pt-8 pb-4">
        {/* Warning icon */}
        <motion.div
          className="w-20 h-20 mx-auto mb-6 rounded-full bg-red-100 flex items-center justify-center"
          initial={{ scale: 0.8 }}
          animate={{ scale: [0.8, 1.1, 1] }}
          transition={{ duration: 0.6 }}
        >
          <svg className="w-10 h-10 text-red-500" fill="currentColor" viewBox="0 0 20 20">
            <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
          </svg>
        </motion.div>

        {/* Title */}
        <h2 className="text-xl font-bold text-center text-neutral-900 mb-2">
          Your Stars Can Vanish
        </h2>
        <p className="text-sm text-center text-red-500 font-medium mb-6">
          The Hidden Risk
        </p>

        {/* Stats */}
        <div className="bg-red-50 rounded-xl p-4 space-y-3 border border-red-100">
          {[
            { value: '50K+', label: 'Vinted accounts banned in 2024' },
            { value: '3.2 yrs', label: 'Average feedback history lost' },
            { value: '89%', label: 'Never recover their ratings' },
          ].map((stat, i) => (
            <motion.div
              key={i}
              className="flex items-center gap-3"
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.3 + i * 0.15 }}
            >
              <div className="w-8 h-8 rounded-lg bg-red-100 flex items-center justify-center">
                <svg className="w-4 h-4 text-red-500" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M13.477 14.89A6 6 0 015.11 6.524l8.367 8.368zm1.414-1.414L6.524 5.11a6 6 0 018.367 8.367zM18 10a8 8 0 11-16 0 8 8 0 0116 0z" clipRule="evenodd" />
                </svg>
              </div>
              <div>
                <div className="text-lg font-bold text-red-600">{stat.value}</div>
                <div className="text-xs text-neutral-600">{stat.label}</div>
              </div>
            </motion.div>
          ))}
        </div>
      </div>

      {/* Bottom button */}
      <div className="px-6 pb-8">
        <div className="w-full h-12 bg-[#5A3EB8] rounded-xl flex items-center justify-center">
          <span className="text-white font-medium text-sm">Continue</span>
        </div>
      </div>
    </div>
  );
}

// TrustScore Screen
export function TrustScoreScreen() {
  return (
    <div className="w-full h-full bg-white flex flex-col">
      <div className="h-12 bg-white" />

      <div className="flex-1 px-5 pt-4">
        {/* Header */}
        <div className="text-center mb-4">
          <h2 className="text-lg font-bold text-neutral-900">Your TrustScore</h2>
          <p className="text-xs text-neutral-500">Updated weekly</p>
        </div>

        {/* Score card */}
        <motion.div
          className="bg-gradient-to-br from-[#5A3EB8] to-[#462F8F] rounded-2xl p-5 mb-4 shadow-lg"
          initial={{ scale: 0.95, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ duration: 0.5 }}
        >
          <div className="text-center">
            <motion.div
              className="text-5xl font-bold text-white mb-1"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.3 }}
            >
              754
            </motion.div>
            <div className="text-sm text-white/80">Very High Trust</div>
            <div className="mt-3 inline-flex items-center gap-1 bg-white/20 px-3 py-1 rounded-full">
              <svg className="w-3 h-3 text-amber-300" fill="currentColor" viewBox="0 0 20 20">
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
              </svg>
              <span className="text-xs text-white font-medium">4.8 combined rating</span>
            </div>
          </div>
        </motion.div>

        {/* Components */}
        <div className="space-y-2">
          {[
            { name: 'Identity', score: 250, max: 300, color: 'bg-green-500' },
            { name: 'Profiles', score: 320, max: 400, color: 'bg-[#5A3EB8]' },
            { name: 'Behaviour', score: 184, max: 300, color: 'bg-amber-500' },
          ].map((component, i) => (
            <div key={i} className="bg-neutral-50 rounded-xl p-3">
              <div className="flex justify-between text-sm mb-1.5">
                <span className="font-medium text-neutral-700">{component.name}</span>
                <span className="text-neutral-500">{component.score}/{component.max}</span>
              </div>
              <div className="h-2 bg-neutral-200 rounded-full overflow-hidden">
                <motion.div
                  className={`h-full ${component.color} rounded-full`}
                  initial={{ width: 0 }}
                  animate={{ width: `${(component.score / component.max) * 100}%` }}
                  transition={{ delay: 0.5 + i * 0.1, duration: 0.6 }}
                />
              </div>
            </div>
          ))}
        </div>

        {/* Connected platforms */}
        <div className="mt-4 pt-4 border-t border-neutral-100">
          <div className="text-xs text-neutral-500 mb-2">Connected Platforms</div>
          <div className="flex gap-2">
            {['V', 'e', 'D', 'I', 'T'].map((initial, i) => (
              <div
                key={i}
                className="w-8 h-8 rounded-lg bg-neutral-100 flex items-center justify-center text-xs font-bold text-neutral-600"
              >
                {initial}
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

// Connect Profiles Screen
export function ConnectProfilesScreen() {
  return (
    <div className="w-full h-full bg-white flex flex-col">
      <div className="h-12 bg-white" />

      <div className="flex-1 px-5 pt-4">
        <h2 className="text-lg font-bold text-neutral-900 mb-1">Connect Profiles</h2>
        <p className="text-xs text-neutral-500 mb-5">Link your accounts to build trust</p>

        {/* Platform list */}
        <div className="space-y-2">
          {[
            { name: 'Vinted', rating: '4.9', reviews: '127', color: 'bg-teal-500', verified: true },
            { name: 'eBay', rating: '4.8', reviews: '89', color: 'bg-red-500', verified: true },
            { name: 'Depop', rating: '5.0', reviews: '43', color: 'bg-red-400', verified: true },
            { name: 'Instagram', followers: '2.4K', color: 'bg-pink-500', verified: false },
            { name: 'TikTok', followers: '12K', color: 'bg-black', verified: false },
          ].map((platform, i) => (
            <motion.div
              key={i}
              className="flex items-center gap-3 p-3 bg-neutral-50 rounded-xl"
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.1 }}
            >
              <div className={`w-10 h-10 ${platform.color} rounded-xl flex items-center justify-center text-white font-bold text-sm`}>
                {platform.name[0]}
              </div>
              <div className="flex-1">
                <div className="flex items-center gap-1.5">
                  <span className="font-medium text-sm text-neutral-900">{platform.name}</span>
                  {platform.verified && (
                    <svg className="w-3.5 h-3.5 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                    </svg>
                  )}
                </div>
                <div className="text-xs text-neutral-500">
                  {platform.rating ? (
                    <span className="flex items-center gap-0.5">
                      <svg className="w-3 h-3 text-amber-400" fill="currentColor" viewBox="0 0 20 20">
                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                      </svg>
                      {platform.rating} ({platform.reviews} reviews)
                    </span>
                  ) : (
                    `${platform.followers} followers`
                  )}
                </div>
              </div>
              <span className={`text-xs px-2 py-1 rounded-full ${platform.verified ? 'bg-green-100 text-green-700' : 'bg-neutral-200 text-neutral-600'}`}>
                {platform.verified ? 'Verified' : 'Linked'}
              </span>
            </motion.div>
          ))}
        </div>

        {/* Add more button */}
        <button className="mt-4 w-full py-3 border-2 border-dashed border-neutral-300 rounded-xl text-sm font-medium text-neutral-500 hover:border-[#5A3EB8] hover:text-[#5A3EB8] transition-colors">
          + Add Another Profile
        </button>
      </div>
    </div>
  );
}

// Verified Badge Screen
export function VerifiedBadgeScreen() {
  return (
    <div className="w-full h-full bg-neutral-100 flex flex-col">
      <div className="h-12 bg-white" />

      <div className="flex-1 px-5 pt-4 flex flex-col items-center">
        <h2 className="text-lg font-bold text-neutral-900 mb-1">Your Verified Badge</h2>
        <p className="text-xs text-neutral-500 mb-5">Share anywhere to prove your trust</p>

        {/* Badge preview */}
        <motion.div
          className="w-56 bg-white rounded-2xl shadow-xl overflow-hidden"
          initial={{ scale: 0.9, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ duration: 0.5 }}
        >
          {/* Badge header */}
          <div className="bg-gradient-to-r from-[#5A3EB8] to-[#462F8F] p-3 flex items-center justify-center gap-2">
            <svg className="w-4 h-4 text-white" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
            </svg>
            <span className="text-white text-sm font-semibold">SilentID Verified</span>
          </div>

          {/* Badge content */}
          <div className="p-4 text-center">
            <div className="w-12 h-12 bg-[#5A3EB8]/10 rounded-full mx-auto mb-2 flex items-center justify-center">
              <span className="text-lg font-bold text-[#5A3EB8]">SM</span>
            </div>
            <div className="text-sm font-semibold text-neutral-900">@sarahm</div>
            <div className="flex items-center justify-center gap-1 mt-1 mb-3">
              <svg className="w-3 h-3 text-green-500" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
              </svg>
              <span className="text-xs text-green-600">ID Verified</span>
            </div>

            {/* Stats row */}
            <div className="flex justify-center gap-4 py-2 border-t border-neutral-100">
              <div className="text-center">
                <div className="text-lg font-bold text-amber-500">4.8</div>
                <div className="text-[10px] text-neutral-500">Rating</div>
              </div>
              <div className="w-px bg-neutral-200" />
              <div className="text-center">
                <div className="text-lg font-bold text-[#5A3EB8]">754</div>
                <div className="text-[10px] text-neutral-500">TrustScore</div>
              </div>
              <div className="w-px bg-neutral-200" />
              <div className="text-center">
                <div className="text-lg font-bold text-neutral-700">5</div>
                <div className="text-[10px] text-neutral-500">Platforms</div>
              </div>
            </div>

            {/* QR placeholder */}
            <div className="mt-3 w-16 h-16 mx-auto bg-neutral-100 rounded-lg flex items-center justify-center">
              <svg className="w-10 h-10 text-neutral-400" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M3 4a1 1 0 011-1h3a1 1 0 011 1v3a1 1 0 01-1 1H4a1 1 0 01-1-1V4zm2 2V5h1v1H5zM3 13a1 1 0 011-1h3a1 1 0 011 1v3a1 1 0 01-1 1H4a1 1 0 01-1-1v-3zm2 2v-1h1v1H5zM13 3a1 1 0 00-1 1v3a1 1 0 001 1h3a1 1 0 001-1V4a1 1 0 00-1-1h-3zm1 2v1h1V5h-1z" clipRule="evenodd" />
                <path d="M11 4a1 1 0 10-2 0v1a1 1 0 002 0V4zM10 7a1 1 0 011 1v1h2a1 1 0 110 2h-3a1 1 0 01-1-1V8a1 1 0 011-1zM16 9a1 1 0 100 2 1 1 0 000-2zM9 13a1 1 0 011-1h1a1 1 0 110 2v2a1 1 0 11-2 0v-3zM16 11a1 1 0 10-2 0v3a1 1 0 102 0v-3zM13 13a1 1 0 100 2h3a1 1 0 100-2h-3z" />
              </svg>
            </div>
            <div className="text-[10px] text-neutral-400 mt-1">Scan to verify</div>
          </div>
        </motion.div>

        {/* Action buttons */}
        <div className="flex gap-3 mt-6 w-full max-w-xs">
          <button className="flex-1 py-2.5 bg-[#5A3EB8] text-white text-sm font-medium rounded-xl">
            Share Badge
          </button>
          <button className="flex-1 py-2.5 bg-neutral-200 text-neutral-700 text-sm font-medium rounded-xl">
            Download
          </button>
        </div>
      </div>
    </div>
  );
}

// Trust Passport Screen (Public Profile)
export function TrustPassportScreen() {
  return (
    <div className="w-full h-full bg-gradient-to-b from-[#5A3EB8] to-[#462F8F] flex flex-col">
      <div className="h-12" />

      <div className="flex-1 px-5 pt-4">
        {/* Profile header */}
        <div className="text-center mb-6">
          <div className="w-20 h-20 bg-white/20 rounded-full mx-auto mb-3 flex items-center justify-center border-4 border-white/30">
            <span className="text-2xl font-bold text-white">SM</span>
          </div>
          <h2 className="text-xl font-bold text-white">Sarah M.</h2>
          <p className="text-sm text-white/70">@sarahm</p>
          <div className="inline-flex items-center gap-1.5 mt-2 bg-white/20 px-3 py-1 rounded-full">
            <svg className="w-3.5 h-3.5 text-green-400" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
            </svg>
            <span className="text-xs text-white font-medium">Identity Verified</span>
          </div>
        </div>

        {/* Score card */}
        <div className="bg-white rounded-2xl p-4 shadow-lg mb-4">
          <div className="flex items-center justify-between mb-3">
            <div>
              <div className="text-3xl font-bold text-[#5A3EB8]">754</div>
              <div className="text-xs text-neutral-500">TrustScore</div>
            </div>
            <div className="text-right">
              <div className="flex items-center gap-1">
                {[1, 2, 3, 4, 5].map((star) => (
                  <svg key={star} className={`w-4 h-4 ${star <= 4 ? 'text-amber-400' : 'text-amber-200'}`} fill="currentColor" viewBox="0 0 20 20">
                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                  </svg>
                ))}
              </div>
              <div className="text-xs text-neutral-500 mt-0.5">4.8 from 5 platforms</div>
            </div>
          </div>

          {/* Platforms */}
          <div className="flex gap-2 flex-wrap">
            {['Vinted', 'eBay', 'Depop', 'Instagram', 'TikTok'].map((platform, i) => (
              <span key={i} className="text-xs px-2 py-1 bg-neutral-100 rounded-full text-neutral-600">
                {platform}
              </span>
            ))}
          </div>
        </div>

        {/* Verified on */}
        <div className="text-center text-xs text-white/60">
          Member since 2023 · 0 disputes
        </div>
      </div>
    </div>
  );
}
