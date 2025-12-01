import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/gamification/gamification.dart';
import '../../../core/utils/haptics.dart';
import '../../../services/security_api_service.dart';

/// Security Center main hub screen (Section 15)
/// Digital protection hub with overview of all security features
/// Level 7 Gamification: Animated risk meter, status transitions, interactive cards
class SecurityCenterScreen extends StatefulWidget {
  const SecurityCenterScreen({super.key});

  @override
  State<SecurityCenterScreen> createState() => _SecurityCenterScreenState();
}

class _SecurityCenterScreenState extends State<SecurityCenterScreen>
    with SingleTickerProviderStateMixin {
  final _securityApi = SecurityApiService();

  SecurityOverview? _overview;
  bool _isLoading = true;
  String? _error;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _loadSecurityOverview();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadSecurityOverview() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final overview = await _securityApi.getSecurityOverview();
      setState(() {
        _overview = overview;
        _isLoading = false;
      });
      _fadeController.forward(from: 0.0);
    } catch (e) {
      setState(() {
        _error = 'Failed to load security data';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.pureWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.neutralGray900),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Security Center',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_overview != null && _overview!.unreadAlertCount > 0)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: AppTheme.neutralGray900),
                  onPressed: () => context.push('/security/alerts'),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.dangerRed,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_overview!.unreadAlertCount}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.pureWhite,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: AppTheme.neutralGray900),
              onPressed: () => context.push('/security/alerts'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryPurple))
          : _error != null
              ? _buildErrorState()
              : RefreshIndicator(
                  onRefresh: _loadSecurityOverview,
                  color: AppTheme.primaryPurple,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSecurityScoreCard(),
                          const SizedBox(height: AppSpacing.lg),
                          _buildQuickActions(),
                          const SizedBox(height: AppSpacing.lg),
                          _buildSecurityFeatures(),
                          const SizedBox(height: AppSpacing.lg),
                          _buildRecentActivity(),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppTheme.neutralGray300),
            const SizedBox(height: 16),
            Text(
              _error ?? 'Something went wrong',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppTheme.neutralGray700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _loadSecurityOverview,
              child: Text(
                'Try Again',
                style: GoogleFonts.inter(
                  fontSize: 14,
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

  Widget _buildSecurityScoreCard() {
    final score = _overview?.identityStatus.verificationScore ?? 0;
    final riskLevel = _overview?.riskStatus.riskLevel ?? 'None';
    final isSecure = riskLevel == 'None' || riskLevel == 'Low';
    final baseColor = isSecure ? AppTheme.successGreen : AppTheme.warningAmber;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [baseColor, baseColor.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Level 7: Animated Security Ring
          AnimatedProgressRing(
            progress: score / 100,
            size: 100,
            strokeWidth: 10,
            progressColor: Colors.white,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: score),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Text(
                      '$value',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                Text(
                  '/ 100',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge with animation
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  builder: (context, opacity, child) {
                    return Opacity(
                      opacity: opacity,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isSecure
                                  ? Icons.check_circle_outline
                                  : Icons.warning_amber_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isSecure ? 'Secure' : 'Attention Needed',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'Security Score',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _overview?.identityStatus.statusText ?? 'Loading...',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 12),
                // Risk level indicator
                Row(
                  children: [
                    _buildRiskChip('None', riskLevel == 'None'),
                    const SizedBox(width: 4),
                    _buildRiskChip('Low', riskLevel == 'Low'),
                    const SizedBox(width: 4),
                    _buildRiskChip('Med', riskLevel == 'Medium'),
                    const SizedBox(width: 4),
                    _buildRiskChip('High', riskLevel == 'High'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white.withValues(alpha: 0.25)
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.6),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.verified_user_outlined,
                label: 'Identity',
                subtitle: _overview?.identityStatus.identityVerified == true ? 'Verified' : 'Not verified',
                isPositive: _overview?.identityStatus.identityVerified == true,
                onTap: () => context.push('/security/identity'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.folder_outlined,
                label: 'Vault',
                subtitle: '${_overview?.vaultHealth.totalEvidenceCount ?? 0} items',
                isPositive: _overview?.vaultHealth.isHealthy == true,
                onTap: () => context.push('/security/vault'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool isPositive,
    required VoidCallback onTap,
  }) {
    return InteractiveCard(
      onTap: () {
        AppHaptics.light();
        onTap();
      },
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Animated icon
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppTheme.primaryPurple, size: 24),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.neutralGray900,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, opacity, child) {
                  return Opacity(
                    opacity: opacity,
                    child: Icon(
                      isPositive ? Icons.check_circle : Icons.info_outline,
                      size: 14,
                      color: isPositive
                          ? AppTheme.successGreen
                          : AppTheme.warningAmber,
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Security Features',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          icon: Icons.history,
          title: 'Login Activity',
          subtitle: 'View your recent sign-in history',
          onTap: () => context.push('/security/login-activity'),
        ),
        _buildFeatureItem(
          icon: Icons.smartphone,
          title: 'Device Security',
          subtitle: 'Check your device integrity',
          onTap: () => context.push('/security/device'),
        ),
        _buildFeatureItem(
          icon: Icons.shield_outlined,
          title: 'Risk Status',
          subtitle: _overview?.riskStatus.riskLevel == 'None'
              ? 'No risks detected'
              : '${_overview?.riskStatus.signalCount ?? 0} active signals',
          hasWarning: _overview?.riskStatus.hasRisk == true,
          onTap: () => context.push('/security/risk'),
        ),
        _buildFeatureItem(
          icon: Icons.notifications_outlined,
          title: 'Security Alerts',
          subtitle: _overview?.unreadAlertCount == 0
              ? 'No new alerts'
              : '${_overview?.unreadAlertCount} unread alerts',
          badge: _overview?.unreadAlertCount ?? 0,
          onTap: () => context.push('/security/alerts'),
        ),
        _buildFeatureItem(
          icon: Icons.search,
          title: 'Breach Scanner',
          subtitle: 'Check if your email was exposed',
          isExternal: true,
          onTap: () => _showBreachScannerInfo(),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool hasWarning = false,
    int badge = 0,
    bool isExternal = false,
  }) {
    final iconColor = hasWarning ? AppTheme.warningAmber : AppTheme.primaryPurple;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InteractiveCard(
        onTap: () {
          AppHaptics.light();
          onTap();
        },
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Animated icon container
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.9, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.neutralGray900,
                        ),
                      ),
                      if (isExternal) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.neutralGray300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Coming Soon',
                            style: GoogleFonts.inter(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.neutralGray700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: hasWarning
                          ? AppTheme.warningAmber
                          : AppTheme.neutralGray700,
                    ),
                  ),
                ],
              ),
            ),
            if (badge > 0)
              // Animated badge
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.dangerRed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$badge',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.pureWhite,
                        ),
                      ),
                    ),
                  );
                },
              )
            else
              Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.neutralGray300,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    final recentLogins = _overview?.recentLogins ?? [];
    if (recentLogins.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Logins',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray900,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/security/login-activity'),
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...recentLogins.take(3).map((login) => _buildLoginItem(login)),
      ],
    );
  }

  Widget _buildLoginItem(LoginEntry login) {
    final timeAgo = _formatTimeAgo(login.timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
      ),
      child: Row(
        children: [
          Icon(
            login.isActive ? Icons.phone_android : Icons.phone_android_outlined,
            color: login.isActive ? AppTheme.successGreen : AppTheme.neutralGray700,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  login.deviceDescription,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.neutralGray900,
                  ),
                ),
                Text(
                  login.ipAddress ?? 'Unknown location',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeAgo,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppTheme.neutralGray700,
                ),
              ),
              if (login.isActive)
                Text(
                  'Active',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.successGreen,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  void _showBreachScannerInfo() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.pureWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.neutralGray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Icon(Icons.search, size: 48, color: AppTheme.primaryPurple),
            const SizedBox(height: 16),
            Text(
              'Breach Scanner',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.neutralGray900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This feature will check if your email has appeared in known data breaches using the HaveIBeenPwned service.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.warningAmber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.warningAmber, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Requires external API configuration',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.warningAmber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Got It',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.pureWhite,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
