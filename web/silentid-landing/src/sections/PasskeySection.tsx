'use client';

import { motion } from 'framer-motion';
import { useState } from 'react';
import SectionShell from '@/components/landing/SectionShell';
import CTAButton from '@/components/landing/CTAButton';

const authMethods = [
  {
    name: 'Apple Sign-In',
    icon: (
      <svg className="w-12 h-12" viewBox="0 0 24 24" fill="currentColor">
        <path d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09l.01-.01zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z"/>
      </svg>
    ),
    description: 'Sign in with your Apple ID',
    color: 'from-neutral-900 to-neutral-700'
  },
  {
    name: 'Google Sign-In',
    icon: (
      <svg className="w-12 h-12" viewBox="0 0 24 24" fill="currentColor">
        <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
        <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
        <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
        <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
      </svg>
    ),
    description: 'Sign in with your Google account',
    color: 'from-blue-600 to-blue-400'
  },
  {
    name: 'Passkeys',
    icon: (
      <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 11c0 1.657-1.343 3-3 3s-3-1.343-3-3 1.343-3 3-3 3 1.343 3 3zm0 0c0 1.657 1.343 3 3 3s3-1.343 3-3-1.343-3-3-3m-6 9h12M9 21H5a2 2 0 01-2-2v-4a2 2 0 012-2h4m10 0h4a2 2 0 012 2v4a2 2 0 01-2 2h-4" />
      </svg>
    ),
    description: 'Face ID, Touch ID, or fingerprint',
    color: 'from-[#5A3EB8] to-[#462F8F]'
  },
  {
    name: 'Email OTP',
    icon: (
      <svg className="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
      </svg>
    ),
    description: '6-digit code sent to your email',
    color: 'from-[#1FBF71] to-[#0E9F5E]'
  }
];

