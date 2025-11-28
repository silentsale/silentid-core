import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../services/api_service.dart';
import 'level3_verification_screen.dart';

class ProfileLinkScreen extends StatefulWidget {
  const ProfileLinkScreen({super.key});

  @override
  State<ProfileLinkScreen> createState() => _ProfileLinkScreenState();
}

class _ProfileLinkScreenState extends State<ProfileLinkScreen> {
  final _formKey = GlobalKey<FormState>();
  final _api = ApiService();
  final _urlController = TextEditingController();

  bool _isLoading = false;
  String? _detectedPlatform;

  final Map<String, List<String>> _platformExamples = {
    'Vinted': [
      'https://vinted.com/member/123456',
      'https://www.vinted.co.uk/member/yourname',
    ],
    'eBay': [
      'https://www.ebay.com/usr/yourname',
      'https://www.ebay.co.uk/usr/yourname',
    ],
    'Depop': [
      'https://www.depop.com/yourname',
    ],
    'Etsy': [
      'https://www.etsy.com/shop/YourShopName',
    ],
    'Facebook Marketplace': [
      'https://www.facebook.com/marketplace/profile/123456789',
    ],
  };

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _detectPlatform(String url) {
    if (url.contains('vinted.')) {
      setState(() => _detectedPlatform = 'Vinted');
    } else if (url.contains('ebay.')) {
      setState(() => _detectedPlatform = 'eBay');
    } else if (url.contains('depop.')) {
      setState(() => _detectedPlatform = 'Depop');
    } else if (url.contains('etsy.')) {
      setState(() => _detectedPlatform = 'Etsy');
    } else if (url.contains('facebook.com/marketplace')) {
      setState(() => _detectedPlatform = 'Facebook Marketplace');
    } else {
      setState(() => _detectedPlatform = null);
    }
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _api.post(
        '/v1/evidence/profile-links',
        data: {
          'url': _urlController.text.trim(),
          'platform': _detectedPlatform ?? 'Other',
        },
      );

      if (mounted) {
        // Extract profile link ID from response for verification
        final profileLinkId = response.data['id']?.toString();
        final profileUrl = _urlController.text.trim();
        final platform = _detectedPlatform ?? 'Other';

        // Navigate to Level 3 Verification flow (Section 49)
        final verified = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => Level3VerificationScreen(
              profileUrl: profileUrl,
              platform: platform,
              profileLinkId: profileLinkId,
            ),
          ),
        );

        if (mounted) {
          if (verified == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile verified at Level 3!'),
                backgroundColor: AppTheme.successGreen,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile added at Level 1'),
                backgroundColor: AppTheme.successGreen,
              ),
            );
          }
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add profile: ${e.toString()}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Profile Link',
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info text
                Text(
                  'Add your public profile from marketplaces like Vinted, eBay, Depop, or Etsy. We\'ll scan your ratings and transaction history.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.neutralGray700,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // URL input
                AppTextField(
                  controller: _urlController,
                  label: 'Public Profile URL',
                  hint: 'https://vinted.com/member/yourname',
                  keyboardType: TextInputType.url,
                  onChanged: _detectPlatform,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a profile URL';
                    }
                    if (!value.startsWith('http://') && !value.startsWith('https://')) {
                      return 'URL must start with http:// or https://';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Detected platform
                if (_detectedPlatform != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.softLilac,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppTheme.successGreen,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Detected: $_detectedPlatform',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.deepBlack,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 32),

                // Platform examples
                Text(
                  'Example URLs:',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepBlack,
                  ),
                ),

                const SizedBox(height: 12),

                ..._platformExamples.entries.map((entry) {
                  return _buildPlatformExample(
                    platform: entry.key,
                    examples: entry.value,
                  );
                }),

                const SizedBox(height: 32),

                // Privacy notice
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.softLilac,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryPurple,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'We only scan public information. Your profile must be publicly visible.',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppTheme.neutralGray900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Submit button
                PrimaryButton(
                  text: 'Continue to Verification',
                  isLoading: _isLoading,
                  onPressed: _isLoading ? () {} : _submitProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformExample({
    required String platform,
    required List<String> examples,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            platform,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 4),
          ...examples.map((example) {
            return Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 2.0),
              child: Text(
                example,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.neutralGray700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
