import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/enums/button_variant.dart';
import '../../../services/auth_service.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _authService = AuthService();
  final _usernameController = TextEditingController();
  bool _confirmChecked = false;
  bool _isDeleting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  bool get _canDelete =>
      _confirmChecked &&
      _usernameController.text.isNotEmpty &&
      !_isDeleting;

  Future<void> _deleteAccount() async {
    // Final confirmation
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Are you absolutely sure?',
          style: TextStyle(color: AppTheme.dangerRed),
        ),
        content: const Text(
          'This action is permanent and cannot be undone. All your data will be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.dangerRed,
            ),
            child: const Text('Yes, Delete My Account'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isDeleting = true);

    try {
      // TODO: Replace with actual API call
      // await ApiService().delete('/users/me');

      await Future.delayed(const Duration(seconds: 2));

      // Clear auth data
      await _authService.logout();

      if (mounted) {
        context.go('/');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your account has been deleted'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    } catch (e) {
      setState(() => _isDeleting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Delete Account'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Warning Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.dangerRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                size: 64,
                color: AppTheme.dangerRed,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Delete Your Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.neutralGray900,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Warning Messages
            _buildWarningCard(
              '⚠️ This action is permanent and cannot be undone',
            ),
            const SizedBox(height: 12),

            _buildWarningCard(
              '⚠️ Your TrustScore, evidence, and profile will be deleted',
            ),
            const SizedBox(height: 12),

            _buildWarningCard(
              '⚠️ You will need to create a new account to use SilentID again',
            ),

            const SizedBox(height: 32),

            // Confirmation Steps
            const Text(
              'To delete your account:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray900,
              ),
            ),

            const SizedBox(height: 16),

            // Step 1: Checkbox
            InkWell(
              onTap: () {
                setState(() => _confirmChecked = !_confirmChecked);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _confirmChecked
                        ? AppTheme.dangerRed
                        : AppTheme.neutralGray300,
                    width: _confirmChecked ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _confirmChecked,
                      onChanged: (value) {
                        setState(() => _confirmChecked = value ?? false);
                      },
                      activeColor: AppTheme.dangerRed,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'I understand this action is permanent',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.neutralGray900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Step 2: Type username
            const Text(
              'Type your username to confirm:',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
            ),

            const SizedBox(height: 8),

            AppTextField(
              label: 'Username',
              controller: _usernameController,
              hint: 'Enter your username',
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 32),

            // Delete Button
            PrimaryButton(
              text: 'Delete My Account',
              onPressed: _canDelete ? _deleteAccount : null,
              isLoading: _isDeleting,
              variant: ButtonVariant.danger,
            ),

            const SizedBox(height: 16),

            // Cancel Button
            PrimaryButton(
              text: 'Cancel',
              onPressed: _isDeleting ? null : () => Navigator.pop(context),
              variant: ButtonVariant.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.dangerRed.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.dangerRed.withOpacity(0.2),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          color: AppTheme.dangerRed,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
