import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

/// Smart Sharing Service for Section 51.4
/// Automatically detects context and chooses the safest sharing format:
/// - Link sharing for platforms that support it
/// - Badge image sharing for platforms that restrict links
/// - Fallback mechanisms for restricted platforms

/// Platform sharing capabilities
enum SharingCapability {
  /// Platform fully supports links (WhatsApp, Telegram, Email, SMS)
  linksSupported,

  /// Platform restricts links (Instagram bio, TikTok, some dating apps)
  linksRestricted,

  /// Unknown platform - use safe fallback
  unknown,
}

/// Sharing format to use
enum SharingFormat {
  publicPassportLink,
  verifiedBadgeImage,
  linkWithBadgeAttachment,
  qrCodeOnly,
}

/// Known platform configurations
class PlatformSharingConfig {
  final String platformId;
  final String displayName;
  final SharingCapability capability;
  final SharingFormat preferredFormat;
  final String? packageName; // Android package name
  final String? urlScheme; // iOS URL scheme

  const PlatformSharingConfig({
    required this.platformId,
    required this.displayName,
    required this.capability,
    required this.preferredFormat,
    this.packageName,
    this.urlScheme,
  });
}

/// Smart Sharing Service
class SmartSharingService {
  static const _instance = SmartSharingService._();
  const SmartSharingService._();
  factory SmartSharingService() => _instance;

  /// Known platform configurations
  static const List<PlatformSharingConfig> _platformConfigs = [
    // Link-friendly platforms
    PlatformSharingConfig(
      platformId: 'whatsapp',
      displayName: 'WhatsApp',
      capability: SharingCapability.linksSupported,
      preferredFormat: SharingFormat.publicPassportLink,
      packageName: 'com.whatsapp',
      urlScheme: 'whatsapp',
    ),
    PlatformSharingConfig(
      platformId: 'telegram',
      displayName: 'Telegram',
      capability: SharingCapability.linksSupported,
      preferredFormat: SharingFormat.publicPassportLink,
      packageName: 'org.telegram.messenger',
      urlScheme: 'tg',
    ),
    PlatformSharingConfig(
      platformId: 'email',
      displayName: 'Email',
      capability: SharingCapability.linksSupported,
      preferredFormat: SharingFormat.linkWithBadgeAttachment,
    ),
    PlatformSharingConfig(
      platformId: 'sms',
      displayName: 'SMS',
      capability: SharingCapability.linksSupported,
      preferredFormat: SharingFormat.publicPassportLink,
    ),
    PlatformSharingConfig(
      platformId: 'facebook_messenger',
      displayName: 'Messenger',
      capability: SharingCapability.linksSupported,
      preferredFormat: SharingFormat.publicPassportLink,
      packageName: 'com.facebook.orca',
      urlScheme: 'fb-messenger',
    ),
    PlatformSharingConfig(
      platformId: 'imessage',
      displayName: 'iMessage',
      capability: SharingCapability.linksSupported,
      preferredFormat: SharingFormat.publicPassportLink,
    ),

    // Link-restricted platforms (image sharing preferred)
    PlatformSharingConfig(
      platformId: 'instagram',
      displayName: 'Instagram',
      capability: SharingCapability.linksRestricted,
      preferredFormat: SharingFormat.verifiedBadgeImage,
      packageName: 'com.instagram.android',
      urlScheme: 'instagram',
    ),
    PlatformSharingConfig(
      platformId: 'tiktok',
      displayName: 'TikTok',
      capability: SharingCapability.linksRestricted,
      preferredFormat: SharingFormat.verifiedBadgeImage,
      packageName: 'com.zhiliaoapp.musically',
      urlScheme: 'snssdk1128',
    ),
    PlatformSharingConfig(
      platformId: 'snapchat',
      displayName: 'Snapchat',
      capability: SharingCapability.linksRestricted,
      preferredFormat: SharingFormat.verifiedBadgeImage,
      packageName: 'com.snapchat.android',
      urlScheme: 'snapchat',
    ),
    PlatformSharingConfig(
      platformId: 'tinder',
      displayName: 'Tinder',
      capability: SharingCapability.linksRestricted,
      preferredFormat: SharingFormat.qrCodeOnly,
      packageName: 'com.tinder',
    ),
    PlatformSharingConfig(
      platformId: 'bumble',
      displayName: 'Bumble',
      capability: SharingCapability.linksRestricted,
      preferredFormat: SharingFormat.qrCodeOnly,
      packageName: 'com.bumble.app',
    ),
    PlatformSharingConfig(
      platformId: 'hinge',
      displayName: 'Hinge',
      capability: SharingCapability.linksRestricted,
      preferredFormat: SharingFormat.qrCodeOnly,
      packageName: 'co.hinge.app',
    ),
  ];

