import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/info_modal.dart';
import '../../../services/profile_linking_service.dart';

/// Upgrade to Verified Screen - Section 52.3 Flow B & C
/// Allows users to upgrade a Linked profile to Verified status
/// via Token Verification (Flow B) or Screenshot Verification (Flow C)
class UpgradeToVerifiedScreen extends StatefulWidget {
  final ConnectedProfile profile;

  const UpgradeToVerifiedScreen({
    super.key,
    required this.profile,
  });

  @override
  State<UpgradeToVerifiedScreen> createState() =>
      _UpgradeToVerifiedScreenState();
}

class _UpgradeToVerifiedScreenState extends State<UpgradeToVerifiedScreen> {
  final _service = ProfileLinkingService();
  late PlatformConfig? _platform;
  String _verificationToken = '';
  bool _isLoadingToken = true;

  bool _isCheckingToken = false;
  bool _tokenCopied = false;
  VerificationMethod _selectedMethod = VerificationMethod.token;

  @override
  void initState() {
    super.initState();
    _platform = _service.getPlatformById(widget.profile.platformId);
    _loadVerificationToken();
  }

  Future<void> _loadVerificationToken() async {
    try {
      final token = await _service.generateVerificationToken(widget.profile.id);
      if (mounted) {
        setState(() {
          _verificationToken = token;
          _isLoadingToken = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _verificationToken = 'SID-ERROR';
          _isLoadingToken = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate token: $e'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    }
  }

  void _copyToken() {
    Clipboard.setData(ClipboardData(text: _verificationToken));
    HapticFeedback.mediumImpact();
    setState(() => _tokenCopied = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Token copied to clipboard',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _checkTokenNow() async {
    setState(() => _isCheckingToken = true);
    HapticFeedback.mediumImpact();

    try {
      // Check if token exists in profile bio via backend scraping
      final found = await _service.verifyTokenInProfile(widget.profile.id);

      if (found) {
        // Upgrade to verified
        final upgraded = await _service.upgradeToVerified(
          profile: widget.profile,
          verificationMethod: ProfileLinkState.verifiedToken,
        );
        if (mounted) {
          _showSuccessDialog(upgraded);
        }
      } else {
        if (mounted) {
          _showTokenNotFoundDialog();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: $e'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    } finally {
      setState(() => _isCheckingToken = false);
    }
  }

  void _showTokenNotFoundDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.search_off_rounded, color: AppTheme.warningAmber),
            const SizedBox(width: 8),
            Text(
              'Token Not Found',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          'We couldn\'t find the verification token in your ${_platform?.displayName ?? 'profile'} bio.\n\n'
          'Make sure you:\n'
          '• Copied the exact token\n'
          '• Added it to your public bio/about section\n'
          '• Saved your changes\n\n'
          'Try again in a few moments.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.neutralGray700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(ConnectedProfile upgraded) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.verified_rounded,
                color: AppTheme.successGreen,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Profile Verified!',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.neutralGray900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your ${_platform?.displayName ?? 'profile'} is now verified.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_rounded,
                    size: 16,
                    color: AppTheme.successGreen,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Verified',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.successGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This boosts your TrustScore and shows a verified badge on your passport.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.neutralGray700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, upgraded); // Return upgraded profile
            },
            child: Text(
              'Done',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTokenInfo() {
    InfoModal.show(
      context,
      title: 'Token Verification',
      body:
          'Add a small SilentID code to your profile bio.\n\n'
          'This proves you own the account. You can remove the token after verification is complete.\n\n'
          'This is the strongest form of verification.',
      icon: Icons.verified_rounded,
    );
  }

  void _showScreenshotInfo() {
    InfoModal.show(
      context,
      title: 'Screenshot Verification',
      body:
          'Some platforms don\'t allow bio edits.\n\n'
          'We use a live camera photo of your profile screen to confirm ownership.\n\n'
          'This is a fallback when token verification isn\'t possible.',
      icon: Icons.camera_alt_rounded,
    );
  }

  void _startScreenshotVerification() {
    // Navigate to screenshot verification screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenshotVerificationScreen(
          profile: widget.profile,
          platform: _platform,
          onVerified: (upgraded) {
            Navigator.pop(context); // Pop screenshot screen
            Navigator.pop(context, upgraded); // Return to connected profiles
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Upgrade to Verified',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.neutralGray900),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile being verified
            _buildProfileCard(),
            const SizedBox(height: 24),

            // Method selection
            _buildMethodSelection(),
            const SizedBox(height: 24),

            // Token verification flow
            if (_selectedMethod == VerificationMethod.token) ...[
              _buildTokenVerificationFlow(),
            ],

            // Screenshot verification flow
            if (_selectedMethod == VerificationMethod.screenshot) ...[
              _buildScreenshotVerificationFlow(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    if (_platform == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _platform!.brandColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _platform!.icon,
              color: _platform!.brandColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _platform!.displayName,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralGray900,
                  ),
                ),
                Text(
                  '@${widget.profile.username}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.warningAmber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Linked',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppTheme.warningAmber,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose verification method',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMethodOption(
                method: VerificationMethod.token,
                icon: Icons.code_rounded,
                label: 'Token',
                sublabel: 'Recommended',
                isRecommended: true,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMethodOption(
                method: VerificationMethod.screenshot,
                icon: Icons.camera_alt_rounded,
                label: 'Screenshot',
                sublabel: 'Fallback',
                isRecommended: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodOption({
    required VerificationMethod method,
    required IconData icon,
    required String label,
    required String sublabel,
    required bool isRecommended,
  }) {
    final isSelected = _selectedMethod == method;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedMethod = method);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryPurple.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryPurple
                : AppTheme.neutralGray300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppTheme.primaryPurple
                  : AppTheme.neutralGray700,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppTheme.primaryPurple
                    : AppTheme.neutralGray900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isRecommended
                    ? AppTheme.successGreen
                    : AppTheme.neutralGray700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenVerificationFlow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info card
        GestureDetector(
          onTap: _showTokenInfo,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryPurple.withValues(alpha: 0.08),
                  AppTheme.primaryPurple.withValues(alpha: 0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryPurple.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
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
                        'How token verification works',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tap to learn more',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.neutralGray700,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.primaryPurple,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Step 1: Copy token
        _buildStep(
          number: '1',
          title: 'Copy this code',
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.neutralGray300.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.neutralGray300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _isLoadingToken
                          ? Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppTheme.primaryPurple,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Generating token...',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: AppTheme.neutralGray700,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              _verificationToken,
                              style: GoogleFonts.robotoMono(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.neutralGray900,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                    GestureDetector(
                      onTap: _isLoadingToken ? null : _copyToken,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _tokenCopied
                              ? AppTheme.successGreen.withValues(alpha: 0.15)
                              : AppTheme.primaryPurple.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _tokenCopied
                              ? Icons.check_rounded
                              : Icons.copy_rounded,
                          size: 20,
                          color: _tokenCopied
                              ? AppTheme.successGreen
                              : AppTheme.primaryPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Step 2: Add to bio
        _buildStep(
          number: '2',
          title: 'Add to your ${_platform?.displayName ?? 'profile'} bio',
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.neutralGray300),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 18,
                  color: AppTheme.warningAmber,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _platform?.tokenPlacementHint ?? 'Add to your bio section',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.neutralGray700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Step 3: Check
        _buildStep(
          number: '3',
          title: 'Tap "Check now" when ready',
          child: const SizedBox.shrink(),
        ),
        const SizedBox(height: 24),

        // Check Now Button
        Material(
          color: AppTheme.primaryPurple,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: _isCheckingToken ? null : _checkTokenNow,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isCheckingToken)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else
                    const Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  const SizedBox(width: 8),
                  Text(
                    _isCheckingToken ? 'Checking...' : 'Check now',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Note about removing token
        Center(
          child: Text(
            'You can remove the token after verification',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.neutralGray700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScreenshotVerificationFlow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info card
        GestureDetector(
          onTap: _showScreenshotInfo,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryPurple.withValues(alpha: 0.08),
                  AppTheme.primaryPurple.withValues(alpha: 0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryPurple.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
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
                        'How screenshot verification works',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tap to learn more',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.neutralGray700,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.primaryPurple,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Instructions
        _buildStep(
          number: '1',
          title: 'Open your ${_platform?.displayName ?? 'profile'}',
          child: const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),

        _buildStep(
          number: '2',
          title: 'Navigate to your profile page',
          child: const SizedBox.shrink(),
        ),
        const SizedBox(height: 16),

        _buildStep(
          number: '3',
          title: 'Take a live photo of your screen',
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.warningAmber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.warningAmber.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: AppTheme.warningAmber,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Screenshots from gallery are not accepted. You must use the live camera.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.neutralGray700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Start button
        Material(
          color: AppTheme.primaryPurple,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: _startScreenshotVerification,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Open Camera',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.neutralGray900,
                ),
              ),
            ),
          ],
        ),
        if (child is! SizedBox) ...[
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: child,
          ),
        ],
      ],
    );
  }
}

/// Verification method enum
enum VerificationMethod {
  token,
  screenshot,
}

/// Screenshot Verification Screen - Section 52.3 Flow C
/// Uses live camera to capture profile screen for verification
class ScreenshotVerificationScreen extends StatefulWidget {
  final ConnectedProfile profile;
  final PlatformConfig? platform;
  final Function(ConnectedProfile) onVerified;

  const ScreenshotVerificationScreen({
    super.key,
    required this.profile,
    required this.platform,
    required this.onVerified,
  });

  @override
  State<ScreenshotVerificationScreen> createState() =>
      _ScreenshotVerificationScreenState();
}

class _ScreenshotVerificationScreenState
    extends State<ScreenshotVerificationScreen> {
  final _service = ProfileLinkingService();
  bool _isProcessing = false;
  bool _photoTaken = false;

  Future<void> _takeLivePhoto() async {
    HapticFeedback.mediumImpact();
    setState(() => _isProcessing = true);

    // Simulate camera capture and OCR processing
    // In production: Use image_picker with camera source, then send to backend for OCR
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _photoTaken = true;
      _isProcessing = false;
    });
  }

  Future<void> _verifyScreenshot() async {
    setState(() => _isProcessing = true);
    HapticFeedback.mediumImpact();

    try {
      // Simulate verification
      // In production: Send image to backend, OCR extracts username, compare with profile
      await Future.delayed(const Duration(seconds: 2));

      final upgraded = await _service.upgradeToVerified(
        profile: widget.profile,
        verificationMethod: ProfileLinkState.verifiedScreenshot,
      );

      if (mounted) {
        _showSuccessAndReturn(upgraded);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: $e'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showSuccessAndReturn(ConnectedProfile upgraded) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.verified_rounded,
                color: AppTheme.successGreen,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Profile Verified!',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.neutralGray900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Screenshot verification complete.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              widget.onVerified(upgraded);
            },
            child: Text(
              'Done',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _retakePhoto() {
    setState(() => _photoTaken = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Screenshot Verification',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.neutralGray900),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.camera_alt_rounded,
                        color: AppTheme.primaryPurple,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Take a photo of your profile',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Open ${widget.platform?.displayName ?? 'the app'} on another device or in a browser, then take a live photo showing your username.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.neutralGray700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Camera preview area (placeholder)
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: AppTheme.neutralGray300.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.neutralGray300),
              ),
              child: _photoTaken
                  ? Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 48,
                                color: AppTheme.successGreen,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Photo captured',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.neutralGray900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ready to verify',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppTheme.neutralGray700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: _retakePhoto,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: AppTheme.neutralGray300),
                              ),
                              child: Icon(
                                Icons.refresh_rounded,
                                size: 20,
                                color: AppTheme.neutralGray700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 48,
                            color: AppTheme.neutralGray700,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Camera preview',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppTheme.neutralGray700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap the button below to capture',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.neutralGray300,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 24),

            // Action button
            Material(
              color: AppTheme.primaryPurple,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: _isProcessing
                    ? null
                    : (_photoTaken ? _verifyScreenshot : _takeLivePhoto),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isProcessing)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      else
                        Icon(
                          _photoTaken
                              ? Icons.verified_rounded
                              : Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      const SizedBox(width: 8),
                      Text(
                        _isProcessing
                            ? (_photoTaken ? 'Verifying...' : 'Capturing...')
                            : (_photoTaken ? 'Verify Now' : 'Take Photo'),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Retake option
            if (_photoTaken && !_isProcessing) ...[
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: _retakePhoto,
                  child: Text(
                    'Retake Photo',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.neutralGray700,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
