/**
 * Cookie Policy Page
 * Source: CLAUDE.md Section 45 (Cookie & Tracking Policy)
 * Version: 1.8.0
 */

import Link from 'next/link';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Cookie Policy | SilentID',
  description: 'Cookie and tracking policy for SilentID - minimal, privacy-focused approach',
};

export default function CookiesPage() {
  return (
    <div className="min-h-screen bg-white">
      {/* Header */}
      <header className="bg-neutral-900 text-white py-16">
        <div className="container mx-auto px-6 max-w-4xl">
          <Link
            href="/"
            className="inline-flex items-center gap-2 text-neutral-300 hover:text-white transition-colors mb-6"
          >
            <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            Back to Home
          </Link>
          <h1 className="text-4xl md:text-5xl font-bold mb-4">Cookie Policy</h1>
          <p className="text-xl text-neutral-300">How We Use Cookies</p>
          <p className="text-sm text-neutral-400 mt-4">
            <strong>Effective Date:</strong> 23 November 2025<br />
            <strong>Version:</strong> 1.0
          </p>
        </div>
      </header>

      {/* Content */}
      <main className="container mx-auto px-6 max-w-4xl py-12">
        <div className="prose prose-lg max-w-none">
          {/* Introduction */}
          <section className="mb-12">
            <p className="text-lg text-neutral-700 leading-relaxed">
              This Cookie Policy explains how <strong>SILENTSALE LTD</strong> (Company No. 16457502) uses cookies and similar tracking technologies on the SilentID website and application.
            </p>
            <div className="bg-success-light/30 border-l-4 border-success p-4 mt-6 rounded">
              <p className="text-neutral-800 font-medium">
                ✅ <strong>SilentID uses minimal cookies.</strong> We prioritise your privacy and only use essential cookies for security and functionality.
              </p>
            </div>
          </section>

          {/* Table of Contents */}
          <section className="bg-neutral-50 p-8 rounded-xl mb-12 border border-neutral-200">
            <h2 className="text-2xl font-bold text-neutral-black mb-6">Contents</h2>
            <ol className="space-y-2 text-neutral-700">
              <li><a href="#what-are-cookies" className="text-primary hover:underline">1. What Are Cookies?</a></li>
              <li><a href="#cookies-we-use" className="text-primary hover:underline">2. Cookies We Use</a></li>
              <li><a href="#essential-cookies" className="text-primary hover:underline">3. Essential Cookies</a></li>
              <li><a href="#no-tracking" className="text-primary hover:underline">4. What We Don&apos;t Use</a></li>
              <li><a href="#control" className="text-primary hover:underline">5. How to Control Cookies</a></li>
              <li><a href="#updates" className="text-primary hover:underline">6. Changes to This Policy</a></li>
              <li><a href="#contact" className="text-primary hover:underline">7. Contact Us</a></li>
            </ol>
          </section>

          {/* Section 1: What Are Cookies */}
          <section id="what-are-cookies" className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">1. WHAT ARE COOKIES?</h2>
            <p className="text-neutral-700">
              Cookies are small text files stored on your device when you visit a website. They help websites remember your preferences and provide essential functionality.
            </p>
            <p className="text-neutral-700 mt-4">
              Cookies can be:
            </p>
            <ul className="list-disc pl-6 space-y-2 text-neutral-700 mt-2">
              <li><strong>Session cookies:</strong> Temporary cookies that expire when you close your browser</li>
              <li><strong>Persistent cookies:</strong> Cookies that remain on your device for a set period</li>
              <li><strong>First-party cookies:</strong> Set by the website you&apos;re visiting (SilentID)</li>
              <li><strong>Third-party cookies:</strong> Set by external services (we minimise these)</li>
            </ul>
          </section>

          {/* Section 2: Cookies We Use */}
          <section id="cookies-we-use" className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">2. COOKIES WE USE</h2>

            <div className="overflow-x-auto mt-6">
              <table className="min-w-full bg-white border border-neutral-200 rounded-lg">
                <thead className="bg-neutral-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-sm font-semibold text-neutral-800 border-b">Cookie Name</th>
                    <th className="px-6 py-3 text-left text-sm font-semibold text-neutral-800 border-b">Type</th>
                    <th className="px-6 py-3 text-left text-sm font-semibold text-neutral-800 border-b">Purpose</th>
                    <th className="px-6 py-3 text-left text-sm font-semibold text-neutral-800 border-b">Duration</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-neutral-200">
                  <tr>
                    <td className="px-6 py-4 text-sm text-neutral-700">silentid_session</td>
                    <td className="px-6 py-4 text-sm text-neutral-700">Essential</td>
                    <td className="px-6 py-4 text-sm text-neutral-700">Maintains your login session</td>
                    <td className="px-6 py-4 text-sm text-neutral-700">2 hours</td>
                  </tr>
                  <tr>
                    <td className="px-6 py-4 text-sm text-neutral-700">silentid_auth</td>
                    <td className="px-6 py-4 text-sm text-neutral-700">Essential</td>
                    <td className="px-6 py-4 text-sm text-neutral-700">Authentication token</td>
                    <td className="px-6 py-4 text-sm text-neutral-700">7 days</td>
                  </tr>
                  <tr>
                    <td className="px-6 py-4 text-sm text-neutral-700">silentid_preferences</td>
                    <td className="px-6 py-4 text-sm text-neutral-700">Functional</td>
                    <td className="px-6 py-4 text-sm text-neutral-700">Remembers your settings (theme, language)</td>
                    <td className="px-6 py-4 text-sm text-neutral-700">1 year</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>

          {/* Section 3: Essential Cookies */}
          <section id="essential-cookies" className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">3. ESSENTIAL COOKIES</h2>
            <p className="text-neutral-700">
              Essential cookies are necessary for the website to function properly. These cookies:
            </p>
            <ul className="list-disc pl-6 space-y-2 text-neutral-700 mt-4">
              <li>Enable you to log in and stay logged in</li>
              <li>Protect your account security</li>
              <li>Remember your authentication state</li>
              <li>Prevent fraud and abuse</li>
            </ul>
            <div className="bg-amber-50 border-l-4 border-warning p-4 mt-6 rounded">
              <p className="text-neutral-800">
                <strong>Note:</strong> Essential cookies cannot be disabled without affecting core functionality. Without them, you would not be able to use SilentID.
              </p>
            </div>
          </section>

          {/* Section 4: What We Don't Use */}
          <section id="no-tracking" className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">4. WHAT WE DON&apos;T USE</h2>
            <div className="bg-primary-light/30 border-2 border-primary/30 rounded-xl p-6">
              <h3 className="text-xl font-bold text-primary mb-4">We Do NOT Use:</h3>
              <ul className="space-y-3 text-neutral-800">
                <li className="flex items-start gap-2">
                  <span className="text-danger font-bold">❌</span>
                  <span><strong>Advertising Cookies:</strong> We do not track you for advertising purposes</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="text-danger font-bold">❌</span>
                  <span><strong>Social Media Tracking:</strong> No Facebook Pixel, Twitter tracking, or similar tools</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="text-danger font-bold">❌</span>
                  <span><strong>Cross-Site Tracking:</strong> We do not track your activity on other websites</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="text-danger font-bold">❌</span>
                  <span><strong>Analytics Cookies:</strong> No Google Analytics or similar third-party analytics (we use privacy-focused, anonymised analytics only)</span>
                </li>
              </ul>
            </div>
          </section>

          {/* Section 5: How to Control Cookies */}
          <section id="control" className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">5. HOW TO CONTROL COOKIES</h2>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">5.1 Browser Settings</h3>
            <p className="text-neutral-700">
              You can control and delete cookies through your browser settings. Here&apos;s how:
            </p>
            <ul className="list-disc pl-6 space-y-2 text-neutral-700 mt-4">
              <li><strong>Chrome:</strong> Settings → Privacy and security → Cookies and other site data</li>
              <li><strong>Firefox:</strong> Settings → Privacy & Security → Cookies and Site Data</li>
              <li><strong>Safari:</strong> Preferences → Privacy → Manage Website Data</li>
              <li><strong>Edge:</strong> Settings → Cookies and site permissions → Cookies and site data</li>
            </ul>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">5.2 Impact of Disabling Cookies</h3>
            <p className="text-neutral-700">
              If you disable essential cookies:
            </p>
            <ul className="list-disc pl-6 space-y-2 text-neutral-700 mt-2">
              <li>You will not be able to log in to SilentID</li>
              <li>Your session will not persist between visits</li>
              <li>Security features will not function properly</li>
            </ul>
            <p className="text-neutral-700 mt-4">
              We recommend keeping essential cookies enabled for the best experience.
            </p>
          </section>

          {/* Section 6: Updates */}
          <section id="updates" className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">6. CHANGES TO THIS POLICY</h2>
            <p className="text-neutral-700">
              We may update this Cookie Policy from time to time. When we make changes:
            </p>
            <ul className="list-disc pl-6 space-y-2 text-neutral-700 mt-4">
              <li>We will update the &quot;Effective Date&quot; at the top of this page</li>
              <li>We will notify you via email if changes are significant</li>
              <li>Continued use of SilentID means you accept the updated policy</li>
            </ul>
          </section>

          {/* Contact Section */}
          <section id="contact" className="mt-16 bg-neutral-50 p-8 rounded-xl border border-neutral-200">
            <h2 className="text-2xl font-bold text-neutral-black mb-4">7. CONTACT US</h2>
            <p className="text-neutral-700 mb-4">
              If you have questions about our use of cookies:
            </p>
            <ul className="space-y-2 text-neutral-700">
              <li><strong>Email:</strong> <a href="mailto:privacy@silentid.co.uk" className="text-primary hover:underline">privacy@silentid.co.uk</a></li>
              <li><strong>Data Protection Officer:</strong> <a href="mailto:dpo@silentid.co.uk" className="text-primary hover:underline">dpo@silentid.co.uk</a></li>
              <li><strong>Company:</strong> SILENTSALE LTD, Company No. 16457502</li>
            </ul>
          </section>

          {/* Note */}
          <div className="mt-12 text-sm text-neutral-500 text-center">
            <p>
              This Cookie Policy is part of our Privacy Policy. For more information about how we handle your data, see our <Link href="/privacy" className="text-primary hover:underline">Privacy Policy</Link>.<br />
              Last Updated: 23 November 2025 | Version 1.0
            </p>
          </div>
        </div>
      </main>
    </div>
  );
}
