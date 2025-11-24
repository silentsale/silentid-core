class SafetyReport {
  final String id;
  final String reporterId;
  final String reportedUserId;
  final String category;
  final String description;
  final String status;
  final DateTime createdAt;
  final List<ReportEvidence>? evidence;

  // Display properties
  final String? reportedUserName;
  final String? reportedUserUsername;

  SafetyReport({
    required this.id,
    required this.reporterId,
    required this.reportedUserId,
    required this.category,
    required this.description,
    required this.status,
    required this.createdAt,
    this.evidence,
    this.reportedUserName,
    this.reportedUserUsername,
  });

  factory SafetyReport.fromJson(Map<String, dynamic> json) {
    // Backend returns nested reportedUser object
    final reportedUser = json['reportedUser'] as Map<String, dynamic>?;

    return SafetyReport(
      id: json['id'] as String,
      reporterId: json['reporterId'] as String? ?? '',
      reportedUserId: json['reportedUserId'] as String? ?? reportedUser?['id'] as String? ?? '',
      category: json['category'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['filedAt'] ?? json['createdAt'] as String),
      evidence: json['evidence'] != null
          ? (json['evidence'] as List)
              .map((e) => ReportEvidence.fromJson(e))
              .toList()
          : null,
      reportedUserName: reportedUser?['displayName'] as String?,
      reportedUserUsername: reportedUser?['username'] as String?,
    );
  }

  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending Review';
      case 'underreview':
        return 'Under Review';
      case 'verified':
        return 'Verified';
      case 'dismissed':
        return 'Dismissed';
      default:
        return status;
    }
  }

  String get categoryLabel {
    switch (category) {
      case 'ItemNotReceived':
        return 'Item not received';
      case 'AggressiveBehaviour':
        return 'Aggressive behaviour';
      case 'FraudConcern':
        return 'Fraud concern';
      case 'PaymentIssue':
        return 'Payment issue';
      case 'Other':
        return 'Other concern';
      default:
        return category;
    }
  }

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isUnderReview => status.toLowerCase() == 'underreview';
  bool get isVerified => status.toLowerCase() == 'verified';
  bool get isDismissed => status.toLowerCase() == 'dismissed';
}

class ReportEvidence {
  final String id;
  final String reportId;
  final String fileUrl;
  final String? ocrText;
  final DateTime createdAt;

  ReportEvidence({
    required this.id,
    required this.reportId,
    required this.fileUrl,
    this.ocrText,
    required this.createdAt,
  });

  factory ReportEvidence.fromJson(Map<String, dynamic> json) {
    return ReportEvidence(
      id: json['id'] as String,
      reportId: json['reportId'] as String,
      fileUrl: json['fileUrl'] as String,
      ocrText: json['ocrText'] as String?,
      createdAt: DateTime.parse(json['uploadedAt'] ?? json['createdAt'] as String),
    );
  }
}

class CreateReportRequest {
  final String reportedUserIdentifier;
  final String category;
  final String description;

  CreateReportRequest({
    required this.reportedUserIdentifier,
    required this.category,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'reportedUserIdentifier': reportedUserIdentifier,
      'category': category,
      'description': description,
    };
  }
}
