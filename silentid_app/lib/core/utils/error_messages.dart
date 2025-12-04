import 'dart:io';

/// User-friendly error message mapping for SilentID
/// Converts technical exceptions into readable messages
/// Per Section 53 - Design System compliance
class ErrorMessages {
  // ============================================
  // GENERIC ERROR MAPPING
  // ============================================

  /// Convert any exception to a user-friendly message
  static String fromException(dynamic error, {String? fallbackAction}) {
    final action = fallbackAction ?? 'complete this action';

    // Handle null/empty errors
    if (error == null) {
      return 'Something went wrong. Please try again.';
    }

    final errorString = error.toString().toLowerCase();

    // Network errors
    if (_isNetworkError(error, errorString)) {
      return 'Unable to connect. Please check your internet connection and try again.';
    }

    // Timeout errors
    if (_isTimeoutError(errorString)) {
      return 'The request took too long. Please try again.';
    }

    // Authentication errors
    if (_isAuthError(errorString)) {
      return 'Your session has expired. Please log in again.';
    }

    // Permission errors
    if (_isPermissionError(errorString)) {
      return 'You don\'t have permission to $action.';
    }

    // Not found errors
    if (_isNotFoundError(errorString)) {
      return 'The requested item could not be found.';
    }

    // Rate limit errors
    if (_isRateLimitError(errorString)) {
      return 'Too many requests. Please wait a moment and try again.';
    }

    // Validation errors
    if (_isValidationError(errorString)) {
      return 'Please check your input and try again.';
    }

    // Server errors
    if (_isServerError(errorString)) {
      return 'Our servers are having trouble. Please try again later.';
    }

    // Generic fallback
    return 'Unable to $action. Please try again.';
  }

  // ============================================
  // FEATURE-SPECIFIC MESSAGES
  // ============================================

  // --- Authentication ---
  static const String otpSent = 'Verification code sent to your email.';
  static const String otpInvalid = 'Invalid or expired code. Please try again.';
  static const String otpExpired = 'Code has expired. Please request a new one.';
  static const String loginSuccess = 'Welcome back!';
  static const String logoutSuccess = 'You have been logged out.';
  static const String sessionExpired = 'Your session has expired. Please log in again.';

  // --- Profile Linking ---
  static const String profileLinkAdded = 'Profile link added successfully.';
  static const String profileLinkFailed = 'Unable to add profile link. Please check the URL and try again.';
  static const String profileDeleted = 'Profile removed successfully.';

  // --- Profile Verification ---
  static const String verificationStarted = 'Verification started. Please follow the instructions.';
  static const String verificationSuccess = 'Profile verified successfully!';
  static const String verificationFailed = 'Verification failed. Please try again.';
  static const String verificationPending = 'Verification is being processed. This may take a few minutes.';

  // --- Identity Verification ---
  static const String identityVerified = 'Identity verified successfully!';
  static const String identityFailed = 'Identity verification failed. Please try again.';
  static const String identityPending = 'Identity verification is being processed.';

  // --- Device Management ---
  static const String deviceRevoked = 'Device access revoked successfully.';
  static const String deviceRevokeFailed = 'Unable to revoke device. Please try again.';
  static const String deviceAdded = 'This device has been registered.';

  // --- Account Management ---
  static const String accountUpdated = 'Account details updated successfully.';
  static const String accountUpdateFailed = 'Unable to update account. Please try again.';
  static const String accountDeleted = 'Your account has been deleted.';
  static const String accountDeleteFailed = 'Unable to delete account. Please try again.';
  static const String passwordChanged = 'Password changed successfully.';
  static const String emailChanged = 'Email updated successfully. Please verify your new email.';

  // --- Privacy Settings ---
  static const String privacyUpdated = 'Privacy settings updated.';
  static const String privacyUpdateFailed = 'Unable to update privacy settings. Please try again.';

  // --- Reports ---
  static const String reportSubmitted = 'Report submitted. Thank you for helping keep SilentID safe.';
  static const String reportFailed = 'Unable to submit report. Please try again.';
  static const String concernReported = 'Concern reported. We\'ll review it shortly.';

  // --- Subscriptions ---
  static const String subscriptionSuccess = 'Subscription activated successfully!';
  static const String subscriptionFailed = 'Unable to process subscription. Please try again.';
  static const String subscriptionCancelled = 'Subscription cancelled.';

  // --- Data Export ---
  static const String exportStarted = 'Data export started. You\'ll receive an email when it\'s ready.';
  static const String exportFailed = 'Unable to start data export. Please try again.';

  // --- Sharing ---
  static const String linkCopied = 'Link copied to clipboard.';
  static const String shareFailed = 'Unable to share. Please try again.';

  // --- Referrals ---
  static const String referralCodeCopied = 'Referral code copied!';
  static const String referralSuccess = 'Referral applied successfully!';
  static const String referralInvalid = 'Invalid referral code. Please check and try again.';

  // --- Security ---
  static const String alertMarkedRead = 'Alert marked as read.';
  static const String allAlertsRead = 'All alerts marked as read.';

  // --- General ---
  static const String saved = 'Changes saved.';
  static const String deleted = 'Item deleted.';
  static const String copied = 'Copied to clipboard.';
  static const String tryAgain = 'Something went wrong. Please try again.';
  static const String networkError = 'Unable to connect. Please check your internet connection.';
  static const String serverError = 'Our servers are having trouble. Please try again later.';

  // ============================================
  // ERROR TYPE DETECTION HELPERS
  // ============================================

  static bool _isNetworkError(dynamic error, String errorString) {
    if (error is SocketException) return true;
    return errorString.contains('socketexception') ||
        errorString.contains('connection refused') ||
        errorString.contains('network is unreachable') ||
        errorString.contains('no internet') ||
        errorString.contains('failed host lookup') ||
        errorString.contains('connection reset') ||
        errorString.contains('connection closed') ||
        errorString.contains('handshake') ||
        errorString.contains('errno = 7') ||
        errorString.contains('errno = 8') ||
        errorString.contains('errno = 61');
  }

  static bool _isTimeoutError(String errorString) {
    return errorString.contains('timeout') ||
        errorString.contains('timed out') ||
        errorString.contains('deadline exceeded');
  }

  static bool _isAuthError(String errorString) {
    return errorString.contains('401') ||
        errorString.contains('unauthorized') ||
        errorString.contains('unauthenticated') ||
        errorString.contains('token expired') ||
        errorString.contains('invalid token') ||
        errorString.contains('session expired');
  }

  static bool _isPermissionError(String errorString) {
    return errorString.contains('403') ||
        errorString.contains('forbidden') ||
        errorString.contains('permission denied') ||
        errorString.contains('access denied');
  }

  static bool _isNotFoundError(String errorString) {
    return errorString.contains('404') || errorString.contains('not found');
  }

  static bool _isRateLimitError(String errorString) {
    return errorString.contains('429') ||
        errorString.contains('rate limit') ||
        errorString.contains('too many requests') ||
        errorString.contains('throttled');
  }

  static bool _isValidationError(String errorString) {
    return errorString.contains('400') ||
        errorString.contains('bad request') ||
        errorString.contains('validation') ||
        errorString.contains('invalid');
  }

  static bool _isServerError(String errorString) {
    return errorString.contains('500') ||
        errorString.contains('502') ||
        errorString.contains('503') ||
        errorString.contains('504') ||
        errorString.contains('internal server error') ||
        errorString.contains('service unavailable') ||
        errorString.contains('bad gateway');
  }
}
