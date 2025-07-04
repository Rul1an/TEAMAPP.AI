// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../models/annual_planning/morphocycle.dart';
import '../../models/training_session/training_exercise.dart';
import '../../providers/annual_planning_provider.dart';
import '../../providers/exercise_designer_provider.dart';

// Modular widgets
import 'exercise_library/widgets/search_bar.dart';
import 'exercise_library/widgets/filter_bar.dart';
import 'exercise_library/widgets/morphocycle_banner.dart';
import 'exercise_library/widgets/exercise_tab_view.dart';

/// Modern, modular Exercise Library.
class ExerciseLibraryScreen extends ConsumerStatefulWidget {
  const ExerciseLibraryScreen({
    super.key,
    this.filterIntensity,
    this.filterTacticalFocus,
    this.weekNumber = 1,
    this.isSelectMode = false,
    this.onExerciseSelected,
  });

  final TrainingIntensity? filterIntensity;
  final TacticalFocus? filterTacticalFocus;
  final int weekNumber;
  final bool isSelectMode;
  final void Function(TrainingExercise)? onExerciseSelected;

  @override
  ConsumerState<ExerciseLibraryScreen> createState() =>
      _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends ConsumerState<ExerciseLibraryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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
    final morphocycle =
        ref.watch(annualPlanningProvider).getMorphocycleForWeek(widget.weekNumber);
    final exercisesAsync = ref.watch(exerciseLibraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('🏃‍♂️ Exercise Library (Week ${widget.weekNumber})'),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.recommend), text: 'Recommended'),
            Tab(icon: Icon(Icons.fitness_center), text: 'Intensity'),
            Tab(icon: Icon(Icons.sports_soccer), text: 'Focus'),
            Tab(icon: Icon(Icons.list), text: 'All'),
          ],
        ),
      ),
      body: exercisesAsync.when(
        data: (_) => Column(
          children: [
            if (morphocycle != null)
              MorphocycleBanner(
                morphocycle: morphocycle,
                weekNumber: widget.weekNumber,
              ),
            const ExerciseSearchBar(),
            const ExerciseFilterBar(),
            Expanded(
              child: ExerciseTabView(
                tabController: _tabController,
                morphocycle: morphocycle,
                isSelectMode: widget.isSelectMode,
                onExerciseSelected: widget.onExerciseSelected,
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
