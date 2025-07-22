import 'package:flutter/material.dart';

// Project imports:
import '../analytics/performance_analytics_screen.dart';
import '../player_tracking/svs_dashboard_screen.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Insights'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Analytics', icon: Icon(Icons.analytics)),
              Tab(text: 'SVS', icon: Icon(Icons.speed)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PerformanceAnalyticsScreen(),
            SVSDashboardScreen(),
          ],
        ),
      ),
    );
  }
}