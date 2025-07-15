// ignore_for_file: unused_element
// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../../models/annual_planning/morphocycle.dart';
import '../../models/training_session/training_exercise.dart';
import '../../providers/annual_planning_provider.dart';
import '../../providers/exercise_designer_provider.dart';

// Extracted widgets
import 'exercise_library/widgets/search_bar.dart';
import 'exercise_library/widgets/filter_bar.dart';
import 'exercise_library/widgets/morphocycle_banner.dart';
import 'exercise_library/widgets/exercise_tab_view.dart';

class EnhancedExerciseLibraryScreen extends ConsumerStatefulWidget {
  const EnhancedExerciseLibraryScreen({
    super.key,
    this.filterIntensity,
    this.weekNumber = 1,
  });
  final TrainingIntensity? filterIntensity;
  final int weekNumber;

  @override
  ConsumerState<EnhancedExerciseLibraryScreen> createState() =>
      _EnhancedExerciseLibraryScreenState();
}

class _EnhancedExerciseLibraryScreenState
    extends ConsumerState<EnhancedExerciseLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  bool _showMorphocycleRecommendations = true;
  int _minDuration = 0;
  int _maxDuration = 120;
  int _playerCount = 18;

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
    final exercisesAsync = ref.watch(exerciseLibraryProvider);
    final planningState = ref.watch(annualPlanningProvider);
    final currentMorphocycle = planningState.getMorphocycleForWeek(
      widget.weekNumber,
    );

    return Scaffold(
      appBar: AppBar(
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
      ),
      body: exercisesAsync.when(
        data: (exercises) => Column(
          children: [
            if (currentMorphocycle != null)
              MorphocycleBanner(
                morphocycle: currentMorphocycle,
                weekNumber: widget.weekNumber,
              ),
            const ExerciseSearchBar(),
            const ExerciseFilterBar(),
            Expanded(
              child: ExerciseTabView(
                tabController: _tabController,
                morphocycle: currentMorphocycle,
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
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
        ),
      ),
    );
  }

  Widget _buildMorphocycleInfo(Morphocycle morphocycle) {
    if (!_showMorphocycleRecommendations) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E88E5), // Colors.blue.shade600
            Color(0xFF42A5F5), // Colors.blue.shade400
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.science, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Week ${widget.weekNumber} Morphocycle',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: () =>
                    setState(() => _showMorphocycleRecommendations = false),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Primary Focus: ${morphocycle.primaryGameModelFocus}',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            'Secondary Focus: ${morphocycle.secondaryGameModelFocus}',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search exercises...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _searchQuery = ''),
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
      );

  Widget _buildRecommendedTab(
    List<TrainingExercise> exercises,
    Morphocycle? morphocycle,
  ) {
    if (morphocycle == null) {
      return const Center(child: Text('No morphocycle data available'));
    }

    // Group exercises by intensity for morphocycle recommendations
    final recoveryExercises =
        exercises.where((e) => e.intensityLevel <= 3.0).toList();
    final acquisitionExercises =
        exercises.where((e) => e.intensityLevel >= 8.0).toList();
    final developmentExercises = exercises
        .where((e) => e.intensityLevel >= 5.0 && e.intensityLevel <= 7.0)
        .toList();
    final activationExercises = exercises
        .where((e) => e.intensityLevel >= 4.0 && e.intensityLevel <= 6.0)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Morphocycle-Based Recommendations',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildRecommendationSection(
            'Recovery Day (Day +1)',
            'Low intensity, technical skills',
            _applyFilters(recoveryExercises),
            Colors.green,
            Icons.nature,
          ),
          _buildRecommendationSection(
            'Acquisition Day (Day +2)',
            'High intensity tactical work',
            _applyFilters(acquisitionExercises),
            Colors.red,
            Icons.bolt,
          ),
          _buildRecommendationSection(
            'Development Day (Day +3)',
            'Medium intensity development',
            _applyFilters(developmentExercises),
            Colors.orange,
            Icons.trending_up,
          ),
          _buildRecommendationSection(
            'Activation Day (Day +4)',
            'Match preparation',
            _applyFilters(activationExercises),
            Colors.blue,
            Icons.play_arrow,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationSection(
    String title,
    String description,
    List<TrainingExercise> exercises,
    Color color,
    IconData icon,
  ) =>
      Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${exercises.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (exercises.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: const Center(
                  child: Text(
                    'No matching exercises found.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: exercises.length > 6 ? 6 : exercises.length,
                  itemBuilder: (context, index) => Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 12),
                    child: _buildExerciseCard(exercises[index]),
                  ),
                ),
              ),
            if (exercises.length > 6)
              TextButton(
                onPressed: () => _tabController.animateTo(3),
                child: Text('View all ${exercises.length} exercises'),
              ),
          ],
        ),
      );

  Widget _buildIntensityTab(List<TrainingExercise> exercises) {
    final intensityGroups = {
      'Recovery (1-3)':
          exercises.where((e) => e.intensityLevel <= 3.0).toList(),
      'Activation (4-6)': exercises
          .where((e) => e.intensityLevel >= 4.0 && e.intensityLevel <= 6.0)
          .toList(),
      'Development (5-7)': exercises
          .where((e) => e.intensityLevel >= 5.0 && e.intensityLevel <= 7.0)
          .toList(),
      'Acquisition (8-10)':
          exercises.where((e) => e.intensityLevel >= 8.0).toList(),
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: intensityGroups.entries
          .map(
            (entry) =>
                _buildIntensitySection(entry.key, _applyFilters(entry.value)),
          )
          .toList(),
    );
  }

  Widget _buildIntensitySection(
    String intensityName,
    List<TrainingExercise> exercises,
  ) {
    final color = _getIntensityColorFromName(intensityName);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  intensityName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${exercises.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (exercises.isEmpty)
            const Text('No exercises found')
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: exercises.length > 4 ? 4 : exercises.length,
              itemBuilder: (context, index) =>
                  _buildExerciseCard(exercises[index]),
            ),
          if (exercises.length > 4)
            TextButton(
              onPressed: () => _tabController.animateTo(3),
              child: Text('View all ${exercises.length} exercises'),
            ),
        ],
      ),
    );
  }

  Widget _buildFocusTab(List<TrainingExercise> exercises) {
    final focusGroups = {
      'Technical':
          exercises.where((e) => e.type == ExerciseType.technical).toList(),
      'Tactical':
          exercises.where((e) => e.type == ExerciseType.tactical).toList(),
      'Physical':
          exercises.where((e) => e.type == ExerciseType.physical).toList(),
      'Small Sided Games': exercises
          .where((e) => e.type == ExerciseType.smallSidedGames)
          .toList(),
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: focusGroups.entries
          .map(
            (entry) =>
                _buildFocusSection(entry.key, _applyFilters(entry.value)),
          )
          .toList(),
    );
  }

  Widget _buildFocusSection(
    String focusName,
    List<TrainingExercise> exercises,
  ) {
    final color = _getFocusColorFromName(focusName);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  focusName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${exercises.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (exercises.isEmpty)
            const Text('No exercises found')
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: exercises.length > 4 ? 4 : exercises.length,
              itemBuilder: (context, index) =>
                  _buildExerciseCard(exercises[index]),
            ),
          if (exercises.length > 4)
            TextButton(
              onPressed: () => _tabController.animateTo(3),
              child: Text('View all ${exercises.length} exercises'),
            ),
        ],
      ),
    );
  }

  Widget _buildAllExercisesTab(List<TrainingExercise> exercises) {
    final filteredExercises = _applyFilters(exercises);

    if (filteredExercises.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No exercises found'),
            Text('Try adjusting your filters'),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[100],
          child: Row(
            children: [
              Text(
                '${filteredExercises.length} exercises found',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                'Total duration: ${_calculateTotalDuration(filteredExercises)} min',
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: filteredExercises.length,
            itemBuilder: (context, index) =>
                _buildExerciseCard(filteredExercises[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(TrainingExercise exercise) => Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => _showExerciseDetails(exercise),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getIntensityColorFromLevel(
                            exercise.intensityLevel),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${exercise.intensityLevel.toInt()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(exercise.type),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        exercise.type.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${exercise.durationMinutes}m',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  exercise.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  exercise.description.isEmpty
                      ? 'No description'
                      : exercise.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${exercise.playerCount} players',
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    const Row(
                      children: [
                        Icon(Icons.star, size: 12, color: Colors.amber),
                        Text(
                          '4.2',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  List<TrainingExercise> _applyFilters(List<TrainingExercise> exercises) =>
      exercises.where((exercise) {
        if (_searchQuery.isNotEmpty) {
          final searchLower = _searchQuery.toLowerCase();
          if (!exercise.name.toLowerCase().contains(searchLower) &&
              !exercise.description.toLowerCase().contains(searchLower)) {
            return false;
          }
        }

        if (exercise.durationMinutes < _minDuration ||
            exercise.durationMinutes > _maxDuration) {
          return false;
        }

        if (exercise.playerCount > _playerCount) {
          return false;
        }

        return true;
      }).toList();

  int _calculateTotalDuration(List<TrainingExercise> exercises) => exercises
      .fold(0, (sum, exercise) => sum + exercise.durationMinutes.round());

  void _showFilterDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Exercises'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Player Count: $_playerCount'),
              Slider(
                value: _playerCount.toDouble(),
                min: 6,
                max: 22,
                divisions: 16,
                onChanged: (value) =>
                    setDialogState(() => _playerCount = value.round()),
              ),
              const SizedBox(height: 16),
              Text('Duration: $_minDuration - $_maxDuration minutes'),
              RangeSlider(
                values: RangeValues(
                  _minDuration.toDouble(),
                  _maxDuration.toDouble(),
                ),
                min: 5,
                max: 120,
                divisions: 23,
                onChanged: (values) => setDialogState(() {
                  _minDuration = values.start.round();
                  _maxDuration = values.end.round();
                }),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _minDuration = 0;
                _maxDuration = 120;
                _playerCount = 18;
              });
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showExerciseDetails(TrainingExercise exercise) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(exercise.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                exercise.description.isEmpty
                    ? 'No description available'
                    : exercise.description,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                'Duration',
                '${exercise.durationMinutes} minutes',
              ),
              _buildDetailRow('Players', '${exercise.playerCount}'),
              _buildDetailRow('Intensity', '${exercise.intensityLevel}/10'),
              _buildDetailRow('Type', exercise.type.name),
              if (exercise.equipment.isNotEmpty)
                _buildDetailRow('Equipment', exercise.equipment),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${exercise.name} added to session (demo)'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Add to Session'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                '$label:',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );

  Color _getIntensityColorFromLevel(double level) {
    if (level <= 3.0) return Colors.green;
    if (level <= 6.0) return Colors.blue;
    if (level <= 7.0) return Colors.orange;
    return Colors.red;
  }

  Color _getIntensityColorFromName(String name) {
    if (name.contains('Recovery')) return Colors.green;
    if (name.contains('Activation')) return Colors.blue;
    if (name.contains('Development')) return Colors.orange;
    return Colors.red;
  }

  Color _getFocusColorFromName(String name) {
    switch (name.toLowerCase()) {
      case 'technical':
        return Colors.blue;
      case 'tactical':
        return Colors.red;
      case 'physical':
        return Colors.orange;
      case 'small sided games':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getTypeColor(ExerciseType type) {
    switch (type) {
      case ExerciseType.technical:
        return Colors.blue;
      case ExerciseType.tactical:
        return Colors.red;
      case ExerciseType.physical:
        return Colors.orange;
      case ExerciseType.smallSidedGames:
        return Colors.green;
      case ExerciseType.warmUp:
        return Colors.cyan;
      case ExerciseType.coolDown:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
