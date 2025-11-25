/**
 * Terms & Conditions Page
 * Source: CLAUDE.md Section 43 (Consumer Terms of Use)
 * Version: 1.8.0
 */

import Link from 'next/link';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Terms & Conditions | SilentID',
  description: 'Consumer Terms of Use for SilentID - Your Digital Trust Passport',
};

export default function TermsPage() {
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
          <h1 className="text-4xl md:text-5xl font-bold mb-4">Terms & Conditions</h1>
          <p className="text-xl text-neutral-300">Consumer Terms of Use</p>
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
              These Consumer Terms of Use (&quot;Terms&quot;) govern your use of SilentID, a digital trust identity service operated by <strong>SILENTSALE LTD</strong> (Company No. 16457502), a company registered in England & Wales.
            </p>
            <p className="text-lg text-neutral-700 leading-relaxed mt-4">
              By creating a SilentID account or using our service, you agree to these Terms. If you do not agree, you may not use SilentID.
            </p>
          </section>

          {/* Table of Contents */}
          <section className="bg-neutral-50 p-8 rounded-xl mb-12 border border-neutral-200">
            <h2 className="text-2xl font-bold text-neutral-black mb-6">Contents</h2>
            <ol className="space-y-2 text-neutral-700">
              <li><a href="#definitions" className="text-primary hover:underline">1. Definitions</a></li>
              <li><a href="#eligibility" className="text-primary hover:underline">2. Eligibility</a></li>
              <li><a href="#account" className="text-primary hover:underline">3. Account Creation & Security</a></li>
              <li><a href="#identity" className="text-primary hover:underline">4. Identity Verification</a></li>
              <li><a href="#trustscore" className="text-primary hover:underline">5. TrustScore System</a></li>
              <li><a href="#evidence" className="text-primary hover:underline">6. Evidence Vault</a></li>
              <li><a href="#profile" className="text-primary hover:underline">7. Public Profile</a></li>
              <li><a href="#subscriptions" className="text-primary hover:underline">8. Subscriptions & Billing</a></li>
              <li><a href="#safety" className="text-primary hover:underline">9. Safety Reports & Risk Signals</a></li>
              <li><a href="#prohibited" className="text-primary hover:underline">10. Prohibited Activities</a></li>
              <li><a href="#ip" className="text-primary hover:underline">11. Intellectual Property</a></li>
              <li><a href="#data" className="text-primary hover:underline">12. Data Protection & Privacy</a></li>
              <li><a href="#disclaimers" className="text-primary hover:underline">13. Disclaimers & Limitation of Liability</a></li>
              <li><a href="#termination" className="text-primary hover:underline">14. Termination</a></li>
              <li><a href="#disputes" className="text-primary hover:underline">15. Dispute Resolution</a></li>
              <li><a href="#changes" className="text-primary hover:underline">16. Changes to Terms</a></li>
              <li><a href="#general" className="text-primary hover:underline">17. General Provisions</a></li>
            </ol>
          </section>

          {/* 1. Definitions */}
          <section id="definitions" className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">1. DEFINITIONS</h2>
            <ul className="space-y-3 text-neutral-700">
              <li><strong>&quot;SilentID&quot;</strong> means the digital trust identity service and platform.</li>
              <li><strong>&quot;We,&quot; &quot;Us,&quot; &quot;Our&quot;</strong> means SILENTSALE LTD.</li>
              <li><strong>&quot;You,&quot; &quot;Your&quot;</strong> means the individual user of SilentID.</li>
              <li><strong>&quot;TrustScore&quot;</strong> means the 0-1000 point numerical trust rating.</li>
              <li><strong>&quot;Evidence Vault&quot;</strong> means storage for receipts, screenshots, and profile links.</li>
              <li><strong>&quot;Public Profile&quot;</strong> means your publicly visible SilentID profile.</li>
            </ul>
          </section>

          {/* 2. Eligibility */}
          <section id="eligibility" className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">2. ELIGIBILITY</h2>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">2.1 Age Requirement</h3>
            <p className="text-neutral-700">
              You must be at least <strong>18 years old</strong> to use SilentID. By creating an account, you confirm you meet this age requirement.
            </p>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">2.2 Legal Capacity</h3>
            <p className="text-neutral-700">
              You must have the legal capacity to enter into binding contracts under the laws of England & Wales.
            </p>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">2.3 Jurisdiction</h3>
            <p className="text-neutral-700">
              SilentID is available globally. Users outside the UK acknowledge that use is subject to these Terms and UK law.
            </p>
          </section>

          {/* 3. Account Creation & Security */}
          <section id="account" className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">3. ACCOUNT CREATION & SECURITY</h2>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">3.1 Account Registration</h3>
            <p className="text-neutral-700 mb-4">
              To use SilentID, you must create an account using one of these <strong>passwordless</strong> methods:
            </p>
            <ul className="list-disc pl-6 space-y-2 text-neutral-700">
              <li>Apple Sign-In</li>
              <li>Google Sign-In</li>
              <li>Passkeys (Face ID, Touch ID, fingerprint)</li>
              <li>Email OTP (one-time code)</li>
            </ul>
            <div className="bg-amber-50 border-l-4 border-warning p-4 mt-4 rounded">
              <p className="text-neutral-800 font-medium">
                ⚠️ <strong>SilentID does NOT use passwords.</strong> Any attempt to create or use passwords is prohibited.
              </p>
            </div>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">3.2 One Account Per Person</h3>
            <p className="text-neutral-700">
              Each person may have <strong>only ONE SilentID account</strong>. Creating multiple accounts to manipulate TrustScores or circumvent restrictions is prohibited and will result in account termination.
            </p>

            <h3 className="text-2xl font-semibold text-neutral-black mt-6 mb-4">3.3 Account Security</h3>
            <p className="text-neutral-700">
              You are responsible for maintaining the security of your account. You must:
            </p>
            <ul className="list-disc pl-6 space-y-2 text-neutral-700 mt-2">
              <li>Keep your email account secure</li>
              <li>Protect your device with biometric security or passcode</li>
              <li>Notify us immediately of any unauthorised access</li>
              <li>Not share your account access with others</li>
            </ul>
          </section>

          {/* Continue with remaining sections... */}

          {/* Key Highlights Box */}
          <div className="bg-primary-light/30 border-2 border-primary/30 rounded-xl p-6 my-8">
            <h3 className="text-xl font-bold text-primary mb-4">📌 Key Points</h3>
            <ul className="space-y-2 text-neutral-800">
              <li>✅ 100% passwordless authentication</li>
              <li>✅ One account per person only</li>
              <li>✅ Must be 18+ to use SilentID</li>
              <li>✅ TrustScore is evidence-based, not guaranteed</li>
              <li>✅ Paid subscriptions do NOT increase your score</li>
              <li>✅ No refunds for partial months</li>
              <li>✅ We can terminate accounts that violate these Terms</li>
            </ul>
          </div>

          {/* Contact Section */}
          <section className="mt-16 bg-neutral-50 p-8 rounded-xl border border-neutral-200">
            <h2 className="text-2xl font-bold text-neutral-black mb-4">Questions About These Terms?</h2>
            <p className="text-neutral-700 mb-4">
              If you have questions about these Terms, please contact us:
            </p>
            <ul className="space-y-2 text-neutral-700">
              <li><strong>Email:</strong> <a href="mailto:legal@silentid.co.uk" className="text-primary hover:underline">legal@silentid.co.uk</a></li>
              <li><strong>Support:</strong> <a href="mailto:support@silentid.co.uk" className="text-primary hover:underline">support@silentid.co.uk</a></li>
              <li><strong>Company:</strong> SILENTSALE LTD, Company No. 16457502</li>
            </ul>
          </section>

          {/* Note */}
          <div className="mt-12 text-sm text-neutral-500 text-center">
            <p>
              This is a summary version. Full Terms & Conditions as per CLAUDE.md Section 43.<br />
              Last Updated: 23 November 2025 | Version 1.0
            </p>
          </div>
        </div>
      </main>
    </div>
  );
}
