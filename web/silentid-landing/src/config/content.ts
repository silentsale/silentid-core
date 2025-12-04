/**
 * Content Configuration for SilentID Landing Page
 * Source: claude.md (Various Sections)
 * Version: 2.1.0 - SEO & AI Optimized
 *
 * CRITICAL: All content is extracted from claude.md.
 * When claude.md changes, update this file accordingly.
 */

export const hero = {
  // Fear hook
  fearHook: '50K+ Vinted accounts banned in 2024. Years of stars—gone instantly.',
  headline: 'Never Lose Your Reputation Again',
  subheadline: 'SilentID backs up your hard-earned ratings from Vinted, eBay, Depop, and more.',
  tagline: 'Your reputation, protected and portable.',
  primaryCTA: 'Protect Your Reputation',
  secondaryCTA: 'See How It Works',
  // Trust signals
  trustSignals: [
    'Works with Vinted, eBay, Depop & more',
    'Your proof, backed up forever',
    '100% Passwordless & Secure',
  ],
};

export const problem = {
  title: 'The Problem Every Seller Faces',
  subtitle: 'Your reputation is at risk—and most people don\'t realize until it\'s too late',
  stats: [
    {
      value: '50K+',
      label: 'Vinted accounts banned in 2024 alone',
      icon: 'ban',
    },
    {
      value: '3.2 years',
      label: 'Average feedback history lost per banned account',
      icon: 'clock',
    },
    {
      value: '89%',
      label: 'Of sellers never recover their ratings',
      icon: 'trending-down',
    },
  ],
  painPoints: [
    'Platform bans your account without warning—all your stars gone',
    'Marketplace shuts down—years of reputation disappear overnight',
    'Moving to a new platform—start from zero, no proof of who you are',
    'Unfair review tanks your rating—no way to show your real track record',
  ],
  solution: 'SilentID is your reputation backup. We save your ratings, verify your identity, and give you permanent proof of who you really are.',
};

export const howItWorks = {
  title: 'How SilentID Works',
  subtitle: 'Protect your reputation in four simple steps',
  steps: [
    {
      number: '01',
      title: 'Create Your Account',
      description: 'Sign up with Apple, Google, or Passkey. No passwords needed—ever. Takes 30 seconds.',
      icon: 'key',
      color: 'purple',
      screen: 'onboarding', // Maps to app screen
    },
    {
      number: '02',
      title: 'Verify Your Identity',
      description: 'Quick ID check via Stripe Identity. Your documents stay with Stripe—we only get confirmation you\'re real.',
      icon: 'shield-check',
      color: 'green',
      screen: 'identity',
    },
    {
      number: '03',
      title: 'Connect Your Profiles',
      description: 'Link your Vinted, eBay, Depop, Instagram, and other profiles. We verify ownership and back up your ratings.',
      icon: 'link',
      color: 'amber',
      screen: 'connect-profiles',
    },
    {
      number: '04',
      title: 'Share Your Trust',
      description: 'Get your Trust Passport and verified badge. Share anywhere—even platforms that block links can see your QR code.',
      icon: 'share',
      color: 'blue',
      screen: 'share-passport',
    },
  ],
};

export const appWalkthrough = {
  title: 'See SilentID in Action',
  subtitle: 'Take a tour of the app and see how your reputation is protected',
  screens: [
    {
      id: 'horror-stats',
      title: 'The Risk Is Real',
      description: 'First, we show you why reputation protection matters. These numbers are real.',
      highlight: 'Did you know 89% of sellers never recover their ratings after a ban?',
    },
    {
      id: 'solution',
      title: 'Your Safety Net',
      description: 'SilentID backs up your hard-earned reputation across all platforms.',
      highlight: 'Never lose your stars again.',
    },
    {
      id: 'trustscore',
      title: 'One Score, All Platforms',
      description: 'Your TrustScore (0-1000) combines ratings from Vinted, eBay, Depop, and more.',
      highlight: 'Your combined 4.8★ rating from 5 platforms—in one number.',
    },
    {
      id: 'connect',
      title: 'Connect Your Profiles',
      description: 'Link any marketplace or social profile. We verify you own it.',
      highlight: 'Supports 20+ platforms including Vinted, eBay, Depop, Instagram, TikTok.',
    },
    {
      id: 'badge',
      title: 'Share Your Verified Badge',
      description: 'Download your badge with QR code. Share on dating apps, social media, anywhere.',
      highlight: 'Works even if people don\'t know what SilentID is—your stats speak for themselves.',
    },
  ],
};

