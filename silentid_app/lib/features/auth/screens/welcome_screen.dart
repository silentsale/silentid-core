import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../services/auth_service.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _authService = AuthService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  bool _isLoading = false;

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);

    try {
      // Check if Apple Sign-In is available
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

      // Request Apple credentials
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Call backend with Apple credentials
      final result = await _authService.appleSignIn(
        credential.identityToken ?? '',
        credential.authorizationCode,
      );

      if (mounted) {
        if (result['success']) {
          // Navigate to home
          context.go('/home');
        } else {
          // Show error
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
      // Sign in with Google
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled
        return;
      }

      // Get Google authentication
      final googleAuth = await googleUser.authentication;

      // Call backend with Google credentials
      final result = await _authService.googleSignIn(
        googleAuth.idToken ?? '',
        googleAuth.accessToken,
      );

      if (mounted) {
        if (result['success']) {
          // Navigate to home
          context.go('/home');
        } else {
          // Show error
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
    // Show "Coming Soon" dialog with passkey information
    // Passkey authentication will be fully implemented when backend WebAuthn support is ready
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.fingerprint,
                color: AppTheme.primaryPurple,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Passkey Sign-In',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBlack,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Passkey authentication is coming soon!',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppTheme.deepBlack,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Passkeys use Face ID, Touch ID, or fingerprint to provide secure, passwordless login.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.softLilac.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryPurple,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'For now, please use Apple, Google, or Email sign-in.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.neutralGray700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Got it',
              style: GoogleFonts.inter(
                color: AppTheme.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Logo placeholder (would be replaced with actual logo)
              Container(
                height: 80,
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'S',
                  style: GoogleFonts.inter(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.pureWhite,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                'Welcome to SilentID',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.deepBlack,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Your portable trust passport.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppTheme.neutralGray700,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Continue with Apple button
              PrimaryButton(
                text: 'Continue with Apple',
                icon: Icons.apple,
                isLoading: _isLoading,
                onPressed: _isLoading ? () {} : _handleAppleSignIn,
              ),

              const SizedBox(height: 16),

              // Continue with Google button
              PrimaryButton(
                text: 'Continue with Google',
                icon: Icons.g_mobiledata_rounded,
                isSecondary: true,
                isLoading: _isLoading,
                onPressed: _isLoading ? () {} : _handleGoogleSignIn,
              ),

              const SizedBox(height: 16),

              // Continue with Email button
              PrimaryButton(
                text: 'Continue with Email',
                icon: Icons.email_outlined,
                isSecondary: true,
                onPressed: () {
                  context.push('/email');
                },
              ),

              const SizedBox(height: 16),

              // Use a Passkey button
              PrimaryButton(
                text: 'Use a Passkey',
                icon: Icons.fingerprint,
                isSecondary: true,
                onPressed: _handlePasskeySignIn,
              ),

              const Spacer(),

              // Legal notice
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    Text(
                      'By continuing, you agree to SilentID\'s',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.neutralGray700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Terms & Privacy Policy',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.softLilac,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'SilentID never stores passwords. Your account is secured with modern passwordless authentication.',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.neutralGray900,
                        ),
                        textAlign: TextAlign.center,
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
  }
}
