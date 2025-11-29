import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/offline_indicator.dart';
import '../../../core/widgets/onboarding_checklist.dart';
import '../../../core/utils/animations.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_api_service.dart';
import '../../../services/evidence_service.dart';
import '../../../services/profile_linking_service.dart';

class EnhancedHomeScreen extends StatefulWidget {
  const EnhancedHomeScreen({super.key});

  @override
  State<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen> {
  final _authService = AuthService();
  static const _storage = FlutterSecureStorage();

  // API Services for data refresh
  final _userApiService = UserApiService();
  final _evidenceService = EvidenceService();
  final _profileLinkingService = ProfileLinkingService();

  String? _userEmail;
  int _selectedIndex = 0;
  bool _isOnline = true;
  bool _isRefreshing = false;

  // Badge counts (placeholder - integrate with real data)
  final int _evidenceBadgeCount = 0;
  final int _verifyBadgeCount = 2; // Example: 2 pending verification requests
  final int _profileBadgeCount = 1; // Example: 1 security alert

  // Section 50.2.2 - Onboarding checklist state
  bool _showOnboardingChecklist = true;
  bool _identityVerified = false;
  bool _profileConnected = false;
  bool _firstEvidenceAdded = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _checkConnectivity();
    _loadOnboardingState();
  }

  /// Load onboarding checklist state from secure storage
  Future<void> _loadOnboardingState() async {
    final dismissed = await _storage.read(key: 'onboarding_checklist_dismissed');
    final identity = await _storage.read(key: 'identity_verified');
    final profile = await _storage.read(key: 'profile_connected');
    final evidence = await _storage.read(key: 'first_evidence_added');

    setState(() {
      _showOnboardingChecklist = dismissed != 'true';
      _identityVerified = identity == 'true';
      _profileConnected = profile == 'true';
      _firstEvidenceAdded = evidence == 'true';
    });
  }

  /// Dismiss the onboarding checklist permanently
  Future<void> _dismissOnboardingChecklist() async {
    await _storage.write(key: 'onboarding_checklist_dismissed', value: 'true');
    setState(() {
      _showOnboardingChecklist = false;
    });
  }

  Future<void> _loadUserEmail() async {
    final email = await _authService.getCurrentUserEmail();
    setState(() {
      _userEmail = email;
    });
  }

