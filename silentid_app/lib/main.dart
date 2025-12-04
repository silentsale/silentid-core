import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/widgets/share_listener_wrapper.dart';
import 'services/api_service.dart';
import 'services/shared_link_controller.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API service
  ApiService().initialize();

  // In debug mode, clear auth data on startup so app starts at login screen
  // This ensures fresh state for development/testing
  if (kDebugMode) {
    await StorageService().clearAuthData();
  }

  runApp(
    const ProviderScope(
      child: SilentIDApp(),
    ),
  );
}

class SilentIDApp extends ConsumerStatefulWidget {
  const SilentIDApp({super.key});

  @override
  ConsumerState<SilentIDApp> createState() => _SilentIDAppState();
}

class _SilentIDAppState extends ConsumerState<SilentIDApp> {
  @override
  void initState() {
    super.initState();
    // Initialize the shared link controller to start listening
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sharedLinkControllerProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SilentID',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        // Wrap with ShareListenerWrapper to handle incoming shared links
        return ShareListenerWrapper(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
