import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import 'info_modal.dart';
import 'public_connected_profiles.dart';

/// Connected Profiles Trust Contribution Widget - Section 52.7
///
/// Shows how connected profiles contribute to TrustScore.
/// Displays breakdown by Linked vs Verified profiles.
///
/// UI follows Section 53 design guidelines.
class ConnectedProfilesTrustContribution extends StatelessWidget {
  final List<PublicConnectedProfile> profiles;
  final bool showHeader;
  final bool expandable;

  const ConnectedProfilesTrustContribution({
    super.key,
    required this.profiles,
    this.showHeader = true,
    this.expandable = true,
  });

  /// Calculate trust points from connected profiles
  /// Per Section 52.7:
  /// - Linked profiles: small boost (5 points each, max 25)
  /// - Verified profiles: strong boost (15 points each, max 75)
  int get linkedPoints {
    final count = profiles.where((p) => !p.isVerified).length;
    return (count * 5).clamp(0, 25);
  }

  int get verifiedPoints {
    final count = profiles.where((p) => p.isVerified).length;
    return (count * 15).clamp(0, 75);
  }

  int get totalPoints => linkedPoints + verifiedPoints;
  int get maxPoints => 100; // Max contribution from connected profiles

  @override
  Widget build(BuildContext context) {
    if (profiles.isEmpty) {
      return _buildEmptyState(context);
    }

    final linkedCount = profiles.where((p) => !p.isVerified).length;
    final verifiedCount = profiles.where((p) => p.isVerified).length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
      ),
      child: expandable
          ? _buildExpandableContent(context, linkedCount, verifiedCount)
          : _buildStaticContent(context, linkedCount, verifiedCount),
    );
  }

  Widget _buildExpandableContent(
    BuildContext context,
    int linkedCount,
    int verifiedCount,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.link_rounded,
            color: AppTheme.primaryPurple,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Text(
              'Connected Profiles',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray900,
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => _showInfoModal(context),
              child: Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: AppTheme.primaryPurple,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '+$totalPoints/$maxPoints points',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryPurple,
            ),
          ),
        ),
        children: [
          _buildContributionDetails(context, linkedCount, verifiedCount),
        ],
      ),
    );
  }

  Widget _buildStaticContent(
    BuildContext context,
    int linkedCount,
    int verifiedCount,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader) ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.link_rounded,
                    color: AppTheme.primaryPurple,
                    size: 20,
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
                            'Connected Profiles',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.neutralGray900,
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () => _showInfoModal(context),
                            child: Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: AppTheme.primaryPurple,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '+$totalPoints/$maxPoints points',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          _buildContributionDetails(context, linkedCount, verifiedCount),
        ],
      ),
    );
  }

  Widget _buildContributionDetails(
    BuildContext context,
    int linkedCount,
    int verifiedCount,
  ) {
    return Column(
      children: [
        // Progress bar
        _buildProgressBar(),
        const SizedBox(height: 16),

        // Verified profiles contribution
        if (verifiedCount > 0)
          _buildContributionRow(
            icon: Icons.verified_rounded,
            iconColor: AppTheme.successGreen,
            label: '$verifiedCount Verified Profile${verifiedCount > 1 ? 's' : ''}',
            points: verifiedPoints,
            description: 'Strong trust boost',
          ),

        if (verifiedCount > 0 && linkedCount > 0) const SizedBox(height: 12),

        // Linked profiles contribution
        if (linkedCount > 0)
          _buildContributionRow(
            icon: Icons.link_rounded,
            iconColor: AppTheme.warningAmber,
            label: '$linkedCount Linked Profile${linkedCount > 1 ? 's' : ''}',
            points: linkedPoints,
            description: 'Shows online presence',
          ),

        const SizedBox(height: 16),

        // Tip to improve
        if (linkedCount > 0 && verifiedCount < 5)
          _buildImprovementTip(context, linkedCount),
      ],
    );
  }

  Widget _buildProgressBar() {
    final progress = totalPoints / maxPoints;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Profile Trust Contribution',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.neutralGray700,
              ),
            ),
            Text(
              '$totalPoints/$maxPoints',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.neutralGray300.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 0.75
                  ? AppTheme.successGreen
                  : progress >= 0.5
                      ? AppTheme.primaryPurple
                      : AppTheme.warningAmber,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildContributionRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required int points,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.neutralGray900,
                ),
              ),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.neutralGray700,
                ),
              ),
            ],
          ),
        ),
        Text(
          '+$points',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.successGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildImprovementTip(BuildContext context, int linkedCount) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.primaryPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: 18,
            color: AppTheme.primaryPurple,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Upgrade $linkedCount linked profile${linkedCount > 1 ? 's' : ''} to Verified for +${linkedCount * 10} more points',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.neutralGray700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.neutralGray300.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.link_off_rounded,
              color: AppTheme.neutralGray700,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No Connected Profiles',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralGray900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Connect your profiles to boost your TrustScore',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppTheme.neutralGray300,
          ),
        ],
      ),
    );
  }

  void _showInfoModal(BuildContext context) {
    InfoModal.show(
      context,
      title: 'How profiles help your trust',
      body:
          'Connecting and verifying your profiles helps SilentID confirm your reputation and identity.\n\n'
          '• Linked profiles show your online presence (+5 pts each, max 25)\n\n'
          '• Verified profiles prove ownership (+15 pts each, max 75)\n\n'
          'Total max contribution: 100 points to your TrustScore.',
      icon: Icons.link_rounded,
    );
  }
}

