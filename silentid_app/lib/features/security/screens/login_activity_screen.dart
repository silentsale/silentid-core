import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/security_api_service.dart';

/// Login Activity screen (Section 15.3)
/// Shows complete history of SilentID account logins
class LoginActivityScreen extends StatefulWidget {
  const LoginActivityScreen({super.key});

  @override
  State<LoginActivityScreen> createState() => _LoginActivityScreenState();
}

class _LoginActivityScreenState extends State<LoginActivityScreen> {
  final _securityApi = SecurityApiService();

  List<LoginEntry> _logins = [];
  int _totalCount = 0;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLoginHistory();
  }

  Future<void> _loadLoginHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _securityApi.getLoginHistory(limit: 100);
      setState(() {
        _logins = response.logins;
        _totalCount = response.totalCount;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load login history';
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
          'Login Activity',
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
              : _logins.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadLoginHistory,
                      color: AppTheme.primaryPurple,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(24),
                        itemCount: _logins.length + 1, // +1 for header
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return _buildHeader();
                          }
                          return _buildLoginCard(_logins[index - 1]);
                        },
                      ),
                    ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                  'This shows all sign-in attempts to your SilentID account. Active sessions are highlighted.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.neutralGray700,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '$_totalCount total logins',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppTheme.neutralGray700,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLoginCard(LoginEntry login) {
    final dateFormatter = DateFormat('MMM d, yyyy');
    final timeFormatter = DateFormat('h:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: login.isActive
              ? AppTheme.successGreen.withValues(alpha: 0.5)
              : AppTheme.neutralGray300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: login.isActive
                      ? AppTheme.successGreen.withValues(alpha: 0.1)
                      : AppTheme.neutralGray300.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getDeviceIcon(login),
                  color: login.isActive ? AppTheme.successGreen : AppTheme.neutralGray700,
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
                        Flexible(
                          child: Text(
                            login.deviceDescription,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.neutralGray900,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (login.isActive) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.successGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Active',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.pureWhite,
                              ),
                            ),
                          ),
                        ],
                        if (login.isTrusted) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.verified, color: AppTheme.primaryPurple, size: 16),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      login.ipAddress ?? 'Unknown IP',
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
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppTheme.neutralGray300),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: AppTheme.neutralGray700),
              const SizedBox(width: 6),
              Text(
                dateFormatter.format(login.timestamp),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.neutralGray700,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 14, color: AppTheme.neutralGray700),
              const SizedBox(width: 6),
              Text(
                timeFormatter.format(login.timestamp),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.neutralGray700,
                ),
              ),
            ],
          ),
          if (login.browser != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.language, size: 14, color: AppTheme.neutralGray700),
                const SizedBox(width: 6),
                Text(
                  login.browser!,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData _getDeviceIcon(LoginEntry login) {
    final os = login.os?.toLowerCase() ?? '';
    if (os.contains('ios') || os.contains('iphone') || os.contains('ipad')) {
      return Icons.phone_iphone;
    } else if (os.contains('android')) {
      return Icons.phone_android;
    } else if (os.contains('windows') || os.contains('mac') || os.contains('linux')) {
      return Icons.computer;
    }
    return Icons.devices;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: AppTheme.neutralGray300),
            const SizedBox(height: 16),
            Text(
              'No login history',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your login activity will appear here',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
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
              onPressed: _loadLoginHistory,
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