export const trustScore = {
  title: 'Your TrustScore: One Number, All Your Reputation',
  subtitle: 'We aggregate your ratings from every platform into one powerful score',
  maxScore: 1000,
  components: [
    {
      name: 'Identity',
      points: 300,
      description: 'Email verification, Stripe ID check, passkey setup',
      icon: 'user-check',
    },
    {
      name: 'Profiles',
      points: 400,
      description: 'Verified marketplace and social profiles with ratings',
      icon: 'link',
    },
    {
      name: 'Behaviour',
      points: 300,
      description: 'Account age, login patterns, platform engagement',
      icon: 'activity',
    },
  ],
  levels: [
    { range: '850-1000', label: 'Exceptional', color: 'emerald' },
    { range: '700-849', label: 'Very High', color: 'green' },
    { range: '550-699', label: 'High', color: 'lime' },
    { range: '400-549', label: 'Moderate', color: 'yellow' },
    { range: '250-399', label: 'Low', color: 'orange' },
    { range: '0-249', label: 'High Risk', color: 'red' },
  ],
  aggregatedRating: {
    title: 'Combined Star Rating',
    description: 'Pro users see their aggregated rating across all platforms',
    example: '4.8★ from 5 platforms',
  },
};

export const platforms = {
  title: 'Works With Your Favorite Platforms',
  subtitle: 'Connect profiles from marketplaces, social media, and more',
  categories: [
    {
      name: 'Marketplaces',
      platforms: ['Vinted', 'eBay', 'Depop', 'Etsy', 'Poshmark', 'Facebook Marketplace'],
    },
    {
      name: 'Social',
      platforms: ['Instagram', 'TikTok', 'Twitter/X', 'YouTube', 'LinkedIn'],
    },
    {
      name: 'Professional',
      platforms: ['GitHub', 'Behance', 'Dribbble'],
    },
    {
      name: 'Gaming & Community',
      platforms: ['Discord', 'Twitch', 'Steam', 'Reddit'],
    },
  ],
};

export const pricing = {
  title: 'Protect Your Reputation',
  subtitle: 'Start backing up your ratings for free. Upgrade for full protection.',
  tiers: [
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
        'File safety reports',
      ],
      cta: 'Get Started Free',
      popular: false,
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
        'Dispute evidence pack—legal-ready PDF proof',
        'Platform watchdog—alerts when markets have mass bans',
        'Custom passport URL (silentid.co.uk/your-name)',
        'Priority verification & support',
      ],
      cta: 'Protect Your Reputation',
      popular: true,
    },
  ],
  disclaimer: {
    title: 'Important: Your TrustScore Cannot Be Bought',
    text: 'Paid subscriptions do NOT increase your TrustScore. Your score is based purely on verified profiles and behavior, never on what you pay. Pro unlocks tools and analytics—your trustworthiness is always earned.',
  },
};

