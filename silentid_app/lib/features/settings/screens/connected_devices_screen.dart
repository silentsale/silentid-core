import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  State<ConnectedDevicesScreen> createState() => _ConnectedDevicesScreenState();
}

class _ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _devices = [];

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _devices = [
          {
            'id': '1',
            'model': 'iPhone 13 Pro',
            'os': 'iOS 17.2',
            'lastUsed': '2 hours ago',
            'location': 'London, UK',
            'isCurrent': true,
          },
          {
            'id': '2',
            'model': 'MacBook Pro',
            'os': 'macOS 14.1',
            'lastUsed': '1 day ago',
            'location': 'London, UK',
            'isCurrent': false,
          },
        ];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _revokeDevice(String deviceId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revoke Device Access'),
        content: const Text(
          'This device will be logged out and will need to sign in again. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.dangerRed),
            child: const Text('Revoke'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // TODO: API call to revoke device
      setState(() {
        _devices.removeWhere((device) => device['id'] == deviceId);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Device access revoked')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Connected Devices'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadDevices,
              child: ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: _devices.length + 1,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Text(
                      'Devices with access to your SilentID account',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.neutralGray700,
                      ),
                    );
                  }
                  return _buildDeviceCard(_devices[index - 1]);
                },
              ),
            ),
    );
  }

  Widget _buildDeviceCard(Map<String, dynamic> device) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: device['isCurrent']
              ? AppTheme.primaryPurple
              : AppTheme.neutralGray300,
          width: device['isCurrent'] ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                device['model'].contains('iPhone') ||
                        device['model'].contains('iPad')
                    ? Icons.phone_iphone
                    : Icons.computer,
                color: AppTheme.primaryPurple,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  device['model'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralGray900,
                  ),
                ),
              ),
              if (device['isCurrent'])
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'This Device',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryPurple,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.computer, device['os']),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.access_time, 'Last used: ${device['lastUsed']}'),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.location_on, device['location']),
          if (!device['isCurrent']) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => _revokeDevice(device['id']),
              icon: const Icon(Icons.block, size: 18),
              label: const Text('Revoke Access'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.dangerRed,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.neutralGray700),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.neutralGray700,
          ),
        ),
      ],
    );
  }
}
