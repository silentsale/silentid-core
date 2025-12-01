import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_spacing.dart';
import 'reward_tag.dart';

/// Milestone Progress Widget (Gamification Level 7)
///
/// Shows progress toward milestones with animated progress bar
/// Used for: Evidence milestone, Profile milestone, Identity milestone
class MilestoneProgress extends StatefulWidget {
  final String title;
  final String? subtitle;
  final int current;
  final int target;
  final int rewardPoints;
  final IconData icon;
  final Color? color;
  final bool showReward;
  final bool animate;
  final VoidCallback? onTap;

  const MilestoneProgress({
    super.key,
    required this.title,
    this.subtitle,
    required this.current,
    required this.target,
    required this.rewardPoints,
    required this.icon,
    this.color,
    this.showReward = true,
    this.animate = true,
    this.onTap,
  });

  @override
  State<MilestoneProgress> createState() => _MilestoneProgressState();
}

class _MilestoneProgressState extends State<MilestoneProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    final progress = (widget.current / widget.target).clamp(0.0, 1.0);
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    if (widget.animate) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _progressColor => widget.color ?? AppTheme.primaryPurple;
  bool get _isComplete => widget.current >= widget.target;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: _isComplete
                ? _progressColor.withValues(alpha: 0.3)
                : AppTheme.neutralGray300,
          ),
          boxShadow: _isComplete
              ? [
                  BoxShadow(
                    color: _progressColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon container
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _progressColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Icon(
                    _isComplete ? Icons.check_circle_rounded : widget.icon,
                    color: _progressColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),

                // Title and progress
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.deepBlack,
                        ),
                      ),
                      if (widget.subtitle != null)
                        Text(
                          widget.subtitle!,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppTheme.neutralGray700,
                          ),
                        ),
                    ],
                  ),
                ),

                // Reward indicator
                if (widget.showReward && !_isComplete)
                  RewardIndicator(points: widget.rewardPoints, compact: true),

                // Completed check
                if (_isComplete)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          color: AppTheme.successGreen,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Complete',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.successGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // Progress bar
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _progressAnimation.value,
                        minHeight: 6,
                        backgroundColor:
                            AppTheme.neutralGray300.withValues(alpha: 0.5),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _isComplete
                              ? AppTheme.successGreen
                              : _progressColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.current}/${widget.target}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.neutralGray700,
                          ),
                        ),
                        Text(
                          '${(_progressAnimation.value * 100).toInt()}%',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _progressColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal milestones indicator (for onboarding progress)
class HorizontalMilestones extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;

  const HorizontalMilestones({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isOdd) {
          // Connector line
          final stepIndex = index ~/ 2;
          final isCompleted = stepIndex < currentStep;
          return Expanded(
            child: Container(
              height: 2,
              color: isCompleted
                  ? AppTheme.primaryPurple
                  : AppTheme.neutralGray300,
            ),
          );
        }

        // Step circle
        final stepIndex = index ~/ 2;
        final isCompleted = stepIndex < currentStep;
        final isCurrent = stepIndex == currentStep;

        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppTheme.primaryPurple
                : isCurrent
                    ? AppTheme.primaryPurple.withValues(alpha: 0.2)
                    : AppTheme.neutralGray300.withValues(alpha: 0.5),
            border: isCurrent
                ? Border.all(color: AppTheme.primaryPurple, width: 2)
                : null,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 16,
                  )
                : Text(
                    '${stepIndex + 1}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isCurrent
                          ? AppTheme.primaryPurple
                          : AppTheme.neutralGray700,
                    ),
                  ),
          ),
        );
      }),
    );
  }
}
