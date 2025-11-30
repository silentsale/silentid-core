import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Global empty state widget
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: (iconColor ?? AppTheme.neutralGray300).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: iconColor ?? AppTheme.neutralGray300,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBlack,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    foregroundColor: AppTheme.pureWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    actionText!,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Empty evidence state
  factory EmptyState.evidence({
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.folder_outlined,
      title: 'No Evidence Yet',
      message: 'Add your first evidence to build your TrustScore.\n\nUpload receipts, screenshots, or link your marketplace profiles.',
      actionText: 'Add Evidence',
      onAction: onAction,
      iconColor: AppTheme.primaryPurple,
    );
  }

  /// Empty reports state
  factory EmptyState.reports() {
    return const EmptyState(
      icon: Icons.shield_outlined,
      title: 'No Reports',
      message: 'You haven\'t filed any safety reports.',
      iconColor: AppTheme.successGreen,
    );
  }

  /// Empty devices state
  factory EmptyState.devices() {
    return const EmptyState(
      icon: Icons.devices_outlined,
      title: 'No Other Devices',
      message: 'This is your only trusted device.\n\nNew devices will appear here when you log in.',
    );
  }

  /// Empty receipts state
  factory EmptyState.receipts({
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.receipt_outlined,
      title: 'No Receipts Yet',
      message: 'Connect your email or manually upload receipts to build evidence of your transactions.',
      actionText: 'Upload Receipt',
      onAction: onAction,
      iconColor: AppTheme.primaryPurple,
    );
  }

  /// Empty screenshots state
  factory EmptyState.screenshots({
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.image_outlined,
      title: 'No Screenshots Yet',
      message: 'Upload screenshots of your marketplace profiles, reviews, or sales history.',
      actionText: 'Upload Screenshot',
      onAction: onAction,
      iconColor: AppTheme.primaryPurple,
    );
  }

  /// Empty profile links state
  factory EmptyState.profileLinks({
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.link_outlined,
      title: 'No Profile Links Yet',
      message: 'Link your public marketplace profiles (Vinted, eBay, Depop) to verify your activity.',
      actionText: 'Add Profile Link',
      onAction: onAction,
      iconColor: AppTheme.primaryPurple,
    );
  }

  /// Search no results state
  factory EmptyState.searchNoResults({
    required String searchQuery,
  }) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'No Results Found',
      message: 'We couldn\'t find anything matching "$searchQuery".\n\nTry adjusting your search.',
    );
  }

  /// Coming soon state
  factory EmptyState.comingSoon({
    required String featureName,
  }) {
    return EmptyState(
      icon: Icons.auto_awesome_outlined,
      title: 'Coming Soon',
      message: '$featureName will be available in a future update.',
      iconColor: AppTheme.primaryPurple,
    );
  }
}

/// Compact empty state for inline use
class CompactEmptyState extends StatelessWidget {
  final String message;
  final IconData? icon;

  const CompactEmptyState({
    super.key,
    required this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: AppTheme.neutralGray700,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
