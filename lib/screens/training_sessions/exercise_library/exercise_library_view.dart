// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../../models/annual_planning/morphocycle.dart';
import '../../../models/training_session/training_exercise.dart';
import '../../../providers/annual_planning_provider.dart';
import '../../../providers/exercise_designer_provider.dart';
import 'exercise_library_controller.dart';
import 'widgets/morphocycle_banner.dart';
import 'widgets/search_bar.dart';
import 'widgets/filter_bar.dart';
import 'widgets/recommended_exercises_tab.dart';
import 'widgets/intensity_exercises_tab.dart';
import 'widgets/focus_exercises_tab.dart';
import 'widgets/all_exercises_tab.dart';
import 'widgets/exercise_filter_dialog.dart';

/// Main view widget for the exercise library
class ExerciseLibraryView extends ConsumerStatefulWidget {
  const ExerciseLibraryView({
    super.key,
    this.filterIntensity,
    this.weekNumber = 1,
  });

  final TrainingIntensity? filterIntensity;
  final int weekNumber;

  @override
  ConsumerState<ExerciseLibraryView> createState() =>
      _ExerciseLibraryViewState();
}

class _ExerciseLibraryViewState extends ConsumerState<ExerciseLibraryView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      ref
          .read(exerciseLibraryControllerProvider.notifier)
          .updateSelectedTab(_tabController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(exerciseLibraryProvider);
    final planningState = ref.watch(annualPlanningProvider);
    final controllerState = ref.watch(exerciseLibraryControllerProvider);

    final currentMorphocycle = planningState.getMorphocycleForWeek(
      widget.weekNumber,
    );

    return Scaffold(
      appBar: _buildAppBar(context),
      body: exercisesAsync.when(
        data: (exercises) => _buildContent(
          context,
          exercises,
          currentMorphocycle,
          controllerState,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, error),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        '🏃‍♂️ Exercise Library ${widget.weekNumber > 1 ? "(Week ${widget.weekNumber})" : ""}',
      ),
      backgroundColor: Colors.orange[600],
      foregroundColor: Colors.white,
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: const [
          Tab(icon: Icon(Icons.recommend), text: 'Recommended'),
          Tab(icon: Icon(Icons.fitness_center), text: 'By Intensity'),
          Tab(icon: Icon(Icons.sports_soccer), text: 'By Focus'),
          Tab(icon: Icon(Icons.list), text: 'All'),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: _showFilterDialog,
          tooltip: 'Filter',
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<TrainingExercise> exercises,
    Morphocycle? currentMorphocycle,
    ExerciseLibraryState controllerState,
  ) {
    return Column(
      children: [
        if (currentMorphocycle != null &&
            controllerState.showMorphocycleRecommendations)
          MorphocycleBanner(
            morphocycle: currentMorphocycle,
            weekNumber: widget.weekNumber,
          ),
        const ExerciseSearchBar(),
        const ExerciseFilterBar(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              RecommendedExercisesTab(
                exercises: exercises,
                morphocycle: currentMorphocycle,
                onViewAllTap: () => _tabController.animateTo(3),
              ),
              IntensityExercisesTab(
                exercises: exercises,
                onViewAllTap: () => _tabController.animateTo(3),
              ),
              FocusExercisesTab(
                exercises: exercises,
                onViewAllTap: () => _tabController.animateTo(3),
              ),
              AllExercisesTab(exercises: exercises),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error: $error'),
          ElevatedButton(
            onPressed: () => ref.refresh(exerciseLibraryProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => const ExerciseFilterDialog(),
    );
  }
}
