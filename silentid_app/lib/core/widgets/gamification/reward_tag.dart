import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../utils/haptics.dart';

/// Reward Tag Widget (Gamification Level 7)
///
/// Displays soft reward indicators (+10, +25, +50) with pop-in animation
/// Used after completing actions: evidence upload, profile connection, verification
class RewardTag extends StatefulWidget {
  final int points;
  final bool autoAnimate;
  final VoidCallback? onAnimationComplete;
  final RewardTagStyle style;
  final bool showIcon;

  const RewardTag({
    super.key,
    required this.points,
    this.autoAnimate = true,
    this.onAnimationComplete,
    this.style = RewardTagStyle.standard,
    this.showIcon = true,
  });

  @override
  State<RewardTag> createState() => _RewardTagState();
}

enum RewardTagStyle { standard, large, inline }

class _RewardTagState extends State<RewardTag>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(_controller);

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    if (widget.autoAnimate) {
      _controller.forward().then((_) {
        AppHaptics.success();
        widget.onAnimationComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _tagColor {
    if (widget.points >= 50) return const Color(0xFFFFD700);
    if (widget.points >= 25) return AppTheme.primaryPurple;
    return AppTheme.successGreen;
  }

  double get _fontSize {
    switch (widget.style) {
      case RewardTagStyle.large:
        return 20;
      case RewardTagStyle.inline:
        return 12;
      case RewardTagStyle.standard:
        return 16;
    }
  }

  EdgeInsets get _padding {
    switch (widget.style) {
      case RewardTagStyle.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case RewardTagStyle.inline:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case RewardTagStyle.standard:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: _padding,
              decoration: BoxDecoration(
                color: _tagColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _tagColor.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _tagColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showIcon) ...[
                    Icon(
                      Icons.add_circle_rounded,
                      color: _tagColor,
                      size: _fontSize * 1.1,
                    ),
                    SizedBox(width: widget.style == RewardTagStyle.inline ? 2 : 4),
                  ],
                  Text(
                    '+${widget.points}',
                    style: GoogleFonts.inter(
                      fontSize: _fontSize,
                      fontWeight: FontWeight.bold,
                      color: _tagColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Static reward indicator (no animation)
class RewardIndicator extends StatelessWidget {
  final int points;
  final bool compact;

  const RewardIndicator({
    super.key,
    required this.points,
    this.compact = false,
  });

  Color get _tagColor {
    if (points >= 50) return const Color(0xFFFFD700);
    if (points >= 25) return AppTheme.primaryPurple;
    return AppTheme.successGreen;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: _tagColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '+$points',
        style: GoogleFonts.inter(
          fontSize: compact ? 10 : 12,
          fontWeight: FontWeight.w600,
          color: _tagColor,
        ),
      ),
    );
  }
}
