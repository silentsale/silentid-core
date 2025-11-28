import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../services/subscription_api_service.dart';

/// Upgrade to Premium Screen
///
/// Displays Premium subscription benefits and upgrade flow
/// Following Section 12 & 16 specifications
class UpgradePremiumScreen extends StatefulWidget {
  const UpgradePremiumScreen({super.key});

  @override
  State<UpgradePremiumScreen> createState() => _UpgradePremiumScreenState();
}

class _UpgradePremiumScreenState extends State<UpgradePremiumScreen> {
  final _subscriptionApi = SubscriptionApiService();
  bool _isLoading = false;

  Future<void> _handleUpgrade() async {
    setState(() => _isLoading = true);

    try {
      // Show payment method collection dialog
      // In production, this would use Stripe Payment Sheet
      final confirmed = await _showPaymentConfirmation();

      if (confirmed == true) {
        // Call backend to upgrade subscription
        // Note: In production, paymentMethodId would come from Stripe Payment Sheet
        await _subscriptionApi.upgradeSubscription(
          tier: 'Premium',
          paymentMethodId: 'pm_placeholder', // Would be real Stripe payment method
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Welcome to SilentID Premium!'),
              backgroundColor: AppTheme.successGreen,
            ),
          );
          Navigator.pop(context, true); // Return success
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upgrade failed: ${e.toString()}'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool?> _showPaymentConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Upgrade',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are upgrading to SilentID Premium at £4.99/month.',
              style: GoogleFonts.inter(),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.softLilac,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryPurple,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Stripe payment integration coming soon. This is a preview of the upgrade flow.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.neutralGray700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upgrade to Premium',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Premium Badge
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.softLilac,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.diamond_outlined,
                            color: AppTheme.primaryPurple,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'SilentID Premium',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Pricing
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '£4.99',
                          style: GoogleFonts.inter(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.deepBlack,
                          ),
                        ),
                        Text(
                          'per month',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: AppTheme.neutralGray700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Description
                  Text(
                    'Get deeper insights into your trust profile, a larger evidence vault, and powerful tools to prove your reliability everywhere you trade.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppTheme.neutralGray700,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Benefits
                  Text(
                    'What\'s Included',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.deepBlack,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _buildBenefitItem(
                    icon: Icons.cloud_upload_outlined,
                    title: 'Unlimited Evidence',
                    subtitle: 'Upload unlimited screenshots and receipts',
                  ),

                  _buildBenefitItem(
                    icon: Icons.analytics_outlined,
                    title: 'Advanced TrustScore Breakdown',
                    subtitle: 'Detailed reasons and component analysis',
                  ),

                  _buildBenefitItem(
                    icon: Icons.timeline_outlined,
                    title: 'Trust Timeline & Analytics',
                    subtitle: 'Graphs and platform-by-platform stats',
                  ),

                  _buildBenefitItem(
                    icon: Icons.workspace_premium_outlined,
                    title: 'Premium Profile Badge',
                    subtitle: 'Show your commitment to trust',
                  ),

                  _buildBenefitItem(
                    icon: Icons.folder_special_outlined,
                    title: '100GB Evidence Vault',
                    subtitle: 'Store all your trust evidence',
                  ),

                  _buildBenefitItem(
                    icon: Icons.fast_forward_outlined,
                    title: 'Priority Evidence Processing',
                    subtitle: 'Faster verification of your evidence',
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Important Notice
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppTheme.softLilac,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                      ),
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
                          'Paid subscription does NOT override safety systems or directly increase your TrustScore. '
                          'Premium unlocks features and tools, but your trust reputation is always earned through verified evidence and behavior.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.neutralGray700,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),

          // Bottom CTA Section
          Container(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: AppTheme.pureWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleUpgrade,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.pureWhite,
                          ),
                        )
                      : const Text('Get Premium — £4.99/month'),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'You can cancel anytime. Your plan will stay active until the end of the current billing period.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppTheme.softLilac,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryPurple,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepBlack,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
