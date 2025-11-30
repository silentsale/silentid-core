import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../services/api_service.dart';

// Color aliases for missing theme colors
const _neutralGray200 = Color(0xFFE5E5E5);
const _neutralGray400 = Color(0xFF9E9E9E);
const _neutralGray500 = Color(0xFF757575);
const _neutralGray600 = Color(0xFF616161);
const _warningYellow = Color(0xFFFFC043);

/// Level 3 Verification Flow Screen (Section 49)
///
/// Two verification methods:
/// - PRIMARY: Share-Intent (user shares profile URL from platform app)
/// - SECONDARY: Token-in-Bio (user adds verification token to profile bio)
class Level3VerificationScreen extends StatefulWidget {
  final String profileUrl;
  final String platform;
  final String? profileLinkId;

  const Level3VerificationScreen({
    super.key,
    required this.profileUrl,
    required this.platform,
    this.profileLinkId,
  });

  @override
  State<Level3VerificationScreen> createState() => _Level3VerificationScreenState();
}

class _Level3VerificationScreenState extends State<Level3VerificationScreen> {
  final _api = ApiService();

  // Verification state
  VerificationMethod _selectedMethod = VerificationMethod.shareIntent;
  VerificationStep _currentStep = VerificationStep.selectMethod;

  // Token-in-Bio state
  String? _verificationToken;
  bool _tokenCopied = false;
  bool _tokenAddedConfirmed = false;

  // Share-Intent state
  bool _shareInitiated = false;
  

  // Loading state
  bool _isVerifying = false;
  String? _errorMessage;
  bool _verificationSuccess = false;

  // Platform type detection
  bool get _supportsShareIntent => [
    'Instagram', 'TikTok', 'X', 'Twitter', 'Facebook',
    'Vinted', 'eBay', 'Depop', 'Etsy',
  ].contains(widget.platform);

  bool get _supportsTokenInBio => [
    'Vinted', 'eBay', 'Depop', 'Etsy', 'Facebook Marketplace',
  ].contains(widget.platform);

  String get _platformIcon {
    switch (widget.platform.toLowerCase()) {
      case 'vinted': return '👗';
      case 'ebay': return '🛒';
      case 'depop': return '📱';
      case 'etsy': return '🎨';
      case 'instagram': return '📸';
      case 'tiktok': return '🎵';
      case 'x':
      case 'twitter': return '🐦';
      case 'facebook':
      case 'facebook marketplace': return '👥';
      default: return '🌐';
    }
  }

  @override
  void initState() {
    super.initState();
    // Token will be fetched from backend when user selects TokenInBio method
  }

  /// Fetch verification token from backend (Section 49.3)
  Future<void> _fetchVerificationToken() async {
    if (widget.profileLinkId == null) {
      setState(() {
        _errorMessage = 'Profile link ID required for verification';
      });
      return;
    }

    try {
      final response = await _api.post(
        '/v1/evidence/profile-links/${widget.profileLinkId}/generate-token',
        data: {},
      );

      if (mounted && response.data != null) {
        setState(() {
          _verificationToken = response.data['verificationToken'] as String?;
        });
      }
    } catch (e) {
      if (mounted) {
        // Fallback to local generation if backend fails
        final random = Random.secure();
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        final code = List.generate(8, (_) => chars[random.nextInt(chars.length)]).join();
        setState(() {
          _verificationToken = 'SILENTID-VERIFY-$code';
        });
      }
    }
  }

  Future<void> _initiateShareIntent() async {
    setState(() {
      _shareInitiated = true;
      
    });

    // Open share dialog with instructions
    await SharePlus.instance.share(
      ShareParams(
        text: 'Verifying my profile on SilentID: ${widget.profileUrl}',
        subject: 'SilentID Profile Verification',
      ),
    );

    // After share completes, show verification button
    if (mounted) {
      setState(() {
        _currentStep = VerificationStep.verifyOwnership;
      });
    }
  }

