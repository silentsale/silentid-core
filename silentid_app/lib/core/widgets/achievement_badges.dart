import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Achievement Badges System (Section 50.5.2)
///
/// Retention badges displayed on profile:
/// - Verified Identity
/// - Connected External Profile
/// - First Mutual Verification
/// - Trust Milestone (750+)
/// - Multi-platform Verified
/// - Community badges (50.6.3)
class AchievementBadge {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool isEarned;
  final DateTime? earnedAt;
  final BadgeCategory category;
  final int? requiredScore; // For milestone badges

  const AchievementBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.isEarned = false,
    this.earnedAt,
    this.category = BadgeCategory.achievement,
    this.requiredScore,
  });

  /// Create a copy with earned status
  AchievementBadge copyWithEarned({DateTime? earnedAt}) {
    return AchievementBadge(
      id: id,
      name: name,
      description: description,
      icon: icon,
      color: color,
      isEarned: true,
      earnedAt: earnedAt ?? DateTime.now(),
      category: category,
      requiredScore: requiredScore,
    );
  }
}

enum BadgeCategory {
  achievement,
  milestone,
  community,
}

/// Predefined badges per Section 50.5.2 and 50.6.3
class BadgeDefinitions {
  // Achievement badges (50.5.2)
  static const verifiedIdentity = AchievementBadge(
    id: 'verified_identity',
    name: 'Verified Identity',
    description: 'Completed identity verification via Stripe',
    icon: Icons.verified_user,
    color: AppTheme.primaryPurple,
    category: BadgeCategory.achievement,
  );

  static const connectedProfile = AchievementBadge(
    id: 'connected_profile',
    name: 'Profile Pioneer',
    description: 'Connected first external marketplace profile',
    icon: Icons.link,
    color: AppTheme.warningAmber,
    category: BadgeCategory.achievement,
  );

  static const firstVerification = AchievementBadge(
    id: 'first_verification',
    name: 'Trust Builder',
    description: 'Completed first mutual verification',
    icon: Icons.handshake,
    color: AppTheme.successGreen,
    category: BadgeCategory.achievement,
  );

  static const multiPlatform = AchievementBadge(
    id: 'multi_platform',
    name: 'Multi-Platform Star',
    description: 'Connected profiles on 3+ platforms',
    icon: Icons.stars,
    color: Color(0xFFFF9500),
    category: BadgeCategory.achievement,
  );

  // Milestone badges (50.5.2)
  static const trustMilestone500 = AchievementBadge(
    id: 'trust_500',
    name: 'Rising Trust',
    description: 'Reached TrustScore of 500',
    icon: Icons.trending_up,
    color: Color(0xFF3B82F6),
    category: BadgeCategory.milestone,
    requiredScore: 500,
  );

  static const trustMilestone750 = AchievementBadge(
    id: 'trust_750',
    name: 'High Trust',
    description: 'Reached TrustScore of 750',
    icon: Icons.emoji_events,
    color: Color(0xFFFFD700),
    category: BadgeCategory.milestone,
    requiredScore: 750,
  );

  static const trustMilestone900 = AchievementBadge(
    id: 'trust_900',
    name: 'Exceptional Trust',
    description: 'Reached TrustScore of 900',
    icon: Icons.military_tech,
    color: Color(0xFFC0C0C0),
    category: BadgeCategory.milestone,
    requiredScore: 900,
  );

  // Community badges (50.6.3)
  static const trustedCommunityMember = AchievementBadge(
    id: 'trusted_community',
    name: 'Trusted Community Member',
    description: 'Active member with 10+ mutual verifications',
    icon: Icons.groups,
    color: AppTheme.primaryPurple,
    category: BadgeCategory.community,
  );

  static const topVerifier = AchievementBadge(
    id: 'top_verifier',
    name: 'Top Verifier',
    description: 'Top 10% in mutual verifications this month',
    icon: Icons.workspace_premium,
    color: Color(0xFFFFD700),
    category: BadgeCategory.community,
  );

  static const networkLeader = AchievementBadge(
    id: 'network_leader',
    name: 'Network Leader',
    description: 'Most verified in your network',
    icon: Icons.hub,
    color: Color(0xFF9333EA),
    category: BadgeCategory.community,
  );

  static const referralChampion = AchievementBadge(
    id: 'referral_champion',
    name: 'Referral Champion',
    description: 'Successfully referred 5+ friends',
    icon: Icons.share,
    color: AppTheme.successGreen,
    category: BadgeCategory.community,
  );

