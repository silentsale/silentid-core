import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/info_modal.dart';
import '../../../core/utils/haptics.dart';
import '../../../services/profile_linking_service.dart';
import 'connected_profiles_screen.dart';

/// Connect Your Profiles Screen - Section 52.2
/// Main entry point for unified profile linking
/// Level 7: Gamification + Interactivity
class ConnectProfilesScreen extends StatefulWidget {
  const ConnectProfilesScreen({super.key});

  @override
  State<ConnectProfilesScreen> createState() => _ConnectProfilesScreenState();
}

class _ConnectProfilesScreenState extends State<ConnectProfilesScreen>
    with SingleTickerProviderStateMixin {
  final _service = ProfileLinkingService();
  List<ConnectedProfile> _connectedProfiles = [];
  bool _isLoading = true;

  // Level 7: Animation controllers
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Level 7: Initialize animations
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _loadProfiles();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadProfiles() async {
    setState(() => _isLoading = true);
    try {
      final profiles = await _service.getConnectedProfiles();
      setState(() {
        _connectedProfiles = profiles;
        _isLoading = false;
      });
      // Level 7: Start animations after data loads
      _animController.forward();
    } catch (e) {
      setState(() => _isLoading = false);
      _animController.forward();
    }
  }

  void _showWhyConnectInfo() {
    InfoModal.show(
      context,
      title: 'Why connect profiles?',
      body: 'Connecting your profiles helps prove your online presence and increases trust.\n\n'
          '• Builds a stronger reputation\n'
          '• Shows your identity is consistent\n'
          '• Helps people trust you faster\n'
          '• You choose what becomes public',
      icon: Icons.link_rounded,
    );
  }

  Future<void> _navigateToAddProfile() async {
    final result = await context.push<ConnectedProfile>('/profiles/add');

    if (result != null) {
      setState(() {
        _connectedProfiles.add(result);
      });
    }
  }

  void _navigateToConnectedProfiles() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConnectedProfilesScreen(
          profiles: _connectedProfiles,
          onProfilesChanged: (profiles) {
            setState(() => _connectedProfiles = profiles);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Connect Profiles',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.neutralGray900),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AppHaptics.light();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryPurple))
          : FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  _buildHeader(),
                  const SizedBox(height: 24),

                  // Why Connect Info Card
                  _buildWhyConnectCard(),
                  const SizedBox(height: 24),

                  // Connected Profiles Summary
                  if (_connectedProfiles.isNotEmpty) ...[
                    _buildConnectedSummary(),
                    const SizedBox(height: 24),
                  ],

                  // Add Profile Button
                  _buildAddProfileButton(),
                  const SizedBox(height: 16),

                  // View All Profiles Button (if any exist)
                  if (_connectedProfiles.isNotEmpty) _buildViewAllButton(),
                  const SizedBox(height: 32),

                  // Platform Categories
                  _buildPlatformCategories(),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.link_rounded,
                color: AppTheme.primaryPurple,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connect your other profiles',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.neutralGray900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Build trust across all your accounts',
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
      ],
    );
  }

  Widget _buildWhyConnectCard() {
    return GestureDetector(
      onTap: _showWhyConnectInfo,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryPurple.withValues(alpha: 0.08),
              AppTheme.primaryPurple.withValues(alpha: 0.03),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryPurple.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.info_outline_rounded,
                color: AppTheme.primaryPurple,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why connect profiles?',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap to learn how this helps your trust',
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
              color: AppTheme.primaryPurple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedSummary() {
    final linked = _connectedProfiles.where((p) => !p.isVerified).length;
    final verified = _connectedProfiles.where((p) => p.isVerified).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.successGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.successGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppTheme.successGreen,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_connectedProfiles.length} profiles connected',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralGray900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$verified verified • $linked linked',
                  style: GoogleFonts.inter(
                    fontSize: 13,
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

  Widget _buildAddProfileButton() {
    // Level 7: Animated button with scale effect
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Material(
        color: AppTheme.primaryPurple,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            AppHaptics.medium();
            _navigateToAddProfile();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Add Profile',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewAllButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          AppHaptics.light();
          _navigateToConnectedProfiles();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.neutralGray300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.list_rounded,
                color: AppTheme.neutralGray700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'View All Connected Profiles',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.neutralGray700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supported Platforms',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        const SizedBox(height: 16),

        // Marketplaces
        _buildCategorySection(
          'Marketplaces',
          Icons.storefront_rounded,
          PlatformCategory.marketplace,
        ),
        const SizedBox(height: 16),

        // Social Media
        _buildCategorySection(
          'Social Media',
          Icons.people_rounded,
          PlatformCategory.social,
        ),
        const SizedBox(height: 16),

        // Professional
        _buildCategorySection(
          'Professional',
          Icons.work_rounded,
          PlatformCategory.professional,
        ),
        const SizedBox(height: 16),

        // Gaming & Community
        _buildCategorySection(
          'Gaming & Community',
          Icons.sports_esports_rounded,
          PlatformCategory.gaming,
        ),
      ],
    );
  }

  Widget _buildCategorySection(
    String title,
    IconData icon,
    PlatformCategory category,
  ) {
    final platforms = _service.getPlatformsByCategory(category);
    if (category == PlatformCategory.gaming) {
      // Combine gaming and community
      platforms.addAll(_service.getPlatformsByCategory(PlatformCategory.community));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.neutralGray700),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.neutralGray700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: platforms.map((p) => _buildPlatformChip(p)).toList(),
        ),
      ],
    );
  }

  Widget _buildPlatformChip(PlatformConfig platform) {
    final isConnected = _connectedProfiles.any((p) => p.platformId == platform.id);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isConnected
            ? AppTheme.successGreen.withValues(alpha: 0.1)
            : AppTheme.neutralGray300.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isConnected
              ? AppTheme.successGreen.withValues(alpha: 0.3)
              : AppTheme.neutralGray300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            platform.icon,
            size: 16,
            color: isConnected ? AppTheme.successGreen : platform.brandColor,
          ),
          const SizedBox(width: 6),
          Text(
            platform.displayName,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isConnected
                  ? AppTheme.successGreen
                  : AppTheme.neutralGray700,
            ),
          ),
          if (isConnected) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.check_circle_rounded,
              size: 14,
              color: AppTheme.successGreen,
            ),
          ],
        ],
      ),
    );
  }
}
