'use client';

import { motion } from 'framer-motion';
import SectionShell from '@/components/landing/SectionShell';

const securityFeatures = [
  {
    title: 'Email Breach Scanner',
    description: 'Checks if your email appears in known data breaches. Get instant alerts if your data is compromised.',
    icon: (
      <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4" />
      </svg>
    ),
    color: 'from-[#D04C4C] to-[#FFC043]',
    status: 'Monitoring'
  },
  {
    title: 'Device Security Check',
    description: 'Verify your device hasn\'t been compromised. Detects jailbreak, root access, and security issues.',
    icon: (
      <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z" />
      </svg>
    ),
    color: 'from-[#5A3EB8] to-[#462F8F]',
    status: 'Secure'
  },
  {
    title: 'Login Activity',
    description: 'Track every login: device, location, time. Get alerts for suspicious sign-ins from new devices.',
    icon: (
      <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
      </svg>
    ),
    color: 'from-[#1FBF71] to-[#0E9F5E]',
    status: 'Tracking'
  },
  {
    title: 'Risk Score Monitor',
    description: 'Real-time fraud detection. We flag suspicious patterns like fake evidence or device inconsistencies.',
    icon: (
      <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
      </svg>
    ),
    color: 'from-[#FFC043] to-[#FF9F1C]',
    status: 'Active'
  }
];

const protectionLayers = [
  {
    label: 'Identity Protection',
    percentage: 100,
    color: '#5A3EB8'
  },
  {
    label: 'Device Security',
    percentage: 100,
    color: '#1FBF71'
  },
  {
    label: 'Account Monitoring',
    percentage: 100,
    color: '#FFC043'
  },
  {
    label: 'Fraud Detection',
    percentage: 100,
    color: '#462F8F'
  }
];

export default function RiskSignalsSection() {
  return (
    <SectionShell background="dark" className="py-24">
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
            className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-[#1FBF71]/20 text-[#1FBF71] text-sm font-medium mb-6"
          >
            <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
            </svg>
            Security Center
          </motion.div>

          <h2 className="text-4xl md:text-5xl font-bold text-white mb-6">
            Your trust,{' '}
            <span className="bg-gradient-to-r from-[#1FBF71] to-[#FFC043] bg-clip-text text-transparent">
              protected 24/7
            </span>
          </h2>

          <p className="text-xl text-neutral-300 mb-8 leading-relaxed">
            SilentID's Security Center monitors your account, devices, and identity for threats. Stay ahead of scammers with proactive protection.
          </p>

          {/* Protection Layers */}
          <div className="space-y-4 mb-8">
            {protectionLayers.map((layer, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, x: -20 }}
                whileInView={{ opacity: 1, x: 0 }}
                viewport={{ once: true }}
                transition={{ delay: index * 0.1, duration: 0.6 }}
              >
                <div className="flex items-center justify-between mb-2">
                  <span className="text-white font-medium">{layer.label}</span>
                  <span className="text-[#1FBF71] font-semibold">{layer.percentage}%</span>
                </div>
                <div className="h-2 bg-white/10 rounded-full overflow-hidden">
                  <motion.div
                    className="h-full rounded-full"
                    style={{ backgroundColor: layer.color }}
                    initial={{ width: 0 }}
                    whileInView={{ width: `${layer.percentage}%` }}
                    viewport={{ once: true }}
                    transition={{ delay: index * 0.1 + 0.3, duration: 1, ease: [0.16, 1, 0.3, 1] }}
                  />
                </div>
              </motion.div>
            ))}
          </div>

          {/* Premium Feature Notice */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.6, duration: 0.6 }}
            className="p-6 rounded-2xl bg-white/5 border border-white/10"
          >
            <div className="flex items-start gap-3">
              <svg className="w-6 h-6 text-[#FFC043] flex-shrink-0 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
              </svg>
              <div>
                <h3 className="font-semibold text-white mb-1">
                  Pro Security Features
                </h3>
                <p className="text-sm text-neutral-400 leading-relaxed">
                  Real-time breach monitoring, detailed login history, and advanced risk analytics included in the Pro plan.
                </p>
              </div>
            </div>
          </motion.div>
        </motion.div>

        {/* Right: Security Feature Cards */}
        <motion.div
          initial={{ opacity: 0, x: 50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.8 }}
          className="grid grid-cols-2 gap-4"
        >
          {securityFeatures.map((feature, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, scale: 0.9 }}
              whileInView={{ opacity: 1, scale: 1 }}
              viewport={{ once: true }}
              transition={{ delay: index * 0.1, duration: 0.6 }}
              whileHover={{ y: -8, scale: 1.02, transition: { duration: 0.2 } }}
              className="group relative"
            >
              {/* Glow effect on hover */}
              <div className="absolute inset-0 bg-gradient-to-br opacity-0 group-hover:opacity-20 blur-xl transition-opacity duration-300 rounded-2xl"
                style={{
                  backgroundImage: `linear-gradient(to bottom right, ${feature.color.split(' ')[1]}, ${feature.color.split(' ')[3]})`
                }}
              />

              {/* Card */}
              <div className="relative bg-white/10 backdrop-blur-sm rounded-2xl p-6 border border-white/20 h-full">
                {/* Icon */}
                <div className={`w-14 h-14 mb-4 rounded-xl bg-gradient-to-br ${feature.color} flex items-center justify-center text-white shadow-lg`}>
                  {feature.icon}
                </div>

                {/* Title */}
                <h3 className="text-lg font-bold text-white mb-2">
                  {feature.title}
                </h3>

                {/* Description */}
                <p className="text-sm text-neutral-300 leading-relaxed mb-4">
                  {feature.description}
                </p>

                {/* Status Badge */}
                <div className="flex items-center gap-2">
                  <motion.div
                    animate={{ scale: [1, 1.2, 1] }}
                    transition={{ duration: 2, repeat: Infinity, ease: "easeInOut" }}
                    className="w-2 h-2 rounded-full bg-[#1FBF71]"
                  />
                  <span className="text-xs font-medium text-[#1FBF71]">
                    {feature.status}
                  </span>
                </div>
              </div>
            </motion.div>
          ))}
        </motion.div>
      </div>

      {/* Bottom Stats */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ delay: 0.8, duration: 0.6 }}
        className="mt-16 grid grid-cols-2 md:grid-cols-4 gap-6"
      >
        {[
          { label: 'Threats Blocked', value: '10,000+', icon: '🛡️' },
          { label: 'Devices Monitored', value: '50,000+', icon: '📱' },
          { label: 'Logins Tracked', value: '1M+', icon: '🔐' },
          { label: 'Breaches Detected', value: '2,500+', icon: '⚠️' }
        ].map((stat, index) => (
          <motion.div
            key={index}
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ delay: 0.8 + index * 0.1, duration: 0.6 }}
            className="text-center p-6 rounded-2xl bg-white/5 border border-white/10"
          >
            <div className="text-3xl mb-2">{stat.icon}</div>
            <div className="text-3xl font-bold text-white mb-1">{stat.value}</div>
            <div className="text-sm text-neutral-400">{stat.label}</div>
          </motion.div>
        ))}
      </motion.div>
    </SectionShell>
  );
}
