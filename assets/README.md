# SilentID Assets Directory

This directory contains all static assets for the SilentID application.

## 📁 Directory Structure

```
assets/
├── images/              # Logo and image assets
│   ├── silentid-logo.png          # ⚠️ ADD: Full logo (shield + text)
│   ├── silentid-icon.png          # ⚠️ ADD: Icon only (shield)
│   ├── silentid-logo-white.png    # TODO: White version for dark mode
│   └── silentid-icon-white.png    # TODO: White icon for dark mode
│
├── branding/           # Brand guidelines and documentation
│   └── LOGO_USAGE.md              # ✅ Logo usage guide
│
└── README.md                      # This file

```

## 🎨 Logo Files - **ACTION REQUIRED**

### Primary Logo (Shield + Text)
**File to Add:** `images/silentid-logo.png`

**Source:** Logo image provided (purple shield with keyhole + "SilentID" text)

**Specifications:**
- Format: PNG with transparency
- Color: Royal Purple #5A3EB8
- Background: Transparent
- High resolution for scaling
- Recommended: 800x300px minimum

### Icon Only (Shield)
**File to Add:** `images/silentid-icon.png`

**Specifications:**
- Format: PNG with transparency
- Dimensions: 512x512px (square)
- Color: Royal Purple #5A3EB8
- Contains: Shield with keyhole only (no text)

## 📋 How to Add Logo Files

1. **Save the full logo:**
   - Export logo as `silentid-logo.png`
   - Place in `C:\SILENTID\assets\images\`
   - Ensure transparent background
   - High resolution (recommended 800x300px or larger)

2. **Create icon version:**
   - Crop shield portion only (no text)
   - Export as square `silentid-icon.png`
   - Place in `C:\SILENTID\assets\images\`
   - 512x512px minimum for app icons

3. **Verify logo specs:**
   - Color: #5A3EB8 (royal purple)
   - Background: Transparent
   - Format: PNG
   - Quality: High resolution, no artifacts

## 🔗 Usage Documentation

See [branding/LOGO_USAGE.md](branding/LOGO_USAGE.md) for complete usage guidelines including:
- ✅ Correct usage examples
- ❌ Incorrect usage warnings
- Flutter integration code
- Email template usage
- Size recommendations
- Accessibility requirements

## 📱 Flutter Integration (Future)

Once logo files are added, register in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/silentid-logo.png
    - assets/images/silentid-icon.png
```

Then use in Flutter widgets:
```dart
Image.asset('assets/images/silentid-logo.png')
```

## 🎯 Priority Tasks

- [ ] **HIGH:** Add `silentid-logo.png` (full logo with text)
- [ ] **HIGH:** Add `silentid-icon.png` (shield icon only)
- [ ] **MEDIUM:** Create white versions for dark mode
- [ ] **LOW:** Create favicon variants (16x16, 32x32)
- [ ] **LOW:** Create social media share image (1200x630)

## 🔐 Brand Colors Reference

**Primary:**
- Royal Purple: `#5A3EB8`

**Secondary:**
- Dark Mode Purple: `#462F8F`
- Soft Lilac: `#E8E2FF`
- Pure White: `#FFFFFF`
- Deep Black: `#0A0A0A`

**Neutrals:**
- Gray 900: `#111111`
- Gray 700: `#4C4C4C`
- Gray 300: `#DADADA`

**Status:**
- Success Green: `#1FBF71`
- Warning Amber: `#FFC043`
- Danger Red: `#D04C4C`

---

**Note:** Logo files are not yet added. They will be added in the next step of development.
