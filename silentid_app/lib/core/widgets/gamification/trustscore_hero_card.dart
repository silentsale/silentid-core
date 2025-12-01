import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_spacing.dart';
import '../../utils/haptics.dart';
import 'level_badge.dart';

/// TrustScore Hero Card (Gamification Level 7)
///
/// Animated TrustScore display with ring progress, level indicator,
/// and premium visual effects. This is the main TrustScore display
/// on the home dashboard.
class TrustScoreHeroCard extends StatefulWidget {
  final int trustScore;
  final int maxScore;
  final int userLevel;
  final String trustLabel;
  final VoidCallback? onTap;
  final bool showLevel;
  final bool animate;

  const TrustScoreHeroCard({
    super.key,
    required this.trustScore,
    this.maxScore = 1000,
    this.userLevel = 1,
    required this.trustLabel,
    this.onTap,
    this.showLevel = true,
    this.animate = true,
  });

  @override
  State<TrustScoreHeroCard> createState() => _TrustScoreHeroCardState();
}

class _TrustScoreHeroCardState extends State<TrustScoreHeroCard>
    with TickerProviderStateMixin {
  late AnimationController _ringController;
  late AnimationController _scoreController;
  late AnimationController _pulseController;
  late Animation<double> _ringAnimation;
  late Animation<int> _scoreAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Ring animation
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _ringAnimation = Tween<double>(
      begin: 0.0,
      end: widget.trustScore / widget.maxScore,
    ).animate(CurvedAnimation(
      parent: _ringController,
      curve: Curves.easeOutCubic,
    ));

    // Score counter animation
    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreAnimation = IntTween(
      begin: 0,
      end: widget.trustScore,
    ).animate(CurvedAnimation(
      parent: _scoreController,
      curve: Curves.easeOutCubic,
    ));

    // Subtle pulse animation for the ring
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.animate) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _ringController.forward();
          _scoreController.forward();
          _pulseController.repeat(reverse: true);
        }
      });
    } else {
      _ringController.value = 1.0;
      _scoreController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _ringController.dispose();
    _scoreController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color get _scoreColor {
    if (widget.trustScore >= 850) return const Color(0xFFFFD700);
    if (widget.trustScore >= 700) return AppTheme.successGreen;
    if (widget.trustScore >= 550) return const Color(0xFF3B82F6);
    if (widget.trustScore >= 400) return AppTheme.warningAmber;
    return AppTheme.dangerRed;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppHaptics.light();
        widget.onTap?.call();
      },
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryPurple,
                    AppTheme.darkModePurple,
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header with level
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your TrustScore',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      if (widget.showLevel)
                        LevelIndicator(
                          level: widget.userLevel,
                          height: 28,
                        ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Animated ring with score
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background ring
                        CustomPaint(
                          size: const Size(180, 180),
                          painter: _TrustScoreRingPainter(
                            progress: 1.0,
                            strokeWidth: 14,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        // Progress ring
                        AnimatedBuilder(
                          animation: _ringAnimation,
                          builder: (context, child) {
                            return CustomPaint(
                              size: const Size(180, 180),
                              painter: _TrustScoreRingPainter(
                                progress: _ringAnimation.value,
                                strokeWidth: 14,
                                color: _scoreColor,
                                showGradient: true,
                              ),
                            );
                          },
                        ),
                        // Score display
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedBuilder(
                              animation: _scoreAnimation,
                              builder: (context, child) {
                                return Text(
                                  '${_scoreAnimation.value}',
                                  style: GoogleFonts.inter(
                                    fontSize: 52,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _scoreColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.trustLabel,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // View details CTA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View Breakdown',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TrustScoreRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final bool showGradient;

  _TrustScoreRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    this.showGradient = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (showGradient) {
      paint.shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [
          color.withValues(alpha: 0.5),
          color,
          color,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    } else {
      paint.color = color;
    }

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_TrustScoreRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Compact TrustScore card for inline display
class TrustScoreCompactCard extends StatelessWidget {
  final int trustScore;
  final String trustLabel;
  final VoidCallback? onTap;

  const TrustScoreCompactCard({
    super.key,
    required this.trustScore,
    required this.trustLabel,
    this.onTap,
  });

  Color get _scoreColor {
    if (trustScore >= 850) return const Color(0xFFFFD700);
    if (trustScore >= 700) return AppTheme.successGreen;
    if (trustScore >= 550) return const Color(0xFF3B82F6);
    if (trustScore >= 400) return AppTheme.warningAmber;
    return AppTheme.dangerRed;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppHaptics.light();
        onTap?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryPurple,
              AppTheme.darkModePurple,
            ],
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryPurple.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mini ring
            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: trustScore / 1000,
                    strokeWidth: 3,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(_scoreColor),
                  ),
                  Text(
                    '$trustScore',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TrustScore',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  trustLabel,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
