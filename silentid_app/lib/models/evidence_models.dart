// Evidence data models for SilentID

class Receipt {
  final String id;
  final String platform;
  final String? item;
  final double amount;
  final String currency;
  final String role;
  final DateTime date;
  final int integrityScore;
  final String evidenceState;
  final DateTime createdAt;

  Receipt({
    required this.id,
    required this.platform,
    this.item,
    required this.amount,
    required this.currency,
    required this.role,
    required this.date,
    required this.integrityScore,
    required this.evidenceState,
    required this.createdAt,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      platform: json['platform'],
      item: json['item'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
      role: json['role'],
      date: DateTime.parse(json['date']),
      integrityScore: json['integrityScore'],
      evidenceState: json['evidenceState'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Screenshot {
  final String id;
  final String fileUrl;
  final String platform;
  final String? ocrText;
  final int integrityScore;
  final bool fraudFlag;
  final String evidenceState;
  final DateTime createdAt;

  Screenshot({
    required this.id,
    required this.fileUrl,
    required this.platform,
    this.ocrText,
    required this.integrityScore,
    required this.fraudFlag,
    required this.evidenceState,
    required this.createdAt,
  });

  factory Screenshot.fromJson(Map<String, dynamic> json) {
    return Screenshot(
      id: json['id'],
      fileUrl: json['fileUrl'],
      platform: json['platform'],
      ocrText: json['ocrText'],
      integrityScore: json['integrityScore'],
      fraudFlag: json['fraudFlag'],
      evidenceState: json['evidenceState'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

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
  final int receiptsCount;
  final int screenshotsCount;
  final int profileLinksCount;

  EvidenceSummary({
    required this.receiptsCount,
    required this.screenshotsCount,
    required this.profileLinksCount,
  });

  factory EvidenceSummary.fromJson(Map<String, dynamic> json) {
    return EvidenceSummary(
      receiptsCount: json['receiptsCount'] ?? 0,
      screenshotsCount: json['screenshotsCount'] ?? 0,
      profileLinksCount: json['profileLinksCount'] ?? 0,
    );
  }
}
