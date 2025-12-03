import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_messages.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/info_point_helper.dart';
import '../../../core/widgets/gamification/gamification.dart';
import '../../../core/data/info_point_data.dart';
import '../../../core/utils/haptics.dart';
import '../../../services/api_service.dart';

class ScreenshotUploadScreen extends StatefulWidget {
  const ScreenshotUploadScreen({super.key});

  @override
  State<ScreenshotUploadScreen> createState() => _ScreenshotUploadScreenState();
}

class _ScreenshotUploadScreenState extends State<ScreenshotUploadScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  final _api = ApiService();
  final _picker = ImagePicker();

  String _platform = 'Vinted';
  XFile? _selectedImage;
  bool _isLoading = false;
  String _uploadStep = '';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  final List<String> _platforms = [
    'Vinted',
    'eBay',
    'Depop',
    'Etsy',
    'Facebook Marketplace',
    'Other',
  ];

  Future<void> _pickFromGallery() async {
    AppHaptics.light();
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _captureWithCamera() async {
    AppHaptics.light();
    await _pickImage(ImageSource.camera);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        AppMessages.showError(context, ErrorMessages.fromException(e, fallbackAction: 'select image'));
      }
    }
  }

  Future<void> _uploadScreenshot() async {
    if (_selectedImage == null) {
      AppMessages.showError(context, 'Please select a screenshot first');
      return;
    }

    setState(() {
      _isLoading = true;
      _uploadStep = 'Preparing upload...';
    });

    try {
      // Step 1: Get upload URL from backend
      setState(() => _uploadStep = 'Step 1 of 3: Preparing...');
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
      setState(() => _uploadStep = 'Step 2 of 3: Uploading...');
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
      setState(() => _uploadStep = 'Step 3 of 3: Saving...');
      await _api.post(
        '/v1/evidence/screenshots',
        data: {
          'platform': _platform,
          'fileUrl': fileUrl,
        },
      );

      if (mounted) {
        AppMessages.showSuccess(context, ErrorMessages.screenshotUploaded);
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AppMessages.showError(context, ErrorMessages.fromException(e, fallbackAction: 'upload screenshot'));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _uploadStep = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
        child: FadeTransition(
          opacity: _fadeAnimation,
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

              // Image picker options (gallery + camera)
              if (_selectedImage == null)
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _pickFromGallery,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.primaryPurple,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.photo_library_outlined,
                                size: 48,
                                color: AppTheme.primaryPurple,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Gallery',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryPurple,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Choose existing',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppTheme.neutralGray700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: _captureWithCamera,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.primaryPurple,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.camera_alt_outlined,
                                size: 48,
                                color: AppTheme.primaryPurple,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Camera',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryPurple,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Take photo now',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppTheme.neutralGray700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: _pickFromGallery,
                          icon: const Icon(Icons.photo_library_outlined),
                          label: const Text('Gallery'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.primaryPurple,
                          ),
                        ),
                        const SizedBox(width: 16),
                        TextButton.icon(
                          onPressed: _captureWithCamera,
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text('Camera'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.primaryPurple,
                          ),
                        ),
                      ],
                    ),
                  ],
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

              // Warning box with Info Point (Section 40.4)
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
                    const SizedBox(width: 8),
                    InfoPointHelper(data: InfoPoints.screenshotIntegrity),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Privacy reassurance
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.softLilac.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      color: AppTheme.primaryPurple,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your screenshot is stored securely. Only you and our verification team can view it.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.neutralGray700,
                        ),
                      ),
                    ),
                    InfoPointHelper(data: InfoPoints.evidenceStorage),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Upload progress indicator
              if (_isLoading && _uploadStep.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        backgroundColor: AppTheme.neutralGray300,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryPurple),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _uploadStep,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.neutralGray700,
                        ),
                      ),
                    ],
                  ),
                ),

              // Level 7: Reward hint
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const RewardIndicator(points: 10, compact: true),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Each verified screenshot adds 10 points to your TrustScore',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.neutralGray700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Upload button
              PrimaryButton(
                text: 'Upload Screenshot',
                isLoading: _isLoading,
                onPressed: _isLoading
                    ? () {}
                    : () {
                        AppHaptics.medium();
                        _uploadScreenshot();
                      },
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
