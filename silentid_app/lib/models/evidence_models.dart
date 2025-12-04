// Evidence data models for SilentID
// NOTE: Receipt and Screenshot classes removed - feature removed from MVP

class ProfileLink {
  final String id;
  final String url;
  final String platform;
  final String? scrapeDataJson;
  final int usernameMatchScore;
  final int integrityScore;
  final String evidenceState;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProfileLink({
    required this.id,
    required this.url,
    required this.platform,
    this.scrapeDataJson,
    required this.usernameMatchScore,
    required this.integrityScore,
    required this.evidenceState,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProfileLink.fromJson(Map<String, dynamic> json) {
    return ProfileLink(
      id: json['id'],
      url: json['url'],
      platform: json['platform'],
      scrapeDataJson: json['scrapeDataJson'],
      usernameMatchScore: json['usernameMatchScore'],
      integrityScore: json['integrityScore'],
      evidenceState: json['evidenceState'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}

class EvidenceSummary {
  final int profileLinksCount;

  EvidenceSummary({
    required this.profileLinksCount,
  });

  factory EvidenceSummary.fromJson(Map<String, dynamic> json) {
    return EvidenceSummary(
      profileLinksCount: json['profileLinksCount'] ?? 0,
    );
  }
}
