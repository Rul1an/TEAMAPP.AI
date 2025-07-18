// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../services/monitoring_service.dart';
import '../../widgets/common/main_scaffold.dart';

/// Advanced Analytics Screen for SaaS metrics and performance monitoring
class AdvancedAnalyticsScreen extends ConsumerStatefulWidget {
  const AdvancedAnalyticsScreen({super.key});

  @override
  ConsumerState<AdvancedAnalyticsScreen> createState() =>
      _AdvancedAnalyticsScreenState();
}

class _AdvancedAnalyticsScreenState
    extends ConsumerState<AdvancedAnalyticsScreen> with MonitoringMixin {
  @override
  void initState() {
    super.initState();
    // Track analytics screen access
    MonitoringService.trackEvent(
      name: 'analytics_screen_accessed',
      parameters: {
        'screen': 'advanced_analytics',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  Widget build(BuildContext context) => MainScaffold(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildMetricsOverview(),
              const SizedBox(height: 24),
              _buildPerformanceCharts(),
              const SizedBox(height: 24),
              _buildUserEngagementMetrics(),
              const SizedBox(height: 24),
              _buildAIUsageAnalytics(),
              const SizedBox(height: 24),
              _buildBusinessMetrics(),
            ],
          ),
        ),
      );

  Widget _buildHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined,
                  size: 32, color: Colors.blue,),
              const SizedBox(width: 12),
              const Text(
                'Advanced Analytics',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              _buildTimeRangeSelector(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Real-time insights and performance monitoring',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      );

  Widget _buildTimeRangeSelector() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<String>(
          value: 'Last 7 days',
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(
                value: 'Last 24 hours', child: Text('Last 24 hours'),),
            DropdownMenuItem(value: 'Last 7 days', child: Text('Last 7 days')),
            DropdownMenuItem(
                value: 'Last 30 days', child: Text('Last 30 days'),),
            DropdownMenuItem(
                value: 'Last 90 days', child: Text('Last 90 days'),),
          ],
          onChanged: (value) {
            // Track time range change
            MonitoringService.trackEvent(
              name: 'analytics_time_range_changed',
              parameters: {'time_range': value},
            );
          },
        ),
      );

  Widget _buildMetricsOverview() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Metrics Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            childAspectRatio: 1.5,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildMetricCard(
                title: 'Active Users',
                value: '1,247',
                change: '+12.5%',
                isPositive: true,
                icon: Icons.people_outline,
                color: Colors.blue,
              ),
              _buildMetricCard(
                title: 'AI Interactions',
                value: '3,891',
                change: '+28.7%',
                isPositive: true,
                icon: Icons.psychology_outlined,
                color: Colors.purple,
              ),
              _buildMetricCard(
                title: 'Training Sessions',
                value: '892',
                change: '+15.3%',
                isPositive: true,
                icon: Icons.sports_soccer_outlined,
                color: Colors.green,
              ),
              _buildMetricCard(
                title: 'Error Rate',
                value: '0.12%',
                change: '-0.05%',
                isPositive: true,
                icon: Icons.error_outline,
                color: Colors.red,
              ),
            ],
          ),
        ],
      );

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required IconData icon,
    required Color color,
  }) =>
      Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          (isPositive ? Colors.green : Colors.red).withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      change,
                      style: TextStyle(
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),),
            ],
          ),
        ),
      );

  Widget _buildPerformanceCharts() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Metrics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Response Time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    const FlSpot(0, 120),
                                    const FlSpot(1, 98),
                                    const FlSpot(2, 145),
                                    const FlSpot(3, 87),
                                    const FlSpot(4, 156),
                                    const FlSpot(5, 92),
                                    const FlSpot(6, 78),
                                  ],
                                  isCurved: true,
                                  color: Colors.blue,
                                  barWidth: 3,
                                  dotData: const FlDotData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Error Distribution',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: 70,
                                  title: '70%',
                                  color: Colors.green,
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  value: 20,
                                  title: '20%',
                                  color: Colors.orange,
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  value: 10,
                                  title: '10%',
                                  color: Colors.red,
                                  radius: 50,
                                ),
                              ],
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildUserEngagementMetrics() => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Engagement',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildEngagementMetric(
                      'Session Duration',
                      '8m 32s',
                      '+2.1%',
                      Icons.access_time,
                    ),
                  ),
                  Expanded(
                    child: _buildEngagementMetric(
                      'Pages per Session',
                      '4.7',
                      '+0.8%',
                      Icons.pageview,
                    ),
                  ),
                  Expanded(
                    child: _buildEngagementMetric(
                      'Bounce Rate',
                      '23.4%',
                      '-1.2%',
                      Icons.exit_to_app,
                    ),
                  ),
                  Expanded(
                    child: _buildEngagementMetric(
                      'Return Rate',
                      '67.8%',
                      '+3.4%',
                      Icons.refresh,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildEngagementMetric(
    String title,
    String value,
    String change,
    IconData icon,
  ) =>
      Column(
        children: [
          Icon(icon, size: 32, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            change,
            style: TextStyle(
              fontSize: 12,
              color: change.startsWith('+') ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget _buildAIUsageAnalytics() => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.psychology_outlined,
                    color: Colors.purple,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'AI Feature Usage',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      MonitoringService.trackEvent(
                        name: 'ai_analytics_details_viewed',
                        parameters: {'source': 'advanced_analytics'},
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('View Details'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _buildAIFeatureCard('Training Generator', '1,234', '+45%'),
                  _buildAIFeatureCard('Tactical Assistant', '892', '+32%'),
                  _buildAIFeatureCard('Voice Commands', '567', '+78%'),
                  _buildAIFeatureCard('Performance Analysis', '445', '+23%'),
                  _buildAIFeatureCard('Formation Optimizer', '334', '+56%'),
                  _buildAIFeatureCard('Player Insights', '223', '+67%'),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildAIFeatureCard(String feature, String usage, String growth) =>
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.purple.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.purple.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              feature,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              usage,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            Text(
              growth,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  Widget _buildBusinessMetrics() => Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Business Intelligence',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildBusinessMetricCard(
                      'Monthly Recurring Revenue',
                      '€12,450',
                      '+18.5%',
                      Icons.euro_symbol,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildBusinessMetricCard(
                      'Customer Acquisition Cost',
                      '€89',
                      '-12.3%',
                      Icons.person_add_outlined,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildBusinessMetricCard(
                      'Churn Rate',
                      '2.1%',
                      '-0.8%',
                      Icons.trending_down,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildBusinessMetricCard(
                      'Lifetime Value',
                      '€1,234',
                      '+25.7%',
                      Icons.account_balance_wallet_outlined,
                      Colors.purple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildBusinessMetricCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
  ) =>
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (change.startsWith('+') ? Colors.green : Colors.red)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    change,
                    style: TextStyle(
                      color: change.startsWith('+') ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(title,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),),
          ],
        ),
      );
}
