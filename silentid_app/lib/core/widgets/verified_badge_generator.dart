import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import '../theme/app_theme.dart';

// Additional colors not in AppTheme
class _BadgeColors {
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color neutralGray50 = Color(0xFFFAFAFA);
  static const Color neutralGray100 = Color(0xFFF5F5F5);
  static const Color neutralGray200 = Color(0xFFE5E5E5);
  static const Color neutralGray500 = Color(0xFF737373);
  static const Color neutralGray600 = Color(0xFF525252);
}

/// Verified Badge Generator for Section 51.3
/// Creates a premium, shareable badge image containing:
/// - "SilentID Verified" header
/// - User initials / username
/// - TrustScore (if public)
/// - Verification tier
/// - Mutual verification count
/// - QR code leading to public passport
/// - Dark/light mode variants

enum BadgeMode { light, dark }

enum BadgeSize { small, standard, story }

class VerifiedBadgeData {
  final String username;
  final String initials;
  final int? trustScore; // null if private
  final String trustScoreLabel;
  final bool isIdentityVerified;
  final int mutualVerificationCount;
  final String publicPassportUrl;
  final List<String> connectedPlatforms;

  const VerifiedBadgeData({
    required this.username,
    required this.initials,
    this.trustScore,
    required this.trustScoreLabel,
    required this.isIdentityVerified,
    required this.mutualVerificationCount,
    required this.publicPassportUrl,
    this.connectedPlatforms = const [],
  });

  bool get isTrustScorePublic => trustScore != null;
}

class VerifiedBadgeGenerator extends StatefulWidget {
  final VerifiedBadgeData data;
  final BadgeMode mode;
  final BadgeSize size;
  final VoidCallback? onShare;
  final VoidCallback? onDownload;

  const VerifiedBadgeGenerator({
    super.key,
    required this.data,
    this.mode = BadgeMode.light,
    this.size = BadgeSize.standard,
    this.onShare,
    this.onDownload,
  });

  @override
  State<VerifiedBadgeGenerator> createState() => _VerifiedBadgeGeneratorState();
}

class _VerifiedBadgeGeneratorState extends State<VerifiedBadgeGenerator> {
  final GlobalKey _badgeKey = GlobalKey();
  bool _isGenerating = false;

  Future<Uint8List?> _captureBadgeAsImage() async {
    try {
      final boundary = _badgeKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing badge: $e');
      return null;
    }
  }

