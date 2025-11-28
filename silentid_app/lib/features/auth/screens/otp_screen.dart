import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/info_point_helper.dart';
import '../../../core/data/info_point_data.dart';
import '../../../services/auth_service.dart';
import '../../../services/referral_api_service.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({
    super.key,
    required this.email,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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

  @override
  void initState() {
    super.initState();
    _startResendTimer();
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
      // Clear all fields
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

  Future<void> _verifyOtp() async {
    final code = _getOtpCode();

    if (code.length != 6) {
      setState(() {
        _errorMessage = 'Please enter the complete 6-digit code';
      });
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
        // Apply referral code if provided and valid
        final referralCode = _referralCodeController.text.trim();
        if (referralCode.isNotEmpty && _referralCodeValid) {
          try {
            await _referralApi.applyReferralCode(referralCode);
            // Show success message briefly
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
            // Don't block login if referral fails
            debugPrint('Failed to apply referral code: $e');
          }
        }

        // Navigate to home screen
        if (mounted) {
          context.go('/home');
        }
      } else {
        setState(() {
          _errorMessage = result['message'];
          _isLoading = false;
        });

        // Clear all fields on error
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // Title with Info Point (Section 40.4)
              Row(
                children: [
                  Text(
                    'Check your email',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.deepBlack,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InfoPointHelper(data: InfoPoints.emailOTP),
                ],
              ),

              const SizedBox(height: 12),

              // Subtitle with email
              RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppTheme.neutralGray700,
                  ),
                  children: [
                    const TextSpan(text: 'We\'ve sent a 6-digit code to '),
                    TextSpan(
                      text: widget.email,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.deepBlack,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // OTP input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.deepBlack,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: AppTheme.pureWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppTheme.neutralGray300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppTheme.neutralGray300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
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

                        // Auto-submit when all fields are filled
                        if (index == 5 && value.isNotEmpty) {
                          _verifyOtp();
                        }

                        // Clear error when user types
                        if (_errorMessage != null) {
                          setState(() {
                            _errorMessage = null;
                          });
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // Resend timer
              Center(
                child: _canResend
                    ? TextButton(
                        onPressed: _resendCode,
                        child: Text(
                          'Resend code',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      )
                    : Text(
                        'Resend code in ${_resendTimer}s',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.neutralGray700,
                        ),
                      ),
              ),

              const SizedBox(height: 24),

              // Verify button
              PrimaryButton(
                text: 'Verify & Continue',
                isLoading: _isLoading,
                onPressed: _getOtpCode().length == 6 ? _verifyOtp : null,
              ),

              const SizedBox(height: 16),

              // Error message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.dangerRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.dangerRed.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
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
                ),

              const SizedBox(height: 16),

              // Security notice
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.softLilac,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.security,
                      color: AppTheme.primaryPurple,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'We monitor login patterns to prevent account abuse.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.neutralGray900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Referral code section (Section 50.6.1)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showReferralInput = !_showReferralInput;
                  });
                  HapticFeedback.lightImpact();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _showReferralInput
                          ? Icons.card_giftcard
                          : Icons.card_giftcard_outlined,
                      color: AppTheme.primaryPurple,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Have a referral code?',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      _showReferralInput
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppTheme.primaryPurple,
                      size: 20,
                    ),
                  ],
                ),
              ),

              if (_showReferralInput) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.softLilac.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _referralCodeValid
                          ? AppTheme.successGreen
                          : AppTheme.neutralGray300,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter your friend\'s referral code to both earn +50 TrustScore bonus!',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.neutralGray700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _referralCodeController,
                        textCapitalization: TextCapitalization.characters,
                        style: GoogleFonts.firaCode(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.deepBlack,
                          letterSpacing: 2,
                        ),
                        decoration: InputDecoration(
                          hintText: 'ABCD1234',
                          hintStyle: GoogleFonts.firaCode(
                            fontSize: 18,
                            color: AppTheme.neutralGray700,
                            letterSpacing: 2,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
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
                                  ? Icon(
                                      _referralCodeValid
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: _referralCodeValid
                                          ? AppTheme.successGreen
                                          : AppTheme.dangerRed,
                                    )
                                  : null,
                        ),
                        onChanged: (value) {
                          // Debounce validation
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
                            Text(
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
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
