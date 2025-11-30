import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/shared_link_controller.dart';
import '../../features/profiles/widgets/share_import_modal.dart';

/// ShareListenerWrapper - Section 55
/// Wraps the app to listen for incoming shared links and show the import modal
/// Must be placed inside the MaterialApp's widget tree to access context

class ShareListenerWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const ShareListenerWrapper({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ShareListenerWrapper> createState() =>
      _ShareListenerWrapperState();
}

class _ShareListenerWrapperState extends ConsumerState<ShareListenerWrapper> {
  SharedLinkData? _lastShownLink;

  @override
  void initState() {
    super.initState();
    // Initialize the controller by reading it once
    // This ensures listeners are set up
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sharedLinkControllerProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for shared link state changes
    ref.listen<SharedLinkState>(
      sharedLinkControllerProvider,
      (previous, next) {
        // Show modal when we have a new pending link
        if (next.pendingLink != null &&
            !next.isProcessing &&
            next.pendingLink != _lastShownLink) {
          _lastShownLink = next.pendingLink;
          _showImportModal(context);
        }
      },
    );

    return widget.child;
  }

  void _showImportModal(BuildContext context) {
    // Delay slightly to ensure navigation is complete
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && context.mounted) {
        showShareImportModal(context);
      }
    });
  }
}

/// Global navigator key for showing modals from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Show share import modal using global navigator (for use outside widget tree)
void showShareImportModalGlobal() {
  final context = navigatorKey.currentContext;
  if (context != null) {
    showShareImportModal(context);
  }
}
