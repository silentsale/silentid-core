import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptics.dart';
import '../../../services/evidence_api_service.dart';

/// Evidence Overview Screen - SuperDesign Level 7+
/// Gamified evidence vault with XP system, achievements, daily challenges
class EvidenceOverviewScreen extends StatefulWidget {
  const EvidenceOverviewScreen({super.key});

  @override
  State<EvidenceOverviewScreen> createState() => _EvidenceOverviewScreenState();
}

class _EvidenceOverviewScreenState extends State<EvidenceOverviewScreen>
    with TickerProviderStateMixin {
  final _evidenceApi = EvidenceApiService();

  bool _isLoading = true;
  int _receiptsCount = 0;
  int _screenshotsCount = 0;
  int _profileLinksCount = 0;

  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;

  // Demo gamification data
  final int _currentXP = 302;
  final int _maxXP = 400;
  final int _dayStreak = 7;
  final int _dailyChallengeProgress = 1;
  final int _dailyChallengeTarget = 2;

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

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _loadEvidenceCounts();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
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
      _fadeController.forward(from: 0.0);
    }
  }

  int get _totalItems => _receiptsCount + _screenshotsCount + _profileLinksCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureWhite,
      floatingActionButton: _buildFAB(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadEvidenceCounts,
          color: AppTheme.primaryPurple,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: AppTheme.pureWhite,
                elevation: 0,
                pinned: true,
                title: Text(
                  'Evidence Vault',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralGray900,
                  ),
                ),
                centerTitle: false,
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.softLilac,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.info_outline, color: AppTheme.primaryPurple, size: 20),
                      onPressed: () => _showInfoBottomSheet(),
                    ),
                  ),
                ],
              ),

              // Content
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // XP Score Hero
                        _buildXPScoreHero(),
                        const SizedBox(height: 24),

                        // Achievement Badges Row
                        _buildAchievementBadgesSection(),
                        const SizedBox(height: 24),

                        // Stats Cards Row
                        _buildStatsCardsRow(),
                        const SizedBox(height: 24),

                        // Daily Challenge Card
                        _buildDailyChallengeCard(),
                        const SizedBox(height: 24),

                        // Evidence Categories
                        _buildEvidenceCategoriesSection(),
                        const SizedBox(height: 24),

                        // Recent Evidence
                        _buildRecentEvidenceSection(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildXPScoreHero() {
    final progress = _currentXP / _maxXP;

    return Center(
      child: Column(
        children: [
          // Animated Progress Ring
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background ring
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 12,
                    backgroundColor: AppTheme.softLilac,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.softLilac),
                  ),
                ),
                // Progress ring with animation
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: progress),
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return SizedBox(
                      width: 160,
                      height: 160,
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 12,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
                        strokeCap: StrokeCap.round,
                      ),
                    );
                  },
                ),
                // Center content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: _currentXP),
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Text(
                          '$value',
                          style: GoogleFonts.inter(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.neutralGray900,
                          ),
                        );
                      },
                    ),
                    Text(
                      '/ $_maxXP XP',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.neutralGray700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Progress Label
          Text(
            'Evidence Master',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.neutralGray900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_maxXP - _currentXP} XP to next level',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.neutralGray700,
            ),
          ),
          const SizedBox(height: 12),

          // Mini Progress Bar
          Container(
            width: 280,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.softLilac,
              borderRadius: BorderRadius.circular(4),
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: progress),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadgesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Achievements',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray900,
              ),
            ),
            TextButton(
              onPressed: () {
                AppHaptics.light();
                // Navigate to achievements
              },
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildAchievementBadge(
                icon: Icons.receipt_long,
                title: '5 Receipts',
                xp: 75,
                color: AppTheme.primaryPurple,
                isPulsing: true,
              ),
              const SizedBox(width: 12),
              _buildAchievementBadge(
                icon: Icons.image,
                title: 'First Screenshot',
                xp: 10,
                color: AppTheme.successGreen,
              ),
              const SizedBox(width: 12),
              _buildAchievementBadge(
                icon: Icons.person,
                title: 'Profile Pro',
                xp: 100,
                color: AppTheme.primaryPurple,
              ),
              const SizedBox(width: 12),
              _buildAchievementBadge(
                icon: Icons.verified,
                title: 'Verified',
                xp: 50,
                color: const Color(0xFF3B82F6),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementBadge({
    required IconData icon,
    required String title,
    required int xp,
    required Color color,
    bool isPulsing = false,
  }) {
    Widget badge = Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.softLilac,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.neutralGray900,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '+$xp XP',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.neutralGray700,
            ),
          ),
        ],
      ),
    );

    if (isPulsing) {
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: child,
          );
        },
        child: badge,
      );
    }

    return badge;
  }

  Widget _buildStatsCardsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            value: '$_totalItems',
            label: 'Total Items',
            color: AppTheme.primaryPurple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            value: '3',
            label: 'Types',
            color: AppTheme.primaryPurple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStreakCard(),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, animValue, child) {
              return Transform.scale(
                scale: animValue,
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 4),
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

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated fire icon
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: 0.8 + (_pulseController.value * 0.2),
                        child: Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                          size: 20,
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 4),
              Text(
                '$_dayStreak',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Day Streak',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.neutralGray700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyChallengeCard() {
    final progress = _dailyChallengeProgress / _dailyChallengeTarget;

    return GestureDetector(
      onTap: () {
        AppHaptics.light();
        context.push('/evidence/receipts');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryPurple, const Color(0xFF7C3AED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryPurple.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Challenge',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Expires in 8h 42m',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '+25 XP',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Add 2 receipts today',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$_dailyChallengeProgress/$_dailyChallengeTarget',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenceCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Evidence Categories',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        const SizedBox(height: 12),

        _buildEvidenceCategoryCard(
          icon: Icons.receipt_long,
          title: 'Receipts',
          count: _isLoading ? 0 : _receiptsCount,
          xpEarned: _receiptsCount * 15,
          xpPerItem: 15,
          onTap: () => context.push('/evidence/receipts'),
        ),
        const SizedBox(height: 12),

        _buildEvidenceCategoryCard(
          icon: Icons.image,
          title: 'Screenshots',
          count: _isLoading ? 0 : _screenshotsCount,
          xpEarned: _screenshotsCount * 10,
          xpPerItem: 10,
          onTap: () => context.push('/evidence/screenshots'),
        ),
        const SizedBox(height: 12),

        _buildEvidenceCategoryCard(
          icon: Icons.link,
          title: 'Profile Links',
          count: _isLoading ? 0 : _profileLinksCount,
          xpEarned: _profileLinksCount * 25,
          xpPerItem: 25,
          isVerified: _profileLinksCount > 0,
          onTap: () => context.push('/evidence/profile-links'),
        ),
      ],
    );
  }

  Widget _buildEvidenceCategoryCard({
    required IconData icon,
    required String title,
    required int count,
    required int xpEarned,
    required int xpPerItem,
    required VoidCallback onTap,
    bool isVerified = false,
  }) {
    return GestureDetector(
      onTap: () {
        AppHaptics.light();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.neutralGray300),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.softLilac,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppTheme.primaryPurple, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.neutralGray900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (isVerified) ...[
                            Icon(Icons.check_circle, color: AppTheme.successGreen, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '$count verified profiles',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.successGreen,
                              ),
                            ),
                          ] else
                            Text(
                              '$count items uploaded',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.neutralGray700,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '+$xpEarned',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryPurple,
                      ),
                    ),
                    Text(
                      'XP earned',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.neutralGray700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$xpPerItem XP per ${title.toLowerCase().substring(0, title.length - 1)}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                  ),
                ),
                Icon(Icons.chevron_right, color: AppTheme.neutralGray700, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentEvidenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Evidence',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray900,
              ),
            ),
            TextButton(
              onPressed: () {
                AppHaptics.light();
              },
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        _buildRecentEvidenceItem(
          icon: Icons.receipt_long,
          title: 'Vinted Receipt',
          subtitle: 'Added today at 2:34 PM',
          xp: 15,
        ),
        const SizedBox(height: 8),
        _buildRecentEvidenceItem(
          icon: Icons.link,
          title: 'Depop Profile Verified',
          subtitle: 'Added yesterday',
          xp: 25,
        ),
        const SizedBox(height: 8),
        _buildRecentEvidenceItem(
          icon: Icons.image,
          title: 'Chat Screenshot',
          subtitle: 'Added 2 days ago',
          xp: 10,
        ),
      ],
    );
  }

  Widget _buildRecentEvidenceItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required int xp,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.softLilac,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryPurple, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.neutralGray900,
                  ),
                ),
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
          Text(
            '+$xp XP',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.successGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        AppHaptics.medium();
        _showAddEvidenceSheet();
      },
      backgroundColor: AppTheme.primaryPurple,
      elevation: 4,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }

  void _showAddEvidenceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.pureWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.neutralGray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Add Evidence',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.neutralGray900,
                ),
              ),
              const SizedBox(height: 20),

              _buildAddEvidenceOption(
                icon: Icons.image,
                title: 'Upload Screenshot',
                subtitle: '+10 XP per screenshot',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/evidence/screenshots');
                },
              ),
              const SizedBox(height: 12),
              _buildAddEvidenceOption(
                icon: Icons.link,
                title: 'Link Profile',
                subtitle: '+25 XP per verified profile',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/profiles/connect');
                },
              ),
              const SizedBox(height: 12),
              _buildAddEvidenceOption(
                icon: Icons.email_outlined,
                title: 'Email Scanner',
                subtitle: 'Forward receipts to verify purchases',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/evidence/receipts/email-setup');
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddEvidenceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        AppHaptics.light();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.softLilac.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.neutralGray900,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.successGreen,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppTheme.primaryPurple),
          ],
        ),
      ),
    );
  }

  void _showInfoBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.pureWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.neutralGray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Icon(Icons.folder_open, size: 48, color: AppTheme.primaryPurple),
            const SizedBox(height: 16),
            Text(
              'Evidence Vault',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.neutralGray900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Build your trust profile by adding evidence of your verified transactions and marketplace activity. Each piece of evidence earns you XP and contributes to your TrustScore.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.softLilac,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.security, color: AppTheme.primaryPurple, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'All evidence is verified and your private data is never shared.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.neutralGray900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Got It',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.pureWhite,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
