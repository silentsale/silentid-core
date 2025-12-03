import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptics.dart';
import '../../../services/auth_service.dart';
import '../../../services/storage_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  final _authService = AuthService();
  final _storageService = StorageService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  bool _isLoading = false;

  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _counterController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<int> _counterAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    // Pulse animation for counter card
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Counter animation
    _counterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _counterAnimation = IntTween(begin: 0, end: 50000).animate(
      CurvedAnimation(parent: _counterController, curve: Curves.easeOut),
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _counterController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _counterController.dispose();
    super.dispose();
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Apple Sign-In is not available on this device'),
              backgroundColor: AppTheme.dangerRed,
            ),
          );
        }
        return;
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final result = await _authService.appleSignIn(
        credential.identityToken ?? '',
        credential.authorizationCode,
      );

      if (mounted) {
        if (result['success']) {
          context.go('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: AppTheme.dangerRed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Apple Sign-In failed: ${e.toString()}'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final result = await _authService.googleSignIn(
        googleAuth.idToken ?? '',
        googleAuth.accessToken,
      );

      if (mounted) {
        if (result['success']) {
          context.go('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: AppTheme.dangerRed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google Sign-In failed: ${e.toString()}'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleDemoMode() async {
    AppHaptics.heavy();
    setState(() => _isLoading = true);

    try {
      await _storageService.enableDemoMode();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.science_outlined, color: Colors.white),
                const SizedBox(width: 8),
                Text('Demo mode activated!', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              ],
            ),
            backgroundColor: AppTheme.primaryPurple,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        context.go('/home');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFF8F6FF),
              AppTheme.softLilac,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 48),

                  // Logo with glow
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                            blurRadius: 24,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'S',
                          style: GoogleFonts.inter(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Tagline
                  Text(
                    'Build Trust. Prove Identity.',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.deepBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Trade Safely.',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: AppTheme.neutralGray700,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Animated counter card
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.softLilac,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.people_outline,
                                color: AppTheme.successGreen,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              AnimatedBuilder(
                                animation: _counterAnimation,
                                builder: (context, child) {
                                  return RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.deepBlack,
                                      ),
                                      children: [
                                        const TextSpan(text: 'Join '),
                                        TextSpan(
                                          text: '${_counterAnimation.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}+',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primaryPurple,
                                          ),
                                        ),
                                        const TextSpan(text: ' trusted users'),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Trust Journey Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.neutralGray300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Your Trust Journey Starts Here',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.deepBlack,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // Level 1 Badge
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.grey[300]!,
                                Colors.grey[400]!,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'LEVEL',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '1',
                                style: GoogleFonts.inter(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.neutralGray700,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Starter',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Start at Level 1 and unlock achievements as you build your trust profile',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.neutralGray700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Benefit Cards
                  _buildBenefitCard(
                    icon: Icons.check_circle_outline,
                    title: 'Verify Your Identity',
                    description: 'Prove who you are with secure, passwordless verification',
                    delay: 0,
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitCard(
                    icon: Icons.flash_on_outlined,
                    title: 'Build Your Reputation',
                    description: 'Earn TrustScore points and level up with every achievement',
                    delay: 1,
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitCard(
                    icon: Icons.share_outlined,
                    title: 'Share Your Trust',
                    description: 'Show your verified profile to trade safely anywhere',
                    delay: 2,
                  ),

                  const SizedBox(height: 24),

                  // Auth Section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.neutralGray300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Get Started',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.deepBlack,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Apple Sign In
                        _buildAuthButton(
                          onPressed: _isLoading ? null : _handleAppleSignIn,
                          icon: Icons.apple,
                          label: 'Continue with Apple',
                          isPrimary: true,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                        ),
                        const SizedBox(height: 12),

                        // Google Sign In
                        _buildAuthButton(
                          onPressed: _isLoading ? null : _handleGoogleSignIn,
                          icon: Icons.g_mobiledata_rounded,
                          label: 'Continue with Google',
                          isPrimary: false,
                          backgroundColor: Colors.white,
                          textColor: AppTheme.deepBlack,
                        ),
                        const SizedBox(height: 12),

                        // Email Sign In
                        _buildAuthButton(
                          onPressed: _isLoading ? null : () {
                            AppHaptics.light();
                            context.push('/email');
                          },
                          icon: Icons.email_outlined,
                          label: 'Continue with Email',
                          isPrimary: false,
                          backgroundColor: Colors.white,
                          textColor: AppTheme.primaryPurple,
                          borderColor: AppTheme.primaryPurple,
                        ),

                        const SizedBox(height: 16),
                        Text(
                          '100% Passwordless - No passwords required',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.neutralGray700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Demo Mode Section
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppTheme.neutralGray300)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or for testing',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.neutralGray700,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppTheme.neutralGray300)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Demo Mode Button
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _handleDemoMode,
                    icon: const Icon(Icons.science_outlined, color: Color(0xFFE65100)),
                    label: Text(
                      'Enter Demo Mode',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE65100),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFF3E0),
                      side: const BorderSide(color: Color(0xFFFFB74D), width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Footer
                  Text(
                    'By continuing, you agree to our',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.neutralGray700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Terms of Service',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.primaryPurple,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Text(
                        ' and ',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.neutralGray700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Privacy Policy',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.primaryPurple,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitCard({
    required IconData icon,
    required String title,
    required String description,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (delay * 200)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 8 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.neutralGray300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.softLilac,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      icon,
                      color: AppTheme.primaryPurple,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.deepBlack,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.neutralGray700,
                          ),
                        ),
                      ],
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

  Widget _buildAuthButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required bool isPrimary,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor ?? AppTheme.neutralGray300,
              width: borderColor != null ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
