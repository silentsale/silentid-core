import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../services/shared_link_controller.dart';
import '../../../services/profile_linking_service.dart';

/// Share Import Modal - Section 55
/// Shown when user shares a link to SilentID from another app
/// Displays detected platform and offers to connect profile

class ShareImportModal extends ConsumerWidget {
  const ShareImportModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharedLinkState = ref.watch(sharedLinkControllerProvider);
    final controller = ref.read(sharedLinkControllerProvider.notifier);

    if (sharedLinkState.pendingLink == null) {
      return const SizedBox.shrink();
    }

    final pendingLink = sharedLinkState.pendingLink!;
    final hasValidProfile = pendingLink.hasValidProfile;
    final platformId = pendingLink.detectionResult?.platformId;
    final platform = platformId != null
        ? ProfileLinkingService().getPlatformById(platformId)
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Icon/Platform logo
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: hasValidProfile
                        ? (platform?.brandColor ?? AppTheme.primaryPurple)
                            .withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    hasValidProfile
                        ? (platform?.icon ?? Icons.link_rounded)
                        : Icons.link_off_rounded,
                    size: 32,
                    color: hasValidProfile
                        ? (platform?.brandColor ?? AppTheme.primaryPurple)
                        : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Title
              Text(
                hasValidProfile
                    ? 'Profile Link Detected'
                    : 'Link Not Recognized',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),

              // Subtitle/Description
              Text(
                hasValidProfile
                    ? 'We detected a ${pendingLink.platformName} profile link. Would you like to connect it to your SilentID?'
                    : 'The shared link doesn\'t appear to be from a supported platform.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),

              if (hasValidProfile) ...[
                const SizedBox(height: AppSpacing.md),

                // Profile preview card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: (platform?.brandColor ?? AppTheme.primaryPurple)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          platform?.icon ?? Icons.person_rounded,
                          color: platform?.brandColor ?? AppTheme.primaryPurple,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              platform?.displayName ?? 'Unknown Platform',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            if (pendingLink.detectionResult?.username !=
                                    null &&
                                pendingLink.detectionResult!.username !=
                                    'Unknown') ...[
                              const SizedBox(height: 2),
                              Text(
                                '@${pendingLink.detectionResult!.username}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.lg),

              // Actions
              if (hasValidProfile) ...[
                PrimaryButton(
                  text: 'Connect Profile',
                  onPressed: () {
                    controller.markAsProcessing();
                    Navigator.of(context).pop();
                    // Navigate to add profile screen with pre-filled URL (Section 55)
                    context.push(
                      '/profiles/add',
                      extra: {
                        'platformId': platformId,
                        'url': pendingLink.extractedUrl,
                        'username': pendingLink.detectionResult?.username,
                        'fromShare': true,
                      },
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () {
                    controller.clearPendingLink();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Not Now',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ] else ...[
                PrimaryButton(
                  text: 'Close',
                  isSecondary: true,
                  onPressed: () {
                    controller.clearPendingLink();
                    Navigator.of(context).pop();
                  },
                ),
              ],

              // Info point
              const SizedBox(height: AppSpacing.md),
              _buildInfoPoint(
                context,
                hasValidProfile
                    ? 'Connecting a profile helps build your trust score. Verify it later to maximize points.'
                    : 'SilentID supports marketplaces, social media, and professional platforms.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPoint(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 16,
          color: Colors.grey[500],
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ),
      ],
    );
  }
}

/// Show the share import modal as a bottom sheet
Future<void> showShareImportModal(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const ShareImportModal(),
  );
}
