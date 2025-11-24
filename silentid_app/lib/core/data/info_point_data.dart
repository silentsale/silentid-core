import 'package:flutter/material.dart';

/// Info Point Data Model
///
/// Represents a single info point with all its content
/// following Section 40.4 specifications
class InfoPointData {
  final String title;
  final String body;
  final IconData? icon;
  final String? learnMoreText;
  final String? learnMoreUrl;
  final String? actionButtonText;
  final VoidCallback? onAction;

  const InfoPointData({
    required this.title,
    required this.body,
    this.icon,
    this.learnMoreText,
    this.learnMoreUrl,
    this.actionButtonText,
    this.onAction,
  });
}

/// All info point content from Section 40.4
///
/// This is the single source of truth for info point content
/// All text is derived from CLAUDE.md and respects:
/// - Defamation-safe wording (Section 4)
/// - GDPR-compliant language (Section 20)
/// - Subscription wording (Section 12/16)
class InfoPoints {
  // ============================================================================
  // 1. TRUSTSCORE UI
  // ============================================================================

  static InfoPointData get trustScoreOverall => const InfoPointData(
        title: 'What is TrustScore?',
        icon: Icons.emoji_events,
        body: '''Your TrustScore (0-1000) shows how trustworthy you are to deal with online.

It's calculated from:
• Identity verification
• Evidence you upload
• Your behaviour
• Peer confirmations

Higher score = more trust = better reputation.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/trustscore',
      );

  static InfoPointData get identityComponent => const InfoPointData(
        title: 'Identity Component',
        icon: Icons.shield_outlined,
        body: '''Worth up to 200 points.

Earned by verifying your identity with Stripe and confirming your email/phone.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/identity-verification',
      );

  static InfoPointData get evidenceComponent => const InfoPointData(
        title: 'Evidence Component',
        icon: Icons.folder_outlined,
        body: '''Worth up to 300 points.

Earned by uploading receipts, screenshots, and linking your marketplace profiles.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/evidence',
      );

  static InfoPointData get behaviourComponent => const InfoPointData(
        title: 'Behaviour Component',
        icon: Icons.trending_up,
        body: '''Worth up to 300 points.

Based on having no safety reports, consistent activity, and account longevity.''',
      );

  static InfoPointData get peerVerificationComponent => const InfoPointData(
        title: 'Peer Verification Component',
        icon: Icons.people_outline,
        body: '''Worth up to 200 points.

Earned by getting mutual confirmations from people you've traded with.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/mutual-verification',
      );

  // ============================================================================
  // 2. RISKSCORE & SECURITY CENTER
  // ============================================================================

  static InfoPointData get riskScore => const InfoPointData(
        title: 'What is RiskScore?',
        icon: Icons.shield,
        body: '''RiskScore (0-100) measures potential fraud signals. Higher = more risk.

It's based on device patterns, evidence integrity checks, and user reports.

High RiskScore may restrict account features until resolved.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/risk-signals',
      );

  static InfoPointData get riskSignals => const InfoPointData(
        title: 'Risk Signals',
        icon: Icons.warning_amber_outlined,
        body: '''Risk signals are automated fraud detection alerts.

Examples: suspicious evidence, device inconsistency, or reports from other users.

You can review and resolve these in Security Center.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/risk-signals',
      );

  static InfoPointData get deviceSecurity => const InfoPointData(
        title: 'Device Security',
        icon: Icons.smartphone,
        body: '''SilentID monitors your devices for security.

If you log in from a new device, we'll alert you to prevent account takeover.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/device-security',
      );

  static InfoPointData get accountRestrictions => const InfoPointData(
        title: 'Why is my account restricted?',
        icon: Icons.lock_outline,
        body: '''Accounts may be temporarily restricted if:
• High RiskScore detected
• Multiple safety reports filed
• Evidence integrity concerns

Contact support to resolve.''',
      );

  // ============================================================================
  // 3. IDENTITY VERIFICATION (STRIPE)
  // ============================================================================

  static InfoPointData get stripeIdentity => const InfoPointData(
        title: 'Identity Verification with Stripe',
        icon: Icons.verified_user_outlined,
        body: '''SilentID uses Stripe to verify your identity.

Your ID documents and selfie are stored by Stripe (not SilentID). We only receive confirmation that you're verified.

This prevents fake accounts and boosts your TrustScore.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/identity-verification',
      );

  static InfoPointData get verificationRetry => const InfoPointData(
        title: 'Verification Failed',
        icon: Icons.error_outline,
        body: '''Your identity verification was unsuccessful.

Reasons: blurry photo, document mismatch, or expired ID.

You can retry up to 3 times per 24 hours.''',
        learnMoreText: 'Learn More',
        learnMoreUrl:
            'https://help.silentid.co.uk/troubleshooting-verification',
      );

  // ============================================================================
  // 4. EVIDENCE VAULT
  // ============================================================================

