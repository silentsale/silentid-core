import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';

class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _email;
  bool _isEmailVerified = false;
  String? _phone;
  bool _isPhoneVerified = false;

  @override
  void initState() {
    super.initState();
    _loadAccountDetails();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _loadAccountDetails() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Replace with actual API call
      // final response = await ApiService().get('/users/me');

      // Mock data for now
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _email = 'sarah@example.com';
        _isEmailVerified = true;
        _phone = null;
        _isPhoneVerified = false;
        _usernameController.text = 'sarahtrusted';
        _displayNameController.text = 'Sarah M.';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load details: $e')),
        );
      }
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      // TODO: Replace with actual API call
      // await ApiService().patch('/users/me', {
      //   'username': _usernameController.text,
      //   'displayName': _displayNameController.text,
      // });

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account details updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save changes: $e')),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _addPhoneNumber() async {
    // TODO: Implement phone number addition flow
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Phone verification coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Account Details'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email (Read-only)
                    _buildReadOnlyField(
                      label: 'Email',
                      value: _email!,
                      icon: Icons.email_outlined,
                      isVerified: _isEmailVerified,
                    ),

                    const SizedBox(height: 20),

                    // Username (Editable)
                    AppTextField(
                      label: 'Username',
                      controller: _usernameController,
                      prefixIcon: const Icon(Icons.alternate_email),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        if (value.length < 3) {
                          return 'Username must be at least 3 characters';
                        }
                        if (!RegExp(r'^[a-z0-9_]+$').hasMatch(value)) {
                          return 'Username can only contain lowercase letters, numbers, and underscores';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Display Name (Editable)
                    AppTextField(
                      label: 'Display Name',
                      controller: _displayNameController,
                      prefixIcon: const Icon(Icons.person_outline),
                      hint: 'First name + last initial (e.g., Sarah M.)',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Display name is required';
                        }
                        if (value.length < 2) {
                          return 'Display name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Phone (Optional)
                    _phone == null
                        ? _buildAddPhoneButton()
                        : _buildReadOnlyField(
                            label: 'Phone',
                            value: _phone!,
                            icon: Icons.phone_outlined,
                            isVerified: _isPhoneVerified,
                          ),

                    const SizedBox(height: 32),

                    // Save Button
                    PrimaryButton(
                      text: 'Save Changes',
                      onPressed: _isSaving ? null : _saveChanges,
                      isLoading: _isSaving,
                    ),

                    const SizedBox(height: 16),

                    // Info Text
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.softLilac.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: AppTheme.primaryPurple,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Username changes are limited to once every 30 days. Your display name follows the format: First name + Last initial for privacy.',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.neutralGray700,
                              ),
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

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
    required bool isVerified,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.neutralGray700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.neutralGray300.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.neutralGray300),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppTheme.neutralGray700,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.neutralGray900,
                  ),
                ),
              ),
              if (isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: AppTheme.successGreen,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.successGreen,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhoneButton() {
    return InkWell(
      onTap: _addPhoneNumber,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryPurple,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.add_circle_outline,
              color: AppTheme.primaryPurple,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Phone Number',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Optional - Improve your TrustScore',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.neutralGray700,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTheme.primaryPurple,
            ),
          ],
        ),
      ),
    );
  }
}
