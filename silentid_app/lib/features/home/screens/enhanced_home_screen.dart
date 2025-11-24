import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/offline_indicator.dart';
import '../../../core/utils/animations.dart';
import '../../../services/auth_service.dart';

class EnhancedHomeScreen extends StatefulWidget {
  const EnhancedHomeScreen({super.key});

  @override
  State<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen> {
  final _authService = AuthService();
  String? _userEmail;
  int _selectedIndex = 0;
  bool _isOnline = true; // TODO: Implement connectivity check

  // Badge counts (placeholder - integrate with real data)
  int _evidenceBadgeCount = 0;
  int _verifyBadgeCount = 2; // Example: 2 pending verification requests
  int _profileBadgeCount = 1; // Example: 1 security alert

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _checkConnectivity();
  }

  Future<void> _loadUserEmail() async {
    final email = await _authService.getCurrentUserEmail();
    setState(() {
      _userEmail = email;
    });
  }

  Future<void> _checkConnectivity() async {
    // TODO: Implement real connectivity check
    // For now, always online
    setState(() {
      _isOnline = true;
    });
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

  Future<void> _refreshTab() async {
    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));

    // TODO: Implement real refresh logic based on tab
    setState(() {
      // Refresh complete
    });
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

            const SizedBox(height: 32),

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
