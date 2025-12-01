import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_spacing.dart';
import '../../utils/haptics.dart';

/// Interactive Card Widget (Interactivity Level 7)
///
/// Card with lift-on-tap, scale animation, and haptic feedback
/// Provides premium Apple-quality interaction feel
class InteractiveCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final bool enableLift;
  final bool enableScale;
  final bool enableHaptic;
  final double liftAmount;
  final double scaleAmount;

  const InteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.enableLift = true,
    this.enableScale = true,
    this.enableHaptic = true,
    this.liftAmount = 4.0,
    this.scaleAmount = 0.98,
  });

  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleAmount,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: widget.liftAmount,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null || widget.onLongPress != null) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTap() {
    if (widget.enableHaptic) {
      AppHaptics.light();
    }
    widget.onTap?.call();
  }

  void _handleLongPress() {
    if (widget.enableHaptic) {
      AppHaptics.medium();
    }
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap != null ? _handleTap : null,
        onLongPress: widget.onLongPress != null ? _handleLongPress : null,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.enableScale ? _scaleAnimation.value : 1.0,
              child: Transform.translate(
                offset: widget.enableLift
                    ? Offset(0, -_elevationAnimation.value)
                    : Offset.zero,
                child: Container(
                  padding: widget.padding ?? const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ?? Colors.white,
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? AppSpacing.radiusMd,
                    ),
                    border: Border.all(
                      color: widget.borderColor ?? AppTheme.neutralGray300,
                    ),
                    boxShadow: widget.enableLift && _isPressed
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8 + _elevationAnimation.value * 2,
                              offset: Offset(0, 2 + _elevationAnimation.value),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  child: widget.child,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Quick Action Card with icon, title, subtitle and arrow
class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Widget? trailing;
  final bool showArrow;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.trailing,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (iconColor ?? AppTheme.primaryPurple).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppTheme.primaryPurple,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepBlack,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),

          // Trailing widget or arrow
          if (trailing != null)
            trailing!
          else if (showArrow)
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.neutralGray700,
              size: 24,
            ),
        ],
      ),
    );
  }
}

/// Feature highlight card with gradient background
class FeatureHighlightCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;
  final List<Color>? gradientColors;

  const FeatureHighlightCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ??
        [
          AppTheme.primaryPurple,
          AppTheme.darkModePurple,
        ];

    return InteractiveCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      borderColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white.withValues(alpha: 0.8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
