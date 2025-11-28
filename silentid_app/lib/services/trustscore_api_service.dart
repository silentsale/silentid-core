import '../core/constants/api_constants.dart';
import 'api_service.dart';

/// TrustScore API Service
/// Handles all TrustScore-related API calls
class TrustScoreApiService {
  final ApiService _api = ApiService();

  /// Get current user's TrustScore summary
  Future<TrustScoreSummary> getTrustScore() async {
    final response = await _api.get(ApiConstants.trustScoreMe);
    return TrustScoreSummary.fromJson(response.data);
  }

  /// Get detailed TrustScore breakdown with all components
  Future<TrustScoreBreakdownResponse> getTrustScoreBreakdown() async {
    final response = await _api.get(ApiConstants.trustScoreBreakdown);
    return TrustScoreBreakdownResponse.fromJson(response.data);
  }

  /// Get TrustScore history for specified months
  Future<TrustScoreHistoryResponse> getTrustScoreHistory({int months = 6}) async {
    final response = await _api.get(
      '${ApiConstants.trustScoreMe}/history?months=$months',
    );
    return TrustScoreHistoryResponse.fromJson(response.data);
  }

  /// Manually trigger TrustScore recalculation
  Future<TrustScoreSummary> recalculateTrustScore() async {
    final response = await _api.post('${ApiConstants.trustScoreMe}/recalculate');
    return TrustScoreSummary.fromJson(response.data);
  }
}

/// TrustScore summary response model (3-component: Identity 250, Evidence 400, Behaviour 350)
class TrustScoreSummary {
  final int totalScore;
  final String label;
  final int identityScore;
  final int evidenceScore;
  final int behaviourScore;
  final DateTime? lastCalculated;

  TrustScoreSummary({
    required this.totalScore,
    required this.label,
    required this.identityScore,
    required this.evidenceScore,
    required this.behaviourScore,
    this.lastCalculated,
  });

  factory TrustScoreSummary.fromJson(Map<String, dynamic> json) {
    return TrustScoreSummary(
      totalScore: json['totalScore'] ?? 0,
      label: json['label'] ?? 'Unknown',
      identityScore: json['identityScore'] ?? 0,
      evidenceScore: json['evidenceScore'] ?? 0,
      behaviourScore: json['behaviourScore'] ?? 0,
      lastCalculated: json['lastCalculated'] != null
          ? DateTime.tryParse(json['lastCalculated'])
          : null,
    );
  }
}

/// TrustScore breakdown response model (3-component model)
class TrustScoreBreakdownResponse {
  final int totalScore;
  final String label;
  final ComponentBreakdown identity;
  final ComponentBreakdown evidence;
  final ComponentBreakdown behaviour;

  TrustScoreBreakdownResponse({
    required this.totalScore,
    required this.label,
    required this.identity,
    required this.evidence,
    required this.behaviour,
  });

  factory TrustScoreBreakdownResponse.fromJson(Map<String, dynamic> json) {
    final components = json['components'] as Map<String, dynamic>? ?? {};
    return TrustScoreBreakdownResponse(
      totalScore: json['totalScore'] ?? 0,
      label: json['label'] ?? 'Unknown',
      identity: ComponentBreakdown.fromJson(
          components['identity'] as Map<String, dynamic>? ?? {}),
      evidence: ComponentBreakdown.fromJson(
          components['evidence'] as Map<String, dynamic>? ?? {}),
      behaviour: ComponentBreakdown.fromJson(
          components['behaviour'] as Map<String, dynamic>? ?? {}),
    );
  }

  /// Convert to Map format for UI compatibility
  Map<String, dynamic> toUiFormat() {
    return {
      'totalScore': totalScore,
      'level': label,
      'components': {
        'identity': identity.toUiFormat(),
        'evidence': evidence.toUiFormat(),
        'behaviour': behaviour.toUiFormat(),
      },
    };
  }
}

/// Component breakdown model (identity, evidence, behaviour)
class ComponentBreakdown {
  final int score;
  final int maxScore;
  final List<ScoreItemResponse> items;

  ComponentBreakdown({
    required this.score,
    required this.maxScore,
    required this.items,
  });

  factory ComponentBreakdown.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    return ComponentBreakdown(
      score: json['score'] ?? 0,
      maxScore: json['maxScore'] ?? 0,
      items: itemsList
          .map((i) => ScoreItemResponse.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convert to Map format for UI compatibility
  Map<String, dynamic> toUiFormat() {
    return {
      'score': score,
      'max': maxScore,
      'items': items.map((i) => i.toUiFormat()).toList(),
    };
  }
}

/// Individual score item model
class ScoreItemResponse {
  final String description;
  final int points;
  final String status; // "completed", "warning", "missing"

  ScoreItemResponse({
    required this.description,
    required this.points,
    required this.status,
  });

  factory ScoreItemResponse.fromJson(Map<String, dynamic> json) {
    return ScoreItemResponse(
      description: json['description'] ?? '',
      points: json['points'] ?? 0,
      status: json['status'] ?? 'missing',
    );
  }

  /// Convert to Map format for UI compatibility
  /// Maps backend status to UI status format
  Map<String, dynamic> toUiFormat() {
    // Backend uses: "completed", "warning", "missing"
    // UI expects: "positive", "negative", "neutral"
    String uiStatus;
    switch (status.toLowerCase()) {
      case 'completed':
        uiStatus = 'positive';
        break;
      case 'warning':
        uiStatus = 'negative';
        break;
      default:
        uiStatus = 'neutral';
    }
    return {
      'label': description,
      'points': points,
      'status': uiStatus,
    };
  }
}

/// TrustScore history response model
class TrustScoreHistoryResponse {
  final List<TrustScoreSnapshot> snapshots;
  final int count;

  TrustScoreHistoryResponse({
    required this.snapshots,
    required this.count,
  });

  factory TrustScoreHistoryResponse.fromJson(Map<String, dynamic> json) {
    final snapshotsList = json['snapshots'] as List<dynamic>? ?? [];
    return TrustScoreHistoryResponse(
      snapshots: snapshotsList
          .map((s) => TrustScoreSnapshot.fromJson(s as Map<String, dynamic>))
          .toList(),
      count: json['count'] ?? 0,
    );
  }
}

/// Individual TrustScore snapshot for history (3-component model)
class TrustScoreSnapshot {
  final int score;
  final int identityScore;
  final int evidenceScore;
  final int behaviourScore;
  final DateTime date;

  TrustScoreSnapshot({
    required this.score,
    required this.identityScore,
    required this.evidenceScore,
    required this.behaviourScore,
    required this.date,
  });

  factory TrustScoreSnapshot.fromJson(Map<String, dynamic> json) {
    return TrustScoreSnapshot(
      score: json['score'] ?? 0,
      identityScore: json['identityScore'] ?? 0,
      evidenceScore: json['evidenceScore'] ?? 0,
      behaviourScore: json['behaviourScore'] ?? 0,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    );
  }
}
