import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../core/widgets/info_point_helper.dart';
import '../../../core/data/info_point_data.dart';
import '../../../models/mutual_verification.dart';
import '../../../services/api_service.dart';
import '../../../services/mutual_verification_service.dart';

class MutualVerificationHomeScreen extends StatefulWidget {
  const MutualVerificationHomeScreen({super.key});

  @override
  State<MutualVerificationHomeScreen> createState() =>
      _MutualVerificationHomeScreenState();
}

class _MutualVerificationHomeScreenState
    extends State<MutualVerificationHomeScreen> {
  final _mutualVerificationService =
      MutualVerificationService(ApiService());

  List<MutualVerification> _verifications = [];
  bool _isLoading = true;
  String? _error;
  String _filter = 'All'; // All, Confirmed, Pending

  @override
  void initState() {
    super.initState();
    _loadVerifications();
  }

  Future<void> _loadVerifications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final verifications = await _mutualVerificationService.getAll();
      if (mounted) {
        setState(() {
          _verifications = verifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  List<MutualVerification> get _filteredVerifications {
    if (_filter == 'All') return _verifications;
    if (_filter == 'Confirmed') {
      return _verifications.where((v) => v.isConfirmed).toList();
    }
    if (_filter == 'Pending') {
      return _verifications.where((v) => v.isPending).toList();
    }
    return _verifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Mutual Verifications',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            InfoPointHelper(data: InfoPoints.peerVerificationComponent),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.primaryPurple),
            onPressed: () {
              Navigator.pushNamed(context, '/mutual-verification/create')
                  .then((_) => _loadVerifications());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip('All'),
                const SizedBox(width: 8),
                _buildFilterChip('Confirmed'),
                const SizedBox(width: 8),
                _buildFilterChip('Pending'),
              ],
            ),
          ),

          // List
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadVerifications,
              color: AppTheme.primaryPurple,
              child: _buildBody(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/mutual-verification/create')
              .then((_) => _loadVerifications());
        },
        backgroundColor: AppTheme.primaryPurple,
        label: const Text('New Verification'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _filter == label;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filter = label;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: AppTheme.softLilac,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryPurple : AppTheme.neutralGray700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppTheme.primaryPurple : AppTheme.neutralGray300,
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => const EvidenceCardSkeleton(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.dangerRed,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load verifications',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loadVerifications,
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    final filtered = _filteredVerifications;

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_user_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _filter == 'All'
                  ? 'No verifications yet'
                  : 'No ${_filter.toLowerCase()} verifications',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Verify transactions to build trust',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.neutralGray700,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: () {
                Navigator.pushNamed(context, '/mutual-verification/create')
                    .then((_) => _loadVerifications());
              },
              text: 'Create Verification',
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final verification = filtered[index];
        return _buildVerificationCard(verification);
      },
    );
  }

  Widget _buildVerificationCard(MutualVerification verification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/mutual-verification/details',
            arguments: verification.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: verification.isConfirmed
                          ? AppTheme.successGreen.withValues(alpha: 0.1)
                          : AppTheme.warningAmber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      verification.isConfirmed
                          ? Icons.check_circle
                          : Icons.pending,
                      color: verification.isConfirmed
                          ? AppTheme.successGreen
                          : AppTheme.warningAmber,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          verification.item,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          verification.otherUserName!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.neutralGray700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '£${verification.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: verification.isConfirmed
                              ? AppTheme.successGreen.withValues(alpha: 0.1)
                              : AppTheme.warningAmber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          verification.statusLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: verification.isConfirmed
                                ? AppTheme.successGreen
                                : AppTheme.warningAmber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${verification.date.day}/${verification.date.month}/${verification.date.year}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.neutralGray700,
                    ),
                  ),
                  Text(
                    'Your role: ${verification.roleA}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.neutralGray700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
