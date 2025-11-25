/**
 * About Us Page
 * Source: CLAUDE.md Section 46 (About SilentID - Legal Imprint)
 * Version: 1.8.0
 */

import Link from 'next/link';
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'About Us | SilentID',
  description: 'Learn about SilentID - the passwordless digital trust identity platform helping honest people rise and scammers fail',
};

export default function AboutPage() {
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
          <h1 className="text-4xl md:text-5xl font-bold mb-4">About SilentID</h1>
          <p className="text-xl text-neutral-300">Building a safer internet through portable trust</p>
        </div>
      </header>

      {/* Content */}
      <main className="container mx-auto px-6 max-w-4xl py-12">
        <div className="prose prose-lg max-w-none">
          {/* Who We Are */}
          <section className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">Who We Are</h2>
            <p className="text-lg text-neutral-700 leading-relaxed">
              <strong>SilentID</strong> is a passwordless digital trust identity platform that helps people build portable, evidence-based reputations across marketplaces, dating apps, rental platforms, and community groups.
            </p>
            <div className="bg-primary-light/30 border-l-4 border-primary p-4 mt-6 rounded">
              <p className="text-neutral-800 font-semibold text-lg">
                We believe that <strong>honest people should rise, and scammers should fail.</strong>
              </p>
            </div>
          </section>

          {/* Our Mission */}
          <section className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">Our Mission</h2>
            <p className="text-lg text-neutral-700 font-semibold">
              To create a safer internet where trust is portable, verifiable, and transparent.
            </p>
            <p className="text-neutral-700 mt-4">
              SilentID empowers users to:
            </p>
            <ul className="list-disc pl-6 space-y-2 text-neutral-700 mt-2">
              <li>Verify their identity <strong>once</strong> (via Stripe Identity)</li>
              <li>Build a <strong>TrustScore (0-1000)</strong> based on real evidence</li>
              <li>Share their trust profile <strong>everywhere</strong> they trade or interact online</li>
            </ul>
          </section>

          {/* What Makes Us Different */}
          <section className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">What Makes Us Different</h2>

            <div className="space-y-6">
              <div>
                <h3 className="text-xl font-semibold text-neutral-black mb-2">1. 100% Passwordless</h3>
                <p className="text-neutral-700">
                  SilentID <strong>never</strong> uses passwords. We use Apple Sign-In, Google Sign-In, Passkeys, and Email OTP for maximum security.
                </p>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-neutral-black mb-2">2. Privacy-First</h3>
                <p className="text-neutral-700">
                  We <strong>do NOT store</strong> your ID documents or passwords. Identity verification is handled by Stripe, and we store only the verification result.
                </p>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-neutral-black mb-2">3. Evidence-Based Trust</h3>
                <p className="text-neutral-700">
                  TrustScores are built on <strong>real evidence</strong>:
                </p>
                <ul className="list-disc pl-6 space-y-1 text-neutral-700 mt-2">
                  <li>Email receipts from marketplaces</li>
                  <li>Screenshots of reviews and ratings</li>
                  <li>Links to your public seller profiles</li>
                </ul>
              </div>

              <div>
                <h3 className="text-xl font-semibold text-neutral-black mb-2">4. Bank-Grade Security</h3>
                <p className="text-neutral-700">
                  SilentID is designed with the same security standards as financial institutions.
                </p>
              </div>
            </div>
          </section>

          {/* Our Values */}
          <section className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">Our Values</h2>
            <div className="grid md:grid-cols-2 gap-6">
              <div className="bg-neutral-50 p-6 rounded-xl border border-neutral-200">
                <h3 className="text-lg font-semibold text-primary mb-2">Trust</h3>
                <p className="text-neutral-700">
                  We are transparent about how TrustScores are calculated.
                </p>
              </div>
              <div className="bg-neutral-50 p-6 rounded-xl border border-neutral-200">
                <h3 className="text-lg font-semibold text-primary mb-2">Safety</h3>
                <p className="text-neutral-700">
                  We prioritise fraud prevention and user protection.
                </p>
              </div>
              <div className="bg-neutral-50 p-6 rounded-xl border border-neutral-200">
                <h3 className="text-lg font-semibold text-primary mb-2">Privacy</h3>
                <p className="text-neutral-700">
                  We minimise data collection and protect what we do collect.
                </p>
              </div>
              <div className="bg-neutral-50 p-6 rounded-xl border border-neutral-200">
                <h3 className="text-lg font-semibold text-primary mb-2">Fairness</h3>
                <p className="text-neutral-700">
                  No pay-to-win. Paid subscriptions do NOT increase TrustScores.
                </p>
              </div>
            </div>
          </section>

          {/* Company Information */}
          <section className="mb-12 bg-neutral-50 p-8 rounded-xl border border-neutral-200">
            <h2 className="text-2xl font-bold text-neutral-black mb-6">Company Information</h2>
            <div className="space-y-2 text-neutral-700">
              <p><strong>Legal Name:</strong> SILENTSALE LTD</p>
              <p><strong>Company Number:</strong> 16457502</p>
              <p><strong>Registered in:</strong> England & Wales</p>
              <p><strong>Trading As:</strong> SilentID</p>
            </div>

            <div className="mt-6 pt-6 border-t border-neutral-200">
              <h3 className="text-lg font-semibold text-neutral-black mb-4">Contact</h3>
              <div className="space-y-2 text-neutral-700">
                <p><strong>Website:</strong> <a href="https://www.silentid.co.uk" className="text-primary hover:underline">www.silentid.co.uk</a></p>
                <p><strong>Email:</strong> <a href="mailto:hello@silentid.co.uk" className="text-primary hover:underline">hello@silentid.co.uk</a></p>
                <p><strong>Support:</strong> <a href="mailto:support@silentid.co.uk" className="text-primary hover:underline">support@silentid.co.uk</a></p>
                <p><strong>Legal:</strong> <a href="mailto:legal@silentid.co.uk" className="text-primary hover:underline">legal@silentid.co.uk</a></p>
                <p><strong>Privacy:</strong> <a href="mailto:dpo@silentid.co.uk" className="text-primary hover:underline">dpo@silentid.co.uk</a></p>
              </div>
            </div>
          </section>

          {/* Regulatory Compliance */}
          <section className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">Regulatory Compliance</h2>

            <h3 className="text-xl font-semibold text-neutral-black mb-4">Data Protection</h3>
            <p className="text-neutral-700">
              We comply with UK GDPR and the Data Protection Act 2018.
            </p>
            <div className="bg-primary-light/30 border-l-4 border-primary p-4 mt-4 rounded">
              <p className="text-neutral-800">
                <strong>ICO Registration Number:</strong> [To be inserted upon registration]
              </p>
            </div>

            <h3 className="text-xl font-semibold text-neutral-black mt-6 mb-4">Payment Processing</h3>
            <p className="text-neutral-700">
              Payments are processed by Stripe, a regulated payment service provider. SILENTSALE LTD is NOT a payment service provider.
            </p>
          </section>

          {/* What We Are Not */}
          <section className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">What We Are Not</h2>
            <div className="bg-amber-50 border-l-4 border-warning p-6 rounded">
              <p className="text-neutral-800 font-semibold mb-4">
                SilentID is <strong>NOT</strong>:
              </p>
              <ul className="space-y-2 text-neutral-700">
                <li>❌ A credit reference agency</li>
                <li>❌ A background check service</li>
                <li>❌ A financial institution or bank</li>
                <li>❌ An insurance provider</li>
                <li>❌ A marketplace or transaction platform</li>
                <li>❌ A guarantee of trustworthiness</li>
              </ul>
              <p className="text-neutral-800 mt-4 font-medium">
                <strong>Important:</strong> SilentID provides trust signals to help you make safer decisions. We do not guarantee outcomes or verify accuracy of third-party information.
              </p>
            </div>
          </section>

          {/* Our Team */}
          <section className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">Our Team</h2>
            <p className="text-neutral-700">
              SilentID is built by a small team in the UK dedicated to making the internet safer for everyone.
            </p>
            <p className="text-neutral-700 mt-4">
              We&apos;re always looking for talented people to join us. If you&apos;re passionate about trust, security, and user privacy, get in touch: <a href="mailto:careers@silentid.co.uk" className="text-primary hover:underline">careers@silentid.co.uk</a>
            </p>
          </section>

          {/* Get In Touch */}
          <section className="mb-12 bg-neutral-50 p-8 rounded-xl border border-neutral-200">
            <h2 className="text-2xl font-bold text-neutral-black mb-6">Get In Touch</h2>
            <div className="space-y-4">
              <div>
                <h3 className="font-semibold text-neutral-black">Support</h3>
                <p className="text-neutral-700">
                  If you need help, visit our Help Center or email <a href="mailto:support@silentid.co.uk" className="text-primary hover:underline">support@silentid.co.uk</a>
                </p>
              </div>
              <div>
                <h3 className="font-semibold text-neutral-black">Press & Media</h3>
                <p className="text-neutral-700">
                  For press enquiries, email <a href="mailto:press@silentid.co.uk" className="text-primary hover:underline">press@silentid.co.uk</a>
                </p>
              </div>
              <div>
                <h3 className="font-semibold text-neutral-black">Partnerships</h3>
                <p className="text-neutral-700">
                  Interested in integrating SilentID into your platform? Email <a href="mailto:partnerships@silentid.co.uk" className="text-primary hover:underline">partnerships@silentid.co.uk</a>
                </p>
              </div>
              <div>
                <h3 className="font-semibold text-neutral-black">Legal</h3>
                <p className="text-neutral-700">
                  For legal matters, email <a href="mailto:legal@silentid.co.uk" className="text-primary hover:underline">legal@silentid.co.uk</a>
                </p>
              </div>
            </div>
          </section>

          {/* Legal Documents */}
          <section className="mb-12">
            <h2 className="text-3xl font-bold text-neutral-black mb-6">Legal Documents</h2>
            <ul className="space-y-2 text-neutral-700">
              <li>
                <Link href="/terms" className="text-primary hover:underline">Terms of Use</Link>
              </li>
              <li>
                <Link href="/privacy" className="text-primary hover:underline">Privacy Policy</Link>
              </li>
              <li>
                <Link href="/cookies" className="text-primary hover:underline">Cookie Policy</Link>
              </li>
            </ul>
          </section>

          {/* Copyright */}
          <section className="mt-16 bg-neutral-900 text-white p-8 rounded-xl">
            <h2 className="text-2xl font-bold mb-4">Copyright</h2>
            <p className="mb-4">© 2025 SILENTSALE LTD. All rights reserved.</p>
            <p className="text-sm text-neutral-300">
              <strong>SilentID</strong>, the SilentID logo, and <strong>&quot;Honest people rise. Scammers fail.&quot;</strong> are trademarks of SILENTSALE LTD.
            </p>
          </section>

          {/* Note */}
          <div className="mt-12 text-sm text-neutral-500 text-center">
            <p>
              Last Updated: 23 November 2025 | Version 1.0
            </p>
          </div>
        </div>
      </main>
    </div>
  );
}
