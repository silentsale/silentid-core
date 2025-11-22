import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class TrustScoreBreakdownScreen extends StatefulWidget {
  const TrustScoreBreakdownScreen({super.key});

  @override
  State<TrustScoreBreakdownScreen> createState() =>
      _TrustScoreBreakdownScreenState();
}

class _TrustScoreBreakdownScreenState
    extends State<TrustScoreBreakdownScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _breakdownData;

  @override
  void initState() {
    super.initState();
    _loadBreakdown();
  }

  Future<void> _loadBreakdown() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Replace with actual API call
      // final response = await ApiService().get('/trustscore/me/breakdown');

      // Mock data for now
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _breakdownData = {
          'totalScore': 754,
          'level': 'High Trust',
          'components': {
            'identity': {
              'score': 210,
              'max': 200,
              'items': [
                {
                  'label': 'Stripe Identity Verified',
                  'points': 200,
                  'status': 'positive'
                },
                {'label': 'Email Verified', 'points': 10, 'status': 'positive'},
                {'label': 'Phone Not Added', 'points': 0, 'status': 'neutral'},
              ],
            },
            'evidence': {
              'score': 180,
              'max': 300,
              'items': [
                {
                  'label': '96 Receipts Verified',
                  'points': 140,
                  'status': 'positive'
                },
                {
                  'label': '5 Screenshots Uploaded',
                  'points': 15,
                  'status': 'positive'
                },
                {
                  'label': '1 Profile Link Verified',
                  'points': 25,
                  'status': 'positive'
                },
              ],
            },
            'behaviour': {
              'score': 240,
              'max': 300,
              'items': [
                {
                  'label': 'No Safety Reports',
                  'points': 40,
                  'status': 'positive'
                },
                {
                  'label': 'Account Age (120 days)',
                  'points': 60,
                  'status': 'positive'
                },
                {
                  'label': 'Cross-Platform Consistency',
                  'points': 50,
                  'status': 'positive'
                },
                {
                  'label': '2 Device Changes',
                  'points': -10,
                  'status': 'negative'
                },
              ],
            },
            'peer': {
              'score': 124,
              'max': 200,
              'items': [
                {
                  'label': '12 Mutual Verifications',
                  'points': 120,
                  'status': 'positive'
                },
                {
                  'label': '3 Returning Partners',
                  'points': 4,
                  'status': 'positive'
                },
              ],
            },
          },
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load breakdown: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('TrustScore Breakdown'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadBreakdown,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Score Header
                    _buildTotalScoreHeader(),
                    const SizedBox(height: 32),

                    // Component Sections
                    _buildComponentSection(
                      'Identity Score',
                      Icons.verified_user,
                      _breakdownData!['components']['identity'],
                    ),
                    const SizedBox(height: 24),

                    _buildComponentSection(
                      'Evidence Score',
                      Icons.receipt_long,
                      _breakdownData!['components']['evidence'],
                    ),
                    const SizedBox(height: 24),

                    _buildComponentSection(
                      'Behaviour Score',
                      Icons.trending_up,
                      _breakdownData!['components']['behaviour'],
                    ),
                    const SizedBox(height: 24),

                    _buildComponentSection(
                      'Peer Verification Score',
                      Icons.handshake,
                      _breakdownData!['components']['peer'],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTotalScoreHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryPurple,
            AppTheme.primaryPurple.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total TrustScore',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _breakdownData!['level'],
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(
            '${_breakdownData!['totalScore']}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentSection(
    String title,
    IconData icon,
    Map<String, dynamic> component,
  ) {
    final score = component['score'] as int;
    final max = component['max'] as int;
    final items = component['items'] as List;

    return Container(
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
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 16),
          leading: Icon(
            icon,
            color: AppTheme.primaryPurple,
            size: 28,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.neutralGray900,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '$score/$max points',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryPurple,
              ),
            ),
          ),
          children: [
            ...items.map((item) => _buildBreakdownItem(item)),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownItem(Map<String, dynamic> item) {
    final label = item['label'] as String;
    final points = item['points'] as int;
    final status = item['status'] as String;

    IconData icon;
    Color iconColor;

    switch (status) {
      case 'positive':
        icon = Icons.check_circle;
        iconColor = AppTheme.successGreen;
        break;
      case 'negative':
        icon = Icons.warning;
        iconColor = AppTheme.warningAmber;
        break;
      default:
        icon = Icons.cancel;
        iconColor = AppTheme.neutralGray700;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: AppTheme.neutralGray900,
              ),
            ),
          ),
          Text(
            points > 0 ? '+$points' : '$points',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: points > 0
                  ? AppTheme.successGreen
                  : points < 0
                      ? AppTheme.dangerRed
                      : AppTheme.neutralGray700,
            ),
          ),
        ],
      ),
    );
  }
}
