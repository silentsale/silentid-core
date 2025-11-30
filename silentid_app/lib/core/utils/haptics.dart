import 'package:flutter/services.dart';

/// Haptic feedback utility for consistent tactile responses
///
/// Following Section 53 UI Design Language for haptic patterns:
/// - Light: Selection, toggle, minor state changes
/// - Medium: Button taps, confirmations
/// - Heavy: Success, errors, important actions
/// - Selection: List selections, tab changes
class AppHaptics {
  /// Light haptic - for minor interactions
  /// Use: Toggle switches, radio selections, checkboxes
  static void light() {
    HapticFeedback.lightImpact();
  }

  /// Medium haptic - standard button feedback
  /// Use: Primary/secondary button taps, form submissions
  static void medium() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy haptic - for significant actions
  /// Use: Success confirmations, error states, destructive actions
  static void heavy() {
    HapticFeedback.heavyImpact();
  }

  /// Selection haptic - for selections and navigation
  /// Use: Tab switches, list item selections, picker changes
  static void selection() {
    HapticFeedback.selectionClick();
  }

  /// Success haptic - double light for positive feedback
  /// Use: Upload complete, verification success, achievement unlocked
  static Future<void> success() async {
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    HapticFeedback.lightImpact();
  }

  /// Error haptic - heavy with vibrate for errors
  /// Use: Validation errors, failed operations, warnings
  static Future<void> error() async {
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    HapticFeedback.vibrate();
  }

  /// Warning haptic - medium for warnings
  /// Use: Destructive action confirmation, rate limit warnings
  static void warning() {
    HapticFeedback.mediumImpact();
  }

  /// Notification haptic - for alerts and notifications
  /// Use: Push notifications, security alerts
  static void notification() {
    HapticFeedback.vibrate();
  }

  /// Scroll haptic - for reaching scroll boundaries
  /// Use: Pull-to-refresh, end of list
  static void scrollBoundary() {
    HapticFeedback.lightImpact();
  }

  /// Long press haptic - for long press actions
  /// Use: Context menus, drag start
  static void longPress() {
    HapticFeedback.mediumImpact();
  }

  /// Slider haptic - for continuous value changes
  /// Use: Sliders at step values
  static void sliderTick() {
    HapticFeedback.selectionClick();
  }
}

/// Extension to add haptic feedback to callbacks
extension HapticCallback on VoidCallback {
  /// Wraps callback with light haptic
  VoidCallback withLightHaptic() {
    return () {
      AppHaptics.light();
      this();
    };
  }

  /// Wraps callback with medium haptic
  VoidCallback withMediumHaptic() {
    return () {
      AppHaptics.medium();
      this();
    };
  }

  /// Wraps callback with selection haptic
  VoidCallback withSelectionHaptic() {
    return () {
      AppHaptics.selection();
      this();
    };
  }
}
