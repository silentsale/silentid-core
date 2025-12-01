import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/gamification/reward_tag.dart';

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
      rewardPoints: 0,
    ),
    OnboardingPage(
      icon: Icons.emoji_events_outlined,
      title: 'Your TrustScore',
      subtitle: 'Your Digital Reputation Passport',
      description:
          'Your TrustScore (0-1000) shows how trustworthy you are online. Higher score = more trust = better opportunities.',
      color: AppTheme.successGreen,
      rewardPoints: 0,
      showTrustPreview: true,
    ),
    OnboardingPage(
      icon: Icons.verified_user_outlined,
      title: 'Verify Your Identity',
      subtitle: 'Prove You\'re Real',
      description:
          'Quick identity verification via Stripe. Your documents are never stored by SilentID—only the result.',
      color: AppTheme.primaryPurple,
      rewardPoints: 50,
    ),
    OnboardingPage(
      icon: Icons.link,
      title: 'Connect Your Profiles',
      subtitle: 'Bring Your Stars With You',
      description:
          'Link your Vinted, eBay, Depop, Instagram, TikTok ratings. Your reputation from one platform boosts your TrustScore everywhere.\n\nOr import directly using your phone\'s Share button.',
      color: AppTheme.warningAmber,
      rewardPoints: 25,
      showPlatformIcons: true,
    ),
    OnboardingPage(
      icon: Icons.receipt_long_outlined,
      title: 'Evidence Vault',
      subtitle: 'Prove Your Transactions',
      description:
          'Upload receipts and screenshots from your transactions. Each piece of evidence strengthens your reputation.',
      color: AppTheme.successGreen,
      rewardPoints: 10,
    ),
    // NEW: Share-Import page (Section 55)
    OnboardingPage(
      icon: Icons.ios_share_outlined,
      title: 'Import Profiles From Any App',
      subtitle: 'Share to Connect',
      description:
          'Open any profile → Share → Import to SilentID.\n\nSupports marketplaces, socials, and professional platforms.',
      color: const Color(0xFF3B82F6),
      rewardPoints: 25,
      showShareImportDemo: true,
    ),
    OnboardingPage(
      icon: Icons.share_outlined,
      title: 'Share Your Trust',
      subtitle: 'One Identity. Everywhere.',
      description:
          'Share your Digital Trust Passport anywhere—even on platforms that block links. Prove who you are instantly.',
      color: AppTheme.primaryPurple,
      isLast: true,
      rewardPoints: 0,
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            // Animated icon container with reward tag
            Stack(
              clipBehavior: Clip.none,
              children: [
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
                      boxShadow: [
                        BoxShadow(
                          color: page.color.withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      page.icon,
                      size: 56,
                      color: page.color,
                    ),
                  ),
                ),
                // Reward points indicator (Level 7 Gamification)
                if (page.rewardPoints > 0)
                  Positioned(
                    top: -8,
                    right: -8,
                    child: RewardIndicator(points: page.rewardPoints),
                  ),
              ],
            ),

            const SizedBox(height: 40),

            // Title
            Text(
              page.title,
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppTheme.deepBlack,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Subtitle pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: page.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: page.color.withValues(alpha: 0.3),
                ),
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

            // Show TrustScore preview
            if (page.showTrustPreview) ...[
              const SizedBox(height: 28),
              _buildTrustScorePreview(),
            ],

            // Show Platform Icons (Connect Profiles page)
            if (page.showPlatformIcons) ...[
              const SizedBox(height: 28),
              _buildPlatformIconsRow(),
            ],

            // Show Share-Import Demo (Section 55)
            if (page.showShareImportDemo) ...[
              const SizedBox(height: 28),
              _buildShareImportDemo(),
            ],

            const SizedBox(height: 24),
          ],
        ),
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

  /// Platform icons row for Connect Profiles page (Level 7 Gamification)
  Widget _buildPlatformIconsRow() {
    final platforms = [
      {'icon': Icons.local_mall_outlined, 'color': const Color(0xFF09B1BA), 'name': 'Vinted'},
      {'icon': Icons.shopping_bag_outlined, 'color': const Color(0xFFE53238), 'name': 'eBay'},
      {'icon': Icons.storefront_outlined, 'color': const Color(0xFFFF2300), 'name': 'Depop'},
      {'icon': Icons.camera_alt_outlined, 'color': const Color(0xFFE4405F), 'name': 'Instagram'},
      {'icon': Icons.music_note_outlined, 'color': Colors.black, 'name': 'TikTok'},
      {'icon': Icons.business_center_outlined, 'color': const Color(0xFF0077B5), 'name': 'LinkedIn'},
    ];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: platforms.asMap().entries.map((entry) {
                final index = entry.key;
                final platform = entry.value;
                final delay = index * 0.1;
                final itemOpacity = (value - delay).clamp(0.0, 1.0);

                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: Duration(milliseconds: 300 + index * 100),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: 0.8 + (scale - 0.8) * itemOpacity,
                      child: Opacity(
                        opacity: itemOpacity,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: (platform['color'] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: (platform['color'] as Color).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Icon(
                            platform['icon'] as IconData,
                            color: platform['color'] as Color,
                            size: 26,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  /// Share-Import demo animation for Section 55 page
  Widget _buildShareImportDemo() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 30),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppTheme.neutralGray300.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                children: [
                  // Share flow visualization
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App icon
                      _buildShareFlowStep(
                        icon: Icons.apps_rounded,
                        label: 'Any App',
                        color: AppTheme.neutralGray700,
                        isActive: value > 0.2,
                      ),
                      _buildShareFlowArrow(isActive: value > 0.4),
                      // Share button
                      _buildShareFlowStep(
                        icon: Icons.ios_share_rounded,
                        label: 'Share',
                        color: const Color(0xFF3B82F6),
                        isActive: value > 0.5,
                      ),
                      _buildShareFlowArrow(isActive: value > 0.7),
                      // SilentID
                      _buildShareFlowStep(
                        icon: Icons.shield_rounded,
                        label: 'SilentID',
                        color: AppTheme.primaryPurple,
                        isActive: value > 0.8,
                        isPrimary: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Platform icons
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildMiniPlatformIcon(Icons.local_mall_outlined, const Color(0xFF09B1BA)),
                      _buildMiniPlatformIcon(Icons.shopping_bag_outlined, const Color(0xFFE53238)),
                      _buildMiniPlatformIcon(Icons.camera_alt_outlined, const Color(0xFFE4405F)),
                      _buildMiniPlatformIcon(Icons.music_note_outlined, Colors.black),
                      _buildMiniPlatformIcon(Icons.business_center_outlined, const Color(0xFF0077B5)),
                      _buildMiniPlatformIcon(Icons.code_outlined, const Color(0xFF333333)),
                      _buildMiniPlatformIcon(Icons.store_outlined, const Color(0xFFF56400)),
                      _buildMiniPlatformIcon(Icons.chat_outlined, const Color(0xFF5865F2)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShareFlowStep({
    required IconData icon,
    required String label,
    required Color color,
    required bool isActive,
    bool isPrimary = false,
  }) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isActive ? 1.0 : 0.3,
      child: Column(
        children: [
          Container(
            width: isPrimary ? 52 : 44,
            height: isPrimary ? 52 : 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(isPrimary ? 14 : 10),
              border: Border.all(
                color: isActive ? color.withValues(alpha: 0.5) : Colors.transparent,
                width: 2,
              ),
              boxShadow: isPrimary && isActive
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              color: color,
              size: isPrimary ? 26 : 22,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isActive ? color : AppTheme.neutralGray700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareFlowArrow({required bool isActive}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isActive ? 1.0 : 0.3,
        child: Icon(
          Icons.arrow_forward_rounded,
          color: isActive ? AppTheme.primaryPurple : AppTheme.neutralGray300,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMiniPlatformIcon(IconData icon, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: color,
        size: 18,
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
  final int rewardPoints;
  final bool showTrustPreview;
  final bool showPlatformIcons;
  final bool showShareImportDemo;

  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    this.isLast = false,
    this.rewardPoints = 0,
    this.showTrustPreview = false,
    this.showPlatformIcons = false,
    this.showShareImportDemo = false,
  });
}
