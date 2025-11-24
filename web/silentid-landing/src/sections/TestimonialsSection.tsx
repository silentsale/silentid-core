'use client';

import { motion } from 'framer-motion';
import SectionShell from '@/components/landing/SectionShell';

const testimonials = [
  {
    quote: "SilentID completely changed how I sell online. Buyers trust me instantly because they can see my verified history across all platforms.",
    author: "Alex Thompson",
    role: "Vintage Seller",
    trustScore: 892,
    verified: true,
    platforms: 3,
    avatar: "AT"
  },
  {
    quote: "No more starting from zero on every new marketplace. My trust follows me everywhere, and it's based on real evidence—not just claims.",
    author: "Maria Rodriguez",
    role: "Professional Reseller",
    trustScore: 847,
    verified: true,
    platforms: 5,
    avatar: "MR"
  },
  {
    quote: "Finally, a way to prove I'm trustworthy without sharing my personal information. The passwordless system is genius.",
    author: "James Chen",
    role: "Community Organizer",
    trustScore: 765,
    verified: true,
    platforms: 2,
    avatar: "JC"
  },
  {
    quote: "As a parent, I use SilentID to vet other parents in our local groups. It gives me peace of mind knowing everyone is verified.",
    author: "Sarah Mitchell",
    role: "Parent & Group Admin",
    trustScore: 823,
    verified: true,
    platforms: 4,
    avatar: "SM"
  },
  {
    quote: "The Security Center caught a data breach I didn't even know about. SilentID isn't just about trust—it's about safety.",
    author: "David Park",
    role: "Marketplace Power Seller",
    trustScore: 911,
    verified: true,
    platforms: 6,
    avatar: "DP"
  },
  {
    quote: "I upgraded to Pro for the bulk checks. Game-changer for moderating our community. Worth every penny.",
    author: "Rachel Green",
    role: "Online Community Manager",
    trustScore: 856,
    verified: true,
    platforms: 3,
    avatar: "RG"
  }
];

export default function TestimonialsSection() {
  return (
    <SectionShell background="white" className="py-24">
      {/* Header */}
      <div className="text-center mb-16">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-[#1FBF71]/10 text-[#1FBF71] text-sm font-medium mb-6"
        >
          <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
            <path d="M2 10.5a1.5 1.5 0 113 0v6a1.5 1.5 0 01-3 0v-6zM6 10.333v5.43a2 2 0 001.106 1.79l.05.025A4 4 0 008.943 18h5.416a2 2 0 001.962-1.608l1.2-6A2 2 0 0015.56 8H12V4a2 2 0 00-2-2 1 1 0 00-1 1v.667a4 4 0 01-.8 2.4L6.8 7.933a4 4 0 00-.8 2.4z" />
          </svg>
          Trusted by Thousands
        </motion.div>

        <motion.h2
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.1, duration: 0.6 }}
          className="text-4xl md:text-5xl font-bold text-neutral-900 mb-6"
        >
          Real People,{' '}
          <span className="bg-gradient-to-r from-[#5A3EB8] to-[#462F8F] bg-clip-text text-transparent">
            Real Trust
          </span>
        </motion.h2>

        <motion.p
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ delay: 0.2, duration: 0.6 }}
          className="text-xl text-neutral-600 max-w-3xl mx-auto"
        >
          Join thousands of verified users building portable trust across marketplaces, communities, and platforms.
        </motion.p>
      </div>

      {/* Testimonials Grid */}
      <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6 mb-16">
        {testimonials.map((testimonial, index) => (
          <motion.div
            key={index}
            initial={{ opacity: 0, y: 30 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true, margin: '-50px' }}
            transition={{ delay: index * 0.1, duration: 0.6 }}
            whileHover={{ y: -8, transition: { duration: 0.2 } }}
            className="group"
          >
            <div className="relative bg-white rounded-2xl shadow-lg border border-neutral-200 p-6 h-full flex flex-col group-hover:shadow-2xl group-hover:border-[#5A3EB8]/30 transition-all">
              {/* Quote */}
              <div className="mb-6 flex-1">
                <svg className="w-8 h-8 text-[#5A3EB8]/20 mb-3" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M14.017 21v-7.391c0-5.704 3.731-9.57 8.983-10.609l.995 2.151c-2.432.917-3.995 3.638-3.995 5.849h4v10h-9.983zm-14.017 0v-7.391c0-5.704 3.748-9.57 9-10.609l.996 2.151c-2.433.917-3.996 3.638-3.996 5.849h3.983v10h-9.983z" />
                </svg>
                <p className="text-neutral-700 leading-relaxed">
                  "{testimonial.quote}"
                </p>
              </div>

              {/* Author */}
              <div className="border-t border-neutral-100 pt-4">
                <div className="flex items-center gap-3 mb-3">
                  {/* Avatar */}
                  <div className="w-12 h-12 rounded-full bg-gradient-to-br from-[#5A3EB8] to-[#462F8F] flex items-center justify-center text-white font-bold flex-shrink-0">
                    {testimonial.avatar}
                  </div>

                  {/* Name & Role */}
                  <div className="flex-1">
                    <div className="flex items-center gap-2">
                      <h4 className="font-semibold text-neutral-900">
                        {testimonial.author}
                      </h4>
                      {testimonial.verified && (
                        <svg className="w-4 h-4 text-[#1FBF71]" fill="currentColor" viewBox="0 0 20 20">
                          <path fillRule="evenodd" d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                        </svg>
                      )}
                    </div>
                    <p className="text-sm text-neutral-500">
                      {testimonial.role}
                    </p>
                  </div>
                </div>

                {/* Trust Indicators */}
                <div className="flex items-center gap-4 text-xs text-neutral-600">
                  <div className="flex items-center gap-1">
                    <svg className="w-4 h-4 text-[#5A3EB8]" fill="currentColor" viewBox="0 0 20 20">
                      <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                    </svg>
                    <span className="font-medium">{testimonial.trustScore}</span>
                  </div>
                  <span className="text-neutral-300">•</span>
                  <span>{testimonial.platforms} platforms</span>
                </div>
              </div>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Stats */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ delay: 0.8, duration: 0.6 }}
        className="grid grid-cols-2 md:grid-cols-4 gap-8 max-w-4xl mx-auto"
      >
        {[
          { value: '50,000+', label: 'Verified Users' },
          { value: '500,000+', label: 'Trades Protected' },
          { value: '847', label: 'Average TrustScore' },
          { value: '99.2%', label: 'User Satisfaction' }
        ].map((stat, index) => (
          <motion.div
            key={index}
            initial={{ opacity: 0, scale: 0.9 }}
            whileInView={{ opacity: 1, scale: 1 }}
            viewport={{ once: true }}
            transition={{ delay: 0.8 + index * 0.1, duration: 0.6 }}
            className="text-center"
          >
            <div className="text-3xl md:text-4xl font-bold text-[#5A3EB8] mb-2">
              {stat.value}
            </div>
            <div className="text-sm text-neutral-600">
              {stat.label}
            </div>
          </motion.div>
        ))}
      </motion.div>
    </SectionShell>
  );
}
