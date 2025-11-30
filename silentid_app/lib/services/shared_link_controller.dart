import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'profile_linking_service.dart';

/// SharedLinkController - Share Target Handler
/// Listens for incoming shared URLs from other apps and routes to profile connection flow
/// Per Section 55: Share Target Integration

/// Shared link data model
class SharedLinkData {
  final String rawText;
  final String? extractedUrl;
  final ProfileDetectionResult? detectionResult;
  final DateTime receivedAt;
  final String source; // 'android_intent', 'ios_share_extension', 'deep_link'

  SharedLinkData({
    required this.rawText,
    this.extractedUrl,
    this.detectionResult,
    required this.receivedAt,
    required this.source,
  });

  bool get hasValidProfile =>
      detectionResult != null && detectionResult!.detected;

  String get platformName {
    if (detectionResult?.platformId == null) return 'Unknown';
    final platform =
        ProfileLinkingService().getPlatformById(detectionResult!.platformId!);
    return platform?.displayName ?? 'Unknown';
  }
}

/// Shared link state for UI
class SharedLinkState {
  final SharedLinkData? pendingLink;
  final bool isProcessing;
  final String? error;

  const SharedLinkState({
    this.pendingLink,
    this.isProcessing = false,
    this.error,
  });

  SharedLinkState copyWith({
    SharedLinkData? pendingLink,
    bool? isProcessing,
    String? error,
    bool clearPending = false,
  }) {
    return SharedLinkState(
      pendingLink: clearPending ? null : (pendingLink ?? this.pendingLink),
      isProcessing: isProcessing ?? this.isProcessing,
      error: error,
    );
  }
}

/// SharedLinkController - manages incoming shared links
class SharedLinkController extends StateNotifier<SharedLinkState> {
  SharedLinkController() : super(const SharedLinkState()) {
    _initListeners();
  }

  final ProfileLinkingService _profileService = ProfileLinkingService();

  StreamSubscription? _intentSubscription;
  StreamSubscription? _initialMediaSubscription;

  /// Initialize share intent listeners
  void _initListeners() {
    // Listen for shared text while app is running (foreground)
    _intentSubscription =
        ReceiveSharingIntent.instance.getMediaStream().listen(
      (List<SharedMediaFile> files) {
        _handleSharedMedia(files, 'android_intent');
      },
      onError: (err) {
        debugPrint('SharedLinkController: Error receiving share intent: $err');
      },
    );

    // Get initial shared text when app starts from share intent
    ReceiveSharingIntent.instance.getInitialMedia().then((files) {
      if (files.isNotEmpty) {
        _handleSharedMedia(files, 'android_intent');
      }
    });
  }

