import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/verified_badge_generator.dart';
import '../../../core/enums/button_variant.dart';

class ShareProfileSheet extends StatefulWidget {
  final String username;
  final String? displayName;
  final int? trustScore;
  final String trustScoreLabel;
  final bool isIdentityVerified;
  final List<String> connectedPlatforms;

  const ShareProfileSheet({
    super.key,
    required this.username,
    this.displayName,
    this.trustScore,
    this.trustScoreLabel = 'Unknown',
    this.isIdentityVerified = false,
    this.connectedPlatforms = const [],
  });

  @override
  State<ShareProfileSheet> createState() => _ShareProfileSheetState();
}

class _ShareProfileSheetState extends State<ShareProfileSheet> {
  int _selectedTab = 0; // 0 = QR/Link, 1 = Verified Badge

  String get profileUrl => 'https://silentid.co.uk/u/${widget.username}';

  String get _initials {
    final name = widget.displayName ?? widget.username;
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: profileUrl));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile URL copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _shareProfile() async {
    await SharePlus.instance.share(
      ShareParams(
        text: 'Check out my SilentID trust profile: $profileUrl',
        subject: 'My SilentID Profile',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle Bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.neutralGray300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  'Share Your Profile',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.neutralGray900,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Tab Selector
                _buildTabSelector(),

                const SizedBox(height: 24),

                // Content based on tab
                if (_selectedTab == 0)
                  _buildQRLinkTab()
                else
                  _buildVerifiedBadgeTab(),

                const SizedBox(height: 16),

                // Close Button
                PrimaryButton(
                  text: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  variant: ButtonVariant.secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.neutralGray200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'QR / Link',
              icon: Icons.qr_code_rounded,
              isSelected: _selectedTab == 0,
              onTap: () => setState(() => _selectedTab = 0),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'Verified Badge',
              icon: Icons.verified_rounded,
              isSelected: _selectedTab == 1,
              onTap: () => setState(() => _selectedTab = 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRLinkTab() {
    return Column(
      children: [
        Text(
          'Scan this QR code or share your profile link',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.neutralGray700,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        // QR Code
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.neutralGray300,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: QrImageView(
              data: profileUrl,
              version: QrVersions.auto,
              size: 180,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppTheme.primaryPurple,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: AppTheme.neutralGray900,
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Profile URL
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.softLilac.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryPurple.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.link,
                color: AppTheme.primaryPurple,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  profileUrl,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.neutralGray900,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _copyToClipboard(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Copy',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Share Button
        PrimaryButton(
          text: 'Share Link',
          onPressed: _shareProfile,
          icon: Icons.share,
        ),
      ],
    );
  }

  Widget _buildVerifiedBadgeTab() {
    final badgeData = VerifiedBadgeData(
      username: widget.username,
      initials: _initials,
      trustScore: widget.trustScore,
      trustScoreLabel: widget.trustScoreLabel,
      isIdentityVerified: widget.isIdentityVerified,
      publicPassportUrl: profileUrl,
      connectedPlatforms: widget.connectedPlatforms,
    );

    return Column(
      children: [
        Text(
          'Share your verified badge on social media',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.neutralGray700,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // Platform recommendations
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lightbulb_rounded,
                size: 18,
                color: AppTheme.primaryPurple,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Perfect for Instagram, Twitter, and LinkedIn bios',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Badge Generator
        VerifiedBadgeGenerator(
          data: badgeData,
          mode: BadgeMode.light,
          size: BadgeSize.small,
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppTheme.primaryPurple : AppTheme.neutralGray600,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.primaryPurple : AppTheme.neutralGray600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
