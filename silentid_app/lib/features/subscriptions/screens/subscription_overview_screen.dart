import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_spacing.dart';

/// Subscription Overview Screen
///
/// Displays current subscription plan and management options
class SubscriptionOverviewScreen extends StatelessWidget {
  const SubscriptionOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - replace with actual state management
    final String currentPlan = "Premium";
    final String renewalDate = "21 Dec 2025";
    final double monthlyPrice = 4.99;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subscription',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
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

            _buildBenefitItem('Unlimited evidence uploads'),
            _buildBenefitItem('Advanced TrustScore breakdown'),
            _buildBenefitItem('Trust Timeline & Analytics'),
            _buildBenefitItem('Premium profile badge'),
            _buildBenefitItem('100GB Evidence Vault'),
            _buildBenefitItem('Priority evidence processing'),

            const SizedBox(height: AppSpacing.lg),

            // Upgrade Option (if Premium, show Pro upgrade)
            if (currentPlan == "Premium")
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/subscriptions/pro');
                },
                child: const Text('Upgrade to Pro'),
              ),

            const SizedBox(height: AppSpacing.md),

            // Manage Subscription
            OutlinedButton(
              onPressed: () {
                // TODO: Show subscription management options
                _showManagementOptions(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.neutralGray700,
                side: BorderSide(color: AppTheme.neutralGray300),
              ),
              child: const Text('Manage Subscription'),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Important Notice
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
                // TODO: Navigate to payment method update
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_outlined),
              title: const Text('View billing history'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to billing history
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
            onPressed: () {
              Navigator.pop(context);
              // TODO: Handle cancellation
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
