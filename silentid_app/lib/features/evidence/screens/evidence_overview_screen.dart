import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/info_point_helper.dart';
import '../../../core/widgets/gamification/gamification.dart';
import '../../../core/data/info_point_data.dart';
import '../../../core/utils/haptics.dart';
import '../../../services/evidence_api_service.dart';

class EvidenceOverviewScreen extends StatefulWidget {
  const EvidenceOverviewScreen({super.key});

  @override
  State<EvidenceOverviewScreen> createState() => _EvidenceOverviewScreenState();
}

class _EvidenceOverviewScreenState extends State<EvidenceOverviewScreen>
    with SingleTickerProviderStateMixin {
  final _evidenceApi = EvidenceApiService();

  bool _isLoading = true;
  int _receiptsCount = 0;
  int _screenshotsCount = 0;
  int _profileLinksCount = 0;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _loadEvidenceCounts();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadEvidenceCounts() async {
    setState(() => _isLoading = true);
    try {
      final summary = await _evidenceApi.getEvidenceSummary();
      setState(() {
        _receiptsCount = summary.receiptsCount;
        _screenshotsCount = summary.screenshotsCount;
        _profileLinksCount = summary.profileLinksCount;
        _isLoading = false;
      });
      _fadeController.forward(from: 0.0);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  int get _totalEvidenceScore {
    // Each receipt = 5 points, screenshot = 3 points, profile link = 10 points (max 400)
    final score = (_receiptsCount * 5) + (_screenshotsCount * 3) + (_profileLinksCount * 10);
    return score > 400 ? 400 : score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Evidence Vault',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppTheme.deepBlack,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadEvidenceCounts,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Level 7 Gamification: Evidence Score Hero
                  _buildEvidenceScoreHero(),
                  const SizedBox(height: AppSpacing.lg),

                  // Intro text
                  Text(
                    'Build your trust profile by adding evidence of your verified transactions and marketplace activity.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.neutralGray700,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Level 7 Gamification: Evidence Cards with Progress
                  _buildGamifiedEvidenceCard(
                    icon: Icons.receipt_long,
                    iconColor: AppTheme.primaryPurple,
                    title: 'Email Receipts',
                    subtitle: 'Connect your inbox to automatically verify transactions',
                    count: _isLoading ? 0 : _receiptsCount,
                    maxCount: 20,
                    rewardPerItem: 5,
                    onTap: () {
                      AppHaptics.light();
                      context.push('/evidence/receipts');
                    },
                    infoPoint: InfoPoints.emailScanning,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _buildGamifiedEvidenceCard(
                    icon: Icons.image,
                    iconColor: AppTheme.successGreen,
                    title: 'Screenshots',
                    subtitle: 'Upload screenshots of your marketplace profiles and ratings',
                    count: _isLoading ? 0 : _screenshotsCount,
                    maxCount: 30,
                    rewardPerItem: 3,
                    onTap: () {
                      AppHaptics.light();
                      context.push('/evidence/screenshots');
                    },
                    infoPoint: InfoPoints.screenshotIntegrity,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _buildGamifiedEvidenceCard(
                    icon: Icons.link,
                    iconColor: const Color(0xFF3B82F6),
                    title: 'Public Profiles',
                    subtitle: 'Link your verified marketplace accounts (Vinted, eBay, etc.)',
                    count: _isLoading ? 0 : _profileLinksCount,
                    maxCount: 10,
                    rewardPerItem: 10,
                    onTap: () {
                      AppHaptics.light();
                      context.push('/evidence/profile-links');
                    },
                    infoPoint: InfoPoints.evidenceVault,
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Level 7: Achievement hint
                  if (_totalEvidenceScore >= 100)
                    _buildAchievementUnlocked(),

                  const SizedBox(height: AppSpacing.lg),

                  // Info box
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
                            'All evidence is verified and contributes to your TrustScore. We never share your private data.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppTheme.neutralGray900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Level 7 Gamification: Evidence Score Hero Card
  Widget _buildEvidenceScoreHero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryPurple,
            AppTheme.darkModePurple,
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Animated progress ring
          AnimatedProgressRing(
            progress: _totalEvidenceScore / 400,
            size: 80,
            strokeWidth: 8,
            progressColor: Colors.white,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: _totalEvidenceScore),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Text(
                      '$value',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                Text(
                  '/ 400',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Evidence Score',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Contributes up to 400 points to your TrustScore',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 8),
                // Progress milestones
                Row(
                  children: [
                    _buildMilestoneChip(100, _totalEvidenceScore >= 100),
                    const SizedBox(width: 6),
                    _buildMilestoneChip(200, _totalEvidenceScore >= 200),
                    const SizedBox(width: 6),
                    _buildMilestoneChip(300, _totalEvidenceScore >= 300),
                    const SizedBox(width: 6),
                    _buildMilestoneChip(400, _totalEvidenceScore >= 400),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestoneChip(int milestone, bool achieved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: achieved
            ? Colors.white.withValues(alpha: 0.25)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (achieved)
            Icon(
              Icons.check,
              size: 10,
              color: Colors.white,
            ),
          Text(
            '$milestone',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: achieved ? FontWeight.w600 : FontWeight.w400,
              color: Colors.white.withValues(alpha: achieved ? 1.0 : 0.6),
            ),
          ),
        ],
      ),
    );
  }

  // Level 7 Gamification: Evidence Card with Progress Bar
  Widget _buildGamifiedEvidenceCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required int count,
    required int maxCount,
    required int rewardPerItem,
    required VoidCallback onTap,
    InfoPointData? infoPoint,
  }) {
    final progress = (count / maxCount).clamp(0.0, 1.0);
    final earnedPoints = count * rewardPerItem;
    final maxPoints = maxCount * rewardPerItem;

    return InteractiveCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
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
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.deepBlack,
                          ),
                        ),
                        if (infoPoint != null) ...[
                          const SizedBox(width: 6),
                          InfoPointHelper(data: infoPoint),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.neutralGray700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Reward indicator
              if (count < maxCount)
                RewardIndicator(points: rewardPerItem, compact: true),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppTheme.neutralGray700,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Animated progress bar
          Row(
            children: [
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: progress),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: value,
                            backgroundColor: iconColor.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$count / $maxCount items · $earnedPoints / $maxPoints pts',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppTheme.neutralGray700,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Level 7: Achievement Badge
  Widget _buildAchievementUnlocked() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFD700).withValues(alpha: 0.15),
            const Color(0xFFFFA500).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Color(0xFFFFD700),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Evidence Collector',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralGray900,
                  ),
                ),
                Text(
                  'You\'ve earned 100+ evidence points!',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),
          LevelBadge(level: _totalEvidenceScore >= 200 ? 2 : 1),
        ],
      ),
    );
  }
}
