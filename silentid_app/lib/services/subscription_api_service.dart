import '../core/constants/api_constants.dart';
import 'api_service.dart';

/// Subscription API Service
/// Handles subscription-related API calls
class SubscriptionApiService {
  final ApiService _api = ApiService();

  /// Get current user's subscription
  Future<SubscriptionInfo> getSubscription() async {
    final response = await _api.get(ApiConstants.subscriptionMe);
    return SubscriptionInfo.fromJson(response.data);
  }

  /// Upgrade subscription to a new tier
  Future<SubscriptionInfo> upgradeSubscription({
    required String tier,
    required String paymentMethodId,
  }) async {
    final response = await _api.post(
      ApiConstants.subscriptionUpgrade,
      data: {
        'tier': tier,
        'paymentMethodId': paymentMethodId,
      },
    );
    return SubscriptionInfo.fromJson(response.data);
  }

  /// Cancel current subscription
  Future<SubscriptionInfo> cancelSubscription() async {
    final response = await _api.post(ApiConstants.subscriptionCancel);
    return SubscriptionInfo.fromJson(response.data);
  }
}

/// Subscription info model
class SubscriptionInfo {
  final String tier;
  final String status;
  final DateTime? renewalDate;
  final DateTime? cancelAt;
  final DateTime createdAt;
  final String? message;

  SubscriptionInfo({
    required this.tier,
    required this.status,
    this.renewalDate,
    this.cancelAt,
    required this.createdAt,
    this.message,
  });

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfo(
      tier: json['tier'] ?? 'Free',
      status: json['status'] ?? 'Active',
      renewalDate: json['renewalDate'] != null
          ? DateTime.tryParse(json['renewalDate'])
          : null,
      cancelAt: json['cancelAt'] != null
          ? DateTime.tryParse(json['cancelAt'])
          : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      message: json['message'],
    );
  }

  /// Check if subscription is active
  bool get isActive => status.toLowerCase() == 'active';

  /// Check if subscription is cancelled but still usable
  bool get isCancelled => cancelAt != null;

  /// Check if user has premium features
  bool get isPremium => tier.toLowerCase() == 'premium' || tier.toLowerCase() == 'pro';

  /// Check if user has pro features
  bool get isPro => tier.toLowerCase() == 'pro';

  /// Get display price based on tier
  double get monthlyPrice {
    switch (tier.toLowerCase()) {
      case 'pro':
        return 9.99;
      case 'premium':
        return 4.99;
      default:
        return 0.0;
    }
  }

  /// Get formatted renewal date
  String get formattedRenewalDate {
    if (renewalDate == null) return 'N/A';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${renewalDate!.day} ${months[renewalDate!.month - 1]} ${renewalDate!.year}';
  }

  /// Get list of benefits based on tier
  List<String> get benefits {
    switch (tier.toLowerCase()) {
      case 'pro':
        return [
          'Everything in Premium',
          'Unlimited evidence uploads',
          'API access for integrations',
          'White-label passport sharing',
          'Priority support',
          '500GB Evidence Vault',
        ];
      case 'premium':
        return [
          'Unlimited evidence uploads',
          'Advanced TrustScore breakdown',
          'Trust Timeline & Analytics',
          'Premium profile badge',
          '100GB Evidence Vault',
          'Priority evidence processing',
        ];
      default:
        return [
          'Basic TrustScore',
          '10 evidence uploads/month',
          'Standard processing',
          '1GB Evidence Vault',
        ];
    }
  }
}
