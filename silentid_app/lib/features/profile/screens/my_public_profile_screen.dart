import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/trust_score_star_rating.dart';
import '../../../core/utils/haptics.dart';
import '../widgets/share_profile_sheet.dart';
import '../../../models/public_profile.dart';
import '../../../services/public_profile_service.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';

/// My Public Profile Screen - SuperDesign Level 7+
/// Trust Passport with gamification and animations
class MyPublicProfileScreen extends StatefulWidget {
  const MyPublicProfileScreen({super.key});

  @override
  State<MyPublicProfileScreen> createState() => _MyPublicProfileScreenState();
}

class _MyPublicProfileScreenState extends State<MyPublicProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _scoreController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scoreAnimation;

  bool _isLoading = true;
  PublicProfile? _profile;
  late final PublicProfileService _publicProfileService;
  final _storage = StorageService();

  // Demo data
  final int _userLevel = 4;
  final int _shareCount = 12;
  final int _viewCount = 156;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _publicProfileService = PublicProfileService(ApiService());
    _loadProfile();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scoreAnimation = CurvedAnimation(
      parent: _scoreController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    try {
      final username = await _storage.getUsername();
      if (username == null || username.isEmpty) {
        throw Exception('Username not found. Please complete your profile setup.');
      }

      final profile = await _publicProfileService.getPublicProfile(username);

      setState(() {
        _profile = profile;
        _isLoading = false;
      });
      _fadeController.forward();
      _scoreController.forward();
    } catch (e) {
      // Use demo data when API is unavailable
      if (mounted) {
        setState(() {
          _profile = PublicProfile(
            userId: 'demo-user',
            username: '@demouser',
            displayName: 'Demo User',
            trustScore: 752,
            trustScoreLabel: 'Very High',
            identityVerified: true,
            accountAge: '3 months',
            verifiedPlatforms: ['Vinted', 'eBay'],
            verifiedTransactionCount: 47,
            badges: [
              'Identity Verified',
              '25+ verified transactions',
              'Excellent behaviour',
            ],
            createdAt: DateTime.now().subtract(const Duration(days: 90)),
            platformRatings: [
              PlatformRating(
                platform: 'Vinted',
                rating: 4.9,
                reviewCount: 28,
                displayRating: '4.9 ★',
                lastUpdated: DateTime.now().subtract(const Duration(days: 2)),
                isLevel3Verified: true,
              ),
              PlatformRating(
                platform: 'eBay',
                rating: 99.2,
                reviewCount: 19,
                displayRating: '99.2% positive',
                lastUpdated: DateTime.now().subtract(const Duration(days: 5)),
                isLevel3Verified: true,
              ),
            ],
            trustScoreVisible: true,
            connectedProfiles: [],
          );
          _isLoading = false;
        });
        _fadeController.forward();
        _scoreController.forward();
      }
    }
  }

  void _showShareSheet() {
    if (_profile == null) return;
    AppHaptics.medium();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ShareProfileSheet(
        username: _profile!.cleanUsername,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureWhite,
      body: SafeArea(
        child: _isLoading
            ? _buildLoadingState()
            : _profile == null
                ? _buildErrorState()
                : FadeTransition(
                opacity: _fadeAnimation,
                child: RefreshIndicator(
                  onRefresh: _loadProfile,
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
                          'Trust Passport',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.neutralGray900,
                          ),
                        ),
                        centerTitle: false,
                        actions: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.softLilac,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.qr_code, color: AppTheme.primaryPurple, size: 22),
                              onPressed: () {
                                AppHaptics.light();
                                // Show QR code
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryPurple,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.share, color: Colors.white, size: 20),
                              onPressed: _showShareSheet,
                            ),
                          ),
                        ],
                      ),

                      // Content
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),

                              // Preview Banner
                              _buildPreviewBanner(),
                              const SizedBox(height: 24),

                              // Profile Header with Level Badge
                              _buildProfileHeader(),
                              const SizedBox(height: 24),

                              // TrustScore Hero
                              if (_profile!.shouldShowTrustScore) ...[
                                _buildTrustScoreHero(),
                                const SizedBox(height: 24),
                              ],

                              // Stats Row
                              _buildStatsRow(),
                              const SizedBox(height: 24),

                              // Achievement Badges
                              _buildAchievementBadges(),
                              const SizedBox(height: 24),

                              // Platform Ratings
                              if (_profile!.hasPlatformRatings) ...[
                                _buildPlatformRatingsSection(),
                                const SizedBox(height: 24),
                              ],

                              // Public Metrics
                              _buildPublicMetrics(),
                              const SizedBox(height: 24),

                              // Share Rewards Card
                              _buildShareRewardsCard(),
                              const SizedBox(height: 24),

                              // Privacy Notice
                              _buildPrivacyNotice(),
                              const SizedBox(height: 24),

                              // Share Button
                              PrimaryButton(
                                text: 'Share Profile',
                                onPressed: _showShareSheet,
                                icon: Icons.share,
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading your passport...',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.neutralGray700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.neutralGray500,
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to load profile',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Retry',
              onPressed: _loadProfile,
              icon: Icons.refresh,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.softLilac,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryPurple.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.visibility_outlined, color: AppTheme.primaryPurple, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This is how others see your profile',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray900,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.push('/settings/privacy'),
            child: Text(
              'Edit',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    if (_profile == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Avatar with Level Badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryPurple,
                          AppTheme.primaryPurple.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _profile!.displayName[0].toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Level Badge
            Positioned(
              bottom: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.warningAmber,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.warningAmber.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 12),
                    const SizedBox(width: 2),
                    Text(
                      'LVL $_userLevel',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Text(
          _profile!.displayName,
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.neutralGray900,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          _profile!.username,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppTheme.primaryPurple,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTrustScoreHero() {
    if (_profile == null || !_profile!.shouldShowTrustScore) {
      return const SizedBox.shrink();
    }

    final score = _profile!.trustScore ?? 0;
    final progress = score / 1000;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryPurple, const Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Verified TrustScore',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Animated Score
          AnimatedBuilder(
            animation: _scoreAnimation,
            builder: (context, child) {
              final animatedScore = (score * _scoreAnimation.value).toInt();
              return Text(
                '$animatedScore',
                style: GoogleFonts.inter(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),

          Text(
            _profile!.trustScoreLabel ?? 'Building Trust',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),

          const SizedBox(height: 16),

          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: AnimatedBuilder(
              animation: _scoreAnimation,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress * _scoreAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Star Rating
          TrustScoreStarRating.large(
            trustScore: score,
            showNumericScore: false,
            colorOverride: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.visibility,
            value: '$_viewCount',
            label: 'Profile Views',
            color: AppTheme.primaryPurple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.share,
            value: '$_shareCount',
            label: 'Times Shared',
            color: AppTheme.successGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
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

  Widget _buildAchievementBadges() {
    if (_profile == null || _profile!.badges.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Achievements',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray900,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.softLilac,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_profile!.badges.length} earned',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _profile!.badges.length,
            itemBuilder: (context, index) {
              final badge = _profile!.badges[index];
              return Padding(
                padding: EdgeInsets.only(right: index < _profile!.badges.length - 1 ? 12 : 0),
                child: _buildBadgeCard(badge, index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeCard(String badgeText, int index) {
    IconData icon;
    Color color;

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

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 80,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  badgeText.split(' ').first,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralGray900,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlatformRatingsSection() {
    if (_profile == null || !_profile!.hasPlatformRatings) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Marketplace Ratings',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray900,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: AppTheme.successGreen, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    'Verified',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.successGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.pureWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.neutralGray300),
          ),
          child: Column(
            children: _profile!.level3VerifiedRatings
                .asMap()
                .entries
                .map((entry) {
              final rating = entry.value;
              final isLast =
                  entry.key == _profile!.level3VerifiedRatings.length - 1;
              return Column(
                children: [
                  _buildPlatformRatingRow(rating),
                  if (!isLast)
                    Divider(height: 24, color: AppTheme.neutralGray300),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformRatingRow(PlatformRating rating) {
    return Row(
      children: [
        Text(
          rating.platformIcon,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rating.platform,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.neutralGray900,
                ),
              ),
              Text(
                '${rating.reviewCount} reviews',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.neutralGray700,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.star, color: AppTheme.warningAmber, size: 14),
              const SizedBox(width: 4),
              Text(
                rating.displayRating,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPublicMetrics() {
    if (_profile == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Public Metrics',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.pureWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.neutralGray300),
          ),
          child: Column(
            children: [
              _buildMetricRow(
                icon: Icons.receipt_long,
                label: 'Verified Transactions',
                value: _profile!.verifiedTransactionCount.toString(),
              ),
              const Divider(height: 20),
              _buildMetricRow(
                icon: Icons.link,
                label: 'Platforms Verified',
                value: _profile!.verifiedPlatforms.isEmpty
                    ? 'None yet'
                    : '${_profile!.verifiedPlatforms.length}',
              ),
              const Divider(height: 20),
              _buildMetricRow(
                icon: Icons.calendar_today,
                label: 'Account Age',
                value: _profile!.accountAge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.softLilac,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryPurple, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.neutralGray700,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
      ],
    );
  }

  Widget _buildShareRewardsCard() {
    return GestureDetector(
      onTap: _showShareSheet,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.warningAmber,
              AppTheme.warningAmber.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.warningAmber.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.card_giftcard, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Earn +50 TrustScore',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Invite friends and boost your score!',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyNotice() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.neutralGray300.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, color: AppTheme.neutralGray700, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your full name, email, and address are never shown publicly',
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
}
