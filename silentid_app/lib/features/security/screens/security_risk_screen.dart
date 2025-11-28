import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/security_api_service.dart';

/// Security Risk Status screen (Section 15.2)
/// Shows user's risk score and active risk signals
class SecurityRiskScreen extends StatefulWidget {
  const SecurityRiskScreen({super.key});

  @override
  State<SecurityRiskScreen> createState() => _SecurityRiskScreenState();
}

class _SecurityRiskScreenState extends State<SecurityRiskScreen> {
  final _securityApi = SecurityApiService();

  RiskStatusResponse? _riskStatus;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRiskStatus();
  }

  Future<void> _loadRiskStatus() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _securityApi.getRiskStatus();
      setState(() {
        _riskStatus = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load risk status';
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
          'Risk Status',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryPurple))
          : _error != null
              ? _buildErrorState()
              : RefreshIndicator(
                  onRefresh: _loadRiskStatus,
                  color: AppTheme.primaryPurple,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRiskScoreCard(),
                        const SizedBox(height: 24),
                        _buildRiskInfoCard(),
                        const SizedBox(height: 24),
                        if (_riskStatus?.activeSignals.isNotEmpty == true) ...[
                          _buildActiveSignals(),
                          const SizedBox(height: 24),
                        ],
                        _buildWhatAffectsRisk(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildRiskScoreCard() {
    final riskScore = _riskStatus?.riskScore ?? 0;
    final riskLevel = _riskStatus?.riskLevel ?? 'None';
    final isSecure = riskLevel == 'None' || riskLevel == 'Low';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isSecure
              ? [AppTheme.successGreen, AppTheme.successGreen.withValues(alpha: 0.8)]
              : riskLevel == 'Moderate'
                  ? [AppTheme.warningAmber, AppTheme.warningAmber.withValues(alpha: 0.8)]
                  : [AppTheme.dangerRed, AppTheme.dangerRed.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            isSecure ? Icons.verified_user : Icons.shield_outlined,
            color: AppTheme.pureWhite,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            riskLevel == 'None' ? 'No Risk Detected' : '$riskLevel Risk',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.pureWhite,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isSecure
                ? 'Your account security looks good'
                : 'Some attention may be needed',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.pureWhite.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.pureWhite.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Risk Score: $riskScore / 100',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.pureWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryPurple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryPurple.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppTheme.primaryPurple, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Risk signals are based on account behavior patterns. A higher score indicates more potential issues detected.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.neutralGray700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSignals() {
    final signals = _riskStatus?.activeSignals ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Risk Signals',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        const SizedBox(height: 12),
        ...signals.map((signal) => _buildSignalCard(signal)),
      ],
    );
  }

  Widget _buildSignalCard(RiskSignal signal) {
    final dateFormatter = DateFormat('MMM d, yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getSeverityColor(signal.severity).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getSeverityColor(signal.severity).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: _getSeverityColor(signal.severity),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        signal.type,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.neutralGray900,
                        ),
                      ),
                    ),
                    _buildSeverityBadge(signal.severity),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  signal.message,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.neutralGray700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Detected ${dateFormatter.format(signal.createdAt)}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
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

  Widget _buildSeverityBadge(int severity) {
    String label;
    Color color;

    if (severity >= 8) {
      label = 'High';
      color = AppTheme.dangerRed;
    } else if (severity >= 5) {
      label = 'Medium';
      color = AppTheme.warningAmber;
    } else {
      label = 'Low';
      color = AppTheme.successGreen;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getSeverityColor(int severity) {
    if (severity >= 8) return AppTheme.dangerRed;
    if (severity >= 5) return AppTheme.warningAmber;
    return AppTheme.successGreen;
  }

  Widget _buildWhatAffectsRisk() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What Affects Your Risk Score',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        const SizedBox(height: 12),
        _buildRiskFactorItem(
          icon: Icons.login,
          title: 'Login Patterns',
          description: 'Unusual login locations or times',
        ),
        _buildRiskFactorItem(
          icon: Icons.devices,
          title: 'Device Changes',
          description: 'New or untrusted devices accessing your account',
        ),
        _buildRiskFactorItem(
          icon: Icons.security,
          title: 'Account Activity',
          description: 'Failed verification attempts or suspicious actions',
        ),
        _buildRiskFactorItem(
          icon: Icons.verified_user,
          title: 'Identity Verification',
          description: 'Incomplete or expired identity verification',
        ),
      ],
    );
  }

  Widget _buildRiskFactorItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.neutralGray300.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.neutralGray700, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralGray900,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
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
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _loadRiskStatus,
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
}
