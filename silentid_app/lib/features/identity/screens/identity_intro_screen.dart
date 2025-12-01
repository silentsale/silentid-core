import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/info_point_helper.dart';
import '../../../core/widgets/gamification/gamification.dart';
import '../../../core/data/info_point_data.dart';
import '../../../core/utils/haptics.dart';

class IdentityIntroScreen extends StatefulWidget {
  const IdentityIntroScreen({super.key});

  @override
  State<IdentityIntroScreen> createState() => _IdentityIntroScreenState();
}

class _IdentityIntroScreenState extends State<IdentityIntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Level 7: Staggered animation helper for benefits
  Widget _buildAnimatedBenefit({
    required int index,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 150)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _buildBenefit(icon: icon, title: title, description: description),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AppHaptics.light();
            context.pop();
          },
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),

                // Level 7: Animated Icon with scale
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        height: 80,
                        width: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppTheme.softLilac,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryPurple.withValues(alpha: 0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.verified_user,
                          size: 48,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Level 7: Animated Title with Info Point (Section 40.4)
                SlideTransition(
                  position: _slideAnimation,
                  child: Row(
                    children: [
                      Text(
                        'Verify your identity',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepBlack,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InfoPointHelper(data: InfoPoints.stripeIdentity),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Level 7: Animated Description
                SlideTransition(
                  position: _slideAnimation,
                  child: Text(
                    'SilentID uses Stripe to securely confirm you\'re a real person. We do not store your ID documents — Stripe handles everything.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppTheme.neutralGray700,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Level 7: Staggered Benefits with animations
                _buildAnimatedBenefit(
                  index: 0,
                  icon: Icons.shield,
                  title: 'Prevent impersonation',
                  description: 'Prove you\'re a real person, not a bot or fake account',
                ),

                const SizedBox(height: 20),

                _buildAnimatedBenefit(
                  index: 1,
                  icon: Icons.trending_up,
                  title: 'Strengthen your TrustScore',
                  description: 'Identity verification adds 200 points to your score',
                ),

                const SizedBox(height: 20),

                _buildAnimatedBenefit(
                  index: 2,
                  icon: Icons.lock_open,
                  title: 'Unlock advanced features',
                  description: 'Access mutual verifications and public profile sharing',
                ),

                const Spacer(),

                // Level 7: Animated Reward indicator
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.successGreen.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const RewardIndicator(points: 200, compact: true),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Earn 200 TrustScore points for verifying',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.successGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Privacy notice
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(opacity: value, child: child);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.softLilac,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppTheme.primaryPurple,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your document photos are processed by Stripe, not SilentID.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppTheme.neutralGray900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Level 7: Animated Start verification button
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: PrimaryButton(
                    text: 'Start Verification',
                    onPressed: () {
                      AppHaptics.medium();
                      // Navigate to Stripe Identity WebView which calls backend
                      // to create verification session and loads Stripe Identity UI
                      context.push('/identity/verify');
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Level 7: Animated Maybe later button
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(opacity: value, child: child);
                  },
                  child: PrimaryButton(
                    text: 'Maybe later',
                    isSecondary: true,
                    onPressed: () {
                      AppHaptics.light();
                      context.pop();
                    },
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefit({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: AppTheme.softLilac,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryPurple,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepBlack,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.neutralGray700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
