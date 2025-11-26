import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/trust_score_star_rating.dart';
import '../../../models/public_profile.dart';
import '../../../services/public_profile_service.dart';
import '../../../services/api_service.dart';

/// Public Profile Viewer Screen
///
/// View other users' public profiles via username
/// Uses GET /v1/public/profile/{username} endpoint
/// Following Section 39 specifications
class PublicProfileViewerScreen extends StatefulWidget {
  final String username;

  const PublicProfileViewerScreen({
    super.key,
    required this.username,
  });

  @override
  State<PublicProfileViewerScreen> createState() => _PublicProfileViewerScreenState();
}

class _PublicProfileViewerScreenState extends State<PublicProfileViewerScreen> {
  bool _isLoading = true;
  PublicProfile? _profile;
  String? _error;
  late final PublicProfileService _publicProfileService;

  @override
  void initState() {
    super.initState();
    _publicProfileService = PublicProfileService(ApiService());
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profile = await _publicProfileService.getPublicProfile(widget.username);
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _shareProfile() async {
    if (_profile == null) return;

    final shareText = _publicProfileService.getShareText(
      _profile!.username,
      _profile!.displayName,
    );

    await SharePlus.instance.share(
      ShareParams(
        text: shareText,
        subject: 'SilentID Trust Profile',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: _shareProfile,
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(Icons.flag_outlined),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/safety/report',
                arguments: widget.username,
              );
            },
            tooltip: 'Report',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState()
              : _buildProfileContent(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.dangerRed,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Could not load profile',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBlack,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _error ?? 'Unknown error',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(
              onPressed: _loadProfile,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    final profile = _profile!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.softLilac,
                  child: Text(
                    profile.displayName[0],
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Display Name
                Text(
                  profile.displayName,
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepBlack,
                  ),
                ),

                const SizedBox(height: AppSpacing.xxs),

                // Username
                Text(
                  profile.username,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Safety Warning (if applicable)
          if (profile.hasSafetyWarning)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppTheme.warningAmber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.warningAmber,
                  width: 2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_outlined,
                    color: AppTheme.warningAmber,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Safety Concern Reported',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.deepBlack,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          profile.riskWarning!,
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

          // TrustScore Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryPurple, AppTheme.darkModePurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'TrustScore',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppTheme.pureWhite.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  '${profile.trustScore}',
                  style: GoogleFonts.inter(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.pureWhite,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  profile.trustScoreLabel,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.pureWhite,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                TrustScoreStarRating.large(
                  trustScore: profile.trustScore,
                  showNumericScore: false,
                  colorOverride: AppTheme.pureWhite,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Badges Section
          if (profile.badges.isNotEmpty) ...[
            Text(
              'Badges',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBlack,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.badges.map((badge) => _buildBadge(badge)).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Metrics Section
          Text(
            'Activity Metrics',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.deepBlack,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.receipt_outlined,
                  label: 'Receipts',
                  value: '${profile.verifiedTransactionCount}',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.verified_user_outlined,
                  label: 'Verified',
                  value: '${profile.mutualVerificationCount}',
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.store_outlined,
                  label: 'Platforms',
                  value: '${profile.verifiedPlatforms.length}',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildMetricCard(
                  icon: Icons.calendar_today_outlined,
                  label: 'Account Age',
                  value: profile.accountAge,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // QR Code Section
          Text(
            'Share Profile',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.deepBlack,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppTheme.pureWhite,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.neutralGray300),
            ),
            child: Column(
              children: [
                // Real QR Code
                QrImageView(
                  data: profile.profileUrl,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: AppTheme.pureWhite,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Scan to view this SilentID profile',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Privacy Notice
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppTheme.softLilac,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryPurple,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Privacy Protected',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'This public profile only shows display name, username, TrustScore, and general activity metrics. '
                  'Full legal name, email, phone, address, and ID documents are never shown.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String badgeText) {
    IconData icon;
    Color color;

    // Map badge text to icon and color
    if (badgeText.contains('Identity Verified')) {
      icon = Icons.verified_outlined;
      color = AppTheme.successGreen;
    } else if (badgeText.contains('transaction')) {
      icon = Icons.receipt_outlined;
      color = AppTheme.primaryPurple;
    } else if (badgeText.contains('behaviour') || badgeText.contains('Excellent')) {
      icon = Icons.star_outlined;
      color = AppTheme.warningAmber;
    } else if (badgeText.contains('Peer-verified')) {
      icon = Icons.handshake_outlined;
      color = AppTheme.primaryPurple;
    } else {
      icon = Icons.check_circle_outlined;
      color = AppTheme.primaryPurple;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            badgeText,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.deepBlack,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryPurple,
            size: 28,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.deepBlack,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.neutralGray700,
            ),
          ),
        ],
      ),
    );
  }
}
