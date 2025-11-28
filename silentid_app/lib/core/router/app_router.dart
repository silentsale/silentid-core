import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/email_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/home/screens/enhanced_home_screen.dart';
import '../../features/identity/screens/identity_intro_screen.dart';
import '../../features/identity/screens/identity_webview_screen.dart';
import '../../features/identity/screens/identity_status_screen.dart';
import '../../features/evidence/screens/evidence_overview_screen.dart';
import '../../features/evidence/screens/receipt_upload_screen.dart';
import '../../features/evidence/screens/receipt_list_screen.dart';
import '../../features/evidence/screens/email_receipts_setup_screen.dart';
import '../../features/evidence/screens/screenshot_upload_screen.dart';
import '../../features/evidence/screens/profile_link_screen.dart';
import '../../features/trust/screens/trustscore_overview_screen.dart';
import '../../features/trust/screens/trustscore_breakdown_screen.dart';
import '../../features/trust/screens/trustscore_history_screen.dart';
import '../../features/profile/screens/my_public_profile_screen.dart';
import '../../features/settings/screens/account_details_screen.dart';
import '../../features/settings/screens/privacy_settings_screen.dart';
import '../../features/settings/screens/connected_devices_screen.dart';
import '../../features/settings/screens/data_export_screen.dart';
import '../../features/settings/screens/delete_account_screen.dart';
import '../../features/mutual_verification/screens/mutual_verification_home_screen.dart';
import '../../features/mutual_verification/screens/create_verification_screen.dart';
import '../../features/mutual_verification/screens/incoming_requests_screen.dart';
import '../../features/mutual_verification/screens/verification_details_screen.dart';
import '../../features/safety/screens/report_user_screen.dart';
import '../../features/safety/screens/my_reports_screen.dart';
import '../../features/safety/screens/report_details_screen.dart';
import '../../features/subscriptions/screens/subscription_overview_screen.dart';
import '../../features/subscriptions/screens/upgrade_premium_screen.dart';
import '../../features/subscriptions/screens/upgrade_pro_screen.dart';
import '../../features/profile/screens/public_profile_viewer_screen.dart';
import '../../features/profiles/screens/connect_profiles_screen.dart';
import '../../features/profiles/screens/add_profile_screen.dart';
import '../../features/profiles/screens/connected_profiles_screen.dart';
import '../../features/profiles/screens/upgrade_to_verified_screen.dart';
import '../../features/onboarding/screens/onboarding_tour_screen.dart';
import '../../features/referral/screens/referral_screen.dart';
import '../../features/sharing/screens/sharing_education_screen.dart';
import '../../services/auth_service.dart';
import '../../services/profile_linking_service.dart';
import '../widgets/main_shell.dart';

class AppRouter {
  static final _authService = AuthService();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final isAuthenticated = await _authService.isAuthenticated();
      final isAuthRoute = state.matchedLocation == '/' ||
          state.matchedLocation == '/email' ||
          state.matchedLocation == '/otp';
      final isOnboardingRoute = state.matchedLocation == '/onboarding/tour';

      // If authenticated and trying to access auth routes, check for onboarding
      if (isAuthenticated && isAuthRoute) {
        // Check if onboarding has been completed (Section 50.2.1)
        final hasCompletedOnboarding =
            await OnboardingTourScreen.hasCompletedOnboarding();
        if (!hasCompletedOnboarding) {
          return '/onboarding/tour';
        }
        return '/home';
      }

      // If not authenticated and trying to access protected routes, redirect to welcome
      if (!isAuthenticated && !isAuthRoute && !isOnboardingRoute) {
        return '/';
      }

