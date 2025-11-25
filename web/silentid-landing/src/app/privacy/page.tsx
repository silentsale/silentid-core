/**
 * Privacy Policy Page
 * Source: CLAUDE.md Section 44 (Privacy Policy - UK GDPR-Aligned)
 * Version: 1.8.0
 */

import Link from 'next/link';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Privacy Policy | SilentID',
  description: 'Privacy Policy for SilentID - UK GDPR-aligned data protection practices',
};

export default function PrivacyPage() {
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
          <h1 className="text-4xl md:text-5xl font-bold mb-4">Privacy Policy</h1>
          <p className="text-xl text-neutral-300">UK GDPR-Aligned Data Protection</p>
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
              This Privacy Policy explains how <strong>SILENTSALE LTD</strong> (Company No. 16457502) (&quot;we,&quot; &quot;us,&quot; &quot;our&quot;) collects, uses, shares, and protects your personal data when you use SilentID.
            </p>
            <p className="text-lg text-neutral-700 leading-relaxed mt-4">
              We are committed to protecting your privacy and complying with the <strong>UK General Data Protection Regulation (UK GDPR)</strong> and the <strong>Data Protection Act 2018</strong>.
            </p>
            <div className="bg-primary-light/30 border-l-4 border-primary p-4 mt-6 rounded">
              <p className="text-neutral-800">
                <strong>ICO Registration:</strong> [To be inserted upon registration]
              </p>
            </div>
          </section>

          {/* Table of Contents */}
          <section className="bg-neutral-50 p-8 rounded-xl mb-12 border border-neutral-200">
            <h2 className="text-2xl font-bold text-neutral-black mb-6">Contents</h2>
            <ol className="space-y-2 text-neutral-700">
              <li><a href="#intro" className="text-primary hover:underline">1. Introduction</a></li>
              <li><a href="#data-collect" className="text-primary hover:underline">2. What Data We Collect</a></li>
              <li><a href="#legal-basis" className="text-primary hover:underline">3. Legal Basis for Processing</a></li>
              <li><a href="#data-use" className="text-primary hover:underline">4. How We Use Your Data</a></li>
              <li><a href="#data-share" className="text-primary hover:underline">5. Who We Share Data With</a></li>
              <li><a href="#retention" className="text-primary hover:underline">6. Data Retention</a></li>
              <li><a href="#rights" className="text-primary hover:underline">7. Your Rights Under UK GDPR</a></li>
              <li><a href="#security" className="text-primary hover:underline">8. Data Security</a></li>
              <li><a href="#cookies" className="text-primary hover:underline">9. Cookies & Tracking</a></li>
              <li><a href="#children" className="text-primary hover:underline">10. Children&apos;s Privacy</a></li>
              <li><a href="#transfers" className="text-primary hover:underline">11. International Data Transfers</a></li>
              <li><a href="#automated" className="text-primary hover:underline">12. Automated Decision-Making</a></li>
              <li><a href="#changes" className="text-primary hover:underline">13. Changes to This Policy</a></li>
              <li><a href="#complaints" className="text-primary hover:underline">14. Complaints</a></li>
              <li><a href="#contact" className="text-primary hover:underline">15. Contact Us</a></li>
            </ol>
          </section>

          {/* 2. What Data We Collect */}
          <section id="data-collect" className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">2. WHAT DATA WE COLLECT</h2>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">2.1 Account Information</h3>
            <ul className="list-disc pl-6 space-y-2 text-neutral-700">
              <li><strong>Email address</strong> (required)</li>
              <li><strong>Username</strong> (chosen by you, publicly visible)</li>
              <li><strong>Display name</strong> (e.g., &quot;Sarah M.&quot; - publicly visible)</li>
              <li><strong>Phone number</strong> (optional)</li>
              <li><strong>Date of Birth</strong> (from identity verification - NOT publicly visible)</li>
            </ul>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">2.2 Authentication Data</h3>
            <div className="bg-success-light/30 border-l-4 border-success p-4 rounded">
              <p className="text-neutral-800 font-medium">
                ✅ <strong>We do NOT store passwords. SilentID is 100% passwordless.</strong>
              </p>
            </div>
            <p className="text-neutral-700 mt-4">
              We store:
            </p>
            <ul className="list-disc pl-6 space-y-2 text-neutral-700 mt-2">
              <li>Passkey public keys (NOT biometric data)</li>
              <li>OAuth tokens from Apple/Google (securely encrypted)</li>
              <li>Email OTP verification timestamps (codes deleted after use)</li>
            </ul>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">2.3 Identity Verification Data (via Stripe)</h3>
            <div className="bg-amber-50 border-l-4 border-warning p-4 rounded">
              <p className="text-neutral-800">
                <strong>We store ONLY:</strong>
              </p>
              <ul className="list-disc pl-6 mt-2 text-neutral-700">
                <li>Stripe Verification Reference ID</li>
                <li>Verification Status (Verified, Pending, Failed)</li>
                <li>Timestamp of verification</li>
              </ul>
              <p className="text-neutral-800 mt-4 font-medium">
                ⚠️ <strong>ID documents and selfies are stored by Stripe, NOT by SilentID.</strong>
              </p>
            </div>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">2.4 Evidence Data</h3>
            <ul className="list-disc pl-6 space-y-2 text-neutral-700">
              <li><strong>Email receipts:</strong> Transaction summaries extracted (date, amount, platform)</li>
              <li><strong>Screenshots:</strong> Images + OCR text</li>
              <li><strong>Public profile links:</strong> Scraped data from marketplace profiles</li>
            </ul>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">2.5 Device & Usage Data</h3>
            <ul className="list-disc pl-6 space-y-2 text-neutral-700">
              <li>Device type, operating system, browser</li>
              <li>IP address (anonymized after 90 days)</li>
              <li>Login times and locations</li>
              <li>Feature usage patterns</li>
            </ul>
          </section>

          {/* 3. Legal Basis */}
          <section id="legal-basis" className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">3. LEGAL BASIS FOR PROCESSING</h2>
            <div className="overflow-x-auto">
              <table className="min-w-full bg-white border border-neutral-200 rounded-lg">
                <thead className="bg-neutral-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-sm font-semibold text-neutral-800 border-b">Data Type</th>
                    <th className="px-6 py-3 text-left text-sm font-semibold text-neutral-800 border-b">Lawful Basis</th>
                    <th className="px-6 py-3 text-left text-sm font-semibold text-neutral-800 border-b">Purpose</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-neutral-200">
                  <tr>
                    <td className="px-6 py-4 text-sm text-neutral-700">Account information</td>
                    <td className="px-6 py-4 text-sm text-neutral-700"><strong>Contract</strong> + Legitimate Interest</td>
                    <td className="px-6 py-4 text-sm text-neutral-700">Provide service, prevent fraud</td>
                  </tr>
                  <tr>
                    <td className="px-6 py-4 text-sm text-neutral-700">Authentication data</td>
                    <td className="px-6 py-4 text-sm text-neutral-700"><strong>Contract</strong></td>
                    <td className="px-6 py-4 text-sm text-neutral-700">Secure account access</td>
                  </tr>
                  <tr>
                    <td className="px-6 py-4 text-sm text-neutral-700">Identity verification</td>
                    <td className="px-6 py-4 text-sm text-neutral-700"><strong>Legitimate Interest</strong></td>
                    <td className="px-6 py-4 text-sm text-neutral-700">Prevent fake accounts, fraud</td>
                  </tr>
                  <tr>
                    <td className="px-6 py-4 text-sm text-neutral-700">Evidence (receipts, screenshots)</td>
                    <td className="px-6 py-4 text-sm text-neutral-700"><strong>Consent</strong> + Legitimate Interest</td>
                    <td className="px-6 py-4 text-sm text-neutral-700">Build TrustScore, fraud prevention</td>
                  </tr>
                  <tr>
                    <td className="px-6 py-4 text-sm text-neutral-700">Device & usage data</td>
                    <td className="px-6 py-4 text-sm text-neutral-700"><strong>Legitimate Interest</strong></td>
                    <td className="px-6 py-4 text-sm text-neutral-700">Security, fraud detection</td>
                  </tr>
                  <tr>
                    <td className="px-6 py-4 text-sm text-neutral-700">Payment data</td>
                    <td className="px-6 py-4 text-sm text-neutral-700"><strong>Contract</strong></td>
                    <td className="px-6 py-4 text-sm text-neutral-700">Process subscriptions</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </section>

          {/* 6. Data Retention */}
          <section id="retention" className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">6. DATA RETENTION</h2>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">6.1 While Your Account Is Active</h3>
            <p className="text-neutral-700">
              We retain your data as long as your account is active and for the purposes described in this policy.
            </p>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">6.2 After Account Deletion</h3>
            <ul className="list-disc pl-6 space-y-2 text-neutral-700">
              <li><strong>Most data:</strong> Deleted within <strong>30 days</strong></li>
              <li><strong>Anonymised fraud logs:</strong> Retained for <strong>7 years</strong> (UK legal requirement for fraud prevention)</li>
              <li><strong>Financial records (Stripe):</strong> Retained for <strong>7 years</strong> (UK tax law requirement)</li>
            </ul>
          </section>

          {/* 7. Your Rights */}
          <section id="rights" className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">7. YOUR RIGHTS UNDER UK GDPR</h2>
            <div className="bg-primary-light/30 border-2 border-primary/30 rounded-xl p-6">
              <h3 className="text-xl font-bold text-primary mb-4">You Have the Right To:</h3>
              <div className="space-y-4 text-neutral-800">
                <div>
                  <h4 className="font-semibold">✅ Right of Access</h4>
                  <p className="text-sm">Request a copy of all personal data we hold about you.</p>
                </div>
                <div>
                  <h4 className="font-semibold">✅ Right to Rectification</h4>
                  <p className="text-sm">Correct inaccurate or incomplete data.</p>
                </div>
                <div>
                  <h4 className="font-semibold">✅ Right to Erasure (&quot;Right to be Forgotten&quot;)</h4>
                  <p className="text-sm">Request deletion of your data. We will delete it within 30 days.</p>
                </div>
                <div>
                  <h4 className="font-semibold">✅ Right to Restriction</h4>
                  <p className="text-sm">Limit how we use your data.</p>
                </div>
                <div>
                  <h4 className="font-semibold">✅ Right to Data Portability</h4>
                  <p className="text-sm">Receive your data in a machine-readable format.</p>
                </div>
                <div>
                  <h4 className="font-semibold">✅ Right to Object</h4>
                  <p className="text-sm">Object to processing based on legitimate interests or for direct marketing.</p>
                </div>
                <div>
                  <h4 className="font-semibold">✅ Right to Withdraw Consent</h4>
                  <p className="text-sm">Withdraw consent at any time (e.g., stop email receipt scanning).</p>
                </div>
              </div>
            </div>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">7.8 How to Exercise Your Rights</h3>
            <p className="text-neutral-700">
              <strong>Email:</strong> <a href="mailto:privacy@silentid.co.uk" className="text-primary hover:underline">privacy@silentid.co.uk</a><br />
              <strong>In-app:</strong> Settings → Privacy → Request My Data
            </p>
            <p className="text-neutral-700 mt-2">
              We will respond within <strong>30 days</strong>.
            </p>
          </section>

          {/* Contact Section */}
          <section id="contact" className="mt-16 bg-neutral-50 p-8 rounded-xl border border-neutral-200">
            <h2 className="text-2xl font-bold text-neutral-black mb-4">15. CONTACT US</h2>
            <p className="text-neutral-700 mb-4">
              For privacy-related questions or to exercise your rights:
            </p>
            <ul className="space-y-2 text-neutral-700">
              <li><strong>Data Protection Officer:</strong> <a href="mailto:dpo@silentid.co.uk" className="text-primary hover:underline">dpo@silentid.co.uk</a></li>
              <li><strong>Privacy Team:</strong> <a href="mailto:privacy@silentid.co.uk" className="text-primary hover:underline">privacy@silentid.co.uk</a></li>
              <li><strong>Company:</strong> SILENTSALE LTD, Company No. 16457502</li>
            </ul>
          </section>

          {/* Note */}
          <div className="mt-12 text-sm text-neutral-500 text-center">
            <p>
              This is a summary version. Full Privacy Policy as per CLAUDE.md Section 44.<br />
              Last Updated: 23 November 2025 | Version 1.0
            </p>
          </div>
        </div>
      </main>
    </div>
  );
}
