import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/info_point_helper.dart';
import '../../../core/data/info_point_data.dart';
import '../../../core/utils/haptics.dart';
import '../../../services/auth_service.dart';
import '../../../services/referral_api_service.dart';

/// OTP Screen - SuperDesign Level 7+
/// Animated verification with gamification elements
class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with TickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  final _authService = AuthService();
  final _referralApi = ReferralApiService();
  final _referralCodeController = TextEditingController();

  bool _isLoading = false;
  bool _canResend = false;
  int _resendTimer = 30;
  Timer? _timer;
  String? _errorMessage;
  bool _showReferralInput = false;
  bool _referralCodeValid = false;
  bool _isValidatingReferral = false;

  // Animations
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.05, 0),
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _referralCodeController.dispose();
    _timer?.cancel();
    _fadeController.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _validateReferralCode(String code) async {
    if (code.isEmpty) {
      setState(() {
        _referralCodeValid = false;
        _isValidatingReferral = false;
      });
      return;
    }

    setState(() => _isValidatingReferral = true);

    try {
      final isValid = await _referralApi.validateReferralCode(code);
      if (mounted) {
        setState(() {
          _referralCodeValid = isValid;
          _isValidatingReferral = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _referralCodeValid = false;
          _isValidatingReferral = false;
        });
      }
    }
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendTimer = 30;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  Future<void> _resendCode() async {
    AppHaptics.light();
    final result = await _authService.requestOtp(widget.email);

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: AppTheme.successGreen,
        ),
      );
      _startResendTimer();
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: AppTheme.dangerRed,
        ),
      );
    }
  }

  String _getOtpCode() {
    return _controllers.map((c) => c.text).join();
  }

  void _triggerShake() {
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
    AppHaptics.error();
  }

  Future<void> _verifyOtp() async {
    final code = _getOtpCode();

    if (code.length != 6) {
      setState(() {
        _errorMessage = 'Please enter the complete 6-digit code';
      });
      _triggerShake();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _authService.verifyOtp(widget.email, code);

      if (!mounted) return;

      if (result['success']) {
        AppHaptics.success();
        final referralCode = _referralCodeController.text.trim();
        if (referralCode.isNotEmpty && _referralCodeValid) {
          try {
            await _referralApi.applyReferralCode(referralCode);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Referral code applied! You\'ll both get +50 TrustScore when you verify your identity.'),
                  backgroundColor: AppTheme.successGreen,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          } catch (e) {
            debugPrint('Failed to apply referral code: $e');
          }
        }

        if (mounted) {
          context.go('/home');
        }
      } else {
        setState(() {
          _errorMessage = result['message'];
          _isLoading = false;
        });
        _triggerShake();

        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _isLoading = false;
      });
      _triggerShake();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.neutralGray900),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),

                // Animated email icon
                Center(
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.softLilac,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryPurple.withValues(alpha: 0.2),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.mark_email_unread_outlined,
                            size: 40,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Check your email',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutralGray900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InfoPointHelper(data: InfoPoints.emailOTP),
                  ],
                ),

                const SizedBox(height: 12),

                // Subtitle with email
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppTheme.neutralGray700,
                      ),
                      children: [
                        const TextSpan(text: 'We\'ve sent a 6-digit code to\n'),
                        TextSpan(
                          text: widget.email,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // OTP input fields with shake animation
                SlideTransition(
                  position: _shakeAnimation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: _buildOtpField(index),
                          );
                        },
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 24),

                // Resend timer with circular progress
                Center(
                  child: _canResend
                      ? TextButton.icon(
                          onPressed: _resendCode,
                          icon: Icon(Icons.refresh, color: AppTheme.primaryPurple, size: 18),
                          label: Text(
                            'Resend code',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryPurple,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                value: _resendTimer / 30,
                                strokeWidth: 2,
                                backgroundColor: AppTheme.neutralGray300,
                                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Resend in ${_resendTimer}s',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppTheme.neutralGray700,
                              ),
                            ),
                          ],
                        ),
                ),

                const SizedBox(height: 32),

                // Verify button
                PrimaryButton(
                  text: 'Verify & Continue',
                  isLoading: _isLoading,
                  onPressed: _getOtpCode().length == 6 ? _verifyOtp : null,
                ),

                const SizedBox(height: 16),

                // Error message with animation
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _errorMessage != null
                      ? Container(
                          key: ValueKey(_errorMessage),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.dangerRed.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.dangerRed.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: AppTheme.dangerRed,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppTheme.dangerRed,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                const SizedBox(height: 16),

                // Security notice
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.softLilac,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.security,
                          color: AppTheme.primaryPurple,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Secure Login',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.neutralGray900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'We monitor login patterns to keep your account safe.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.neutralGray700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Referral code section
                _buildReferralSection(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    final hasValue = _controllers[index].text.isNotEmpty;
    final hasFocus = _focusNodes[index].hasFocus;

    return SizedBox(
      width: 48,
      height: 56,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppTheme.neutralGray900,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: hasValue
              ? AppTheme.softLilac
              : AppTheme.pureWhite,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasValue
                  ? AppTheme.primaryPurple
                  : AppTheme.neutralGray300,
              width: hasValue ? 2 : 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasValue
                  ? AppTheme.primaryPurple
                  : AppTheme.neutralGray300,
              width: hasValue ? 2 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppTheme.primaryPurple,
              width: 2,
            ),
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          if (index == 5 && value.isNotEmpty) {
            _verifyOtp();
          }

          if (_errorMessage != null) {
            setState(() {
              _errorMessage = null;
            });
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _buildReferralSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showReferralInput = !_showReferralInput;
            });
            AppHaptics.light();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _showReferralInput
                  ? AppTheme.softLilac.withValues(alpha: 0.5)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _showReferralInput
                    ? AppTheme.primaryPurple.withValues(alpha: 0.3)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _showReferralInput
                        ? Icons.card_giftcard
                        : Icons.card_giftcard_outlined,
                    color: AppTheme.primaryPurple,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Have a referral code?',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedRotation(
                  turns: _showReferralInput ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppTheme.primaryPurple,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),

        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: _buildReferralInput(),
          crossFadeState: _showReferralInput
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  Widget _buildReferralInput() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.softLilac.withValues(alpha: 0.5),
            AppTheme.softLilac.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _referralCodeValid
              ? AppTheme.successGreen
              : AppTheme.primaryPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: AppTheme.warningAmber, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Enter your friend\'s code to both earn +50 TrustScore!',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.neutralGray900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _referralCodeController,
            textCapitalization: TextCapitalization.characters,
            style: GoogleFonts.firaCode(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.neutralGray900,
              letterSpacing: 3,
            ),
            decoration: InputDecoration(
              hintText: 'ABCD1234',
              hintStyle: GoogleFonts.firaCode(
                fontSize: 18,
                color: AppTheme.neutralGray700.withValues(alpha: 0.5),
                letterSpacing: 3,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: _isValidatingReferral
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                    )
                  : _referralCodeController.text.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: Icon(
                            _referralCodeValid
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: _referralCodeValid
                                ? AppTheme.successGreen
                                : AppTheme.dangerRed,
                          ),
                        )
                      : null,
            ),
            onChanged: (value) {
              Future.delayed(const Duration(milliseconds: 500), () {
                if (_referralCodeController.text == value) {
                  _validateReferralCode(value.toUpperCase());
                }
              });
            },
          ),
          if (_referralCodeController.text.isNotEmpty &&
              !_isValidatingReferral) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _referralCodeValid
                      ? Icons.check_circle_outline
                      : Icons.info_outline,
                  size: 14,
                  color: _referralCodeValid
                      ? AppTheme.successGreen
                      : AppTheme.warningAmber,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _referralCodeValid
                        ? 'Valid code! Bonus will be applied after verification.'
                        : 'Invalid code. Please check and try again.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: _referralCodeValid
                          ? AppTheme.successGreen
                          : AppTheme.warningAmber,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
