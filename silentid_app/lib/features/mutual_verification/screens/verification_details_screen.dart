import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../models/mutual_verification.dart';
import '../../../services/api_service.dart';
import '../../../services/mutual_verification_service.dart';

class VerificationDetailsScreen extends StatefulWidget {
  final String verificationId;

  const VerificationDetailsScreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<VerificationDetailsScreen> createState() =>
      _VerificationDetailsScreenState();
}

class _VerificationDetailsScreenState extends State<VerificationDetailsScreen> {
  final _mutualVerificationService =
      MutualVerificationService(ApiService());

  MutualVerification? _verification;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadVerification();
  }

  Future<void> _loadVerification() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final verification =
          await _mutualVerificationService.getById(widget.verificationId);
      if (mounted) {
        setState(() {
          _verification = verification;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Color _getStatusColor() {
    if (_verification == null) return AppTheme.neutralGray700;
    if (_verification!.isConfirmed) return AppTheme.successGreen;
    if (_verification!.isRejected) return AppTheme.dangerRed;
    if (_verification!.isPending) return AppTheme.warningAmber;
    return AppTheme.neutralGray700;
  }

  IconData _getStatusIcon() {
    if (_verification == null) return Icons.info;
    if (_verification!.isConfirmed) return Icons.check_circle;
    if (_verification!.isRejected) return Icons.cancel;
    if (_verification!.isPending) return Icons.pending;
    return Icons.info;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Verification Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState()
              : RefreshIndicator(
                  onRefresh: _loadVerification,
                  color: AppTheme.primaryPurple,
                  child: _buildContent(),
                ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.dangerRed,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load verification',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _loadVerification,
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final statusColor = _getStatusColor();
    final statusIcon = _getStatusIcon();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                statusIcon,
                size: 60,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Status Label
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor, width: 1.5),
              ),
              child: Text(
                _verification!.statusLabel,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Transaction Details Card
          _buildDetailsCard(
            'Transaction Details',
            [
              _buildDetailRow('Item', _verification!.item),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Amount',
                '£${_verification!.amount.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Date',
                '${_verification!.date.day}/${_verification!.date.month}/${_verification!.date.year}',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Participants Card
          _buildDetailsCard(
            'Participants',
            [
              _buildDetailRow(
                'You',
                _verification!.roleA,
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Other Party',
                '${_verification!.otherUserName ?? 'Unknown'} (@${_verification!.otherUserUsername ?? 'unknown'})',
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Their Role',
                _verification!.roleB,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Timeline Card
          _buildDetailsCard(
            'Timeline',
            [
              _buildTimelineItem(
                'Request Created',
                _verification!.createdAt,
                true,
              ),
              if (_verification!.isConfirmed || _verification!.isRejected) ...[
                const SizedBox(height: 16),
                _buildTimelineItem(
                  _verification!.isConfirmed
                      ? 'Confirmed'
                      : 'Rejected',
                  _verification!.createdAt,
                  true,
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),

          // Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.softLilac,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryPurple,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _verification!.isConfirmed
                        ? 'This transaction has been mutually verified and contributes to both parties\' TrustScores.'
                        : _verification!.isPending
                            ? 'This verification is pending confirmation from the other party.'
                            : 'This verification was not confirmed and does not affect TrustScores.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.neutralGray700,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.neutralGray900,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.neutralGray700,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.neutralGray900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(String event, DateTime time, bool isDone) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isDone ? AppTheme.primaryPurple : AppTheme.neutralGray300,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDone
                      ? AppTheme.neutralGray900
                      : AppTheme.neutralGray700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${time.day}/${time.month}/${time.year} at ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
