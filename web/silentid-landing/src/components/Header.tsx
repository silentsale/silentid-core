'use client';

/**
 * Header Component - Navigation Bar
 * Source: claude.md Section 21 (Landing Page)
 *
 * Features:
 * - Fixed header that stays on top when scrolling
 * - Logo on the left (clickable, links to #home)
 * - Navigation menu on the right
 * - "Get Started" CTA button
 * - Mobile responsive with hamburger menu
 * - Professional, bank-grade aesthetic
 */

import { useState, useEffect } from 'react';
import Link from 'next/link';

// Inline SVG Logo component for crisp rendering
const Logo = ({ className }: { className?: string }) => (
  <svg
    viewBox="0 0 180 40"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
    className={className}
  >
    {/* Shield with keyhole */}
    <path
      d="M4 8C4 6.89543 4.89543 6 6 6H26C27.1046 6 28 6.89543 28 8V20C28 28 16 34 16 34C16 34 4 28 4 20V8Z"
      fill="#5A3EB8"
    />
    {/* Keyhole */}
    <circle cx="16" cy="15" r="4" fill="white"/>
    <path d="M14 18H18V25H14V18Z" fill="white"/>

    {/* SilentID text */}
    <text x="36" y="26" fontFamily="Inter, system-ui, sans-serif" fontSize="22" fontWeight="600" fill="#5A3EB8">
      SilentID
    </text>
  </svg>
);

const navLinks = [
  { href: '/#problem', label: 'The Problem' },
  { href: '/#how-it-works', label: 'How It Works' },
  { href: '/#pricing', label: 'Pricing' },
  { href: '/#faq', label: 'FAQ' },
];

export default function Header() {
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  // Handle scroll effect for header shadow
  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 10);
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  // Close mobile menu when clicking outside
  useEffect(() => {
    if (isMobileMenuOpen) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = 'unset';
    }

    return () => {
      document.body.style.overflow = 'unset';
    };
  }, [isMobileMenuOpen]);

  // Close mobile menu when clicking a link
  const handleLinkClick = () => {
    setIsMobileMenuOpen(false);
  };

  return (
    <header
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        isScrolled
          ? 'bg-white/95 backdrop-blur-md shadow-md'
          : 'bg-white'
      }`}
    >
      <nav className="container-custom">
        <div className="flex items-center justify-between h-20">
          {/* Logo */}
          <Link
            href="/"
            className="flex items-center transition-opacity hover:opacity-80"
            onClick={handleLinkClick}
          >
            <Logo className="h-10 w-auto" />
          </Link>

          {/* Desktop Navigation */}
          <div className="hidden lg:flex items-center space-x-8">
            {navLinks.map((link) => (
              <a
                key={link.href}
                href={link.href}
                className="text-neutral-700 font-medium hover:text-primary transition-colors duration-200"
              >
                {link.label}
              </a>
            ))}

            {/* CTA Button */}
            <button className="btn-primary">
              Get Started
            </button>
          </div>

          {/* Mobile Menu Button */}
          <button
            className="lg:hidden p-2 text-neutral-700 hover:text-primary transition-colors"
            onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
            aria-label="Toggle menu"
            aria-expanded={isMobileMenuOpen}
          >
            {isMobileMenuOpen ? (
              // Close Icon
              <svg
                className="w-6 h-6"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M6 18L18 6M6 6l12 12"
                />
              </svg>
            ) : (
              // Hamburger Icon
              <svg
                className="w-6 h-6"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M4 6h16M4 12h16M4 18h16"
                />
              </svg>
            )}
          </button>
        </div>
      </nav>

      {/* Mobile Menu Overlay */}
      {isMobileMenuOpen && (
        <>
          {/* Backdrop */}
          <div
            className="fixed inset-0 bg-neutral-black/50 backdrop-blur-sm lg:hidden"
            onClick={() => setIsMobileMenuOpen(false)}
            aria-hidden="true"
          />

          {/* Mobile Menu */}
          <div className="fixed top-20 left-0 right-0 bg-white border-t border-neutral-300 shadow-lg lg:hidden">
            <div className="container-custom py-6">
              <div className="flex flex-col space-y-4">
                {navLinks.map((link) => (
                  <a
                    key={link.href}
                    href={link.href}
                    className="text-lg font-medium text-neutral-700 hover:text-primary transition-colors py-2"
                    onClick={handleLinkClick}
                  >
                    {link.label}
                  </a>
                ))}

                {/* Mobile CTA Button */}
                <button
                  className="btn-primary mt-4"
                  onClick={handleLinkClick}
                >
                  Get Started
                </button>
              </div>
            </div>
          </div>
        </>
      )}
    </header>
  );
}
