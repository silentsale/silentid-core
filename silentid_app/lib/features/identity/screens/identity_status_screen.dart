import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/gamification/gamification.dart';
import '../../../core/utils/haptics.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/api_constants.dart';

enum VerificationStatus {
  pending,
  verified,
  failed,
  needsRetry,
}

class IdentityStatusScreen extends StatefulWidget {
  const IdentityStatusScreen({super.key});

  @override
  State<IdentityStatusScreen> createState() => _IdentityStatusScreenState();
}

class _IdentityStatusScreenState extends State<IdentityStatusScreen>
    with TickerProviderStateMixin {
  final _api = ApiService();
  bool _isLoading = true;
  VerificationStatus _status = VerificationStatus.pending;
  String _message = '';

  // Level 7: Animation controllers
  late AnimationController _animController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // Level 7: Initialize animations
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _checkStatus();
  }

  @override
  void dispose() {
    _animController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _checkStatus() async {
    setState(() => _isLoading = true);

    try {
      final response = await _api.get(ApiConstants.identityStatus);
      final status = response.data['status']?.toString().toLowerCase();

      setState(() {
        switch (status) {
          case 'verified':
            _status = VerificationStatus.verified;
            _message = 'Identity Verified';
            break;
          case 'failed':
            _status = VerificationStatus.failed;
            _message = 'Verification unsuccessful';
            break;
          case 'needs_retry':
            _status = VerificationStatus.needsRetry;
            _message = 'We couldn\'t verify your ID';
            break;
          default:
            _status = VerificationStatus.pending;
            _message = 'Verification in progress';
        }
        _isLoading = false;
      });
      // Level 7: Start animations after data loads
      _animController.forward();
      if (_status == VerificationStatus.verified) {
        _pulseController.repeat(reverse: true);
      }
    } catch (e) {
      setState(() {
        _status = VerificationStatus.pending;
        _message = 'Unable to check status';
        _isLoading = false;
      });
      _animController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verification Status',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppTheme.deepBlack,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AppHaptics.light();
            context.pop();
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryPurple))
          : SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 48),

                      // Level 7: Animated status icon with pulse
                      Center(
                        child: AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: _status == VerificationStatus.verified
                                  ? AnimatedBuilder(
                                      animation: _pulseAnimation,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: _pulseAnimation.value,
                                          child: _buildStatusIcon(),
                                        );
                                      },
                                    )
                                  : _buildStatusIcon(),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Level 7: Animated status message
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          _message,
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.deepBlack,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Status description
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: child,
                          );
                        },
                        child: Text(
                          _getStatusDescription(),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: AppTheme.neutralGray700,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Level 7: Status badge with gamification (only if verified)
                      if (_status == VerificationStatus.verified)
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
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.softLilac,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryPurple.withValues(alpha: 0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.successGreen.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.verified,
                                    color: AppTheme.successGreen,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Identity Verified via Stripe',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.deepBlack,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const RewardIndicator(points: 200, compact: true),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const Spacer(),

                      // Level 7: Animated action button
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: PrimaryButton(
                          text: _getButtonText(),
                          onPressed: () {
                            AppHaptics.medium();
                            _getButtonAction()();
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Secondary button
                      if (_status != VerificationStatus.verified)
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Opacity(opacity: value, child: child);
                          },
                          child: PrimaryButton(
                            text: 'Go Back',
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

  Widget _buildStatusIcon() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.1),
        shape: BoxShape.circle,
        boxShadow: _status == VerificationStatus.verified
            ? [
                BoxShadow(
                  color: _getStatusColor().withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Icon(
        _getStatusIcon(),
        size: 64,
        color: _getStatusColor(),
      ),
    );
  }

  Color _getStatusColor() {
    switch (_status) {
      case VerificationStatus.verified:
        return AppTheme.successGreen;
      case VerificationStatus.failed:
      case VerificationStatus.needsRetry:
        return AppTheme.dangerRed;
      case VerificationStatus.pending:
        return AppTheme.warningAmber;
    }
  }

  IconData _getStatusIcon() {
    switch (_status) {
      case VerificationStatus.verified:
        return Icons.check_circle;
      case VerificationStatus.failed:
      case VerificationStatus.needsRetry:
        return Icons.error;
      case VerificationStatus.pending:
        return Icons.hourglass_empty;
    }
  }

  String _getStatusDescription() {
    switch (_status) {
      case VerificationStatus.verified:
        return 'Your identity has been successfully verified. You\'ve earned +200 TrustScore points and unlocked advanced features.';
      case VerificationStatus.failed:
        return 'We were unable to verify your identity. Please ensure your documents are clear and try again.';
      case VerificationStatus.needsRetry:
        return 'Your documents didn\'t meet the requirements. Please try again with a different photo.';
      case VerificationStatus.pending:
        return 'We\'re processing your verification. This usually takes a few moments. Check back soon.';
    }
  }

  String _getButtonText() {
    switch (_status) {
      case VerificationStatus.verified:
        return 'View My Profile';
      case VerificationStatus.failed:
      case VerificationStatus.needsRetry:
        return 'Try Again';
      case VerificationStatus.pending:
        return 'Refresh Status';
    }
  }

  VoidCallback _getButtonAction() {
    return () {
      switch (_status) {
        case VerificationStatus.verified:
          context.go('/home');
          break;
        case VerificationStatus.failed:
        case VerificationStatus.needsRetry:
          context.push('/identity/verify');
          break;
        case VerificationStatus.pending:
          _checkStatus();
          break;
      }
    };
  }
}
