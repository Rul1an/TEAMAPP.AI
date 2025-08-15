// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
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
import 'performance_monitoring/performance_telemetry_status_card.dart';

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
                    const PerformanceTelemetryStatusCard(),
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
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
