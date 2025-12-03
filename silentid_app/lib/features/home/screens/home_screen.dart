import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptics.dart';
import '../../../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  final _authService = AuthService();
  String? _userEmail;
  int _selectedIndex = 0;

  late AnimationController _scoreController;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();

    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scoreAnimation = Tween<double>(begin: 0, end: 752).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.easeOutCubic),
    );
    _scoreController.forward();
  }

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  Future<void> _loadUserEmail() async {
    final email = await _authService.getCurrentUserEmail();
    setState(() {
      _userEmail = email;
    });
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Logout',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
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
              style: GoogleFonts.inter(color: AppTheme.neutralGray700),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SilentID',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.deepBlack,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: AppTheme.neutralGray300,
            ),

            // Content
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  _buildHomeTab(),
                  _buildEvidenceTab(),
                  _buildPassportTab(),
                  _buildSecurityTab(),
                  _buildSettingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppTheme.neutralGray300, width: 1),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
              _buildNavItem(1, Icons.description_outlined, Icons.description, 'Evidence'),
              _buildNavItem(2, Icons.person_outline, Icons.person, 'Profile'),
              _buildNavItem(3, Icons.shield_outlined, Icons.shield, 'Security'),
              _buildNavItem(4, Icons.settings_outlined, Icons.settings, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        AppHaptics.light();
        setState(() => _selectedIndex = index);
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppTheme.primaryPurple : AppTheme.neutralGray700,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppTheme.primaryPurple : AppTheme.neutralGray700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // TrustScore Hero Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                children: [
                  // Score Circle
                  SizedBox(
                    width: 128,
                    height: 128,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background ring
                        Container(
                          width: 128,
                          height: 128,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.softLilac,
                          ),
                        ),
                        // Progress ring
                        AnimatedBuilder(
                          animation: _scoreAnimation,
                          builder: (context, child) {
                            return CustomPaint(
                              size: const Size(128, 128),
                              painter: _ScoreRingPainter(
                                progress: _scoreAnimation.value / 1000,
                                color: AppTheme.primaryPurple,
                              ),
                            );
                          },
                        ),
                        // Score text
                        AnimatedBuilder(
                          animation: _scoreAnimation,
                          builder: (context, child) {
                            return Text(
                              '${_scoreAnimation.value.toInt()}',
                              style: GoogleFonts.inter(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.deepBlack,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Score Label
                  Text(
                    'Very High Trust',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.deepBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your TrustScore is in the top 15%',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.neutralGray700,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Score Range Indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '400',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.neutralGray700,
                              ),
                            ),
                            Text(
                              '1000',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.neutralGray700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppTheme.softLilac,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return AnimatedBuilder(
                                animation: _scoreAnimation,
                                builder: (context, child) {
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: constraints.maxWidth * (_scoreAnimation.value / 1000),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryPurple,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Onboarding Checklist Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.softLilac,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Complete Your Profile',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.deepBlack,
                          ),
                        ),
                        Text(
                          '2/3',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress bar
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppTheme.softLilac.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.666,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPurple,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Checklist Items
                    _buildChecklistItem(
                      'Verify your identity',
                      '+100 TrustScore',
                      true,
                    ),
                    const SizedBox(height: 12),
                    _buildChecklistItem(
                      'Connect a marketplace profile',
                      '+150 TrustScore',
                      true,
                    ),
                    const SizedBox(height: 12),
                    _buildChecklistItem(
                      'Add evidence to your vault',
                      '+100 TrustScore',
                      false,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.deepBlack,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickAction(
                          icon: Icons.description_outlined,
                          title: 'Add Evidence',
                          subtitle: 'Upload receipts',
                          onTap: () => context.push('/evidence'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickAction(
                          icon: Icons.link,
                          title: 'Connect Profile',
                          subtitle: 'Link marketplace',
                          onTap: () => context.push('/profiles/connect'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickAction(
                          icon: Icons.share_outlined,
                          title: 'Share Passport',
                          subtitle: 'Generate link',
                          onTap: () => context.push('/profile/share'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickAction(
                          icon: Icons.lock_outline,
                          title: 'Security',
                          subtitle: 'Manage devices',
                          onTap: () => setState(() => _selectedIndex = 3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recent Activity
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.deepBlack,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See All',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildActivityItem(
                    icon: Icons.check_circle_outline,
                    iconBgColor: AppTheme.successGreen.withValues(alpha: 0.1),
                    iconColor: AppTheme.successGreen,
                    title: 'Profile verified',
                    subtitle: 'Vinted profile successfully connected',
                    time: '2 hours ago',
                    points: '+150',
                  ),
                  const SizedBox(height: 12),
                  _buildActivityItem(
                    icon: Icons.shield_outlined,
                    iconBgColor: AppTheme.primaryPurple.withValues(alpha: 0.1),
                    iconColor: AppTheme.primaryPurple,
                    title: 'Identity verified',
                    subtitle: 'Stripe Identity check completed',
                    time: '1 day ago',
                    points: '+100',
                  ),
                  const SizedBox(height: 12),
                  _buildActivityItem(
                    icon: Icons.person_outline,
                    iconBgColor: AppTheme.softLilac,
                    iconColor: AppTheme.primaryPurple,
                    title: 'Account created',
                    subtitle: 'Welcome to SilentID',
                    time: '3 days ago',
                    points: null,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String title, String points, bool completed) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: completed ? AppTheme.successGreen : Colors.transparent,
            border: completed
                ? null
                : Border.all(color: AppTheme.neutralGray300, width: 2),
          ),
          child: completed
              ? const Icon(Icons.check, color: Colors.white, size: 14)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: completed ? AppTheme.neutralGray700 : AppTheme.deepBlack,
                  fontWeight: completed ? FontWeight.w400 : FontWeight.w500,
                  decoration: completed ? TextDecoration.lineThrough : null,
                ),
              ),
              Text(
                points,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: completed ? AppTheme.neutralGray700 : AppTheme.primaryPurple,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction({
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.neutralGray300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              String.fromCharCode(icon.codePoint),
              style: TextStyle(
                fontFamily: icon.fontFamily,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppTheme.deepBlack,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.neutralGray700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    String? points,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.deepBlack,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.neutralGray700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.neutralGray700.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          if (points != null)
            Text(
              points,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.successGreen,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEvidenceTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.softLilac,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.description_outlined,
                size: 40,
                color: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Evidence Vault',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBlack,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload receipts, screenshots, and profile links to build your trust profile.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.push('/evidence'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Add Evidence',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassportTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.softLilac,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline,
                size: 40,
                color: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Trust Passport',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBlack,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Share your verified trust profile with others.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.push('/profile/passport'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'View Passport',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.softLilac,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shield_outlined,
                size: 40,
                color: AppTheme.primaryPurple,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Security Center',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBlack,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your security settings and connected devices.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.push('/security'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'View Security',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Section
          _buildSettingsSection(
            'Account',
            [
              _buildSettingsItem(
                Icons.person_outline,
                'Account Details',
                'Email, display name',
                () => context.push('/settings/account'),
              ),
              _buildSettingsItem(
                Icons.people_outline,
                'Connected Accounts',
                'Apple, Google',
                () {},
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Security Section
          _buildSettingsSection(
            'Security',
            [
              _buildSettingsItem(
                Icons.lock_outline,
                'Manage Passkeys',
                '2 passkeys active',
                () => context.push('/security/passkeys'),
              ),
              _buildSettingsItem(
                Icons.devices_outlined,
                'Connected Devices',
                'Manage trusted devices',
                () => context.push('/settings/devices'),
              ),
              _buildSettingsItem(
                Icons.shield_outlined,
                'Login Activity',
                'Recent sessions & history',
                () => context.push('/security/activity'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Data Section
          _buildSettingsSection(
            'Data',
            [
              _buildSettingsItem(
                Icons.download_outlined,
                'Export My Data',
                'Download all your data',
                () => context.push('/settings/export'),
              ),
              _buildSettingsItem(
                Icons.delete_outline,
                'Delete Account',
                'Permanently delete your account',
                () => context.push('/settings/delete'),
                isDestructive: true,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // App Info Section
          _buildSettingsSection(
            'App Info',
            [
              _buildSettingsItem(
                Icons.help_outline,
                'Help Center',
                null,
                () {},
              ),
              _buildSettingsItem(
                Icons.description_outlined,
                'Terms of Service',
                null,
                () {},
              ),
              _buildSettingsItem(
                Icons.lock_outline,
                'Privacy Policy',
                null,
                () {},
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Version info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
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
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Version',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.deepBlack,
                      ),
                    ),
                    Text(
                      '1.0.0',
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

          const SizedBox(height: 16),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _handleLogout,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: AppTheme.neutralGray300, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Log Out',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepBlack,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBlack,
              ),
            ),
          ),
          Divider(height: 1, color: AppTheme.neutralGray300),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    String? subtitle,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppTheme.neutralGray300.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppTheme.dangerRed.withValues(alpha: 0.1)
                    : AppTheme.softLilac,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: isDestructive ? AppTheme.dangerRed : AppTheme.primaryPurple,
                size: 20,
              ),
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
                      color: isDestructive ? AppTheme.dangerRed : AppTheme.deepBlack,
                    ),
                  ),
                  if (subtitle != null)
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
            Icon(
              Icons.chevron_right,
              color: isDestructive ? AppTheme.dangerRed : AppTheme.neutralGray700,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ScoreRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ScoreRingPainter oldDelegate) =>
      progress != oldDelegate.progress || color != oldDelegate.color;
}