  Future<void> _shareBadge() async {
    if (_isGenerating) return;

    setState(() => _isGenerating = true);
    HapticFeedback.mediumImpact();

    try {
      final imageBytes = await _captureBadgeAsImage();
      if (imageBytes == null) {
        _showError('Failed to generate badge image');
        return;
      }

      // Use system temp directory
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/silentid_badge.png');
      await file.writeAsBytes(imageBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Verified on SilentID - ${widget.data.publicPassportUrl}',
          subject: 'My SilentID Verified Badge',
        ),
      );

      widget.onShare?.call();
    } catch (e) {
      _showError('Failed to share badge');
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _downloadBadge() async {
    if (_isGenerating) return;

    setState(() => _isGenerating = true);
    HapticFeedback.mediumImpact();

    try {
      final imageBytes = await _captureBadgeAsImage();
      if (imageBytes == null) {
        _showError('Failed to generate badge image');
        return;
      }

      // Save to system temp (will be shared for actual download)
      final tempDir = Directory.systemTemp;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${tempDir.path}/silentid_badge_$timestamp.png');
      await file.writeAsBytes(imageBytes);

      widget.onDownload?.call();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Badge saved to ${file.path}',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      _showError('Failed to save badge');
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter()),
        backgroundColor: AppTheme.dangerRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Badge Preview
        RepaintBoundary(
          key: _badgeKey,
          child: _BadgeCard(
            data: widget.data,
            mode: widget.mode,
            size: widget.size,
          ),
        ),
        const SizedBox(height: 24),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.share_rounded,
                label: 'Share Badge',
                isLoading: _isGenerating,
                onPressed: _shareBadge,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionButton(
                icon: Icons.download_rounded,
                label: 'Download',
                isLoading: _isGenerating,
                isPrimary: false,
                onPressed: _downloadBadge,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final VerifiedBadgeData data;
  final BadgeMode mode;
  final BadgeSize size;

  const _BadgeCard({
    required this.data,
    required this.mode,
    required this.size,
  });

  Size get _dimensions {
    switch (size) {
      case BadgeSize.small:
        return const Size(280, 320);
      case BadgeSize.standard:
        return const Size(320, 400);
      case BadgeSize.story:
        return const Size(360, 640);
    }
  }

  Color get _backgroundColor =>
      mode == BadgeMode.dark ? const Color(0xFF1A1A2E) : Colors.white;

  Color get _textColor =>
      mode == BadgeMode.dark ? Colors.white : AppTheme.neutralGray900;

  Color get _subtitleColor =>
      mode == BadgeMode.dark ? Colors.white70 : _BadgeColors.neutralGray500;

  Color get _cardBorderColor =>
      mode == BadgeMode.dark
          ? Colors.white.withValues(alpha: 0.1)
          : _BadgeColors.neutralGray200;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _dimensions.width,
      height: _dimensions.height,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _cardBorderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with gradient
          _buildHeader(),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // User info
                  _buildUserInfo(),
                  const SizedBox(height: 16),

                  // Trust Score or Private indicator
                  _buildTrustScoreSection(),
                  const SizedBox(height: 16),

                  // Stats row
                  _buildStatsRow(),

                  const Spacer(),

                  // QR Code
                  _buildQrCode(),

                  const SizedBox(height: 12),

                  // Footer
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryPurple,
            AppTheme.primaryPurple.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'SilentID Verified',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        // Avatar with initials
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryPurple.withValues(alpha: 0.15),
                _BadgeColors.accentBlue.withValues(alpha: 0.1),
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.primaryPurple.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              data.initials,
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryPurple,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '@${data.username}',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
        if (data.isIdentityVerified) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_user_rounded,
                size: 14,
                color: AppTheme.successGreen,
              ),
              const SizedBox(width: 4),
              Text(
                'Identity Verified',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.successGreen,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTrustScoreSection() {
    if (data.isTrustScorePublic) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryPurple.withValues(alpha: 0.1),
              _BadgeColors.accentBlue.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryPurple.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Text(
              'TrustScore',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: _subtitleColor,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${data.trustScore}',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryPurple,
                    height: 1,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '/1000',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _subtitleColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getTrustScoreColor().withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                data.trustScoreLabel,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _getTrustScoreColor(),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Private mode
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: mode == BadgeMode.dark
            ? Colors.white.withValues(alpha: 0.05)
            : _BadgeColors.neutralGray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_rounded,
            size: 16,
            color: _subtitleColor,
          ),
          const SizedBox(width: 8),
          Text(
            'TrustScore Private',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _subtitleColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTrustScoreColor() {
    final score = data.trustScore ?? 0;
    if (score >= 850) return const Color(0xFF10B981); // Exceptional
    if (score >= 700) return const Color(0xFF059669); // Very High
    if (score >= 550) return AppTheme.successGreen; // High
    if (score >= 400) return AppTheme.warningAmber; // Moderate
    if (score >= 250) return AppTheme.dangerRed.withValues(alpha: 0.8); // Low
    return AppTheme.dangerRed; // High Risk
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatItem(
          icon: Icons.people_rounded,
          value: '${data.mutualVerificationCount}',
          label: 'Verifications',
          textColor: _textColor,
          subtitleColor: _subtitleColor,
        ),
        Container(
          width: 1,
          height: 30,
          color: _cardBorderColor,
          margin: const EdgeInsets.symmetric(horizontal: 20),
        ),
        _StatItem(
          icon: Icons.link_rounded,
          value: '${data.connectedPlatforms.length}',
          label: 'Platforms',
          textColor: _textColor,
          subtitleColor: _subtitleColor,
        ),
      ],
    );
  }

  Widget _buildQrCode() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cardBorderColor),
      ),
      child: QrImageView(
        data: data.publicPassportUrl,
        version: QrVersions.auto,
        size: size == BadgeSize.story ? 100 : 80,
        backgroundColor: Colors.white,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Color(0xFF1A1A2E),
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Color(0xFF1A1A2E),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'Scan to verify',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: _subtitleColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'silentid.app',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryPurple,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color textColor;
  final Color subtitleColor;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryPurple),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: subtitleColor,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLoading;
  final bool isPrimary;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.isLoading = false,
    this.isPrimary = true,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? AppTheme.primaryPurple : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: isPrimary
              ? null
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.neutralGray300),
                ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isPrimary ? Colors.white : AppTheme.primaryPurple,
                  ),
                )
              else
                Icon(
                  icon,
                  size: 18,
                  color: isPrimary ? Colors.white : AppTheme.neutralGray700,
                ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? Colors.white : AppTheme.neutralGray700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Screen to generate and share verified badge
class VerifiedBadgeScreen extends StatefulWidget {
  final VerifiedBadgeData data;

  const VerifiedBadgeScreen({
    super.key,
    required this.data,
  });

  @override
  State<VerifiedBadgeScreen> createState() => _VerifiedBadgeScreenState();
}

class _VerifiedBadgeScreenState extends State<VerifiedBadgeScreen> {
  BadgeMode _selectedMode = BadgeMode.light;
  BadgeSize _selectedSize = BadgeSize.standard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _BadgeColors.neutralGray50,
      appBar: AppBar(
        title: Text(
          'Share Your Badge',
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode Selector
            Text(
              'Badge Style',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _ModeChip(
                  label: 'Light',
                  icon: Icons.light_mode_rounded,
                  isSelected: _selectedMode == BadgeMode.light,
                  onTap: () => setState(() => _selectedMode = BadgeMode.light),
                ),
                const SizedBox(width: 8),
                _ModeChip(
                  label: 'Dark',
                  icon: Icons.dark_mode_rounded,
                  isSelected: _selectedMode == BadgeMode.dark,
                  onTap: () => setState(() => _selectedMode = BadgeMode.dark),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Size Selector
            Text(
              'Badge Size',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _ModeChip(
                  label: 'Small',
                  isSelected: _selectedSize == BadgeSize.small,
                  onTap: () => setState(() => _selectedSize = BadgeSize.small),
                ),
                const SizedBox(width: 8),
                _ModeChip(
                  label: 'Standard',
                  isSelected: _selectedSize == BadgeSize.standard,
                  onTap: () =>
                      setState(() => _selectedSize = BadgeSize.standard),
                ),
                const SizedBox(width: 8),
                _ModeChip(
                  label: 'Story',
                  isSelected: _selectedSize == BadgeSize.story,
                  onTap: () => setState(() => _selectedSize = BadgeSize.story),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Badge Preview
            Center(
              child: VerifiedBadgeGenerator(
                data: widget.data,
                mode: _selectedMode,
                size: _selectedSize,
                onShare: () {
                  HapticFeedback.lightImpact();
                },
                onDownload: () {
                  HapticFeedback.lightImpact();
                },
              ),
            ),
            const SizedBox(height: 32),

            // Tips
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _BadgeColors.accentBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _BadgeColors.accentBlue.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_rounded,
                        size: 18,
                        color: _BadgeColors.accentBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sharing Tips',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _BadgeColors.accentBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _TipItem(
                    text: 'Use "Story" size for Instagram/TikTok stories',
                  ),
                  _TipItem(
                    text: 'Dark mode looks great on dating profiles',
                  ),
                  _TipItem(
                    text: 'QR code links directly to your public passport',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    this.icon,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryPurple
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryPurple
                : AppTheme.neutralGray300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : _BadgeColors.neutralGray600,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppTheme.neutralGray700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;

  const _TipItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: _BadgeColors.neutralGray600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: _BadgeColors.neutralGray600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