/// Compact Trust Points Badge - Section 52.7
///
/// Shows just the points earned from connected profiles.
/// Use in compact spaces like cards or lists.
class ConnectedProfilesTrustBadge extends StatelessWidget {
  final int linkedCount;
  final int verifiedCount;

  const ConnectedProfilesTrustBadge({
    super.key,
    required this.linkedCount,
    required this.verifiedCount,
  });

  int get linkedPoints => (linkedCount * 5).clamp(0, 25);
  int get verifiedPoints => (verifiedCount * 15).clamp(0, 75);
  int get totalPoints => linkedPoints + verifiedPoints;

  @override
  Widget build(BuildContext context) {
    if (linkedCount == 0 && verifiedCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.successGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.successGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.link_rounded,
            size: 14,
            color: AppTheme.successGreen,
          ),
          const SizedBox(width: 4),
          Text(
            '+$totalPoints pts',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.successGreen,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mini Profile Trust Summary - Section 52.7
///
/// Shows counts and points in one line for tight spaces.
class ProfileTrustSummaryLine extends StatelessWidget {
  final int linkedCount;
  final int verifiedCount;

  const ProfileTrustSummaryLine({
    super.key,
    required this.linkedCount,
    required this.verifiedCount,
  });

  @override
  Widget build(BuildContext context) {
    final total = linkedCount + verifiedCount;
    if (total == 0) return const SizedBox.shrink();

    final linkedPoints = (linkedCount * 5).clamp(0, 25);
    final verifiedPoints = (verifiedCount * 15).clamp(0, 75);
    final totalPoints = linkedPoints + verifiedPoints;

    return Row(
      children: [
        if (verifiedCount > 0) ...[
          Icon(
            Icons.verified_rounded,
            size: 14,
            color: AppTheme.successGreen,
          ),
          const SizedBox(width: 4),
          Text(
            '$verifiedCount',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.successGreen,
            ),
          ),
        ],
        if (verifiedCount > 0 && linkedCount > 0) const SizedBox(width: 8),
        if (linkedCount > 0) ...[
          Icon(
            Icons.link_rounded,
            size: 14,
            color: AppTheme.warningAmber,
          ),
          const SizedBox(width: 4),
          Text(
            '$linkedCount',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.warningAmber,
            ),
          ),
        ],
        const SizedBox(width: 8),
        Container(
          width: 1,
          height: 12,
          color: AppTheme.neutralGray300,
        ),
        const SizedBox(width: 8),
        Text(
          '+$totalPoints pts',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryPurple,
          ),
        ),
      ],
    );
  }
}
