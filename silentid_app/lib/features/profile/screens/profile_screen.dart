import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/settings_list_item.dart';
import '../../../core/widgets/info_point_helper.dart';
import '../../../core/data/info_point_data.dart';
import '../../../services/user_api_service.dart';

/// Profile/Settings screen following Section 39 specifications
///
/// Contains 7 mandatory sections in exact order:
/// 1. Account & Identity
/// 2. Trust & Evidence
/// 3. Security & Risk
/// 4. Subscriptions & Billing
/// 5. Privacy & Data
/// 6. Help & Legal
/// 7. About & Legal
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userApi = UserApiService();

  bool _isLoading = true;
  UserProfile? _profile;

  // Derived getters for backwards compatibility
  String get displayName => _profile?.displayNameOrFallback ?? "Loading...";
  String get username => _profile?.formattedUsername ?? "@user";
  bool get isIdentityVerified => _profile?.isIdentityVerified ?? false;
  int get trustScore => _profile?.trustScore ?? 0;
  String get trustLevel => _profile?.trustLevel ?? "Unknown";
  String get accountType => _profile?.accountType ?? "Free";
  int get riskScore => _profile?.riskScore ?? 0;
  int get evidenceCount => _profile?.evidenceCount ?? 0;
  int get mutualVerificationsCount => _profile?.mutualVerificationsCount ?? 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await _userApi.getUserProfile();
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureWhite,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Profile Header
            SliverToBoxAdapter(
              child: _buildProfileHeader(),
            ),

            // Section 1: Account & Identity
            SliverToBoxAdapter(
              child: _buildSection1AccountIdentity(),
            ),

            // Section 2: Trust & Evidence
            SliverToBoxAdapter(
              child: _buildSection2TrustEvidence(),
            ),

            // Section 3: Security & Risk
            SliverToBoxAdapter(
              child: _buildSection3SecurityRisk(),
            ),

            // Section 4: Subscriptions & Billing
            SliverToBoxAdapter(
              child: _buildSection4Subscriptions(),
            ),

            // Section 5: Privacy & Data
            SliverToBoxAdapter(
              child: _buildSection5PrivacyData(),
            ),

            // Section 6: Help & Legal
            SliverToBoxAdapter(
              child: _buildSection6HelpLegal(),
            ),

            // Section 7: About & Legal
            SliverToBoxAdapter(
              child: _buildSection7AboutLegal(),
            ),

            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSpacing.xl),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: AppTheme.softLilac,
            child: Text(
              displayName[0],
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryPurple,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Display Name
          Text(
            displayName,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppTheme.deepBlack,
            ),
          ),

          const SizedBox(height: AppSpacing.xxs),

          // Username
          Text(
            username,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.neutralGray700,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Trust Badges
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            alignment: WrapAlignment.center,
            children: [
              if (isIdentityVerified)
                _buildBadge("✅ Identity Verified", AppTheme.successGreen),
              _buildBadge("🎯 TrustScore: $trustScore ($trustLevel)", AppTheme.primaryPurple),
              if (accountType != "Free")
                _buildBadge("💎 $accountType Member", AppTheme.primaryPurple),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Primary CTA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate based on user state
                if (!isIdentityVerified) {
                  Navigator.pushNamed(context, '/identity/intro');
                } else if (trustScore < 800) {
                  Navigator.pushNamed(context, '/evidence');
                } else {
                  Navigator.pushNamed(context, '/trust/overview');
                }
              },
              child: Text(
                !isIdentityVerified
                    ? "Verify your identity"
                    : trustScore < 800
                        ? "Improve your TrustScore"
                        : "View TrustScore Details",
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Secondary CTA
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile/public');
            },
            child: const Text("View public profile"),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.neutralGray700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSection1AccountIdentity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("ACCOUNT & IDENTITY"),

        Container(
          decoration: BoxDecoration(
            color: AppTheme.pureWhite,
            border: Border(
              top: BorderSide(color: AppTheme.neutralGray300, width: 1),
              bottom: BorderSide(color: AppTheme.neutralGray300, width: 1),
            ),
          ),
          child: Column(
            children: [
              SettingsListItem(
                icon: Icons.shield_outlined,
                title: "Identity verification",
                subtitle: isIdentityVerified ? "Verified via Stripe" : "Not verified",
                iconColor: isIdentityVerified ? AppTheme.successGreen : AppTheme.neutralGray700,
                onTap: () {
                  Navigator.pushNamed(context, '/identity/status');
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoPointHelper(data: InfoPoints.stripeIdentity),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: AppTheme.neutralGray700,
                    ),
                  ],
                ),
                showChevron: false,
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.person_outline,
                title: "Public profile",
                subtitle: "View and manage",
                onTap: () {
                  Navigator.pushNamed(context, '/profile/public');
                },
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.edit_outlined,
                title: "Edit profile",
                subtitle: "Display name, avatar",
                onTap: () {
                  Navigator.pushNamed(context, '/settings/account');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection2TrustEvidence() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("TRUST & EVIDENCE"),

        Container(
          decoration: BoxDecoration(
            color: AppTheme.pureWhite,
            border: Border(
              top: BorderSide(color: AppTheme.neutralGray300, width: 1),
              bottom: BorderSide(color: AppTheme.neutralGray300, width: 1),
            ),
          ),
          child: Column(
            children: [
              SettingsListItem(
                icon: Icons.emoji_events_outlined,
                title: "TrustScore",
                subtitle: "$trustScore - $trustLevel",
                iconColor: AppTheme.primaryPurple,
                onTap: () {
                  Navigator.pushNamed(context, '/trust/overview');
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoPointHelper(data: InfoPoints.trustScoreOverall),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: AppTheme.neutralGray700,
                    ),
                  ],
                ),
                showChevron: false,
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.folder_outlined,
                title: "Evidence Vault",
                subtitle: "$evidenceCount items",
                onTap: () {
                  Navigator.pushNamed(context, '/evidence');
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoPointHelper(data: InfoPoints.evidenceVault),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: AppTheme.neutralGray700,
                    ),
                  ],
                ),
                showChevron: false,
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.check_circle_outline,
                title: "Mutual verification",
                subtitle: "$mutualVerificationsCount verified",
                onTap: () {
                  Navigator.pushNamed(context, '/mutual-verification');
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoPointHelper(data: InfoPoints.peerVerificationComponent),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: AppTheme.neutralGray700,
                    ),
                  ],
                ),
                showChevron: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection3SecurityRisk() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("SECURITY & RISK"),

        Container(
          decoration: BoxDecoration(
            color: AppTheme.pureWhite,
            border: Border(
              top: BorderSide(color: AppTheme.neutralGray300, width: 1),
              bottom: BorderSide(color: AppTheme.neutralGray300, width: 1),
            ),
          ),
          child: Column(
            children: [
              SettingsListItem(
                icon: Icons.security_outlined,
                title: "Security Center",
                subtitle: riskScore < 20 ? "All clear" : "Review needed",
                iconColor: riskScore < 20 ? AppTheme.successGreen : AppTheme.warningAmber,
                onTap: () {
                  // TODO: Navigate to Security Center
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoPointHelper(data: InfoPoints.riskScore),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: AppTheme.neutralGray700,
                    ),
                  ],
                ),
                showChevron: false,
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.phone_android_outlined,
                title: "Devices & sessions",
                subtitle: "Manage trusted devices",
                onTap: () {
                  Navigator.pushNamed(context, '/settings/devices');
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoPointHelper(data: InfoPoints.deviceSecurity),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: AppTheme.neutralGray700,
                    ),
                  ],
                ),
                showChevron: false,
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.vpn_key_outlined,
                title: "Login methods",
                subtitle: "Passkey, Apple, Google, Email",
                onTap: () {
                  // TODO: Navigate to Login methods
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoPointHelper(data: InfoPoints.whyNoPasswords),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: AppTheme.neutralGray700,
                    ),
                  ],
                ),
                showChevron: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection4Subscriptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("SUBSCRIPTIONS & BILLING"),

        Container(
          decoration: BoxDecoration(
            color: AppTheme.pureWhite,
            border: Border(
              top: BorderSide(color: AppTheme.neutralGray300, width: 1),
              bottom: BorderSide(color: AppTheme.neutralGray300, width: 1),
            ),
          ),
          child: Column(
            children: [
              SettingsListItem(
                icon: Icons.credit_card_outlined,
                title: "Current plan",
                subtitle: accountType,
                iconColor: accountType != "Free" ? AppTheme.primaryPurple : AppTheme.neutralGray700,
                onTap: () {
                  Navigator.pushNamed(context, '/subscriptions/overview');
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoPointHelper(data: InfoPoints.subscriptionTiers),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: AppTheme.neutralGray700,
                    ),
                  ],
                ),
                showChevron: false,
              ),

              if (accountType == "Free") ...[
                Divider(height: 1, color: AppTheme.neutralGray300),
                SettingsListItem(
                  icon: Icons.arrow_upward_outlined,
                  title: "Upgrade to Premium",
                  subtitle: "£4.99/month",
                  iconColor: AppTheme.primaryPurple,
                  onTap: () {
                    Navigator.pushNamed(context, '/subscriptions/premium');
                  },
                ),
              ],

              if (accountType == "Premium") ...[
                Divider(height: 1, color: AppTheme.neutralGray300),
                SettingsListItem(
                  icon: Icons.arrow_upward_outlined,
                  title: "Upgrade to Pro",
                  subtitle: "£14.99/month",
                  iconColor: AppTheme.primaryPurple,
                  onTap: () {
                    Navigator.pushNamed(context, '/subscriptions/pro');
                  },
                ),
              ],

              if (accountType != "Free") ...[
                Divider(height: 1, color: AppTheme.neutralGray300),
                SettingsListItem(
                  icon: Icons.settings_outlined,
                  title: "Manage subscription",
                  onTap: () {
                    Navigator.pushNamed(context, '/subscriptions/overview');
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection5PrivacyData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("PRIVACY & DATA"),

        Container(
          decoration: BoxDecoration(
            color: AppTheme.pureWhite,
            border: Border(
              top: BorderSide(color: AppTheme.neutralGray300, width: 1),
              bottom: BorderSide(color: AppTheme.neutralGray300, width: 1),
            ),
          ),
          child: Column(
            children: [
              SettingsListItem(
                icon: Icons.link_outlined,
                title: "Connected services",
                subtitle: "Email, permissions",
                onTap: () {
                  // TODO: Navigate to Connected services
                },
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.download_outlined,
                title: "Download my data",
                subtitle: "GDPR export",
                onTap: () {
                  Navigator.pushNamed(context, '/settings/export');
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoPointHelper(data: InfoPoints.evidenceStorage),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: AppTheme.neutralGray700,
                    ),
                  ],
                ),
                showChevron: false,
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.privacy_tip_outlined,
                title: "Privacy preferences",
                onTap: () {
                  Navigator.pushNamed(context, '/settings/privacy');
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoPointHelper(data: InfoPoints.publicProfileVisibility),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: AppTheme.neutralGray700,
                    ),
                  ],
                ),
                showChevron: false,
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.delete_outline,
                title: "Delete my account",
                iconColor: AppTheme.dangerRed,
                onTap: () {
                  Navigator.pushNamed(context, '/settings/delete');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection6HelpLegal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("HELP & LEGAL"),

        Container(
          decoration: BoxDecoration(
            color: AppTheme.pureWhite,
            border: Border(
              top: BorderSide(color: AppTheme.neutralGray300, width: 1),
              bottom: BorderSide(color: AppTheme.neutralGray300, width: 1),
            ),
          ),
          child: Column(
            children: [
              SettingsListItem(
                icon: Icons.help_outline,
                title: "Help Center",
                onTap: () {
                  // TODO: Navigate to Help Center
                },
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.chat_bubble_outline,
                title: "Contact support",
                onTap: () {
                  // TODO: Navigate to Contact support
                },
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.flag_outlined,
                title: "Report a safety concern",
                onTap: () {
                  Navigator.pushNamed(context, '/safety/report');
                },
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.list_alt_outlined,
                title: "My reports",
                onTap: () {
                  Navigator.pushNamed(context, '/safety/my-reports');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection7AboutLegal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("ABOUT & LEGAL"),

        Container(
          decoration: BoxDecoration(
            color: AppTheme.pureWhite,
            border: Border(
              top: BorderSide(color: AppTheme.neutralGray300, width: 1),
              bottom: BorderSide(color: AppTheme.neutralGray300, width: 1),
            ),
          ),
          child: Column(
            children: [
              SettingsListItem(
                icon: Icons.description_outlined,
                title: "Terms & Conditions",
                onTap: () {
                  // TODO: Open Terms & Conditions
                },
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.lock_outline,
                title: "Privacy Policy",
                onTap: () {
                  // TODO: Open Privacy Policy
                },
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.code_outlined,
                title: "Licenses & credits",
                onTap: () {
                  // TODO: Show licenses
                },
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.info_outline,
                title: "App version",
                subtitle: "1.0.0 (MVP)",
                showChevron: false,
                onTap: null,
              ),

              Divider(height: 1, color: AppTheme.neutralGray300),

              SettingsListItem(
                icon: Icons.article_outlined,
                title: "SilentID Specification",
                subtitle: "Version 1.6.0",
                showChevron: false,
                onTap: null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
