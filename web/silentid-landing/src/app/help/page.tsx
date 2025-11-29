/**
 * Help Center Index Page
 * Displays all categories and popular articles
 */

import Link from 'next/link';
import type { Metadata } from 'next';
import { helpCategories, helpArticles } from '@/lib/help-data';
import HelpSearch from '@/components/help/HelpSearch';

export const metadata: Metadata = {
  title: 'Help Center | SilentID',
  description: 'Find answers to your questions about SilentID - passwordless authentication, TrustScore, profile linking, evidence vault, and more.',
};

const categoryIcons: Record<string, React.ReactNode> = {
  rocket: (
    <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
    </svg>
  ),
  shield: (
    <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
    </svg>
  ),
  chart: (
    <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
    </svg>
  ),
  link: (
    <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
    </svg>
  ),
  folder: (
    <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
    </svg>
  ),
  share: (
    <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z" />
    </svg>
  ),
  lock: (
    <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
    </svg>
  ),
  help: (
    <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>
  ),
};

// Popular articles to feature
const popularArticleSlugs = [
  { categorySlug: 'getting-started', articleSlug: 'what-is-silentid' },
  { categorySlug: 'trustscore', articleSlug: 'how-it-works' },
  { categorySlug: 'trustscore', articleSlug: 'improving-score' },
  { categorySlug: 'profile-linking', articleSlug: 'linked-vs-verified' },
  { categorySlug: 'login-security', articleSlug: 'passwordless-explained' },
  { categorySlug: 'evidence', articleSlug: 'email-forwarding' },
];

const popularArticles = popularArticleSlugs
  .map(({ categorySlug, articleSlug }) =>
    helpArticles.find(
      (a) => a.categorySlug === categorySlug && a.slug === articleSlug
    )
  )
  .filter(Boolean);

export default function HelpCenterPage() {
  return (
    <div className="min-h-screen bg-neutral-50">
      {/* Header */}
      <header className="bg-gradient-to-br from-[#5A3EB8] to-[#462F8F] text-white py-16">
        <div className="container mx-auto px-6 max-w-5xl">
          <Link
            href="/"
            className="inline-flex items-center gap-2 text-white/80 hover:text-white transition-colors mb-6"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            Back to Home
          </Link>
          <h1 className="text-4xl md:text-5xl font-bold mb-4">Help Center</h1>
          <p className="text-xl text-white/80 mb-8">
            Find answers to your questions about SilentID
          </p>

          {/* Search */}
          <HelpSearch />
        </div>
      </header>

      <main className="container mx-auto px-6 max-w-5xl py-12">
        {/* Categories Grid */}
        <section className="mb-16">
          <h2 className="text-2xl font-bold text-neutral-900 mb-6">Browse by Category</h2>
          <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-4">
            {helpCategories.map((category) => (
              <Link
                key={category.id}
                href={`/help/${category.slug}`}
                className="group bg-white rounded-xl p-6 border border-neutral-200 hover:border-[#5A3EB8] hover:shadow-lg transition-all"
              >
                <div className="w-12 h-12 rounded-xl bg-[#5A3EB8]/10 text-[#5A3EB8] flex items-center justify-center mb-4 group-hover:bg-[#5A3EB8] group-hover:text-white transition-colors">
                  {categoryIcons[category.icon]}
                </div>
                <h3 className="font-semibold text-neutral-900 mb-1 group-hover:text-[#5A3EB8] transition-colors">
                  {category.title}
                </h3>
                <p className="text-sm text-neutral-600 mb-2">{category.description}</p>
                <span className="text-xs text-neutral-500">
                  {category.articles.length} articles
                </span>
              </Link>
            ))}
          </div>
        </section>

        {/* Popular Articles */}
        <section className="mb-16">
          <h2 className="text-2xl font-bold text-neutral-900 mb-6">Popular Articles</h2>
          <div className="grid md:grid-cols-2 gap-4">
            {popularArticles.map((article) => (
              article && (
                <Link
                  key={article.id}
                  href={`/help/${article.categorySlug}/${article.slug}`}
                  className="bg-white rounded-xl p-6 border border-neutral-200 hover:border-[#5A3EB8] hover:shadow-md transition-all"
                >
                  <div className="flex items-start gap-4">
                    <div className="w-10 h-10 rounded-lg bg-neutral-100 text-neutral-600 flex items-center justify-center flex-shrink-0">
                      <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                      </svg>
                    </div>
                    <div>
                      <h3 className="font-semibold text-neutral-900 mb-1 hover:text-[#5A3EB8] transition-colors">
                        {article.title}
                      </h3>
                      <p className="text-sm text-neutral-600 line-clamp-2">
                        {article.summary}
                      </p>
                      <span className="text-xs text-[#5A3EB8] mt-2 inline-block">
                        {article.category}
                      </span>
                    </div>
                  </div>
                </Link>
              )
            ))}
          </div>
        </section>

        {/* Quick Links */}
        <section className="bg-white rounded-xl p-8 border border-neutral-200">
          <h2 className="text-xl font-bold text-neutral-900 mb-6">Quick Links</h2>
          <div className="grid md:grid-cols-3 gap-6">
            <div>
              <h3 className="font-semibold text-neutral-800 mb-3">Getting Started</h3>
              <ul className="space-y-2">
                {helpCategories[0].articles.slice(0, 4).map((article) => (
                  <li key={article.id}>
                    <Link
                      href={`/help/${article.categorySlug}/${article.slug}`}
                      className="text-sm text-neutral-600 hover:text-[#5A3EB8] transition-colors"
                    >
                      {article.title}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
            <div>
              <h3 className="font-semibold text-neutral-800 mb-3">TrustScore</h3>
              <ul className="space-y-2">
                {helpCategories[2].articles.slice(0, 4).map((article) => (
                  <li key={article.id}>
                    <Link
                      href={`/help/${article.categorySlug}/${article.slug}`}
                      className="text-sm text-neutral-600 hover:text-[#5A3EB8] transition-colors"
                    >
                      {article.title}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
            <div>
              <h3 className="font-semibold text-neutral-800 mb-3">Troubleshooting</h3>
              <ul className="space-y-2">
                {helpCategories[7].articles.slice(0, 4).map((article) => (
                  <li key={article.id}>
                    <Link
                      href={`/help/${article.categorySlug}/${article.slug}`}
                      className="text-sm text-neutral-600 hover:text-[#5A3EB8] transition-colors"
                    >
                      {article.title}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </section>

        {/* Contact Support */}
        <section className="mt-12 text-center">
          <h2 className="text-xl font-bold text-neutral-900 mb-2">Still need help?</h2>
          <p className="text-neutral-600 mb-4">
            Can&apos;t find what you&apos;re looking for? Our support team is here to help.
          </p>
          <a
            href="mailto:support@silentid.co.uk"
            className="inline-flex items-center gap-2 bg-[#5A3EB8] text-white px-6 py-3 rounded-lg font-semibold hover:bg-[#462F8F] transition-colors"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
            Contact Support
          </a>
        </section>
      </main>
    </div>
  );
}
