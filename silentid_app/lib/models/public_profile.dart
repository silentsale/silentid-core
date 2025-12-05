import '../core/widgets/public_connected_profiles.dart';

/// Platform Rating from Level 3 Verified Profile (Section 47/49)
///
/// Represents star ratings extracted from verified marketplace profiles.
/// Only shown for Level 3 verified profiles.
class PlatformRating {
  final String platform; // "Vinted", "eBay", "Depop"
  final double rating; // Raw rating value (4.9 or 99.2)
  final int reviewCount; // Total number of reviews
  final String displayRating; // Formatted: "4.9 ★" or "99.2% positive"
  final DateTime lastUpdated;
  final bool isLevel3Verified; // True if ownership verified

  const PlatformRating({
    required this.platform,
    required this.rating,
    required this.reviewCount,
    required this.displayRating,
    required this.lastUpdated,
    required this.isLevel3Verified,
  });

  factory PlatformRating.fromJson(Map<String, dynamic> json) {
    return PlatformRating(
      platform: json['platform'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      displayRating: json['displayRating'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isLevel3Verified: json['isLevel3Verified'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'rating': rating,
      'reviewCount': reviewCount,
      'displayRating': displayRating,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isLevel3Verified': isLevel3Verified,
    };
  }

  /// Get platform icon based on name
  String get platformIcon {
    switch (platform.toLowerCase()) {
      case 'vinted':
        return '👗';
      case 'ebay':
        return '🛒';
      case 'depop':
        return '📱';
      case 'etsy':
        return '🎨';
      case 'facebook marketplace':
        return '📘';
      case 'poshmark':
        return '👠';
      default:
        return '🏪';
    }
  }
}

/// Public Profile Model
///
/// Represents a public SilentID profile that can be viewed by anyone.
/// Maps to PublicProfileDto from PublicController (Section 9).
///
/// PRIVACY-SAFE: Never contains email, phone, address, ID documents.
/// TrustScore visibility controlled by user privacy settings.
class PublicProfile {
  final String userId; // User ID for API operations (e.g., report concern)
  final String username; // @username format
  final String displayName; // "Sarah M."
  final int? trustScore; // 0-1000, NULL if user hides it
  final String? trustScoreLabel; // "Very High Trust", etc., NULL if hidden
  final bool identityVerified;
  final String accountAge; // "180 days", "Today", etc.
  final List<String> verifiedPlatforms; // ["Vinted", "eBay", "Depop"]
  final int verifiedTransactionCount;
  final List<String> badges; // ["Identity Verified", "500+ verified transactions"]
  final String? riskWarning; // ⚠️ Safety concern message (if any)
  final DateTime createdAt;
  final List<PlatformRating> platformRatings; // Section 47: Star ratings from verified profiles
  final bool trustScoreVisible; // Whether user allows TrustScore to be shown
  final List<PublicConnectedProfile> connectedProfiles; // Section 52.6: Linked/Verified external profiles

  const PublicProfile({
    required this.userId,
    required this.username,
    required this.displayName,
    this.trustScore,
    this.trustScoreLabel,
    required this.identityVerified,
    required this.accountAge,
    required this.verifiedPlatforms,
    required this.verifiedTransactionCount,
    required this.badges,
    this.riskWarning,
    required this.createdAt,
    this.platformRatings = const [],
    this.trustScoreVisible = false,
    this.connectedProfiles = const [],
  });

  /// Parse from API response (GET /v1/public/profile/{username})
  factory PublicProfile.fromJson(Map<String, dynamic> json) {
    // Parse platform ratings if present
    final platformRatingsJson = json['platformRatings'] as List<dynamic>?;
    final platformRatings = platformRatingsJson
            ?.map((e) => PlatformRating.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    // Parse connected profiles (Section 52.6)
    final connectedProfilesJson = json['connectedProfiles'] as List<dynamic>?;
    final connectedProfiles = connectedProfilesJson
            ?.map((e) => PublicConnectedProfile.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return PublicProfile(
      userId: json['userId'] as String? ?? '',
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      trustScore: json['trustScore'] as int?, // Now nullable
      trustScoreLabel: json['trustScoreLabel'] as String?, // Now nullable
      identityVerified: json['identityVerified'] as bool,
      accountAge: json['accountAge'] as String,
      verifiedPlatforms: (json['verifiedPlatforms'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      verifiedTransactionCount: json['verifiedTransactionCount'] as int,
      badges:
          (json['badges'] as List<dynamic>).map((e) => e as String).toList(),
      riskWarning: json['riskWarning'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      platformRatings: platformRatings,
      trustScoreVisible: json['trustScoreVisible'] as bool? ?? false,
      connectedProfiles: connectedProfiles,
    );
  }

  /// Convert to JSON (rarely needed, but useful for caching)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'displayName': displayName,
      'trustScore': trustScore,
      'trustScoreLabel': trustScoreLabel,
      'identityVerified': identityVerified,
      'accountAge': accountAge,
      'verifiedPlatforms': verifiedPlatforms,
      'verifiedTransactionCount': verifiedTransactionCount,
      'badges': badges,
      'riskWarning': riskWarning,
      'createdAt': createdAt.toIso8601String(),
      'platformRatings': platformRatings.map((r) => r.toJson()).toList(),
      'trustScoreVisible': trustScoreVisible,
      'connectedProfiles': connectedProfiles.map((p) => p.toJson()).toList(),
    };
  }

  /// Get username without @ prefix for API calls
  String get cleanUsername => username.startsWith('@') ? username.substring(1) : username;

  /// Get profile URL for sharing
  String get profileUrl => 'https://silentid.co.uk/u/$cleanUsername';

  /// Check if profile has safety concerns
  bool get hasSafetyWarning => riskWarning != null && riskWarning!.isNotEmpty;

  /// Check if TrustScore should be displayed
  bool get shouldShowTrustScore => trustScoreVisible && trustScore != null;

  /// Check if profile has verified platform ratings
  bool get hasPlatformRatings => platformRatings.isNotEmpty;

  /// Get only Level 3 verified platform ratings
  List<PlatformRating> get level3VerifiedRatings =>
      platformRatings.where((r) => r.isLevel3Verified).toList();

  /// Check if profile has connected external profiles (Section 52.6)
  bool get hasConnectedProfiles => connectedProfiles.isNotEmpty;

  /// Get verified connected profiles count
  int get verifiedConnectedProfilesCount =>
      connectedProfiles.where((p) => p.isVerified).length;

  /// Get linked (not verified) connected profiles count
  int get linkedConnectedProfilesCount =>
      connectedProfiles.where((p) => !p.isVerified).length;

  /// Get TrustScore color based on score band
  /// Section 3: TrustScore ranges
  String get trustScoreColor {
    final score = trustScore ?? 0;
    if (score >= 801) return '#1FBF71'; // Success Green
    if (score >= 601) return '#5A3EB8'; // Primary Purple
    if (score >= 401) return '#FFC043'; // Warning Amber
    return '#D04C4C'; // Danger Red
  }

  /// Calculate combined star rating from all Level 3 verified platforms
  /// Returns average of all platform ratings (on 5-star scale)
  double? get combinedStarRating {
    final verified = level3VerifiedRatings;
    if (verified.isEmpty) return null;

    // Filter only star-based ratings (0-5 scale, not percentage)
    final starRatings = verified.where((r) => r.rating <= 5.0).toList();
    if (starRatings.isEmpty) return null;

    final sum = starRatings.fold<double>(0, (prev, r) => prev + r.rating);
    return sum / starRatings.length;
  }

  /// Get number of platforms contributing to combined rating
  int get combinedRatingPlatformCount {
    return level3VerifiedRatings.where((r) => r.rating <= 5.0).length;
  }

  /// Check if profile has a combined star rating to show
  bool get hasCombinedStarRating =>
      combinedStarRating != null && combinedRatingPlatformCount > 0;
}

/// Username Availability Response
///
/// Used for checking if a username is available during registration.
class UsernameAvailability {
  final String username;
  final bool available;
  final List<String> suggestions;

  const UsernameAvailability({
    required this.username,
    required this.available,
    required this.suggestions,
  });

  factory UsernameAvailability.fromJson(Map<String, dynamic> json) {
    return UsernameAvailability(
      username: json['username'] as String,
      available: json['available'] as bool,
      suggestions: (json['suggestions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }
}
