import '../core/constants/api_constants.dart';
import 'api_service.dart';

/// Receipt API Service
/// Handles email receipt forwarding feature (Section 47.4 - Expensify Model)
class ReceiptApiService {
  final ApiService _api = ApiService();

  /// Get user's unique forwarding email address and setup instructions
  Future<ForwardingAliasInfo> getForwardingAlias() async {
    final response = await _api.get('${ApiConstants.apiBaseUrl}/receipts/forwarding-alias');
    return ForwardingAliasInfo.fromJson(response.data);
  }

  /// Get all receipts for the user
  Future<ReceiptListResponse> getReceipts() async {
    final response = await _api.get('${ApiConstants.apiBaseUrl}/receipts');
    return ReceiptListResponse.fromJson(response.data);
  }

  /// Get receipt count
  Future<int> getReceiptCount() async {
    final response = await _api.get('${ApiConstants.apiBaseUrl}/receipts/count');
    return response.data['validCount'] ?? 0;
  }
}

/// Forwarding alias information with setup instructions
class ForwardingAliasInfo {
  final String forwardingEmail;
  final SetupInstructions instructions;
  final List<SupportedPlatform> supportedPlatforms;

  ForwardingAliasInfo({
    required this.forwardingEmail,
    required this.instructions,
    required this.supportedPlatforms,
  });

  factory ForwardingAliasInfo.fromJson(Map<String, dynamic> json) {
    return ForwardingAliasInfo(
      forwardingEmail: json['forwardingEmail'] ?? '',
      instructions: SetupInstructions.fromJson(json['instructions'] ?? {}),
      supportedPlatforms: (json['supportedPlatforms'] as List<dynamic>?)
              ?.map((p) => SupportedPlatform.fromJson(p))
              .toList() ??
          [],
    );
  }
}

/// Setup instructions for different email providers
class SetupInstructions {
  final List<String> gmail;
  final List<String> outlook;
  final List<String> manual;

  SetupInstructions({
    required this.gmail,
    required this.outlook,
    required this.manual,
  });

  factory SetupInstructions.fromJson(Map<String, dynamic> json) {
    return SetupInstructions(
      gmail: List<String>.from(json['gmail'] ?? []),
      outlook: List<String>.from(json['outlook'] ?? []),
      manual: List<String>.from(json['manual'] ?? []),
    );
  }
}

/// Supported marketplace platform
class SupportedPlatform {
  final String name;
  final String domain;
  final String icon;

  SupportedPlatform({
    required this.name,
    required this.domain,
    required this.icon,
  });

  factory SupportedPlatform.fromJson(Map<String, dynamic> json) {
    return SupportedPlatform(
      name: json['name'] ?? '',
      domain: json['domain'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

/// Response containing list of receipts
class ReceiptListResponse {
  final List<Receipt> receipts;
  final int totalCount;
  final int validCount;

  ReceiptListResponse({
    required this.receipts,
    required this.totalCount,
    required this.validCount,
  });

  factory ReceiptListResponse.fromJson(Map<String, dynamic> json) {
    return ReceiptListResponse(
      receipts: (json['receipts'] as List<dynamic>?)
              ?.map((r) => Receipt.fromJson(r))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
      validCount: json['validCount'] ?? 0,
    );
  }
}

/// Individual receipt evidence
class Receipt {
  final String id;
  final String platform;
  final String? orderId;
  final String? item;
  final double amount;
  final String currency;
  final String role;
  final DateTime date;
  final int integrityScore;
  final String status;
  final DateTime createdAt;

  Receipt({
    required this.id,
    required this.platform,
    this.orderId,
    this.item,
    required this.amount,
    required this.currency,
    required this.role,
    required this.date,
    required this.integrityScore,
    required this.status,
    required this.createdAt,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'] ?? '',
      platform: json['platform'] ?? 'Other',
      orderId: json['orderId'],
      item: json['item'],
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'GBP',
      role: json['role'] ?? 'Buyer',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      integrityScore: json['integrityScore'] ?? 0,
      status: json['status'] ?? 'Valid',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Get platform icon
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
      case 'paypal':
        return '💳';
      case 'stripe':
        return '💰';
      case 'facebookmarketplace':
        return '📘';
      default:
        return '📧';
    }
  }

  /// Get formatted amount with currency symbol
  String get formattedAmount {
    final symbol = currency == 'GBP' ? '£' : (currency == 'EUR' ? '€' : '\$');
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Check if this is a valid receipt
  bool get isValid => status == 'Valid';
}
