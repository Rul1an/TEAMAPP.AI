// lib/screens/annual_planning/weekly_planning_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/weekly_planning_controller.dart';
import '../../../../providers/annual_planning_provider.dart';
import 'weekly_planning/widgets/season_header.dart';
import 'weekly_planning/widgets/weekly_week_selector.dart';
import 'weekly_planning/widgets/weekly_table.dart';
import 'periodization_template_dialog.dart';

/// Screen displaying the weekly planning using controller and sub-widgets
class WeeklyPlanningScreen extends ConsumerWidget {
  const WeeklyPlanningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(weeklyPlanningControllerProvider);
    final state = ref.watch(annualPlanningProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Planning'),
      ),
      body: Column(
        children: [
          SeasonHeader(state: state),
          WeeklyWeekSelector(
            state: state,
            scrollController: controller.scrollController,
          ),
          Expanded(
            child: WeeklyTable(state: state),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const PeriodizationTemplateDialog(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
