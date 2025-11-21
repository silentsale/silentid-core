# SilentID Logo Usage Guide

## 📁 Logo Files

**Main Logo Location:**
- Full Logo (with text): `assets/images/silentid-logo.png`
- Shield Icon Only: `assets/images/silentid-icon.png`

## 🎨 Logo Description

**Visual Design:**
- **Shield Icon:** Royal purple (#5A3EB8) shield with white keyhole
- **Typography:** Custom "SilentID" wordmark in royal purple
- **Style:** Modern, secure, professional, bank-grade aesthetic

**Symbolism:**
- **Shield:** Protection, security, trust, safety
- **Keyhole:** Identity, access, verification, privacy
- **Purple:** Premium, trust, professionalism, innovation

## 📐 Logo Specifications

### Primary Logo (Shield + Text)
- **Format:** PNG with transparency
- **Dimensions:** Scalable (original: high resolution)
- **Color:** Royal Purple #5A3EB8
- **Background:** Transparent
- **Clear Space:** Minimum 20px padding on all sides

### Icon Only (Shield)
- **Use Case:** App icons, favicons, small UI elements
- **Format:** PNG with transparency
- **Dimensions:** 512x512px recommended for app icons
- **Color:** Royal Purple #5A3EB8

## 🎯 Usage Guidelines

### ✅ Correct Usage

**Mobile App:**
- Launch screen: Full logo centered
- Login screen: Full logo at top
- Navigation header: Icon only (32x32px)
- Loading states: Icon with animation
- About page: Full logo

**Backend API:**
- Swagger/API documentation header
- Email templates (full logo)
- PDF reports/certificates (full logo)

**Web/Marketing:**
- Website header: Full logo
- Social media: Icon (square crop)
- Documentation: Full logo in headers

### ❌ Incorrect Usage

- Do NOT change logo colors (except white on dark backgrounds)
- Do NOT distort, stretch, or rotate logo
- Do NOT add effects, shadows, or outlines
- Do NOT place on busy backgrounds without sufficient contrast
- Do NOT use outdated or modified versions

## 📱 Flutter App Integration

### Asset Registration (pubspec.yaml)
```yaml
flutter:
  assets:
    - assets/images/silentid-logo.png
    - assets/images/silentid-icon.png
```

### Usage Examples

**Splash Screen:**
```dart
Image.asset(
  'assets/images/silentid-logo.png',
  width: 280,
  height: 120,
  fit: BoxFit.contain,
)
```

**App Bar Icon:**
```dart
Image.asset(
  'assets/images/silentid-icon.png',
  width: 32,
  height: 32,
)
```

**Login Screen:**
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'assets/images/silentid-logo.png',
        width: 240,
        height: 100,
      ),
      SizedBox(height: 40),
      Text(
        'Your Portable Trust Passport',
        style: TextStyle(
          color: Color(0xFF4C4C4C),
          fontSize: 16,
        ),
      ),
    ],
  ),
)
```

## 🌐 API/Backend Usage

### Email Templates
```html
<img src="cid:silentid-logo" alt="SilentID" width="200" style="display: block; margin: 0 auto;" />
```

### Swagger Documentation
Add logo to Swagger UI configuration in Program.cs:
```csharp
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "SilentID API v1");
    c.InjectStylesheet("/swagger-ui/silentid-custom.css");
    c.DocumentTitle = "SilentID API Documentation";
});
```

## 🎨 Logo Variants (Future)

### Dark Mode
- White logo on dark backgrounds
- Maintain shield shape and keyhole
- Ensure WCAG contrast compliance

### Monochrome
- Single color versions for special use cases
- Black on white
- White on black

### Favicon
- 16x16px, 32x32px, 64x64px
- Square crop of shield icon
- Simplified details for small sizes

## 📏 Size Recommendations

### Mobile App
- **Splash Screen:** 280-320px width
- **Login Screen:** 240-280px width
- **Navigation Bar:** 32-40px height
- **Tab Bar:** 24-28px height
- **List Item Icon:** 40-48px
- **Button Icon:** 20-24px

### Web
- **Header:** 180-220px width
- **Footer:** 120-160px width
- **Favicon:** 32x32px
- **Social Share:** 1200x630px (with padding)

### Email
- **Header:** 200-240px width
- **Footer:** 120-140px width

### Print/PDF
- **A4 Header:** 400-600px width (300 DPI)
- **Certificate:** 800-1000px width (300 DPI)

## 🔐 Brand Consistency

**Always pair with:**
- Primary color: #5A3EB8 (Royal Purple)
- Font: Inter
- Clean, minimal design language
- Bank-grade professional tone

**Never pair with:**
- Playful, cartoonish elements
- Gradients (unless subtle and on-brand)
- Multiple bright colors
- Unprofessional imagery

## 📄 File Export Requirements

When exporting logo for different platforms:

**iOS App Icon:**
- 1024x1024px PNG (no transparency)
- White background with centered purple shield
- Export as App Store Connect icon

**Android App Icon:**
- 512x512px PNG (with transparency)
- Adaptive icon: foreground + background layers
- Follow Material Design guidelines

**Web Favicon:**
- 32x32px ICO format
- 16x16px ICO format
- 180x180px PNG (Apple Touch Icon)

## 🎯 Accessibility

**Alt Text:**
- Full Logo: "SilentID - Your Portable Trust Passport"
- Icon Only: "SilentID Shield Icon"
- Decorative: "" (empty alt for decorative usage)

**Contrast Ratios:**
- Purple (#5A3EB8) on white: 7.2:1 (AAA compliant)
- White on purple: 7.2:1 (AAA compliant)
- Ensure readable at all sizes

---

**Version:** 1.0.0
**Last Updated:** 2025-11-21
**Maintained By:** SilentID Development Team
