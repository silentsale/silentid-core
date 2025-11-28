import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Onboarding Checklist Widget (Section 50.2.2)
///
/// Progress bar checklist shown on Home Screen for new users:
/// 1. Verify identity
/// 2. Connect one external profile
/// 3. Get first mutual verification
///
/// Each completed step triggers haptics, celebration, and visible TrustScore jump.
class OnboardingChecklist extends StatefulWidget {
  final bool identityVerified;
  final bool profileConnected;
  final bool mutualVerificationComplete;
  final VoidCallback? onVerifyIdentityTap;
  final VoidCallback? onConnectProfileTap;
  final VoidCallback? onMutualVerificationTap;
  final VoidCallback? onDismiss;

  const OnboardingChecklist({
    super.key,
    required this.identityVerified,
    required this.profileConnected,
    required this.mutualVerificationComplete,
    this.onVerifyIdentityTap,
    this.onConnectProfileTap,
    this.onMutualVerificationTap,
    this.onDismiss,
  });

  /// Calculate completion percentage
  int get completedSteps {
    int count = 0;
    if (identityVerified) count++;
    if (profileConnected) count++;
    if (mutualVerificationComplete) count++;
    return count;
  }

  double get progressPercent => completedSteps / 3;

  bool get isComplete => completedSteps == 3;

  @override
  State<OnboardingChecklist> createState() => _OnboardingChecklistState();
}

class _OnboardingChecklistState extends State<OnboardingChecklist>
    with SingleTickerProviderStateMixin {
  late AnimationController _celebrationController;
  int _lastCompletedSteps = 0;

  @override
  void initState() {
    super.initState();
    _lastCompletedSteps = widget.completedSteps;
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void didUpdateWidget(OnboardingChecklist oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if a new step was completed
    if (widget.completedSteps > _lastCompletedSteps) {
      _triggerCelebration();
      _lastCompletedSteps = widget.completedSteps;
    }
  }

  void _triggerCelebration() {
    HapticFeedback.mediumImpact();
    _celebrationController.forward(from: 0);
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Don't show if all complete and user dismisses
    if (widget.isComplete) {
      return _buildCompletionCard();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.rocket_launch,
                    color: AppTheme.primaryPurple,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Quick Start',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.deepBlack,
                    ),
                  ),
                ],
              ),
              Text(
                '${widget.completedSteps}/3',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: widget.progressPercent),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: AppTheme.neutralGray300,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryPurple,
                  ),
                  minHeight: 8,
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Checklist items
          _buildChecklistItem(
            step: 1,
            title: 'Verify your identity',
            subtitle: 'Quick ID check via Stripe',
            isComplete: widget.identityVerified,
            icon: Icons.verified_user_outlined,
            onTap: widget.identityVerified ? null : widget.onVerifyIdentityTap,
          ),

          const SizedBox(height: 12),

          _buildChecklistItem(
            step: 2,
            title: 'Connect a profile',
            subtitle: 'Link Vinted, eBay, or Depop',
            isComplete: widget.profileConnected,
            icon: Icons.link,
            onTap: widget.profileConnected ? null : widget.onConnectProfileTap,
          ),

          const SizedBox(height: 12),

          _buildChecklistItem(
            step: 3,
            title: 'Get verified',
            subtitle: 'Complete a mutual verification',
            isComplete: widget.mutualVerificationComplete,
            icon: Icons.people_outline,
            onTap: widget.mutualVerificationComplete
                ? null
                : widget.onMutualVerificationTap,
          ),

          const SizedBox(height: 16),

          // Motivational text
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.softLilac.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.primaryPurple,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getMotivationalText(),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.neutralGray900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem({
    required int step,
    required String title,
    required String subtitle,
    required bool isComplete,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return AnimatedBuilder(
      animation: _celebrationController,
      builder: (context, child) {
        final scale = isComplete && _celebrationController.isAnimating
            ? 1.0 + (_celebrationController.value * 0.05)
            : 1.0;

        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isComplete
                ? AppTheme.successGreen.withValues(alpha: 0.1)
                : AppTheme.neutralGray300.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isComplete
                  ? AppTheme.successGreen.withValues(alpha: 0.3)
                  : AppTheme.neutralGray300,
            ),
          ),
          child: Row(
            children: [
              // Status indicator
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isComplete
                      ? AppTheme.successGreen
                      : AppTheme.neutralGray300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isComplete ? Icons.check : icon,
                  color: isComplete ? Colors.white : AppTheme.neutralGray700,
                  size: 18,
                ),
              ),

              const SizedBox(width: 12),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isComplete
                            ? AppTheme.successGreen
                            : AppTheme.deepBlack,
                        decoration:
                            isComplete ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.neutralGray700,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow or checkmark
              if (!isComplete)
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.neutralGray700,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.successGreen,
            AppTheme.successGreen.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.successGreen.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.celebration,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Start Complete!',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'You\'re all set to build your trust reputation.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          if (widget.onDismiss != null)
            IconButton(
              onPressed: widget.onDismiss,
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  String _getMotivationalText() {
    if (widget.completedSteps == 0) {
      return 'Complete these steps to boost your TrustScore by up to 300 points!';
    } else if (widget.completedSteps == 1) {
      return 'Great start! Two more steps to unlock your full trust potential.';
    } else if (widget.completedSteps == 2) {
      return 'Almost there! One more step to complete your trust profile.';
    }
    return 'Congratulations! Your trust foundation is complete.';
  }
}
