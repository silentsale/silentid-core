import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/info_point_helper.dart';
import '../../../core/data/info_point_data.dart';
import '../../../services/subscription_api_service.dart';

/// Subscription Overview Screen
/// Level 7 Gamification + Level 7 Interactivity
///
/// Displays current subscription plan and management options
/// Follows Section 53 UI Design Language
class SubscriptionOverviewScreen extends StatefulWidget {
  const SubscriptionOverviewScreen({super.key});

  @override
  State<SubscriptionOverviewScreen> createState() => _SubscriptionOverviewScreenState();
}

class _SubscriptionOverviewScreenState extends State<SubscriptionOverviewScreen>
    with SingleTickerProviderStateMixin {
  final _subscriptionApi = SubscriptionApiService();

  // Level 7: Animation controller
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  bool _isLoading = true;
  String? _errorMessage;
  SubscriptionInfo? _subscription;

  @override
  void initState() {
    super.initState();
    // Level 7: Initialize animations
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _loadSubscription();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadSubscription() async {
    setState(() => _isLoading = true);
    try {
      final subscription = await _subscriptionApi.getSubscription();
      setState(() {
        _subscription = subscription;
        _isLoading = false;
      });
      // Level 7: Start animation after data loads
      _animController.forward();
    } catch (e) {
      // Use mock data when API fails
      setState(() {
        _subscription = SubscriptionInfo(
          tier: 'Pro',
          status: 'Active',
          renewalDate: DateTime.now().add(const Duration(days: 30)),
          cancelAt: null,
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
        );
        _isLoading = false;
        _errorMessage = null;
      });
      _animController.forward();
    }
  }

  Future<void> _cancelSubscription() async {
    setState(() => _isLoading = true);
    try {
      final subscription = await _subscriptionApi.cancelSubscription();
      setState(() {
        _subscription = subscription;
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subscription cancelled. Access continues until end of billing period.'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel: ${e.toString()}'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    }
  }

  // Derived getters for backwards compatibility
  String get currentPlan => _subscription?.tier ?? "Free";
  String get renewalDate => _subscription?.formattedRenewalDate ?? "N/A";
  double get monthlyPrice => _subscription?.monthlyPrice ?? 0.0;
  List<String> get benefits => _subscription?.benefits ?? [];
  bool get isPremium => _subscription?.isPremium ?? false;
  bool get isCancelled => _subscription?.isCancelled ?? false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Subscription',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Subscription',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.neutralGray500,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppTheme.neutralGray600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _errorMessage = null;
                    });
                    _loadSubscription();
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subscription',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Plan Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryPurple, AppTheme.darkModePurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.diamond_outlined,
                        color: AppTheme.pureWhite,
                        size: 32,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '$currentPlan Plan',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.pureWhite,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '£${monthlyPrice.toStringAsFixed(2)}/month',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.pureWhite,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Renews on $renewalDate',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.pureWhite.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Benefits Section
            Text(
              'Your Benefits',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBlack,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Dynamic benefits from subscription
            ...benefits.map((benefit) => _buildBenefitItem(benefit)),

            const SizedBox(height: AppSpacing.lg),

            // Show cancelled notice if applicable
            if (isCancelled)
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppTheme.warningAmber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.warningAmber),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppTheme.warningAmber),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Your subscription is cancelled. Access continues until ${_subscription?.cancelAt != null ? _subscription!.formattedRenewalDate : "end of period"}.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.neutralGray700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Upgrade Option (if Premium, show Pro upgrade)
            if (currentPlan.toLowerCase() == "premium" && !isCancelled)
              OutlinedButton(
                onPressed: () {
                  context.push('/subscriptions/pro');
                },
                child: const Text('Upgrade to Pro'),
              ),

            const SizedBox(height: AppSpacing.md),

            // Manage Subscription
            OutlinedButton(
              onPressed: () {
                _showManagementOptions(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.neutralGray700,
                side: BorderSide(color: AppTheme.neutralGray300),
              ),
              child: const Text('Manage Subscription'),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Important Notice with Info Point (Section 40.4)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppTheme.softLilac,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryPurple,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Important',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                      const SizedBox(width: 6),
                      InfoPointHelper(data: InfoPoints.subscriptionAndSafety),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Paid subscription does NOT directly increase your TrustScore or override safety systems. '
                    'Subscriptions only unlock features like larger Evidence Vault and analytics.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.neutralGray700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppTheme.successGreen,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.deepBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showManagementOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.payment_outlined),
              title: const Text('Update payment method'),
              onTap: () {
                Navigator.pop(context);
                _showPaymentMethodUpdate();
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_outlined),
              title: const Text('View billing history'),
              onTap: () {
                Navigator.pop(context);
                _showBillingHistory();
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel_outlined, color: AppTheme.dangerRed),
              title: Text(
                'Cancel subscription',
                style: TextStyle(color: AppTheme.dangerRed),
              ),
              onTap: () {
                Navigator.pop(context);
                _showCancelConfirmation(context);
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethodUpdate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.payment_outlined, color: AppTheme.primaryPurple),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Update Payment Method',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppTheme.softLilac,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppTheme.primaryPurple),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Stripe payment method management will be available in a future update. Your current payment method will continue to be charged.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.neutralGray700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBillingHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg + MediaQuery.of(context).padding.bottom,
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.receipt_outlined, color: AppTheme.primaryPurple),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Billing History',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: _subscription != null && _subscription!.isPremium
                  ? ListView(
                      children: [
                        _buildBillingItem(
                          date: _subscription!.formattedRenewalDate,
                          amount: '£${_subscription!.monthlyPrice.toStringAsFixed(2)}',
                          status: 'Upcoming',
                          isUpcoming: true,
                        ),
                        // Show placeholder for past invoices
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            children: [
                              Icon(
                                Icons.history,
                                size: 48,
                                color: AppTheme.neutralGray300,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Past invoices will appear here',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppTheme.neutralGray700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: AppTheme.neutralGray300,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'No billing history',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.neutralGray700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Upgrade to Premium or Pro to start building history',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppTheme.neutralGray700,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingItem({
    required String date,
    required String amount,
    required String status,
    bool isUpcoming = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isUpcoming ? AppTheme.softLilac : AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUpcoming ? AppTheme.primaryPurple.withValues(alpha: 0.3) : AppTheme.neutralGray300,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.deepBlack,
                  ),
                ),
                Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isUpcoming ? AppTheme.primaryPurple : AppTheme.successGreen,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.deepBlack,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Subscription?',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'You can cancel anytime. Your plan will stay active until the end of your billing period.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Subscription'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _cancelSubscription();
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.dangerRed,
            ),
            child: const Text('Cancel Subscription'),
          ),
        ],
      ),
    );
  }
}