  /// Get all badge definitions
  static List<AchievementBadge> get all => [
        verifiedIdentity,
        connectedProfile,
        firstVerification,
        multiPlatform,
        trustMilestone500,
        trustMilestone750,
        trustMilestone900,
        trustedCommunityMember,
        topVerifier,
        networkLeader,
        referralChampion,
      ];
}

/// Widget to display a single badge
class BadgeWidget extends StatelessWidget {
  final AchievementBadge badge;
  final double size;
  final bool showLabel;
  final VoidCallback? onTap;

  const BadgeWidget({
    super.key,
    required this.badge,
    this.size = 64,
    this.showLabel = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _showBadgeDetails(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: badge.isEarned
                  ? badge.color.withValues(alpha: 0.15)
                  : AppTheme.neutralGray300.withValues(alpha: 0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: badge.isEarned
                    ? badge.color
                    : AppTheme.neutralGray300,
                width: 2,
              ),
              boxShadow: badge.isEarned
                  ? [
                      BoxShadow(
                        color: badge.color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              badge.icon,
              color: badge.isEarned
                  ? badge.color
                  : AppTheme.neutralGray700.withValues(alpha: 0.5),
              size: size * 0.45,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: size + 16,
              child: Text(
                badge.name,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: badge.isEarned
                      ? AppTheme.deepBlack
                      : AppTheme.neutralGray700,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showBadgeDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BadgeDetailSheet(badge: badge),
    );
  }
}

/// Badge detail bottom sheet
class BadgeDetailSheet extends StatelessWidget {
  final AchievementBadge badge;

  const BadgeDetailSheet({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.neutralGray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Badge icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: badge.isEarned
                  ? badge.color.withValues(alpha: 0.15)
                  : AppTheme.neutralGray300.withValues(alpha: 0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: badge.isEarned ? badge.color : AppTheme.neutralGray300,
                width: 3,
              ),
            ),
            child: Icon(
              badge.icon,
              color: badge.isEarned ? badge.color : AppTheme.neutralGray700,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),

          // Badge name
          Text(
            badge.name,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.deepBlack,
            ),
          ),
          const SizedBox(height: 8),

          // Badge description
          Text(
            badge.description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.neutralGray700,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: badge.isEarned
                  ? AppTheme.successGreen.withValues(alpha: 0.1)
                  : AppTheme.neutralGray300.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  badge.isEarned ? Icons.check_circle : Icons.lock_outline,
                  color: badge.isEarned
                      ? AppTheme.successGreen
                      : AppTheme.neutralGray700,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  badge.isEarned
                      ? 'Earned ${_formatDate(badge.earnedAt)}'
                      : 'Not yet earned',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: badge.isEarned
                        ? AppTheme.successGreen
                        : AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Widget to display a grid of badges
class BadgeGrid extends StatelessWidget {
  final List<AchievementBadge> badges;
  final int crossAxisCount;
  final bool showLocked;
  final String? title;

  const BadgeGrid({
    super.key,
    required this.badges,
    this.crossAxisCount = 4,
    this.showLocked = true,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final displayBadges = showLocked
        ? badges
        : badges.where((b) => b.isEarned).toList();

    if (displayBadges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              title!,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBlack,
              ),
            ),
          ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.8,
            crossAxisSpacing: 8,
            mainAxisSpacing: 16,
          ),
          itemCount: displayBadges.length,
          itemBuilder: (context, index) {
            return BadgeWidget(
              badge: displayBadges[index],
              size: 56,
            );
          },
        ),
      ],
    );
  }
}

/// Compact badge row for profile display
class BadgeRow extends StatelessWidget {
  final List<AchievementBadge> badges;
  final int maxVisible;
  final VoidCallback? onSeeAll;

  const BadgeRow({
    super.key,
    required this.badges,
    this.maxVisible = 5,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final earnedBadges = badges.where((b) => b.isEarned).toList();
    final visibleBadges = earnedBadges.take(maxVisible).toList();
    final hiddenCount = earnedBadges.length - visibleBadges.length;

    if (earnedBadges.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        ...visibleBadges.map((badge) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: BadgeWidget(
                badge: badge,
                size: 40,
                showLabel: false,
              ),
            )),
        if (hiddenCount > 0)
          GestureDetector(
            onTap: onSeeAll,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.neutralGray300.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '+$hiddenCount',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
