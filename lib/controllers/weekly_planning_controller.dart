import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeeklyPlanningController with ChangeNotifier {
  /// Controller for horizontal week selector scrolling
  final ScrollController scrollController = ScrollController();

  /// Scrolls to the given week index (0-based)
  void scrollToWeek(int weekIndex) {
    final position = weekIndex * 64.0;
    scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  /// Clean up resources
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

/// Provider for [WeeklyPlanningController]
final weeklyPlanningControllerProvider =
    ChangeNotifierProvider<WeeklyPlanningController>(
        (ref) => WeeklyPlanningController());