  /// Determine the best sharing format for a given context
  SharingFormat determineFormat({
    String? targetPlatformId,
    bool userPrefersBadge = false,
    bool isTrustScorePublic = true,
  }) {
    // User preference override
    if (userPrefersBadge) {
      return SharingFormat.verifiedBadgeImage;
    }

    // If TrustScore is private, badge still shows badges/verification status
    // but the QR code still works

    // Check specific platform
    if (targetPlatformId != null) {
      final config = _platformConfigs.firstWhere(
        (c) => c.platformId == targetPlatformId,
        orElse: () => const PlatformSharingConfig(
          platformId: 'unknown',
          displayName: 'Unknown',
          capability: SharingCapability.unknown,
          preferredFormat: SharingFormat.linkWithBadgeAttachment,
        ),
      );
      return config.preferredFormat;
    }

    // Default: link with badge attachment for maximum compatibility
    return SharingFormat.linkWithBadgeAttachment;
  }

  /// Get all platform configs for UI display
  List<PlatformSharingConfig> get allPlatforms => _platformConfigs;

  /// Get platforms that support links
  List<PlatformSharingConfig> get linkFriendlyPlatforms => _platformConfigs
      .where((c) => c.capability == SharingCapability.linksSupported)
      .toList();

  /// Get platforms that restrict links
  List<PlatformSharingConfig> get linkRestrictedPlatforms => _platformConfigs
      .where((c) => c.capability == SharingCapability.linksRestricted)
      .toList();

  /// Execute smart share based on format
  Future<void> executeShare({
    required SharingFormat format,
    required String publicPassportUrl,
    File? badgeImageFile,
    String? targetPlatformId,
  }) async {
    switch (format) {
      case SharingFormat.publicPassportLink:
        await _shareLink(publicPassportUrl);
        break;

      case SharingFormat.verifiedBadgeImage:
        if (badgeImageFile != null) {
          await _shareImage(badgeImageFile, publicPassportUrl);
        } else {
          // Fallback to link if no image
          await _shareLink(publicPassportUrl);
        }
        break;

      case SharingFormat.linkWithBadgeAttachment:
        if (badgeImageFile != null) {
          await _shareLinkWithImage(publicPassportUrl, badgeImageFile);
        } else {
          await _shareLink(publicPassportUrl);
        }
        break;

      case SharingFormat.qrCodeOnly:
        if (badgeImageFile != null) {
          await _shareImage(badgeImageFile, null);
        }
        break;
    }
  }

  Future<void> _shareLink(String url) async {
    await SharePlus.instance.share(
      ShareParams(
        text: 'Check out my verified identity: $url',
        subject: 'My SilentID Public Passport',
      ),
    );
  }

  Future<void> _shareImage(File imageFile, String? captionUrl) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(imageFile.path)],
        text: captionUrl != null
            ? 'Verified on SilentID - $captionUrl'
            : 'Verified on SilentID',
        subject: 'My SilentID Verified Badge',
      ),
    );
  }

  Future<void> _shareLinkWithImage(String url, File imageFile) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(imageFile.path)],
        text: 'Check out my verified identity: $url',
        subject: 'My SilentID Public Passport',
      ),
    );
  }

  /// Copy link with smart clipboard detection
  Future<void> copyLinkToClipboard(
    String publicPassportUrl, {
    VoidCallback? onCopied,
    VoidCallback? onRestrictedPlatformDetected,
  }) async {
    await Clipboard.setData(ClipboardData(text: publicPassportUrl));
    HapticFeedback.mediumImpact();
    onCopied?.call();

    // Note: True clipboard monitoring for restricted platforms
    // would require platform channels. For now, we show a helpful tip.
  }

  /// Get sharing recommendation message
  String getRecommendationMessage(SharingFormat format) {
    switch (format) {
      case SharingFormat.publicPassportLink:
        return 'Share your public passport link directly.';
      case SharingFormat.verifiedBadgeImage:
        return 'This platform restricts links. Sharing your verified badge image with QR code instead.';
      case SharingFormat.linkWithBadgeAttachment:
        return 'Sharing your link with badge image attached for best visibility.';
      case SharingFormat.qrCodeOnly:
        return 'This platform restricts links. Share your badge - others can scan the QR code.';
    }
  }

  /// Get icon for sharing format
  IconData getFormatIcon(SharingFormat format) {
    switch (format) {
      case SharingFormat.publicPassportLink:
        return Icons.link_rounded;
      case SharingFormat.verifiedBadgeImage:
        return Icons.image_rounded;
      case SharingFormat.linkWithBadgeAttachment:
        return Icons.attach_file_rounded;
      case SharingFormat.qrCodeOnly:
        return Icons.qr_code_rounded;
    }
  }
}

