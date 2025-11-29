# SILENTID UI MASTER LOG

**Version:** 1.0.0
**Last Updated:** 2025-11-29
**Design System:** Section 53 Compliant

---

## Table of Contents

1. [Design System Overview](#design-system-overview)
2. [Color Palette](#color-palette)
3. [Typography](#typography)
4. [Spacing & Layout](#spacing--layout)
5. [Core Widgets](#core-widgets)
6. [Screen Inventory](#screen-inventory)
7. [Navigation Structure](#navigation-structure)
8. [Info Points System](#info-points-system)
9. [Implementation Status](#implementation-status)
10. [Change Log](#change-log)

---

## Design System Overview

SilentID follows a locked, premium Apple-style UI based on:
- **Unified spacing:** 16px grid system
- **Card shapes:** 12px border radius
- **Typography:** Inter font family (Google Fonts)
- **Accent color:** Royal Purple #5A3EB8 (accents only)
- **Material 3:** Enabled for modern design tokens

### Design Principles

| Principle | Implementation |
|-----------|----------------|
| Purple for accents only | CTAs, active states, highlights |
| Clean white backgrounds | Scaffold background: #FFFFFF |
| Consistent card styling | 12px radius, subtle shadows |
| Inter typography | All text elements |
| 16px base spacing | Padding, margins, gaps |
| Haptic feedback | All interactive elements |

---

## Color Palette

### Brand Colors

| Name | Hex | Usage |
|------|-----|-------|
| Primary Purple | `#5A3EB8` | CTAs, active states, accents |
| Dark Mode Purple | `#462F8F` | Secondary accent, dark mode |
| Soft Lilac | `#E8E2FF` | Backgrounds, highlights |
| Deep Black | `#0A0A0A` | Primary text |
| Pure White | `#FFFFFF` | Backgrounds, cards |

### Neutral Grays

| Name | Hex | Usage |
|------|-----|-------|
| Gray 900 | `#111111` | Dark mode background |
| Gray 700 | `#4C4C4C` | Secondary text, hints |
| Gray 300 | `#DADADA` | Borders, dividers |

### Semantic Colors

| Name | Hex | Usage |
|------|-----|-------|
| Success Green | `#1FBF71` | Verified states, success |
| Warning Amber | `#FFC043` | Warnings, pending states |
| Danger Red | `#D04C4C` | Errors, alerts, removal |

### Platform Brand Colors

| Platform | Color | Icon |
|----------|-------|------|
| Vinted | `#09B1BA` | Teal |
| eBay | `#E53238` | Red |
| Depop | `#FF2300` | Orange-Red |
| Etsy | `#F56400` | Orange |
| Poshmark | `#7F0353` | Burgundy |
| Facebook | `#1877F2` | Blue |
| Instagram | `#E4405F` | Pink |
| TikTok | `#000000` | Black |
| Twitter/X | `#1DA1F2` | Blue |
| YouTube | `#FF0000` | Red |
| LinkedIn | `#0A66C2` | Blue |
| GitHub | `#181717` | Black |
| Discord | `#5865F2` | Purple |
| Twitch | `#9146FF` | Purple |
| Steam | `#1B2838` | Dark Blue |
| Reddit | `#FF4500` | Orange |

---

## Typography

### Font Family

```dart
GoogleFonts.inter()
```

### Text Styles

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| Headline Large | 32px | Bold (700) | Screen titles |
| Headline Medium | 24px | SemiBold (600) | Section headers |
| Title Large | 22px | SemiBold (600) | Card titles |
| Title Medium | 18px | SemiBold (600) | AppBar titles |
| Body Large | 16px | Regular (400) | Primary content |
| Body Medium | 14px | Regular (400) | Secondary content |
| Body Small | 12px | Regular (400) | Captions, hints |
| Label Large | 14px | Medium (500) | Buttons |
| Label Medium | 12px | Medium (500) | Chips, badges |

### AppBar Title Style

```dart
GoogleFonts.inter(
  color: deepBlack,
  fontSize: 18,
  fontWeight: FontWeight.w600,
)
```

---

## Spacing & Layout

### Base Grid

- **Base unit:** 8px
- **Standard spacing:** 16px (2 units)
- **Large spacing:** 24px (3 units)
- **Extra large:** 32px (4 units)

### Screen Padding

```dart
EdgeInsets.symmetric(horizontal: 24, vertical: 16)
```

### Card Styling

```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: Offset(0, 2),
      ),
    ],
  ),
)
```

### Button Heights

| Type | Height |
|------|--------|
| Primary Button | 52px |
| Secondary Button | 48px |
| Small Button | 40px |

### Border Radius

| Element | Radius |
|---------|--------|
| Cards | 12px |
| Buttons | 12px |
| Input Fields | 12px |
| Chips | 20px |
| Avatars | 50% (circular) |

---

## Core Widgets

### Location: `lib/core/widgets/`

| Widget | File | Purpose | Section |
|--------|------|---------|---------|
| AppTextField | `app_text_field.dart` | Styled text input | 53 |
| InfoModal | `info_modal.dart` | Help/info bottom sheets | 53.7 |
| InfoPoint | `info_point.dart` | Contextual help triggers | 53.7 |
| InfoPointHelper | `info_point_helper.dart` | InfoPoint data lookup | 53.7 |
| PrimaryButton | `primary_button.dart` | Main CTA buttons | 53 |
| SettingsListItem | `settings_list_item.dart` | Settings menu items | 53 |
| SkeletonLoader | `skeleton_loader.dart` | Loading placeholders | 53 |
| LoadingOverlay | `loading_overlay.dart` | Full-screen loading | 53 |
| ErrorState | `error_state.dart` | Error display widget | 53 |
| EmptyState | `empty_state.dart` | Empty list states | 53 |
| OfflineIndicator | `offline_indicator.dart` | Connectivity status | 53 |
| TrustScoreStarRating | `trust_score_star_rating.dart` | Star rating display | 47 |
| MainShell | `main_shell.dart` | Bottom nav container | UI Master |
| OnboardingChecklist | `onboarding_checklist.dart` | 3-step progress | 50.2.2 |
| DemoProfilePreview | `demo_profile_preview.dart` | Sample profile card | 50.2.3 |
| TrustScoreProgressRings | `trustscore_progress_rings.dart` | Category rings | 50.3.2 |
| SocialProofWidget | `social_proof_widget.dart` | User counts/stories | 50.3.3 |
| AchievementBadges | `achievement_badges.dart` | 11 badge definitions | 50.5.2 |
| VerifiedBadgeGenerator | `verified_badge_generator.dart` | QR badge images | 51.3 |
| PublicConnectedProfiles | `public_connected_profiles.dart` | Profile display (3 variants) | 52.6 |
| ConnectedProfilesTrustContribution | `connected_profiles_trust_contribution.dart` | Trust points widget | 52.7 |

### Widget Variants

#### PublicConnectedProfiles (3 variants)
1. `PublicConnectedProfilesWidget` - Full list display
2. `CompactConnectedProfilesRow` - Horizontal chips
3. `ConnectedProfilesSummary` - Count badge

#### ConnectedProfilesTrustContribution (3 variants)
1. `ConnectedProfilesTrustContribution` - Full breakdown
2. `ConnectedProfilesTrustBadge` - Compact "+N pts" badge
3. `ProfileTrustSummaryLine` - Mini "2 · 3 | +55 pts" line

#### AchievementBadges (11 badges)
1. `verifiedIdentity` - Identity Verified
2. `connectedProfile` - Profile Connected
3. `firstEvidence` - Evidence Pioneer
4. `multiPlatform` - Multi-Platform Trust
5. `trustMilestone500` - TrustScore 500+
6. `trustMilestone750` - TrustScore 750+
7. `trustMilestone900` - TrustScore 900+
8. `trustedCommunityMember` - Community Member
9. `topVerifier` - Top Verifier
10. `networkLeader` - Network Leader
11. `referralChampion` - Referral Champion

---

## Screen Inventory

### Authentication Screens (3)

| Screen | Route | File | Status |
|--------|-------|------|--------|
| Welcome | `/` | `welcome_screen.dart` | ✅ Complete |
| Email Entry | `/email` | `email_screen.dart` | ✅ Complete |
| OTP Verification | `/otp` | `otp_screen.dart` | ✅ Complete |

### Home & Onboarding (3)

| Screen | Route | File | Status |
|--------|-------|------|--------|
| Enhanced Home | `/home` | `enhanced_home_screen.dart` | ✅ Complete |
| Home (Legacy) | - | `home_screen.dart` | ⚠️ Deprecated |
| Onboarding Tour | `/onboarding/tour` | `onboarding_tour_screen.dart` | ✅ Complete |

### Identity Verification (3)

| Screen | Route | File | Status |
|--------|-------|------|--------|
| Identity Intro | `/identity/intro` | `identity_intro_screen.dart` | ✅ Complete |
| Identity WebView | `/identity/verify` | `identity_webview_screen.dart` | ✅ Complete |
| Identity Status | `/identity/status` | `identity_status_screen.dart` | ✅ Complete |

### Evidence Vault (7)

| Screen | Route | File | Status |
|--------|-------|------|--------|
| Evidence Overview | `/evidence` | `evidence_overview_screen.dart` | ✅ Complete |
| Receipt List | `/evidence/receipts` | `receipt_list_screen.dart` | ✅ Complete |
| Receipt Upload | `/evidence/receipts/upload` | `receipt_upload_screen.dart` | ✅ Complete |
| Email Receipts Setup | `/evidence/receipts/email-setup` | `email_receipts_setup_screen.dart` | ✅ Complete |
| Screenshot Upload | `/evidence/screenshots` | `screenshot_upload_screen.dart` | ✅ Complete |
| Profile Links | `/evidence/profile-links` | `profile_link_screen.dart` | ✅ Complete |
| Level 3 Verification | `/evidence/level3-verify` | `level3_verification_screen.dart` | ✅ Complete |

### TrustScore (3)

| Screen | Route | File | Status |
|--------|-------|------|--------|
| TrustScore Overview | `/trust/overview` | `trustscore_overview_screen.dart` | ✅ Complete |
| TrustScore Breakdown | `/trust/breakdown` | `trustscore_breakdown_screen.dart` | ✅ Complete |
| TrustScore History | `/trust/history` | `trustscore_history_screen.dart` | ✅ Complete |

### Profile & Public Passport (3)

| Screen | Route | File | Status |
|--------|-------|------|--------|
| Profile (Settings Hub) | `/settings` | `profile_screen.dart` | ✅ Complete |
| My Public Profile | `/profile/public` | `my_public_profile_screen.dart` | ✅ Complete |
| Public Profile Viewer | `/profile/view/:username` | `public_profile_viewer_screen.dart` | ✅ Complete |

### Profile Linking (4)

| Screen | Route | File | Status |
|--------|-------|------|--------|
| Connect Profiles | `/profiles/connect` | `connect_profiles_screen.dart` | ✅ Complete |
| Add Profile | `/profiles/add` | `add_profile_screen.dart` | ✅ Complete |
| Connected Profiles | `/profiles/connected` | `connected_profiles_screen.dart` | ✅ Complete |
| Upgrade to Verified | `/profiles/upgrade` | `upgrade_to_verified_screen.dart` | ✅ Complete |

### Settings (5)

| Screen | Route | File | Status |
|--------|-------|------|--------|
| Account Details | `/settings/account` | `account_details_screen.dart` | ✅ Complete |
| Privacy Settings | `/settings/privacy` | `privacy_settings_screen.dart` | ✅ Complete |
| Connected Devices | `/settings/devices` | `connected_devices_screen.dart` | ✅ Complete |
| Data Export | `/settings/export` | `data_export_screen.dart` | ✅ Complete |
| Delete Account | `/settings/delete` | `delete_account_screen.dart` | ✅ Complete |

### Security Center (4)

| Screen | Route | File | Status |
|--------|-------|------|--------|
| Security Center | `/security` | `security_center_screen.dart` | ✅ Complete |
| Login Activity | `/security/login-activity` | `login_activity_screen.dart` | ✅ Complete |
| Security Alerts | `/security/alerts` | `security_alerts_screen.dart` | ✅ Complete |
| Security Risk | `/security/risk` | `security_risk_screen.dart` | ✅ Complete |

### Safety & Reporting (5)

| Screen | Route | File | Status |
|--------|-------|------|--------|
| Report User | `/safety/report` | `report_user_screen.dart` | ✅ Complete |
| My Reports | `/safety/my-reports` | `my_reports_screen.dart` | ✅ Complete |
| Report Details | `/safety/report-details/:id` | `report_details_screen.dart` | ✅ Complete |
| Report Concern | `/concern/report/:userId/:username` | `report_concern_screen.dart` | ✅ Complete |
| Contact Support | `/support/contact` | `contact_support_screen.dart` | ✅ Complete |

### Subscriptions (3)

| Screen | Route | File | Status |
|--------|-------|------|--------|
| Subscription Overview | `/subscriptions/overview` | `subscription_overview_screen.dart` | ✅ Complete |
| Upgrade Premium | `/subscriptions/premium` | `upgrade_premium_screen.dart` | ✅ Complete |
| Upgrade Pro | `/subscriptions/pro` | `upgrade_pro_screen.dart` | ✅ Complete |

### Help Center (3)

| Screen | Route | File | Status |
|--------|-------|------|--------|
| Help Center | `/help` | `help_center_screen.dart` | ✅ Complete |
| Help Category | `/help/:category` | `help_category_screen.dart` | ✅ Complete |
| Help Article | `/help/:category/:slug` | `help_article_screen.dart` | ✅ Complete |

### Sharing & Referral (2)

| Screen | Route | File | Status |
|--------|-------|------|--------|
| Sharing Education | `/sharing/education` | `sharing_education_screen.dart` | ✅ Complete |
| Referral Program | `/referral` | `referral_screen.dart` | ✅ Complete |

---

## Navigation Structure

### Bottom Navigation (5 Tabs)

| Index | Tab | Route | Icon |
|-------|-----|-------|------|
| 0 | Home | `/home` | `Icons.home_outlined` |
| 1 | Evidence | `/evidence` | `Icons.folder_outlined` |
| 2 | Profile | `/profile/public` | `Icons.person_outlined` |
| 3 | Security | `/security` | `Icons.shield_outlined` |
| 4 | Settings | `/settings` | `Icons.settings_outlined` |

### Shell Route Helper

```dart
class ShellRouteHelper {
  static int getIndexFromRoute(String route);
  static bool shouldShowBottomNav(String route);
}
```

### Routes Without Bottom Nav

- `/` (Welcome)
- `/email` (Email Entry)
- `/otp` (OTP)
- `/onboarding/tour` (Onboarding)

### Authentication Flow

```
/ (Welcome) → /email → /otp → /onboarding/tour → /home
```

### Redirect Logic

1. **Authenticated + Auth Route** → Check onboarding → `/home` or `/onboarding/tour`
2. **Not Authenticated + Protected Route** → `/`
3. **Otherwise** → No redirect

---

## Info Points System

### Location: `lib/core/data/info_point_data.dart`

### Info Point Categories

| Category | Count | Description |
|----------|-------|-------------|
| TrustScore | 8 | Score components, tiers, calculation |
| Identity | 4 | Verification, Stripe, security |
| Evidence | 6 | Receipts, screenshots, uploads |
| Profiles | 6 | Linking, verification methods |
| Security | 5 | Login, devices, risk signals |
| Sharing | 4 | Passport, badges, visibility |
| Referral | 3 | Program, bonuses, tracking |
| General | 5 | Privacy, data, subscriptions |

### Info Point Structure

```dart
class InfoPointData {
  final String id;
  final String title;
  final String shortDescription;
  final String fullDescription;
  final List<String> bulletPoints;
  final String? learnMoreUrl;
}
```

### Key Info Points

| ID | Title | Usage |
|----|-------|-------|
| `trustScore` | "What is TrustScore?" | Score overview |
| `identityComponent` | "Identity Score" | Identity section |
| `evidenceComponent` | "Evidence Score" | Evidence section |
| `behaviourComponent` | "Behaviour Score" | Behaviour section |
| `connectedProfiles` | "Connected Profiles" | Profile linking |
| `linkedProfile` | "What does Linked mean?" | Link state |
| `verifiedProfile` | "What does Verified mean?" | Verified state |
| `profileTrustContribution` | "Profile Trust Points" | Trust contribution |
| `tokenVerification` | "Token Verification" | Token-in-bio |
| `screenshotVerification` | "Screenshot Verification" | Camera capture |
| `reportConcern` | "Report a Concern" | Safety flagging |
| `concernPrivacy` | "Concern Privacy" | Anonymous reporting |
| `contactSupport` | "Contact Support" | Help system |
| `supportResponseTime` | "Response Time" | 24-48 hours |

---

## Implementation Status

### Overall Progress

| Category | Complete | Total | Percentage |
|----------|----------|-------|------------|
| Screens | 48 | 48 | 100% |
| Core Widgets | 21 | 21 | 100% |
| Navigation | 100% | - | Complete |
| Info Points | 50+ | 50+ | 100% |
| Theme | 100% | - | Complete |

### Section Compliance

| Section | Description | Status |
|---------|-------------|--------|
| 47 | Public Trust Passport | ✅ Complete |
| 48 | Platform Configuration | ✅ Complete |
| 49 | Level 3 Verification | ✅ Complete |
| 49.6 | Extraction Service | ✅ Complete |
| 50 | User Growth Strategy | ✅ Complete |
| 50.2.1 | Onboarding Tour | ✅ Complete |
| 50.2.2 | Onboarding Checklist | ✅ Complete |
| 50.2.3 | Demo Profile Preview | ✅ Complete |
| 50.3.2 | Progress Rings | ✅ Complete |
| 50.3.3 | Social Proof | ✅ Complete |
| 50.5.2 | Achievement Badges | ✅ Complete |
| 50.6.1 | Referral System | ✅ Complete |
| 51 | Trust Passport Sharing | ✅ Complete |
| 51.3 | Verified Badge Generator | ✅ Complete |
| 51.4 | Smart Sharing Logic | ✅ Complete |
| 51.5 | Visibility Controls | ✅ Complete |
| 51.7 | Sharing Education | ✅ Complete |
| 52 | Unified Profile Linking | ✅ Complete |
| 52.6 | Public Profile Display | ✅ Complete |
| 52.7 | TrustScore Integration | ✅ Complete |
| 53 | UI Design Language | ✅ Complete |
| 53.7 | Info Points System | ✅ Complete |
| 54 | Login & Session Security | ✅ Complete |

### API Integration Status

| Service | File | Status |
|---------|------|--------|
| Auth | `auth_service.dart` | ✅ Wired |
| TrustScore | `trustscore_api_service.dart` | ✅ Wired |
| Evidence | `evidence_api_service.dart` | ✅ Wired |
| Profile Linking | `profile_linking_service.dart` | ✅ Wired |
| Receipts | `receipt_api_service.dart` | ✅ Wired |
| Referral | `referral_api_service.dart` | ✅ Wired |
| Security | `security_api_service.dart` | ✅ Wired |
| User | `user_api_service.dart` | ✅ Wired |
| Smart Sharing | `smart_sharing_service.dart` | ✅ Wired |
| Concern | `concern_service.dart` | ✅ Wired |
| Support | `support_service.dart` | ✅ Wired |

---

## Change Log

### 2025-11-29 - Comprehensive UI Master Log Created

**Files Touched:**
- `SILENTID_UI_MASTER_LOG.md` (this file)

**Summary:**
- Expanded UI Master Log with complete documentation
- Documented all 48 screens with routes and status
- Listed all 21 core widgets with purpose and section references
- Mapped complete navigation structure (5-tab bottom nav)
- Catalogued 50+ info points by category
- Verified 100% Section 53 compliance
- Added color palette with platform brand colors
- Added typography and spacing specifications
- Added quick reference for creating new screens/widgets

---

### 2025-11-29 - UI Master Prompt Audit & Cleanup

**Files Touched:**
- `onboarding_checklist.dart`
- `demo_profile_preview.dart`
- `onboarding_tour_screen.dart`
- `achievement_badges.dart`

**Sections Referenced:**
- Section 50 (User Growth Strategy)
- Section 53 (UI Design Language)
- UI Master Prompt (5-tab navigation, mutual verification removal)

**Summary:**
- Conducted full UI audit against UI Master Prompt specification
- Found 95%+ alignment with spec
- Verified all Mutual Verification references removed
- Confirmed 3-component TrustScore model in UI

---

### 2025-11-28 - Level 3 Verification & OCR Integration

**Files Touched:**
- `level3_verification_screen.dart`
- `profile_link_screen.dart`
- `email_receipts_setup_screen.dart`
- Multiple navigation updates

**Summary:**
- Level 3 verification flow complete (Section 49)
- OCR service integration (Section 49.6)
- Email receipts forwarding setup (Section 47.4)
- GoRouter navigation migration complete

---

### 2025-11-28 - Report Concern & Contact Support

**Files Touched:**
- `report_concern_screen.dart` (NEW)
- `contact_support_screen.dart` (NEW)
- `concern_service.dart` (NEW)
- `support_service.dart` (NEW)

**Summary:**
- Report Concern: 4-step defamation-safe flow
- Contact Support: Unified help ticket system
- Both features use safe, neutral language
- Admin panel modules added

---

### 2025-11-27 - Section 52 Profile Linking Complete

**Files Touched:**
- `connect_profiles_screen.dart`
- `add_profile_screen.dart`
- `connected_profiles_screen.dart`
- `upgrade_to_verified_screen.dart`
- `public_connected_profiles.dart`

**Summary:**
- 16 platform configurations
- Token-in-bio verification (Flow B)
- Screenshot verification (Flow C)
- Public passport display (3 widget variants)
- TrustScore integration (Section 52.7)

---

### 2025-11-27 - Section 50-51 User Growth Complete

**Files Touched:**
- `onboarding_tour_screen.dart`
- `onboarding_checklist.dart`
- `demo_profile_preview.dart`
- `achievement_badges.dart`
- `referral_screen.dart`
- `sharing_education_screen.dart`
- `verified_badge_generator.dart`
- `smart_sharing_service.dart`

**Summary:**
- 6-page onboarding tour
- 3-step progress checklist
- Demo profile preview
- 11 achievement badges
- Referral program (+50 bonus)
- Smart sharing logic
- Visibility controls (Public/Badge-only/Private)

---

### 2025-11-28 - Mutual Verification Removal

**Files Removed:**
- `lib/features/mutual_verification/` (entire directory)
- `lib/services/mutual_verification_service.dart`
- `lib/models/mutual_verification.dart`

**Summary:**
- Feature deprecated
- TrustScore simplified to 3-component model
- All UI references cleaned up
- Database migration created

---

## Quick Reference

### Creating New Screens

1. Follow Section 53 design language
2. Use `AppTheme` colors and typography
3. Add route to `app_router.dart`
4. Include info points where helpful
5. Add haptic feedback on interactions
6. Use 24px horizontal padding
7. Use 12px border radius for cards
8. Register in this log

### Creating New Widgets

1. Place in `lib/core/widgets/`
2. Follow naming convention: `snake_case.dart`
3. Use `AppTheme` constants
4. Support both light and dark themes
5. Add to Core Widgets section above

### Adding Info Points

1. Add definition to `info_point_data.dart`
2. Use `InfoPoint` widget with ID reference
3. Document in Info Points section above

### File Paths

| Category | Path |
|----------|------|
| Screens | `lib/features/{feature}/screens/` |
| Widgets | `lib/core/widgets/` |
| Services | `lib/services/` |
| Theme | `lib/core/theme/` |
| Router | `lib/core/router/` |
| Data | `lib/core/data/` |
| Models | `lib/models/` |

---

**END OF UI MASTER LOG**
