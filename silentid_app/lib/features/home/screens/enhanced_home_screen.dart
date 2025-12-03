import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptics.dart';
import '../../../services/auth_service.dart';

/// SuperDesign Level 7+ Enhanced Home Screen
/// This screen is wrapped by MainShellScreen which provides the bottom navigation
class EnhancedHomeScreen extends StatefulWidget {
  const EnhancedHomeScreen({super.key});

  @override
  State<EnhancedHomeScreen> createState() => _EnhancedHomeScreenState();
}

class _EnhancedHomeScreenState extends State<EnhancedHomeScreen>
    with TickerProviderStateMixin {
  final _authService = AuthService();

  late AnimationController _scoreController;
  late AnimationController _pulseController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _pulseAnimation;

  bool _isRefreshing = false;

  // Demo data
  final int _trustScore = 752;
  final String _trustLabel = 'Very High Trust';
  final int _userLevel = 4;

  // Onboarding checklist state
  final bool _identityVerified = true;
  final bool _profileConnected = true;
  final bool _firstEvidenceAdded = false;

  @override
  void initState() {
    super.initState();

    _scoreController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scoreAnimation = Tween<double>(begin: 0, end: _trustScore.toDouble()).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.easeOutCubic),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scoreController.forward();
  }

  @override
  void dispose() {
    _scoreController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    _scoreController.forward(from: 0);
    if (mounted) setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.primaryPurple,
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverAppBar(
              expandedHeight: 60,
              floating: true,
              pinned: true,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'SilentID',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.deepBlack,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  color: AppTheme.neutralGray700,
                  onPressed: () {
                    AppHaptics.light();
                    // TODO: Navigate to notifications
                  },
                ),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // TrustScore Hero Section
                  _buildTrustScoreHero(),

                  // Onboarding Checklist
                  if (!_allOnboardingComplete) _buildOnboardingChecklist(),

                  // Quick Actions
                  _buildQuickActionsSection(),

                  // Recent Activity
                  _buildRecentActivitySection(),

                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get _allOnboardingComplete =>
      _identityVerified && _profileConnected && _firstEvidenceAdded;

  int get _completedSteps {
    int count = 0;
    if (_identityVerified) count++;
    if (_profileConnected) count++;
    if (_firstEvidenceAdded) count++;
    return count;
  }

  Widget _buildTrustScoreHero() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: [
          // Animated Score Circle
          GestureDetector(
            onTap: () {
              AppHaptics.medium();
              context.push('/trust/overview');
            },
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background ring
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.softLilac,
                          ),
                        ),
                        // Progress ring
                        AnimatedBuilder(
                          animation: _scoreAnimation,
                          builder: (context, child) {
                            return CustomPaint(
                              size: const Size(140, 140),
                              painter: _ScoreRingPainter(
                                progress: _scoreAnimation.value / 1000,
                                color: AppTheme.primaryPurple,
                                strokeWidth: 10,
                              ),
                            );
                          },
                        ),
                        // Score text
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedBuilder(
                              animation: _scoreAnimation,
                              builder: (context, child) {
                                return Text(
                                  '${_scoreAnimation.value.toInt()}',
                                  style: GoogleFonts.inter(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.deepBlack,
                                  ),
                                );
                              },
                            ),
                            Text(
                              'TrustScore',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.neutralGray700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Trust Label
          Text(
            _trustLabel,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.deepBlack,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your TrustScore is in the top 15%',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.neutralGray700,
            ),
          ),

          const SizedBox(height: 16),

          // Level Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryPurple,
                  AppTheme.primaryPurple.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Level $_userLevel',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Score Range Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.neutralGray700,
                      ),
                    ),
                    Text(
                      '1000',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.neutralGray700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.softLilac,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return AnimatedBuilder(
                        animation: _scoreAnimation,
                        builder: (context, child) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: constraints.maxWidth * (_scoreAnimation.value / 1000),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryPurple,
                                    AppTheme.primaryPurple.withValues(alpha: 0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingChecklist() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.softLilac,
              AppTheme.softLilac.withValues(alpha: 0.5),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Complete Your Profile',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.deepBlack,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$_completedSteps/3',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Progress bar
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: _completedSteps / 3),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Checklist Items
            _buildChecklistItem(
              'Verify your identity',
              '+100 TrustScore',
              _identityVerified,
              () => context.push('/identity/intro'),
            ),
            const SizedBox(height: 14),
            _buildChecklistItem(
              'Connect a marketplace profile',
              '+150 TrustScore',
              _profileConnected,
              () => context.push('/profiles/connect'),
            ),
            const SizedBox(height: 14),
            _buildChecklistItem(
              'Add evidence to your vault',
              '+100 TrustScore',
              _firstEvidenceAdded,
              () => context.push('/evidence'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(
    String title,
    String points,
    bool completed,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: completed ? null : () {
        AppHaptics.light();
        onTap();
      },
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: completed ? AppTheme.successGreen : Colors.white,
              border: completed
                  ? null
                  : Border.all(color: AppTheme.neutralGray300, width: 2),
            ),
            child: completed
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: completed ? AppTheme.neutralGray700 : AppTheme.deepBlack,
                    fontWeight: completed ? FontWeight.w400 : FontWeight.w500,
                    decoration: completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  points,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: completed ? AppTheme.neutralGray700 : AppTheme.primaryPurple,
                  ),
                ),
              ],
            ),
          ),
          if (!completed)
            Icon(
              Icons.chevron_right,
              color: AppTheme.primaryPurple,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.deepBlack,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.description_outlined,
                  title: 'Add Evidence',
                  subtitle: 'Upload receipts',
                  color: AppTheme.primaryPurple,
                  onTap: () => context.push('/evidence'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.link,
                  title: 'Connect Profile',
                  subtitle: 'Link marketplace',
                  color: const Color(0xFF3B82F6),
                  onTap: () => context.push('/profiles/connect'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.share_outlined,
                  title: 'Share Passport',
                  subtitle: 'Generate link',
                  color: AppTheme.successGreen,
                  onTap: () => context.push('/profile/public'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.shield_outlined,
                  title: 'Security',
                  subtitle: 'Manage devices',
                  color: const Color(0xFFE65100),
                  onTap: () => context.push('/security'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        AppHaptics.light();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.neutralGray300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBlack,
              ),
            ),
            const SizedBox(height: 2),
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
    );
  }

  Widget _buildRecentActivitySection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.deepBlack,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActivityItem(
            icon: Icons.check_circle_outline,
            iconBgColor: AppTheme.successGreen.withValues(alpha: 0.1),
            iconColor: AppTheme.successGreen,
            title: 'Profile verified',
            subtitle: 'Vinted profile successfully connected',
            time: '2 hours ago',
            points: '+150',
          ),
          const SizedBox(height: 12),
          _buildActivityItem(
            icon: Icons.shield_outlined,
            iconBgColor: AppTheme.primaryPurple.withValues(alpha: 0.1),
            iconColor: AppTheme.primaryPurple,
            title: 'Identity verified',
            subtitle: 'Stripe Identity check completed',
            time: '1 day ago',
            points: '+100',
          ),
          const SizedBox(height: 12),
          _buildActivityItem(
            icon: Icons.person_add_outlined,
            iconBgColor: AppTheme.softLilac,
            iconColor: AppTheme.primaryPurple,
            title: 'Account created',
            subtitle: 'Welcome to SilentID',
            time: '3 days ago',
            points: null,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    String? points,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neutralGray300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepBlack,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.neutralGray700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          if (points != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                points,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.successGreen,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _ScoreRingPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth * 2) / 2;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ScoreRingPainter oldDelegate) =>
      progress != oldDelegate.progress || color != oldDelegate.color;
}
