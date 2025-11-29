/**
 * Help Center Data Structure
 * Parsed from docs/help/HELP_CENTER.md
 */

export interface HelpArticle {
  id: string;
  slug: string;
  title: string;
  category: string;
  categorySlug: string;
  summary: string;
  infoPointKey?: string;
  screenPath?: string;
  infoPointSummary?: string;
  content: string;
}

export interface HelpCategory {
  id: string;
  slug: string;
  title: string;
  description: string;
  icon: string;
  articles: HelpArticle[];
}

// Categories with metadata
export const helpCategories: HelpCategory[] = [
  {
    id: '1',
    slug: 'getting-started',
    title: 'Getting Started',
    description: 'Learn the basics of SilentID and set up your account',
    icon: 'rocket',
    articles: [],
  },
  {
    id: '2',
    slug: 'login-security',
    title: 'Passwordless Login & Security',
    description: 'Understand passwordless authentication and security features',
    icon: 'shield',
    articles: [],
  },
  {
    id: '3',
    slug: 'trustscore',
    title: 'TrustScore',
    description: 'How your TrustScore works and how to improve it',
    icon: 'chart',
    articles: [],
  },
  {
    id: '4',
    slug: 'profile-linking',
    title: 'Profile Linking & Verification',
    description: 'Connect and verify your external profiles',
    icon: 'link',
    articles: [],
  },
  {
    id: '5',
    slug: 'evidence',
    title: 'Evidence & Receipts',
    description: 'Add receipts and screenshots to your Evidence Vault',
    icon: 'folder',
    articles: [],
  },
  {
    id: '6',
    slug: 'sharing',
    title: 'Public Trust Passport & Sharing',
    description: 'Share your trust profile with others',
    icon: 'share',
    articles: [],
  },
  {
    id: '7',
    slug: 'privacy',
    title: 'Privacy, Data & Controls',
    description: 'Manage your data and privacy settings',
    icon: 'lock',
    articles: [],
  },
  {
    id: '8',
    slug: 'troubleshooting',
    title: 'Troubleshooting & Common Issues',
    description: 'Solutions for common problems',
    icon: 'help',
    articles: [],
  },
];

