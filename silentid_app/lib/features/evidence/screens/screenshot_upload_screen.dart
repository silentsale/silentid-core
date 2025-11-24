import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../services/api_service.dart';

class ScreenshotUploadScreen extends StatefulWidget {
  const ScreenshotUploadScreen({super.key});

  @override
  State<ScreenshotUploadScreen> createState() => _ScreenshotUploadScreenState();
}

class _ScreenshotUploadScreenState extends State<ScreenshotUploadScreen> {
  final _api = ApiService();
  final _picker = ImagePicker();

  String _platform = 'Vinted';
  XFile? _selectedImage;
  bool _isLoading = false;

  final List<String> _platforms = [
    'Vinted',
    'eBay',
    'Depop',
    'Etsy',
    'Facebook Marketplace',
    'Other',
  ];

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: AppTheme.dangerRed,
          ),
        );
      }
    }
  }

  Future<void> _uploadScreenshot() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a screenshot first'),
          backgroundColor: AppTheme.dangerRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Step 1: Get upload URL from backend
      final uploadUrlResponse = await _api.post(
        '/v1/evidence/screenshots/upload-url',
        data: {
          'platform': _platform,
          'filename': _selectedImage!.name,
        },
      );

      final uploadUrl = uploadUrlResponse.data['uploadUrl'];
      final fileUrl = uploadUrlResponse.data['fileUrl'];

      // Step 2: Upload file to Azure Blob Storage
      final file = File(_selectedImage!.path);
      final fileBytes = await file.readAsBytes();

      // Create Dio instance for blob upload (without auth interceptor)
      final blobDio = Dio();
      await blobDio.put(
        uploadUrl,
        data: fileBytes,
        options: Options(
          headers: {
            'Content-Type': 'image/jpeg', // or detect from file
            'x-ms-blob-type': 'BlockBlob',
          },
        ),
      );

      // Step 3: Submit metadata to backend
      await _api.post(
        '/v1/evidence/screenshots',
        data: {
          'platform': _platform,
          'fileUrl': fileUrl,
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Screenshot uploaded successfully'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload screenshot: ${e.toString()}'),
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
          'Upload Screenshot',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info text
              Text(
                'Upload a screenshot of your marketplace profile, ratings, or transaction history.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.neutralGray700,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

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
                value: _platform,
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

              const SizedBox(height: 32),

              // Image preview or picker button
              if (_selectedImage == null)
                InkWell(
                  onTap: _pickImage,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.primaryPurple,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_photo_alternate,
                          size: 64,
                          color: AppTheme.primaryPurple,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tap to choose screenshot',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(_selectedImage!.path),
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.change_circle),
                      label: const Text('Change Screenshot'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryPurple,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 32),

              // Warning box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.warningAmber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.warningAmber),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber,
                      color: AppTheme.warningAmber,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Only upload clean, unmodified screenshots. Edited images will be flagged.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.neutralGray900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Upload button
              PrimaryButton(
                text: 'Upload Screenshot',
                isLoading: _isLoading,
                onPressed: _isLoading ? () {} : _uploadScreenshot,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