// SEO & AI Optimized FAQ - Comprehensive answers for better ranking
export const faq = {
  title: 'Frequently Asked Questions',
  subtitle: 'Everything you need to know about protecting your online reputation',
  questions: [
    {
      question: 'What is SilentID?',
      answer: 'SilentID is a reputation backup service for online sellers. It saves your hard-earned ratings from platforms like Vinted, eBay, Depop, Instagram, and others into one secure profile. If your account gets banned, the platform shuts down, or you move to a new marketplace, you have permanent proof of your reputation. SilentID also creates a TrustScore (0-1000) that combines all your ratings into one number, plus a verified badge you can share anywhere.',
      keywords: ['reputation backup', 'online sellers', 'Vinted', 'eBay', 'Depop', 'TrustScore'],
    },
    {
      question: 'What happens if my Vinted or eBay account gets banned?',
      answer: 'If your marketplace account gets banned, your years of hard-earned feedback typically disappear forever—89% of sellers never recover their ratings. With SilentID, your reputation is already backed up. You have proof of your rating history, verified identity, and TrustScore. You can show new platforms, buyers, or anyone that you were a trusted seller before the ban. Your Trust Passport and verified badge serve as portable proof that follows you everywhere.',
      keywords: ['Vinted banned', 'eBay banned', 'account suspended', 'lost ratings', 'reputation backup'],
    },
    {
      question: 'How does SilentID protect my reputation?',
      answer: 'SilentID protects your reputation in three ways: (1) Backup - We verify and store your ratings from connected platforms, so if anything happens to your account, the proof exists. (2) Aggregation - We combine ratings from all your platforms into one TrustScore and combined star rating (e.g., "4.8★ across 5 platforms"). (3) Portability - Your Trust Passport and verified badge can be shared anywhere, proving your trustworthiness even on platforms that don\'t know you yet.',
      keywords: ['reputation protection', 'rating backup', 'TrustScore', 'verified badge'],
    },
    {
      question: 'Is SilentID free?',
      answer: 'Yes, SilentID has a free tier that includes identity verification, basic TrustScore, connecting up to 5 profiles, a public Trust Passport URL, basic verified badge, and the ability to file safety reports. For serious sellers who want complete protection features, Pro costs £4.99/month and adds unlimited profile connections, rating drop alerts, trust timeline history, dispute evidence pack generator, platform watchdog alerts, and priority support.',
      keywords: ['free', 'pricing', 'Pro subscription', 'cost'],
    },
    {
      question: 'Which platforms does SilentID work with?',
      answer: 'SilentID works with 20+ platforms across multiple categories. Marketplaces: Vinted, eBay, Depop, Etsy, Poshmark, Facebook Marketplace. Social: Instagram, TikTok, Twitter/X, YouTube, LinkedIn. Professional: GitHub, Behance, Dribbble. Gaming & Community: Discord, Twitch, Steam, Reddit. We\'re constantly adding more platforms based on user requests.',
      keywords: ['supported platforms', 'Vinted', 'eBay', 'Depop', 'Instagram', 'TikTok', 'marketplaces'],
    },
    {
      question: 'How does SilentID verify that I own my profiles?',
      answer: 'We use a simple token verification method. When you connect a profile, SilentID gives you a unique code to temporarily add to your profile bio (e.g., "Verify: ABC123"). We check that the code appears, confirm you own the account, then you can remove it. This proves ownership without needing your login credentials. We never ask for your passwords to other platforms.',
      keywords: ['profile verification', 'token verification', 'prove ownership'],
    },
    {
      question: 'Can I use SilentID on dating apps?',
      answer: 'Yes! SilentID is perfect for dating apps where trust is crucial. You can share your verified badge (which includes your TrustScore, ID verification status, and combined rating from other platforms) on your Tinder, Bumble, Hinge, or any dating profile. The QR code links to your full Trust Passport. It\'s a way to show potential matches that you\'re a real, trustworthy person with a verified track record online.',
      keywords: ['dating apps', 'Tinder', 'Bumble', 'online dating', 'verified badge'],
    },
    {
      question: 'What is a TrustScore and how is it calculated?',
      answer: 'Your TrustScore is a number from 0 to 1000 that represents your overall trustworthiness online. It\'s calculated from three components: Identity (up to 300 points) - email verification, Stripe ID check, passkey setup. Profiles (up to 400 points) - verified marketplace and social profiles with their ratings. Behaviour (up to 300 points) - account age, login patterns, platform engagement. Higher scores indicate more trustworthy users. Scores regenerate weekly.',
      keywords: ['TrustScore', 'trust rating', 'calculation', 'score components'],
    },
    {
      question: 'Is SilentID secure? Do you store my passwords?',
      answer: 'SilentID is 100% passwordless—we never store passwords because we never ask for them. You sign up using Apple Sign-In, Google Sign-In, Passkeys (FIDO2/WebAuthn), or Email OTP. For identity verification, we use Stripe Identity, which means your ID documents go to Stripe, not SilentID. We only receive confirmation that you\'re verified. All data is encrypted, and we\'re fully GDPR compliant as a UK-registered company.',
      keywords: ['security', 'passwordless', 'GDPR', 'Stripe Identity', 'data protection'],
    },
    {
      question: 'What is the verified badge and how do I use it?',
      answer: 'The verified badge is a shareable image containing your SilentID verification. It shows: your TrustScore (if public), combined star rating from all platforms, number of connected platforms, ID verification checkmark, and a QR code linking to your full Trust Passport. You can download it in different sizes (profile picture, Instagram story, card format) and light/dark modes. Share it on social media bios, marketplace profiles, dating apps, or anywhere you want to prove your trustworthiness.',
      keywords: ['verified badge', 'QR code', 'Trust Passport', 'share', 'social media'],
    },
    {
      question: 'Can I delete my SilentID account?',
      answer: 'Yes, you can delete your account anytime from Settings. After requesting deletion, there\'s a 30-day grace period where you can cancel if you change your mind. After 30 days, your profile, connected profiles, and all personal data are permanently deleted. We only retain anonymized fraud prevention data as required by law. You can also export your data before deletion.',
      keywords: ['delete account', 'data deletion', 'GDPR rights', 'privacy'],
    },
    {
      question: 'What is the dispute evidence pack?',
      answer: 'The dispute evidence pack (Pro feature) is a legal-ready PDF document that proves your reputation history. It includes: your TrustScore and breakdown, all connected platform ratings with dates, ID verification confirmation, reputation timeline, and a unique verification link. It\'s designed for situations where you need official proof—disputing a ban, applying to a platform, showing a potential buyer, or any legal context where your online reputation matters.',
      keywords: ['dispute evidence', 'proof', 'legal document', 'reputation history'],
    },
    {
      question: 'What are rating drop alerts?',
      answer: 'Rating drop alerts (Pro feature) notify you immediately if any of your connected platform ratings change. For example, if someone leaves you a negative review on Vinted or your eBay feedback score drops, you get an instant notification. This lets you respond quickly—either addressing the issue on the platform or updating your SilentID profile with context. It\'s early warning protection for your reputation.',
      keywords: ['rating alerts', 'notifications', 'feedback monitoring', 'reputation tracking'],
    },
    {
      question: 'What is the platform watchdog feature?',
      answer: 'Platform watchdog (Pro feature) alerts you when marketplaces have mass account bans or significant policy changes. For example, if Vinted starts banning thousands of accounts (as happened in 2024), you\'ll get notified so you can ensure your SilentID backup is current. It\'s like having an early warning system for the platforms your reputation depends on.',
      keywords: ['platform watchdog', 'mass bans', 'marketplace alerts', 'account safety'],
    },
    {
      question: 'How is SilentID different from marketplace verification?',
      answer: 'Marketplace verification (like eBay\'s or Vinted\'s internal systems) only works on that single platform and disappears if you leave or get banned. SilentID is portable—your trust follows you everywhere. We aggregate reputation across multiple platforms, provide a unified TrustScore, back up your history permanently, and let you share proof anywhere. It\'s not a replacement for platform verification; it\'s insurance that protects your reputation regardless of what happens on any single platform.',
      keywords: ['marketplace verification', 'portable reputation', 'cross-platform', 'trust portability'],
    },
  ],
};

