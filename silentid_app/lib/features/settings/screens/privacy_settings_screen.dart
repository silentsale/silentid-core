import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _isLoading = true;
  bool _showTransactionCount = true;
  bool _showPlatformList = true;
  bool _showAccountAge = true;
  bool _showMutualVerifications = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Load from API
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSetting(String key, bool value) async {
    // TODO: Save to API
    // await ApiService().patch('/users/me/privacy', {key: value});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Text(
                  'Public Profile Visibility',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.neutralGray900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Control what information is visible on your public SilentID profile',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.neutralGray700,
                  ),
                ),
                const SizedBox(height: 24),

                _buildToggle(
                  'Show transaction count',
                  'Display total number of verified transactions',
                  _showTransactionCount,
                  (value) {
                    setState(() => _showTransactionCount = value);
                    _saveSetting('showTransactionCount', value);
                  },
                ),
                const SizedBox(height: 16),

                _buildToggle(
                  'Show platform list',
                  'Display platforms you\'re verified on (Vinted, eBay, etc.)',
                  _showPlatformList,
                  (value) {
                    setState(() => _showPlatformList = value);
                    _saveSetting('showPlatformList', value);
                  },
                ),
                const SizedBox(height: 16),

                _buildToggle(
                  'Show account age',
                  'Display how long you\'ve had your SilentID account',
                  _showAccountAge,
                  (value) {
                    setState(() => _showAccountAge = value);
                    _saveSetting('showAccountAge', value);
                  },
                ),
                const SizedBox(height: 16),

                _buildToggle(
                  'Show mutual verification count',
                  'Display number of mutual verifications with other users',
                  _showMutualVerifications,
                  (value) {
                    setState(() => _showMutualVerifications = value);
                    _saveSetting('showMutualVerifications', value);
                  },
                ),

                const SizedBox(height: 32),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.softLilac.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 20,
                        color: AppTheme.primaryPurple,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your TrustScore and identity verification status are always visible. Your full name, email, phone, and address are never shown publicly.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.neutralGray700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildToggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralGray900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.neutralGray700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryPurple,
          ),
        ],
      ),
    );
  }
}
