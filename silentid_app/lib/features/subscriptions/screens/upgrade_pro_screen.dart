import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_messages.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../services/subscription_api_service.dart';

/// Upgrade to Pro Screen
/// Level 7 Gamification + Level 7 Interactivity
///
/// Displays Pro subscription benefits and upgrade flow
/// Following Section 12 & 16 specifications
class UpgradeProScreen extends StatefulWidget {
  const UpgradeProScreen({super.key});

  @override
  State<UpgradeProScreen> createState() => _UpgradeProScreenState();
}

class _UpgradeProScreenState extends State<UpgradeProScreen>
    with SingleTickerProviderStateMixin {
  final _subscriptionApi = SubscriptionApiService();

  // Level 7: Animation controller
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  bool _isLoading = false;

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
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

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
          tier: 'Pro',
          paymentMethodId: 'pm_placeholder', // Would be real Stripe payment method
        );

        if (mounted) {
          AppMessages.showSuccess(context, 'Welcome to SilentID Pro!');
          Navigator.pop(context, true); // Return success
        }
      }
    } catch (e) {
      if (mounted) {
        AppMessages.showError(context, ErrorMessages.fromException(e, fallbackAction: 'upgrade to Pro'));
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
              'You are upgrading to SilentID Pro at £14.99/month.',
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
          'Upgrade to Pro',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pro Badge
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryPurple, AppTheme.darkModePurple],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.workspace_premium,
                            color: AppTheme.pureWhite,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'SilentID Pro',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.pureWhite,
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
                          '£14.99',
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
                    'Built for power sellers and community leaders',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.deepBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  Text(
                    'Manage risk at scale, present a professional trust profile, and export organised evidence packs when you need them.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppTheme.neutralGray700,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Everything in Premium
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppTheme.softLilac,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Everything in Premium',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Unlimited evidence, advanced analytics, 100GB vault, priority processing, premium badge',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.neutralGray700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Pro-Exclusive Benefits
                  Text(
                    'Pro-Exclusive Features',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.deepBlack,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _buildBenefitItem(
                    icon: Icons.groups_outlined,
                    title: 'Bulk Profile Checks',
                    subtitle: 'Check up to 50 SilentID profiles at once',
                  ),

                  _buildBenefitItem(
                    icon: Icons.description_outlined,
                    title: 'Dispute & Evidence Pack Generator',
                    subtitle: 'PDF report for marketplace support or legal use',
                  ),

                  _buildBenefitItem(
                    icon: Icons.verified_outlined,
                    title: 'Trust Certificate Export',
                    subtitle: 'Branded PDF for landlord references and external markets',
                  ),

                  _buildBenefitItem(
                    icon: Icons.business_outlined,
                    title: 'White-Label Profile Option',
                    subtitle: 'Remove branding on external materials',
                  ),

                  _buildBenefitItem(
                    icon: Icons.storage_outlined,
                    title: '500GB Evidence Vault',
                    subtitle: 'Store comprehensive evidence archives',
                  ),

                  _buildBenefitItem(
                    icon: Icons.support_agent_outlined,
                    title: 'Priority Support',
                    subtitle: 'Dedicated support channel',
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Who is this for
                  Text(
                    'Ideal For',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.deepBlack,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _buildIdealForItem('High-volume sellers'),
                  _buildIdealForItem('Landlords and property managers'),
                  _buildIdealForItem('Community group admins'),
                  _buildIdealForItem('Professional service providers'),

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
                          'Pro unlocks professional tools and features, but your trust reputation is always earned through verified evidence and behavior.',
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
                      : const Text('Get Pro — £14.99/month'),
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
              gradient: const LinearGradient(
                colors: [AppTheme.primaryPurple, AppTheme.darkModePurple],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.pureWhite,
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

  Widget _buildIdealForItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppTheme.primaryPurple,
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
}