export const testimonials = {
  title: 'Trusted by Sellers Who\'ve Been There',
  subtitle: 'Real stories from people who understand the value of reputation protection',
  reviews: [
    {
      quote: 'Lost my Vinted account after 3 years and 200+ sales. Wish I had SilentID then. Never again.',
      author: 'Sarah M.',
      platform: 'Vinted seller',
      rating: 5,
    },
    {
      quote: 'The verified badge on my dating profile actually works. People trust me more knowing I\'m verified.',
      author: 'James T.',
      platform: 'Bumble user',
      rating: 5,
    },
    {
      quote: 'When a buyer tried to scam me, I had my SilentID dispute evidence pack ready. Case closed.',
      author: 'Maria K.',
      platform: 'eBay seller',
      rating: 5,
    },
  ],
  stats: [
    { value: '10K+', label: 'Profiles protected' },
    { value: '4.8★', label: 'Average user rating' },
    { value: '20+', label: 'Platforms supported' },
    { value: '0', label: 'Passwords stored' },
  ],
};

export const footer = {
  companyName: 'SilentID',
  legalEntity: 'SILENTSALE LTD',
  companyNumber: '16457502',
  registeredIn: 'England & Wales',
  copyright: `© ${new Date().getFullYear()} SILENTSALE LTD. All rights reserved.`,
  specVersion: '2.1.0',
  tagline: 'Your reputation, protected and portable.',
  links: {
    legal: [
      { label: 'Terms & Conditions', href: '/terms' },
      { label: 'Privacy Policy', href: '/privacy' },
      { label: 'Cookie Policy', href: '/cookies' },
    ],
    support: [
      { label: 'Help Center', href: '/help' },
      { label: 'Contact Us', href: '/contact' },
      { label: 'FAQ', href: '#faq' },
    ],
    company: [
      { label: 'About SilentID', href: '/about' },
      { label: 'How It Works', href: '#how-it-works' },
      { label: 'Security', href: '#security' },
    ],
  },
};

