import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/info_point_helper.dart';
import '../../../core/data/info_point_data.dart';

class IdentityIntroScreen extends StatelessWidget {
  const IdentityIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // Icon
              Container(
                height: 80,
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.softLilac,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.verified_user,
                  size: 48,
                  color: AppTheme.primaryPurple,
                ),
              ),

              const SizedBox(height: 32),

              // Title with Info Point (Section 40.4)
              Row(
                children: [
                  Text(
                    'Verify your identity',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.deepBlack,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InfoPointHelper(data: InfoPoints.stripeIdentity),
                ],
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                'SilentID uses Stripe to securely confirm you\'re a real person. We do not store your ID documents — Stripe handles everything.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppTheme.neutralGray700,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              // Benefits
              _buildBenefit(
                icon: Icons.shield,
                title: 'Prevent impersonation',
                description: 'Prove you\'re a real person, not a bot or fake account',
              ),

              const SizedBox(height: 20),

              _buildBenefit(
                icon: Icons.trending_up,
                title: 'Strengthen your TrustScore',
                description: 'Identity verification adds 200 points to your score',
              ),

              const SizedBox(height: 20),

              _buildBenefit(
                icon: Icons.lock_open,
                title: 'Unlock advanced features',
                description: 'Access mutual verifications and public profile sharing',
              ),

              const Spacer(),

              // Privacy notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.softLilac,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryPurple,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your document photos are processed by Stripe, not SilentID.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.neutralGray900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Start verification button
              PrimaryButton(
                text: 'Start Verification',
                onPressed: () {
                  // TODO: Navigate to Stripe verification WebView
                  context.push('/identity/verify');
                },
              ),

              const SizedBox(height: 16),

              // Maybe later button
              PrimaryButton(
                text: 'Maybe later',
                isSecondary: true,
                onPressed: () => context.pop(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefit({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          width: 40,
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
        const SizedBox(width: 16),
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
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.neutralGray700,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
