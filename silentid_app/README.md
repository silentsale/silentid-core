# SilentID Flutter App

Your portable trust passport.

## Quick Start

### Prerequisites
- Flutter SDK 3.9.2+
- Android Studio / VS Code
- iOS Simulator (Mac) or Android Emulator
- Backend API running at http://localhost:5249

### Run the App

```bash
# Get dependencies
flutter pub get

# Run on available device
flutter run

# Run on specific device
flutter run -d <device-id>

# Check available devices
flutter devices
```

## Project Structure

```
lib/
├── core/                  # Core functionality
│   ├── constants/         # API constants
│   ├── router/            # Navigation
│   ├── theme/             # App theming
│   └── widgets/           # Reusable widgets
├── features/              # Feature modules
│   ├── auth/              # Authentication
│   └── home/              # Home screen
├── services/              # Services layer
│   ├── api_service.dart
│   ├── auth_service.dart
│   └── storage_service.dart
└── main.dart              # App entry point
```

## Features

### Phase 1 (Current)
- ✅ Passwordless authentication (Email OTP)
- ✅ Secure token storage
- ✅ JWT token management
- ✅ Auto token refresh
- ✅ Protected routes
- ✅ Royal purple branding (#5A3EB8)
- ✅ Bank-grade UI design

### Coming Soon
- Apple Sign-In
- Google Sign-In
- Passkey authentication
- Stripe Identity verification
- Evidence collection
- TrustScore display
- Mutual verification

## Testing

### Email OTP Flow
1. Open app → Welcome Screen
2. Tap "Continue with Email"
3. Enter email address
4. Tap "Send Verification Code"
5. Check email for OTP
6. Enter 6-digit code
7. Auto-submit → Home Screen

## API Configuration

Base URL: `http://localhost:5249`

Endpoints used:
- POST /v1/auth/request-otp
- POST /v1/auth/verify-otp
- POST /v1/auth/refresh
- POST /v1/auth/logout

## Security

- NO passwords stored (100% passwordless)
- Secure token storage (flutter_secure_storage)
- Auto token refresh on 401
- JWT authentication
- Protected routes

## Branding

- Primary Color: #5A3EB8 (Royal Purple)
- Font: Inter (via Google Fonts)
- Design: Bank-grade, professional, clean

## Support

For issues or questions, refer to:
- `../docs/SPRINT1_FLUTTER_IMPLEMENTATION.md`
- `../CLAUDE.md` specification

---

**Version:** 1.0.0
**Phase:** 1 (Authentication MVP)
**Status:** Production-ready for Phase 1
