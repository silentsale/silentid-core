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

  /// Upload evidence file for a report
  Future<void> uploadEvidence(String reportId, File file) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      await _apiService.post(
        '/v1/reports/$reportId/evidence',
        data: formData,
      );
    } catch (e) {
      throw Exception('Failed to upload evidence: ${e.toString()}');
    }
  }

  /// Get all reports filed by current user
  Future<List<SafetyReport>> getMyReports() async {
    try {
      final response = await _apiService.get('/v1/reports/mine');

      if (response.data is List) {
        return (response.data as List)
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
