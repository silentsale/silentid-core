import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

/// MainShellScreen provides the persistent bottom navigation bar
/// for the 5 main sections of SilentID.
///
/// Tabs (per CLAUDE.md spec):
/// 1. Home - TrustScore overview, quick actions, onboarding
/// 2. Evidence - Receipts, screenshots, profile links
/// 3. Profile - Public Trust Passport, sharing
/// 4. Security - Security center, login activity, risk
/// 5. Settings - Account, privacy, help, subscriptions
class MainShellScreen extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainShellScreen({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.pureWhite,
          boxShadow: [
            BoxShadow(
              color: AppTheme.neutralGray300.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                  index: 0,
                  route: '/home',
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.folder_outlined,
                  activeIcon: Icons.folder,
                  label: 'Evidence',
                  index: 1,
                  route: '/evidence',
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                  index: 2,
                  route: '/profile/public',
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.shield_outlined,
                  activeIcon: Icons.shield,
                  label: 'Security',
                  index: 3,
                  route: '/security',
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  label: 'Settings',
                  index: 4,
                  route: '/settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required String route,
  }) {
    final isSelected = widget.currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (!isSelected) {
            context.go(route);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryPurple.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected
                      ? AppTheme.primaryPurple
                      : AppTheme.neutralGray700,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppTheme.primaryPurple
                      : AppTheme.neutralGray700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper class to determine current tab index from route
class ShellRouteHelper {
  static int getIndexFromRoute(String location) {
    // Tab 0: Home
    if (location.startsWith('/home') ||
        location.startsWith('/trust') ||
        location.startsWith('/onboarding') ||
        location.startsWith('/identity')) {
      return 0;
    }
    // Tab 1: Evidence
    if (location.startsWith('/evidence') ||
        location.startsWith('/profiles')) {
      return 1;
    }
    // Tab 2: Profile
    if (location.startsWith('/profile')) {
      return 2;
    }
    // Tab 3: Security
    if (location.startsWith('/security')) {
      return 3;
    }
    // Tab 4: Settings
    if (location.startsWith('/settings') ||
        location.startsWith('/subscriptions') ||
        location.startsWith('/safety') ||
        location.startsWith('/referral') ||
        location.startsWith('/sharing') ||
        location.startsWith('/help') ||
        location.startsWith('/support') ||
        location.startsWith('/concern')) {
      return 4;
    }
    return 0; // Default to Home
  }

  /// Routes that should show the bottom navigation bar
  static bool shouldShowBottomNav(String location) {
    // Auth routes don't show bottom nav
    if (location == '/' ||
        location == '/email' ||
        location == '/otp' ||
        location.startsWith('/identity/verify') ||
        location.startsWith('/onboarding/tour')) {
      return false;
    }
    return true;
  }
}
