import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// SilentID Gamification Animation System - SuperDesign Level 7+
/// Provides consistent premium animations across all screens

// ============================================================================
// PARTICLE SYSTEM
// ============================================================================

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final Color color;

  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final animatedY = (particle.y + progress * particle.speed) % 1.0;
      final x = particle.x * size.width;
      final y = animatedY * size.height;
      final edgeFade = (1 - (animatedY - 0.5).abs() * 2).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = color.withOpacity(particle.opacity * edgeFade)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), particle.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

List<Particle> generateParticles({int count = 15}) {
  final random = math.Random();
  return List.generate(count, (_) => Particle(
    x: random.nextDouble(),
    y: random.nextDouble(),
    size: random.nextDouble() * 8 + 4,
    speed: random.nextDouble() * 0.5 + 0.2,
    opacity: random.nextDouble() * 0.3 + 0.1,
  ));
}

// ============================================================================
// SHIELD LOGO PAINTER
// ============================================================================

class ShieldLogoPainter extends CustomPainter {
  final Color color;
  final Color? backgroundColor;

  ShieldLogoPainter({required this.color, this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shieldPath = Path();
    final w = size.width;
    final h = size.height;

    shieldPath.moveTo(w * 0.1, h * 0.15);
    shieldPath.quadraticBezierTo(w * 0.1, h * 0.05, w * 0.25, h * 0.05);
    shieldPath.lineTo(w * 0.5, h * 0.02);
    shieldPath.lineTo(w * 0.75, h * 0.05);
    shieldPath.quadraticBezierTo(w * 0.9, h * 0.05, w * 0.9, h * 0.15);
    shieldPath.lineTo(w * 0.9, h * 0.45);
    shieldPath.quadraticBezierTo(w * 0.9, h * 0.7, w * 0.5, h * 0.98);
    shieldPath.quadraticBezierTo(w * 0.1, h * 0.7, w * 0.1, h * 0.45);
    shieldPath.close();

    canvas.drawPath(shieldPath, paint);

    final cutoutPaint = Paint()
      ..color = backgroundColor ?? AppTheme.softLilac
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(w * 0.5, h * 0.35), w * 0.12, cutoutPaint);

    final keyholePath = Path();
    keyholePath.moveTo(w * 0.42, h * 0.42);
    keyholePath.lineTo(w * 0.38, h * 0.7);
    keyholePath.lineTo(w * 0.62, h * 0.7);
    keyholePath.lineTo(w * 0.58, h * 0.42);
    keyholePath.close();

    canvas.drawPath(keyholePath, cutoutPaint);
  }

  @override
  bool shouldRepaint(covariant ShieldLogoPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.backgroundColor != backgroundColor;
  }
}

// ============================================================================
// ANIMATED WIDGETS
// ============================================================================

/// Floating particle background
class ParticleBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final Color? particleColor;

  const ParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 15,
    this.particleColor,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = generateParticles(count: widget.particleCount);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlePainter(
                particles: _particles,
                progress: _controller.value,
                color: widget.particleColor ?? AppTheme.primaryPurple.withOpacity(0.3),
              ),
              size: Size.infinite,
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

/// Pulsing glow effect widget
class PulsingGlow extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double maxRadius;

  const PulsingGlow({
    super.key,
    required this.child,
    this.glowColor = const Color(0xFF5A3EB8),
    this.maxRadius = 20,
  });

  @override
  State<PulsingGlow> createState() => _PulsingGlowState();
}

class _PulsingGlowState extends State<PulsingGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(0.3 * _controller.value),
                blurRadius: widget.maxRadius * _controller.value,
                spreadRadius: widget.maxRadius * 0.5 * _controller.value,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Rotating shine effect
class RotatingShine extends StatefulWidget {
  final Widget child;
  final double size;

  const RotatingShine({
    super.key,
    required this.child,
    this.size = 100,
  });

  @override
  State<RotatingShine> createState() => _RotatingShineState();
}

class _RotatingShineState extends State<RotatingShine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * math.pi,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

/// Staggered fade-in animation
class StaggeredFadeIn extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final Offset slideOffset;

  const StaggeredFadeIn({
    super.key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 100),
    this.duration = const Duration(milliseconds: 500),
    this.slideOffset = const Offset(0, 20),
  });

  @override
  State<StaggeredFadeIn> createState() => _StaggeredFadeInState();
}

class _StaggeredFadeInState extends State<StaggeredFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(widget.delay * widget.index, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Floating animation widget
class FloatingWidget extends StatefulWidget {
  final Widget child;
  final double amplitude;
  final Duration duration;

  const FloatingWidget({
    super.key,
    required this.child,
    this.amplitude = 5,
    this.duration = const Duration(milliseconds: 3000),
  });

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = math.sin(_controller.value * math.pi) * widget.amplitude;
        return Transform.translate(
          offset: Offset(0, offset),
          child: widget.child,
        );
      },
    );
  }
}

