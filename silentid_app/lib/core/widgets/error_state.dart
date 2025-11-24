import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Global error state widget
class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String? retryText;
  final IconData? icon;
  final bool showDetails;
  final String? errorDetails;

  const ErrorState({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.retryText,
    this.icon,
    this.showDetails = false,
    this.errorDetails,
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
                color: AppTheme.dangerRed.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.error_outline,
                size: 48,
                color: AppTheme.dangerRed,
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
            if (showDetails && errorDetails != null) ...[
              const SizedBox(height: 16),
              _ErrorDetailsExpander(details: errorDetails!),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    foregroundColor: AppTheme.pureWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.refresh, size: 20),
                  label: Text(
                    retryText ?? 'Try Again',
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

  /// Network error state
  factory ErrorState.network({
    VoidCallback? onRetry,
  }) {
    return ErrorState(
      title: 'Connection Error',
      message: 'Unable to connect. Please check your internet connection and try again.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }

  /// Server error state
  factory ErrorState.server({
    VoidCallback? onRetry,
    String? errorDetails,
  }) {
    return ErrorState(
      title: 'Server Error',
      message: 'Something went wrong on our end. Please try again later.',
      icon: Icons.cloud_off,
      onRetry: onRetry,
      showDetails: errorDetails != null,
      errorDetails: errorDetails,
    );
  }

  /// Unauthorized error state
  factory ErrorState.unauthorized({
    VoidCallback? onRetry,
  }) {
    return ErrorState(
      title: 'Session Expired',
      message: 'Your session has expired. Please log in again.',
      icon: Icons.lock_outline,
      onRetry: onRetry,
      retryText: 'Log In',
    );
  }

  /// Not found error state
  factory ErrorState.notFound({
    String? resourceName,
  }) {
    return ErrorState(
      title: 'Not Found',
      message: resourceName != null
          ? '$resourceName not found'
          : 'The requested resource could not be found.',
      icon: Icons.search_off,
    );
  }

  /// Generic error state
  factory ErrorState.generic({
    String? message,
    VoidCallback? onRetry,
    String? errorDetails,
  }) {
    return ErrorState(
      title: 'Oops!',
      message: message ?? 'An unexpected error occurred. Please try again.',
      onRetry: onRetry,
      showDetails: errorDetails != null,
      errorDetails: errorDetails,
    );
  }
}

/// Expandable error details section
class _ErrorDetailsExpander extends StatefulWidget {
  final String details;

  const _ErrorDetailsExpander({required this.details});

  @override
  State<_ErrorDetailsExpander> createState() => _ErrorDetailsExpanderState();
}

class _ErrorDetailsExpanderState extends State<_ErrorDetailsExpander> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          icon: Icon(
            _isExpanded ? Icons.expand_less : Icons.expand_more,
            size: 20,
            color: AppTheme.neutralGray700,
          ),
          label: Text(
            _isExpanded ? 'Hide Details' : 'Show Details',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.neutralGray700,
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.neutralGray300.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.details,
              style: GoogleFonts.robotoMono(
                fontSize: 12,
                color: AppTheme.neutralGray900,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Inline error message (for form fields)
class InlineError extends StatelessWidget {
  final String message;

  const InlineError({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.dangerRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.dangerRed.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            size: 20,
            color: AppTheme.dangerRed,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.dangerRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
