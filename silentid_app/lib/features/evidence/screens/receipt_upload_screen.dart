import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../services/api_service.dart';

class ReceiptUploadScreen extends StatefulWidget {
  const ReceiptUploadScreen({super.key});

  @override
  State<ReceiptUploadScreen> createState() => _ReceiptUploadScreenState();
}

class _ReceiptUploadScreenState extends State<ReceiptUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final _api = ApiService();

  String _platform = 'Vinted';
  String _role = 'Buyer';
  final _itemController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  final List<String> _platforms = [
    'Vinted',
    'eBay',
    'Depop',
    'Etsy',
    'Facebook Marketplace',
    'Other',
  ];

  @override
  void dispose() {
    _itemController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitReceipt() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _api.post(
        '/v1/evidence/receipts/manual',
        data: {
          'platform': _platform,
          'item': _itemController.text.trim(),
          'amount': double.tryParse(_amountController.text.trim()) ?? 0.0,
          'currency': 'GBP',
          'role': _role,
          'date': _selectedDate.toIso8601String(),
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receipt added successfully'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add receipt: ${e.toString()}'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Receipt',
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Platform dropdown
                Text(
                  'Platform',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepBlack,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _platform,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  items: _platforms
                      .map((platform) => DropdownMenuItem(
                            value: platform,
                            child: Text(platform),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _platform = value!);
                  },
                ),

                const SizedBox(height: 24),

                // Item name
                AppTextField(
                  controller: _itemController,
                  label: 'Item Name',
                  hint: 'e.g., Vintage Nike Trainers',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter item name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Amount
                AppTextField(
                  controller: _amountController,
                  label: 'Amount (£)',
                  hint: '0.00',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter valid amount';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Role
                Text(
                  'Your Role',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildRoleChip('Buyer', _role == 'Buyer'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildRoleChip('Seller', _role == 'Seller'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Date
                Text(
                  'Transaction Date',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.deepBlack,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _selectDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.neutralGray300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: AppTheme.deepBlack,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today,
                          color: AppTheme.primaryPurple,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Submit button
                PrimaryButton(
                  text: 'Add Receipt',
                  isLoading: _isLoading,
                  onPressed: _isLoading ? () {} : _submitReceipt,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleChip(String role, bool isSelected) {
    return InkWell(
      onTap: () => setState(() => _role = role),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryPurple : AppTheme.pureWhite,
          border: Border.all(
            color: isSelected ? AppTheme.primaryPurple : AppTheme.neutralGray300,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          role,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppTheme.pureWhite : AppTheme.deepBlack,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