  static InfoPointData get evidenceVault => const InfoPointData(
        title: 'What is Evidence Vault?',
        icon: Icons.folder_special_outlined,
        body: '''Your Evidence Vault stores proof of your trustworthy behaviour:

• Email receipts from marketplaces
• Screenshots of reviews/ratings
• Links to public seller profiles

All evidence is integrity-checked and contributes to your TrustScore.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/evidence',
      );

  static InfoPointData get emailScanning => const InfoPointData(
        title: 'How Email Scanning Works',
        icon: Icons.email_outlined,
        body: '''We scan your inbox for order confirmations from marketplaces like Vinted, eBay, and Depop.

We only read receipts—not personal emails.

You can disconnect anytime.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/email-scanning',
      );

  static InfoPointData get screenshotIntegrity => const InfoPointData(
        title: 'Screenshot Verification',
        icon: Icons.image_outlined,
        body: '''All screenshots are checked for tampering using image analysis.

Suspicious or edited screenshots may be rejected.

Upload clear, unedited screenshots for best results.''',
      );

  static InfoPointData get evidenceStorage => const InfoPointData(
        title: 'What SilentID Stores',
        icon: Icons.storage_outlined,
        body: '''We store:
✅ Summary of transactions (date, amount, platform)
✅ Screenshot images
✅ Public profile data

We do NOT store:
❌ Full email content
❌ ID documents (handled by Stripe)
❌ Your passwords (we don't use passwords!)''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/privacy',
      );

  // ============================================================================
  // 5. PASSWORDLESS AUTHENTICATION
  // ============================================================================

  static InfoPointData get whyNoPasswords => const InfoPointData(
        title: 'Why Doesn\'t SilentID Use Passwords?',
        icon: Icons.lock_open_outlined,
        body: '''Passwords are the #1 cause of account hacks.

SilentID is 100% passwordless. You log in with:
• Apple Sign-In
• Google Sign-In
• Passkeys (Face ID / Touch ID)
• Email OTP (6-digit code)

Your account is more secure this way.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/passwordless-auth',
      );

  static InfoPointData get emailOTP => const InfoPointData(
        title: 'How Email OTP Works',
        icon: Icons.pin_outlined,
        body: '''We send a 6-digit code to your email.

Enter it within 5 minutes to log in.

You can request up to 3 codes per 5 minutes.''',
      );

  static InfoPointData get passkeys => const InfoPointData(
        title: 'What are Passkeys?',
        icon: Icons.fingerprint,
        body: '''Passkeys use Face ID, Touch ID, or fingerprint to log in.

They're device-bound and extremely secure.

You can enable passkeys in Settings → Security.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/passkeys',
      );

  static InfoPointData get accountRecovery => const InfoPointData(
        title: 'What if I lose my device?',
        icon: Icons.phone_android_outlined,
        body: '''If you lose access, you can recover your account by:

1. Entering your email
2. Verifying your identity via Stripe again

Your TrustScore and evidence will be restored.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/account-recovery',
      );

  // ============================================================================
  // 6. PUBLIC PROFILE
  // ============================================================================

  static InfoPointData get publicProfileVisibility => const InfoPointData(
        title: 'What\'s Public?',
        icon: Icons.public,
        body: '''Your public profile shows:
✅ Display name (e.g., "Sarah M.")
✅ Username (@sarahtrusted)
✅ TrustScore
✅ Verification badges
✅ General activity metrics

Your public profile does NOT show:
❌ Full legal name
❌ Email or phone
❌ Address or location
❌ ID documents''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/public-profile',
      );

  static InfoPointData get safetyWarnings => const InfoPointData(
        title: 'Safety Warnings',
        icon: Icons.warning_outlined,
        body: '''If multiple users report a profile, we may display:

⚠️ "Safety concern flagged"

This means other users have submitted verified evidence about this person.

We recommend extra caution.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/safety-reports',
      );

  // ============================================================================
  // 7. SUBSCRIPTIONS (FREE / PREMIUM / PRO)
  // ============================================================================

  static InfoPointData get subscriptionTiers => const InfoPointData(
        title: 'What\'s the difference?',
        icon: Icons.card_membership_outlined,
        body: '''Free: Basic TrustScore, limited evidence (10 receipts, 5 screenshots)

Premium (£4.99/mo): Unlimited evidence, advanced analytics, 100GB vault

Pro (£14.99/mo): Everything in Premium + bulk checks, dispute tools, 500GB vault''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/subscriptions',
      );

  static InfoPointData get subscriptionAndSafety => const InfoPointData(
        title: 'Does paying increase my TrustScore?',
        icon: Icons.help_outline,
        body: '''NO.

Paying for Premium or Pro does NOT directly increase your TrustScore or override safety systems.

Subscriptions only unlock features like larger Evidence Vault and analytics.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/subscription-safety',
      );

  static InfoPointData get refundPolicy => const InfoPointData(
        title: 'Refund Policy',
        icon: Icons.money_off_outlined,
        body: '''We do not offer refunds for partial months.

You can cancel anytime. Your plan remains active until the end of your billing period.''',
        learnMoreText: 'Learn More',
        learnMoreUrl: 'https://help.silentid.co.uk/refunds',
      );
}
