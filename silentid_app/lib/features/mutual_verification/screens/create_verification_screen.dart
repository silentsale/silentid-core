import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../models/mutual_verification.dart';
import '../../../services/api_service.dart';
import '../../../services/mutual_verification_service.dart';

class CreateVerificationScreen extends StatefulWidget {
  const CreateVerificationScreen({super.key});

  @override
  State<CreateVerificationScreen> createState() =>
      _CreateVerificationScreenState();
}

class _CreateVerificationScreenState extends State<CreateVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _itemController = TextEditingController();
  final _amountController = TextEditingController();

  final _mutualVerificationService =
      MutualVerificationService(ApiService());

  String _selectedRole = 'Buyer';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _itemController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryPurple,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitVerification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = CreateVerificationRequest(
        otherUserIdentifier: _usernameController.text.trim(),
        item: _itemController.text.trim(),
        amount: double.parse(_amountController.text),
        yourRole: _selectedRole,
        date: _selectedDate,
      );

      await _mutualVerificationService.createVerification(request);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification request sent successfully!'),
          backgroundColor: AppTheme.successGreen,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppTheme.dangerRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
          'Create Verification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Verify a transaction',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ask the other person to confirm this transaction. Both parties must agree for it to be verified.',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.neutralGray700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Other user username/email
            AppTextField(
              controller: _usernameController,
              label: 'Their SilentID username or email',
              hint: '@username or email@example.com',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                if (value.length < 3) {
                  return 'Please enter a valid username or email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Item description
            AppTextField(
              controller: _itemController,
              label: 'Item or service',
              hint: 'e.g., Vintage Nike trainers',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Amount
            AppTextField(
              controller: _amountController,
              label: 'Amount (£)',
              hint: '0.00',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Your role
            const Text(
              'Your role',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Buyer'),
                    value: 'Buyer',
                    groupValue: _selectedRole,
                    activeColor: AppTheme.primaryPurple,
                    onChanged: (value) {
                      setState(() => _selectedRole = value!);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Seller'),
                    value: 'Seller',
                    groupValue: _selectedRole,
                    activeColor: AppTheme.primaryPurple,
                    onChanged: (value) {
                      setState(() => _selectedRole = value!);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Transaction date
            const Text(
              'Transaction date',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray700,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.neutralGray300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.calendar_today,
                        color: AppTheme.primaryPurple),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Info box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.softLilac,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryPurple,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'The other person will receive a notification to confirm this transaction. Once confirmed, it will strengthen both your TrustScores.',
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
            const SizedBox(height: 32),

            // Submit button
            PrimaryButton(
              onPressed: _isLoading ? null : _submitVerification,
              text: _isLoading ? 'Sending...' : 'Send Verification Request',
            ),
          ],
        ),
      ),
    );
  }
}
