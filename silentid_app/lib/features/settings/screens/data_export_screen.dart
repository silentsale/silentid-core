import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/constants/api_constants.dart';
import '../../../services/api_service.dart';

/// Data Export Screen
/// Level 7 Gamification + Level 7 Interactivity
class DataExportScreen extends StatefulWidget {
  const DataExportScreen({super.key});

  @override
  State<DataExportScreen> createState() => _DataExportScreenState();
}

class _DataExportScreenState extends State<DataExportScreen>
    with SingleTickerProviderStateMixin {
  final _api = ApiService();

  // Level 7: Animation controller
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  bool _isRequesting = false;

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
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _requestExport() async {
    setState(() => _isRequesting = true);

    try {
      await _api.post(ApiConstants.dataExportRequest);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Export requested. We\'ll email you a download link when ready.',
            ),
            duration: Duration(seconds: 4),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to request export: $e'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    } finally {
      setState(() => _isRequesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Export Your Data'),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.download_outlined,
              size: 64,
              color: AppTheme.primaryPurple,
            ),
            const SizedBox(height: 24),

            const Text(
              'Download Your SilentID Data',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.neutralGray900,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Text(
              'Get a complete copy of your data in JSON format. This includes:',
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.neutralGray700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            _buildDataItem('Profile information'),
            _buildDataItem('Identity verification status'),
            _buildDataItem('Evidence & receipts'),
            _buildDataItem('TrustScore history'),
            _buildDataItem('Connected profiles'),
            _buildDataItem('Activity logs'),

            const SizedBox(height: 32),

            PrimaryButton(
              text: 'Request Data Export',
              onPressed: _isRequesting ? null : _requestExport,
              isLoading: _isRequesting,
              icon: Icons.download,
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.softLilac.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: AppTheme.primaryPurple,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'How it works',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.neutralGray900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '1. We\'ll prepare your data export (this may take a few minutes)\n'
                    '2. You\'ll receive an email with a secure download link\n'
                    '3. The link will be valid for 7 days\n'
                    '4. Your data will be in JSON format',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.neutralGray700,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildDataItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppTheme.successGreen,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.neutralGray900,
            ),
          ),
        ],
      ),
    );
  }
}
