import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import 'info_modal.dart';

/// Connected Profile for Public Passport Display - Section 52.6
///
/// Represents a connected profile as shown on the public passport.
/// Simpler than the full ConnectedProfile model used internally.
class PublicConnectedProfile {
  final String platformId;
  final String platformName;
  final String username;
  final bool isVerified; // true = Verified, false = Linked
  final String? verificationMethod; // 'token' or 'screenshot' if verified

  const PublicConnectedProfile({
    required this.platformId,
    required this.platformName,
    required this.username,
    required this.isVerified,
    this.verificationMethod,
  });

  factory PublicConnectedProfile.fromJson(Map<String, dynamic> json) {
    return PublicConnectedProfile(
      platformId: json['platformId'] as String,
      platformName: json['platformName'] as String,
      username: json['username'] as String,
      isVerified: json['isVerified'] as bool,
      verificationMethod: json['verificationMethod'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platformId': platformId,
      'platformName': platformName,
      'username': username,
      'isVerified': isVerified,
      'verificationMethod': verificationMethod,
    };
  }

  /// Get platform icon
  IconData get icon {
    switch (platformId.toLowerCase()) {
      case 'vinted':
        return Icons.storefront_rounded;
      case 'ebay':
        return Icons.shopping_bag_rounded;
      case 'depop':
        return Icons.local_mall_rounded;
      case 'etsy':
        return Icons.store_rounded;
      case 'poshmark':
        return Icons.checkroom_rounded;
      case 'facebook_marketplace':
        return Icons.facebook_rounded;
      case 'instagram':
        return Icons.camera_alt_rounded;
      case 'tiktok':
        return Icons.music_note_rounded;
      case 'twitter':
        return Icons.alternate_email_rounded;
      case 'youtube':
        return Icons.play_circle_rounded;
      case 'linkedin':
        return Icons.work_rounded;
      case 'github':
        return Icons.code_rounded;
      case 'discord':
        return Icons.headset_mic_rounded;
      case 'twitch':
        return Icons.videogame_asset_rounded;
      case 'steam':
        return Icons.sports_esports_rounded;
      case 'reddit':
        return Icons.forum_rounded;
      default:
        return Icons.link_rounded;
    }
  }

  /// Get platform brand color
  Color get brandColor {
    switch (platformId.toLowerCase()) {
      case 'vinted':
        return const Color(0xFF09B1BA);
      case 'ebay':
        return const Color(0xFFE53238);
      case 'depop':
        return const Color(0xFFFF2300);
      case 'etsy':
        return const Color(0xFFF56400);
      case 'poshmark':
        return const Color(0xFF7F0353);
      case 'facebook_marketplace':
        return const Color(0xFF1877F2);
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'tiktok':
        return const Color(0xFF000000);
      case 'twitter':
        return const Color(0xFF000000);
      case 'youtube':
        return const Color(0xFFFF0000);
      case 'linkedin':
        return const Color(0xFF0A66C2);
      case 'github':
        return const Color(0xFF181717);
      case 'discord':
        return const Color(0xFF5865F2);
      case 'twitch':
        return const Color(0xFF9146FF);
      case 'steam':
        return const Color(0xFF171A21);
      case 'reddit':
        return const Color(0xFFFF4500);
      default:
        return AppTheme.neutralGray700;
    }
  }
}

/// Public Connected Profiles Widget - Section 52.6
///
/// Displays connected profiles on the public passport view.
/// Shows Verified (✅) and Linked (🔗) profiles with info overlays.
///
/// UI follows Section 53 design guidelines.
class PublicConnectedProfilesWidget extends StatelessWidget {
  final List<PublicConnectedProfile> profiles;
  final bool showInfoButton;

  const PublicConnectedProfilesWidget({
    super.key,
    required this.profiles,
    this.showInfoButton = true,
  });

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return const SizedBox.shrink();
    }