export default function PasskeySection() {
  const [selectedMethod, setSelectedMethod] = useState(2); // Default to Passkeys

  return (
    <SectionShell background="white" className="py-24">
      <div className="grid lg:grid-cols-2 gap-16 items-center">
        {/* Left: Content */}
        <motion.div
          initial={{ opacity: 0, x: -50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8 }}
        >
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6 }}
            className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-[#5A3EB8]/10 text-[#5A3EB8] text-sm font-medium mb-6"
          >
            <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clipRule="evenodd" />
            </svg>
            Passwordless Security
          </motion.div>

          <h2 className="text-4xl md:text-5xl font-bold text-neutral-900 mb-6">
            100% Passwordless.{' '}
            <span className="bg-gradient-to-r from-[#5A3EB8] to-[#462F8F] bg-clip-text text-transparent">
              100% Secure.
            </span>
          </h2>

          <p className="text-xl text-neutral-600 mb-8 leading-relaxed">
            SilentID never stores passwords. Your account is protected by modern authentication methods that are both more secure and more convenient.
          </p>

          {/* Auth Methods Grid */}
          <div className="grid grid-cols-2 gap-4 mb-8">
            {authMethods.map((method, index) => (
              <motion.button
                key={index}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.1, duration: 0.6 }}
                whileHover={{ scale: 1.02, y: -2 }}
                onClick={() => setSelectedMethod(index)}
                className={`relative group p-6 rounded-2xl border-2 transition-all ${
                  selectedMethod === index
                    ? 'border-[#5A3EB8] bg-[#5A3EB8]/5'
                    : 'border-neutral-200 bg-white hover:border-[#5A3EB8]/50'
                }`}
              >
                <div className={`mb-3 ${selectedMethod === index ? 'text-[#5A3EB8]' : 'text-neutral-600'}`}>
                  {method.icon}
                </div>
                <h3 className="font-semibold text-neutral-900 mb-1">
                  {method.name}
                </h3>
                <p className="text-sm text-neutral-600">
                  {method.description}
                </p>
              </motion.button>
            ))}
          </div>

          {/* Security Features */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.6, duration: 0.6 }}
            className="bg-neutral-50 rounded-2xl p-6 border border-neutral-200"
          >
            <h3 className="font-semibold text-neutral-900 mb-4 flex items-center gap-2">
              <svg className="w-5 h-5 text-[#1FBF71]" fill="currentColor" viewBox="0 0 20 20">
                <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
              </svg>
              Why Passwordless?
            </h3>
            <ul className="space-y-3">
              <li className="flex items-start gap-3 text-neutral-700">
                <svg className="w-5 h-5 text-[#5A3EB8] flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                </svg>
                <span>Passwords are the #1 cause of account hacks</span>
              </li>
              <li className="flex items-start gap-3 text-neutral-700">
                <svg className="w-5 h-5 text-[#5A3EB8] flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                </svg>
                <span>Biometric authentication is faster and more secure</span>
              </li>
              <li className="flex items-start gap-3 text-neutral-700">
                <svg className="w-5 h-5 text-[#5A3EB8] flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                </svg>
                <span>No passwords to remember, reuse, or leak</span>
              </li>
            </ul>
          </motion.div>
        </motion.div>

        {/* Right: Animated Visualization */}
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          whileInView={{ opacity: 1, scale: 1 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8, ease: [0.16, 1, 0.3, 1] }}
          className="relative flex justify-center"
        >
          {/* Glow effect */}
          <div className="absolute inset-0 bg-gradient-to-r from-[#5A3EB8] to-[#462F8F] opacity-20 blur-3xl" />

          {/* Auth Method Display */}
          <div className="relative">
            <motion.div
              key={selectedMethod}
              initial={{ opacity: 0, scale: 0.8, rotateY: -30 }}
              animate={{ opacity: 1, scale: 1, rotateY: 0 }}
              transition={{ duration: 0.5, ease: [0.16, 1, 0.3, 1] }}
              className="bg-white rounded-3xl shadow-2xl p-12 border border-neutral-200 max-w-md"
            >
              {/* Selected Method Icon */}
              <motion.div
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ delay: 0.2, duration: 0.5, ease: [0.16, 1, 0.3, 1] }}
                className={`w-32 h-32 mx-auto mb-8 rounded-3xl bg-gradient-to-br ${authMethods[selectedMethod].color} flex items-center justify-center text-white shadow-lg`}
              >
                {authMethods[selectedMethod].icon}
              </motion.div>

              {/* Method Name */}
              <motion.h3
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.3, duration: 0.5 }}
                className="text-3xl font-bold text-neutral-900 text-center mb-3"
              >
                {authMethods[selectedMethod].name}
              </motion.h3>

              {/* Description */}
              <motion.p
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.4, duration: 0.5 }}
                className="text-neutral-600 text-center mb-8"
              >
                {authMethods[selectedMethod].description}
              </motion.p>

              {/* Animated Security Indicator */}
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                transition={{ delay: 0.5, duration: 0.5 }}
                className="flex items-center justify-center gap-2 text-[#1FBF71] bg-[#1FBF71]/10 rounded-full px-6 py-3"
              >
                <motion.svg
                  className="w-5 h-5"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                  animate={{ rotate: [0, 360] }}
                  transition={{ duration: 2, repeat: Infinity, ease: "linear" }}
                >
                  <path fillRule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                </motion.svg>
                <span className="font-medium">Secured</span>
              </motion.div>

              {/* Fingerprint Animation (for Passkeys) */}
              {selectedMethod === 2 && (
                <motion.div
                  initial={{ opacity: 0, scale: 0 }}
                  animate={{ opacity: [0, 1, 1, 0], scale: [0.8, 1.2, 1.2, 0.8] }}
                  transition={{ duration: 2, repeat: Infinity, ease: "easeInOut" }}
                  className="absolute -bottom-8 -right-8 w-32 h-32 bg-[#5A3EB8]/10 rounded-full flex items-center justify-center"
                >
                  <svg className="w-16 h-16 text-[#5A3EB8]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M12 11c0 1.657-1.343 3-3 3s-3-1.343-3-3 1.343-3 3-3 3 1.343 3 3zm0 0c0 1.657 1.343 3 3 3s3-1.343 3-3-1.343-3-3-3" />
                  </svg>
                </motion.div>
              )}
            </motion.div>
          </div>
        </motion.div>
      </div>

      {/* Bottom CTA */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ delay: 0.8, duration: 0.6 }}
        className="mt-16 text-center"
      >
        <CTAButton variant="primary" size="lg">
          Create Your SilentID
        </CTAButton>
        <p className="mt-4 text-sm text-neutral-600">
          No credit card required • Free to start
        </p>
      </motion.div>
    </SectionShell>
  );
}
