/**
 * Help Center Category Page
 * Displays all articles in a category
 */

import Link from 'next/link';
import { notFound } from 'next/navigation';
import type { Metadata } from 'next';
import { helpCategories, getCategoryBySlug } from '@/lib/help-data';

interface PageProps {
  params: Promise<{ category: string }>;
}

export async function generateStaticParams() {
  return helpCategories.map((category) => ({
    category: category.slug,
  }));
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { category: categorySlug } = await params;
  const category = getCategoryBySlug(categorySlug);

  if (!category) {
    return {
      title: 'Category Not Found | SilentID Help Center',
    };
  }

  return {
    title: `${category.title} | SilentID Help Center`,
    description: category.description,
  };
}

export default async function CategoryPage({ params }: PageProps) {
  const { category: categorySlug } = await params;
  const category = getCategoryBySlug(categorySlug);

  if (!category) {
    notFound();
  }

  return (
    <div className="min-h-screen bg-neutral-50">
      {/* Header */}
      <header className="bg-gradient-to-br from-[#5A3EB8] to-[#462F8F] text-white py-12">
        <div className="container mx-auto px-6 max-w-4xl">
          {/* Breadcrumb */}
          <nav className="flex items-center gap-2 text-sm text-white/70 mb-4">
            <Link href="/" className="hover:text-white transition-colors">
              Home
            </Link>
            <span>/</span>
            <Link href="/help" className="hover:text-white transition-colors">
              Help Center
            </Link>
            <span>/</span>
            <span className="text-white">{category.title}</span>
          </nav>

          <h1 className="text-3xl md:text-4xl font-bold mb-2">{category.title}</h1>
          <p className="text-lg text-white/80">{category.description}</p>
          <p className="text-sm text-white/60 mt-2">
            {category.articles.length} articles
          </p>
        </div>
      </header>

      <main className="container mx-auto px-6 max-w-4xl py-12">
        {/* Articles List */}
        <div className="space-y-4">
          {category.articles.map((article, index) => (
            <Link
              key={article.id}
              href={`/help/${category.slug}/${article.slug}`}
              className="block bg-white rounded-xl p-6 border border-neutral-200 hover:border-[#5A3EB8] hover:shadow-md transition-all group"
            >
              <div className="flex items-start gap-4">
                <div className="w-8 h-8 rounded-lg bg-neutral-100 text-neutral-500 flex items-center justify-center flex-shrink-0 group-hover:bg-[#5A3EB8] group-hover:text-white transition-colors">
                  <span className="text-sm font-semibold">{index + 1}</span>
                </div>
                <div className="flex-1 min-w-0">
                  <h2 className="font-semibold text-neutral-900 mb-1 group-hover:text-[#5A3EB8] transition-colors">
                    {article.title}
                  </h2>
                  <p className="text-sm text-neutral-600 line-clamp-2">
                    {article.summary}
                  </p>
                  {article.screenPath && (
                    <p className="text-xs text-neutral-400 mt-2">
                      Path: {article.screenPath}
                    </p>
                  )}
                </div>
                <svg
                  className="w-5 h-5 text-neutral-400 group-hover:text-[#5A3EB8] transition-colors flex-shrink-0"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M9 5l7 7-7 7"
                  />
                </svg>
              </div>
            </Link>
          ))}
        </div>

        {/* Back to Help Center */}
        <div className="mt-12 text-center">
          <Link
            href="/help"
            className="inline-flex items-center gap-2 text-[#5A3EB8] hover:underline"
          >
            <svg
              className="w-4 h-4"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M10 19l-7-7m0 0l7-7m-7 7h18"
              />
            </svg>
            Back to Help Center
          </Link>
        </div>
      </main>
    </div>
  );
}