/// Animated counter
class AnimatedCounter extends StatefulWidget {
  final int targetValue;
  final Duration duration;
  final TextStyle? style;
  final String? prefix;
  final String? suffix;

  const AnimatedCounter({
    super.key,
    required this.targetValue,
    this.duration = const Duration(milliseconds: 2000),
    this.style,
    this.prefix,
    this.suffix,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addListener(() {
      setState(() {
        _currentValue = (widget.targetValue *
            Curves.easeOutCubic.transform(_controller.value))
            .toInt();
      });
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(int value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}k';
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.prefix ?? ''}${_formatNumber(_currentValue)}${widget.suffix ?? ''}',
      style: widget.style,
    );
  }
}

/// Gradient background with animated gradient
class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color>? colors;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.colors,
  });

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors ?? [
      Colors.white,
      AppTheme.softLilac.withOpacity(0.3),
      AppTheme.softLilac.withOpacity(0.5),
    ];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
              stops: [
                0.0,
                0.5 + (_controller.value * 0.1),
                1.0,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Level badge with shine effect (renamed to avoid collision with widgets/gamification/level_badge.dart)
class AnimatedLevelBadge extends StatelessWidget {
  final int level;
  final String label;
  final double size;

  const AnimatedLevelBadge({
    super.key,
    required this.level,
    required this.label,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return RotatingShine(
      size: size + 20,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade200,
              Colors.grey.shade300,
            ],
          ),
          border: Border.all(
            color: AppTheme.primaryPurple.withOpacity(0.3),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryPurple.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LEVEL',
              style: TextStyle(
                fontSize: size * 0.12,
                fontWeight: FontWeight.w500,
                color: AppTheme.neutralGray700,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              level.toString(),
              style: TextStyle(
                fontSize: size * 0.35,
                fontWeight: FontWeight.bold,
                color: AppTheme.deepBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// TrustScore ring indicator
class TrustScoreRing extends StatefulWidget {
  final int score;
  final double size;
  final double strokeWidth;

  const TrustScoreRing({
    super.key,
    required this.score,
    this.size = 150,
    this.strokeWidth = 12,
  });

  @override
  State<TrustScoreRing> createState() => _TrustScoreRingState();
}

class _TrustScoreRingState extends State<TrustScoreRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getScoreColor(int score) {
    if (score >= 850) return const Color(0xFF1FBF71);
    if (score >= 700) return const Color(0xFF4CAF50);
    if (score >= 550) return const Color(0xFFFFC107);
    if (score >= 400) return const Color(0xFFFF9800);
    return const Color(0xFFE53935);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = Curves.easeOutCubic.transform(_controller.value);
        final displayScore = (widget.score * progress).toInt();
        final percentage = (displayScore / 1000) * progress;

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background ring
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: widget.strokeWidth,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(Colors.grey.shade200),
                ),
              ),
              // Progress ring
              SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: widget.strokeWidth,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(_getScoreColor(widget.score)),
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Score text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    displayScore.toString(),
                    style: TextStyle(
                      fontSize: widget.size * 0.25,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.deepBlack,
                    ),
                  ),
                  Text(
                    'TrustScore',
                    style: TextStyle(
                      fontSize: widget.size * 0.1,
                      color: AppTheme.neutralGray700,
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
}

/// Haptic feedback helper
class GamificationHaptics {
  static void light() => HapticFeedback.lightImpact();
  static void medium() => HapticFeedback.mediumImpact();
  static void heavy() => HapticFeedback.heavyImpact();
  static void selection() => HapticFeedback.selectionClick();
  static void success() => HapticFeedback.mediumImpact();
  static void error() => HapticFeedback.heavyImpact();
}

/// Premium card with hover effect
class PremiumCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  State<PremiumCard> createState() => _PremiumCardState();
}

class _PremiumCardState extends State<PremiumCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
        GamificationHaptics.light();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1.0 - (_controller.value * 0.02);
          return Transform.scale(
            scale: scale,
            child: Container(
              margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              padding: widget.padding ?? const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withOpacity(_isPressed ? 0.15 : 0.08),
                    blurRadius: _isPressed ? 20 : 15,
                    offset: Offset(0, _isPressed ? 8 : 5),
                  ),
                ],
                border: Border.all(
                  color: AppTheme.primaryPurple.withOpacity(_isPressed ? 0.2 : 0.1),
                  width: 1,
                ),
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

/// Progress bar with animation
class AnimatedProgressBar extends StatefulWidget {
  final double progress;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final Duration duration;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.height = 8,
    this.backgroundColor,
    this.progressColor,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final animatedProgress = widget.progress * Curves.easeOutCubic.transform(_controller.value);
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.grey.shade200,
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: animatedProgress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: widget.progressColor ?? AppTheme.primaryPurple,
                borderRadius: BorderRadius.circular(widget.height / 2),
                boxShadow: [
                  BoxShadow(
                    color: (widget.progressColor ?? AppTheme.primaryPurple).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
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