/// Smart Share Button Widget
class SmartShareButton extends StatelessWidget {
  final String publicPassportUrl;
  final File? badgeImageFile;
  final bool userPrefersBadge;
  final bool isTrustScorePublic;
  final String? targetPlatformId;
  final VoidCallback? onShareComplete;

  const SmartShareButton({
    super.key,
    required this.publicPassportUrl,
    this.badgeImageFile,
    this.userPrefersBadge = false,
    this.isTrustScorePublic = true,
    this.targetPlatformId,
    this.onShareComplete,
  });

  @override
  Widget build(BuildContext context) {
    final service = SmartSharingService();
    final format = service.determineFormat(
      targetPlatformId: targetPlatformId,
      userPrefersBadge: userPrefersBadge,
      isTrustScorePublic: isTrustScorePublic,
    );

    return Material(
      color: const Color(0xFF5A3EB8), // AppTheme.primaryPurple
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          HapticFeedback.mediumImpact();
          await service.executeShare(
            format: format,
            publicPassportUrl: publicPassportUrl,
            badgeImageFile: badgeImageFile,
            targetPlatformId: targetPlatformId,
          );
          onShareComplete?.call();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                service.getFormatIcon(format),
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Share',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Platform Picker for Smart Sharing
class PlatformSharePicker extends StatelessWidget {
  final String publicPassportUrl;
  final File? badgeImageFile;
  final bool isTrustScorePublic;
  final VoidCallback? onDismiss;

  const PlatformSharePicker({
    super.key,
    required this.publicPassportUrl,
    this.badgeImageFile,
    this.isTrustScorePublic = true,
    this.onDismiss,
  });

  static void show(
    BuildContext context, {
    required String publicPassportUrl,
    File? badgeImageFile,
    bool isTrustScorePublic = true,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PlatformSharePicker(
        publicPassportUrl: publicPassportUrl,
        badgeImageFile: badgeImageFile,
        isTrustScorePublic: isTrustScorePublic,
        onDismiss: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = SmartSharingService();
    final linkFriendly = service.linkFriendlyPlatforms;
    final restricted = service.linkRestrictedPlatforms;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Share Your Trust Identity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111111),
                  ),
                ),
              ),
              IconButton(
                onPressed: onDismiss,
                icon: const Icon(Icons.close, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Link-friendly section
          const Text(
            'Share Link',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4C4C4C),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: linkFriendly.map((platform) {
              return _PlatformChip(
                platform: platform,
                onTap: () async {
                  onDismiss?.call();
                  await service.executeShare(
                    format: platform.preferredFormat,
                    publicPassportUrl: publicPassportUrl,
                    badgeImageFile: badgeImageFile,
                    targetPlatformId: platform.platformId,
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Image-preferred section
          const Text(
            'Share Badge Image',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4C4C4C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'These platforms restrict links - we\'ll share your badge with QR code',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: restricted.map((platform) {
              return _PlatformChip(
                platform: platform,
                isRestricted: true,
                onTap: () async {
                  onDismiss?.call();
                  await service.executeShare(
                    format: platform.preferredFormat,
                    publicPassportUrl: publicPassportUrl,
                    badgeImageFile: badgeImageFile,
                    targetPlatformId: platform.platformId,
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Copy link option
          ListTile(
            onTap: () {
              service.copyLinkToClipboard(
                publicPassportUrl,
                onCopied: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Link copied to clipboard'),
                      backgroundColor: Color(0xFF1FBF71),
                    ),
                  );
                  onDismiss?.call();
                },
              );
            },
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF5A3EB8).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.copy_rounded,
                color: Color(0xFF5A3EB8),
                size: 20,
              ),
            ),
            title: const Text(
              'Copy Link',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              publicPassportUrl,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.chevron_right),
            contentPadding: EdgeInsets.zero,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _PlatformChip extends StatelessWidget {
  final PlatformSharingConfig platform;
  final bool isRestricted;
  final VoidCallback onTap;

  const _PlatformChip({
    required this.platform,
    this.isRestricted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isRestricted
          ? const Color(0xFFFFF7ED)
          : const Color(0xFFF3F0FF),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isRestricted)
                const Icon(
                  Icons.image_rounded,
                  size: 14,
                  color: Color(0xFFD97706),
                )
              else
                const Icon(
                  Icons.link_rounded,
                  size: 14,
                  color: Color(0xFF5A3EB8),
                ),
              const SizedBox(width: 6),
              Text(
                platform.displayName,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isRestricted
                      ? const Color(0xFFD97706)
                      : const Color(0xFF5A3EB8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
