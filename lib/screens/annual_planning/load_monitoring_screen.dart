// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../providers/annual_planning_provider.dart';
import 'load_monitoring_view.dart';

class LoadMonitoringScreen extends ConsumerStatefulWidget {
  const LoadMonitoringScreen({super.key});

  @override
  ConsumerState<LoadMonitoringScreen> createState() =>
      _LoadMonitoringScreenState();
}

class _LoadMonitoringScreenState extends ConsumerState<LoadMonitoringScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedWeekRange = 12; // Default to 12 weeks view
  bool _showProjections = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planningState = ref.watch(annualPlanningProvider);

    return LoadMonitoringView(
      tabController: _tabController,
      selectedWeekRange: _selectedWeekRange,
      showProjections: _showProjections,
      onWeekRangeChanged: (value) => setState(() => _selectedWeekRange = value),
      onToggleProjections: () => setState(() => _showProjections = !_showProjections),
      planningState: planningState,
    );
  }


}