// All articles data
export const helpArticles: HelpArticle[] = [
  // ============================================================================
  // 1. GETTING STARTED
  // ============================================================================
  {
    id: '1.1',
    slug: 'what-is-silentid',
    title: 'What is SilentID?',
    category: 'Getting Started',
    categorySlug: 'getting-started',
    summary: 'Learn what SilentID is and how it helps you build trust online.',
    infoPointKey: 'trustScoreOverall',
    screenPath: 'Home',
    infoPointSummary: 'SilentID is your portable digital reputation. Build trust once, share everywhere.',
    content: `SilentID is a standalone trust-identity application that allows you to build a portable reputation profile. Think of it as your digital passport for trust - proving to others that you're a reliable person to deal with online.

## How does it work?

1. **Create your account** using passwordless login (Apple, Google, Passkey, or Email)
2. **Build your TrustScore** by verifying your identity and adding evidence
3. **Connect your profiles** from marketplaces like Vinted, eBay, and Depop
4. **Share your trust** with a public link or QR code anywhere you need it

## Why use SilentID?

- **Portable reputation**: Your trust follows you across platforms
- **Evidence-based**: Real proof, not just self-claims
- **Privacy-first**: You control what's visible
- **Passwordless security**: No passwords to remember or lose

## FAQs

**Q: Is SilentID free?**
A: Yes, the core features are free. Premium plans unlock additional storage and analytics.

**Q: Can I use SilentID internationally?**
A: Yes, SilentID works worldwide.

**Q: Do I need to connect all my accounts?**
A: No, you choose which profiles to connect and what to share publicly.`,
  },
  {
    id: '1.2',
    slug: 'creating-your-account',
    title: 'Creating Your Account',
    category: 'Getting Started',
    categorySlug: 'getting-started',
    summary: 'How to sign up for SilentID using passwordless authentication.',
    infoPointKey: 'whyNoPasswords',
    screenPath: 'Login / Sign Up',
    infoPointSummary: 'Create your SilentID account in seconds using Apple, Google, Passkey, or Email - no password needed.',
    content: `SilentID is 100% passwordless - you'll never need to create, remember, or reset a password.

## Step-by-step

1. Open the SilentID app
2. Tap "Get Started"
3. Choose your login method:
   - **Apple Sign-In** (recommended for iPhone users)
   - **Google Sign-In** (recommended for Android users)
   - **Passkey** (use Face ID or fingerprint)
   - **Email** (receive a 6-digit code)
4. Complete the verification
5. You're in!

## Have a referral code?

If a friend invited you, you can enter their referral code during sign-up. When you complete identity verification, you'll both receive +50 TrustScore points.

## One email, one account

SilentID uses your email as your identity anchor. Each email address can only be linked to one account.

## FAQs

**Q: Can I change my email later?**
A: Currently, your email is permanent. Contact support for assistance.

**Q: What if I already have an account with this email?**
A: You'll be signed into your existing account automatically.

**Q: Is my data safe?**
A: Absolutely. We use bank-level security and never store passwords.`,
  },
  {
    id: '1.3',
    slug: 'your-first-trustscore',
    title: 'Your First TrustScore',
    category: 'Getting Started',
    categorySlug: 'getting-started',
    summary: 'Understanding what your initial TrustScore means and how to improve it.',
    infoPointKey: 'trustScoreOverall',
    screenPath: 'Home → TrustScore Card',
    infoPointSummary: 'Your TrustScore (0-1000) shows how trustworthy you appear online. Higher is better.',
    content: `When you create your account, you'll start with a basic TrustScore. Don't worry if it's low - everyone starts somewhere!

## What determines your starting score?

Your initial score is based on:
- Email verification (you've already done this!)
- Account creation

## How to improve quickly

1. **Verify your identity** with Stripe (+200 points potential)
2. **Connect a profile** from Vinted, eBay, or similar (+5-15 points each)
3. **Forward receipts** from marketplace purchases (+points for each valid receipt)

## Understanding the score

- **0-1000 scale**: Higher is better
- **Three components**: Identity, Evidence, and Behaviour
- **Weekly updates**: Your score regenerates weekly

## FAQs

**Q: Why is my starting score low?**
A: New accounts start with limited data. Build your score by adding evidence and verifying your identity.

**Q: How quickly can I improve?**
A: Most users can reach a "High Trust" score within a few weeks of active use.`,
  },
  {
    id: '1.4',
    slug: 'home-screen',
    title: 'Understanding the Home Screen',
    category: 'Getting Started',
    categorySlug: 'getting-started',
    summary: 'A guide to the SilentID Home screen and its features.',
    screenPath: 'Home',
    infoPointSummary: 'Your Home screen shows your TrustScore, quick actions, and progress at a glance.',
    content: `Your Home screen is your command center for building trust.

## What you'll see

1. **TrustScore Card**: Your current score with a tap-to-view breakdown
2. **Identity Status**: Shows if you're verified or have pending verification
3. **Evidence Summary**: Count of receipts, screenshots, and connected profiles
4. **Onboarding Checklist**: (New users) Steps to boost your score quickly
5. **Quick Actions**: Add evidence, share passport, view profiles

## Navigation

The bottom navigation bar has 5 tabs:
- **Home**: Overview and quick actions
- **Evidence**: Your Evidence Vault
- **Profile**: Your public passport preview
- **Security**: Login history and security settings
- **Settings**: App preferences and account settings

## FAQs

**Q: How do I get to my TrustScore breakdown?**
A: Tap on your TrustScore card on the Home screen.

**Q: Where do I add new evidence?**
A: Use the Evidence tab or the quick action buttons on Home.`,
  },
  {
    id: '1.5',
    slug: 'onboarding-checklist',
    title: 'The Onboarding Checklist',
    category: 'Getting Started',
    categorySlug: 'getting-started',
    summary: 'How to complete the onboarding checklist and get the most from SilentID.',
    screenPath: 'Home → Onboarding Checklist',
    infoPointSummary: 'Complete 3 quick tasks to boost your TrustScore and unlock your full profile.',
    content: `New users see a 3-step checklist designed to help you build trust quickly.

## The three steps

1. **Verify your identity**
   - Complete identity verification with Stripe
   - Takes about 2 minutes
   - Worth up to 200 points

2. **Connect a profile**
   - Link a marketplace account (Vinted, eBay, Depop, etc.)
   - Paste your profile URL
   - Instant trust boost

3. **Add your first evidence**
   - Forward a receipt or add a screenshot
   - Shows real transaction history
   - Builds your Evidence component

## Tracking progress

- The progress bar fills as you complete steps
- Tap any incomplete step to go directly to that task
- A celebration animation plays when you finish each step

## Can I skip the checklist?

Yes, you can dismiss it anytime. But completing all steps is the fastest way to build a strong TrustScore.

## FAQs

**Q: Do I have to complete all steps?**
A: No, but completing them will significantly boost your TrustScore.

**Q: The checklist disappeared - where is it?**
A: Once completed or dismissed, it won't show again.`,
  },
  {
    id: '1.6',
    slug: 'demo-mode',
    title: 'Demo Mode Preview',
    category: 'Getting Started',
    categorySlug: 'getting-started',
    summary: 'Understanding the demo profile preview feature.',
    screenPath: 'Home → Demo Profile Preview',
    infoPointSummary: 'See what a fully-built SilentID profile looks like before you create yours.',
    content: `Before you've built your profile, SilentID shows you a sample "Alex M." profile to demonstrate what's possible.

## What the demo shows

- **TrustScore**: 650 (High Trust)
- **Connected platforms**: Vinted (4.9 stars), eBay (99%)
- **Evidence stats**: 2 profiles, 47 receipts
- **Verification badges**: Identity verified, profiles connected

## Why we show this

The demo helps you:
- See the value of a complete profile
- Understand what others will see
- Get motivated to build your own trust

## The message

"This could be you in 7 days. Here's how you start."

## FAQs

**Q: Is Alex M. a real person?**
A: No, it's a sample profile for demonstration purposes.

**Q: How long until my profile looks like this?**
A: Most users can build a strong profile within 1-2 weeks of regular use.`,
  },

  // ============================================================================
  // 2. PASSWORDLESS LOGIN & SECURITY
  // ============================================================================
  {
    id: '2.1',
    slug: 'passwordless-explained',
    title: 'What is Passwordless Authentication?',
    category: 'Passwordless Login & Security',
    categorySlug: 'login-security',
    summary: 'Understanding why SilentID doesn\'t use passwords and how passwordless works.',
    infoPointKey: 'whyNoPasswords',
    screenPath: 'Login',
    infoPointSummary: 'Passwords are the #1 cause of account hacks. SilentID uses modern, secure alternatives.',
    content: `Passwords are:
- Easy to forget
- Often reused across sites
- The #1 target for hackers
- A hassle to manage

SilentID eliminates all password-related risks by using modern authentication methods.

## How you log in

Choose one of four secure methods:

1. **Apple Sign-In**: Use your Apple ID
2. **Google Sign-In**: Use your Google account
3. **Passkeys**: Use Face ID, Touch ID, or fingerprint
4. **Email OTP**: Receive a 6-digit code by email

## Is it secure?

Yes. Passwordless authentication is actually more secure than passwords because:
- No password to steal or guess
- Each login is verified independently
- Biometric methods (Face ID) can't be phished

## FAQs

**Q: What if I don't have Apple or Google?**
A: Use Email OTP - we'll send you a code each time you log in.

**Q: Can hackers steal my login?**
A: It's extremely difficult. Unlike passwords, these methods can't be phished or guessed.

**Q: What if I want to use a password?**
A: SilentID is passwordless by design. This makes your account more secure.`,
  },
  {
    id: '2.2',
    slug: 'passkeys',
    title: 'Using Passkeys',
    category: 'Passwordless Login & Security',
    categorySlug: 'login-security',
    summary: 'How to set up and use passkeys with SilentID.',
    infoPointKey: 'passkeys',
    screenPath: 'Settings → Security → Passkeys',
    infoPointSummary: 'Passkeys use Face ID, Touch ID, or fingerprint for instant, secure login.',
    content: `Passkeys are a modern login method that uses your device's biometric sensors (Face ID, Touch ID, or fingerprint) to verify it's really you.

## Why use passkeys?

- **Fastest login**: Just look at your phone or touch the sensor
- **Most secure**: Stored only on your device
- **No codes to enter**: No waiting for emails or texts
- **Phishing-proof**: Can't be tricked by fake websites

## Setting up passkeys

1. Go to **Settings → Security**
2. Tap **Set up Passkey**
3. Verify your identity with an existing login method
4. Follow the prompts to register your biometric
5. Done! Next login, just use Face ID or fingerprint

## Using passkeys to log in

1. Open SilentID
2. Tap "Log in with Passkey"
3. Use Face ID, Touch ID, or your fingerprint
4. You're in!

## FAQs

**Q: Can I use passkeys on multiple devices?**
A: Passkeys are device-specific. Set up separately on each device.

**Q: What if my Face ID doesn't work?**
A: Fall back to Apple/Google Sign-In or Email OTP.

**Q: Are passkeys stored in the cloud?**
A: Your passkey private key stays on your device. Only a public key is stored securely on our servers.`,
  },
  {
    id: '2.3',
    slug: 'apple-sign-in',
    title: 'Apple Sign-In',
    category: 'Passwordless Login & Security',
    categorySlug: 'login-security',
    summary: 'How to use Apple Sign-In with SilentID.',
    screenPath: 'Login → Apple Sign-In',
    infoPointSummary: 'Use your Apple ID to log in securely with Face ID or Touch ID.',
    content: `Apple Sign-In is the recommended login method for iPhone users. It's fast, secure, and integrates seamlessly with your device.

## How it works

1. Tap "Continue with Apple"
2. Use Face ID, Touch ID, or your Apple ID password
3. Apple verifies your identity
4. You're logged into SilentID

## Privacy with Apple

Apple can hide your email address if you choose. However, SilentID needs your email to identify your account, so we recommend sharing it.

## Requirements

- An Apple ID
- iOS device or Mac with Safari
- Face ID, Touch ID, or Apple ID password

## FAQs

**Q: Can I use Apple Sign-In on Android?**
A: No, Apple Sign-In is only available on Apple devices.

**Q: What if I change my Apple ID email?**
A: Your SilentID account remains linked to your original Apple ID.`,
  },
  {
    id: '2.4',
    slug: 'google-sign-in',
    title: 'Google Sign-In',
    category: 'Passwordless Login & Security',
    categorySlug: 'login-security',
    summary: 'How to use Google Sign-In with SilentID.',
    screenPath: 'Login → Google Sign-In',
    infoPointSummary: 'Use your Google account to log in quickly on any device.',
    content: `Google Sign-In works on both Android and iOS devices. It's quick and secure.

## How it works

1. Tap "Continue with Google"
2. Choose your Google account (if you have multiple)
3. Google verifies your identity
4. You're logged into SilentID

## Requirements

- A Google account
- Any device with a browser

## FAQs

**Q: Can I use a Google Workspace account?**
A: Yes, any Google account works.

**Q: What if I have multiple Google accounts?**
A: You can choose which account to use. Your SilentID account is tied to that specific email.`,
  },
  {
    id: '2.5',
    slug: 'email-otp',
    title: 'Email OTP',
    category: 'Passwordless Login & Security',
    categorySlug: 'login-security',
    summary: 'How Email OTP (one-time password) login works.',
    infoPointKey: 'emailOTP',
    screenPath: 'Login → Email OTP',
    infoPointSummary: 'We send a 6-digit code to your email. Enter it within 5 minutes to log in.',
    content: `Email OTP is the simplest login method. We send a 6-digit code to your email, and you enter it to log in.

## How it works

1. Enter your email address
2. Tap "Send Code"
3. Check your email for the 6-digit code
4. Enter the code in SilentID
5. You're logged in!

## Important notes

- Codes expire after **5 minutes**
- You can request up to **3 codes per 5 minutes**
- Check your spam folder if you don't see the email

## When to use Email OTP

- You don't have Apple or Google accounts linked
- Your passkey isn't working
- You're on a new device

## FAQs

**Q: I didn't receive the code?**
A: Check spam/junk folders. Make sure you entered the correct email. Try again after a few minutes.

**Q: The code says "expired"?**
A: Request a new code. Codes only work for 5 minutes.

**Q: Can someone hack my account with just my email?**
A: No. They would also need access to your email inbox.`,
  },
  {
    id: '2.6',
    slug: 'managing-login-methods',
    title: 'Managing Login Methods',
    category: 'Passwordless Login & Security',
    categorySlug: 'login-security',
    summary: 'How to add, remove, and manage your login methods.',
    screenPath: 'Settings → Security',
    infoPointSummary: 'Add multiple login methods for backup and convenience.',
    content: `You can have multiple login methods active at once for convenience and backup.

## Viewing your methods

1. Go to **Settings → Security**
2. See all your active login methods
3. Each shows when it was last used

## Adding a new method

1. Tap "Add Login Method"
2. Choose Apple, Google, Passkey, or Email
3. Complete the verification process
4. The new method is now active

## Recommended setup

- **Primary**: Apple or Google Sign-In
- **Backup**: Passkey (for quick access)
- **Fallback**: Email OTP (always available)

## Removing a method

You can remove login methods, but you must always have at least one active method.

1. Tap the method you want to remove
2. Confirm removal
3. The method is deactivated

## FAQs

**Q: Can I use different methods on different devices?**
A: Yes. Use whatever's most convenient on each device.

**Q: What if I lose access to all methods?**
A: You can recover your account by re-verifying your identity with Stripe.`,
  },
  {
    id: '2.7',
    slug: 'security-center',
    title: 'Security Center Overview',
    category: 'Passwordless Login & Security',
    categorySlug: 'login-security',
    summary: 'Understanding the Security Center and staying safe.',
    infoPointKey: 'deviceSecurity',
    screenPath: 'Security (bottom tab)',
    infoPointSummary: 'Your Security Center shows login history, devices, and any security alerts.',
    content: `The Security Center is your hub for monitoring account security and managing devices.

## What you'll find

1. **Risk Indicator**: Shows Low, Medium, or High risk status
2. **Login History**: Recent login attempts and locations
3. **Active Devices**: Devices currently logged into your account
4. **Security Alerts**: Any suspicious activity notifications

## Understanding the Risk Indicator

- **Low Risk** (Green): Everything looks normal
- **Medium Risk** (Amber): Some unusual activity detected
- **High Risk** (Red): Immediate attention needed

## What triggers alerts

- Login from a new device
- Login from an unusual location
- Multiple failed login attempts
- Suspicious evidence uploads

## What to do if you see a suspicious login

1. Check if it was you
2. If not, tap "Not me" on the login entry
3. SilentID will secure your account
4. Change your primary login method if needed

## FAQs

**Q: Why do I see a login I don't recognise?**
A: Check if it was a different device or browser. If truly unknown, report it.

**Q: How often should I check Security Center?**
A: We'll notify you of anything urgent. Check occasionally for peace of mind.`,
  },

  // ============================================================================
  // 3. TRUSTSCORE
  // ============================================================================
  {
    id: '3.1',
    slug: 'how-it-works',
    title: 'How TrustScore Works',
    category: 'TrustScore',
    categorySlug: 'trustscore',
    summary: 'A complete guide to how TrustScore is calculated.',
    infoPointKey: 'trustScoreOverall',
    screenPath: 'Home → TrustScore Card → Breakdown',
    infoPointSummary: 'Your TrustScore (0-1000) combines Identity, Evidence, and Behaviour to show your trustworthiness.',
    content: `TrustScore is a number from 0 to 1000 that represents how trustworthy you appear to others online. Higher is better.

## The Three Components

Your TrustScore is calculated from three components:

| Component | Max Points | What It Measures |
|-----------|------------|------------------|
| Identity | 250 | Who you are (verified identity) |
| Evidence | 400 | What you can prove (receipts, profiles) |
| Behaviour | 350 | How you act (account patterns, reports) |

**Total Maximum: 1000 points**

## The Formula

TrustScore = Identity + Evidence + Behaviour

No complicated maths - your score is simply the sum of your three components.

## Weekly Regeneration

Your TrustScore recalculates every week to reflect:
- New evidence you've added
- Changes in your behaviour patterns
- Updated information from connected profiles

## FAQs

**Q: Can my score go down?**
A: Yes, if safety reports are filed against you or if suspicious activity is detected.

**Q: How quickly can I improve my score?**
A: Most users see significant improvement within 2-3 weeks of active use.

**Q: Do other users see my exact score?**
A: Only if you set your visibility to Public. You can also show just your tier.`,
  },
  {
    id: '3.2',
    slug: 'identity-component',
    title: 'Identity Component',
    category: 'TrustScore',
    categorySlug: 'trustscore',
    summary: 'Understanding the Identity component of your TrustScore.',
    infoPointKey: 'identityComponent',
    screenPath: 'Home → TrustScore → Breakdown → Identity',
    infoPointSummary: 'Worth up to 250 points. Earned by verifying who you are.',
    content: `The Identity component measures how well you've verified who you are.

## How points are earned

| Action | Points |
|--------|--------|
| Email verified | ~50 |
| Stripe Identity verification | ~150 |
| Passkey set up | ~25 |
| Phone verified (if applicable) | ~25 |

## Stripe Identity Verification

This is the most valuable part of your Identity score. It confirms you're a real person with a government-issued ID.

**How it works:**
1. Tap "Verify Identity" in the app
2. You're directed to Stripe's secure verification
3. Take a photo of your ID and a selfie
4. Stripe confirms your identity
5. We receive confirmation (but never your documents)

**Important:** SilentID never sees or stores your ID documents. Stripe handles this securely.

## FAQs

**Q: Why is identity verification so many points?**
A: It's the strongest proof that you're a real, verified person.

**Q: What if my verification fails?**
A: You can retry up to 3 times per 24 hours. Make sure your ID photo is clear.

**Q: Is my ID stored?**
A: No. Stripe stores your verification data. We only receive a yes/no confirmation.`,
  },
  {
    id: '3.3',
    slug: 'evidence-component',
    title: 'Evidence Component',
    category: 'TrustScore',
    categorySlug: 'trustscore',
    summary: 'Understanding the Evidence component of your TrustScore.',
    infoPointKey: 'evidenceComponent',
    screenPath: 'Home → TrustScore → Breakdown → Evidence',
    infoPointSummary: 'Worth up to 400 points. Earned by uploading proof of trustworthy transactions.',
    content: `The Evidence component measures the proof you've provided of trustworthy activity.

## Types of evidence

1. **Email Receipts**: Forward purchase confirmations from marketplaces
2. **Screenshots**: Capture your seller ratings and reviews
3. **Connected Profiles**: Link your marketplace accounts
   - Linked profiles: +5 points each (max 25)
   - Verified profiles: +15 points each (max 75)

## How points are calculated

| Evidence Type | Points per Item | Maximum |
|---------------|-----------------|---------|
| Receipts | ~10 each | ~150 |
| Screenshots | ~5 each | ~75 |
| Linked Profiles | 5 each | 25 |
| Verified Profiles | 15 each | 75 |

## Quality matters

- Higher-value transactions = more points
- Verified profiles = more points than linked
- Consistent evidence over time = bonus points
- Multiple platforms = diversity bonus

## FAQs

**Q: How many receipts should I add?**
A: More is better, but quality matters too. Focus on verified marketplace transactions.

**Q: Do screenshots from any platform count?**
A: Screenshots should show your seller ratings or reviews from marketplaces.

**Q: What's the difference between linked and verified?**
A: Verified profiles have confirmed ownership (you proved it's really your account).`,
  },
  {
    id: '3.4',
    slug: 'behaviour-component',
    title: 'Behaviour Component',
    category: 'TrustScore',
    categorySlug: 'trustscore',
    summary: 'Understanding the Behaviour component of your TrustScore.',
    infoPointKey: 'behaviourComponent',
    screenPath: 'Home → TrustScore → Breakdown → Behaviour',
    infoPointSummary: 'Worth up to 350 points. Based on your account history and patterns.',
    content: `The Behaviour component reflects how you use your account over time.

## What affects Behaviour score

**Positive factors:**
- Account age (longer = better)
- Consistent login patterns
- Regular engagement with the app
- No safety reports against you
- Stable device usage

**Negative factors:**
- Safety reports from other users
- Suspicious login patterns
- Evidence integrity concerns
- Account restriction history

## Building Behaviour score

Unlike Identity and Evidence, you can't "add" behaviour - it develops over time through normal, trustworthy use of the app.

**Tips:**
- Use the app regularly
- Don't do anything that might concern other users
- Keep your login patterns consistent
- Respond to any security alerts promptly

## FAQs

**Q: How long does it take to build Behaviour score?**
A: It grows gradually. Most users see meaningful Behaviour points after a few weeks.

**Q: Can reports against me be appealed?**
A: Yes. Contact support to review any reports you believe are unfair.

**Q: Does inactivity hurt my score?**
A: Extended inactivity won't remove points, but active engagement helps.`,
  },
  {
    id: '3.5',
    slug: 'labels-explained',
    title: 'TrustScore Labels Explained',
    category: 'TrustScore',
    categorySlug: 'trustscore',
    summary: 'What each TrustScore label means.',
    infoPointKey: 'trustScoreTiers',
    screenPath: 'Home → TrustScore Card',
    infoPointSummary: 'TrustScore labels help others quickly understand your trust level.',
    content: `Instead of just numbers, SilentID shows labels to make trust levels easy to understand.

## The Labels

| Score Range | Label | Meaning |
|-------------|-------|---------|
| 850-1000 | Exceptional | Outstanding reputation - highest trust |
| 700-849 | Very High | Excellent reputation - very trusted |
| 550-699 | High | Good reputation - trusted |
| 400-549 | Moderate | Building reputation - some trust |
| 250-399 | Low | Limited reputation - developing |
| 0-249 | High Risk | Needs improvement - proceed with caution |

## What labels tell others

When someone views your profile:
- **Exceptional/Very High**: They can feel confident dealing with you
- **High/Moderate**: They have reasonable assurance
- **Low/High Risk**: They may want to proceed carefully

## Improving your label

Move up to the next tier by:
1. Completing identity verification (+200 points)
2. Adding more evidence (+points per item)
3. Maintaining good behaviour over time

## FAQs

**Q: Can I hide my label?**
A: Yes, use "Private Mode" to hide both score and label.

**Q: How is "High Risk" determined?**
A: Usually due to very low scores, safety reports, or suspicious activity.`,
  },
  {
    id: '3.6',
    slug: 'improving-score',
    title: 'Improving Your TrustScore',
    category: 'TrustScore',
    categorySlug: 'trustscore',
    summary: 'Practical tips to boost your TrustScore quickly.',
    screenPath: 'Home → TrustScore → Tips',
    infoPointSummary: 'Focus on identity verification first, then add evidence steadily.',
    content: `## Quick Wins (Do These First)

1. **Verify your identity** (up to +200 points)
   - The single biggest boost available
   - Takes only 2-3 minutes
   - Go to Settings → Verify Identity

2. **Connect your profiles** (up to +75 points for verified)
   - Link Vinted, eBay, Depop, etc.
   - Verify ownership for maximum points
   - Go to Profile → Connect Profiles

3. **Forward receipts** (up to +150 points)
   - Set up email forwarding
   - Each receipt adds points
   - Go to Evidence → Email Receipts

## Building Over Time

4. **Stay active**
   - Regular logins build Behaviour score
   - Check in at least weekly

5. **Add screenshots**
   - Capture your seller ratings
   - Show positive reviews

6. **Keep security tight**
   - Set up a passkey
   - Respond to security alerts

## What NOT to do

- Don't upload fake or edited evidence
- Don't create multiple accounts
- Don't do anything that might get reported

## FAQs

**Q: What's the fastest way to improve?**
A: Identity verification gives the biggest immediate boost.

**Q: My score isn't changing - why?**
A: Scores update weekly. New evidence will show in your next recalculation.`,
  },
  {
    id: '3.7',
    slug: 'history',
    title: 'TrustScore History',
    category: 'TrustScore',
    categorySlug: 'trustscore',
    summary: 'Understanding your TrustScore history and trends.',
    screenPath: 'Home → TrustScore → History',
    infoPointSummary: 'Track how your TrustScore has changed over time.',
    content: `SilentID keeps a record of your TrustScore snapshots so you can see your progress.

## What the history shows

- **Weekly snapshots**: Your score at each weekly recalculation
- **Trend line**: Visual graph of your progress
- **Change indicators**: Up/down arrows showing week-over-week change

## Reading the graph

- **Upward trend**: You're building trust effectively
- **Flat line**: Stable score (not bad, but room to grow)
- **Downward trend**: Something may need attention

## Why scores change

**Score increases:**
- Added new evidence
- Completed identity verification
- Account aging naturally
- Verified a connected profile

**Score decreases:**
- Safety report filed against you
- Evidence flagged for integrity issues
- Long inactivity period

## FAQs

**Q: How far back does history go?**
A: We store your complete history from account creation.

**Q: Can I export my history?**
A: Yes, through Settings → Privacy → Export Data.

**Q: Weekly updates seem slow - can I trigger a recalculation?**
A: Major changes (like identity verification) may trigger immediate updates.`,
  },

  // ============================================================================
  // 4. PROFILE LINKING & VERIFICATION
  // ============================================================================
  {
    id: '4.1',
    slug: 'why-connect',
    title: 'Why Connect Profiles?',
    category: 'Profile Linking & Verification',
    categorySlug: 'profile-linking',
    summary: 'The benefits of linking your marketplace and social profiles.',
    infoPointKey: 'connectedProfiles',
    screenPath: 'Profile → Connect Profiles',
    infoPointSummary: 'Connected profiles prove your online presence and help others trust you faster.',
    content: `Connecting your profiles to SilentID shows others that you have an established presence online.

## Benefits

1. **Build stronger reputation**
   - Your ratings from Vinted, eBay, etc. become part of your trust profile
   - Shows consistency across platforms

2. **Prove identity**
   - Multiple connected profiles prove you're a real, active person
   - Harder for fraudsters to fake

3. **Help others trust you**
   - Buyers/sellers can see your full track record
   - Makes transactions smoother

4. **You control visibility**
   - Choose which profiles appear on your public passport
   - Hide any you prefer to keep private

## What happens when you connect?

- Your profile link is saved
- SilentID may display your ratings if you verify ownership
- Your TrustScore gets a boost
- The profile shows on your passport (unless you hide it)

## FAQs

**Q: Do I have to connect all my accounts?**
A: No, it's entirely optional. Connect whatever you're comfortable sharing.

**Q: Can people message me through connected profiles?**
A: No, SilentID only displays links. All messaging happens on the original platform.

**Q: Is connecting safe?**
A: Yes. We never post to your accounts or access your login credentials.`,
  },
  {
    id: '4.2',
    slug: 'linked-vs-verified',
    title: 'Linked vs Verified Status',
    category: 'Profile Linking & Verification',
    categorySlug: 'profile-linking',
    summary: 'Understanding the difference between Linked and Verified profile states.',
    infoPointKey: 'linkedProfile',
    screenPath: 'Profile → Connected Profiles',
    infoPointSummary: 'Linked means you added it. Verified means you proved you own it.',
    content: `When you connect a profile, it can be in one of two states:

## Linked

- **What it means**: You added this profile URL to SilentID
- **Trust level**: Basic - we haven't confirmed you own it
- **Points**: +5 TrustScore points (max 25 from linked profiles)
- **Badge**: Shows as "Linked" on your passport
- **Upgrade**: Can be upgraded to Verified anytime

## Verified

- **What it means**: You proved you own this account
- **Trust level**: Strong - ownership confirmed
- **Points**: +15 TrustScore points (max 75 from verified profiles)
- **Badge**: Shows as "Verified" with a green checkmark
- **How to get it**: Complete token or screenshot verification

## Why verification matters

Verified profiles are worth 3x more points because they prove:
- You actually own the account
- You're not claiming someone else's reputation
- Your connected identity is real

## How to upgrade to Verified

1. Go to Profile → Connected Profiles
2. Find the profile you want to verify
3. Tap "Upgrade to Verified"
4. Choose Token or Screenshot verification
5. Complete the process

## FAQs

**Q: Can I leave profiles as Linked?**
A: Yes, Linked profiles still give some trust boost.

**Q: Does Verified mean SilentID can access my account?**
A: No. We only confirm you own it - we never access your login.`,
  },
  {
    id: '4.3',
    slug: 'supported-platforms',
    title: 'Supported Platforms',
    category: 'Profile Linking & Verification',
    categorySlug: 'profile-linking',
    summary: 'List of platforms you can connect to SilentID.',
    screenPath: 'Profile → Connect Profiles → Platform List',
    infoPointSummary: 'Connect profiles from 16+ marketplaces, social platforms, and communities.',
    content: `SilentID supports profiles from these categories:

## Marketplaces

| Platform | Verification Methods |
|----------|---------------------|
| Vinted | Token, Screenshot |
| eBay | Token, Screenshot |
| Depop | Token, Screenshot |
| Etsy | Token, Screenshot |
| Poshmark | Token, Screenshot |
| Facebook Marketplace | Screenshot |

## Social Media

| Platform | Verification Methods |
|----------|---------------------|
| Instagram | Token, Screenshot |
| TikTok | Token, Screenshot |
| Twitter/X | Token, Screenshot |
| YouTube | Token, Screenshot |
| Snapchat | Screenshot |

## Professional

| Platform | Verification Methods |
|----------|---------------------|
| LinkedIn | Token, Screenshot |
| GitHub | Token, Screenshot |

## Gaming & Community

| Platform | Verification Methods |
|----------|---------------------|
| Discord | Token, Screenshot |
| Twitch | Token, Screenshot |
| Steam | Token, Screenshot |
| Reddit | Token, Screenshot |

## Don't see your platform?

We're always adding more. If you'd like to request a platform:
1. Go to Settings → Feedback
2. Tell us which platform you want
3. We'll consider it for future updates

## FAQs

**Q: Why can't all platforms use Token verification?**
A: Some platforms don't allow bio/profile editing, so only Screenshot works.

**Q: Can I add a platform that's not listed?**
A: Not currently, but you can request it through feedback.`,
  },
  {
    id: '4.4',
    slug: 'adding-profile',
    title: 'Adding a Profile',
    category: 'Profile Linking & Verification',
    categorySlug: 'profile-linking',
    summary: 'Step-by-step guide to adding a new connected profile.',
    screenPath: 'Profile → Connect Profiles → Add Profile',
    infoPointSummary: 'Paste your profile URL to add it to SilentID instantly.',
    content: `Connecting a profile is quick and easy.

## Step-by-step

1. **Go to Profile → Connect Profiles**
2. **Tap "Add Profile"**
3. **Paste your profile URL**
   - Copy the link from your profile on the other platform
   - Example: https://www.vinted.co.uk/member/12345-username
4. **Wait for detection**
   - SilentID automatically detects the platform
   - Your username is extracted
5. **Confirm the details**
   - Check the platform and username are correct
   - Tap "Add Profile"
6. **Done!**
   - Your profile is now Linked
   - You can upgrade to Verified anytime

## Tips for getting the right URL

- Go to your profile page on the other platform
- Copy the URL from the address bar
- Make sure it's YOUR profile, not someone else's

## What happens next

- The profile appears in your Connected Profiles
- It shows as "Linked" (unverified)
- It contributes +5 points to your TrustScore
- It appears on your public passport (unless you hide it)

## FAQs

**Q: Can I add the same profile twice?**
A: No, each profile can only be added once.

**Q: What if the URL isn't detected?**
A: Make sure you're pasting the full URL. Try copying it fresh from your browser.

**Q: Can I remove a profile later?**
A: Yes, go to Connected Profiles and tap the profile to remove it.`,
  },
  {
    id: '4.5',
    slug: 'token-verification',
    title: 'Token Verification',
    category: 'Profile Linking & Verification',
    categorySlug: 'profile-linking',
    summary: 'How to verify profile ownership using the token method.',
    infoPointKey: 'tokenVerification',
    screenPath: 'Profile → Connected Profiles → Upgrade → Token',
    infoPointSummary: 'Add a short code to your profile bio to prove ownership. Remove it after verification.',
    content: `Token verification is the strongest way to prove you own a profile. You temporarily add a code to your bio, and SilentID confirms it.

## Step-by-step

1. **Tap "Upgrade to Verified" on your linked profile**
2. **Choose "Token Verification"**
3. **Copy the verification token**
   - It looks like: SilentID-verify-X4K9M
4. **Add the token to your profile bio**
   - Go to the platform (Vinted, eBay, etc.)
   - Edit your profile/bio
   - Paste the token anywhere in your bio
   - Save your changes
5. **Return to SilentID and tap "Check Now"**
6. **Verification complete!**
   - You can now remove the token from your bio
   - Your profile status changes to Verified

## Platform-specific tips

| Platform | Where to add token |
|----------|-------------------|
| Vinted | Profile → Edit → About Me |
| eBay | My eBay → Account Settings → Personal Information |
| Instagram | Edit Profile → Bio |
| LinkedIn | Edit Profile → About section |

## Important notes

- You can remove the token after verification
- The token is unique to your account
- Don't share your token with others

## FAQs

**Q: How long does verification take?**
A: Usually a few seconds after you tap "Check Now."

**Q: The token wasn't found - why?**
A: See our troubleshooting guide for common fixes.

**Q: Can I use the same token for multiple profiles?**
A: No, each profile gets a unique token.`,
  },
  {
    id: '4.6',
    slug: 'screenshot-verification',
    title: 'Screenshot Verification',
    category: 'Profile Linking & Verification',
    categorySlug: 'profile-linking',
    summary: 'How to verify profile ownership using screenshots.',
    infoPointKey: 'screenshotVerification',
    screenPath: 'Profile → Connected Profiles → Upgrade → Screenshot',
    infoPointSummary: 'Use your camera to take a live photo of your profile screen when token verification isn\'t possible.',
    content: `Some platforms don't allow bio editing. In these cases, use Screenshot verification instead.

## How it works

SilentID uses your device's camera to take a **live photo** of your profile screen. This proves you have access to the account.

## Step-by-step

1. **Tap "Upgrade to Verified" on your linked profile**
2. **Choose "Screenshot Verification"**
3. **Open the platform on another device or browser**
   - Navigate to your profile page
   - Make sure your username is visible
4. **Use SilentID's camera to capture your screen**
   - Point your phone at the screen showing your profile
   - Make sure the username is clearly visible
5. **Review the photo**
   - If it's clear, tap "Verify"
   - If not, tap "Retake"
6. **Wait for verification**
   - SilentID checks the image
   - Your profile becomes Verified

## Why a live photo?

We require live camera capture (not gallery uploads) to prevent:
- Screenshot manipulation
- Using someone else's profile
- Edited or fake screenshots

## FAQs

**Q: Can I upload a screenshot from my gallery?**
A: No, only live camera photos are accepted to ensure authenticity.

**Q: My photo was rejected - why?**
A: See our troubleshooting guide for common issues.

**Q: Is token verification better?**
A: Token verification is stronger, but screenshot works when token isn't possible.`,
  },
  {
    id: '4.7',
    slug: 'managing-profiles',
    title: 'Managing Connected Profiles',
    category: 'Profile Linking & Verification',
    categorySlug: 'profile-linking',
    summary: 'How to manage your connected profiles.',
    screenPath: 'Profile → Connected Profiles',
    infoPointSummary: 'View, verify, hide, or remove your connected profiles anytime.',
    content: `All your connected profiles are managed from one place.

## Viewing your profiles

1. Go to **Profile → Connected Profiles**
2. See all your connections with their status:
   - **Verified** (green checkmark)
   - **Linked** (chain icon)
3. View summary: "X Verified, Y Linked"

## Upgrading to Verified

1. Find a Linked profile
2. Tap "Upgrade to Verified"
3. Choose Token or Screenshot verification
4. Complete the process

## Hiding from your Passport

You can hide profiles from your public passport while keeping them for your TrustScore:

1. Tap the profile
2. Toggle "Show on Passport" off
3. The profile won't appear publicly

## Removing a profile

1. Tap the profile
2. Tap "Remove Profile"
3. Confirm removal

**Note:** Removing a profile will reduce your TrustScore by the points it contributed.

## FAQs

**Q: If I hide a profile, does it still count for TrustScore?**
A: Yes, hiding only affects your public passport view.

**Q: Can I re-add a removed profile?**
A: Yes, just add it again like before.

**Q: Why would I want to hide a profile?**
A: Personal preference - maybe you want to keep professional and personal separate.`,
  },

  // ============================================================================
  // 5. EVIDENCE & RECEIPTS
  // ============================================================================
  {
    id: '5.1',
    slug: 'vault-overview',
    title: 'Evidence Vault Overview',
    category: 'Evidence & Receipts',
    categorySlug: 'evidence',
    summary: 'Understanding your Evidence Vault and what it contains.',
    infoPointKey: 'evidenceVault',
    screenPath: 'Evidence (bottom tab)',
    infoPointSummary: 'Your Evidence Vault stores proof of trustworthy transactions.',
    content: `Your Evidence Vault is where all your proof lives - receipts, screenshots, and connected profiles.

## What's in the vault

1. **Email Receipts**
   - Purchase confirmations from marketplaces
   - Payment receipts from platforms
   - Automatically extracted metadata

2. **Screenshots**
   - Seller ratings and reviews
   - Transaction confirmations
   - Profile verifications

3. **Connected Profiles**
   - Links to your marketplace accounts
   - Verified profile ownership

## How evidence helps

- Each valid piece of evidence adds to your TrustScore
- Shows others you have real transaction history
- Proves your trustworthiness isn't just self-claimed

## Storage limits

| Plan | Receipts | Screenshots | Total Storage |
|------|----------|-------------|---------------|
| Free | 10 | 5 | - |
| Premium | Unlimited | Unlimited | 100GB |
| Pro | Unlimited | Unlimited | 500GB |

## FAQs

**Q: Is my evidence secure?**
A: Yes, all evidence is encrypted and stored securely.

**Q: Can others see my evidence?**
A: No, only you can see the details. Others see counts and summaries.

**Q: What happens if I hit my limit?**
A: You'll need to upgrade or remove old evidence to add more.`,
  },
  {
    id: '5.2',
    slug: 'email-forwarding',
    title: 'Email Receipt Forwarding',
    category: 'Evidence & Receipts',
    categorySlug: 'evidence',
    summary: 'How email receipt forwarding works.',
    infoPointKey: 'emailScanning',
    screenPath: 'Evidence → Email Receipts',
    infoPointSummary: 'Forward marketplace receipts to your unique SilentID email to add them automatically.',
    content: `SilentID gives you a unique email address to forward receipts to. It's similar to how expense apps like Expensify work.

## How it works

1. You get a unique forwarding email like: ab12cd.x9kf3m@receipts.silentid.co.uk
2. Forward marketplace receipts to this address
3. SilentID extracts the key information
4. The receipt is added to your Evidence Vault

## What we extract

From each receipt, we extract:
- Platform (Vinted, eBay, etc.)
- Transaction amount and currency
- Order ID
- Item description
- Transaction date

## What we DON'T extract

- Full email content
- Personal messages
- Payment details
- Your email password

## FAQs

**Q: Is this safe?**
A: Yes. We only read forwarded receipts, extract metadata, and discard the rest.

**Q: What if I forward the wrong email?**
A: Non-receipt emails are ignored. Only supported marketplace receipts are processed.

**Q: How many receipts can I forward?**
A: Depends on your plan. Free users can add up to 10.`,
  },
  {
    id: '5.3',
    slug: 'setup-email-forwarding',
    title: 'Setting Up Email Forwarding',
    category: 'Evidence & Receipts',
    categorySlug: 'evidence',
    summary: 'Step-by-step guide to setting up email forwarding.',
    screenPath: 'Evidence → Email Receipts → Setup',
    infoPointSummary: 'Set up automatic forwarding or manually forward receipts to add them.',
    content: `You have two options: automatic filters or manual forwarding.

## Option 1: Automatic Forwarding (Gmail)

1. **Get your forwarding address**
   - Go to Evidence → Email Receipts → Setup
   - Copy your unique address

2. **Open Gmail Settings**
   - Go to Settings → Filters and Blocked Addresses
   - Click "Create a new filter"

3. **Set up the filter**
   - From: vinted.co.uk (or other marketplace)
   - Click "Create filter"

4. **Set the action**
   - Check "Forward it to"
   - Paste your SilentID forwarding address
   - Click "Create filter"

5. **Repeat for other platforms**

## Option 2: Automatic Forwarding (Outlook)

1. **Get your forwarding address** (same as above)

2. **Open Outlook Rules**
   - Settings → Mail → Rules
   - Add new rule

3. **Set conditions**
   - From contains: marketplace email

4. **Set action**
   - Forward to your SilentID address

## Option 3: Manual Forwarding

1. **Open any receipt email**
2. **Tap Forward**
3. **Enter your SilentID forwarding address**
4. **Send**

That's it! The receipt will be processed automatically.

## FAQs

**Q: How long until receipts appear?**
A: Usually within a few minutes.

**Q: Can I forward old receipts?**
A: Yes, forward any receipts you have.`,
  },
  {
    id: '5.4',
    slug: 'supported-senders',
    title: 'Supported Receipt Senders',
    category: 'Evidence & Receipts',
    categorySlug: 'evidence',
    summary: 'List of email senders whose receipts are accepted.',
    screenPath: 'Evidence → Email Receipts → Supported Platforms',
    infoPointSummary: 'We accept receipts from major marketplaces and payment platforms.',
    content: `We currently accept receipts from these platforms:

## Marketplaces

| Platform | Email Domain |
|----------|-------------|
| Vinted | @vinted.co.uk, @vinted.com |
| eBay | @ebay.co.uk, @ebay.com |
| Depop | @depop.com |
| Etsy | @etsy.com |
| Poshmark | @poshmark.com |

## Payment Platforms

| Platform | Email Domain |
|----------|-------------|
| PayPal | @paypal.co.uk, @paypal.com |
| Stripe | @stripe.com |

## Social Commerce

| Platform | Email Domain |
|----------|-------------|
| Facebook Marketplace | @facebookmail.com |

## What makes a valid receipt?

- Sent from a verified sender domain
- Contains transaction details (amount, date, item)
- Has valid email authentication (DKIM/SPF)

## Unsupported emails

These are ignored:
- Marketing emails from platforms
- Account notifications
- Password resets
- Personal emails

## FAQs

**Q: Can you add more platforms?**
A: We're always expanding. Request new platforms via Settings → Feedback.

**Q: What if my receipt isn't from these senders?**
A: It won't be processed. Use screenshot evidence instead.`,
  },
  {
    id: '5.5',
    slug: 'screenshots',
    title: 'Screenshot Evidence',
    category: 'Evidence & Receipts',
    categorySlug: 'evidence',
    summary: 'How to add screenshot evidence to your vault.',
    infoPointKey: 'screenshotIntegrity',
    screenPath: 'Evidence → Screenshots',
    infoPointSummary: 'Upload screenshots of your seller ratings and reviews.',
    content: `Screenshots let you capture seller ratings, reviews, and other trust indicators that aren't available as receipts.

## What to screenshot

- Your seller ratings (stars, percentages)
- Positive buyer reviews
- Transaction history counts
- Verification badges from other platforms

## How to add screenshots

1. **Go to Evidence → Screenshots**
2. **Tap "Add Screenshot"**
3. **Use your camera to capture**
   - Point at the screen showing your profile/ratings
   - Make sure details are clearly visible
4. **Review and confirm**
5. **Done!**

## Live capture required

Like profile verification, screenshots must be captured live with your camera. This prevents:
- Edited or fake screenshots
- Using someone else's ratings
- Manipulated images

## Screenshot quality tips

- Good lighting on the screen you're capturing
- Make sure text is readable
- Include your username in the shot
- Avoid glare and reflections

## FAQs

**Q: Can I upload from my gallery?**
A: No, live capture is required for security.

**Q: How many screenshots can I add?**
A: Free: 5, Premium/Pro: Unlimited

**Q: Why was my screenshot rejected?**
A: See our troubleshooting guide for common issues.`,
  },
  {
    id: '5.6',
    slug: 'privacy-metadata',
    title: 'Evidence Privacy & Metadata',
    category: 'Evidence & Receipts',
    categorySlug: 'evidence',
    summary: 'How SilentID handles your evidence data.',
    infoPointKey: 'evidenceStorage',
    screenPath: 'Settings → Privacy → Evidence Storage',
    infoPointSummary: 'SilentID stores only metadata summaries - never full email content or payment details.',
    content: `SilentID uses a "metadata-only" approach for privacy.

## From receipts, we keep:

- Platform name
- Transaction date
- Transaction amount and currency
- Order ID
- Brief item description
- Email authentication status

## From receipts, we DON'T keep:

- Full email content
- Your email address
- Payment card details
- Seller/buyer personal details
- Tracking numbers or addresses

## For screenshots:

- The image is stored (encrypted)
- Basic metadata (date captured, platform detected)
- Used only for your TrustScore

## Why metadata only?

- **Privacy**: Your personal details stay private
- **Security**: Less data = less risk
- **Efficiency**: We only need what matters for trust
- **GDPR**: Minimising data collection is a requirement

## Your rights

- You can view all stored evidence
- You can delete any evidence item
- You can export all your data
- You can delete your entire account

## FAQs

**Q: Can SilentID read my emails?**
A: No. We only process emails you specifically forward to us.

**Q: Are my screenshots shared with anyone?**
A: No. Only counts are shown publicly, never the actual images.

**Q: How long is my evidence stored?**
A: Until you delete it or close your account.`,
  },

  // ============================================================================
  // 6. PUBLIC TRUST PASSPORT & SHARING
  // ============================================================================
  {
    id: '6.1',
    slug: 'public-passport',
    title: 'Your Public Trust Passport',
    category: 'Public Trust Passport & Sharing',
    categorySlug: 'sharing',
    summary: 'Understanding your public passport and what others see.',
    infoPointKey: 'publicPassport',
    screenPath: 'Profile (bottom tab)',
    infoPointSummary: 'Your Public Trust Passport is a shareable link showing your verified identity.',
    content: `Your passport is a public page that shows your verified trust profile. Share it anywhere to help others trust you.

## What your passport shows

Depending on your visibility settings:

**Public Mode:**
- Display name (e.g., "Sarah M.")
- Username (@sarahtrusted)
- Exact TrustScore (e.g., 754/1000)
- Trust label (e.g., "Very High Trust")
- Connected profiles (that you've chosen to show)
- Achievement badges
- Verification status

**Badge Only Mode:**
- Display name and username
- Trust label (but not exact score)
- Connected profiles
- Achievement badges

**Private Mode:**
- Only that you're "SilentID Verified"
- No score or label shown

## What your passport NEVER shows

- Your email address
- Your phone number
- Your home address
- Your ID documents
- Your actual evidence items

## How to view your passport

1. Go to **Profile** tab
2. See your passport preview
3. Tap "View Public Profile" to see what others see

## FAQs

**Q: Can I customize what's shown?**
A: Yes, use visibility modes and hide specific profiles.

**Q: Is my passport searchable on Google?**
A: Only if you share the link publicly. It's not indexed by default.`,
  },
  {
    id: '6.2',
    slug: 'visibility-modes',
    title: 'Visibility Modes',
    category: 'Public Trust Passport & Sharing',
    categorySlug: 'sharing',
    summary: 'Understanding and setting your visibility preferences.',
    infoPointKey: 'trustScoreVisibility',
    screenPath: 'Settings → Privacy → TrustScore Visibility',
    infoPointSummary: 'Control how much of your TrustScore others can see.',
    content: `SilentID lets you control exactly how much of your trust profile is visible.

## Public Mode (Recommended)

**What's shown:**
- Your exact TrustScore (e.g., 754/1000)
- Your trust label (e.g., "Very High Trust")
- All verification badges
- Connected profiles you've enabled

**Best for:** Maximum transparency and trust

## Badge Only Mode

**What's shown:**
- Your trust label (e.g., "Very High Trust")
- Verification badges
- Connected profiles you've enabled
- NOT your exact numeric score

**Best for:** Privacy while still showing trustworthiness

## Private Mode

**What's shown:**
- Only that you're "SilentID Verified"
- Basic verification status

**What's hidden:**
- TrustScore (number and label)
- Connected profiles
- Detailed badges

**Best for:** Maximum privacy

## How to change your mode

1. Go to **Settings → Privacy**
2. Tap **TrustScore Visibility**
3. Select your preferred mode
4. Changes apply immediately

## FAQs

**Q: Which mode builds the most trust?**
A: Public mode shows the most detail, which typically builds the most trust.

**Q: Can I have different modes for different people?**
A: No, it's one setting for everyone. But you can change it anytime.`,
  },
  {
    id: '6.3',
    slug: 'sharing-link',
    title: 'Sharing Your Passport Link',
    category: 'Public Trust Passport & Sharing',
    categorySlug: 'sharing',
    summary: 'How to share your passport as a link.',
    screenPath: 'Profile → Share',
    infoPointSummary: 'Share your passport link on any platform that supports links.',
    content: `Your passport has a unique URL that you can share anywhere.

## Your passport URL

It looks like: https://silentid.co.uk/p/sarahtrusted

## How to share

1. **Go to Profile tab**
2. **Tap "Share"**
3. **Choose "Copy Link" or share directly to:**
   - WhatsApp
   - Telegram
   - Email
   - SMS
   - Any messaging app

## Where to use your link

- Marketplace listings (include in description)
- Dating app bios
- Email signatures
- Social media profiles
- Anywhere you want to build trust

## The link never expires

Your passport link is permanent. It always shows your current trust status.

## FAQs

**Q: Can I get a custom URL?**
A: Your URL is based on your username. Change your username to change the URL.

**Q: What if someone has a similar link?**
A: Each link is unique to your account.

**Q: Do links work if I'm in Private mode?**
A: Yes, but viewers will see limited information.`,
  },
  {
    id: '6.4',
    slug: 'qr-code',
    title: 'QR Code Sharing',
    category: 'Public Trust Passport & Sharing',
    categorySlug: 'sharing',
    summary: 'How to use QR codes to share your passport.',
    screenPath: 'Profile → Share → QR Code',
    infoPointSummary: 'Others can scan your QR code to view your passport instantly.',
    content: `Every passport has a QR code that links directly to your profile.

## Where QR codes work best

- **In person**: Let someone scan your phone
- **Printed materials**: Business cards, flyers
- **Video calls**: Show on screen for scanning
- **Link-restricted platforms**: Dating apps, Instagram bio

## How to show your QR code

1. **Go to Profile → Share**
2. **Tap "Show QR Code"**
3. **Let the other person scan it**

## How to save your QR code

1. **Go to Profile → Share**
2. **Tap "Show QR Code"**
3. **Tap "Save to Photos"**
4. Use the image anywhere

## Tips

- Make sure there's good contrast for scanning
- QR codes work even in low light
- Test it yourself first to make sure it works

## FAQs

**Q: Does the QR code change?**
A: No, it's linked to your permanent passport URL.

**Q: What if someone saves my QR code?**
A: They can only view your public passport, nothing more.`,
  },
  {
    id: '6.5',
    slug: 'badge-generator',
    title: 'Verified Badge Generator',
    category: 'Public Trust Passport & Sharing',
    categorySlug: 'sharing',
    summary: 'How to create and share verified badge images.',
    infoPointKey: 'verifiedBadgeImage',
    screenPath: 'Profile → Share → Create Badge',
    infoPointSummary: 'Create a shareable badge image with your verification status and QR code.',
    content: `Some platforms restrict links. The badge generator creates a shareable image with a QR code built in.

## What the badge shows

- "SilentID Verified" header
- Your initials or username
- TrustScore or tier (based on your visibility setting)
- Achievement badges
- QR code linking to your passport

## Badge options

**Styles:**
- Light mode (white background)
- Dark mode (dark background)

**Sizes:**
- Small (profile picture size)
- Standard (post size)
- Story (Instagram/TikTok story size)

## How to create a badge

1. **Go to Profile → Share → Create Badge**
2. **Choose your style** (light/dark)
3. **Choose your size**
4. **Preview your badge**
5. **Tap "Share" or "Download"**

## Where to use badges

- Instagram bio or stories
- TikTok profile or videos
- Dating app photo galleries
- WhatsApp profile picture
- Anywhere images are allowed but links aren't

## FAQs

**Q: Can people really scan the QR from an image?**
A: Yes, if the image quality is good and the QR code is visible.

**Q: Does my badge update automatically?**
A: No, download a new one if your score changes significantly.`,
  },
  {
    id: '6.6',
    slug: 'smart-sharing',
    title: 'Smart Sharing',
    category: 'Public Trust Passport & Sharing',
    categorySlug: 'sharing',
    summary: 'How smart sharing chooses the right format automatically.',
    infoPointKey: 'smartSharing',
    screenPath: 'Profile → Share',
    infoPointSummary: 'SilentID automatically picks the best sharing format for each platform.',
    content: `When you tap "Share," SilentID automatically picks the best format for where you're sharing.

## How it works

| Where You're Sharing | Format Used |
|---------------------|-------------|
| WhatsApp, Telegram | Link |
| Email, SMS | Link |
| Instagram, TikTok | Badge image |
| Dating apps (Tinder, Bumble, Hinge) | QR-only image |
| Snapchat | Badge image |
| Copy to clipboard | Link |

## Why different formats?

- **Links** work best on platforms that support them
- **Images** work on platforms that block links
- **QR-only** works on platforms with strict photo rules

## Using Smart Share

1. **Tap "Share" on your Profile**
2. **Choose a platform from the share sheet**
3. **SilentID formats appropriately**
4. **You're done!**

## Manual override

If you prefer a specific format:
1. Tap "Share"
2. Tap "More Options"
3. Choose: Link, QR Code, or Badge Image
4. Share manually

## FAQs

**Q: Can I turn off smart sharing?**
A: You can always manually choose a format instead.

**Q: What if my platform isn't recognized?**
A: It defaults to link sharing.`,
  },

  // ============================================================================
  // 7. PRIVACY, DATA & CONTROLS
  // ============================================================================
  {
    id: '7.1',
    slug: 'data-stored',
    title: 'What Data SilentID Stores',
    category: 'Privacy, Data & Controls',
    categorySlug: 'privacy',
    summary: 'A complete list of what data SilentID keeps.',
    infoPointKey: 'evidenceStorage',
    screenPath: 'Settings → Privacy → Data Storage',
    infoPointSummary: 'We store only what\'s needed for your TrustScore - nothing more.',
    content: `SilentID stores the minimum data needed to provide our service.

## Account data

- Email address
- Display name and username
- Profile picture (if set)
- Account creation date
- Subscription status

## TrustScore data

- Your TrustScore and component breakdown
- Score history snapshots
- Achievement badges earned

## Evidence data (metadata only)

- Receipt summaries (platform, amount, date)
- Screenshot images (encrypted)
- Connected profile links and verification status

## Security data

- Login history
- Device identifiers (for security)
- Security alerts and responses

## What we DON'T store

See "What We Never Store" for details.

## FAQs

**Q: How long do you keep my data?**
A: Until you delete it or close your account.

**Q: Is my data encrypted?**
A: Yes, all data is encrypted at rest and in transit.

**Q: Can I see all my data?**
A: Yes, use Data Export in Settings.`,
  },
  {
    id: '7.2',
    slug: 'never-stored',
    title: 'What We Never Store',
    category: 'Privacy, Data & Controls',
    categorySlug: 'privacy',
    summary: 'Data that SilentID specifically does NOT collect or store.',
    screenPath: 'Settings → Privacy',
    infoPointSummary: 'SilentID never stores passwords, ID documents, or full email content.',
    content: `SilentID is designed with privacy by default. We specifically avoid storing:

## Passwords

- SilentID is 100% passwordless
- No passwords are ever created or stored
- There's nothing for hackers to steal

## ID Documents

- Stripe handles identity verification
- Your passport, driver's license, or ID photos are stored by Stripe, not us
- We only receive a yes/no confirmation of verification

## Full Email Content

- When you forward receipts, we extract only metadata
- The email body is processed and discarded
- We never store personal messages

## Payment Details

- Your card numbers are handled by Stripe
- We don't see or store payment method details
- Only subscription status is stored

## Personal Addresses

- We don't ask for your home address
- Delivery addresses from receipts are not extracted
- Location is not tracked

## Other Users' Personal Data

- When you view someone's passport, we don't track what you saw
- No surveillance of your interactions

## FAQs

**Q: Why don't you store ID documents?**
A: Security. By not storing them, there's nothing to breach.

**Q: What if law enforcement requests ID data?**
A: We'd refer them to Stripe, as we don't have it.`,
  },
  {
    id: '7.3',
    slug: 'settings',
    title: 'Privacy Settings',
    category: 'Privacy, Data & Controls',
    categorySlug: 'privacy',
    summary: 'Overview of all privacy controls available.',
    screenPath: 'Settings → Privacy',
    infoPointSummary: 'Control your visibility, data, and privacy preferences.',
    content: `All privacy controls are in Settings → Privacy.

## Available settings

**TrustScore Visibility**
- Public, Badge Only, or Private mode
- Controls what others see on your passport

**Profile Visibility**
- Toggle which connected profiles show on your passport
- Hide specific profiles while keeping them for TrustScore

**Activity Visibility**
- Control whether activity timestamps are shown

**Search Visibility**
- Whether your profile can be found by username

## Data controls

**Export Data**
- Download all your data in a portable format

**Delete Account**
- Permanently remove all your data

## FAQs

**Q: Do changes take effect immediately?**
A: Yes, privacy setting changes apply instantly.

**Q: Can I make everything private?**
A: Yes, use Private visibility mode and hide all profiles.`,
  },
  {
    id: '7.4',
    slug: 'data-export',
    title: 'Exporting Your Data',
    category: 'Privacy, Data & Controls',
    categorySlug: 'privacy',
    summary: 'How to export all your data from SilentID.',
    screenPath: 'Settings → Privacy → Export Data',
    infoPointSummary: 'Download a complete copy of all your SilentID data.',
    content: `Under GDPR, you have the right to receive all data we hold about you in a portable format.

## What's included

- Account information
- TrustScore history
- Evidence metadata
- Connected profiles
- Login history
- Achievement badges
- Settings and preferences

## How to export

1. **Go to Settings → Privacy**
2. **Tap "Export Data"**
3. **Confirm your identity** (security measure)
4. **Wait for preparation** (may take a few minutes)
5. **Download your data** (ZIP file with JSON data)

## Format

Data is exported as JSON files, which can be:
- Opened in any text editor
- Imported into other services
- Kept for your records

## FAQs

**Q: How long does export take?**
A: Usually a few minutes. You'll be notified when ready.

**Q: How often can I export?**
A: Once per week to prevent abuse.

**Q: Are screenshots included?**
A: Yes, as image files in the export.`,
  },
  {
    id: '7.5',
    slug: 'delete-account',
    title: 'Deleting Your Account',
    category: 'Privacy, Data & Controls',
    categorySlug: 'privacy',
    summary: 'How to permanently delete your SilentID account.',
    screenPath: 'Settings → Privacy → Delete Account',
    infoPointSummary: 'Permanently delete your account and all associated data.',
    content: `Account deletion is permanent and irreversible.

## What gets deleted

- Your account and profile
- All TrustScore data
- All evidence (receipts, screenshots)
- Connected profile links
- Login history
- All personal data

## What remains

- Anonymized safety reports (if you were reported)
- Aggregate statistics (no personal data)

## How to delete

1. **Go to Settings → Privacy**
2. **Tap "Delete Account"**
3. **Read the warning carefully**
4. **Type "DELETE" to confirm**
5. **Confirm with your login method**
6. **Account is deleted**

## Important notes

- This cannot be undone
- You'll lose all TrustScore progress
- Active subscriptions are canceled (no refund for partial months)
- Same email can be used to create a new account

## Waiting period

There's a 24-hour grace period after requesting deletion. You can cancel during this time.

## FAQs

**Q: Can I recover my account after deletion?**
A: No. Deletion is permanent.

**Q: What happens to my subscription?**
A: It's canceled immediately. No refund for partial months.

**Q: Can I create a new account with the same email?**
A: Yes, after deletion is complete.`,
  },
  {
    id: '7.6',
    slug: 'gdpr-rights',
    title: 'Your GDPR Rights',
    category: 'Privacy, Data & Controls',
    categorySlug: 'privacy',
    summary: 'Your data protection rights under GDPR.',
    screenPath: 'Settings → Privacy → Your Rights',
    infoPointSummary: 'You have rights under GDPR including access, correction, and deletion.',
    content: `As a user in the UK/EU, you have these rights under GDPR:

## Right of Access

- You can request all data we hold about you
- Use Data Export in Settings

## Right to Rectification

- You can correct inaccurate personal data
- Edit your profile in Settings
- Contact support for data we can't correct in-app

## Right to Erasure

- You can request deletion of your data
- Use Delete Account in Settings

## Right to Restrict Processing

- You can request we limit how we use your data
- Contact support for specific restrictions

## Right to Data Portability

- You can receive your data in a portable format
- Data Export provides JSON files
- Easy to transfer to other services

## Right to Object

- You can object to certain processing
- Contact support to exercise this right

## How to exercise your rights

Most rights can be exercised directly in the app:
- Data export: Settings → Privacy → Export Data
- Deletion: Settings → Privacy → Delete Account

For other requests:
- Email: privacy@silentid.co.uk
- In-app: Settings → Help → Contact Support

## Response time

We respond to GDPR requests within 30 days.

## FAQs

**Q: Do I need to prove my identity?**
A: Yes, for security we verify it's really you making the request.

**Q: Is there a fee?**
A: No, GDPR requests are free (except excessive/repeated requests).`,
  },

  // ============================================================================
  // 8. TROUBLESHOOTING & COMMON ISSUES
  // ============================================================================
  {
    id: '8.1',
    slug: 'token-not-found',
    title: 'Token Not Found',
    category: 'Troubleshooting & Common Issues',
    categorySlug: 'troubleshooting',
    summary: 'What to do when your verification token isn\'t detected.',
    screenPath: 'Profile → Upgrade to Verified → Error',
    infoPointSummary: 'Check that you\'ve added the exact token to your bio and saved changes.',
    content: `If SilentID can't find your verification token, don't worry - here's how to fix it.

## Common causes

1. **Token not saved yet**
   - Did you tap "Save" after adding the token to your bio?
   - Some platforms take a few seconds to update

2. **Token copied incorrectly**
   - Make sure you copied the ENTIRE token
   - Include the "SilentID-verify-" prefix
   - No extra spaces before or after

3. **Token in wrong location**
   - Check you added it to your profile/bio, not a post
   - Some platforms have multiple profile fields

4. **Profile is private**
   - SilentID needs to see your public profile
   - Temporarily make your profile public

5. **Platform caching**
   - Some platforms cache profile data
   - Wait 5-10 minutes and try again

## Step-by-step fix

1. **Go back to the platform**
2. **View your profile as others would see it**
3. **Confirm the token is visible**
4. **Copy a fresh token from SilentID**
5. **Replace the old token with the new one**
6. **Save your changes**
7. **Wait 1 minute**
8. **Try "Check Now" again**

## Still not working?

- Try Screenshot Verification as an alternative
- Contact support if problems persist

## FAQs

**Q: How long should I wait before checking?**
A: Give it at least 30 seconds after saving on the platform.

**Q: Can I use Screenshot Verification instead?**
A: Yes, it's a valid alternative if token doesn't work.`,
  },
  {
    id: '8.2',
    slug: 'screenshot-rejected',
    title: 'Screenshot Rejected',
    category: 'Troubleshooting & Common Issues',
    categorySlug: 'troubleshooting',
    summary: 'Why screenshots might be rejected and how to fix it.',
    screenPath: 'Profile → Upgrade to Verified → Screenshot Error',
    infoPointSummary: 'Make sure your photo is clear, shows your username, and was taken with the in-app camera.',
    content: `Screenshots can be rejected for several reasons. Here's how to get it right.

## Common rejection reasons

1. **Image too blurry**
   - Hold your phone steady
   - Make sure the screen you're capturing is in focus
   - Avoid motion blur

2. **Username not visible**
   - Your profile username must be clearly visible
   - Scroll so your username shows in the shot

3. **Gallery upload attempted**
   - Only live camera photos are accepted
   - You cannot upload from your photo gallery
   - This is a security measure

4. **Screen glare or reflections**
   - Reduce ambient lighting
   - Angle the screen to avoid reflections
   - Turn up screen brightness

5. **Wrong screen captured**
   - Must be YOUR profile page
   - Not a settings page or someone else's profile

6. **Profile not matching**
   - The username in the screenshot must match your connected profile

## Tips for success

- Good lighting (not too bright, not too dark)
- Clean screens (wipe off fingerprints)
- Maximum screen brightness
- Steady hands or prop your phone
- Fill the frame with the profile screen

## Retrying

1. Tap "Retake Photo"
2. Adjust conditions based on feedback
3. Capture again
4. Submit for verification

## FAQs

**Q: How many retries do I get?**
A: Unlimited, but each attempt must be a live photo.

**Q: Can I use screenshots from tablets/computers?**
A: Yes, just capture that screen with your phone camera.`,
  },
  {
    id: '8.3',
    slug: 'receipt-forwarding',
    title: 'Receipt Forwarding Issues',
    category: 'Troubleshooting & Common Issues',
    categorySlug: 'troubleshooting',
    summary: 'Fixing problems with email receipt forwarding.',
    screenPath: 'Evidence → Email Receipts',
    infoPointSummary: 'Check you\'re forwarding from supported senders to the correct address.',
    content: `If your receipts aren't showing up in your Evidence Vault, here's what to check.

## Receipt not appearing

1. **Check the forwarding address**
   - Go to Evidence → Email Receipts → Setup
   - Verify you're using the correct address
   - It should be: [yourcode]@receipts.silentid.co.uk

2. **Wait a bit longer**
   - Receipts can take up to 10 minutes to process
   - Check back after some time

3. **Check the sender**
   - We only process receipts from supported senders
   - Vinted, eBay, Depop, Etsy, PayPal, Stripe, Facebook

4. **Check it's a receipt email**
   - Marketing emails don't count
   - Password resets don't count
   - Only transaction confirmations work

## Email wasn't delivered

1. **Check your sent folder**
   - Confirm the forward actually sent
   - Check for sending errors

2. **Check you used the correct address**
   - Copy it fresh from the app
   - Watch for typos

## Receipt was rejected

If you got a rejection notice:
- The sender wasn't recognized
- The email failed security checks (DKIM/SPF)
- It wasn't a valid receipt format

## Auto-forwarding not working

1. **Check your email filters**
   - Verify the rule is active
   - Test with a manual forward first

2. **Check the filter criteria**
   - Make sure sender addresses match exactly
   - Some platforms use multiple email domains

## FAQs

**Q: Can I forward old receipts from months ago?**
A: Yes, any valid receipt can be forwarded.

**Q: Why was my receipt rejected even though it's from Vinted?**
A: Make sure it's a purchase confirmation, not marketing.`,
  },
  {
    id: '8.4',
    slug: 'trustscore-not-updating',
    title: 'TrustScore Not Updating',
    category: 'Troubleshooting & Common Issues',
    categorySlug: 'troubleshooting',
    summary: 'Why your TrustScore might not reflect recent changes.',
    screenPath: 'Home → TrustScore',
    infoPointSummary: 'TrustScore updates weekly. New evidence appears in your next recalculation.',
    content: `If you've added evidence but don't see score changes, here's why.

## Weekly recalculation

TrustScore recalculates every week, not instantly. This means:
- Evidence added today shows next week
- Profile verification may not reflect immediately
- Be patient - your score will update

## Exceptions (faster updates)

Some changes trigger immediate recalculation:
- Completing identity verification
- Major evidence milestones

## Check your breakdown

Even before recalculation, you can see pending items:
1. Go to Home → TrustScore → Breakdown
2. Look for "pending" items
3. These will count at next recalculation

## Why my score went down

Scores can decrease due to:
- Safety reports from other users
- Evidence flagged for integrity issues
- Extended inactivity

Check your Security Center for any alerts.

## Still stuck?

If your score hasn't updated after a week:
1. Check that evidence actually saved
2. Review your breakdown for errors
3. Contact support if something seems wrong

## FAQs

**Q: When exactly does recalculation happen?**
A: Weekly on your account's anniversary day.

**Q: Can I force an update?**
A: Not manually, but major actions may trigger updates.

**Q: I verified my identity but score didn't change?**
A: Identity verification usually triggers immediate updates. Contact support if it didn't.`,
  },
  {
    id: '8.5',
    slug: 'login-problems',
    title: 'Login Problems',
    category: 'Troubleshooting & Common Issues',
    categorySlug: 'troubleshooting',
    summary: 'How to resolve common login issues.',
    screenPath: 'Login',
    infoPointSummary: 'Try a different login method or request a new code if having issues.',
    content: `Can't log in? Here's how to fix common issues.

## Apple/Google Sign-In not working

1. **Check your internet connection**
   - Try toggling WiFi or mobile data

2. **Make sure you're using the right account**
   - If you signed up with Apple, use Apple
   - Check the email matches your SilentID account

3. **Try restarting the app**
   - Close completely and reopen

4. **Update the app**
   - Make sure you have the latest version

## Email OTP not arriving

1. **Check spam/junk folders**
   - Codes often get filtered

2. **Wait a few minutes**
   - Emails can be delayed

3. **Check you entered the right email**
   - Typos are common

4. **Request a new code**
   - Old codes may have expired

5. **Check rate limits**
   - Max 3 codes per 5 minutes

## Passkey not working

1. **Try Face ID / Touch ID again**
   - Sometimes the first attempt fails

2. **Make sure biometrics are enabled**
   - Check your device settings

3. **Use an alternative method**
   - Fall back to Apple/Google or Email OTP

## "Account not found"

- Double-check your email address
- Make sure you've signed up previously
- Try all email addresses you might have used

## "Account suspended"

If your account is suspended:
1. Check your email for a message from SilentID
2. Contact support to understand why
3. Follow instructions to resolve

## FAQs

**Q: I forgot which email I used?**
A: Try all emails you commonly use. Each can only have one account.

**Q: My account was hacked - what do I do?**
A: Contact support immediately. We can secure your account.`,
  },
  {
    id: '8.6',
    slug: 'suspicious-device',
    title: 'Suspicious Device Alerts',
    category: 'Troubleshooting & Common Issues',
    categorySlug: 'troubleshooting',
    summary: 'What to do when you get a suspicious device alert.',
    infoPointKey: 'deviceSecurity',
    screenPath: 'Security → Alerts',
    infoPointSummary: 'Review alerts carefully. If you don\'t recognize a login, secure your account.',
    content: `SilentID alerts you when we detect a login that might not be you.

## What triggers alerts

- Login from a new device
- Login from an unusual location
- Login at an unusual time
- Multiple failed login attempts

## When you get an alert

1. **Check if it was you**
   - Did you recently get a new phone?
   - Did you log in from a different browser?
   - Were you traveling?

2. **If it WAS you**
   - Tap "This was me"
   - The device will be trusted

3. **If it WASN'T you**
   - Tap "Not me" immediately
   - We'll secure your account
   - Review and remove unknown devices

## Securing your account

If you suspect unauthorized access:

1. **Go to Security Center**
2. **Review all active devices**
3. **Remove any you don't recognize**
4. **Change your primary login method**
5. **Check for any changes to your profile**

## Preventing future issues

- Use Passkey for extra security
- Review devices regularly
- Keep your login methods updated

## FAQs

**Q: Why did I get an alert for my own login?**
A: New devices or browsers trigger alerts until you confirm them.

**Q: Can someone access my TrustScore?**
A: If they got into your account, they could view it. But they can't change your identity verification.

**Q: What if I lost my phone?**
A: Log in from another device and remove the lost phone from your trusted devices.`,
  },
  {
    id: '8.7',
    slug: 'getting-help',
    title: 'Getting More Help',
    category: 'Troubleshooting & Common Issues',
    categorySlug: 'troubleshooting',
    summary: 'How to get additional help from SilentID support.',
    screenPath: 'Settings → Help',
    infoPointSummary: 'Can\'t find an answer? Contact our support team.',
    content: `If you can't find an answer in the Help Center, we're here to help.

## In-app support

1. **Go to Settings → Help**
2. **Tap "Contact Support"**
3. **Describe your issue**
4. **Send your message**

We typically respond within 24 hours.

## What to include

Help us help you by including:
- What you were trying to do
- What happened (or didn't happen)
- Any error messages you saw
- Your device type (iPhone/Android)
- App version (found in Settings → About)

## Email support

You can also email us directly:
- **General:** support@silentid.co.uk
- **Privacy:** privacy@silentid.co.uk
- **Security:** security@silentid.co.uk

## Response times

- Standard queries: Within 24 hours
- Security issues: Within 4 hours
- Account access issues: Priority handling

## What we can help with

- Account and login issues
- Evidence and TrustScore questions
- Technical problems
- Privacy and data requests
- Feature requests
- Bug reports

## What we can't help with

- Issues with other platforms (Vinted, eBay, etc.)
- Disputes between users on other platforms
- Legal advice

## FAQs

**Q: Is support available on weekends?**
A: We monitor for urgent issues, but response may be slower.

**Q: Can I call support?**
A: We don't currently offer phone support. Use in-app or email.

**Q: How do I report a bug?**
A: Settings → Help → Report a Bug`,
  },
];

// Populate categories with articles
helpCategories.forEach((category) => {
  category.articles = helpArticles.filter(
    (article) => article.categorySlug === category.slug
  );
});

// Helper functions
export function getArticleBySlug(
  categorySlug: string,
  articleSlug: string
): HelpArticle | undefined {
  return helpArticles.find(
    (article) =>
      article.categorySlug === categorySlug && article.slug === articleSlug
  );
}

export function getCategoryBySlug(slug: string): HelpCategory | undefined {
  return helpCategories.find((category) => category.slug === slug);
}

export function searchArticles(query: string): HelpArticle[] {
  const lowerQuery = query.toLowerCase();
  return helpArticles.filter(
    (article) =>
      article.title.toLowerCase().includes(lowerQuery) ||
      article.summary.toLowerCase().includes(lowerQuery) ||
      article.content.toLowerCase().includes(lowerQuery)
  );
}

export function getRelatedArticles(
  article: HelpArticle,
  limit: number = 3
): HelpArticle[] {
  return helpArticles
    .filter(
      (a) => a.categorySlug === article.categorySlug && a.id !== article.id
    )
    .slice(0, limit);
}
