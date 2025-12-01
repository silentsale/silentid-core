import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_spacing.dart';

/// Animated Progress Ring Widget (Gamification Level 7)
///
/// Circular progress indicator with smooth animation
/// Used for TrustScore display, milestone progress, completion tracking
class AnimatedProgressRing extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final Widget? center;
  final bool animate;
  final Duration animationDuration;
  final bool showPercentage;
  final String? label;

  const AnimatedProgressRing({
    super.key,
    required this.progress,
    this.size = 120,
    this.strokeWidth = 12,
    this.progressColor,
    this.backgroundColor,
    this.center,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 1200),
    this.showPercentage = false,
    this.label,
  });

  @override
  State<AnimatedProgressRing> createState() => _AnimatedProgressRingState();
}

class _AnimatedProgressRingState extends State<AnimatedProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressColor = widget.progressColor ?? AppTheme.primaryPurple;
    final backgroundColor =
        widget.backgroundColor ?? AppTheme.neutralGray300.withValues(alpha: 0.3);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: _ProgressRingPainter(
                  progress: _progressAnimation.value,
                  strokeWidth: widget.strokeWidth,
                  progressColor: progressColor,
                  backgroundColor: backgroundColor,
                ),
                child: Center(
                  child: widget.center ??
                      (widget.showPercentage
                          ? Text(
                              '${(_progressAnimation.value * 100).toInt()}%',
                              style: GoogleFonts.inter(
                                fontSize: widget.size * 0.2,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.deepBlack,
                              ),
                            )
                          : null),
                ),
              );
            },
          ),
        ),
        if (widget.label != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.label!,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.neutralGray700,
            ),
          ),
        ],
      ],
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;

  _ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Multi-segment progress ring (for TrustScore breakdown)
class MultiSegmentProgressRing extends StatefulWidget {
  final List<ProgressSegment> segments;
  final double size;
  final double strokeWidth;
  final Widget? center;
  final bool animate;

  const MultiSegmentProgressRing({
    super.key,
    required this.segments,
    this.size = 160,
    this.strokeWidth = 16,
    this.center,
    this.animate = true,
  });

  @override
  State<MultiSegmentProgressRing> createState() =>
      _MultiSegmentProgressRingState();
}

class ProgressSegment {
  final double value; // 0.0 to 1.0
  final Color color;
  final String label;

  const ProgressSegment({
    required this.value,
    required this.color,
    required this.label,
  });
}

class _MultiSegmentProgressRingState extends State<MultiSegmentProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _MultiSegmentRingPainter(
              segments: widget.segments,
              strokeWidth: widget.strokeWidth,
              animationValue: _controller.value,
            ),
            child: Center(child: widget.center),
          );
        },
      ),
    );
  }
}

class _MultiSegmentRingPainter extends CustomPainter {
  final List<ProgressSegment> segments;
  final double strokeWidth;
  final double animationValue;

  _MultiSegmentRingPainter({
    required this.segments,
    required this.strokeWidth,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = AppTheme.neutralGray300.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw segments
    double startAngle = -math.pi / 2;
    final totalValue =
        segments.fold<double>(0, (sum, seg) => sum + seg.value);
    final gapAngle = 0.05; // Small gap between segments

    for (final segment in segments) {
      final segmentSweep =
          (segment.value / totalValue) * 2 * math.pi * animationValue;

      if (segmentSweep > 0) {
        final segmentPaint = Paint()
          ..color = segment.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle + gapAngle / 2,
          segmentSweep - gapAngle,
          false,
          segmentPaint,
        );
      }

      startAngle += segmentSweep;
    }
  }

  @override
  bool shouldRepaint(_MultiSegmentRingPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
