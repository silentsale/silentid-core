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
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    AppHaptics.light();

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
    AppHaptics.light();

    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

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

  Future<void> _handlePasskeySignIn() async {
    AppHaptics.light();
    // TODO: Implement passkey authentication
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 8),
            Text('Passkey coming soon!', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ],
        ),
        backgroundColor: AppTheme.primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
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
                const Icon(Icons.play_circle_outline, color: Colors.white),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with logo
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/favicon_white.png',
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'SilentID',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ),

                // Hero Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                            color: AppTheme.deepBlack,
                          ),
                          children: [
                            const TextSpan(text: 'Your Ratings. '),
                            TextSpan(
                              text: 'Backed Up.',
                              style: TextStyle(color: AppTheme.primaryPurple),
                            ),
                            const TextSpan(text: ' Forever.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Protect your Vinted, eBay & Depop reputation. Never start from zero again.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.neutralGray700,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Trust Passport Preview Card
                _buildPassportPreview(),

                // Value Props - Compact
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildValueProp(
                        icon: Icons.verified_user_outlined,
                        title: 'Account Banned? You\'re Protected',
                        description: 'Prove your reputation to buyers on any platform.',
                      ),
                      Divider(color: Colors.grey[200], height: 1),
                      _buildValueProp(
                        icon: Icons.star_outline_rounded,
                        title: 'One Combined Star Rating',
                        description: 'Show your 4.9★ average in one shareable passport.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Platforms Strip
                _buildPlatformsStrip(),

                const SizedBox(height: 16),

                // CTA Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Demo Button
                      _buildDemoButton(),

                      const SizedBox(height: 16),

                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'Get started',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.neutralGray700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300])),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Social Proof
                      _buildSocialProof(),

                      const SizedBox(height: 12),

                      // Auth Grid
                      _buildAuthGrid(),

                      const SizedBox(height: 16),

                      // Footer
                      Text(
                        'Already have an account? ',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.neutralGray700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          AppHaptics.light();
                          // TODO: Navigate to sign in
                        },
                        child: Text(
                          'Sign in',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppTheme.primaryPurple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPassportPreview() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryPurple, Color(0xFF7B5FD3)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Passport Row
          Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    'YN',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Name',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFF59E0B),
                          size: 12,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '4.9 across 3 platforms',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // TrustScore
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      '847',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    Text(
                      'TRUSTSCORE',
                      style: GoogleFonts.inter(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.8),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Badges Row
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              // Verified Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check, color: Colors.white, size: 10),
                    const SizedBox(width: 3),
                    Text(
                      'ID Verified',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              _buildPlatformPill('Vinted'),
              _buildPlatformPill('eBay'),
              _buildPlatformPill('Depop'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformPill(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        name,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildValueProp({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.softLilac,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryPurple, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.deepBlack,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformsStrip() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildPlatformChip('Vinted'),
          _buildPlatformChip('eBay'),
          _buildPlatformChip('Depop'),
          _buildPlatformChip('Etsy'),
          _buildPlatformChip('+12 more'),
        ],
      ),
    );
  }

  Widget _buildPlatformChip(String name) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        name,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppTheme.deepBlack,
        ),
      ),
    );
  }

  Widget _buildDemoButton() {
    return Material(
      color: AppTheme.softLilac,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _isLoading ? null : _handleDemoMode,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryPurple, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_outline,
                color: AppTheme.primaryPurple,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Try Demo',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialProof() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppTheme.successGreen,
            size: 14,
          ),
          const SizedBox(width: 6),
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.deepBlack,
              ),
              children: [
                TextSpan(
                  text: '50,000+ ',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: 'sellers already protected'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthGrid() {
    return Column(
      children: [
        // Passkey Button - Primary (Full Width)
        _buildPasskeyButton(),

        const SizedBox(height: 10),

        // Apple & Google Row
        Row(
          children: [
            Expanded(child: _buildAppleButton()),
            const SizedBox(width: 10),
            Expanded(child: _buildGoogleButton()),
          ],
        ),

        const SizedBox(height: 10),

        // Email Button - Full Width
        _buildEmailButton(),
      ],
    );
  }

  Widget _buildPasskeyButton() {
    return Material(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _isLoading ? null : _handlePasskeySignIn,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryPurple, Color(0xFF7B5FD3)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.key, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Continue with Passkey',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Secure',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppleButton() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _isLoading ? null : _handleAppleSignIn,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.apple, color: Colors.black, size: 18),
              const SizedBox(width: 8),
              Text(
                'Apple',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _isLoading ? null : _handleGoogleSignIn,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://www.google.com/favicon.ico',
                width: 18,
                height: 18,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.g_mobiledata, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                'Google',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailButton() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _isLoading ? null : () {
          AppHaptics.light();
          context.push('/email');
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email_outlined, color: AppTheme.deepBlack, size: 18),
              const SizedBox(width: 8),
              Text(
                'Continue with Email',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
