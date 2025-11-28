import 'package:flutter/material.dart';
import '../core/constants/api_constants.dart';
import 'api_service.dart';

/// Unified Profile Linking Service - Section 52
/// Handles profile detection, linking, and verification states for ALL platforms

/// Profile link states per Section 52.4
enum ProfileLinkState {
  /// User added profile via share/paste link
  linked,

  /// SilentID confirmed ownership via token
  verifiedToken,

  /// SilentID confirmed ownership via screenshot
  verifiedScreenshot,
}

/// Platform categories for organization
enum PlatformCategory {
  marketplace,
  social,
  professional,
  gaming,
  community,
  other,
}

/// Platform configuration for detection and display
class PlatformConfig {
  final String id;
  final String displayName;
  final PlatformCategory category;
  final IconData icon;
  final Color brandColor;
  final List<String> domainPatterns;
  final RegExp? usernameExtractor;
  final bool supportsTokenVerification;
  final String? tokenPlacementHint;

  const PlatformConfig({
    required this.id,
    required this.displayName,
    required this.category,
    required this.icon,
    required this.brandColor,
    required this.domainPatterns,
    this.usernameExtractor,
    this.supportsTokenVerification = true,
    this.tokenPlacementHint,
  });
}

/// Connected profile data model
class ConnectedProfile {
  final String id;
  final String platformId;
  final String username;
  final String profileUrl;
  final ProfileLinkState state;
  final DateTime connectedAt;
  final DateTime? verifiedAt;
  final bool isPublicOnPassport;

  const ConnectedProfile({
    required this.id,
    required this.platformId,
    required this.username,
    required this.profileUrl,
    required this.state,
    required this.connectedAt,
    this.verifiedAt,
    this.isPublicOnPassport = true,
  });

  bool get isVerified =>
      state == ProfileLinkState.verifiedToken ||
      state == ProfileLinkState.verifiedScreenshot;

  String get stateDisplayText {
    switch (state) {
      case ProfileLinkState.linked:
        return 'Linked';
      case ProfileLinkState.verifiedToken:
        return 'Verified (token)';
      case ProfileLinkState.verifiedScreenshot:
        return 'Verified (screenshot)';
    }
  }

  ConnectedProfile copyWith({
    String? id,
    String? platformId,
    String? username,
    String? profileUrl,
    ProfileLinkState? state,
    DateTime? connectedAt,
    DateTime? verifiedAt,
    bool? isPublicOnPassport,
  }) {
    return ConnectedProfile(
      id: id ?? this.id,
      platformId: platformId ?? this.platformId,
      username: username ?? this.username,
      profileUrl: profileUrl ?? this.profileUrl,
      state: state ?? this.state,
      connectedAt: connectedAt ?? this.connectedAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      isPublicOnPassport: isPublicOnPassport ?? this.isPublicOnPassport,
    );
  }
}

/// Profile detection result
class ProfileDetectionResult {
  final bool detected;
  final String? platformId;
  final String? username;
  final String? normalizedUrl;
  final String? error;

  const ProfileDetectionResult({
    required this.detected,
    this.platformId,
    this.username,
    this.normalizedUrl,
    this.error,
  });

  factory ProfileDetectionResult.success({
    required String platformId,
    required String username,
    required String normalizedUrl,
  }) {
    return ProfileDetectionResult(
      detected: true,
      platformId: platformId,
      username: username,
      normalizedUrl: normalizedUrl,
    );
  }

  factory ProfileDetectionResult.failed(String error) {
    return ProfileDetectionResult(
      detected: false,
      error: error,
    );
  }
}

/// Profile Linking Service - Singleton
class ProfileLinkingService {
  static final ProfileLinkingService _instance = ProfileLinkingService._();
  factory ProfileLinkingService() => _instance;
  ProfileLinkingService._();

  final ApiService _api = ApiService();

