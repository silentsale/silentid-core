import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// MainShellScreen provides the persistent bottom navigation bar
/// for the 4 main sections of SilentID as defined in Section 39.
///
/// Tabs:
/// 1. Home - TrustScore overview, quick actions, recent activity
/// 2. Evidence - Receipts, screenshots, profile links
/// 3. Verify - Mutual verifications, scan profiles, QR codes
/// 4. Profile - Settings, account, security, help
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
                  icon: Icons.verified_outlined,
                  activeIcon: Icons.verified,
                  label: 'Verify',
                  index: 2,
                  route: '/mutual-verification',
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profile',
                  index: 3,
                  route: '/profile/public',
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
            _navigateToTab(context, route);
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                  fontSize: 12,
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

  void _navigateToTab(BuildContext context, String route) {
    // Use GoRouter for navigation
    // This will be replaced with proper GoRouter navigation when integrated
    Navigator.of(context).pushReplacementNamed(route);
  }
}

/// Helper class to determine current tab index from route
class ShellRouteHelper {
  static int getIndexFromRoute(String location) {
    if (location.startsWith('/home')) {
      return 0;
    } else if (location.startsWith('/evidence')) {
      return 1;
    } else if (location.startsWith('/mutual-verification')) {
      return 2;
    } else if (location.startsWith('/profile')) {
      return 3;
    } else if (location.startsWith('/trust')) {
      return 0; // Trust screens are part of Home
    } else if (location.startsWith('/safety')) {
      return 3; // Safety screens are part of Profile
    } else if (location.startsWith('/settings')) {
      return 3; // Settings screens are part of Profile
    } else if (location.startsWith('/subscriptions')) {
      return 3; // Subscription screens are part of Profile
    }
    return 0; // Default to Home
  }

  /// Routes that should show the bottom navigation bar
  static bool shouldShowBottomNav(String location) {
    // Auth routes don't show bottom nav
    if (location == '/' ||
        location == '/email' ||
        location == '/otp' ||
        location.startsWith('/identity/verify')) {
      return false;
    }
    return true;
  }
}
