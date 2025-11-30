import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/security_api_service.dart';
import '../../../core/data/info_point_data.dart';
import '../../../core/widgets/info_point_helper.dart';

/// Login Methods Management Screen (Section 54)
///
/// Displays all available authentication methods:
/// - Passkeys (WebAuthn/FIDO2) - Face ID, Touch ID, Windows Hello
/// - Apple Sign-In
/// - Google Sign-In
/// - Email OTP (fallback)
class LoginMethodsScreen extends StatefulWidget {
  const LoginMethodsScreen({super.key});

  @override
  State<LoginMethodsScreen> createState() => _LoginMethodsScreenState();
}

class _LoginMethodsScreenState extends State<LoginMethodsScreen> {
  final _securityApi = SecurityApiService();
  bool _isLoading = true;
  IdentityStatusResponse? _identityStatus;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadIdentityStatus();
  }

  Future<void> _loadIdentityStatus() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final status = await _securityApi.getIdentityStatus();
      if (mounted) {
        setState(() {
          _identityStatus = status;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load login methods';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.deepBlack),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Login Methods',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.deepBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryPurple))
          : _errorMessage != null
              ? _buildErrorState()
              : _buildContent(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppTheme.neutralGray700),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppTheme.neutralGray700,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: _loadIdentityStatus,
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Passkey Section (Primary - Coming Soon)
          _buildPasskeySection(),
          const SizedBox(height: 24),

          // Automatic method selection info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.neutralGray300.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppTheme.primaryPurple,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'We automatically select the most secure method available when you sign in.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.neutralGray700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Connected Methods Section
          Text(
            'Connected Methods',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.deepBlack,
            ),
          ),
          const SizedBox(height: 12),

          // Apple Sign-In
          _buildLoginMethodCard(
            icon: Icons.apple,
            title: 'Apple Sign-In',
            subtitle: 'Sign in with your Apple ID',
            status: _identityStatus?.email.contains('@privaterelay') == true
                ? 'Connected (Private Relay)'
                : 'Available',
            isConnected: true, // Always available on iOS
            isPrimary: false,
          ),
          const SizedBox(height: 12),

          // Google Sign-In
          _buildLoginMethodCard(
            icon: Icons.g_mobiledata_rounded,
            title: 'Google Sign-In',
            subtitle: 'Sign in with your Google account',
            status: 'Available',
            isConnected: true,
            isPrimary: false,
          ),
          const SizedBox(height: 12),

          // Email OTP (Fallback)
          _buildLoginMethodCard(
            icon: Icons.email_outlined,
            title: 'Email OTP',
            subtitle: 'Fallback method • 6-digit code via email',
            status: _identityStatus?.emailVerified == true ? 'Verified' : 'Available',
            isConnected: _identityStatus?.emailVerified == true,
            isPrimary: false,
            isFallback: true,
            trailing: _identityStatus?.emailVerified == true
                ? const Icon(Icons.verified, color: AppTheme.successGreen, size: 20)
                : null,
          ),

          const SizedBox(height: 32),

          // Security note
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.softLilac.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.security,
                  color: AppTheme.primaryPurple,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '100% Passwordless',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.deepBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SilentID never stores passwords. Your account is protected by modern authentication methods. One email = one account (no duplicates allowed).',
                        
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.neutralGray700,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasskeySection() {
    final passkeyCount = _identityStatus?.passkeyCount ?? 0;
    final isEnabled = _identityStatus?.passkeyEnabled ?? false;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryPurple.withValues(alpha: 0.1),
            AppTheme.softLilac.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryPurple.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.fingerprint,
                  color: AppTheme.primaryPurple,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Passkeys',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.deepBlack,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPurple,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'RECOMMENDED',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InfoPointHelper(data: InfoPoints.passkeys),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isEnabled
                          ? '$passkeyCount passkey${passkeyCount == 1 ? '' : 's'} registered'
                          : 'Face ID, Touch ID, Windows Hello',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.neutralGray700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Passkeys are the most secure way to sign in. They use your device\'s biometric sensors (Face ID, Touch ID, fingerprint) or PIN to verify your identity.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.neutralGray700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Benefits list
          _buildPasskeyBenefit('Phishing-resistant - can\'t be stolen'),
          _buildPasskeyBenefit('No password to remember'),
          _buildPasskeyBenefit('Works across all your devices'),
          _buildPasskeyBenefit('Backed by FIDO2/WebAuthn standard'),

          const SizedBox(height: 20),

          // CTA Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showPasskeyComingSoon(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    isEnabled ? 'Add Another Passkey' : 'Set Up Passkey',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasskeyBenefit(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppTheme.successGreen,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.neutralGray700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginMethodCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required bool isConnected,
    required bool isPrimary,
    bool isFallback = false,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isFallback ? AppTheme.neutralGray300.withValues(alpha: 0.2) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFallback ? AppTheme.neutralGray300 : AppTheme.neutralGray300,
          style: isFallback ? BorderStyle.solid : BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.neutralGray300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppTheme.neutralGray700,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepBlack,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),
          trailing ?? Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isConnected
                  ? AppTheme.successGreen.withValues(alpha: 0.1)
                  : AppTheme.neutralGray300,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isConnected ? AppTheme.successGreen : AppTheme.neutralGray700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPasskeyComingSoon() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.neutralGray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.fingerprint,
                color: AppTheme.primaryPurple,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Passkeys Coming Soon',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.deepBlack,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'We\'re working hard to bring you the most secure authentication experience. Passkey support will be available in an upcoming update.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.softLilac.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_active_outlined,
                    color: AppTheme.primaryPurple,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You\'ll be notified when Passkeys become available.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.neutralGray700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Got It',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
