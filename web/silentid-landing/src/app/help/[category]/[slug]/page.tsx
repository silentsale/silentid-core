/**
 * Help Center Article Page
 * Displays a single help article with markdown content
 */

import Link from 'next/link';
import { notFound } from 'next/navigation';
import type { Metadata } from 'next';
import {
  helpArticles,
  helpCategories,
  getArticleBySlug,
  getCategoryBySlug,
  getRelatedArticles,
} from '@/lib/help-data';

interface PageProps {
  params: Promise<{ category: string; slug: string }>;
}

export async function generateStaticParams() {
  return helpArticles.map((article) => ({
    category: article.categorySlug,
    slug: article.slug,
  }));
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { category, slug } = await params;
  const article = getArticleBySlug(category, slug);

  if (!article) {
    return {
      title: 'Article Not Found | SilentID Help Center',
    };
  }

  return {
    title: `${article.title} | SilentID Help Center`,
    description: article.summary,
  };
}

// Simple markdown-like rendering
function renderContent(content: string) {
  const lines = content.split('\n');
  const elements: React.ReactNode[] = [];
  let inList = false;
  let listItems: string[] = [];
  let inTable = false;
  let tableRows: string[][] = [];

  const flushList = () => {
    if (listItems.length > 0) {
      elements.push(
        <ul key={`list-${elements.length}`} className="list-disc pl-6 space-y-1 text-neutral-700 mb-4">
          {listItems.map((item, i) => (
            <li key={i}>{item}</li>
          ))}
        </ul>
      );
      listItems = [];
    }
    inList = false;
  };

  const flushTable = () => {
    if (tableRows.length > 0) {
      elements.push(
        <div key={`table-${elements.length}`} className="overflow-x-auto mb-4">
          <table className="min-w-full border border-neutral-200 rounded-lg">
            <thead className="bg-neutral-50">
              <tr>
                {tableRows[0]?.map((cell, i) => (
                  <th key={i} className="px-4 py-2 text-left text-sm font-semibold text-neutral-700 border-b">
                    {cell}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {tableRows.slice(2).map((row, i) => (
                <tr key={i} className={i % 2 === 0 ? 'bg-white' : 'bg-neutral-50'}>
                  {row.map((cell, j) => (
                    <td key={j} className="px-4 py-2 text-sm text-neutral-600 border-b">
                      {cell}
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      );
      tableRows = [];
    }
    inTable = false;
  };

  lines.forEach((line, index) => {
    const trimmed = line.trim();

    // Tables
    if (trimmed.startsWith('|') && trimmed.endsWith('|')) {
      if (!inList) flushList();
      inTable = true;
      const cells = trimmed.split('|').filter(Boolean).map(c => c.trim());
      tableRows.push(cells);
      return;
    } else if (inTable) {
      flushTable();
    }

    // Headers
    if (trimmed.startsWith('## ')) {
      flushList();
      elements.push(
        <h2 key={index} className="text-xl font-bold text-neutral-900 mt-8 mb-4">
          {trimmed.replace('## ', '')}
        </h2>
      );
      return;
    }

    if (trimmed.startsWith('### ')) {
      flushList();
      elements.push(
        <h3 key={index} className="text-lg font-semibold text-neutral-800 mt-6 mb-3">
          {trimmed.replace('### ', '')}
        </h3>
      );
      return;
    }

    // Bold text handling
    const processBold = (text: string) => {
      const parts = text.split(/(\*\*[^*]+\*\*)/g);
      return parts.map((part, i) => {
        if (part.startsWith('**') && part.endsWith('**')) {
          return <strong key={i}>{part.slice(2, -2)}</strong>;
        }
        return part;
      });
    };

    // List items
    if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
      inList = true;
      listItems.push(trimmed.slice(2));
      return;
    }

    // Numbered list
    if (/^\d+\.\s/.test(trimmed)) {
      if (!inList || listItems.length === 0) {
        flushList();
      }
      // For numbered lists, we'll use ordered list
      const match = trimmed.match(/^\d+\.\s(.+)$/);
      if (match) {
        listItems.push(match[1]);
      }
      inList = true;
      return;
    }

    // Regular paragraph
    if (trimmed.length > 0) {
      flushList();
      elements.push(
        <p key={index} className="text-neutral-700 mb-4 leading-relaxed">
          {processBold(trimmed)}
        </p>
      );
    }
  });

  flushList();
  flushTable();

  return elements;
}

export default async function ArticlePage({ params }: PageProps) {
  const { category: categorySlug, slug } = await params;
  const article = getArticleBySlug(categorySlug, slug);
  const category = getCategoryBySlug(categorySlug);

  if (!article || !category) {
    notFound();
  }

  const relatedArticles = getRelatedArticles(article, 3);

  // Find prev/next articles in category
  const categoryArticles = category.articles;
  const currentIndex = categoryArticles.findIndex((a) => a.id === article.id);
  const prevArticle = currentIndex > 0 ? categoryArticles[currentIndex - 1] : null;
  const nextArticle =
    currentIndex < categoryArticles.length - 1
      ? categoryArticles[currentIndex + 1]
      : null;

  return (
    <div className="min-h-screen bg-neutral-50">
      {/* Header */}
      <header className="bg-white border-b border-neutral-200 py-6">
        <div className="container mx-auto px-6 max-w-4xl">
          {/* Breadcrumb */}
          <nav className="flex items-center gap-2 text-sm text-neutral-500 mb-4">
            <Link href="/" className="hover:text-[#5A3EB8] transition-colors">
              Home
            </Link>
            <span>/</span>
            <Link href="/help" className="hover:text-[#5A3EB8] transition-colors">
              Help Center
            </Link>
            <span>/</span>
            <Link
              href={`/help/${category.slug}`}
              className="hover:text-[#5A3EB8] transition-colors"
            >
              {category.title}
            </Link>
            <span>/</span>
            <span className="text-neutral-900">{article.title}</span>
          </nav>
        </div>
      </header>

      <main className="container mx-auto px-6 max-w-4xl py-8">
        <div className="grid lg:grid-cols-4 gap-8">
          {/* Main Content */}
          <article className="lg:col-span-3">
            <div className="bg-white rounded-xl p-8 border border-neutral-200">
              {/* Article Header */}
              <header className="mb-8 pb-6 border-b border-neutral-100">
                <div className="flex items-center gap-2 text-sm text-[#5A3EB8] mb-3">
                  <Link
                    href={`/help/${category.slug}`}
                    className="hover:underline"
                  >
                    {category.title}
                  </Link>
                </div>
                <h1 className="text-2xl md:text-3xl font-bold text-neutral-900 mb-3">
                  {article.title}
                </h1>
                <p className="text-lg text-neutral-600">{article.summary}</p>

                {/* Info Point Summary */}
                {article.infoPointSummary && (
                  <div className="mt-4 p-4 bg-[#5A3EB8]/5 border-l-4 border-[#5A3EB8] rounded-r-lg">
                    <p className="text-sm text-neutral-700">
                      <strong className="text-[#5A3EB8]">Quick Summary:</strong>{' '}
                      {article.infoPointSummary}
                    </p>
                  </div>
                )}

                {/* Screen Path */}
                {article.screenPath && (
                  <p className="text-sm text-neutral-500 mt-4">
                    <span className="font-medium">In the app:</span>{' '}
                    {article.screenPath}
                  </p>
                )}
              </header>

              {/* Article Content */}
              <div className="prose prose-neutral max-w-none">
                {renderContent(article.content)}
              </div>
            </div>

            {/* Prev/Next Navigation */}
            <div className="mt-6 grid grid-cols-2 gap-4">
              {prevArticle ? (
                <Link
                  href={`/help/${category.slug}/${prevArticle.slug}`}
                  className="bg-white rounded-xl p-4 border border-neutral-200 hover:border-[#5A3EB8] transition-colors group"
                >
                  <div className="text-sm text-neutral-500 mb-1">← Previous</div>
                  <div className="font-medium text-neutral-900 group-hover:text-[#5A3EB8] transition-colors line-clamp-1">
                    {prevArticle.title}
                  </div>
                </Link>
              ) : (
                <div />
              )}
              {nextArticle ? (
                <Link
                  href={`/help/${category.slug}/${nextArticle.slug}`}
                  className="bg-white rounded-xl p-4 border border-neutral-200 hover:border-[#5A3EB8] transition-colors group text-right"
                >
                  <div className="text-sm text-neutral-500 mb-1">Next →</div>
                  <div className="font-medium text-neutral-900 group-hover:text-[#5A3EB8] transition-colors line-clamp-1">
                    {nextArticle.title}
                  </div>
                </Link>
              ) : (
                <div />
              )}
            </div>
          </article>

          {/* Sidebar */}
          <aside className="lg:col-span-1">
            {/* Related Articles */}
            {relatedArticles.length > 0 && (
              <div className="bg-white rounded-xl p-6 border border-neutral-200 mb-6">
                <h3 className="font-semibold text-neutral-900 mb-4">
                  Related Articles
                </h3>
                <ul className="space-y-3">
                  {relatedArticles.map((related) => (
                    <li key={related.id}>
                      <Link
                        href={`/help/${related.categorySlug}/${related.slug}`}
                        className="text-sm text-neutral-600 hover:text-[#5A3EB8] transition-colors block"
                      >
                        {related.title}
                      </Link>
                    </li>
                  ))}
                </ul>
              </div>
            )}

            {/* Categories */}
            <div className="bg-white rounded-xl p-6 border border-neutral-200">
              <h3 className="font-semibold text-neutral-900 mb-4">Categories</h3>
              <ul className="space-y-2">
                {helpCategories.map((cat) => (
                  <li key={cat.id}>
                    <Link
                      href={`/help/${cat.slug}`}
                      className={`text-sm transition-colors block ${
                        cat.slug === category.slug
                          ? 'text-[#5A3EB8] font-medium'
                          : 'text-neutral-600 hover:text-[#5A3EB8]'
                      }`}
                    >
                      {cat.title}
                      <span className="text-neutral-400 ml-1">
                        ({cat.articles.length})
                      </span>
                    </Link>
                  </li>
                ))}
              </ul>
            </div>

            {/* Contact Support */}
            <div className="mt-6 bg-[#5A3EB8]/5 rounded-xl p-6 border border-[#5A3EB8]/20">
              <h3 className="font-semibold text-neutral-900 mb-2">
                Need more help?
              </h3>
              <p className="text-sm text-neutral-600 mb-4">
                Our support team is here to help.
              </p>
              <a
                href="mailto:support@silentid.co.uk"
                className="inline-flex items-center gap-2 text-sm text-[#5A3EB8] font-medium hover:underline"
              >
                Contact Support →
              </a>
            </div>
          </aside>
        </div>
      </main>
    </div>
  );
}
