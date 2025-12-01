import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_spacing.dart';

/// Level Badge Widget (Gamification Level 7)
///
/// Displays user level (1-10) with animated glow effect
/// Used in profile headers, TrustScore cards, and achievement displays
class LevelBadge extends StatefulWidget {
  final int level;
  final double size;
  final bool showLabel;
  final bool animated;
  final bool showGlow;

  const LevelBadge({
    super.key,
    required this.level,
    this.size = 48,
    this.showLabel = true,
    this.animated = true,
    this.showGlow = true,
  });

  @override
  State<LevelBadge> createState() => _LevelBadgeState();
}

class _LevelBadgeState extends State<LevelBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    if (widget.animated && widget.showGlow) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Color get _levelColor {
    if (widget.level >= 9) return const Color(0xFFFFD700); // Gold
    if (widget.level >= 7) return AppTheme.primaryPurple;
    if (widget.level >= 5) return const Color(0xFF3B82F6); // Blue
    if (widget.level >= 3) return AppTheme.successGreen;
    return AppTheme.neutralGray700;
  }

  String get _levelLabel {
    if (widget.level >= 9) return 'Elite';
    if (widget.level >= 7) return 'Expert';
    if (widget.level >= 5) return 'Advanced';
    if (widget.level >= 3) return 'Rising';
    return 'Starter';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _levelColor,
                    _levelColor.withValues(alpha: 0.8),
                  ],
                ),
                boxShadow: widget.showGlow
                    ? [
                        BoxShadow(
                          color: _levelColor
                              .withValues(alpha: _glowAnimation.value),
                          blurRadius: widget.size * 0.4,
                          spreadRadius: widget.size * 0.1,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  '${widget.level}',
                  style: GoogleFonts.inter(
                    fontSize: widget.size * 0.45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
        if (widget.showLabel) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            _levelLabel,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _levelColor,
            ),
          ),
        ],
      ],
    );
  }
}

/// Compact level indicator for inline use
class LevelIndicator extends StatelessWidget {
  final int level;
  final double height;

  const LevelIndicator({
    super.key,
    required this.level,
    this.height = 24,
  });

  Color get _levelColor {
    if (level >= 9) return const Color(0xFFFFD700);
    if (level >= 7) return AppTheme.primaryPurple;
    if (level >= 5) return const Color(0xFF3B82F6);
    if (level >= 3) return AppTheme.successGreen;
    return AppTheme.neutralGray700;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _levelColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _levelColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: _levelColor,
            size: height * 0.7,
          ),
          const SizedBox(width: 4),
          Text(
            'Lv.$level',
            style: GoogleFonts.inter(
              fontSize: height * 0.5,
              fontWeight: FontWeight.w600,
              color: _levelColor,
            ),
          ),
        ],
      ),
    );
  }
}
