# SILENTID UI MASTER LOG

This file tracks all UI changes, navigation rules, and decisions for the SilentID app.
Maintained per UI Master Prompt requirements.

---

## Log Format

Each entry includes:
- **Date/Time**
- **Files Touched**
- **Sections Referenced** (from CLAUDE_FULL.md)
- **Summary** (1-5 bullet points)
- **TODOs/Questions** (if any)

---

## 2025-11-29 - UI Master Prompt Audit & Cleanup

### Files Touched
- `onboarding_checklist.dart`
- `demo_profile_preview.dart`
- `onboarding_tour_screen.dart`
- `achievement_badges.dart`

### Sections Referenced
- Section 50 (User Growth Strategy)
- Section 53 (UI Design Language)
- UI Master Prompt (5-tab navigation, mutual verification removal)

### Summary
- Conducted full UI audit against UI Master Prompt specification
- Found 95%+ alignment with spec
- Identified 4 files still referencing deprecated Mutual Verification feature
- Removed all Mutual Verification references:
  - Changed onboarding step 3 from "Get verified" to "Add your first evidence"
  - Removed verification count stat from demo profile
  - Updated onboarding tour page 5 messaging
  - Repurposed firstVerification badge to evidence-based

### TODOs
- None - all Mutual Verification cleanup complete

---

## UI Navigation Structure (Locked)

### Bottom Navigation (5 Tabs)
1. **Home** - TrustScore dashboard, onboarding checklist, demo preview
2. **Evidence** - Evidence vault (receipts, screenshots, profile links)
3. **Profile** - Public Trust Passport preview, sharing
4. **Security** - Risk indicator, devices, login history
5. **Settings** - Account, privacy toggles, data export

### Key Screens by Tab

**Home Tab:**
- `enhanced_home_screen.dart` - Main dashboard
- `onboarding_tour_screen.dart` - First-launch tour
- `onboarding_checklist.dart` - Progress widget

**Evidence Tab:**
- `evidence_overview_screen.dart` - Evidence summary
- `receipt_list_screen.dart` - Email receipts
- `email_receipts_setup_screen.dart` - Forwarding setup
- `connect_profiles_screen.dart` - Profile linking entry

**Profile Tab:**
- `my_public_profile_screen.dart` - Passport preview
- `public_profile_viewer_screen.dart` - External view
- `connected_profiles_screen.dart` - Linked profiles list
- `upgrade_to_verified_screen.dart` - Verification flow

**Security Tab:**
- `security_center_screen.dart` - Security hub
- `login_activity_screen.dart` - Login history
- `security_alerts_screen.dart` - Alerts

**Settings Tab:**
- `settings_screen.dart` - Main settings
- `privacy_settings_screen.dart` - Visibility controls
- `account_settings_screen.dart` - Account details

---

## Design System Notes (Section 53)

- **Primary Color:** Royal Purple #5A3EB8 (accents only)
- **Typography:** Inter font family
- **Spacing:** 16px grid system
- **Border Radius:** 12px for cards
- **Screen Padding:** 24px horizontal
- **Bottom Nav:** Fixed, always visible on main screens

---

## Info Points Locations

Key info points implemented:
- TrustScore (Home, Profile)
- Identity verification status
- Evidence Vault summary
- Security Risk label
- Privacy/visibility settings
- Connected profiles (Linked vs Verified)
- Referral program
- Achievement badges

See `lib/core/data/info_point_data.dart` for full definitions (50+ entries).

---
