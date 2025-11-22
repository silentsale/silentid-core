/**
 * Footer Component
 * Source: claude.md Section 18 (Domain Structure) + Section 21 (Landing Page)
 */

import { footer } from '@/config/content';

export default function Footer() {
  return (
    <footer className="bg-neutral-900 text-white">
      <div className="container-custom py-16">
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-8 mb-12">
          {/* Brand Column */}
          <div className="space-y-4">
            <h3 className="text-2xl font-bold text-white">SilentID</h3>
            <p className="text-neutral-300 leading-relaxed">
              Your passport to digital trust. Verify once, carry everywhere.
            </p>
            <div className="text-sm text-neutral-400">
              Reflects Specification v{footer.specVersion}
            </div>
          </div>

          {/* Legal Links */}
          <div className="space-y-4">
            <h4 className="text-lg font-semibold text-white">Legal</h4>
            <ul className="space-y-2">
              {footer.links.legal.map((link, index) => (
                <li key={index}>
                  <a
                    href={link.href}
                    className="text-neutral-300 hover:text-white transition-colors duration-200"
                  >
                    {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Support Links */}
          <div className="space-y-4">
            <h4 className="text-lg font-semibold text-white">Support</h4>
            <ul className="space-y-2">
              {footer.links.support.map((link, index) => (
                <li key={index}>
                  <a
                    href={link.href}
                    className="text-neutral-300 hover:text-white transition-colors duration-200"
                  >
                    {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>

          {/* Company Links */}
          <div className="space-y-4">
            <h4 className="text-lg font-semibold text-white">Company</h4>
            <ul className="space-y-2">
              {footer.links.company.map((link, index) => (
                <li key={index}>
                  <a
                    href={link.href}
                    className="text-neutral-300 hover:text-white transition-colors duration-200"
                  >
                    {link.label}
                  </a>
                </li>
              ))}
            </ul>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className="pt-8 border-t border-neutral-700 space-y-4">
          <div className="flex flex-col md:flex-row justify-between items-center gap-4">
            {/* Legal Entity */}
            <div className="text-sm text-neutral-400 text-center md:text-left">
              <p>
                {footer.companyName} is a product of{' '}
                <span className="font-semibold">{footer.legalEntity}</span>.
              </p>
              <p>
                Company No. {footer.companyNumber}. Registered in {footer.registeredIn}.
              </p>
            </div>

            {/* Copyright */}
            <div className="text-sm text-neutral-400">
              {footer.copyright}
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
}
