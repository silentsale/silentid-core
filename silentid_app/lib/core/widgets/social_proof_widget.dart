import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Social Proof Widget (Section 50.3.3)
///
/// Displays trust-building social proof:
/// - Total verified users count ("1,200+ users have verified their profiles")
/// - Recently verified list
/// - Mini success stories ("Anna improved her TrustScore from 380 → 720 in 3 weeks")
class SocialProofWidget extends StatelessWidget {
  final int verifiedUsersCount;
  final List<RecentVerification>? recentVerifications;
  final List<SuccessStory>? successStories;
  final VoidCallback? onSeeAll;

  const SocialProofWidget({
    super.key,
    required this.verifiedUsersCount,
    this.recentVerifications,
    this.successStories,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with stats
          _buildHeader(),

          // Recently verified section
          if (recentVerifications != null && recentVerifications!.isNotEmpty)
            _buildRecentlyVerified(),

          // Success stories
          if (successStories != null && successStories!.isNotEmpty)
            _buildSuccessStories(),

          // See all button
          if (onSeeAll != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: TextButton(
                  onPressed: onSeeAll,
                  child: Text(
                    'See Community Stats',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final formattedCount = _formatCount(verifiedUsersCount);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.softLilac.withValues(alpha: 0.8),
            AppTheme.softLilac.withValues(alpha: 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.groups,
              color: AppTheme.primaryPurple,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$formattedCount+',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.verified,
                      color: AppTheme.successGreen,
                      size: 20,
                    ),
                  ],
                ),
                Text(
                  'users have verified their profiles',
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
    );
  }

  Widget _buildRecentlyVerified() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.successGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Recently Verified',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Stacked avatars with names
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recentVerifications!.length,
              itemBuilder: (context, index) {
                final verification = recentVerifications![index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildRecentVerificationChip(verification),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentVerificationChip(RecentVerification verification) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.successGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppTheme.successGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                verification.initials,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                verification.name,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepBlack,
                ),
              ),
              Text(
                verification.timeAgo,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppTheme.neutralGray700,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.verified,
            color: AppTheme.successGreen,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStories() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: AppTheme.warningAmber,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Success Stories',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Success story cards
          ...successStories!.map((story) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildSuccessStoryCard(story),
              )),
        ],
      ),
    );
  }

  Widget _buildSuccessStoryCard(SuccessStory story) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.softLilac.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                story.initials,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.deepBlack,
                    ),
                    children: [
                      TextSpan(
                        text: story.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: ' improved from '),
                      TextSpan(
                        text: '${story.oldScore}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.warningAmber,
                        ),
                      ),
                      const TextSpan(text: ' → '),
                      TextSpan(
                        text: '${story.newScore}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.successGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'in ${story.duration}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.trending_up,
            color: AppTheme.successGreen,
            size: 24,
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(count >= 10000 ? 0 : 1)}K';
    }
    return count.toString();
  }
}

/// Model for recent verification
class RecentVerification {
  final String name;
  final String initials;
  final String timeAgo;

  const RecentVerification({
    required this.name,
    required this.initials,
    required this.timeAgo,
  });
}

/// Model for success story
class SuccessStory {
  final String name;
  final String initials;
  final int oldScore;
  final int newScore;
  final String duration;

  const SuccessStory({
    required this.name,
    required this.initials,
    required this.oldScore,
    required this.newScore,
    required this.duration,
  });
}

/// Sample data for demo purposes
class SocialProofSampleData {
  static const recentVerifications = [
    RecentVerification(name: 'Sarah M.', initials: 'SM', timeAgo: '2 min ago'),
    RecentVerification(name: 'James K.', initials: 'JK', timeAgo: '5 min ago'),
    RecentVerification(name: 'Emma T.', initials: 'ET', timeAgo: '12 min ago'),
    RecentVerification(name: 'David L.', initials: 'DL', timeAgo: '18 min ago'),
  ];

  static const successStories = [
    SuccessStory(
      name: 'Anna',
      initials: 'A',
      oldScore: 380,
      newScore: 720,
      duration: '3 weeks',
    ),
    SuccessStory(
      name: 'Mike',
      initials: 'M',
      oldScore: 210,
      newScore: 650,
      duration: '6 weeks',
    ),
  ];
}