  /// Check internet connectivity by attempting a lightweight HTTP request
  /// Uses Google's connectivity check endpoint (similar to Android's approach)
  Future<void> _checkConnectivity() async {
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ));

      // Use Google's generate_204 endpoint - returns 204 No Content if online
      // This is the same approach used by Android for connectivity checks
      final response = await dio.get('https://www.google.com/generate_204');

      if (mounted) {
        setState(() {
          _isOnline = response.statusCode == 204;
        });
      }
    } on DioException catch (_) {
      // Any network error means offline
      if (mounted) {
        setState(() {
          _isOnline = false;
        });
      }
    } catch (_) {
      // Fallback: assume online if check fails unexpectedly
      if (mounted) {
        setState(() {
          _isOnline = true;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: AppTheme.neutralGray700,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Logout',
              style: GoogleFonts.inter(
                color: AppTheme.dangerRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await _authService.logout();
      if (mounted) {
        context.go('/');
      }
    }
  }

  /// Refresh data based on the currently selected tab
  /// Tab 0 (Home): Refresh user data, TrustScore, connectivity
  /// Tab 1 (Evidence): Refresh evidence list (receipts, screenshots, profile links)
  /// Tab 2 (Verify): Refresh verification requests (not implemented yet)
  /// Tab 3 (Profile): Refresh user profile data
  Future<void> _refreshTab() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      // Always check connectivity on refresh
      await _checkConnectivity();

      // If offline, don't attempt data refresh
      if (!_isOnline) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are offline. Please check your connection.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // Refresh based on current tab
      switch (_selectedIndex) {
        case 0:
          // Home tab: Refresh user profile and TrustScore
          await _refreshHomeData();
          break;

        case 1:
          // Evidence tab: Refresh evidence list
          await _refreshEvidenceData();
          break;

        case 2:
          // Verify tab: Refresh verification requests
          // Note: MutualVerificationService removed per specification
          // Future: Add other verification-related refresh if needed
          break;

        case 3:
          // Profile tab: Refresh profile data
          await _refreshProfileData();
          break;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Refresh failed: ${e.toString().replaceAll('Exception: ', '')}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  /// Refresh Home tab data: user info, TrustScore, onboarding state
  Future<void> _refreshHomeData() async {
    try {
      // Fetch user profile (includes TrustScore)
      final userProfile = await _userApiService.getUserProfile();

      // Reload onboarding state
      await _loadOnboardingState();

      // Update user email if changed
      if (mounted && userProfile.email != _userEmail) {
        setState(() {
          _userEmail = userProfile.email;
        });
      }
    } catch (e) {
      // Log error but don't crash - partial refresh is acceptable
      debugPrint('Home refresh error: $e');
      rethrow;
    }
  }

  /// Refresh Evidence tab data: receipts, screenshots, profile links
  Future<void> _refreshEvidenceData() async {
    try {
      // Fetch evidence summary (counts)
      await _evidenceService.getEvidenceSummary();

      // Fetch receipts list
      await _evidenceService.getReceipts();

      // Fetch connected profiles
      await _profileLinkingService.getConnectedProfiles();
    } catch (e) {
      debugPrint('Evidence refresh error: $e');
      rethrow;
    }
  }

  /// Refresh Profile tab data: user profile, connected profiles
  Future<void> _refreshProfileData() async {
    try {
      // Fetch full user profile
      await _userApiService.getUserProfile();

      // Fetch connected profiles for display
      await _profileLinkingService.getConnectedProfiles();
    } catch (e) {
      debugPrint('Profile refresh error: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SilentID',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // Connection status
          if (!_isOnline)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: InlineConnectionStatus(isOnline: false),
            ),

          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // Offline indicator
          if (!_isOnline)
            const OfflineIndicator(),

          // Main content with fade transition
          Expanded(
            child: AnimatedSwitcher(
              duration: AppAnimations.normal,
              child: IndexedStack(
                key: ValueKey(_selectedIndex),
                index: _selectedIndex,
                children: [
                  _buildHomeTab(),
                  _buildEvidenceTab(),
                  _buildVerifyTab(),
                  _buildProfileTab(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryPurple,
      unselectedItemColor: AppTheme.neutralGray700,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
      ),
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: _buildBadge(
            icon: const Icon(Icons.folder_outlined),
            count: _evidenceBadgeCount,
          ),
          activeIcon: _buildBadge(
            icon: const Icon(Icons.folder),
            count: _evidenceBadgeCount,
          ),
          label: 'Evidence',
        ),
        BottomNavigationBarItem(
          icon: _buildBadge(
            icon: const Icon(Icons.verified_user_outlined),
            count: _verifyBadgeCount,
          ),
          activeIcon: _buildBadge(
            icon: const Icon(Icons.verified_user),
            count: _verifyBadgeCount,
          ),
          label: 'Verify',
        ),
        BottomNavigationBarItem(
          icon: _buildBadge(
            icon: const Icon(Icons.person_outline),
            count: _profileBadgeCount,
          ),
          activeIcon: _buildBadge(
            icon: const Icon(Icons.person),
            count: _profileBadgeCount,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildBadge({
    required Widget icon,
    required int count,
  }) {
    if (count == 0) return icon;

    return Badge(
      label: Text('$count'),
      backgroundColor: AppTheme.dangerRed,
      child: icon,
    );
  }

  Widget _buildHomeTab() {
    // Check if all onboarding steps complete
    final allStepsComplete = _identityVerified &&
        _profileConnected &&
        _firstEvidenceAdded;

    return RefreshIndicator(
      onRefresh: _refreshTab,
      color: AppTheme.primaryPurple,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome message with fade-in
            AppAnimations.fadeSlideIn(
              child: Text(
                'Welcome back!',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.deepBlack,
                ),
              ),
            ),

            const SizedBox(height: 8),

            if (_userEmail != null)
              AppAnimations.fadeSlideIn(
                child: Text(
                  _userEmail!,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Section 50.2.2 - Onboarding Checklist (show for new users)
            if (_showOnboardingChecklist)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: OnboardingChecklist(
                  identityVerified: _identityVerified,
                  profileConnected: _profileConnected,
                  firstEvidenceAdded: _firstEvidenceAdded,
                  onVerifyIdentityTap: () => context.push('/identity/intro'),
                  onConnectProfileTap: () => context.push('/profiles/connect'),
                  onAddEvidenceTap: () => context.push('/evidence'),
                  onDismiss: allStepsComplete ? _dismissOnboardingChecklist : null,
                ),
              ),

            // TrustScore card with animation
            AppAnimations.scaleIn(
              child: _buildTrustScoreCard(),
            ),

            const SizedBox(height: 24),

            // Quick actions with stagger
            _buildQuickActionCard(
              icon: Icons.shield_outlined,
              title: 'Verify Identity',
              subtitle: 'Complete your Stripe verification',
              onTap: () => context.push('/identity/intro'),
            ),

            const SizedBox(height: 16),

            _buildQuickActionCard(
              icon: Icons.link,
              title: 'Connect Profiles',
              subtitle: 'Link your Vinted, eBay, Depop ratings',
              onTap: () => context.push('/profiles/connect'),
            ),

            const SizedBox(height: 16),

            _buildQuickActionCard(
              icon: Icons.receipt_outlined,
              title: 'Add Evidence',
              subtitle: 'Upload receipts and screenshots',
              onTap: () => context.push('/evidence'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustScoreCard() {
    return InkWell(
      onTap: () => context.push('/trust/overview'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primaryPurple, AppTheme.darkModePurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
            Text(
              'Your TrustScore',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppTheme.pureWhite.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '754',
              style: GoogleFonts.inter(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: AppTheme.pureWhite,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'High Trust',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.pureWhite.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View Details',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.pureWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward,
                  color: AppTheme.pureWhite,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.neutralGray300,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.softLilac,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryPurple,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.deepBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.neutralGray700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.neutralGray700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvidenceTab() {
    return RefreshIndicator(
      onRefresh: _refreshTab,
      color: AppTheme.primaryPurple,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: EmptyState.evidence(
            onAction: () => context.push('/evidence/receipt/upload'),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyTab() {
    return RefreshIndicator(
      onRefresh: _refreshTab,
      color: AppTheme.primaryPurple,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: EmptyState.mutualVerifications(
            onAction: () => context.push('/mutual-verification/create'),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return RefreshIndicator(
      onRefresh: _refreshTab,
      color: AppTheme.primaryPurple,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Profile & Settings',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.deepBlack,
            ),
          ),

          const SizedBox(height: 24),

          _buildSettingsTile(
            icon: Icons.person_outline,
            title: 'Account Details',
            onTap: () => context.push('/settings/account'),
          ),

          _buildSettingsTile(
            icon: Icons.public_outlined,
            title: 'My Public Profile',
            onTap: () => context.push('/profile/public'),
          ),

          _buildSettingsTile(
            icon: Icons.security_outlined,
            title: 'Privacy Settings',
            badge: _profileBadgeCount > 0 ? _profileBadgeCount : null,
            onTap: () => context.push('/settings/privacy'),
          ),

          _buildSettingsTile(
            icon: Icons.devices_outlined,
            title: 'Connected Devices',
            onTap: () => context.push('/settings/devices'),
          ),

          const Divider(height: 32),

          const Text(
            'Data & Privacy',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.neutralGray700,
            ),
          ),

          const SizedBox(height: 12),

          _buildSettingsTile(
            icon: Icons.download_outlined,
            title: 'Export My Data',
            onTap: () => context.push('/settings/export'),
          ),

          const Divider(height: 32),

          const Text(
            'Danger Zone',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.dangerRed,
            ),
          ),

          const SizedBox(height: 12),

          _buildSettingsTile(
            icon: Icons.delete_forever_outlined,
            title: 'Delete Account',
            textColor: AppTheme.dangerRed,
            onTap: () => context.push('/settings/delete'),
          ),

          const Divider(height: 32),

          _buildSettingsTile(
            icon: Icons.logout,
            title: 'Logout',
            textColor: AppTheme.dangerRed,
            onTap: _handleLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Color? textColor,
    required VoidCallback onTap,
    int? badge,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? AppTheme.deepBlack,
      ),
      title: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: textColor ?? AppTheme.deepBlack,
            ),
          ),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.dangerRed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$badge',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.pureWhite,
                ),
              ),
            ),
          ],
        ],
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppTheme.neutralGray700,
      ),
      onTap: onTap,
    );
  }
}
