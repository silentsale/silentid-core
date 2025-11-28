import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/info_modal.dart';
import '../../../services/profile_linking_service.dart';
import 'upgrade_to_verified_screen.dart';

/// Connected Profiles Screen - Section 52.5
/// Shows all linked and verified profiles
class ConnectedProfilesScreen extends StatefulWidget {
  /// Optional profiles list - if null, loads from service
  final List<ConnectedProfile>? profiles;
  /// Optional callback - if null, changes are not propagated
  final Function(List<ConnectedProfile>)? onProfilesChanged;

  const ConnectedProfilesScreen({
    super.key,
    this.profiles,
    this.onProfilesChanged,
  });

  @override
  State<ConnectedProfilesScreen> createState() =>
      _ConnectedProfilesScreenState();
}

class _ConnectedProfilesScreenState extends State<ConnectedProfilesScreen> {
  final _service = ProfileLinkingService();
  List<ConnectedProfile> _profiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    if (widget.profiles != null) {
      setState(() {
        _profiles = List.from(widget.profiles!);
        _isLoading = false;
      });
    } else {
      // Load from service via API
      setState(() => _isLoading = true);
      try {
        final profiles = await _service.getConnectedProfiles();
        setState(() {
          _profiles = profiles;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load profiles: $e')),
          );
        }
      }
    }
  }

  void _notifyChanged() {
    widget.onProfilesChanged?.call(_profiles);
  }

  void _showLinkedInfo() {
    InfoModal.show(
      context,
      title: 'Linked Profile',
      body: 'You connected this profile by sharing the link.\n\n'
          'It appears on your SilentID Passport.\n\n'
          'Upgrade to Verified for stronger trust.',
      icon: Icons.link_rounded,
    );
  }

  void _showVerifiedInfo() {
    InfoModal.show(
      context,
      title: 'Verified Profile',
      body: 'SilentID confirmed you own this account.\n\n'
          'This boosts your TrustScore significantly.\n\n'
          'Verified profiles show a green checkmark on your passport.',
      icon: Icons.verified_rounded,
    );
  }

  Future<void> _upgradeToVerified(ConnectedProfile profile) async {
    final result = await Navigator.push<ConnectedProfile>(
      context,
      MaterialPageRoute(
        builder: (context) => UpgradeToVerifiedScreen(profile: profile),
      ),
    );

    if (result != null) {
      setState(() {
        final index = _profiles.indexWhere((p) => p.id == result.id);
        if (index != -1) {
          _profiles[index] = result;
        }
      });
      _notifyChanged();
    }
  }

  Future<void> _toggleVisibility(ConnectedProfile profile) async {
    HapticFeedback.selectionClick();
    final updated = await _service.togglePassportVisibility(profile);
    setState(() {
      final index = _profiles.indexWhere((p) => p.id == updated.id);
      if (index != -1) {
        _profiles[index] = updated;
      }
    });
    _notifyChanged();
  }

  Future<void> _removeProfile(ConnectedProfile profile) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Remove Profile?',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'This will disconnect your ${_service.getPlatformById(profile.platformId)?.displayName ?? 'profile'} from SilentID.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: AppTheme.neutralGray700),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Remove',
              style: GoogleFonts.inter(color: AppTheme.dangerRed),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _service.removeProfile(profile.id);
      setState(() {
        _profiles.removeWhere((p) => p.id == profile.id);
      });
      _notifyChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    final linkedProfiles = _profiles.where((p) => !p.isVerified).toList();
    final verifiedProfiles = _profiles.where((p) => p.isVerified).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Connected Profiles',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.neutralGray900),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _profiles.isEmpty
              ? _buildEmptyState()
              : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Summary
                _buildSummary(),
                const SizedBox(height: 24),

                // Verified Profiles
                if (verifiedProfiles.isNotEmpty) ...[
                  _buildSectionHeader(
                    'Verified',
                    Icons.verified_rounded,
                    AppTheme.successGreen,
                    verifiedProfiles.length,
                    _showVerifiedInfo,
                  ),
                  const SizedBox(height: 12),
                  ...verifiedProfiles.map((p) => _buildProfileCard(p)),
                  const SizedBox(height: 24),
                ],

                // Linked Profiles
                if (linkedProfiles.isNotEmpty) ...[
                  _buildSectionHeader(
                    'Linked',
                    Icons.link_rounded,
                    AppTheme.warningAmber,
                    linkedProfiles.length,
                    _showLinkedInfo,
                  ),
                  const SizedBox(height: 12),
                  ...linkedProfiles.map((p) => _buildProfileCard(p)),
                ],
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.neutralGray300.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.link_off_rounded,
                size: 48,
                color: AppTheme.neutralGray700,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No profiles connected',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first profile to start building trust.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    final verified = _profiles.where((p) => p.isVerified).length;
    final linked = _profiles.where((p) => !p.isVerified).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryPurple.withValues(alpha: 0.08),
            AppTheme.primaryPurple.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              'Total',
              '${_profiles.length}',
              Icons.account_circle_rounded,
              AppTheme.primaryPurple,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppTheme.neutralGray300,
          ),
          Expanded(
            child: _buildSummaryItem(
              'Verified',
              '$verified',
              Icons.verified_rounded,
              AppTheme.successGreen,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppTheme.neutralGray300,
          ),
          Expanded(
            child: _buildSummaryItem(
              'Linked',
              '$linked',
              Icons.link_rounded,
              AppTheme.warningAmber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.neutralGray900,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: AppTheme.neutralGray700,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    String title,
    IconData icon,
    Color color,
    int count,
    VoidCallback onInfoTap,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onInfoTap,
          child: Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: AppTheme.neutralGray700,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(ConnectedProfile profile) {
    final platform = _service.getPlatformById(profile.platformId);
    if (platform == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: profile.isVerified
              ? AppTheme.successGreen.withValues(alpha: 0.3)
              : AppTheme.neutralGray300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile info row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: platform.brandColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  platform.icon,
                  color: platform.brandColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          platform.displayName,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.neutralGray900,
                          ),
                        ),
                        if (profile.isVerified) ...[
                          const SizedBox(width: 6),
                          Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: AppTheme.successGreen,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '@${profile.username}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.neutralGray700,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: AppTheme.neutralGray700,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'visibility':
                      _toggleVisibility(profile);
                      break;
                    case 'remove':
                      _removeProfile(profile);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'visibility',
                    child: Row(
                      children: [
                        Icon(
                          profile.isPublicOnPassport
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          size: 18,
                          color: AppTheme.neutralGray700,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          profile.isPublicOnPassport
                              ? 'Hide from Passport'
                              : 'Show on Passport',
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'remove',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: AppTheme.dangerRed,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Remove',
                          style: TextStyle(color: AppTheme.dangerRed),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Status row
          const SizedBox(height: 12),
          Row(
            children: [
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: profile.isVerified
                      ? AppTheme.successGreen.withValues(alpha: 0.1)
                      : AppTheme.warningAmber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  profile.stateDisplayText,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: profile.isVerified
                        ? AppTheme.successGreen
                        : AppTheme.warningAmber,
                  ),
                ),
              ),

              // Visibility indicator
              if (!profile.isPublicOnPassport) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.neutralGray300.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.visibility_off_rounded,
                        size: 12,
                        color: AppTheme.neutralGray700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Hidden',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.neutralGray700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              // Upgrade button for linked profiles
              if (!profile.isVerified)
                TextButton(
                  onPressed: () => _upgradeToVerified(profile),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Upgrade to Verified',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
