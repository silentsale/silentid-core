import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Centralized message display service for SilentID
/// Provides consistent user-friendly messages throughout the app
/// Per Section 53 - Design System compliance
class AppMessages {
  // ============================================
  // SUCCESS MESSAGES
  // ============================================

  /// Show a success message (green SnackBar)
  static void showSuccess(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ============================================
  // ERROR MESSAGES
  // ============================================

  /// Show an error message (red SnackBar)
  static void showError(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.dangerRed,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show an info message (purple SnackBar)
  static void showInfo(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primaryPurple,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show a warning message (orange SnackBar)
  static void showWarning(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.warningAmber,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ============================================
  // CONFIRMATION DIALOGS
  // ============================================

  /// Show a confirmation dialog for destructive actions
  /// Returns true if user confirmed, false if cancelled
  static Future<bool> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) async {
    if (!context.mounted) return false;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancelText,
              style: TextStyle(color: AppTheme.neutralGray700),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              confirmText,
              style: TextStyle(
                color: isDestructive ? AppTheme.dangerRed : AppTheme.primaryPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Show a delete confirmation dialog
  static Future<bool> showDeleteConfirmation(
    BuildContext context, {
    required String itemName,
    String? customMessage,
  }) {
    return showConfirmation(
      context,
      title: 'Delete $itemName?',
      message: customMessage ?? 'This action cannot be undone. Are you sure you want to delete this $itemName?',
      confirmText: 'Delete',
      isDestructive: true,
    );
  }

  /// Show a logout confirmation dialog
  static Future<bool> showLogoutConfirmation(BuildContext context) {
    return showConfirmation(
      context,
      title: 'Log Out?',
      message: 'Are you sure you want to log out of your account?',
      confirmText: 'Log Out',
      isDestructive: false,
    );
  }

  /// Show a revoke device confirmation dialog
  static Future<bool> showRevokeDeviceConfirmation(
    BuildContext context, {
    required String deviceName,
  }) {
    return showConfirmation(
      context,
      title: 'Revoke Device?',
      message: 'This will log out "$deviceName" and prevent it from accessing your account until you log in again.',
      confirmText: 'Revoke Access',
      isDestructive: true,
    );
  }

  // ============================================
  // PROGRESS DIALOG
  // ============================================

  /// Show a loading dialog (non-dismissible)
  static void showLoading(BuildContext context, {String message = 'Please wait...'}) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
              ),
              const SizedBox(width: 20),
              Expanded(child: Text(message)),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  /// Hide loading dialog
  static void hideLoading(BuildContext context) {
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }
}
