import 'dart:io';
import '../models/safety_report.dart';
import 'api_service.dart';

class SafetyService {
  final ApiService _apiService;

  SafetyService(this._apiService);

  /// Create a new safety report
  Future<String> createReport(CreateReportRequest request) async {
    try {
      final response = await _apiService.post(
        '/v1/reports',
        data: request.toJson(),
      );
      return response.data['id'] as String;
    } catch (e) {
      throw Exception('Failed to create report: ${e.toString()}');
    }
  }

  /// Upload evidence file for a report
  /// Note: For now, we're using a placeholder URL since file upload to Azure Blob
  /// requires additional infrastructure (upload URL generation, Azure connection)
  /// In production, this should:
  /// 1. Get signed upload URL from backend
  /// 2. Upload file to Azure Blob Storage
  /// 3. Submit fileUrl to backend
  Future<void> uploadEvidence(String reportId, File file) async {
    try {
      // TODO: Replace with actual Azure Blob upload
      // For now, using local file path as placeholder
      final fileUrl = 'pending-upload://${file.path.split('/').last}';
      final fileType = file.path.split('.').last;

      await _apiService.post(
        '/v1/reports/$reportId/evidence',
        data: {
          'fileUrl': fileUrl,
          'fileType': fileType,
        },
      );
    } catch (e) {
      throw Exception('Failed to upload evidence: ${e.toString()}');
    }
  }

  /// Get all reports filed by current user
  Future<List<SafetyReport>> getMyReports() async {
    try {
      final response = await _apiService.get('/v1/reports/mine');

      // Backend returns: { reports: [...], count: 5 }
      if (response.data is Map && response.data['reports'] is List) {
        return (response.data['reports'] as List)
            .map((json) => SafetyReport.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to load reports: ${e.toString()}');
    }
  }

  /// Get specific report by ID
  Future<SafetyReport> getById(String id) async {
    try {
      final response = await _apiService.get('/v1/reports/$id');
      return SafetyReport.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load report details: ${e.toString()}');
    }
  }
}
