import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../services/referral_api_service.dart';

/// Referral Program Screen (Section 50.6.1)
///
/// "Invite a friend → both get +50 TrustScore bonus once identity is verified."
///
/// Features:
/// - Unique referral code/link generation
/// - Share functionality
/// - Referral tracking (pending, completed)
/// - Reward display
class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final _referralApi = ReferralApiService();

  bool _isLoading = true;
  String? _referralCode;
  String? _referralLink;
  List<ReferralStatus> _referrals = [];
  int _totalEarnedPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadReferralData();
  }

  Future<void> _loadReferralData() async {
    setState(() => _isLoading = true);

    try {
      // Fetch referral summary and list from API
      final summary = await _referralApi.getReferralSummary();
      final referralList = await _referralApi.getReferralList();

      setState(() {
        _referralCode = summary.referralCode;
        _referralLink = summary.referralLink;
        _totalEarnedPoints = summary.totalPointsEarned;
        _referrals = referralList.map((r) => ReferralStatus(
          name: r.name,
          initials: r.initials,
          status: r.referralState,
          earnedPoints: r.pointsEarned,
          invitedAt: r.invitedAt,
          completedAt: r.completedAt,
        )).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load referral data: $e')),
        );
      }
    }
  }

  Future<void> _copyReferralCode() async {
    if (_referralCode == null) return;

    await Clipboard.setData(ClipboardData(text: _referralCode!));
    HapticFeedback.lightImpact();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Referral code copied!'),
          backgroundColor: AppTheme.successGreen,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _shareReferralLink() async {
    if (_referralLink == null) return;

    HapticFeedback.lightImpact();

    await SharePlus.instance.share(
      ShareParams(
        text: 'Join me on SilentID and we both get +50 TrustScore bonus! Use my link: $_referralLink',
        subject: 'Join SilentID - Build Your Trust Reputation',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Invite Friends',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppTheme.deepBlack,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadReferralData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Reward banner
                    _buildRewardBanner(),
                    const SizedBox(height: 24),

                    // Referral code section
                    _buildReferralCodeSection(),
                    const SizedBox(height: 24),

                    // Share buttons
                    _buildShareSection(),
                    const SizedBox(height: 32),

                    // How it works
                    _buildHowItWorks(),
                    const SizedBox(height: 32),

                    // Referral history
                    if (_referrals.isNotEmpty) _buildReferralHistory(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildRewardBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryPurple,
            AppTheme.primaryPurple.withValues(alpha: 0.85),
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Give +50, Get +50',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Both you and your friend earn TrustScore bonus!',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_totalEarnedPoints > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'You\'ve earned $_totalEarnedPoints bonus points!',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReferralCodeSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.softLilac.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Your Referral Code',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.neutralGray700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryPurple,
                    width: 2,
                  ),
                ),
                child: Text(
                  _referralCode ?? '...',
                  style: GoogleFonts.firaCode(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryPurple,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: _copyReferralCode,
                icon: const Icon(Icons.copy),
                color: AppTheme.primaryPurple,
                tooltip: 'Copy code',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareSection() {
    return Column(
      children: [
        PrimaryButton(
          text: 'Share Invite Link',
          icon: Icons.share,
          onPressed: _shareReferralLink,
        ),
        const SizedBox(height: 12),
        Text(
          'or share via',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppTheme.neutralGray700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildShareButton(
              icon: Icons.message,
              label: 'Message',
              onTap: _shareReferralLink,
            ),
            const SizedBox(width: 16),
            _buildShareButton(
              icon: Icons.email,
              label: 'Email',
              onTap: _shareReferralLink,
            ),
            const SizedBox(width: 16),
            _buildShareButton(
              icon: Icons.qr_code,
              label: 'QR Code',
              onTap: () {
                // TODO: Show QR code modal
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShareButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.neutralGray300.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryPurple,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.neutralGray700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorks() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.neutralGray300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: AppTheme.warningAmber,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'How it works',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStep(1, 'Share your unique link or code'),
          _buildStep(2, 'Friend signs up and verifies identity'),
          _buildStep(3, 'You both get +50 TrustScore bonus!'),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralHistory() {
    final completedCount = _referrals.where((r) => r.status == ReferralState.completed).length;
    final pendingCount = _referrals.where((r) => r.status == ReferralState.pending).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Referrals',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.deepBlack,
              ),
            ),
            Row(
              children: [
                _buildStatusChip('$completedCount completed', AppTheme.successGreen),
                const SizedBox(width: 8),
                _buildStatusChip('$pendingCount pending', AppTheme.warningAmber),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...(_referrals.map((referral) => _buildReferralCard(referral))),
      ],
    );
  }

  Widget _buildStatusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

  Widget _buildReferralCard(ReferralStatus referral) {
    final isCompleted = referral.status == ReferralState.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.successGreen.withValues(alpha: 0.05)
            : AppTheme.neutralGray300.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? AppTheme.successGreen.withValues(alpha: 0.3)
              : AppTheme.neutralGray300,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                referral.initials,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  referral.name,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepBlack,
                  ),
                ),
                Text(
                  isCompleted
                      ? 'Verified ${_formatDate(referral.completedAt)}'
                      : 'Invited ${_formatDate(referral.invitedAt)}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),
          if (isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add,
                    color: AppTheme.successGreen,
                    size: 14,
                  ),
                  Text(
                    '${referral.earnedPoints}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.successGreen,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.warningAmber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Pending',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.warningAmber,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'today';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Referral status model (uses ReferralState from referral_api_service.dart)
class ReferralStatus {
  final String name;
  final String initials;
  final ReferralState status;
  final int earnedPoints;
  final DateTime? invitedAt;
  final DateTime? completedAt;

  const ReferralStatus({
    required this.name,
    required this.initials,
    required this.status,
    required this.earnedPoints,
    this.invitedAt,
    this.completedAt,
  });
}