      // No redirect needed
      return null;
    },
    routes: [
      // Auth routes - outside shell (no bottom navigation)
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/email',
        name: 'email',
        builder: (context, state) => const EmailScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) {
          final email = state.extra as String?;
          if (email == null) {
            // If no email provided, redirect to email screen
            return const EmailScreen();
          }
          return OtpScreen(email: email);
        },
      ),
      // Authenticated routes - wrapped in ShellRoute with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          // Conditionally show bottom navigation based on route
          if (!ShellRouteHelper.shouldShowBottomNav(state.matchedLocation)) {
            return child;
          }
          final currentIndex = ShellRouteHelper.getIndexFromRoute(state.matchedLocation);
          return MainShellScreen(
            currentIndex: currentIndex,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const EnhancedHomeScreen(),
          ),
          GoRoute(
            path: '/identity/intro',
            name: 'identity-intro',
            builder: (context, state) => const IdentityIntroScreen(),
          ),
          GoRoute(
            path: '/identity/verify',
            name: 'identity-verify',
            builder: (context, state) => const IdentityWebViewScreen(),
          ),
          GoRoute(
            path: '/identity/status',
            name: 'identity-status',
            builder: (context, state) => const IdentityStatusScreen(),
          ),
          GoRoute(
            path: '/evidence',
            name: 'evidence',
            builder: (context, state) => const EvidenceOverviewScreen(),
          ),
          GoRoute(
            path: '/evidence/receipts',
            name: 'receipt-list',
            builder: (context, state) => const ReceiptListScreen(),
          ),
          GoRoute(
            path: '/evidence/receipts/upload',
            name: 'receipt-upload',
            builder: (context, state) => const ReceiptUploadScreen(),
          ),
          GoRoute(
            path: '/evidence/receipts/email-setup',
            name: 'email-receipts-setup',
            builder: (context, state) => const EmailReceiptsSetupScreen(),
          ),
          GoRoute(
            path: '/evidence/screenshots',
            name: 'screenshot-upload',
            builder: (context, state) => const ScreenshotUploadScreen(),
          ),
          GoRoute(
            path: '/evidence/profile-links',
            name: 'profile-link',
            builder: (context, state) => const ProfileLinkScreen(),
          ),
          GoRoute(
            path: '/trust/overview',
            name: 'trust-overview',
            builder: (context, state) => const TrustScoreOverviewScreen(),
          ),
          GoRoute(
            path: '/trust/breakdown',
            name: 'trust-breakdown',
            builder: (context, state) => const TrustScoreBreakdownScreen(),
          ),
          GoRoute(
            path: '/trust/history',
            name: 'trust-history',
            builder: (context, state) => const TrustScoreHistoryScreen(),
          ),
          GoRoute(
            path: '/profile/public',
            name: 'public-profile',
            builder: (context, state) => const MyPublicProfileScreen(),
          ),
          GoRoute(
            path: '/settings/account',
            name: 'account-details',
            builder: (context, state) => const AccountDetailsScreen(),
          ),
          GoRoute(
            path: '/settings/privacy',
            name: 'privacy-settings',
            builder: (context, state) => const PrivacySettingsScreen(),
          ),
          GoRoute(
            path: '/settings/devices',
            name: 'connected-devices',
            builder: (context, state) => const ConnectedDevicesScreen(),
          ),
          GoRoute(
            path: '/settings/export',
            name: 'data-export',
            builder: (context, state) => const DataExportScreen(),
          ),
          GoRoute(
            path: '/settings/delete',
            name: 'delete-account',
            builder: (context, state) => const DeleteAccountScreen(),
          ),
          GoRoute(
            path: '/mutual-verification',
            name: 'mutual-verification',
            builder: (context, state) => const MutualVerificationHomeScreen(),
          ),
          GoRoute(
            path: '/mutual-verification/create',
            name: 'create-verification',
            builder: (context, state) => const CreateVerificationScreen(),
          ),
          GoRoute(
            path: '/mutual-verification/incoming',
            name: 'incoming-requests',
            builder: (context, state) => const IncomingRequestsScreen(),
          ),
          GoRoute(
            path: '/mutual-verification/details/:id',
            name: 'verification-details',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              if (id == null) {
                return const Scaffold(
                  body: Center(child: Text('Verification ID required')),
                );
              }
              return VerificationDetailsScreen(verificationId: id);
            },
          ),
          GoRoute(
            path: '/safety/report',
            name: 'report-user',
            builder: (context, state) {
              final username = state.extra as String?;
              return ReportUserScreen(username: username);
            },
          ),
          GoRoute(
            path: '/safety/my-reports',
            name: 'my-reports',
            builder: (context, state) => const MyReportsScreen(),
          ),
          GoRoute(
            path: '/safety/report-details/:id',
            name: 'report-details',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              if (id == null) {
                return const Scaffold(
                  body: Center(child: Text('Report ID required')),
                );
              }
              return ReportDetailsScreen(reportId: id);
            },
          ),
          GoRoute(
            path: '/subscriptions/overview',
            name: 'subscription-overview',
            builder: (context, state) => const SubscriptionOverviewScreen(),
          ),
          GoRoute(
            path: '/subscriptions/premium',
            name: 'upgrade-premium',
            builder: (context, state) => const UpgradePremiumScreen(),
          ),
          GoRoute(
            path: '/subscriptions/pro',
            name: 'upgrade-pro',
            builder: (context, state) => const UpgradeProScreen(),
          ),
          GoRoute(
            path: '/profile/view/:username',
            name: 'view-public-profile',
            builder: (context, state) {
              final username = state.pathParameters['username'];
              if (username == null) {
                return const Scaffold(
                  body: Center(child: Text('Username required')),
                );
              }
              return PublicProfileViewerScreen(username: username);
            },
          ),
          // Section 52 - Connected Profiles routes
          GoRoute(
            path: '/profiles/connect',
            name: 'connect-profiles',
            builder: (context, state) => const ConnectProfilesScreen(),
          ),
          GoRoute(
            path: '/profiles/add',
            name: 'add-profile',
            builder: (context, state) => const AddProfileScreen(),
          ),
          GoRoute(
            path: '/profiles/connected',
            name: 'connected-profiles',
            builder: (context, state) => const ConnectedProfilesScreen(),
          ),
          GoRoute(
            path: '/profiles/upgrade',
            name: 'upgrade-to-verified',
            builder: (context, state) {
              final profile = state.extra as ConnectedProfile?;
              if (profile == null) {
                return const Scaffold(
                  body: Center(child: Text('Profile required')),
                );
              }
              return UpgradeToVerifiedScreen(profile: profile);
            },
          ),
          // Section 50 - Onboarding routes
          GoRoute(
            path: '/onboarding/tour',
            name: 'onboarding-tour',
            builder: (context, state) => const OnboardingTourScreen(),
          ),
          // Section 50 - Referral routes
          GoRoute(
            path: '/referral',
            name: 'referral',
            builder: (context, state) => const ReferralScreen(),
          ),
          // Section 51 - Sharing Education routes
          GoRoute(
            path: '/sharing/education',
            name: 'sharing-education',
            builder: (context, state) => const SharingEducationScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
}