    final verifiedProfiles = profiles.where((p) => p.isVerified).toList();
    final linkedProfiles = profiles.where((p) => !p.isVerified).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Text(
              'External Profiles',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray900,
              ),
            ),
            if (showInfoButton) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _showProfilesInfo(context),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: AppTheme.primaryPurple,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),

        // Profiles List
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.neutralGray300),
          ),
          child: Column(
            children: [
              // Verified Profiles
              ...verifiedProfiles.map(
                (profile) => _buildProfileRow(context, profile),
              ),
              // Linked Profiles
              ...linkedProfiles.map(
                (profile) => _buildProfileRow(context, profile),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileRow(BuildContext context, PublicConnectedProfile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Status Icon
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: profile.isVerified
                  ? AppTheme.successGreen.withValues(alpha: 0.15)
                  : AppTheme.neutralGray300.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              profile.isVerified
                  ? Icons.verified_rounded
                  : Icons.link_rounded,
              size: 14,
              color: profile.isVerified
                  ? AppTheme.successGreen
                  : AppTheme.neutralGray700,
            ),
          ),
          const SizedBox(width: 12),

          // Platform Icon
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: profile.brandColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              profile.icon,
              size: 16,
              color: profile.brandColor,
            ),
          ),
          const SizedBox(width: 10),

          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      profile.isVerified ? 'Verified' : 'Linked',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: profile.isVerified
                            ? AppTheme.successGreen
                            : AppTheme.neutralGray700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      profile.platformName,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.neutralGray900,
                      ),
                    ),
                  ],
                ),
                Text(
                  '@${profile.username}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),

          // Info button for individual profile
          GestureDetector(
            onTap: () => profile.isVerified
                ? _showVerifiedInfo(context)
                : _showLinkedInfo(context),
            child: Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: AppTheme.neutralGray300,
            ),
          ),
        ],
      ),
    );
  }

  void _showProfilesInfo(BuildContext context) {
    InfoModal.show(
      context,
      title: 'External Profiles',
      body:
          'This user has connected their profiles from other platforms to SilentID.\n\n'
          '✅ Verified profiles have confirmed ownership via token or screenshot.\n\n'
          '🔗 Linked profiles were added by the user but not fully verified.',
      icon: Icons.account_circle_rounded,
    );
  }

  void _showVerifiedInfo(BuildContext context) {
    InfoModal.show(
      context,
      title: 'What does "Verified" mean?',
      body:
          'The user proved ownership of this profile via a verification token or live screenshot.\n\n'
          'This is a stronger form of connection that boosts their TrustScore.',
      icon: Icons.verified_rounded,
    );
  }

  void _showLinkedInfo(BuildContext context) {
    InfoModal.show(
      context,
      title: 'What does "Linked" mean?',
      body:
          'This account was shared by the user.\n\n'
          'It is connected to their SilentID but not fully verified.\n\n'
          'Linked profiles show online presence but provide less trust boost.',
      icon: Icons.link_rounded,
    );
  }
}

/// Compact Connected Profiles Row - Section 52.6
///
/// Horizontal chip-style display for passport cards.
/// Shows icons with verified/linked indicators.
class CompactConnectedProfilesRow extends StatelessWidget {
  final List<PublicConnectedProfile> profiles;
  final int maxDisplay;
  final VoidCallback? onViewAll;

  const CompactConnectedProfilesRow({
    super.key,
    required this.profiles,
    this.maxDisplay = 5,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayProfiles = profiles.take(maxDisplay).toList();
    final remaining = profiles.length - maxDisplay;

    return Row(
      children: [
        // Profile chips
        ...displayProfiles.map((profile) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildCompactChip(profile),
            )),

        // "+N more" indicator
        if (remaining > 0)
          GestureDetector(
            onTap: onViewAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.neutralGray300.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '+$remaining',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.neutralGray700,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCompactChip(PublicConnectedProfile profile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: profile.isVerified
            ? AppTheme.successGreen.withValues(alpha: 0.1)
            : AppTheme.neutralGray300.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: profile.isVerified
              ? AppTheme.successGreen.withValues(alpha: 0.3)
              : AppTheme.neutralGray300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            profile.icon,
            size: 14,
            color: profile.brandColor,
          ),
          const SizedBox(width: 4),
          if (profile.isVerified)
            Icon(
              Icons.verified_rounded,
              size: 12,
              color: AppTheme.successGreen,
            ),
        ],
      ),
    );
  }
}

/// Connected Profiles Summary Card - Section 52.6
///
/// Shows count summary: "3 Verified • 2 Linked"
class ConnectedProfilesSummary extends StatelessWidget {
  final List<PublicConnectedProfile> profiles;

  const ConnectedProfilesSummary({
    super.key,
    required this.profiles,
  });

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return const SizedBox.shrink();
    }

    final verified = profiles.where((p) => p.isVerified).length;
    final linked = profiles.where((p) => !p.isVerified).length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.account_circle_rounded,
            size: 18,
            color: AppTheme.primaryPurple,
          ),
          const SizedBox(width: 8),
          if (verified > 0) ...[
            Icon(
              Icons.verified_rounded,
              size: 14,
              color: AppTheme.successGreen,
            ),
            const SizedBox(width: 4),
            Text(
              '$verified Verified',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.successGreen,
              ),
            ),
          ],
          if (verified > 0 && linked > 0) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '•',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.neutralGray300,
                ),
              ),
            ),
          ],
          if (linked > 0) ...[
            Icon(
              Icons.link_rounded,
              size: 14,
              color: AppTheme.neutralGray700,
            ),
            const SizedBox(width: 4),
            Text(
              '$linked Linked',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.neutralGray700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
