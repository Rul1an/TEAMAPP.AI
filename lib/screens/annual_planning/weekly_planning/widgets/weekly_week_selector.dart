// lib/screens/annual_planning/weekly_planning/widgets/weekly_week_selector.dart
// ignore_for_file: unused_import
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../providers/annual_planning_provider.dart';
import '../../weekly_planning/widgets/week_selector.dart';

/// Wrapper for [WeekSelector] to fit naming conventions
class WeeklyWeekSelector extends WeekSelector {
  const WeeklyWeekSelector({
    required AnnualPlanningState state,
    required ScrollController scrollController,
    Key? key,
  }) : super(state: state, scrollController: scrollController, key: key);
}
