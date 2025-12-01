import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/safety_report.dart';
import '../../../services/api_service.dart';
import '../../../services/safety_service.dart';

/// Report Details Screen
/// Level 7 Gamification + Level 7 Interactivity
class ReportDetailsScreen extends StatefulWidget {
  final String reportId;

  const ReportDetailsScreen({
    super.key,
    required this.reportId,
  });

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen>
    with SingleTickerProviderStateMixin {
  // Level 7: Animation controller
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  final _safetyService = SafetyService(ApiService());

  SafetyReport? _report;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Level 7: Initialize animations
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _loadReport();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadReport() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final report = await _safetyService.getById(widget.reportId);
      if (mounted) {
        setState(() {
          _report = report;
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppTheme.warningAmber;
      case 'underreview':
        return AppTheme.primaryPurple;
      case 'verified':
        return AppTheme.successGreen;
      case 'dismissed':
        return AppTheme.neutralGray700;
      default:
        return AppTheme.neutralGray700;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending;
      case 'underreview':
        return Icons.search;
      case 'verified':
        return Icons.check_circle;
      case 'dismissed':
        return Icons.cancel;
      default:
        return Icons.info;
    }
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
          'Report Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildErrorState()
                : RefreshIndicator(
                    onRefresh: _loadReport,
                    color: AppTheme.primaryPurple,
                    child: _buildContent(),
                  ),
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
            'Failed to load report',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _loadReport,
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final statusColor = _getStatusColor(_report!.status);
    final statusIcon = _getStatusIcon(_report!.status);

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
                color: statusColor.withValues(alpha: 0.1),
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
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor, width: 1.5),
              ),
              child: Text(
                _report!.statusLabel,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Report Details Card
          _buildDetailsCard(
            'Report Information',
            [
              _buildDetailRow('Category', _report!.categoryLabel),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Reported User',
                '${_report!.reportedUserName ?? 'Unknown'} (@${_report!.reportedUserUsername ?? 'unknown'})',
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                'Submitted',
                _formatDate(_report!.createdAt),
              ),
              if (_report!.evidence != null &&
                  _report!.evidence!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildDetailRow(
                  'Evidence Files',
                  '${_report!.evidence!.length} file(s) attached',
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),

          // Description Card
          _buildDetailsCard(
            'Description',
            [
              Text(
                _report!.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.neutralGray900,
                  height: 1.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Evidence Card (if exists)
          if (_report!.evidence != null && _report!.evidence!.isNotEmpty)
            _buildDetailsCard(
              'Evidence',
              List.generate(
                _report!.evidence!.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: index < _report!.evidence!.length - 1 ? 12 : 0,
                  ),
                  child: _buildEvidenceItem(index + 1),
                ),
              ),
            ),
          const SizedBox(height: 20),

          // Status Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _getStatusIcon(_report!.status),
                  color: statusColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getStatusMessage(_report!.status),
                    style: TextStyle(
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
            color: Colors.black.withValues(alpha: 0.04),
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

  Widget _buildEvidenceItem(int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.softLilac,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.attach_file,
            color: AppTheme.primaryPurple,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Evidence file $index',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.neutralGray900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Your report has been received and is pending review by our moderation team.';
      case 'underreview':
        return 'Our moderation team is currently reviewing your report and the evidence provided.';
      case 'verified':
        return 'Your report has been verified and appropriate action has been taken. Thank you for helping keep the community safe.';
      case 'dismissed':
        return 'After review, this report was dismissed. If you have additional evidence, you may submit a new report.';
      default:
        return 'Report status is being processed.';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes} minutes ago';
      }
      return '${diff.inHours} hours ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
