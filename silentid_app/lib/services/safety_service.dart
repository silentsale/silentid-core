import 'dart:io';
import 'package:dio/dio.dart';
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

  /// Upload evidence file for a report using multipart form upload
  /// The backend handles Azure Blob Storage upload internally via BlobStorageService
  Future<void> uploadEvidence(String reportId, File file) async {
    try {
      final fileName = file.path.split('/').last;
      final fileType = _getContentType(fileName);

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: DioMediaType.parse(fileType),
        ),
        'reportId': reportId,
      });

      await _apiService.uploadMultipart(
        '/v1/reports/$reportId/evidence/upload',
        formData: formData,
      );
    } catch (e) {
      throw Exception('Failed to upload evidence: ${e.toString()}');
    }
  }

  /// Get content type from filename
  String _getContentType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
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
