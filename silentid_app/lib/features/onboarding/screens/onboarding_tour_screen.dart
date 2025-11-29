import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';

/// Onboarding Tour Screen (Section 50.2.1)
///
/// Interactive onboarding journey with micro-lessons (20-30 seconds each).
/// Triggered only on first login. Shows core value proposition of SilentID.
class OnboardingTourScreen extends StatefulWidget {
  const OnboardingTourScreen({super.key});

  static const _storage = FlutterSecureStorage();
  static const _onboardingKey = 'onboarding_completed';

  /// Check if onboarding has been completed
  static Future<bool> hasCompletedOnboarding() async {
    final value = await _storage.read(key: _onboardingKey);
    return value == 'true';
  }

  /// Mark onboarding as completed
  static Future<void> completeOnboarding() async {
    await _storage.write(key: _onboardingKey, value: 'true');
  }

  @override
  State<OnboardingTourScreen> createState() => _OnboardingTourScreenState();
}

class _OnboardingTourScreenState extends State<OnboardingTourScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Animation controllers for each page
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.shield_outlined,
      title: 'Welcome to SilentID',
      subtitle: 'Your Digital Trust Identity',
      description:
          'Build a portable reputation that follows you across marketplaces, dating apps, and online communities.',
      color: AppTheme.primaryPurple,
    ),
    OnboardingPage(
      icon: Icons.emoji_events_outlined,
      title: 'Your TrustScore',
      subtitle: 'Your Digital Reputation Passport',
      description:
          'Your TrustScore (0-1000) shows how trustworthy you are online. Higher score = more trust = better opportunities.',
      color: AppTheme.successGreen,
    ),
    OnboardingPage(
      icon: Icons.verified_user_outlined,
      title: 'Verify Your Identity',
      subtitle: 'Prove You\'re Real',
      description:
          'Quick identity verification via Stripe. Your documents are never stored by SilentID—only the result.',
      color: AppTheme.primaryPurple,
    ),
    OnboardingPage(
      icon: Icons.link,
      title: 'Connect Your Profiles',
      subtitle: 'Bring Your Stars With You',
      description:
          'Link your Vinted, eBay, Depop ratings. Your reputation from one platform boosts your TrustScore everywhere.',
      color: AppTheme.warningAmber,
    ),
    OnboardingPage(
      icon: Icons.receipt_long_outlined,
      title: 'Evidence Vault',
      subtitle: 'Prove Your Transactions',
      description:
          'Upload receipts and screenshots from your transactions. Each piece of evidence strengthens your reputation.',
      color: AppTheme.successGreen,
    ),
    OnboardingPage(
      icon: Icons.share_outlined,
      title: 'Share Your Trust',
      subtitle: 'One Identity. Everywhere.',
      description:
          'Share your Digital Trust Passport anywhere—even on platforms that block links. Prove who you are instantly.',
      color: AppTheme.primaryPurple,
      isLast: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    HapticFeedback.lightImpact();
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await OnboardingTourScreen.completeOnboarding();
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppTheme.neutralGray700,
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                  HapticFeedback.selectionClick();
                  _fadeController.reset();
                  _fadeController.forward();
                },
                itemBuilder: (context, index) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildPage(_pages[index]),
                  );
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _buildDot(index),
                ),
              ),
            ),

            // Action button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: PrimaryButton(
                text: _currentPage == _pages.length - 1
                    ? 'Get Started'
                    : 'Continue',
                onPressed: _nextPage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon container
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: page.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                page.icon,
                size: 56,
                color: page.color,
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Title
          Text(
            page.title,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.deepBlack,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Subtitle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              page.subtitle,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: page.color,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Description
          Text(
            page.description,
            style: GoogleFonts.inter(
              fontSize: 16,
              height: 1.6,
              color: AppTheme.neutralGray700,
            ),
            textAlign: TextAlign.center,
          ),

          // Show TrustScore preview on page 2
          if (page.title == 'Your TrustScore') ...[
            const SizedBox(height: 32),
            _buildTrustScorePreview(),
          ],
        ],
      ),
    );
  }

  Widget _buildTrustScorePreview() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 754),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryPurple,
                AppTheme.primaryPurple.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${value.toInt()}',
                style: GoogleFonts.inter(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TrustScore',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    'High Trust',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDot(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryPurple : AppTheme.neutralGray300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Model for onboarding page content
class OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final bool isLast;

  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    this.isLast = false,
  });
}
