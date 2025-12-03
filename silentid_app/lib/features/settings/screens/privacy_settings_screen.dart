import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/utils/app_messages.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/widgets/info_modal.dart';
import '../../../core/constants/api_constants.dart';
import '../../../services/api_service.dart';

/// TrustScore visibility mode per Section 51.5
enum TrustScoreVisibility {
  /// TrustScore visible everywhere (public passport, badge, profile)
  publicMode,

  /// TrustScore hidden but badges and verification status shown
  badgeOnlyMode,

  /// TrustScore completely hidden, only verification badge visible
  privateMode,
}

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen>
    with SingleTickerProviderStateMixin {
  final _api = ApiService();

  // Level 7: Animation controller
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  bool _isLoading = true;

  // TrustScore Visibility Mode (Section 51.5)
  TrustScoreVisibility _trustScoreVisibility = TrustScoreVisibility.publicMode;

  // Public Metrics Visibility
  bool _showTransactionCount = true;
  bool _showPlatformList = true;
  bool _showAccountAge = true;

  @override
  void initState() {
    super.initState();
    // Level 7: Initialize animations
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _loadSettings();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    try {
      final response = await _api.get(ApiConstants.privacySettings);
      final data = response.data as Map<String, dynamic>;

      setState(() {
        _trustScoreVisibility = _parseVisibility(data['trustScoreVisibility']);
        _showTransactionCount = data['showTransactionCount'] ?? true;
        _showPlatformList = data['showPlatformList'] ?? true;
        _showAccountAge = data['showAccountAge'] ?? true;
        _isLoading = false;
      });
      // Level 7: Start animation after data loads
      _animController.forward();
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  TrustScoreVisibility _parseVisibility(String? value) {
    switch (value) {
      case 'badgeOnlyMode':
        return TrustScoreVisibility.badgeOnlyMode;
      case 'privateMode':
        return TrustScoreVisibility.privateMode;
      default:
        return TrustScoreVisibility.publicMode;
    }
  }

  Future<void> _saveSetting(String key, bool value) async {
    try {
      await _api.patch(ApiConstants.privacySettings, data: {key: value});
    } catch (e) {
      if (mounted) {
        AppMessages.showError(context, ErrorMessages.fromException(e, fallbackAction: 'save setting'));
      }
    }
  }

  void _onVisibilityModeChanged(TrustScoreVisibility mode) {
    AppHaptics.light();
    setState(() {
      _trustScoreVisibility = mode;
    });
    _saveVisibilitySetting(mode);
  }

  Future<void> _saveVisibilitySetting(TrustScoreVisibility mode) async {
    try {
      await _api.patch(ApiConstants.privacySettings, data: {
        'trustScoreVisibility': mode.name,
      });
    } catch (e) {
      if (mounted) {
        AppMessages.showError(context, ErrorMessages.fromException(e, fallbackAction: 'save visibility setting'));
      }
    }
  }

  void _showVisibilityInfo(BuildContext context) {
    InfoModal.show(
      context,
      title: 'TrustScore Visibility',
      body:
          'Control how your TrustScore appears on your public passport and shared badge.\n\n'
          '\u2022 Public Mode: Your exact TrustScore is visible to everyone.\n'
          '\u2022 Badge Only: Show your verification badges and tier, but hide the exact number.\n'
          '\u2022 Private Mode: Only show that you\'re verified, hide all score details.',
      icon: Icons.visibility_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Privacy Settings',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Section 51.5: TrustScore Visibility Control
                Row(
                  children: [
                    const Text(
                      'TrustScore Visibility',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutralGray900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _showVisibilityInfo(context),
                      child: Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.info_outline,
                          size: 20,
                          color: AppTheme.neutralGray700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose how your TrustScore appears when you share your profile.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.neutralGray700,
                  ),
                ),
                const SizedBox(height: 20),

                // Visibility Mode Selector
                _buildVisibilityModeSelector(),

                const SizedBox(height: 20),

                // Visual Preview
                _buildVisibilityPreview(),

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 24),

                // Public Metrics Section
                const Text(
                  'Public Profile Visibility',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.neutralGray900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Control what information is visible on your public SilentID profile',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.neutralGray700,
                  ),
                ),
                const SizedBox(height: 24),

                _buildToggle(
                  'Show transaction count',
                  'Display total number of verified transactions',
                  _showTransactionCount,
                  (value) {
                    setState(() => _showTransactionCount = value);
                    _saveSetting('showTransactionCount', value);
                  },
                ),
                const SizedBox(height: 16),

                _buildToggle(
                  'Show platform list',
                  'Display platforms you\'re verified on (Vinted, eBay, etc.)',
                  _showPlatformList,
                  (value) {
                    setState(() => _showPlatformList = value);
                    _saveSetting('showPlatformList', value);
                  },
                ),
                const SizedBox(height: 16),

                _buildToggle(
                  'Show account age',
                  'Display how long you\'ve had your SilentID account',
                  _showAccountAge,
                  (value) {
                    setState(() => _showAccountAge = value);
                    _saveSetting('showAccountAge', value);
                  },
                ),

                const SizedBox(height: 32),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.softLilac.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 20,
                        color: AppTheme.primaryPurple,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your identity verification badge is always visible. Your TrustScore is private by default. Your full name, email, phone, and address are never shown publicly.',
                          style: TextStyle(
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
      ),
    );
  }

  Widget _buildToggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 24,
              color: AppTheme.primaryPurple,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralGray900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppTheme.primaryPurple.withValues(alpha: 0.5),
            activeThumbColor: AppTheme.primaryPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilityModeSelector() {
    return Column(
      children: [
        _buildVisibilityOption(
          mode: TrustScoreVisibility.publicMode,
          title: 'Public Mode',
          subtitle: 'Show your exact TrustScore (e.g., 754/1000)',
          icon: Icons.visibility_rounded,
          recommended: true,
        ),
        const SizedBox(height: 12),
        _buildVisibilityOption(
          mode: TrustScoreVisibility.badgeOnlyMode,
          title: 'Badge Only Mode',
          subtitle: 'Show badges and tier (e.g., "High Trust") but hide exact score',
          icon: Icons.shield_rounded,
        ),
        const SizedBox(height: 12),
        _buildVisibilityOption(
          mode: TrustScoreVisibility.privateMode,
          title: 'Private Mode',
          subtitle: 'Only show that you\'re verified, hide all score details',
          icon: Icons.lock_rounded,
        ),
      ],
    );
  }

  Widget _buildVisibilityOption({
    required TrustScoreVisibility mode,
    required String title,
    required String subtitle,
    required IconData icon,
    bool recommended = false,
  }) {
    final isSelected = _trustScoreVisibility == mode;

    return GestureDetector(
      onTap: () => _onVisibilityModeChanged(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryPurple.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryPurple : AppTheme.neutralGray300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryPurple.withValues(alpha: 0.15)
                    : AppTheme.neutralGray300.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected ? AppTheme.primaryPurple : AppTheme.neutralGray700,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppTheme.primaryPurple
                              : AppTheme.neutralGray900,
                        ),
                      ),
                      if (recommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.successGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Recommended',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.successGreen,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
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
            const SizedBox(width: 8),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryPurple
                      : AppTheme.neutralGray300,
                  width: 2,
                ),
                color: isSelected ? AppTheme.primaryPurple : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisibilityPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.neutralGray300.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.preview_rounded, size: 18, color: AppTheme.neutralGray700),
              const SizedBox(width: 8),
              Text(
                'Preview: How others see your profile',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.neutralGray700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPreviewCard(),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // User avatar and name
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryPurple.withValues(alpha: 0.2),
                      AppTheme.primaryPurple.withValues(alpha: 0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'JD',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
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
                          '@johndoe',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.neutralGray900,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: AppTheme.successGreen,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Identity Verified',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.successGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // TrustScore display based on mode
          _buildPreviewTrustScore(),
        ],
      ),
    );
  }

  Widget _buildPreviewTrustScore() {
    switch (_trustScoreVisibility) {
      case TrustScoreVisibility.publicMode:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryPurple.withValues(alpha: 0.1),
                AppTheme.primaryPurple.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TrustScore: ',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.neutralGray700,
                ),
              ),
              Text(
                '754',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryPurple,
                ),
              ),
              Text(
                '/1000',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.neutralGray700,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Very High',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successGreen,
                  ),
                ),
              ),
            ],
          ),
        );

      case TrustScoreVisibility.badgeOnlyMode:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.neutralGray300.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shield_rounded,
                size: 20,
                color: AppTheme.successGreen,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Very High Trust',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successGreen,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  _buildMiniBadge(Icons.verified_user_rounded),
                  const SizedBox(width: 4),
                  _buildMiniBadge(Icons.link_rounded),
                  const SizedBox(width: 4),
                  _buildMiniBadge(Icons.people_rounded),
                ],
              ),
            ],
          ),
        );

      case TrustScoreVisibility.privateMode:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.neutralGray300.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_rounded,
                size: 18,
                color: AppTheme.neutralGray700,
              ),
              const SizedBox(width: 8),
              Text(
                'TrustScore is private',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.neutralGray700,
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildMiniBadge(IconData icon) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        size: 14,
        color: AppTheme.primaryPurple,
      ),
    );
  }
}