  /// All supported platforms per Section 52
  static final List<PlatformConfig> platforms = [
    // === MARKETPLACES ===
    PlatformConfig(
      id: 'vinted',
      displayName: 'Vinted',
      category: PlatformCategory.marketplace,
      icon: Icons.storefront_rounded,
      brandColor: const Color(0xFF09B1BA),
      domainPatterns: ['vinted.com', 'vinted.co.uk', 'vinted.fr', 'vinted.de'],
      usernameExtractor: RegExp(r'/member/(\d+)'),
      supportsTokenVerification: true,
      tokenPlacementHint: 'Add to your About section',
    ),
    PlatformConfig(
      id: 'ebay',
      displayName: 'eBay',
      category: PlatformCategory.marketplace,
      icon: Icons.shopping_bag_rounded,
      brandColor: const Color(0xFFE53238),
      domainPatterns: ['ebay.com', 'ebay.co.uk', 'ebay.de', 'ebay.fr'],
      usernameExtractor: RegExp(r'/usr/([^/?]+)'),
      supportsTokenVerification: true,
      tokenPlacementHint: 'Add to your About Me page',
    ),
    PlatformConfig(
      id: 'depop',
      displayName: 'Depop',
      category: PlatformCategory.marketplace,
      icon: Icons.local_mall_rounded,
      brandColor: const Color(0xFFFF2300),
      domainPatterns: ['depop.com'],
      usernameExtractor: RegExp(r'depop\.com/([^/?]+)'),
      supportsTokenVerification: true,
      tokenPlacementHint: 'Add to your bio',
    ),
    PlatformConfig(
      id: 'etsy',
      displayName: 'Etsy',
      category: PlatformCategory.marketplace,
      icon: Icons.store_rounded,
      brandColor: const Color(0xFFF56400),
      domainPatterns: ['etsy.com'],
      usernameExtractor: RegExp(r'/shop/([^/?]+)'),
      supportsTokenVerification: true,
      tokenPlacementHint: 'Add to your shop announcement',
    ),
    PlatformConfig(
      id: 'poshmark',
      displayName: 'Poshmark',
      category: PlatformCategory.marketplace,
      icon: Icons.checkroom_rounded,
      brandColor: const Color(0xFF7F0353),
      domainPatterns: ['poshmark.com', 'poshmark.co.uk'],
      usernameExtractor: RegExp(r'/closet/([^/?]+)'),
      supportsTokenVerification: true,
      tokenPlacementHint: 'Add to your About section',
    ),
    PlatformConfig(
      id: 'facebook_marketplace',
      displayName: 'Facebook Marketplace',
      category: PlatformCategory.marketplace,
      icon: Icons.facebook_rounded,
      brandColor: const Color(0xFF1877F2),
      domainPatterns: ['facebook.com/marketplace'],
      usernameExtractor: RegExp(r'/profile/(\d+)'),
      supportsTokenVerification: false, // FB restricts bio edits
      tokenPlacementHint: null,
    ),

    // === SOCIAL MEDIA ===
    PlatformConfig(
      id: 'instagram',
      displayName: 'Instagram',
      category: PlatformCategory.social,
      icon: Icons.camera_alt_rounded,
      brandColor: const Color(0xFFE4405F),
      domainPatterns: ['instagram.com'],
      usernameExtractor: RegExp(r'instagram\.com/([^/?]+)'),
      supportsTokenVerification: true,
      tokenPlacementHint: 'Add to your bio',
    ),
    PlatformConfig(
      id: 'tiktok',
      displayName: 'TikTok',
      category: PlatformCategory.social,
      icon: Icons.music_note_rounded,
      brandColor: const Color(0xFF000000),
      domainPatterns: ['tiktok.com'],
      usernameExtractor: RegExp(r'tiktok\.com/@([^/?]+)'),
      supportsTokenVerification: true,
      tokenPlacementHint: 'Add to your bio',
    ),
    PlatformConfig(
      id: 'twitter',
      displayName: 'X (Twitter)',
      category: PlatformCategory.social,
      icon: Icons.alternate_email_rounded,
      brandColor: const Color(0xFF000000),
      domainPatterns: ['twitter.com', 'x.com'],
      usernameExtractor: RegExp(r'(?:twitter|x)\.com/([^/?]+)'),
      supportsTokenVerification: true,
      tokenPlacementHint: 'Add to your bio',
    ),
    PlatformConfig(
      id: 'youtube',
      displayName: 'YouTube',
      category: PlatformCategory.social,
      icon: Icons.play_circle_rounded,
      brandColor: const Color(0xFFFF0000),
      domainPatterns: ['youtube.com'],
      usernameExtractor: RegExp(r'youtube\.com/(?:@|channel/|c/)([^/?]+)'),
      supportsTokenVerification: true,
      tokenPlacementHint: 'Add to your channel description',
    ),
    PlatformConfig(
      id: 'snapchat',
      displayName: 'Snapchat',
      category: PlatformCategory.social,
      icon: Icons.chat_bubble_rounded,
      brandColor: const Color(0xFFFFFC00),
      domainPatterns: ['snapchat.com'],
      usernameExtractor: RegExp(r'snapchat\.com/add/([^/?]+)'),
      supportsTokenVerification: false, // Limited bio options
      tokenPlacementHint: null,
    ),

    // === PROFESSIONAL ===
    PlatformConfig(
      id: 'linkedin',
      displayName: 'LinkedIn',
      category: PlatformCategory.professional,
      icon: Icons.work_rounded,
      brandColor: const Color(0xFF0A66C2),
      domainPatterns: ['linkedin.com'],
      usernameExtractor: RegExp(r'linkedin\.com/in/([^/?]+)'),
      supportsTokenVerification: true,
      tokenPlacementHint: 'Add to your About section',
    ),
    PlatformConfig(
      id: 'github',
      displayName: 'GitHub',
      category: PlatformCategory.professional,
      icon: Icons.code_rounded,
      brandColor: const Color(0xFF181717),
      domainPatterns: ['github.com'],
      usernameExtractor: RegExp(r'github\.com/([^/?]+)'),
      supportsTokenVerification: true,
      tokenPlacementHint: 'Add to your profile README or bio',
    ),

    // === GAMING ===
    PlatformConfig(
      id: 'discord',
      displayName: 'Discord',
      category: PlatformCategory.gaming,
      icon: Icons.headset_mic_rounded,
      brandColor: const Color(0xFF5865F2),
      domainPatterns: ['discord.com', 'discord.gg'],
      usernameExtractor: RegExp(r'discord\.(?:com|gg)/users/(\d+)'),
      supportsTokenVerification: true,
      tokenPlacementHint: 'Add to your About Me section',
    ),
    PlatformConfig(
      id: 'twitch',
      displayName: 'Twitch',
      category: PlatformCategory.gaming,
      icon: Icons.videogame_asset_rounded,
      brandColor: const Color(0xFF9146FF),
      domainPatterns: ['twitch.tv'],
      usernameExtractor: RegExp(r'twitch\.tv/([^/?]+)'),
      supportsTokenVerification: true,
      tokenPlacementHint: 'Add to your channel description',
    ),
    PlatformConfig(
      id: 'steam',
      displayName: 'Steam',
      category: PlatformCategory.gaming,
      icon: Icons.sports_esports_rounded,
      brandColor: const Color(0xFF171A21),
      domainPatterns: ['steamcommunity.com'],
      usernameExtractor: RegExp(r'steamcommunity\.com/(?:id|profiles)/([^/?]+)'),
      supportsTokenVerification: true,
      tokenPlacementHint: 'Add to your profile summary',
    ),

    // === COMMUNITY ===
    PlatformConfig(
      id: 'reddit',
      displayName: 'Reddit',
      category: PlatformCategory.community,
      icon: Icons.forum_rounded,
      brandColor: const Color(0xFFFF4500),
      domainPatterns: ['reddit.com'],
      usernameExtractor: RegExp(r'reddit\.com/user/([^/?]+)'),
      supportsTokenVerification: true,
      tokenPlacementHint: 'Add to your profile description',
    ),
  ];

