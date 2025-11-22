import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/api_constants.dart';

class IdentityWebViewScreen extends StatefulWidget {
  const IdentityWebViewScreen({super.key});

  @override
  State<IdentityWebViewScreen> createState() => _IdentityWebViewScreenState();
}

class _IdentityWebViewScreenState extends State<IdentityWebViewScreen> {
  final _api = ApiService();
  late WebViewController _controller;
  bool _isLoading = true;
  String? _verificationUrl;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVerification();
  }

  Future<void> _initializeVerification() async {
    try {
      // Get Stripe verification session URL from backend
      final response = await _api.post(ApiConstants.identitySession);
      final url = response.data['url'];

      if (url != null) {
        setState(() {
          _verificationUrl = url;
          _isLoading = false;
        });

        // Initialize WebView controller
        _controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                // Check if verification completed
                if (url.contains('success') || url.contains('complete')) {
                  // Navigate to status screen
                  context.go('/identity/status');
                } else if (url.contains('cancel')) {
                  // User cancelled verification
                  context.pop();
                }
              },
              onPageFinished: (String url) {
                setState(() => _isLoading = false);
              },
              onWebResourceError: (WebResourceError error) {
                setState(() {
                  _errorMessage = 'Failed to load verification page';
                  _isLoading = false;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(url));
      } else {
        setState(() {
          _errorMessage = 'Failed to get verification URL';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to start verification: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify Identity',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppTheme.deepBlack,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Show confirmation dialog before closing
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Cancel Verification?',
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'Are you sure you want to cancel identity verification?',
                  style: GoogleFonts.inter(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('No, Continue'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.dangerRed,
                    ),
                    child: const Text('Yes, Cancel'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading verification...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppTheme.dangerRed,
              ),
              const SizedBox(height: 16),
              Text(
                'Verification Error',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.deepBlack,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.neutralGray700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    if (_verificationUrl != null) {
      return WebViewWidget(controller: _controller);
    }

    return const Center(child: Text('Something went wrong'));
  }
}