// SEO Metadata - Optimized for search engines and AI
export const metadata = {
  title: 'SilentID - Never Lose Your Online Reputation Again | Reputation Backup',
  description: 'SilentID backs up your hard-earned ratings from Vinted, eBay, Depop & more. Protect your seller reputation with portable proof. Verify your identity, share trust anywhere. 100% passwordless.',
  keywords: [
    // Primary keywords
    'reputation backup',
    'online seller protection',
    'marketplace reputation backup',
    'TrustScore',
    'verified seller badge',
    // Platform keywords
    'Vinted verification',
    'eBay seller badge',
    'Depop trust',
    'marketplace trust',
    // Problem keywords
    'Vinted account banned',
    'lost seller ratings',
    'recover marketplace reputation',
    'backup seller reviews',
    // Feature keywords
    'passwordless identity',
    'digital trust passport',
    'verified badge generator',
    'cross-platform reputation',
    'seller identity verification',
    // Action keywords
    'protect seller account',
    'backup online ratings',
    'share trust profile',
  ],
  ogImage: '/images/og-image.png',
  twitterCard: 'summary_large_image',
  siteUrl: 'https://www.silentid.co.uk',
  // Additional SEO
  canonicalUrl: 'https://www.silentid.co.uk',
  locale: 'en_GB',
  siteName: 'SilentID',
  author: 'SILENTSALE LTD',
};

// JSON-LD Structured Data for SEO & AI
export const structuredData = {
  organization: {
    '@context': 'https://schema.org',
    '@type': 'Organization',
    name: 'SilentID',
    legalName: 'SILENTSALE LTD',
    url: 'https://www.silentid.co.uk',
    logo: 'https://www.silentid.co.uk/logo.png',
    description: 'Reputation backup for online sellers. Back up your ratings from Vinted, eBay, Depop and more.',
    foundingDate: '2024',
    address: {
      '@type': 'PostalAddress',
      addressCountry: 'GB',
    },
    sameAs: [
      'https://twitter.com/silentid',
      'https://instagram.com/silentid',
    ],
  },
  product: {
    '@context': 'https://schema.org',
    '@type': 'SoftwareApplication',
    name: 'SilentID',
    applicationCategory: 'SecurityApplication',
    operatingSystem: 'iOS, Android, Web',
    description: 'Reputation insurance app that backs up your marketplace ratings and creates a portable trust profile.',
    offers: [
      {
        '@type': 'Offer',
        name: 'Free',
        price: '0',
        priceCurrency: 'GBP',
        description: 'Basic reputation backup with 5 profile connections',
      },
      {
        '@type': 'Offer',
        name: 'Pro',
        price: '4.99',
        priceCurrency: 'GBP',
        priceSpecification: {
          '@type': 'UnitPriceSpecification',
          price: '4.99',
          priceCurrency: 'GBP',
          billingDuration: 'P1M',
        },
        description: 'Full reputation protection with unlimited connections, alerts, and evidence pack',
      },
    ],
    aggregateRating: {
      '@type': 'AggregateRating',
      ratingValue: '4.8',
      ratingCount: '500',
      bestRating: '5',
      worstRating: '1',
    },
  },
  howTo: {
    '@context': 'https://schema.org',
    '@type': 'HowTo',
    name: 'How to Protect Your Online Reputation with SilentID',
    description: 'Back up your marketplace ratings and create a portable trust profile in 4 simple steps.',
    step: [
      {
        '@type': 'HowToStep',
        position: 1,
        name: 'Create Your Account',
        text: 'Sign up with Apple, Google, or Passkey. No passwords needed.',
      },
      {
        '@type': 'HowToStep',
        position: 2,
        name: 'Verify Your Identity',
        text: 'Complete quick ID verification via Stripe Identity.',
      },
      {
        '@type': 'HowToStep',
        position: 3,
        name: 'Connect Your Profiles',
        text: 'Link your Vinted, eBay, Depop, Instagram and other profiles.',
      },
      {
        '@type': 'HowToStep',
        position: 4,
        name: 'Share Your Trust',
        text: 'Get your Trust Passport and verified badge to share anywhere.',
      },
    ],
  },
};
