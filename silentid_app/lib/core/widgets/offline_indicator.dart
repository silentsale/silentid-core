import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Offline indicator banner
class OfflineIndicator extends StatelessWidget {
  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.warningAmber,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off,
            size: 20,
            color: AppTheme.deepBlack,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You\'re offline. Some features may be unavailable.',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.deepBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Connection status indicator
class ConnectionStatusIndicator extends StatelessWidget {
  final bool isOnline;

  const ConnectionStatusIndicator({
    super.key,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    if (isOnline) {
      return const SizedBox.shrink();
    }

    return const OfflineIndicator();
  }
}

/// Inline connection status
class InlineConnectionStatus extends StatelessWidget {
  final bool isOnline;

  const InlineConnectionStatus({
    super.key,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isOnline ? AppTheme.successGreen : AppTheme.dangerRed,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isOnline ? 'Online' : 'Offline',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppTheme.neutralGray700,
          ),
        ),
      ],
    );
  }
}