  /// Get platform by ID
  PlatformConfig? getPlatformById(String id) {
    try {
      return platforms.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Get platforms by category
  List<PlatformConfig> getPlatformsByCategory(PlatformCategory category) {
    return platforms.where((p) => p.category == category).toList();
  }

  /// Detect platform from URL
  ProfileDetectionResult detectProfileFromUrl(String url) {
    final normalizedUrl = url.trim().toLowerCase();

    for (final platform in platforms) {
      for (final domain in platform.domainPatterns) {
        if (normalizedUrl.contains(domain)) {
          // Extract username if possible
          String? username;
          if (platform.usernameExtractor != null) {
            final match = platform.usernameExtractor!.firstMatch(url);
            username = match?.group(1);
          }

          return ProfileDetectionResult.success(
            platformId: platform.id,
            username: username ?? 'Unknown',
            normalizedUrl: url.trim(),
          );
        }
      }
    }

    return ProfileDetectionResult.failed(
      'Could not detect platform from URL. Please check the link.',
    );
  }

  /// Generate verification token via API
  /// Returns the token from the backend after creating/updating the profile link
  Future<String> generateVerificationToken(String profileId) async {
    final response = await _api.post(
      ApiConstants.profileLinkGenerateToken(profileId),
    );
    return response.data['verificationToken'] ?? '';
  }

  /// Confirm token verification via API
  /// User has added token to their profile bio, backend will scrape and verify
  Future<ConnectedProfile> confirmTokenVerification({
    required String profileId,
    required String scrapedBioText,
  }) async {
    final response = await _api.post(
      ApiConstants.profileLinkConfirmToken(profileId),
      data: {'scrapedBioText': scrapedBioText},
    );
    return _parseProfileLinkResponse(response.data);
  }

  /// Link a profile (creates Linked state) via API
  Future<ConnectedProfile> linkProfile({
    required String platformId,
    required String username,
    required String profileUrl,
  }) async {
    // Map platformId to backend Platform enum value
    final platformEnumValue = _mapPlatformIdToEnum(platformId);

    final response = await _api.post(
      ApiConstants.profileLinks,
      data: {
        'url': profileUrl,
        'platform': platformEnumValue,
        'username': username,
      },
    );
    return _parseProfileLinkResponse(response.data);
  }

  /// Get all connected profiles for current user via API
  Future<List<ConnectedProfile>> getConnectedProfiles() async {
    final response = await _api.get(ApiConstants.profileLinks);
    final profileLinks = response.data['profileLinks'] as List<dynamic>? ?? [];
    return profileLinks
        .map((p) => _parseProfileLinkResponse(p as Map<String, dynamic>))
        .toList();
  }

  /// Remove a connected profile via API
  Future<void> removeProfile(String profileId) async {
    await _api.delete(ApiConstants.profileLinkById(profileId));
  }

  /// Toggle profile visibility on public passport via API
  Future<ConnectedProfile> togglePassportVisibility(
    ConnectedProfile profile,
  ) async {
    final response = await _api.patch(
      ApiConstants.profileLinkVisibility(profile.id),
      data: {'showOnPassport': !profile.isPublicOnPassport},
    );
    return _parseProfileLinkResponse(response.data);
  }

  /// Verify if verification token exists in profile bio
  /// Scrapes profile URL and checks if token is present
  /// Returns true if token found, false otherwise
  Future<bool> verifyTokenInProfile(String profileId) async {
    try {
      // Backend will scrape the profile URL and verify token presence
      final response = await _api.post(
        ApiConstants.profileLinkConfirmToken(profileId),
        data: {'checkOnly': true},
      );
      return response.data['tokenFound'] == true;
    } catch (e) {
      return false;
    }
  }

  /// Upgrade a linked profile to verified status
  /// Used after successful token or screenshot verification
  Future<ConnectedProfile> upgradeToVerified({
    required ConnectedProfile profile,
    required ProfileLinkState verificationMethod,
  }) async {
    final methodString = verificationMethod == ProfileLinkState.verifiedToken
        ? 'TokenInBio'
        : 'Screenshot';

    final response = await _api.post(
      ApiConstants.profileLinkConfirmToken(profile.id),
      data: {
        'verificationMethod': methodString,
        'confirmUpgrade': true,
      },
    );
    return _parseProfileLinkResponse(response.data);
  }

  /// Parse API response to ConnectedProfile model
  ConnectedProfile _parseProfileLinkResponse(Map<String, dynamic> json) {
    // Map backend linkState to ProfileLinkState enum
    ProfileLinkState state;
    final linkState = json['linkState'] as String? ?? 'Linked';
    final verificationMethod = json['verificationMethod'] as String?;

    if (linkState == 'Verified' || json['verificationLevel'] == 3) {
      state = verificationMethod == 'TokenInBio'
          ? ProfileLinkState.verifiedToken
          : ProfileLinkState.verifiedScreenshot;
    } else {
      state = ProfileLinkState.linked;
    }

    // Map backend platform enum to platformId
    final platformId = _mapPlatformEnumToId(json['platform']);

    return ConnectedProfile(
      id: json['id']?.toString() ?? '',
      platformId: platformId,
      username: json['username'] ?? '',
      profileUrl: json['url'] ?? '',
      state: state,
      connectedAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      verifiedAt: json['ownershipLockedAt'] != null
          ? DateTime.tryParse(json['ownershipLockedAt'])
          : null,
      isPublicOnPassport: json['showOnPassport'] ?? true,
    );
  }

  /// Map platformId to backend Platform enum value
  int _mapPlatformIdToEnum(String platformId) {
    // Backend Platform enum values (based on Platform.cs)
    const platformMap = {
      'vinted': 0,
      'ebay': 1,
      'depop': 2,
      'etsy': 3,
      'poshmark': 4,
      'facebook_marketplace': 5,
      'instagram': 6,
      'tiktok': 7,
      'twitter': 8,
      'youtube': 9,
      'snapchat': 10,
      'linkedin': 11,
      'github': 12,
      'discord': 13,
      'twitch': 14,
      'steam': 15,
      'reddit': 16,
    };
    return platformMap[platformId] ?? 0;
  }

  /// Map backend Platform enum to platformId
  String _mapPlatformEnumToId(dynamic platform) {
    // Handle both int and string values
    final platformValue = platform is int ? platform : int.tryParse(platform?.toString() ?? '0') ?? 0;
    const platformMap = {
      0: 'vinted',
      1: 'ebay',
      2: 'depop',
      3: 'etsy',
      4: 'poshmark',
      5: 'facebook_marketplace',
      6: 'instagram',
      7: 'tiktok',
      8: 'twitter',
      9: 'youtube',
      10: 'snapchat',
      11: 'linkedin',
      12: 'github',
      13: 'discord',
      14: 'twitch',
      15: 'steam',
      16: 'reddit',
    };
    return platformMap[platformValue] ?? 'unknown';
  }

  /// Get mock connected profiles for demo/standalone screens
  List<ConnectedProfile> getMockConnectedProfiles() {
    final now = DateTime.now();
    return [
      ConnectedProfile(
        id: 'mock-1',
        platformId: 'instagram',
        username: '@johndoe',
        profileUrl: 'https://instagram.com/johndoe',
        state: ProfileLinkState.verifiedToken,
        connectedAt: now.subtract(const Duration(days: 30)),
        verifiedAt: now.subtract(const Duration(days: 28)),
        isPublicOnPassport: true,
      ),
      ConnectedProfile(
        id: 'mock-2',
        platformId: 'vinted',
        username: 'johndoe_vinted',
        profileUrl: 'https://www.vinted.co.uk/member/12345',
        state: ProfileLinkState.verifiedScreenshot,
        connectedAt: now.subtract(const Duration(days: 20)),
        verifiedAt: now.subtract(const Duration(days: 18)),
        isPublicOnPassport: true,
      ),
      ConnectedProfile(
        id: 'mock-3',
        platformId: 'linkedin',
        username: 'john-doe-123',
        profileUrl: 'https://linkedin.com/in/john-doe-123',
        state: ProfileLinkState.linked,
        connectedAt: now.subtract(const Duration(days: 10)),
        isPublicOnPassport: true,
      ),
      ConnectedProfile(
        id: 'mock-4',
        platformId: 'depop',
        username: '@johndepop',
        profileUrl: 'https://depop.com/johndepop',
        state: ProfileLinkState.linked,
        connectedAt: now.subtract(const Duration(days: 5)),
        isPublicOnPassport: false,
      ),
    ];
  }
}
