import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_messages.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/widgets/info_point_helper.dart';
import '../../../core/widgets/public_connected_profiles.dart';
import '../../../core/widgets/connected_profiles_trust_contribution.dart';
import '../../../core/data/info_point_data.dart';
import '../../../core/utils/haptics.dart';
import '../../../services/trustscore_api_service.dart';
import '../../../services/profile_linking_service.dart';

/// TrustScore Breakdown Screen - Level 7 SuperDesign
class TrustScoreBreakdownScreen extends StatefulWidget {
  const TrustScoreBreakdownScreen({super.key});

  @override
  State<TrustScoreBreakdownScreen> createState() =>
      _TrustScoreBreakdownScreenState();
}

class _TrustScoreBreakdownScreenState
    extends State<TrustScoreBreakdownScreen>
    with SingleTickerProviderStateMixin {
  final _trustScoreApi = TrustScoreApiService();
  final _profileLinkingService = ProfileLinkingService();

  bool _isLoading = true;
  Map<String, dynamic>? _breakdownData;
  List<PublicConnectedProfile> _connectedProfiles = [];

  // Level 7: Animation controllers
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Level 7: Initialize animations
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _loadBreakdown();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadBreakdown() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch TrustScore breakdown and connected profiles in parallel
      final results = await Future.wait([
        _trustScoreApi.getTrustScoreBreakdown(),
        _profileLinkingService.getConnectedProfiles(),
      ]);

      final breakdown = results[0] as TrustScoreBreakdownResponse;
      final profiles = results[1] as List<ConnectedProfile>;

      // Convert connected profiles to public format
      _connectedProfiles = profiles.map((p) {
        // Get platform name from service
        final platform = _profileLinkingService.getPlatformById(p.platformId);
        // Derive verification method from state
        String? verificationMethod;
        if (p.state == ProfileLinkState.verifiedToken) {
          verificationMethod = 'token';
        } else if (p.state == ProfileLinkState.verifiedScreenshot) {
          verificationMethod = 'screenshot';
        }
        return PublicConnectedProfile(
          platformId: p.platformId,
          platformName: platform?.displayName ?? p.platformId,
          username: p.username,
          isVerified: p.isVerified,
          verificationMethod: verificationMethod,
        );
      }).toList();

      setState(() {
        _breakdownData = breakdown.toUiFormat();
        _isLoading = false;
      });
      // Level 7: Start animations
      _animController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _animController.forward();
      if (mounted) {
        AppMessages.showError(context, ErrorMessages.fromException(e, fallbackAction: 'load breakdown'));
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            AppHaptics.light();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryPurple))
          : FadeTransition(
              opacity: _fadeAnimation,
              child: RefreshIndicator(
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

                    // Component Sections with Info Points (Section 40.4)
                    _buildComponentSection(
                      'Identity Score',
                      Icons.verified_user,
                      _breakdownData!['components']['identity'],
                      infoPoint: InfoPoints.identityComponent,
                    ),
                    const SizedBox(height: 24),

                    _buildComponentSection(
                      'Evidence Score',
                      Icons.receipt_long,
                      _breakdownData!['components']['evidence'],
                      infoPoint: InfoPoints.evidenceComponent,
                    ),
                    const SizedBox(height: 24),

                    _buildComponentSection(
                      'Behaviour Score',
                      Icons.trending_up,
                      _breakdownData!['components']['behaviour'],
                      infoPoint: InfoPoints.behaviourComponent,
                    ),
                    const SizedBox(height: 24),

                    // URS Component (Section 47)
                    if (_breakdownData!['components']['urs'] != null)
                      _buildComponentSection(
                        'Universal Reputation Score',
                        Icons.public,
                        _breakdownData!['components']['urs'],
                        infoPoint: InfoPoints.ursComponent,
                      ),
                    if (_breakdownData!['components']['urs'] != null)
                      const SizedBox(height: 24),

                    // Connected Profiles Trust Contribution (Section 52.7)
                    ConnectedProfilesTrustContribution(
                      profiles: _connectedProfiles,
                      showHeader: true,
                      expandable: true,
                    ),
                  ],
                ),
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
            AppTheme.primaryPurple.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withValues(alpha: 0.3),
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
              Row(
                children: [
                  const Text(
                    'Total TrustScore',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  InfoPointHelper(
                    data: InfoPoints.trustScoreOverall,
                    iconColor: Colors.white.withValues(alpha: 0.8),
                  ),
                ],
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
    Map<String, dynamic> component, {
    InfoPointData? infoPoint,
  }) {
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
            color: Colors.black.withValues(alpha: 0.04),
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
          title: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.neutralGray900,
                ),
              ),
              if (infoPoint != null) ...[
                const SizedBox(width: 6),
                InfoPointHelper(data: infoPoint),
              ],
            ],
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
