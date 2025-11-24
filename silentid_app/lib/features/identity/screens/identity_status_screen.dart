import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/api_constants.dart';

enum VerificationStatus {
  pending,
  verified,
  failed,
  needsRetry,
}

class IdentityStatusScreen extends StatefulWidget {
  const IdentityStatusScreen({super.key});

  @override
  State<IdentityStatusScreen> createState() => _IdentityStatusScreenState();
}

class _IdentityStatusScreenState extends State<IdentityStatusScreen> {
  final _api = ApiService();
  bool _isLoading = true;
  VerificationStatus _status = VerificationStatus.pending;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    setState(() => _isLoading = true);

    try {
      final response = await _api.get(ApiConstants.identityStatus);
      final status = response.data['status']?.toString().toLowerCase();

      setState(() {
        switch (status) {
          case 'verified':
            _status = VerificationStatus.verified;
            _message = 'Identity Verified';
            break;
          case 'failed':
            _status = VerificationStatus.failed;
            _message = 'Verification unsuccessful';
            break;
          case 'needs_retry':
            _status = VerificationStatus.needsRetry;
            _message = 'We couldn\'t verify your ID';
            break;
          default:
            _status = VerificationStatus.pending;
            _message = 'Verification in progress';
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = VerificationStatus.pending;
        _message = 'Unable to check status';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verification Status',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppTheme.deepBlack,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 48),

                    // Status icon
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: _getStatusColor().withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getStatusIcon(),
                          size: 64,
                          color: _getStatusColor(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Status message
                    Text(
                      _message,
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.deepBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    // Status description
                    Text(
                      _getStatusDescription(),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppTheme.neutralGray700,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    // Status badge (only if verified)
                    if (_status == VerificationStatus.verified)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.softLilac,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.verified,
                              color: AppTheme.primaryPurple,
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Identity Verified via Stripe',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.deepBlack,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '+200 TrustScore points',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: AppTheme.primaryPurple,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    const Spacer(),

                    // Action button
                    PrimaryButton(
                      text: _getButtonText(),
                      onPressed: _getButtonAction(),
                    ),

                    const SizedBox(height: 16),

                    // Secondary button
                    if (_status != VerificationStatus.verified)
                      PrimaryButton(
                        text: 'Go Back',
                        isSecondary: true,
                        onPressed: () => context.pop(),
                      ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Color _getStatusColor() {
    switch (_status) {
      case VerificationStatus.verified:
        return AppTheme.successGreen;
      case VerificationStatus.failed:
      case VerificationStatus.needsRetry:
        return AppTheme.dangerRed;
      case VerificationStatus.pending:
        return AppTheme.warningAmber;
    }
  }

  IconData _getStatusIcon() {
    switch (_status) {
      case VerificationStatus.verified:
        return Icons.check_circle;
      case VerificationStatus.failed:
      case VerificationStatus.needsRetry:
        return Icons.error;
      case VerificationStatus.pending:
        return Icons.hourglass_empty;
    }
  }

  String _getStatusDescription() {
    switch (_status) {
      case VerificationStatus.verified:
        return 'Your identity has been successfully verified. You\'ve earned +200 TrustScore points and unlocked advanced features.';
      case VerificationStatus.failed:
        return 'We were unable to verify your identity. Please ensure your documents are clear and try again.';
      case VerificationStatus.needsRetry:
        return 'Your documents didn\'t meet the requirements. Please try again with a different photo.';
      case VerificationStatus.pending:
        return 'We\'re processing your verification. This usually takes a few moments. Check back soon.';
    }
  }

  String _getButtonText() {
    switch (_status) {
      case VerificationStatus.verified:
        return 'View My Profile';
      case VerificationStatus.failed:
      case VerificationStatus.needsRetry:
        return 'Try Again';
      case VerificationStatus.pending:
        return 'Refresh Status';
    }
  }

  VoidCallback _getButtonAction() {
    return () {
      switch (_status) {
        case VerificationStatus.verified:
          context.go('/home');
          break;
        case VerificationStatus.failed:
        case VerificationStatus.needsRetry:
          context.push('/identity/verify');
          break;
        case VerificationStatus.pending:
          _checkStatus();
          break;
      }
    };
  }
}
