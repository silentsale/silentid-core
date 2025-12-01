import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptics.dart';

/// In-App Education for Sharing - Section 51.7
/// Level 7 Gamification + Level 7 Interactivity
/// Provides education on how sharing works, visibility modes, and QR scanning

class SharingEducationScreen extends StatefulWidget {
  const SharingEducationScreen({super.key});

  @override
  State<SharingEducationScreen> createState() => _SharingEducationScreenState();
}

class _SharingEducationScreenState extends State<SharingEducationScreen>
    with SingleTickerProviderStateMixin {
  // Level 7: Animation controller
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Level 7: Initialize animations
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  final List<_EducationPage> _pages = [
    _EducationPage(
      title: 'Share Your Trust Identity',
      subtitle: 'Your SilentID Public Trust Passport',
      description:
          'Your public passport is a verified digital identity that you can share anywhere. '
          'It shows your trust credentials without revealing personal information.',
      icon: Icons.share_rounded,
      color: AppTheme.primaryPurple,
    ),
    _EducationPage(
      title: 'Two Ways to Share',
      subtitle: 'Link or Badge - You Choose',
      description:
          'Share your public passport link on platforms that allow links. '
          'Use your verified badge image on platforms that restrict links.',
      icon: Icons.swap_horiz_rounded,
      color: const Color(0xFF3B82F6),
    ),
    _EducationPage(
      title: 'QR Code Magic',
      subtitle: 'Scan to Verify',
      description:
          'Every badge includes a QR code that links to your public passport. '
          'Others can scan it instantly to verify your identity.',
      icon: Icons.qr_code_scanner_rounded,
      color: const Color(0xFF10B981),
    ),
    _EducationPage(
      title: 'Control Your Visibility',
      subtitle: 'Public, Badge-Only, or Private',
      description:
          'Choose what others see. Show your exact TrustScore, just your tier and badges, '
          'or keep your score private while still proving you\'re verified.',
      icon: Icons.visibility_rounded,
      color: const Color(0xFFF59E0B),
    ),
  ];

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'How Sharing Works',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.neutralGray900),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Page View
            Expanded(
              child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                AppHaptics.light();
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return _buildPage(_pages[index]);
              },
            ),
          ),

          // Page Indicators & Navigation
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Page indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildPageIndicator(index),
                  ),
                ),
                const SizedBox(height: 24),

                // Navigation buttons
                Row(
                  children: [
                    if (_currentPage > 0)
                      TextButton(
                        onPressed: () => _goToPage(_currentPage - 1),
                        child: Text(
                          'Back',
                          style: GoogleFonts.inter(
                            color: AppTheme.neutralGray700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 60),
                    const Spacer(),
                    if (_currentPage < _pages.length - 1)
                      ElevatedButton(
                        onPressed: () => _goToPage(_currentPage + 1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Next',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      )
                    else
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.successGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Got It!',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildPage(_EducationPage page) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Icon container
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 48,
              color: page.color,
            ),
          ),
          const SizedBox(height: 32),

          // Title
          Text(
            page.title,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.neutralGray900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            page.subtitle,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: page.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Description
          Text(
            page.description,
            style: GoogleFonts.inter(
              fontSize: 15,
              height: 1.6,
              color: AppTheme.neutralGray700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Visual demo based on page
          _buildPageDemo(page),
        ],
      ),
    );
  }

  Widget _buildPageDemo(_EducationPage page) {
    switch (page.icon) {
      case Icons.share_rounded:
        return _buildPassportDemo();
      case Icons.swap_horiz_rounded:
        return _buildSharingMethodsDemo();
      case Icons.qr_code_scanner_rounded:
        return _buildQrScanDemo();
      case Icons.visibility_rounded:
        return _buildVisibilityDemo();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPassportDemo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryPurple.withValues(alpha: 0.05),
            AppTheme.primaryPurple.withValues(alpha: 0.02),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_rounded,
                color: AppTheme.primaryPurple,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'SilentID Public Passport',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.link, size: 16, color: AppTheme.neutralGray700),
                const SizedBox(width: 8),
                Text(
                  'silentid.app/p/abc123',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSharingMethodsDemo() {
    return Row(
      children: [
        Expanded(
          child: _buildMethodCard(
            icon: Icons.link_rounded,
            title: 'Link',
            platforms: 'WhatsApp, Email, SMS',
            color: const Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMethodCard(
            icon: Icons.image_rounded,
            title: 'Badge',
            platforms: 'Instagram, TikTok, Dating',
            color: const Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }

  Widget _buildMethodCard({
    required IconData icon,
    required String title,
    required String platforms,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            platforms,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.neutralGray700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQrScanDemo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // QR code preview
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: QrImageView(
              data: 'https://silentid.app/p/demo',
              version: QrVersions.auto,
              size: 100,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Color(0xFF1A1A2E),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone_android_rounded,
                size: 18,
                color: const Color(0xFF10B981),
              ),
              const SizedBox(width: 8),
              Text(
                'Scan with any camera app',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilityDemo() {
    return Column(
      children: [
        _buildVisibilityOption(
          title: 'Public',
          example: '754/1000',
          icon: Icons.visibility_rounded,
          color: AppTheme.successGreen,
        ),
        const SizedBox(height: 12),
        _buildVisibilityOption(
          title: 'Badge Only',
          example: 'Very High Trust',
          icon: Icons.shield_rounded,
          color: const Color(0xFFF59E0B),
        ),
        const SizedBox(height: 12),
        _buildVisibilityOption(
          title: 'Private',
          example: 'Verified Only',
          icon: Icons.lock_rounded,
          color: AppTheme.neutralGray700,
        ),
      ],
    );
  }

  Widget _buildVisibilityOption({
    required String title,
    required String example,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              example,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.neutralGray700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? _pages[_currentPage].color
            : AppTheme.neutralGray300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _EducationPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;

  const _EducationPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });
}

/// Quick tooltip for sharing education
class SharingTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  const SharingTooltip({
    super.key,
    required this.child,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      decoration: BoxDecoration(
        color: AppTheme.neutralGray900,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: 12,
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      preferBelow: false,
      child: child,
    );
  }
}

/// Info banner for sharing screens
class SharingInfoBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onLearnMore;

  const SharingInfoBanner({
    super.key,
    required this.message,
    this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: 20,
            color: const Color(0xFF3B82F6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.neutralGray700,
              ),
            ),
          ),
          if (onLearnMore != null)
            TextButton(
              onPressed: onLearnMore,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Learn More',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3B82F6),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
