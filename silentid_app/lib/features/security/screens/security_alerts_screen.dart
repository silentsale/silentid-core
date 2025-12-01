import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptics.dart';
import '../../../services/security_api_service.dart';

/// Security Alerts screen (Section 15.4)
/// Shows security alerts with read/unread management
/// Level 7 Gamification + Level 7 Interactivity
class SecurityAlertsScreen extends StatefulWidget {
  const SecurityAlertsScreen({super.key});

  @override
  State<SecurityAlertsScreen> createState() => _SecurityAlertsScreenState();
}

class _SecurityAlertsScreenState extends State<SecurityAlertsScreen>
    with SingleTickerProviderStateMixin {
  final _securityApi = SecurityApiService();

  // Level 7: Animation controller
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  List<SecurityAlert> _alerts = [];
  int _unreadCount = 0;
  bool _isLoading = true;
  String? _error;
  bool _showAllAlerts = false;

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
    _loadAlerts();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadAlerts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _securityApi.getAlerts(includeRead: _showAllAlerts);
      setState(() {
        _alerts = response.alerts;
        _unreadCount = response.unreadCount;
        _isLoading = false;
      });
      // Level 7: Start animations after data loads
      _animController.forward();
    } catch (e) {
      setState(() {
        _error = 'Failed to load security alerts';
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(SecurityAlert alert) async {
    if (alert.isRead) return;

    try {
      await _securityApi.markAlertAsRead(alert.id);
      setState(() {
        final index = _alerts.indexWhere((a) => a.id == alert.id);
        if (index != -1) {
          // Create a new alert with isRead = true
          _alerts[index] = SecurityAlert(
            id: alert.id,
            type: alert.type,
            title: alert.title,
            message: alert.message,
            severity: alert.severity,
            isRead: true,
            createdAt: alert.createdAt,
          );
          _unreadCount = (_unreadCount - 1).clamp(0, _alerts.length);
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to mark alert as read'),
          backgroundColor: AppTheme.dangerRed,
        ),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    if (_unreadCount == 0) return;

    try {
      await _securityApi.markAllAlertsAsRead();
      setState(() {
        _alerts = _alerts.map((alert) => SecurityAlert(
          id: alert.id,
          type: alert.type,
          title: alert.title,
          message: alert.message,
          severity: alert.severity,
          isRead: true,
          createdAt: alert.createdAt,
        )).toList();
        _unreadCount = 0;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All alerts marked as read'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to mark alerts as read'),
          backgroundColor: AppTheme.dangerRed,
        ),
      );
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
          onPressed: () {
            AppHaptics.light();
            context.pop();
          },
        ),
        title: Text(
          'Security Alerts',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark all read',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryPurple))
            : _error != null
                ? _buildErrorState()
                : Column(
                    children: [
                      _buildFilterToggle(),
                      Expanded(
                        child: _alerts.isEmpty
                            ? _buildEmptyState()
                            : RefreshIndicator(
                                onRefresh: _loadAlerts,
                                color: AppTheme.primaryPurple,
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(24),
                                  itemCount: _alerts.length,
                                  // Level 7: Staggered animation for alert cards
                                  itemBuilder: (context, index) => _buildAnimatedAlertCard(index, _alerts[index]),
                                ),
                              ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildFilterToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Text(
            _unreadCount > 0 ? '$_unreadCount unread' : 'No unread alerts',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.neutralGray700,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              AppHaptics.light();
              setState(() {
                _showAllAlerts = !_showAllAlerts;
              });
              _loadAlerts();
            },
            child: Row(
              children: [
                Text(
                  _showAllAlerts ? 'Show unread only' : 'Show all',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryPurple,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _showAllAlerts ? Icons.filter_list : Icons.filter_list_off,
                  size: 16,
                  color: AppTheme.primaryPurple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Level 7: Animated alert card with staggered entrance
  Widget _buildAnimatedAlertCard(int index, SecurityAlert alert) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 50)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: _buildAlertCard(alert),
    );
  }

  Widget _buildAlertCard(SecurityAlert alert) {
    final dateFormatter = DateFormat('MMM d, yyyy • h:mm a');

    return GestureDetector(
      onTap: () {
        AppHaptics.light();
        _markAsRead(alert);
        _showAlertDetails(alert);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: alert.isRead
              ? AppTheme.pureWhite
              : AppTheme.primaryPurple.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: alert.isRead
                ? AppTheme.neutralGray300
                : AppTheme.primaryPurple.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getSeverityColor(alert.severity).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getAlertIcon(alert.type),
                color: _getSeverityColor(alert.severity),
                size: 20,
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
                          alert.title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: alert.isRead ? FontWeight.w500 : FontWeight.w600,
                            color: AppTheme.neutralGray900,
                          ),
                        ),
                      ),
                      if (!alert.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPurple,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert.message,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.neutralGray700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSeverityBadge(alert.severity),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          dateFormatter.format(alert.createdAt),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppTheme.neutralGray700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityBadge(int severity) {
    String label;
    Color color;

    if (severity >= 8) {
      label = 'Critical';
      color = AppTheme.dangerRed;
    } else if (severity >= 6) {
      label = 'High';
      color = AppTheme.warningAmber;
    } else if (severity >= 4) {
      label = 'Medium';
      color = AppTheme.warningAmber.withValues(alpha: 0.7);
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

  IconData _getAlertIcon(String type) {
    switch (type.toLowerCase()) {
      case 'breach':
        return Icons.warning_amber_rounded;
      case 'suspiciouslogin':
        return Icons.person_off_outlined;
      case 'deviceissue':
        return Icons.smartphone;
      case 'risksignal':
        return Icons.shield_outlined;
      case 'identityexpiring':
        return Icons.badge_outlined;
      case 'newdevice':
        return Icons.devices;
      case 'evidenceissue':
        return Icons.folder_off_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getSeverityColor(int severity) {
    if (severity >= 8) return AppTheme.dangerRed;
    if (severity >= 6) return AppTheme.warningAmber;
    if (severity >= 4) return AppTheme.primaryPurple;
    return AppTheme.successGreen;
  }

  void _showAlertDetails(SecurityAlert alert) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.pureWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.neutralGray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(alert.severity).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getAlertIcon(alert.type),
                      color: _getSeverityColor(alert.severity),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.title,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.neutralGray900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _buildSeverityBadge(alert.severity),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                alert.message,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.neutralGray700,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.neutralGray300.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Alert Type', _formatAlertType(alert.type)),
                    const SizedBox(height: 8),
                    _buildDetailRow('Created', DateFormat('MMMM d, yyyy • h:mm a').format(alert.createdAt)),
                    const SizedBox(height: 8),
                    _buildDetailRow('Status', alert.isRead ? 'Read' : 'Unread'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Dismiss',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.pureWhite,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.neutralGray700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.neutralGray900,
            ),
          ),
        ),
      ],
    );
  }

  String _formatAlertType(String type) {
    switch (type.toLowerCase()) {
      case 'breach':
        return 'Data Breach Alert';
      case 'suspiciouslogin':
        return 'Suspicious Login';
      case 'deviceissue':
        return 'Device Issue';
      case 'risksignal':
        return 'Risk Signal';
      case 'identityexpiring':
        return 'Identity Expiring';
      case 'newdevice':
        return 'New Device Detected';
      case 'evidenceissue':
        return 'Evidence Issue';
      default:
        return type;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 64,
                color: AppTheme.successGreen,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'All Clear!',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.neutralGray900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _showAllAlerts
                  ? 'You have no security alerts'
                  : 'No unread security alerts',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "We'll notify you if anything needs your attention",
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.neutralGray700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
              onPressed: _loadAlerts,
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
