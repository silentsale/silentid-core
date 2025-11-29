import 'dart:io';
import 'api_service.dart';

/// Service for support tickets.
/// Provides a unified help system accessible anywhere in the app.
class SupportService {
  final ApiService _apiService;

  SupportService(this._apiService);

  /// Create a new support ticket.
  Future<SupportTicketResult> createTicket({
    required SupportCategory category,
    required String message,
    String? contactEmail,
    String? subject,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/support/tickets',
        data: {
          'category': category.value,
          'message': message,
          'contactEmail': contactEmail,
          'subject': subject,
          'deviceInfo': _getBasicDeviceInfo(),
          'appVersion': 'SilentID 1.0.0',
          'platform': Platform.isIOS ? 'iOS' : Platform.isAndroid ? 'Android' : 'Unknown',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return SupportTicketResult(
          success: data['success'] ?? true,
          message: data['message'] ?? 'Thanks — our support team will review this shortly.',
          ticketId: data['ticketId'],
        );
      } else {
        final data = response.data as Map<String, dynamic>;
        return SupportTicketResult(
          success: false,
          message: data['error'] ?? 'Failed to create ticket',
        );
      }
    } catch (e) {
      return SupportTicketResult(
        success: false,
        message: 'Network error. Please try again.',
      );
    }
  }

  /// Get the current user's tickets.
  Future<List<SupportTicketSummary>> getMyTickets() async {
    try {
      final response = await _apiService.get('/api/support/tickets');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((t) => SupportTicketSummary.fromJson(t as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  String _getBasicDeviceInfo() {
    if (Platform.isIOS) {
      return 'iOS Device';
    } else if (Platform.isAndroid) {
      return 'Android Device';
    }
    return 'Unknown device';
  }
}

/// Support ticket categories.
enum SupportCategory {
  accountLogin(1, 'Account/Login'),
  verificationHelp(2, 'Verification Help'),
  technicalIssue(3, 'Technical Issue'),
  generalQuestion(4, 'General Question'),
  billing(5, 'Billing/Subscription'),
  privacyData(6, 'Privacy/Data');

  const SupportCategory(this.value, this.displayText);
  final int value;
  final String displayText;
}

/// Result of creating a support ticket.
class SupportTicketResult {
  final bool success;
  final String message;
  final String? ticketId;

  SupportTicketResult({
    required this.success,
    required this.message,
    this.ticketId,
  });
}

/// Summary of a support ticket.
class SupportTicketSummary {
  final String id;
  final String category;
  final String subject;
  final String status;
  final DateTime createdAt;

  SupportTicketSummary({
    required this.id,
    required this.category,
    required this.subject,
    required this.status,
    required this.createdAt,
  });

  factory SupportTicketSummary.fromJson(Map<String, dynamic> json) {
    return SupportTicketSummary(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      subject: json['subject'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
