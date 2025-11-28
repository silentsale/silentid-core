import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/info_point_helper.dart';
import '../../../core/data/info_point_data.dart';

class EvidenceOverviewScreen extends StatelessWidget {
  const EvidenceOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Evidence Vault',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppTheme.deepBlack,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Intro text
              Text(
                'Build your trust profile by adding evidence of your verified transactions and marketplace activity.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.neutralGray700,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              // Receipts section
              _buildEvidenceCard(
                context: context,
                icon: Icons.receipt_long,
                iconColor: AppTheme.primaryPurple,
                title: 'Email Receipts',
                subtitle: 'Connect your inbox to automatically verify transactions',
                count: 0, // TODO: Get from API
                countLabel: 'receipts verified',
                onTap: () => context.push('/evidence/receipts'),
                infoPoint: InfoPoints.emailScanning,
              ),

              const SizedBox(height: 16),

              // Screenshots section
              _buildEvidenceCard(
                context: context,
                icon: Icons.image,
                iconColor: AppTheme.successGreen,
                title: 'Screenshots',
                subtitle: 'Upload screenshots of your marketplace profiles and ratings',
                count: 0, // TODO: Get from API
                countLabel: 'screenshots uploaded',
                onTap: () => context.push('/evidence/screenshots'),
                infoPoint: InfoPoints.screenshotIntegrity,
              ),

              const SizedBox(height: 16),

              // Profile Links section
              _buildEvidenceCard(
                context: context,
                icon: Icons.link,
                iconColor: AppTheme.warningAmber,
                title: 'Public Profiles',
                subtitle: 'Link your verified marketplace accounts (Vinted, eBay, etc.)',
                count: 0, // TODO: Get from API
                countLabel: 'profiles linked',
                onTap: () => context.push('/evidence/profile-links'),
                infoPoint: InfoPoints.evidenceVault,
              ),

              const SizedBox(height: 32),

              // Info box
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
                        'All evidence is verified and contributes to your TrustScore. We never share your private data.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.neutralGray900,
                        ),
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

  Widget _buildEvidenceCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required int count,
    required String countLabel,
    required VoidCallback onTap,
    InfoPointData? infoPoint,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.neutralGray300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.deepBlack,
                            ),
                          ),
                          if (infoPoint != null) ...[
                            const SizedBox(width: 6),
                            InfoPointHelper(data: infoPoint),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.neutralGray700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppTheme.neutralGray700,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.softLilac,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count $countLabel',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
