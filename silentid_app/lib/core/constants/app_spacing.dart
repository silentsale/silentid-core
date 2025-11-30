import 'package:flutter/material.dart';

/// Design token system based on 4-point grid
///
/// Spacing values for consistent UI layout following Section 39.7 & Section 53
class AppSpacing {
  // ─────────────────────────────────────────────────────────────────────────
  // SPACING TOKENS (4-point grid)
  // ─────────────────────────────────────────────────────────────────────────

  /// Tiny gaps (4px)
  static const double xxs = 4.0;

  /// Small gaps within items (8px)
  static const double xs = 8.0;

  /// Medium gaps within items (12px)
  static const double sm = 12.0;

  /// Standard gaps between items (16px)
  static const double md = 16.0;

  /// Gaps between item groups (24px)
  static const double lg = 24.0;

  /// Gaps between major sections (32px)
  static const double xl = 32.0;

  /// Extra large gaps - rare use (48px)
  static const double xxl = 48.0;

  // ─────────────────────────────────────────────────────────────────────────
  // BORDER RADIUS TOKENS (Section 53 UI Design Language)
  // ─────────────────────────────────────────────────────────────────────────

  /// Smallest radius for tags, badges, small chips (4px)
  static const double radiusXs = 4.0;

  /// Small radius for inner elements, progress bars (8px)
  static const double radiusSm = 8.0;

  /// Standard radius for cards, buttons, inputs (12px) - PRIMARY
  static const double radiusMd = 12.0;

  /// Large radius for modals, bottom sheets (16px)
  static const double radiusLg = 16.0;

  /// Extra large radius for pill shapes, avatars (20px)
  static const double radiusXl = 20.0;

  /// Full pill radius for rounded buttons (24px)
  static const double radiusPill = 24.0;

  /// Full circle (used with BorderRadius.circular for avatars)
  static const double radiusCircle = 999.0;

  // ─────────────────────────────────────────────────────────────────────────
  // BORDER RADIUS HELPERS
  // ─────────────────────────────────────────────────────────────────────────

  /// Card border radius (12px) - for all cards
  static BorderRadius get cardRadius => BorderRadius.circular(radiusMd);

  /// Button border radius (12px) - for all buttons
  static BorderRadius get buttonRadius => BorderRadius.circular(radiusMd);

  /// Input border radius (12px) - for text fields
  static BorderRadius get inputRadius => BorderRadius.circular(radiusMd);

  /// Modal border radius (16px) - for dialogs, bottom sheets
  static BorderRadius get modalRadius => BorderRadius.circular(radiusLg);

  /// Sheet top radius (20px) - for bottom sheets (top corners only)
  static BorderRadius get sheetTopRadius => const BorderRadius.vertical(
        top: Radius.circular(20.0),
      );

  /// Badge/chip radius (4px) - for small indicators
  static BorderRadius get badgeRadius => BorderRadius.circular(radiusXs);

  /// Progress bar radius (8px) - for progress indicators
  static BorderRadius get progressRadius => BorderRadius.circular(radiusSm);

  /// Pill radius (24px) - for pill-shaped buttons
  static BorderRadius get pillRadius => BorderRadius.circular(radiusPill);
}
