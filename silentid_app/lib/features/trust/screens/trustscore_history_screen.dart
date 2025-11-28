import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/trustscore_api_service.dart';

class TrustScoreHistoryScreen extends StatefulWidget {
  const TrustScoreHistoryScreen({super.key});

  @override
  State<TrustScoreHistoryScreen> createState() =>
      _TrustScoreHistoryScreenState();
}

class _TrustScoreHistoryScreenState extends State<TrustScoreHistoryScreen> {
  final _trustScoreApi = TrustScoreApiService();

  bool _isLoading = true;
  List<Map<String, dynamic>>? _historyData;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  /// Get trust label from score
  String _getTrustLabel(int score) {
    if (score >= 801) return 'Very High Trust';
    if (score >= 601) return 'High Trust';
    if (score >= 401) return 'Moderate Trust';
    if (score >= 201) return 'Low Trust';
    return 'High Risk';
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);

    try {
      // Fetch history from API (6 months by default)
      final response = await _trustScoreApi.getTrustScoreHistory(months: 6);

      // Convert API response to UI format
      final historyList = <Map<String, dynamic>>[];
      int? previousScore;

      for (final snapshot in response.snapshots) {
        final change = previousScore != null
            ? snapshot.score - previousScore
            : null;

        historyList.add({
          'date': '${snapshot.date.year}-${snapshot.date.month.toString().padLeft(2, '0')}-${snapshot.date.day.toString().padLeft(2, '0')}',
          'score': snapshot.score,
          'label': _getTrustLabel(snapshot.score),
          'change': change,
        });

        previousScore = snapshot.score;
      }

      setState(() {
        _historyData = historyList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load history: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('TrustScore History'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadHistory,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chart Section
                    const Text(
                      'Score Trend',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.neutralGray900,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildChart(),
                    const SizedBox(height: 40),

                    // History List
                    const Text(
                      'History',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.neutralGray900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._historyData!.map((snapshot) => _buildHistoryItem(snapshot)),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildChart() {
    if (_historyData == null || _historyData!.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: AppTheme.softLilac.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'No history available yet',
            style: TextStyle(
              color: AppTheme.neutralGray700,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final spots = _historyData!
        .asMap()
        .entries
        .map((entry) => FlSpot(
              entry.key.toDouble(),
              (entry.value['score'] as int).toDouble(),
            ))
        .toList();

    final minScore = _historyData!
        .map((e) => e['score'] as int)
        .reduce((a, b) => a < b ? a : b)
        .toDouble();
    final maxScore = _historyData!
        .map((e) => e['score'] as int)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.neutralGray300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 50,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppTheme.neutralGray300.withValues(alpha: 0.5),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
                interval: 50,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(
                      color: AppTheme.neutralGray700,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= _historyData!.length) {
                    return const SizedBox.shrink();
                  }
                  final date = _historyData![index]['date'] as String;
                  final parts = date.split('-');
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${parts[1]}/${parts[2]}',
                      style: const TextStyle(
                        color: AppTheme.neutralGray700,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: AppTheme.neutralGray300,
              width: 1,
            ),
          ),
          minX: 0,
          maxX: (_historyData!.length - 1).toDouble(),
          minY: (minScore - 50).floorToDouble(),
          maxY: (maxScore + 50).ceilToDouble(),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryPurple.withValues(alpha: 0.8),
                  AppTheme.primaryPurple,
                ],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppTheme.primaryPurple,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryPurple.withValues(alpha: 0.2),
                    AppTheme.primaryPurple.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.toInt();
                  final snapshot = _historyData![index];
                  return LineTooltipItem(
                    '${snapshot['score']}\n${snapshot['label']}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> snapshot) {
    final date = snapshot['date'] as String;
    final score = snapshot['score'] as int;
    final label = snapshot['label'] as String;
    final change = snapshot['change'] as int?;

    final dateParts = date.split('-');
    final formattedDate =
        '${_getMonthName(int.parse(dateParts[1]))} ${dateParts[2]}, ${dateParts[0]}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.neutralGray900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
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
                score.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryPurple,
                ),
              ),
              if (change != null) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      change > 0
                          ? Icons.arrow_upward
                          : change < 0
                              ? Icons.arrow_downward
                              : Icons.remove,
                      size: 14,
                      color: change > 0
                          ? AppTheme.successGreen
                          : change < 0
                              ? AppTheme.dangerRed
                              : AppTheme.neutralGray700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      change > 0 ? '+$change' : '$change',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: change > 0
                            ? AppTheme.successGreen
                            : change < 0
                                ? AppTheme.dangerRed
                                : AppTheme.neutralGray700,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
