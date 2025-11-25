import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../models/safety_report.dart';
import '../../../services/api_service.dart';
import '../../../services/safety_service.dart';

class ReportUserScreen extends StatefulWidget {
  final String? username;

  const ReportUserScreen({super.key, this.username});

  @override
  State<ReportUserScreen> createState() => _ReportUserScreenState();
}

class _ReportUserScreenState extends State<ReportUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _safetyService = SafetyService(ApiService());
  final _imagePicker = ImagePicker();

  String _selectedCategory = 'FraudConcern';
  final List<File> _selectedFiles = [];
  bool _isLoading = false;

  final List<Map<String, String>> _categories = [
    {'value': 'ItemNotReceived', 'label': 'Item not received'},
    {'value': 'AggressiveBehaviour', 'label': 'Aggressive behaviour'},
    {'value': 'FraudConcern', 'label': 'Fraud concern'},
    {'value': 'PaymentIssue', 'label': 'Payment issue'},
    {'value': 'Other', 'label': 'Other concern'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.username != null) {
      _usernameController.text = widget.username!;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _selectedFiles.add(File(image.path));
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = CreateReportRequest(
        reportedUserIdentifier: _usernameController.text.trim(),
        category: _selectedCategory,
        description: _descriptionController.text.trim(),
      );

      final reportId = await _safetyService.createReport(request);

      // Upload evidence files
      for (final file in _selectedFiles) {
        await _safetyService.uploadEvidence(reportId, file);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Thank you. Your report helps protect the community. A SilentID reviewer will examine it.',
          ),
          backgroundColor: AppTheme.successGreen,
          duration: Duration(seconds: 4),
        ),
      );

      Navigator.pushReplacementNamed(context, '/safety/my-reports');
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
          'Report a Safety Concern',
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
            // Warning banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.warningAmber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.warningAmber),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppTheme.warningAmber,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Important',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Only submit genuine safety concerns. False reports may affect your TrustScore.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.neutralGray700,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Username
            AppTextField(
              controller: _usernameController,
              label: 'User to report',
              hint: '@username or email',
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

            // Category
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray700,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category['value'],
                  child: Text(category['label']!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
            ),
            const SizedBox(height: 20),

            // Description
            AppTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Describe what happened...',
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please describe the issue';
                }
                if (value.length < 20) {
                  return 'Please provide more details (at least 20 characters)';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Evidence section
            const Text(
              'Evidence (optional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Screenshots, receipts, or chat logs help us review your report.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
            ),
            const SizedBox(height: 12),

            // Selected files
            if (_selectedFiles.isNotEmpty)
              ...List.generate(_selectedFiles.length, (index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.neutralGray300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.image, color: AppTheme.primaryPurple),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedFiles[index].path.split('/').last,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: AppTheme.dangerRed),
                        onPressed: () => _removeFile(index),
                      ),
                    ],
                  ),
                );
              }),

            // Upload button
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Evidence'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryPurple,
                side: const BorderSide(color: AppTheme.primaryPurple),
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                      'Your report will be reviewed by a SilentID moderator. We take all safety concerns seriously and will investigate thoroughly.',
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
              onPressed: _isLoading ? null : _submitReport,
              text: _isLoading ? 'Submitting...' : 'Submit Report',
            ),
          ],
        ),
      ),
    );
  }
}
