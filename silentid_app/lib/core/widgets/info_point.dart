import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Info Point icon widget following Section 40.2 specifications
///
/// Symbol: ⓘ (circled lowercase "i")
/// Size: 20×20 dp
/// Color: Neutral gray (default) / Royal purple (tapped)
class InfoPoint extends StatelessWidget {
  final VoidCallback onTap;
  final String semanticLabel;

  const InfoPoint({
    super.key,
    required this.onTap,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          child: Icon(
            Icons.info_outline,
            size: 20,
            color: AppTheme.neutralGray700,
          ),
        ),
      ),
    );
  }
}
