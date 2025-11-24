/// Public Profile Model
///
/// Represents a public SilentID profile that can be viewed by anyone.
/// Maps to PublicProfileDto from PublicController (Section 9).
///
/// PRIVACY-SAFE: Never contains email, phone, address, ID documents.
class PublicProfile {
  final String username; // @username format
  final String displayName; // "Sarah M."
  final int trustScore; // 0-1000
  final String trustScoreLabel; // "Very High Trust", "High Trust", etc.
  final bool identityVerified;
  final String accountAge; // "180 days", "Today", etc.
  final List<String> verifiedPlatforms; // ["Vinted", "eBay", "Depop"]
  final int verifiedTransactionCount;
  final int mutualVerificationCount;
  final List<String> badges; // ["Identity Verified", "500+ verified transactions"]
  final String? riskWarning; // ⚠️ Safety concern message (if any)
  final DateTime createdAt;

  const PublicProfile({
    required this.username,
    required this.displayName,
    required this.trustScore,
    required this.trustScoreLabel,
    required this.identityVerified,
    required this.accountAge,
    required this.verifiedPlatforms,
    required this.verifiedTransactionCount,
    required this.mutualVerificationCount,
    required this.badges,
    this.riskWarning,
    required this.createdAt,
  });

  /// Parse from API response (GET /v1/public/profile/{username})
  factory PublicProfile.fromJson(Map<String, dynamic> json) {
    return PublicProfile(
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      trustScore: json['trustScore'] as int,
      trustScoreLabel: json['trustScoreLabel'] as String,
      identityVerified: json['identityVerified'] as bool,
      accountAge: json['accountAge'] as String,
      verifiedPlatforms: (json['verifiedPlatforms'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      verifiedTransactionCount: json['verifiedTransactionCount'] as int,
      mutualVerificationCount: json['mutualVerificationCount'] as int,
      badges:
          (json['badges'] as List<dynamic>).map((e) => e as String).toList(),
      riskWarning: json['riskWarning'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert to JSON (rarely needed, but useful for caching)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'displayName': displayName,
      'trustScore': trustScore,
      'trustScoreLabel': trustScoreLabel,
      'identityVerified': identityVerified,
      'accountAge': accountAge,
      'verifiedPlatforms': verifiedPlatforms,
      'verifiedTransactionCount': verifiedTransactionCount,
      'mutualVerificationCount': mutualVerificationCount,
      'badges': badges,
      'riskWarning': riskWarning,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Get username without @ prefix for API calls
  String get cleanUsername => username.startsWith('@') ? username.substring(1) : username;

  /// Get profile URL for sharing
  String get profileUrl => 'https://silentid.co.uk/u/$cleanUsername';

  /// Check if profile has safety concerns
  bool get hasSafetyWarning => riskWarning != null && riskWarning!.isNotEmpty;

  /// Get TrustScore color based on score band
  /// Section 3: TrustScore ranges
  String get trustScoreColor {
    if (trustScore >= 801) return '#1FBF71'; // Success Green
    if (trustScore >= 601) return '#5A3EB8'; // Primary Purple
    if (trustScore >= 401) return '#FFC043'; // Warning Amber
    return '#D04C4C'; // Danger Red
  }
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