  /// Handle incoming shared media/text
  void _handleSharedMedia(List<SharedMediaFile> files, String source) {
    if (files.isEmpty) return;

    state = state.copyWith(isProcessing: true, error: null);

    try {
      // Get the first text item (we only care about URLs)
      String? sharedText;
      for (final file in files) {
        if (file.type == SharedMediaType.text || file.type == SharedMediaType.url) {
          sharedText = file.path;
          break;
        }
      }

      if (sharedText == null || sharedText.isEmpty) {
        state = state.copyWith(
          isProcessing: false,
          error: 'No text or URL found in shared content',
        );
        return;
      }

      _processSharedText(sharedText, source);
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: 'Failed to process shared content: $e',
      );
    }
  }

  /// Process shared text from deep link (silentid://import?url=...)
  void handleDeepLink(Uri uri) {
    if (uri.scheme != 'silentid') return;

    if (uri.host == 'import' || uri.path == '/import') {
      final encodedUrl = uri.queryParameters['url'];
      if (encodedUrl != null && encodedUrl.isNotEmpty) {
        final decodedUrl = Uri.decodeComponent(encodedUrl);
        _processSharedText(decodedUrl, 'deep_link');
      }
    }
  }

  /// Process shared text - extract URL and detect platform
  void _processSharedText(String text, String source) {
    state = state.copyWith(isProcessing: true, error: null);

    // Extract URL from text (handles cases where URL is part of larger text)
    final extractedUrl = _extractUrlFromText(text);

    if (extractedUrl == null) {
      state = state.copyWith(
        isProcessing: false,
        error: 'No valid URL found in shared content',
      );
      return;
    }

    // Validate URL security
    if (!_isUrlSafe(extractedUrl)) {
      state = state.copyWith(
        isProcessing: false,
        error: 'URL appears unsafe and cannot be processed',
      );
      return;
    }

    // Detect platform from URL
    final detection = _profileService.detectProfileFromUrl(extractedUrl);

    final sharedData = SharedLinkData(
      rawText: text,
      extractedUrl: extractedUrl,
      detectionResult: detection,
      receivedAt: DateTime.now(),
      source: source,
    );

    state = state.copyWith(
      pendingLink: sharedData,
      isProcessing: false,
      error: detection.detected ? null : detection.error,
    );

    debugPrint(
      'SharedLinkController: Processed shared link - '
      'Platform: ${sharedData.platformName}, '
      'URL: $extractedUrl, '
      'Detected: ${detection.detected}',
    );
  }

  /// Extract URL from text (handles various formats)
  String? _extractUrlFromText(String text) {
    // Common URL patterns
    final urlRegex = RegExp(
      r'https?://[^\s<>"{}|\\^`\[\]]+',
      caseSensitive: false,
    );

    final match = urlRegex.firstMatch(text);
    if (match != null) {
      String url = match.group(0)!;
      // Clean trailing punctuation that might be captured
      url = url.replaceAll(RegExp(r'[.,;:!?)\]]+$'), '');
      return url;
    }

    // If no http(s) prefix, try to detect bare domain patterns
    final bareUrlRegex = RegExp(
      r'(?:www\.)?(?:vinted|ebay|depop|etsy|instagram|tiktok|twitter|x|linkedin|github|discord|twitch|youtube|reddit|steamcommunity|poshmark|snapchat)\.(?:com|co\.uk|tv|gg|de|fr)[^\s]*',
      caseSensitive: false,
    );

    final bareMatch = bareUrlRegex.firstMatch(text);
    if (bareMatch != null) {
      return 'https://${bareMatch.group(0)}';
    }

    return null;
  }

  /// Basic URL safety validation
  bool _isUrlSafe(String url) {
    try {
      final uri = Uri.parse(url);

      // Must be http or https
      if (uri.scheme != 'http' && uri.scheme != 'https') {
        return false;
      }

      // Block localhost and internal IPs
      final host = uri.host.toLowerCase();
      if (host == 'localhost' ||
          host.startsWith('127.') ||
          host.startsWith('192.168.') ||
          host.startsWith('10.') ||
          host.startsWith('172.16.')) {
        return false;
      }

      // Block file:// and javascript: schemes that might slip through
      if (url.toLowerCase().contains('javascript:') ||
          url.toLowerCase().contains('file://')) {
        return false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  /// Clear pending link (after user dismisses or processes it)
  void clearPendingLink() {
    state = state.copyWith(clearPending: true, error: null);
    // Reset the sharing intent to prevent duplicate processing
    ReceiveSharingIntent.instance.reset();
  }

  /// Mark link as being processed (user chose to connect)
  void markAsProcessing() {
    state = state.copyWith(isProcessing: true);
  }

  /// Check if there's a pending link to process
  bool get hasPendingLink =>
      state.pendingLink != null && !state.isProcessing;

  /// Get the pending platform ID for navigation
  String? get pendingPlatformId => state.pendingLink?.detectionResult?.platformId;

  /// Get the pending URL for profile connection
  String? get pendingUrl => state.pendingLink?.extractedUrl;

  /// Get the pending username (if detected)
  String? get pendingUsername =>
      state.pendingLink?.detectionResult?.username;

  @override
  void dispose() {
    _intentSubscription?.cancel();
    _initialMediaSubscription?.cancel();
    super.dispose();
  }
}

/// Provider for SharedLinkController
final sharedLinkControllerProvider =
    StateNotifierProvider<SharedLinkController, SharedLinkState>((ref) {
  return SharedLinkController();
});

/// Provider to check if there's a pending shared link
final hasPendingSharedLinkProvider = Provider<bool>((ref) {
  final state = ref.watch(sharedLinkControllerProvider);
  return state.pendingLink != null &&
      state.pendingLink!.hasValidProfile &&
      !state.isProcessing;
});
