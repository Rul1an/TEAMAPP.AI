// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../services/monitoring_service.dart';
import '../../widgets/common/main_scaffold.dart';
import 'performance_monitoring/system_health_overview_card.dart';
import 'performance_monitoring/real_time_metrics_card.dart';
import 'performance_monitoring/performance_charts_row.dart';
import 'performance_monitoring/error_tracking_card.dart';
import 'performance_monitoring/user_activity_metrics_card.dart';
import 'performance_monitoring/system_resources_card.dart';

/// Performance Monitoring Screen for real-time system health and metrics
class PerformanceMonitoringScreen extends ConsumerStatefulWidget {
  const PerformanceMonitoringScreen({super.key});

  @override
  ConsumerState<PerformanceMonitoringScreen> createState() =>
      _PerformanceMonitoringScreenState();
}

class _PerformanceMonitoringScreenState
    extends ConsumerState<PerformanceMonitoringScreen>
    with MonitoringMixin, TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Track screen access
    MonitoringService.trackEvent(
      name: 'performance_monitoring_accessed',
      parameters: {
        'screen': 'performance_monitoring',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MainScaffold(
    child: AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Opacity(
        opacity: _animation.value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - _animation.value)),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                const SystemHealthOverviewCard(),
                const SizedBox(height: 24),
                const RealTimeMetricsCard(),
                const SizedBox(height: 24),
                const PerformanceChartsRow(),
                const SizedBox(height: 24),
                const ErrorTrackingCard(),
                const SizedBox(height: 24),
                const UserActivityMetricsCard(),
                const SizedBox(height: 24),
                const SystemResourcesCard(),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _buildHeader() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.monitor_heart,
              size: 32,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Performance Monitoring',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              Text(
                'Real-time system health and performance metrics',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
          const Spacer(),
          _buildStatusIndicator(),
        ],
      ),
    ],
  );

  Widget _buildStatusIndicator() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.green.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'System Healthy',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );

  Widget _buildErrorTracking() => Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Error Tracking',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  MonitoringService.trackEvent(
                    name: 'error_details_viewed',
                    parameters: {'source': 'performance_monitoring'},
                  );
                },
                icon: const Icon(Icons.open_in_new),
                label: const Text('View Details'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildErrorItem(
            'Network Timeout',
            '2 occurrences',
            '5 minutes ago',
            Colors.orange,
            Icons.wifi_off,
          ),
          _buildErrorItem(
            'Authentication Failed',
            '1 occurrence',
            '15 minutes ago',
            Colors.red,
            Icons.lock_outline,
          ),
          _buildErrorItem(
            'Database Connection',
            '0 occurrences',
            '2 hours ago',
            Colors.green,
            Icons.storage,
          ),
        ],
      ),
    ),
  );

  Widget _buildErrorItem(
    String error,
    String count,
    String lastOccurrence,
    Color color,
    IconData icon,
  ) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withValues(alpha: 0.2)),
    ),
    child: Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                error,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                count,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Text(
          lastOccurrence,
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    ),
  );

  Widget _buildUserActivityMetrics() => Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Activity Metrics',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildActivityMetric(
                  'Page Views',
                  '12,345',
                  '+5.2%',
                  Icons.visibility,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildActivityMetric(
                  'Sessions',
                  '3,456',
                  '+12.8%',
                  Icons.access_time,
                  Colors.green,
                ),
              ),
              Expanded(
                child: _buildActivityMetric(
                  'Bounce Rate',
                  '23.4%',
                  '-2.1%',
                  Icons.exit_to_app,
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildActivityMetric(
                  'Avg. Duration',
                  '8m 32s',
                  '+1.5%',
                  Icons.timer,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _buildActivityMetric(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
  ) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 8),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.2)),
    ),
    child: Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 12),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
  );

  Widget _buildSystemResources() => Card(
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Resources',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildResourceUsage('CPU Usage', 0.65, Colors.blue),
          const SizedBox(height: 16),
          _buildResourceUsage('Memory Usage', 0.78, Colors.orange),
          const SizedBox(height: 16),
          _buildResourceUsage('Disk Usage', 0.45, Colors.green),
          const SizedBox(height: 16),
          _buildResourceUsage('Network I/O', 0.32, Colors.purple),
        ],
      ),
    ),
  );

  Widget _buildResourceUsage(String resource, double usage, Color color) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                resource,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(usage * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: usage,
              backgroundColor: Colors.grey.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      );
}
