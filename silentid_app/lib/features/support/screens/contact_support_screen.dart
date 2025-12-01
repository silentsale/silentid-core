import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/info_point_helper.dart';
import '../../../core/data/info_point_data.dart';
import '../../../services/support_service.dart';
import '../../../services/api_service.dart';

/// Contact Support Screen
/// Level 7 Gamification + Level 7 Interactivity
///
/// Unified help system accessible anywhere in the app.
/// Follows Section 53 UI guidelines.
class ContactSupportScreen extends StatefulWidget {
  /// Optional pre-selected category (for contextual support)
  final SupportCategory? initialCategory;

  const ContactSupportScreen({
    super.key,
    this.initialCategory,
  });

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen>
    with SingleTickerProviderStateMixin {
  // Level 7: Animation controller
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  SupportCategory? _selectedCategory;
  final _messageController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;
  bool _isSuccess = false;

  late final SupportService _supportService;

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
    _supportService = SupportService(ApiService());
    _selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    _animController.dispose();
    _messageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitTicket() async {
    if (_selectedCategory == null) {
      setState(() {
        _errorMessage = 'Please select a category';
      });
      return;
    }

    if (_messageController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please describe your issue';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final result = await _supportService.createTicket(
      category: _selectedCategory!,
      message: _messageController.text.trim(),
      contactEmail: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
    );

    setState(() {
      _isSubmitting = false;
      if (result.success) {
        _isSuccess = true;
      } else {
        _errorMessage = result.message;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureWhite,
      appBar: AppBar(
        title: Text(
          'Contact Support',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          InfoPointHelper(data: InfoPoints.contactSupport),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: _isSuccess ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppTheme.softLilac.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.support_agent,
                    color: AppTheme.primaryPurple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How can we help?',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.deepBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Our team typically responds within 24-48 hours',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.neutralGray700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Category selection
          Text(
            'What do you need help with?',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.deepBlack,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Category grid
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: SupportCategory.values.map((category) {
              return _buildCategoryChip(category);
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Message input
          Text(
            'Describe your issue',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.deepBlack,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          TextField(
            controller: _messageController,
            maxLines: 5,
            maxLength: 2000,
            decoration: InputDecoration(
              hintText: 'Please describe your issue in detail...',
              hintStyle: GoogleFonts.inter(
                color: AppTheme.neutralGray700,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.neutralGray300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.neutralGray300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryPurple, width: 2),
              ),
            ),
            style: GoogleFonts.inter(fontSize: 16),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Optional email (for non-logged in users)
          Text(
            'Contact email (optional)',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.deepBlack,
            ),
          ),

          const SizedBox(height: AppSpacing.xxs),

          Text(
            'We\'ll use your account email if not provided',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.neutralGray700,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'your@email.com',
              hintStyle: GoogleFonts.inter(
                color: AppTheme.neutralGray700,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.neutralGray300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.neutralGray300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryPurple, width: 2),
              ),
            ),
            style: GoogleFonts.inter(fontSize: 16),
          ),

          const SizedBox(height: AppSpacing.md),

          // Privacy notice
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppTheme.neutralGray300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppTheme.neutralGray700,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Device info and app version will be attached to help us diagnose issues.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.neutralGray700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppTheme.dangerRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppTheme.dangerRed,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.dangerRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitTicket,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.pureWhite,
                      ),
                    )
                  : Text(
                      'Send Message',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.pureWhite,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(SupportCategory category) {
    final isSelected = _selectedCategory == category;
    final icon = _getCategoryIcon(category);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
          _errorMessage = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryPurple.withValues(alpha: 0.1) : AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryPurple : AppTheme.neutralGray300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppTheme.primaryPurple : AppTheme.neutralGray700,
            ),
            const SizedBox(width: 8),
            Text(
              category.displayText,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppTheme.primaryPurple : AppTheme.deepBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(SupportCategory category) {
    switch (category) {
      case SupportCategory.accountLogin:
        return Icons.lock_outline;
      case SupportCategory.verificationHelp:
        return Icons.verified_user_outlined;
      case SupportCategory.technicalIssue:
        return Icons.bug_report_outlined;
      case SupportCategory.generalQuestion:
        return Icons.help_outline;
      case SupportCategory.billing:
        return Icons.credit_card_outlined;
      case SupportCategory.privacyData:
        return Icons.privacy_tip_outlined;
    }
  }

  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                size: 60,
                color: AppTheme.successGreen,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              'Message Sent!',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppTheme.deepBlack,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.md),

            // Message
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppTheme.softLilac.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Thanks — our support team will review this shortly. We typically respond within 24-48 hours.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppTheme.deepBlack,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Done button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Done',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.pureWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
