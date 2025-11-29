import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/info_point_helper.dart';
import '../../../core/data/info_point_data.dart';
import '../../../services/receipt_api_service.dart';

/// Email Receipts Setup Screen
/// Section 47.4 - Expensify-inspired email forwarding model
/// Follows Section 53 UI Design Language
class EmailReceiptsSetupScreen extends StatefulWidget {
  const EmailReceiptsSetupScreen({super.key});

  @override
  State<EmailReceiptsSetupScreen> createState() => _EmailReceiptsSetupScreenState();
}

class _EmailReceiptsSetupScreenState extends State<EmailReceiptsSetupScreen> {
  final _receiptApi = ReceiptApiService();

  bool _isLoading = true;
  ForwardingAliasInfo? _aliasInfo;
  String _selectedProvider = 'gmail';

  @override
  void initState() {
    super.initState();
    _loadForwardingAlias();
  }

  Future<void> _loadForwardingAlias() async {
    setState(() => _isLoading = true);
    try {
      final info = await _receiptApi.getForwardingAlias();
      setState(() {
        _aliasInfo = info;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load forwarding address: $e'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    }
  }

  void _copyToClipboard() {
    if (_aliasInfo == null) return;

    Clipboard.setData(ClipboardData(text: _aliasInfo!.forwardingEmail));
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email address copied to clipboard'),
        backgroundColor: AppTheme.successGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Email Receipts',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            onPressed: () {
              context.push('/evidence/receipts');
            },
            tooltip: 'View Receipts',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with info point
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Forward Your Receipts',
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.deepBlack,
                          ),
                        ),
                      ),
                      InfoPointHelper(data: InfoPoints.evidenceVault),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  Text(
                    'Forward marketplace receipts to build your TrustScore. We extract transaction data only - your emails stay private.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.neutralGray700,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Forwarding Email Card
                  _buildForwardingEmailCard(),

                  const SizedBox(height: AppSpacing.lg),

                  // Provider Selection
                  _buildProviderSelector(),

                  const SizedBox(height: AppSpacing.md),

                  // Setup Instructions
                  _buildSetupInstructions(),

                  const SizedBox(height: AppSpacing.lg),

                  // Supported Platforms
                  _buildSupportedPlatforms(),

                  const SizedBox(height: AppSpacing.lg),

                  // Privacy Notice
                  _buildPrivacyNotice(),
                ],
              ),
            ),
    );
  }

  Widget _buildForwardingEmailCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.email_outlined,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Your Forwarding Address',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _aliasInfo?.forwardingEmail ?? 'Loading...',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _copyToClipboard,
                  icon: const Icon(Icons.copy, color: Colors.white),
                  tooltip: 'Copy',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This is your unique address. Forward receipts here.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Email Provider',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.deepBlack,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            _buildProviderChip('gmail', 'Gmail', Icons.mail),
            const SizedBox(width: AppSpacing.sm),
            _buildProviderChip('outlook', 'Outlook', Icons.email),
            const SizedBox(width: AppSpacing.sm),
            _buildProviderChip('manual', 'Manual', Icons.forward_to_inbox),
          ],
        ),
      ],
    );
  }

  Widget _buildProviderChip(String id, String label, IconData icon) {
    final isSelected = _selectedProvider == id;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedProvider = id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryPurple : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryPurple : AppTheme.neutralGray300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppTheme.neutralGray700,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppTheme.neutralGray700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupInstructions() {
    final instructions = _getInstructions();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.neutralGray300.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.checklist,
                size: 20,
                color: AppTheme.primaryPurple,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Setup Instructions',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.deepBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...instructions.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPurple,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      entry.value,
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
          }),
        ],
      ),
    );
  }

  List<String> _getInstructions() {
    if (_aliasInfo == null) return [];

    switch (_selectedProvider) {
      case 'gmail':
        return _aliasInfo!.instructions.gmail;
      case 'outlook':
        return _aliasInfo!.instructions.outlook;
      default:
        return _aliasInfo!.instructions.manual;
    }
  }

  Widget _buildSupportedPlatforms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supported Platforms',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.deepBlack,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: (_aliasInfo?.supportedPlatforms ?? []).map((platform) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.softLilac,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                platform.name,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryPurple,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPrivacyNotice() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.successGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.successGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 24,
            color: AppTheme.successGreen,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Privacy is Protected',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'We only extract transaction metadata (seller, date, amount). Raw emails are deleted immediately. We never access your inbox.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.neutralGray700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