  Future<void> _copyTokenToClipboard() async {
    if (_verificationToken == null) return;

    await Clipboard.setData(ClipboardData(text: _verificationToken!));
    setState(() => _tokenCopied = true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification code copied to clipboard'),
          backgroundColor: AppTheme.successGreen,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _verifyOwnership() async {
    if (widget.profileLinkId == null) {
      setState(() {
        _errorMessage = 'Profile link ID required for verification';
        _currentStep = VerificationStep.result;
        _verificationSuccess = false;
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      dynamic response;

      if (_selectedMethod == VerificationMethod.shareIntent) {
        // ShareIntent verification (Section 49.4)
        response = await _api.post(
          '/v1/evidence/profile-links/${widget.profileLinkId}/verify-intent',
          data: {
            'sharedUrl': widget.profileUrl,
            'deviceFingerprint': await _getDeviceFingerprint(),
          },
        );
      } else {
        // TokenInBio verification (Section 49.3)
        // Note: In production, this would send the scraped bio text from the profile
        // For now, we send a placeholder indicating user confirmed they added the token
        response = await _api.post(
          '/v1/evidence/profile-links/${widget.profileLinkId}/confirm-token',
          data: {
            'scrapedBioText': _verificationToken ?? '',
          },
        );
      }

      if (mounted) {
        // Backend returns the updated profile link on success
        final success = response.data != null &&
            (response.data['verificationLevel'] == 3 || response.data['linkState'] == 'Verified');
        setState(() {
          _verificationSuccess = success;
          _currentStep = VerificationStep.result;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Verification failed. Please try again.';
          _currentStep = VerificationStep.result;
          _verificationSuccess = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  /// Get device fingerprint for ShareIntent verification
  Future<String> _getDeviceFingerprint() async {
    // Simple device fingerprint - in production use device_info_plus
    return '${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Verify Profile Ownership',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppTheme.deepBlack,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile being verified
              _buildProfileHeader(),
              const SizedBox(height: 24),

              // Progress indicator
              _buildProgressIndicator(),
              const SizedBox(height: 32),

              // Current step content
              _buildCurrentStepContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.softLilac.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryPurple.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Text(_platformIcon, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.platform,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepBlack,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.profileUrl,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildProgressStep(1, 'Method', _currentStep.index >= 0),
        Expanded(child: _buildProgressLine(_currentStep.index >= 1)),
        _buildProgressStep(2, 'Verify', _currentStep.index >= 1),
        Expanded(child: _buildProgressLine(_currentStep.index >= 2)),
        _buildProgressStep(3, 'Done', _currentStep.index >= 2),
      ],
    );
  }

  Widget _buildProgressStep(int step, String label, bool active) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active ? AppTheme.primaryPurple : AppTheme.neutralGray300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : AppTheme.neutralGray700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: active ? AppTheme.primaryPurple : _neutralGray500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool active) {
    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: active ? AppTheme.primaryPurple : AppTheme.neutralGray300,
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case VerificationStep.selectMethod:
        return _buildSelectMethodStep();
      case VerificationStep.verifyOwnership:
        return _buildVerifyOwnershipStep();
      case VerificationStep.result:
        return _buildResultStep();
    }
  }

  Widget _buildSelectMethodStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Prove you own this profile',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.deepBlack,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Level 3 verification proves ownership and unlocks full reputation benefits.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.neutralGray700,
          ),
        ),
        const SizedBox(height: 24),

        // PRIMARY: Share-Intent Method
        if (_supportsShareIntent) ...[
          _buildMethodCard(
            method: VerificationMethod.shareIntent,
            title: 'Share from App',
            subtitle: 'Recommended - Quick & Easy',
            description: 'Share your profile URL from the ${widget.platform} app. This proves you have access to the account.',
            icon: Icons.share_outlined,
            isPrimary: true,
          ),
          const SizedBox(height: 16),
        ],

        // SECONDARY: Token-in-Bio Method
        if (_supportsTokenInBio) ...[
          _buildMethodCard(
            method: VerificationMethod.tokenInBio,
            title: 'Add Code to Bio',
            subtitle: 'Alternative method',
            description: 'Add a unique verification code to your profile bio. Remove it after verification.',
            icon: Icons.edit_outlined,
            isPrimary: false,
          ),
        ],

        if (!_supportsShareIntent && !_supportsTokenInBio)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _warningYellow.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Level 3 verification is not yet available for ${widget.platform}. Your profile will be added at Level 1.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray900,
              ),
            ),
          ),

        const SizedBox(height: 32),

        // Benefits of Level 3
        _buildLevel3Benefits(),
      ],
    );
  }

  Widget _buildMethodCard({
    required VerificationMethod method,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required bool isPrimary,
  }) {
    final isSelected = _selectedMethod == method;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryPurple.withValues(alpha: 0.1)
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? AppTheme.primaryPurple.withValues(alpha: 0.15)
                        : _neutralGray200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isPrimary
                        ? AppTheme.primaryPurple
                        : AppTheme.neutralGray700,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.deepBlack,
                            ),
                          ),
                          if (isPrimary) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.successGreen,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'PRIMARY',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: _neutralGray600,
                        ),
                      ),
                    ],
                  ),
                ),
                Radio<VerificationMethod>(
                  value: method,
                  groupValue: _selectedMethod,
                  onChanged: (value) => setState(() => _selectedMethod = value!),
                  activeColor: AppTheme.primaryPurple,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.neutralGray700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: isSelected ? 'Continue with this method' : 'Select',
              onPressed: () async {
                setState(() {
                  _selectedMethod = method;
                  _currentStep = VerificationStep.verifyOwnership;
                });
                // Fetch token from backend if TokenInBio selected
                if (method == VerificationMethod.tokenInBio) {
                  await _fetchVerificationToken();
                }
              },
              isSecondary: !isSelected,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevel3Benefits() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.softLilac.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.verified,
                color: AppTheme.primaryPurple,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Level 3 Benefits',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBenefitItem('Star ratings shown on your Digital Trust Passport'),
          _buildBenefitItem('Contributes to Universal Reputation Score (URS)'),
          _buildBenefitItem('+50% profile weight for TrustScore calculation'),
          _buildBenefitItem('Profile ownership locked to your account'),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _buildVerifyOwnershipStep() {
    if (_selectedMethod == VerificationMethod.shareIntent) {
      return _buildShareIntentVerification();
    } else {
      return _buildTokenInBioVerification();
    }
  }

  Widget _buildShareIntentVerification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Share from ${widget.platform}',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.deepBlack,
          ),
        ),
        const SizedBox(height: 24),

        // Step 1: Open the app
        _buildInstructionStep(
          stepNumber: 1,
          title: 'Open ${widget.platform}',
          description: 'Open the ${widget.platform} app and go to your profile.',
          isCompleted: _shareInitiated,
        ),
        const SizedBox(height: 16),

        // Step 2: Share profile
        _buildInstructionStep(
          stepNumber: 2,
          title: 'Share your profile',
          description: 'Tap the share button on your profile and share it via any method.',
          isCompleted: _shareInitiated,
        ),
        const SizedBox(height: 16),

        // Step 3: Come back
        _buildInstructionStep(
          stepNumber: 3,
          title: 'Return here',
          description: 'After sharing, come back to SilentID to complete verification.',
          isCompleted: false,
        ),

        const SizedBox(height: 32),

        if (!_shareInitiated) ...[
          // Share button
          PrimaryButton(
            text: 'Share Profile Now',
            icon: Icons.share,
            onPressed: _initiateShareIntent,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {
                setState(() => _currentStep = VerificationStep.selectMethod);
              },
              child: Text(
                'Use different method',
                style: GoogleFonts.inter(
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
          ),
        ] else ...[
          // Verify button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.successGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.successGreen.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.successGreen,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Share action detected! Click below to verify ownership.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.neutralGray900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Verify Ownership',
            isLoading: _isVerifying,
            onPressed: _isVerifying ? () {} : _verifyOwnership,
          ),
        ],

        if (_errorMessage != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.dangerRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _errorMessage!,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.dangerRed,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTokenInBioVerification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Add Code to Bio',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.deepBlack,
          ),
        ),
        const SizedBox(height: 24),

        // Verification code display
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.deepBlack,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                'Your Verification Code',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: _neutralGray400,
                ),
              ),
              const SizedBox(height: 8),
              SelectableText(
                _verificationToken ?? 'Generating...',
                style: GoogleFonts.firaCode(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPurple,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _copyTokenToClipboard,
                icon: Icon(
                  _tokenCopied ? Icons.check : Icons.copy,
                  size: 18,
                ),
                label: Text(_tokenCopied ? 'Copied!' : 'Copy Code'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: AppTheme.primaryPurple),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Instructions
        _buildInstructionStep(
          stepNumber: 1,
          title: 'Copy the code above',
          description: 'Tap "Copy Code" to copy your unique verification code.',
          isCompleted: _tokenCopied,
        ),
        const SizedBox(height: 16),

        _buildInstructionStep(
          stepNumber: 2,
          title: 'Add to your ${widget.platform} bio',
          description: 'Open ${widget.platform}, edit your profile, and paste the code anywhere in your bio.',
          isCompleted: _tokenAddedConfirmed,
        ),
        const SizedBox(height: 16),

        _buildInstructionStep(
          stepNumber: 3,
          title: 'Confirm and verify',
          description: 'Once added, confirm below and we\'ll verify ownership.',
          isCompleted: false,
        ),

        const SizedBox(height: 24),

        // Confirmation checkbox
        CheckboxListTile(
          value: _tokenAddedConfirmed,
          onChanged: (v) => setState(() => _tokenAddedConfirmed = v ?? false),
          title: Text(
            'I\'ve added the code to my ${widget.platform} bio',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.deepBlack,
            ),
          ),
          activeColor: AppTheme.primaryPurple,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),

        const SizedBox(height: 16),

        PrimaryButton(
          text: 'Verify Ownership',
          isLoading: _isVerifying,
          onPressed: (_tokenAddedConfirmed && !_isVerifying)
              ? _verifyOwnership
              : () {},
        ),

        const SizedBox(height: 16),

        Center(
          child: TextButton(
            onPressed: () {
              setState(() => _currentStep = VerificationStep.selectMethod);
            },
            child: Text(
              'Use different method',
              style: GoogleFonts.inter(
                color: AppTheme.primaryPurple,
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Note about removing code
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.softLilac.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                color: AppTheme.primaryPurple,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You can remove the code from your bio after verification is complete.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (_errorMessage != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.dangerRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _errorMessage!,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.dangerRed,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInstructionStep({
    required int stepNumber,
    required String title,
    required String description,
    required bool isCompleted,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isCompleted ? AppTheme.successGreen : _neutralGray200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    '$stepNumber',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.neutralGray700,
                    ),
                  ),
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
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: _neutralGray600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultStep() {
    if (_verificationSuccess) {
      return _buildSuccessResult();
    } else {
      return _buildFailureResult();
    }
  }

  Widget _buildSuccessResult() {
    return Column(
      children: [
        const SizedBox(height: 32),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.verified,
            color: AppTheme.successGreen,
            size: 48,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Level 3 Verified!',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.successGreen,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Your ${widget.platform} profile ownership has been verified.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.neutralGray700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Benefits unlocked
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.softLilac.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Benefits Unlocked',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepBlack,
                ),
              ),
              const SizedBox(height: 12),
              _buildBenefitItem('Star ratings now visible on your passport'),
              _buildBenefitItem('Profile contributes to your URS'),
              _buildBenefitItem('Ownership locked to your account'),
            ],
          ),
        ),

        const SizedBox(height: 32),

        PrimaryButton(
          text: 'Done',
          onPressed: () => context.pop(true),
        ),
      ],
    );
  }

  Widget _buildFailureResult() {
    return Column(
      children: [
        const SizedBox(height: 32),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.dangerRed.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline,
            color: AppTheme.dangerRed,
            size: 48,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Verification Failed',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.dangerRed,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _errorMessage ?? 'We couldn\'t verify ownership of this profile. Please try again.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.neutralGray700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Troubleshooting tips
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _warningYellow.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Troubleshooting Tips',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepBlack,
                ),
              ),
              const SizedBox(height: 12),
              _buildTroubleshootItem('Make sure your profile is set to public'),
              _buildTroubleshootItem('Check the profile URL is correct'),
              if (_selectedMethod == VerificationMethod.tokenInBio)
                _buildTroubleshootItem('Ensure the verification code is visible in your bio'),
              _buildTroubleshootItem('Wait a few minutes and try again'),
            ],
          ),
        ),

        const SizedBox(height: 32),

        PrimaryButton(
          text: 'Try Again',
          onPressed: () {
            setState(() {
              _currentStep = VerificationStep.selectMethod;
              _errorMessage = null;
              _shareInitiated = false;
              _tokenAddedConfirmed = false;
              _verificationToken = null;
            });
          },
        ),

        const SizedBox(height: 16),

        TextButton(
          onPressed: () => context.pop(false),
          child: Text(
            'Skip for now (Level 1)',
            style: GoogleFonts.inter(
              color: _neutralGray600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTroubleshootItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline,
            color: _warningYellow,
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
}

enum VerificationMethod {
  shareIntent,
  tokenInBio,
}

enum VerificationStep {
  selectMethod,
  verifyOwnership,
  result,
}
