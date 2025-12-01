import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/trust_score_star_rating.dart';
import '../widgets/share_profile_sheet.dart';
import '../../../models/public_profile.dart';
import '../../../services/public_profile_service.dart';
import '../../../services/api_service.dart';
import '../../../services/storage_service.dart';

/// My Public Profile Screen
/// Level 7 Gamification + Level 7 Interactivity
class MyPublicProfileScreen extends StatefulWidget {
  const MyPublicProfileScreen({super.key});

  @override
  State<MyPublicProfileScreen> createState() => _MyPublicProfileScreenState();
}

class _MyPublicProfileScreenState extends State<MyPublicProfileScreen>
    with SingleTickerProviderStateMixin {
  // Level 7: Animation controller
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  bool _isLoading = true;
  PublicProfile? _profile;
  late final PublicProfileService _publicProfileService;
  final _storage = StorageService();

  @override
  void initState() {
    super.initState();
    // Level 7: Initialize animations
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _publicProfileService = PublicProfileService(ApiService());
    _loadProfile();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user's username from storage
      final username = await _storage.getUsername();
      if (username == null || username.isEmpty) {
        throw Exception('Username not found. Please complete your profile setup.');
      }

      final profile = await _publicProfileService.getPublicProfile(username);

      setState(() {
        _profile = profile;
        _isLoading = false;
      });
      // Level 7: Start animation after data loads
      _animController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: $e')),
        );
      }
    }
  }

  void _showShareSheet() {
    if (_profile == null) return;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Public Profile'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FadeTransition(
              opacity: _fadeAnimation,
              child: RefreshIndicator(
                onRefresh: _loadProfile,
                child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Info Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.softLilac.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryPurple.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.primaryPurple,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This is how others see your profile',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.neutralGray900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Profile Header
                    _buildProfileHeader(),
                    const SizedBox(height: 32),

                    // Platform Ratings (Section 47 - Digital Trust Passport)
                    if (_profile!.hasPlatformRatings) ...[
                      _buildPlatformRatingsSection(),
                      const SizedBox(height: 32),
                    ],

                    // TrustScore Display (only if user allows)
                    if (_profile!.shouldShowTrustScore) ...[
                      _buildTrustScoreSection(),
                      const SizedBox(height: 32),
                    ] else ...[
                      _buildTrustScoreHiddenNotice(),
                      const SizedBox(height: 32),
                    ],

                    // Badges Section
                    _buildBadgesSection(),
                    const SizedBox(height: 32),

                    // Public Metrics
                    _buildPublicMetrics(),
                    const SizedBox(height: 32),

                    // Privacy Notice
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.neutralGray300.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            color: AppTheme.neutralGray700,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your full name, email, and address are never shown publicly',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.neutralGray700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Share Button
                    PrimaryButton(
                      text: 'Share Profile',
                      onPressed: _showShareSheet,
                      icon: Icons.share,
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildProfileHeader() {
    if (_profile == null) return const SizedBox.shrink();

    return Column(
      children: [
        // Avatar Placeholder
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryPurple,
                AppTheme.primaryPurple.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: Center(
            child: Text(
              _profile!.displayName[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          _profile!.displayName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.neutralGray900,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          _profile!.username,
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.primaryPurple,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
            const Text(
              'Marketplace Ratings',
              style: TextStyle(
                fontSize: 18,
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
              child: const Text(
                'Verified',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.successGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
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
                    const Divider(height: 24, color: AppTheme.neutralGray300),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ratings from Level 3 verified profiles only',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.neutralGray700,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildPlatformRatingRow(PlatformRating rating) {
    return Row(
      children: [
        // Platform icon
        Text(
          rating.platformIcon,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 12),
        // Platform name and review count
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rating.platform,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.neutralGray900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${rating.reviewCount} reviews',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.neutralGray700,
                ),
              ),
            ],
          ),
        ),
        // Rating display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            rating.displayRating,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryPurple,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrustScoreHiddenNotice() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.neutralGray300.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neutralGray300),
      ),
      child: Column(
        children: [
          Icon(
            Icons.visibility_off_outlined,
            color: AppTheme.neutralGray700,
            size: 32,
          ),
          const SizedBox(height: 12),
          const Text(
            'TrustScore Hidden',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.neutralGray900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your TrustScore is private. Enable visibility in Privacy Settings to show it on your public profile.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.neutralGray700,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              context.push('/settings/privacy');
            },
            child: const Text('Privacy Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustScoreSection() {
    if (_profile == null || !_profile!.shouldShowTrustScore) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryPurple,
            AppTheme.primaryPurple.withValues(alpha: 0.8),
          ],
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
          const Text(
            'TrustScore',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_profile!.trustScore ?? 0}',
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _profile!.trustScoreLabel ?? 'Hidden',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TrustScoreStarRating.large(
            trustScore: _profile!.trustScore ?? 0,
            showNumericScore: false,
            colorOverride: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection() {
    if (_profile == null || _profile!.badges.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Badges',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _profile!.badges.map((badge) => _buildBadge(badge)).toList(),
        ),
      ],
    );
  }

  Widget _buildBadge(String badgeText) {
    IconData icon;
    Color color;

    // Map badge text to icon and color (same logic as PublicProfileViewerScreen)
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
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            badgeText,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.neutralGray900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicMetrics() {
    if (_profile == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Public Metrics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.neutralGray300),
          ),
          child: Column(
            children: [
              _buildMetricRow(
                'Transaction Count',
                _profile!.verifiedTransactionCount.toString(),
              ),
              const Divider(height: 24),
              _buildMetricRow(
                'Platforms Verified',
                _profile!.verifiedPlatforms.isEmpty
                    ? 'None yet'
                    : _profile!.verifiedPlatforms.join(', '),
              ),
              const Divider(height: 24),
              _buildMetricRow(
                'Account Age',
                _profile!.accountAge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: AppTheme.neutralGray700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
      ],
    );
  }
}
