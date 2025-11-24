import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../constants/app_spacing.dart';

/// Info Modal widget following Section 40.3 specifications
///
/// Bottom sheet (mobile) that displays educational content
/// Max width: 90% screen width or 400px (whichever is smaller)
/// Padding: 24px all sides
/// Animation: Slide up from bottom (300ms ease-out)
class InfoModal {
  static void show(
    BuildContext context, {
    required String title,
    required String body,
    IconData? icon,
    String? learnMoreText,
    VoidCallback? onLearnMore,
    String? actionButtonText,
    VoidCallback? onActionButton,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _InfoModalContent(
        title: title,
        body: body,
        icon: icon,
        learnMoreText: learnMoreText,
        onLearnMore: onLearnMore,
        actionButtonText: actionButtonText,
        onActionButton: onActionButton,
      ),
    );
  }
}

class _InfoModalContent extends StatelessWidget {
  final String title;
  final String body;
  final IconData? icon;
  final String? learnMoreText;
  final VoidCallback? onLearnMore;
  final String? actionButtonText;
  final VoidCallback? onActionButton;

  const _InfoModalContent({
    required this.title,
    required this.body,
    this.icon,
    this.learnMoreText,
    this.onLearnMore,
    this.actionButtonText,
    this.onActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final modalWidth = screenWidth * 0.9 < 400 ? screenWidth * 0.9 : 400.0;

    return Container(
      width: modalWidth,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close, size: 24),
              color: AppTheme.neutralGray700,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and Title
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 32,
                        color: AppTheme.primaryPurple,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.deepBlack,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Body text
                Text(
                  body,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.neutralGray700,
                    height: 1.5,
                  ),
                ),

                // Learn More link
                if (learnMoreText != null && onLearnMore != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      onLearnMore!();
                    },
                    child: Text(
                      learnMoreText!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryPurple,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],

                // Action button
                if (actionButtonText != null && onActionButton != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onActionButton!();
                      },
                      child: Text(actionButtonText!),
                    ),
                  ),
                ],

                // Bottom padding for safe area
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom + AppSpacing.md,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
