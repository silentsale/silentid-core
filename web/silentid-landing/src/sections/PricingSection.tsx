'use client';

import { motion } from 'framer-motion';
import SectionShell from '@/components/landing/SectionShell';
import CTAButton from '@/components/landing/CTAButton';

const pricingTiers = [
  {
    name: 'Free',
    price: '£0',
    period: 'forever',
    description: 'Back up your reputation and start building trust',
    features: [
      'Identity verification via Stripe',
      'Basic TrustScore (0-1000)',
      'Connect up to 5 marketplace profiles',
      'Public Trust Passport URL',
      'Basic verified badge for social bios',
      'File safety reports'
    ],
    cta: 'Get Started Free',
    popular: false,
    color: 'neutral'
  },
  {
    name: 'Pro',
    price: '£4.99',
    period: 'per month',
    description: 'Full reputation protection for serious sellers',
    features: [
      'Everything in Free',
      'Unlimited profile connections',
      'Premium verified badge with QR code',
      'Combined star rating from all platforms',
      'Rating drop alerts—know instantly if something changes',
      'Trust timeline—see your reputation history over time',
      'Dispute evidence pack—legal-ready PDF proof of your history',
      'Platform watchdog—alerts when markets have mass bans',
      'Custom passport URL (silentid.co.uk/your-name)',
      'Priority verification & support'
    ],
    cta: 'Protect Your Reputation',
    popular: true,
    color: 'purple'
  }
];

