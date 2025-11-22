import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../widgets/share_profile_sheet.dart';

class MyPublicProfileScreen extends StatefulWidget {
  const MyPublicProfileScreen({super.key});

  @override
  State<MyPublicProfileScreen> createState() => _MyPublicProfileScreenState();
}

class _MyPublicProfileScreenState extends State<MyPublicProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Replace with actual API call
      // final response = await ApiService().get('/users/me');

      // Mock data for now
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _profileData = {
          'displayName': 'Sarah M.',
          'username': 'sarahtrusted',
          'trustScore': 754,
          'trustLevel': 'High Trust',
          'badges': [
            {
              'icon': Icons.verified_user,
              'label': 'Identity Verified',
              'color': AppTheme.successGreen
            },
            {
              'icon': Icons.receipt,
              'label': '500+ Verified Transactions',
              'color': AppTheme.primaryPurple
            },
            {
              'icon': Icons.star,
              'label': 'Excellent Behaviour',
              'color': AppTheme.warningAmber
            },
            {
              'icon': Icons.handshake,
              'label': 'Peer-Verified User',
              'color': AppTheme.primaryPurple
            },
          ],
          'metrics': {
            'transactionCount': 127,
            'platforms': ['Vinted', 'eBay', 'Depop'],
            'accountAgeMonths': 24,
            'mutualVerifications': 12,
          },
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: $e')),
        );
      }
    }
  }

  void _showShareSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ShareProfileSheet(
        username: _profileData!['username'],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Public Profile'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Info Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.softLilac.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryPurple.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppTheme.primaryPurple,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This is how others see your profile',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.neutralGray900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Profile Header
                    _buildProfileHeader(),
                    const SizedBox(height: 32),

                    // TrustScore Display
                    _buildTrustScoreSection(),
                    const SizedBox(height: 32),

                    // Badges Section
                    _buildBadgesSection(),
                    const SizedBox(height: 32),

                    // Public Metrics
                    _buildPublicMetrics(),
                    const SizedBox(height: 32),

                    // Privacy Notice
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.neutralGray300.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            color: AppTheme.neutralGray700,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your full name, email, and address are never shown publicly',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.neutralGray700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Share Button
                    PrimaryButton(
                      text: 'Share Profile',
                      onPressed: _showShareSheet,
                      icon: Icons.share,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // Avatar Placeholder
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryPurple,
                AppTheme.primaryPurple.withOpacity(0.7),
              ],
            ),
          ),
          child: Center(
            child: Text(
              _profileData!['displayName'][0].toUpperCase(),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Text(
          _profileData!['displayName'],
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.neutralGray900,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          '@${_profileData!['username']}',
          style: const TextStyle(
            fontSize: 16,
            color: AppTheme.primaryPurple,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTrustScoreSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryPurple,
            AppTheme.primaryPurple.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'TrustScore',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_profileData!['trustScore']}',
            style: const TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _profileData!['trustLevel'],
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection() {
    final badges = _profileData!['badges'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Badges',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: badges.map((badge) => _buildBadge(badge)).toList(),
        ),
      ],
    );
  }

  Widget _buildBadge(Map<String, dynamic> badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: (badge['color'] as Color).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (badge['color'] as Color).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badge['icon'] as IconData,
            size: 16,
            color: badge['color'] as Color,
          ),
          const SizedBox(width: 6),
          Text(
            badge['label'],
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.neutralGray900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicMetrics() {
    final metrics = _profileData!['metrics'] as Map<String, dynamic>;
    final platforms = metrics['platforms'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Public Metrics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.neutralGray300),
          ),
          child: Column(
            children: [
              _buildMetricRow(
                'Transaction Count',
                metrics['transactionCount'].toString(),
              ),
              const Divider(height: 24),
              _buildMetricRow(
                'Platforms Verified',
                platforms.join(', '),
              ),
              const Divider(height: 24),
              _buildMetricRow(
                'Account Age',
                '${metrics['accountAgeMonths']} months',
              ),
              const Divider(height: 24),
              _buildMetricRow(
                'Mutual Verifications',
                metrics['mutualVerifications'].toString(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: AppTheme.neutralGray700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.neutralGray900,
          ),
        ),
      ],
    );
  }
}
