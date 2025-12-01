import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/gamification/gamification.dart';
import '../../../core/enums/button_variant.dart';
import '../../../core/utils/haptics.dart';
import '../../../services/api_service.dart';

class TrustScoreOverviewScreen extends StatefulWidget {
  const TrustScoreOverviewScreen({super.key});

  @override
  State<TrustScoreOverviewScreen> createState() =>
      _TrustScoreOverviewScreenState();
}

class _TrustScoreOverviewScreenState extends State<TrustScoreOverviewScreen> {
  final _apiService = ApiService();

  bool _isLoading = true;
  Map<String, dynamic>? _trustScoreData;

  @override
  void initState() {
    super.initState();
    _loadTrustScore();
  }

  Future<void> _loadTrustScore() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.get('/v1/trustscore/me');

      if (mounted) {
        setState(() {
          _trustScoreData = {
            'score': response.data['totalScore'] ?? 0,
            'level': response.data['label'] ?? 'Unknown',
            'identity': response.data['identityScore'] ?? 0,
            'identityMax': 250,
            'evidence': response.data['evidenceScore'] ?? 0,
            'evidenceMax': 400,
            'behaviour': response.data['behaviourScore'] ?? 0,
            'behaviourMax': 350,
          };
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load TrustScore: ${e.toString()}'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 801) return AppTheme.successGreen;
    if (score >= 601) return const Color(0xFF4CAF50); // Light green
    if (score >= 401) return AppTheme.warningAmber;
    if (score >= 201) return const Color(0xFFFF9800); // Orange
    return AppTheme.dangerRed;
  }

  String _getScoreLevel(int score) {
    if (score >= 801) return 'Very High Trust';
    if (score >= 601) return 'High Trust';
    if (score >= 401) return 'Moderate Trust';
    if (score >= 201) return 'Low Trust';
    return 'High Risk';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Your TrustScore'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadTrustScore,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Large Circular Score Display
                    _buildScoreCircle(),
                    const SizedBox(height: 40),

                    // Component Cards
                    _buildComponentCard(
                      'Identity',
                      _trustScoreData!['identity'],
                      _trustScoreData!['identityMax'],
                      Icons.verified_user,
                    ),
                    const SizedBox(height: 16),

                    _buildComponentCard(
                      'Evidence',
                      _trustScoreData!['evidence'],
                      _trustScoreData!['evidenceMax'],
                      Icons.receipt_long,
                    ),
                    const SizedBox(height: 16),

                    _buildComponentCard(
                      'Behaviour',
                      _trustScoreData!['behaviour'],
                      _trustScoreData!['behaviourMax'],
                      Icons.trending_up,
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    PrimaryButton(
                      text: 'View Detailed Breakdown',
                      onPressed: () => context.push('/trust/breakdown'),
                    ),
                    const SizedBox(height: 12),

                    PrimaryButton(
                      text: 'View Score History',
                      onPressed: () => context.push('/trust/history'),
                      variant: ButtonVariant.secondary,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildScoreCircle() {
    final score = _trustScoreData!['score'] as int;
    final level = _getScoreLevel(score);
    final color = _getScoreColor(score);

    final identityScore = _trustScoreData!['identity'] as int;
    final evidenceScore = _trustScoreData!['evidence'] as int;
    final behaviourScore = _trustScoreData!['behaviour'] as int;

    // Level 7 Gamification: Multi-segment animated ring
    return Column(
      children: [
        // User level badge
        LevelIndicator(level: _calculateUserLevel(score), height: 28),
        const SizedBox(height: AppSpacing.md),

        // Animated multi-segment ring
        MultiSegmentProgressRing(
          size: 220,
          strokeWidth: 18,
          animate: true,
          segments: [
            ProgressSegment(
              value: identityScore.toDouble(),
              color: AppTheme.primaryPurple,
              label: 'Identity',
            ),
            ProgressSegment(
              value: evidenceScore.toDouble(),
              color: AppTheme.successGreen,
              label: 'Evidence',
            ),
            ProgressSegment(
              value: behaviourScore.toDouble(),
              color: const Color(0xFF3B82F6),
              label: 'Behaviour',
            ),
          ],
          center: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: score),
                duration: const Duration(milliseconds: 1500),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Text(
                    '$value',
                    style: GoogleFonts.inter(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: color,
                      height: 1,
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  level,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Identity', AppTheme.primaryPurple),
            const SizedBox(width: AppSpacing.md),
            _buildLegendItem('Evidence', AppTheme.successGreen),
            const SizedBox(width: AppSpacing.md),
            _buildLegendItem('Behaviour', const Color(0xFF3B82F6)),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppTheme.neutralGray700,
          ),
        ),
      ],
    );
  }

  int _calculateUserLevel(int score) {
    if (score >= 900) return 10;
    if (score >= 800) return 9;
    if (score >= 700) return 8;
    if (score >= 600) return 7;
    if (score >= 500) return 6;
    if (score >= 400) return 5;
    if (score >= 300) return 4;
    if (score >= 200) return 3;
    if (score >= 100) return 2;
    return 1;
  }

  Widget _buildComponentCard(
    String title,
    int current,
    int max,
    IconData icon,
  ) {
    // Determine color based on component type
    Color componentColor;
    int rewardPoints;
    String subtitle;

    switch (title) {
      case 'Identity':
        componentColor = AppTheme.primaryPurple;
        rewardPoints = 50;
        subtitle = 'Verify your identity to boost this score';
        break;
      case 'Evidence':
        componentColor = AppTheme.successGreen;
        rewardPoints = 10;
        subtitle = 'Add receipts and screenshots';
        break;
      case 'Behaviour':
        componentColor = const Color(0xFF3B82F6);
        rewardPoints = 0;
        subtitle = 'Based on your activity and engagement';
        break;
      default:
        componentColor = AppTheme.primaryPurple;
        rewardPoints = 0;
        subtitle = '';
    }

    // Level 7 Gamification: Use MilestoneProgress widget
    return MilestoneProgress(
      title: title,
      subtitle: subtitle,
      current: current,
      target: max,
      rewardPoints: rewardPoints,
      icon: icon,
      color: componentColor,
      showReward: rewardPoints > 0 && current < max,
      animate: true,
      onTap: () {
        AppHaptics.light();
        context.push('/trust/breakdown');
      },
    );
  }
}