export default function PricingSection() {
  return (
    <SectionShell background="subtle" className="py-24" id="pricing">
      {/* Header */}
      <div className="text-center mb-16">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-[#5A3EB8]/10 text-[#5A3EB8] text-sm font-medium mb-6"
        >
          <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
            <path d="M8.433 7.418c.155-.103.346-.196.567-.267v1.698a2.305 2.305 0 01-.567-.267C8.07 8.34 8 8.114 8 8c0-.114.07-.34.433-.582zM11 12.849v-1.698c.22.071.412.164.567.267.364.243.433.468.433.582 0 .114-.07.34-.433.582a2.305 2.305 0 01-.567.267z" />
            <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-13a1 1 0 10-2 0v.092a4.535 4.535 0 00-1.676.662C6.602 6.234 6 7.009 6 8c0 .99.602 1.765 1.324 2.246.48.32 1.054.545 1.676.662v1.941c-.391-.127-.68-.317-.843-.504a1 1 0 10-1.51 1.31c.562.649 1.413 1.076 2.353 1.253V15a1 1 0 102 0v-.092a4.535 4.535 0 001.676-.662C13.398 13.766 14 12.991 14 12c0-.99-.602-1.765-1.324-2.246A4.535 4.535 0 0011 9.092V7.151c.391.127.68.317.843.504a1 1 0 101.511-1.31c-.563-.649-1.413-1.076-2.354-1.253V5z" clipRule="evenodd" />
          </svg>
          Pricing Plans
        </motion.div>

        <motion.h2
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.1, duration: 0.6 }}
          className="text-4xl md:text-5xl font-bold text-neutral-900 mb-6"
        >
          Protect Your{' '}
          <span className="bg-gradient-to-r from-[#5A3EB8] to-[#462F8F] bg-clip-text text-transparent">
            Reputation
          </span>
        </motion.h2>

        <motion.p
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.2, duration: 0.6 }}
          className="text-xl text-neutral-600 max-w-3xl mx-auto"
        >
          Start backing up your ratings for free. Upgrade for full protection with alerts, history, and legal-ready proof.
        </motion.p>
      </div>

      {/* Pricing Cards */}
      <div className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto mb-12">
        {pricingTiers.map((tier, index) => (
          <motion.div
            key={tier.name}
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: index * 0.1, duration: 0.6 }}
            whileHover={{ y: -8, transition: { duration: 0.2 } }}
            className="relative group"
          >
            {/* Popular badge */}
            {tier.popular && (
              <div className="absolute -top-4 left-1/2 -translate-x-1/2 z-10">
                <div className="px-4 py-1.5 rounded-full bg-gradient-to-r from-[#5A3EB8] to-[#462F8F] text-white text-sm font-medium shadow-lg">
                  Most Popular
                </div>
              </div>
            )}

            {/* Glow effect on hover */}
            <div className={`absolute inset-0 bg-gradient-to-br ${
              tier.popular
                ? 'from-[#5A3EB8]/20 to-[#462F8F]/20'
                : 'from-neutral-200/20 to-neutral-300/20'
            } opacity-0 group-hover:opacity-100 blur-xl transition-opacity duration-300 rounded-3xl`} />

            {/* Card */}
            <div className={`relative bg-white rounded-3xl shadow-xl border-2 ${
              tier.popular ? 'border-[#5A3EB8]' : 'border-neutral-200'
            } p-8 h-full flex flex-col`}>
              {/* Tier name */}
              <h3 className="text-2xl font-bold text-neutral-900 mb-2">
                {tier.name}
              </h3>

              {/* Price */}
              <div className="mb-4">
                <div className="flex items-baseline gap-2">
                  <span className="text-5xl font-bold text-neutral-900">
                    {tier.price}
                  </span>
                  <span className="text-neutral-600">
                    {tier.period}
                  </span>
                </div>
              </div>

              {/* Description */}
              <p className="text-neutral-600 mb-6">
                {tier.description}
              </p>

              {/* CTA */}
              <CTAButton
                variant={tier.popular ? 'primary' : 'secondary'}
                className="w-full mb-6"
              >
                {tier.cta}
              </CTAButton>

              {/* Features */}
              <div className="space-y-3 flex-1">
                {tier.features.map((feature, i) => (
                  <motion.div
                    key={i}
                    initial={{ opacity: 0, x: -10 }}
                    whileInView={{ opacity: 1, x: 0 }}
                    viewport={{ once: true }}
                    transition={{ delay: index * 0.1 + i * 0.05, duration: 0.4 }}
                    className="flex items-start gap-3"
                  >
                    <svg className="w-5 h-5 text-[#1FBF71] flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                    <span className="text-sm text-neutral-700 leading-relaxed">
                      {feature}
                    </span>
                  </motion.div>
                ))}
              </div>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Critical Disclaimer */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ delay: 0.6, duration: 0.6 }}
        className="max-w-4xl mx-auto"
      >
        <div className="p-6 rounded-2xl bg-[#FFC043]/10 border-2 border-[#FFC043]/30">
          <div className="flex items-start gap-4">
            <svg className="w-6 h-6 text-[#FFC043] flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
            </svg>
            <div>
              <h3 className="font-bold text-neutral-900 mb-2 text-lg">
                Important: Your TrustScore Cannot Be Bought
              </h3>
              <p className="text-neutral-700 leading-relaxed mb-3">
                Paid subscriptions <strong>do NOT increase your TrustScore</strong> or override safety systems. Your score is based purely on verified profiles and behavior, never on what you pay.
              </p>
              <p className="text-sm text-neutral-600 leading-relaxed">
                Pro unlocks unlimited profile connections, advanced analytics, and professional tools—but your trustworthiness is always earned through real verification, never purchased.
              </p>
            </div>
          </div>
        </div>
      </motion.div>

      {/* FAQ Quick Links */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ delay: 0.8, duration: 0.6 }}
        className="mt-12 text-center"
      >
        <p className="text-neutral-600 mb-4">Have questions?</p>
        <div className="flex flex-wrap justify-center gap-4">
          <CTAButton href="#" variant="text">
            View Full Feature Comparison
          </CTAButton>
          <CTAButton href="#" variant="text">
            Read FAQs
          </CTAButton>
          <CTAButton href="#" variant="text">
            Contact Sales
          </CTAButton>
        </div>
      </motion.div>
    </SectionShell>
  );
}
