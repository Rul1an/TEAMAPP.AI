import 'package:flutter/material.dart';

/// Card showing uptime, response time etc. Extracted from PerformanceMonitoringScreen
class SystemHealthOverviewCard extends StatelessWidget {
  const SystemHealthOverviewCard({super.key});

  @override
  Widget build(BuildContext context) => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'System Health Overview',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                childAspectRatio: 1.2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: const [
                  _HealthMetric(
                    title: 'Uptime',
                    value: '99.98%',
                    icon: Icons.trending_up,
                    color: Colors.green,
                    period: '30 days',
                  ),
                  _HealthMetric(
                    title: 'Response Time',
                    value: '142ms',
                    icon: Icons.speed,
                    color: Colors.blue,
                    period: 'avg last hour',
                  ),
                  _HealthMetric(
                    title: 'Error Rate',
                    value: '0.02%',
                    icon: Icons.error_outline,
                    color: Colors.orange,
                    period: 'last 24h',
                  ),
                  _HealthMetric(
                    title: 'Active Users',
                    value: '1,247',
                    icon: Icons.people,
                    color: Colors.purple,
                    period: 'current',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

class _HealthMetric extends StatelessWidget {
  const _HealthMetric({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.period,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String period;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              period,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      );
}