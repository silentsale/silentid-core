import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/enums/button_variant.dart';
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
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTrustScore();
  }

  Future<void> _loadTrustScore() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiService.get('/v1/trustscore/me');

      if (mounted) {
        setState(() {
          _trustScoreData = {
            'score': response.data['totalScore'] ?? 0,
            'level': response.data['label'] ?? 'Unknown',
            'identity': response.data['identityScore'] ?? 0,
            'identityMax': 200,
            'evidence': response.data['evidenceScore'] ?? 0,
            'evidenceMax': 300,
            'behaviour': response.data['behaviourScore'] ?? 0,
            'behaviourMax': 300,
            'peer': response.data['peerScore'] ?? 0,
            'peerMax': 200,
          };
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load TrustScore';
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
                    const SizedBox(height: 16),

                    _buildComponentCard(
                      'Peer Verification',
                      _trustScoreData!['peer'],
                      _trustScoreData!['peerMax'],
                      Icons.handshake,
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

    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: 12,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            score.toString(),
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            level,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildComponentCard(
    String title,
    int current,
    int max,
    IconData icon,
  ) {
    final progress = current / max;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppTheme.primaryPurple,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.neutralGray900,
                ),
              ),
              const Spacer(),
              Text(
                '$current/$max',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress > 1.0 ? 1.0 : progress,
              minHeight: 8,
              backgroundColor: AppTheme.softLilac,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.primaryPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
