import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/info_modal.dart';
import '../../../services/profile_linking_service.dart';

/// Add Profile Screen - Section 52.3 Flow A
/// Share/Paste link to create a Linked profile
/// Supports pre-filled data from Share Target (Section 55)
class AddProfileScreen extends StatefulWidget {
  /// Optional initial URL (from share import or deep link)
  final String? initialUrl;

  /// Whether this screen was opened from share import
  final bool fromShare;

  const AddProfileScreen({
    super.key,
    this.initialUrl,
    this.fromShare = false,
  });

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final _service = ProfileLinkingService();
  final _urlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  ProfileDetectionResult? _detectionResult;
  PlatformConfig? _detectedPlatform;

  @override
  void initState() {
    super.initState();
    // Pre-fill URL if provided from share import (Section 55)
    if (widget.initialUrl != null && widget.initialUrl!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _urlController.text = widget.initialUrl!;
        _onUrlChanged(widget.initialUrl!);
      });
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _onUrlChanged(String url) {
    if (url.length > 10) {
      final result = _service.detectProfileFromUrl(url);
      setState(() {
        _detectionResult = result;
        if (result.detected && result.platformId != null) {
          _detectedPlatform = _service.getPlatformById(result.platformId!);
        } else {
          _detectedPlatform = null;
        }
      });
    } else {
      setState(() {
        _detectionResult = null;
        _detectedPlatform = null;
      });
    }
  }

  Future<void> _confirmLink() async {
    if (_detectionResult == null || !_detectionResult!.detected) {
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    try {
      final profile = await _service.linkProfile(
        platformId: _detectionResult!.platformId!,
        username: _detectionResult!.username!,
        profileUrl: _detectionResult!.normalizedUrl!,
      );

      if (mounted) {
        // Show success and return profile
        _showSuccessDialog(profile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to link profile: $e'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog(ConnectedProfile profile) {
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
                Icons.check_circle_rounded,
                color: AppTheme.successGreen,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Profile Linked!',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.neutralGray900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your ${_detectedPlatform?.displayName} profile is now connected.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.warningAmber.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Status: Linked (Not Verified Yet)',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.warningAmber,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You can upgrade to Verified anytime for stronger trust.',
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
              Navigator.pop(context, profile); // Return to previous screen
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

  void _showLinkedInfo() {
    InfoModal.show(
      context,
      title: 'Linked Profile',
      body: 'A linked profile is connected to your SilentID.\n\n'
          'It appears on your passport as "Linked" and gives a small trust boost.\n\n'
          'You can upgrade it to Verified anytime for stronger trust.',
      icon: Icons.link_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Add Profile',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructions
              _buildInstructions(),
              const SizedBox(height: 24),

              // URL Input
              _buildUrlInput(),
              const SizedBox(height: 24),

              // Detection Result
              if (_detectionResult != null) _buildDetectionResult(),

              // Confirm Button
              if (_detectionResult?.detected == true) ...[
                const SizedBox(height: 24),
                _buildConfirmButton(),
              ],

              const SizedBox(height: 32),

              // Example URLs
              _buildExampleUrls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
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
                Icons.lightbulb_outline_rounded,
                color: AppTheme.primaryPurple,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'How to add a profile',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStep('1', 'Open the app with your profile'),
          const SizedBox(height: 8),
          _buildStep('2', 'Copy the profile link or share it here'),
          const SizedBox(height: 8),
          _buildStep('3', 'We\'ll detect the platform automatically'),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryPurple,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
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
    );
  }

  Widget _buildUrlInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile URL',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _urlController,
          onChanged: _onUrlChanged,
          keyboardType: TextInputType.url,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: 'Paste your profile link here...',
            hintStyle: GoogleFonts.inter(color: AppTheme.neutralGray300),
            prefixIcon: Icon(
              Icons.link_rounded,
              color: AppTheme.neutralGray700,
            ),
            suffixIcon: _urlController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _urlController.clear();
                      _onUrlChanged('');
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.neutralGray300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.neutralGray300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryPurple, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a profile URL';
            }
            if (!value.contains('http')) {
              return 'Please enter a valid URL';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDetectionResult() {
    if (_detectionResult!.detected && _detectedPlatform != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.successGreen.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.successGreen.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.successGreen,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Profile Detected!',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Platform info
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _detectedPlatform!.brandColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _detectedPlatform!.icon,
                    color: _detectedPlatform!.brandColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _detectedPlatform!.displayName,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.neutralGray900,
                        ),
                      ),
                      Text(
                        '@${_detectionResult!.username}',
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
            const SizedBox(height: 16),

            // Status indicator
            GestureDetector(
              onTap: _showLinkedInfo,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.neutralGray300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.link_rounded,
                      size: 16,
                      color: AppTheme.warningAmber,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Status: Linked (Not Verified Yet)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.neutralGray700,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.info_outline_rounded,
                      size: 14,
                      color: AppTheme.neutralGray700,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Detection failed
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.dangerRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.dangerRed.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppTheme.dangerRed,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _detectionResult!.error ?? 'Could not detect platform',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.dangerRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Material(
      color: AppTheme.primaryPurple,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: _isLoading ? null : _confirmLink,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else
                const Icon(Icons.check_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                _isLoading ? 'Linking...' : 'Confirm',
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
    );
  }

  Widget _buildExampleUrls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Example URLs',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray700,
          ),
        ),
        const SizedBox(height: 8),
        _buildExampleUrl('instagram.com/username'),
        _buildExampleUrl('vinted.co.uk/member/12345'),
        _buildExampleUrl('depop.com/shopname'),
        _buildExampleUrl('linkedin.com/in/name'),
        _buildExampleUrl('tiktok.com/@username'),
      ],
    );
  }

  Widget _buildExampleUrl(String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.link_rounded,
            size: 14,
            color: AppTheme.neutralGray300,
          ),
          const SizedBox(width: 8),
          Text(
            url,
            style: GoogleFonts.robotoMono(
              fontSize: 12,
              color: AppTheme.neutralGray700,
            ),
          ),
        ],
      ),
    );
  }
}
