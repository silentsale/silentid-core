import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/info_point_data.dart';
import 'info_point.dart';
import 'info_modal.dart';

/// Helper widget that combines InfoPoint icon with InfoModal
///
/// Usage:
/// ```dart
/// Row(
///   children: [
///     Text('TrustScore'),
///     SizedBox(width: 6),
///     InfoPointHelper(data: InfoPoints.trustScoreOverall),
///   ],
/// )
/// ```
class InfoPointHelper extends StatelessWidget {
  final InfoPointData data;
  final Color? iconColor; // Custom color for dark backgrounds

  const InfoPointHelper({
    super.key,
    required this.data,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InfoPoint(
      semanticLabel: 'Info: ${data.title}',
      onTap: () => _showInfoModal(context),
      iconColor: iconColor,
    );
  }

  void _showInfoModal(BuildContext context) {
    InfoModal.show(
      context,
      title: data.title,
      body: data.body,
      icon: data.icon,
      learnMoreText: data.learnMoreText,
      onLearnMore: data.learnMoreUrl != null
          ? () => _openLearnMore(context, data.learnMoreUrl!)
          : null,
      actionButtonText: data.actionButtonText,
      onActionButton: data.onAction,
    );
  }

  Future<void> _openLearnMore(BuildContext context, String url) async {
    final uri = Uri.parse(url);

    // Try to launch in-app browser first (preferred on mobile)
    try {
      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView, // In-app browser
        );
      } else {
        // Fallback to external browser
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      // Show error if can't open link
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link: $url'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Extension to easily add info points to text widgets
///
/// Usage:
/// ```dart
/// Text('TrustScore').withInfoPoint(InfoPoints.trustScoreOverall)
/// ```
extension InfoPointExtension on Widget {
  Widget withInfoPoint(InfoPointData data, {double gap = 6.0}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        this,
        SizedBox(width: gap),
        InfoPointHelper(data: data),
      ],
    );
  }
}
