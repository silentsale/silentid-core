/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export', // Static export for Azure Static Web Apps
  images: {
    unoptimized: true, // Required for static export
  },
  trailingSlash: true,
  reactStrictMode: true,
  poweredByHeader: false, // Remove X-Powered-By header

  // Environment variables
  env: {
    SITE_URL: process.env.SITE_URL || 'https://www.silentid.co.uk',
    SPEC_VERSION: '1.4.0',
  },
}

module.exports = nextConfig
