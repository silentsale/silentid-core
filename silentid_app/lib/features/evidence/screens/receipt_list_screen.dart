import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/evidence_service.dart';
import '../../../services/receipt_api_service.dart' hide Receipt;
import '../../../models/evidence_models.dart';
import 'package:intl/intl.dart';

class ReceiptListScreen extends StatefulWidget {
  const ReceiptListScreen({super.key});

  @override
  State<ReceiptListScreen> createState() => _ReceiptListScreenState();
}

class _ReceiptListScreenState extends State<ReceiptListScreen> {
  final _evidenceService = EvidenceService();
  final _receiptApi = ReceiptApiService();
  List<Receipt> _receipts = [];
  bool _isLoading = true;
  String? _error;
  String? _forwardingEmail;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadReceipts(),
      _loadForwardingEmail(),
    ]);
  }

  Future<void> _loadReceipts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final receipts = await _evidenceService.getReceipts();
      setState(() {
        _receipts = receipts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadForwardingEmail() async {
    try {
      final aliasInfo = await _receiptApi.getForwardingAlias();
      setState(() {
        _forwardingEmail = aliasInfo.forwardingEmail;
      });
    } catch (e) {
      // Ignore - forwarding email is optional UI element
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Email Receipts',
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
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryPurple,
                ),
              )
            : _error != null
                ? _buildErrorState()
                : _receipts.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadReceipts,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(24.0),
                          itemCount: _receipts.length + 1, // +1 for banner
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _buildForwardingEmailBanner();
                            }
                            return _buildReceiptCard(_receipts[index - 1]);
                          },
                        ),
                      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/evidence/receipts/upload');
          _loadReceipts(); // Refresh after adding
        },
        backgroundColor: AppTheme.primaryPurple,
        icon: const Icon(Icons.add, color: AppTheme.pureWhite),
        label: Text(
          'Add Receipt',
          style: GoogleFonts.inter(
            color: AppTheme.pureWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildForwardingEmailBanner() {
    if (_forwardingEmail == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.email_outlined, color: AppTheme.pureWhite, size: 20),
              const SizedBox(width: 8),
              Text(
                'Email Forwarding Active',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.pureWhite,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => context.push('/evidence/receipts/email-setup'),
                child: Text(
                  'Settings',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.pureWhite.withValues(alpha: 0.9),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _forwardingEmail!,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.pureWhite.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptCard(Receipt receipt) {
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.neutralGray300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Platform and role badges
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.softLilac,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  receipt.platform,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryPurple,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: receipt.role == 'Buyer'
                      ? AppTheme.successGreen.withValues(alpha: 0.1)
                      : AppTheme.warningAmber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  receipt.role,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: receipt.role == 'Buyer'
                        ? AppTheme.successGreen
                        : AppTheme.warningAmber,
                  ),
                ),
              ),
              const Spacer(),
              // Integrity score indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getIntegrityColor(receipt.integrityScore).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified,
                      size: 14,
                      color: _getIntegrityColor(receipt.integrityScore),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${receipt.integrityScore}%',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getIntegrityColor(receipt.integrityScore),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Item name
          if (receipt.item != null)
            Text(
              receipt.item!,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBlack,
              ),
            ),

          const SizedBox(height: 8),

          // Amount and date
          Row(
            children: [
              Text(
                '${receipt.currency} ${receipt.amount.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryPurple,
                ),
              ),
              const Spacer(),
              Text(
                dateFormatter.format(receipt.date),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.neutralGray700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getIntegrityColor(int score) {
    if (score >= 90) return AppTheme.successGreen;
    if (score >= 70) return AppTheme.warningAmber;
    return AppTheme.dangerRed;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 80,
              color: AppTheme.neutralGray300,
            ),
            const SizedBox(height: 24),
            Text(
              'No Receipts Yet',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBlack,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add your first receipt to start building your TrustScore',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
                height: 1.5,
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
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: AppTheme.dangerRed,
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to Load Receipts',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBlack,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _error ?? 'Unknown error',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadReceipts,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                foregroundColor: AppTheme.pureWhite,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
