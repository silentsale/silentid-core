import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_spacing.dart';

/// TrustScore Star Rating Widget
///
/// Converts TrustScore (0-1000) to visual 5-star representation.
/// Following Section 47 specifications from CLAUDE.md.
///
/// Conversion Formula: TrustScore / 200 = stars
/// Example: 800 / 200 = 4 stars
///
/// Color Bands (from Section 3):
/// - 801-1000: Success Green (Exceptional Trust)
/// - 601-800: Primary Purple (High Trust)
/// - 401-600: Warning Amber (Moderate Trust)
/// - 0-400: Danger Red (Low Trust / High Risk)
class TrustScoreStarRating extends StatelessWidget {
  /// The TrustScore value (0-1000)
  final int trustScore;

  /// Size of each star icon
  final double starSize;

  /// Whether to show the numeric score next to stars
  final bool showNumericScore;

  /// Whether to show the score label (e.g., "High Trust")
  final bool showLabel;

  /// Optional custom color override
  final Color? colorOverride;

  const TrustScoreStarRating({
    super.key,
    required this.trustScore,
    this.starSize = 20.0,
    this.showNumericScore = false,
    this.showLabel = false,
    this.colorOverride,
  });

  /// Small preset - for compact displays
  factory TrustScoreStarRating.small({
    Key? key,
    required int trustScore,
    bool showNumericScore = false,
    Color? colorOverride,
  }) {
    return TrustScoreStarRating(
      key: key,
      trustScore: trustScore,
      starSize: 16.0,
      showNumericScore: showNumericScore,
      showLabel: false,
      colorOverride: colorOverride,
    );
  }

  /// Medium preset - default size
  factory TrustScoreStarRating.medium({
    Key? key,
    required int trustScore,
    bool showNumericScore = true,
    bool showLabel = false,
    Color? colorOverride,
  }) {
    return TrustScoreStarRating(
      key: key,
      trustScore: trustScore,
      starSize: 20.0,
      showNumericScore: showNumericScore,
      showLabel: showLabel,
      colorOverride: colorOverride,
    );
  }

  /// Large preset - for profile headers
  factory TrustScoreStarRating.large({
    Key? key,
    required int trustScore,
    bool showNumericScore = true,
    bool showLabel = true,
    Color? colorOverride,
  }) {
    return TrustScoreStarRating(
      key: key,
      trustScore: trustScore,
      starSize: 28.0,
      showNumericScore: showNumericScore,
      showLabel: showLabel,
      colorOverride: colorOverride,
    );
  }

  /// Convert TrustScore (0-1000) to star rating (0.0-5.0)
  double get starRating {
    // Clamp score to valid range
    final clampedScore = trustScore.clamp(0, 1000);
    // Convert: 1000 / 200 = 5.0 stars
    return clampedScore / 200.0;
  }

  /// Get the appropriate color based on TrustScore band
  Color get ratingColor {
    if (colorOverride != null) return colorOverride!;

    if (trustScore >= 801) return AppTheme.successGreen;
    if (trustScore >= 601) return AppTheme.primaryPurple;
    if (trustScore >= 401) return AppTheme.warningAmber;
    return AppTheme.dangerRed;
  }

  /// Get the trust level label
  String get trustLabel {
    if (trustScore >= 850) return 'Exceptional Trust';
    if (trustScore >= 700) return 'Very High Trust';
    if (trustScore >= 550) return 'High Trust';
    if (trustScore >= 400) return 'Moderate Trust';
    if (trustScore >= 250) return 'Low Trust';
    return 'High Risk';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Star icons
            _buildStars(),

            // Numeric score (optional)
            if (showNumericScore) ...[
              SizedBox(width: AppSpacing.xs),
              Text(
                _formatStarRating(starRating),
                style: TextStyle(
                  fontSize: starSize * 0.8,
                  fontWeight: FontWeight.w600,
                  color: ratingColor,
                ),
              ),
            ],
          ],
        ),

        // Label (optional)
        if (showLabel) ...[
          SizedBox(height: AppSpacing.xxs),
          Text(
            trustLabel,
            style: TextStyle(
              fontSize: starSize * 0.65,
              fontWeight: FontWeight.w500,
              color: ratingColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final fillAmount = (starRating - index).clamp(0.0, 1.0);

        return Padding(
          padding: EdgeInsets.only(
            right: index < 4 ? AppSpacing.xxs / 2 : 0,
          ),
          child: _buildStar(fillAmount),
        );
      }),
    );
  }

  Widget _buildStar(double fillAmount) {
    // Full star
    if (fillAmount >= 1.0) {
      return Icon(
        Icons.star_rounded,
        size: starSize,
        color: ratingColor,
      );
    }

    // Empty star
    if (fillAmount <= 0.0) {
      return Icon(
        Icons.star_outline_rounded,
        size: starSize,
        color: AppTheme.neutralGray300,
      );
    }

    // Partial star - use stack with clipped filled star
    return SizedBox(
      width: starSize,
      height: starSize,
      child: Stack(
        children: [
          // Background empty star
          Icon(
            Icons.star_outline_rounded,
            size: starSize,
            color: AppTheme.neutralGray300,
          ),
          // Clipped filled star
          ClipRect(
            clipper: _StarClipper(fillAmount),
            child: Icon(
              Icons.star_rounded,
              size: starSize,
              color: ratingColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatStarRating(double rating) {
    // Round to 1 decimal place
    final rounded = (rating * 10).round() / 10;
    // Always show 1 decimal place
    return rounded.toStringAsFixed(1);
  }
}

/// Custom clipper for partial star fill
class _StarClipper extends CustomClipper<Rect> {
  final double fillAmount;

  _StarClipper(this.fillAmount);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * fillAmount, size.height);
  }

  @override
  bool shouldReclip(_StarClipper oldClipper) {
    return fillAmount != oldClipper.fillAmount;
  }
}

/// Extension to add star rating display to TrustScore
extension TrustScoreStarExtension on int {
  /// Convert TrustScore to star rating widget
  Widget toStarRating({
    double starSize = 20.0,
    bool showNumericScore = false,
    bool showLabel = false,
  }) {
    return TrustScoreStarRating(
      trustScore: this,
      starSize: starSize,
      showNumericScore: showNumericScore,
      showLabel: showLabel,
    );
  }
}
