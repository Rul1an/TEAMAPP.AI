import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/training_session/training_exercise.dart';
import '../../models/annual_planning/morphocycle.dart';
import '../../providers/exercise_designer_provider.dart';
import '../../providers/annual_planning_provider.dart';
import './exercise_designer_screen.dart';
import './field_diagram_editor_screen.dart';

// exerciseLibraryProvider is now defined in providers/exercise_designer_provider.dart

final exerciseSearchProvider = StateProvider<String>((ref) => '');
final exerciseTypeFilterProvider = StateProvider<ExerciseType?>((ref) => null);

class ExerciseLibraryScreen extends ConsumerStatefulWidget {
  final TrainingIntensity? filterIntensity;
  final TacticalFocus? filterTacticalFocus;
  final int weekNumber;
  final bool isSelectMode;
  final Function(TrainingExercise)? onExerciseSelected;

  const ExerciseLibraryScreen({
    super.key,
    this.filterIntensity,
    this.filterTacticalFocus,
    this.weekNumber = 1,
    this.isSelectMode = false,
    this.onExerciseSelected,
  });

  @override
  ConsumerState<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends ConsumerState<ExerciseLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  ExerciseCategory? _selectedCategory;
  ExerciseComplexity? _selectedComplexity;
  TrainingIntensity? _selectedIntensity;
  TacticalFocus? _selectedTacticalFocus;
  bool _showMorphocycleRecommendations = true;
  int _minDuration = 0;
  int _maxDuration = 120;
  int _playerCount = 18; // Default JO17 team size

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _selectedIntensity = widget.filterIntensity;
    _selectedTacticalFocus = widget.filterTacticalFocus;
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
    final currentMorphocycle = planningState.getMorphocycleForWeek(widget.weekNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text('🏃‍♂️ Exercise Library ${widget.weekNumber > 1 ? "(Week ${widget.weekNumber})" : ""}'),
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
            Tab(icon: Icon(Icons.list), text: 'All Exercises'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Exercises',
          ),
        ],
      ),
      body: exercisesAsync.when(
        data: (exercises) => Column(
          children: [
            _buildMorphocycleInfo(currentMorphocycle),
            _buildSearchBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRecommendedTab(exercises, currentMorphocycle),
                  _buildIntensityTab(exercises),
                  _buildTacticalFocusTab(exercises),
                  _buildAllExercisesTab(exercises),
                ],
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
              Text('Error loading exercises: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(exerciseLibraryProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ExerciseDesignerScreen(),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Create Exercise'),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildMorphocycleInfo(Morphocycle? morphocycle) {
    if (morphocycle == null || !_showMorphocycleRecommendations) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[400]!],
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
                onPressed: () => setState(() => _showMorphocycleRecommendations = false),
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
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMorphocycleIntensityChip('Recovery', TrainingIntensity.recovery, morphocycle),
              const SizedBox(width: 8),
              _buildMorphocycleIntensityChip('Acquisition', TrainingIntensity.acquisition, morphocycle),
              const SizedBox(width: 8),
              _buildMorphocycleIntensityChip('Development', TrainingIntensity.development, morphocycle),
              const SizedBox(width: 8),
              _buildMorphocycleIntensityChip('Activation', TrainingIntensity.activation, morphocycle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMorphocycleIntensityChip(String label, TrainingIntensity intensity, Morphocycle morphocycle) {
    final intensityValue = morphocycle.intensityDistribution[intensity.name.toLowerCase()] ?? 0.0;
    final color = _getIntensityColor(intensity);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label\n${intensityValue.toInt()}%',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  Widget _buildRecommendedTab(List<TrainingExercise> exercises, Morphocycle? morphocycle) {
    if (morphocycle == null) {
      return const Center(
        child: Text('No morphocycle data available for recommendations'),
      );
    }

    final recommendations = TrainingExercise.getRecommendedExercisesForWeek(exercises, widget.weekNumber);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Morphocycle-Based Recommendations',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Recovery Day Exercises
          _buildRecommendationSection(
            'Recovery Day (Day +1)',
            'Low intensity, technical skills, fun activities',
            recommendations['recovery'] ?? [],
            Colors.green,
            Icons.nature,
          ),

          // Acquisition Day Exercises
          _buildRecommendationSection(
            'Acquisition Day (Day +2)',
            'High intensity tactical work, game model specific',
            recommendations['acquisition'] ?? [],
            Colors.red,
            Icons.bolt,
          ),

          // Development Day Exercises
          _buildRecommendationSection(
            'Development Day (Day +3)',
            'Medium intensity, technical-tactical development',
            recommendations['development'] ?? [],
            Colors.orange,
            Icons.trending_up,
          ),

          // Activation Day Exercises
          _buildRecommendationSection(
            'Activation Day (Day +4)',
            'Low-medium intensity, set pieces, match preparation',
            recommendations['activation'] ?? [],
            Colors.blue,
            Icons.play_arrow,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationSection(String title, String description, List<TrainingExercise> exercises, Color color, IconData icon) {
    final filteredExercises = _applyFilters(exercises);

    return Container(
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
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${filteredExercises.length}',
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
          if (filteredExercises.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Center(
                child: Text(
                  'No matching exercises found. Try adjusting filters or create new exercises.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
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
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) => _buildExerciseCard(filteredExercises[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildIntensityTab(List<TrainingExercise> exercises) {
    final intensityGroups = <TrainingIntensity, List<TrainingExercise>>{};

    for (final intensity in TrainingIntensity.values) {
      intensityGroups[intensity] = exercises.forIntensity(intensity);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: TrainingIntensity.values.map((intensity) {
          final intensityExercises = _applyFilters(intensityGroups[intensity] ?? []);
          return _buildIntensitySection(intensity, intensityExercises);
        }).toList(),
      ),
    );
  }

  Widget _buildIntensitySection(TrainingIntensity intensity, List<TrainingExercise> exercises) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getIntensityColor(intensity),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  intensity.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _getIntensityDescription(intensity),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
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
            const Text('No exercises found for this intensity')
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
              itemCount: exercises.length,
              itemBuilder: (context, index) => _buildExerciseCard(exercises[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildTacticalFocusTab(List<TrainingExercise> exercises) {
    final focusGroups = <TacticalFocus, List<TrainingExercise>>{};

    for (final focus in TacticalFocus.values) {
      focusGroups[focus] = exercises.forTacticalFocus(focus);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: TacticalFocus.values.map((focus) {
          final focusExercises = _applyFilters(focusGroups[focus] ?? []);
          return _buildTacticalFocusSection(focus, focusExercises);
        }).toList(),
      ),
    );
  }

  Widget _buildTacticalFocusSection(TacticalFocus focus, List<TrainingExercise> exercises) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getTacticalFocusColor(focus),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  focus.displayName,
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
            const Text('No exercises found for this tactical focus')
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
              itemCount: exercises.length,
              itemBuilder: (context, index) => _buildExerciseCard(exercises[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildAllExercisesTab(List<TrainingExercise> exercises) {
    final filteredExercises = _applyFilters(exercises);

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredExercises.length,
      itemBuilder: (context, index) => _buildExerciseCard(filteredExercises[index]),
    );
  }

  Widget _buildExerciseCard(TrainingExercise exercise) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          if (widget.isSelectMode && widget.onExerciseSelected != null) {
            widget.onExerciseSelected!(exercise);
          } else {
            _showExerciseDetails(exercise);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getIntensityColor(exercise.trainingIntensity),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      exercise.trainingIntensity.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (exercise.tacticalFocus != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getTacticalFocusColor(exercise.tacticalFocus!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        exercise.tacticalFocus!.displayName[0],
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
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                exercise.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                exercise.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Field diagram indicator
              if (exercise.fieldDiagram != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.green[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sports_soccer,
                        size: 12,
                        color: Colors.green[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Field Diagram',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${exercise.minPlayers}-${exercise.maxPlayers} players',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: Colors.amber,
                      ),
                      Text(
                        exercise.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
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
  }

  List<TrainingExercise> _applyFilters(List<TrainingExercise> exercises) {
    return exercises
        .search(_searchQuery)
        .where((e) => _selectedCategory == null || e.category == _selectedCategory)
        .where((e) => _selectedComplexity == null || e.complexity == _selectedComplexity)
        .where((e) => _selectedIntensity == null || e.isCompatibleWithIntensity(_selectedIntensity!))
        .where((e) => _selectedTacticalFocus == null || e.isCompatibleWithTacticalFocus(_selectedTacticalFocus!))
        .where((e) => e.durationMinutes >= _minDuration && e.durationMinutes <= _maxDuration)
        .where((e) => e.minPlayers <= _playerCount && e.maxPlayers >= _playerCount)
        .toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Exercises'),
        content: StatefulBuilder(
          builder: (context, setDialogState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Category filter
                DropdownButtonFormField<ExerciseCategory?>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  value: _selectedCategory,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Categories')),
                    ...ExerciseCategory.values.map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat.displayName),
                    )),
                  ],
                  onChanged: (value) => setDialogState(() => _selectedCategory = value),
                ),
                const SizedBox(height: 16),

                // Complexity filter
                DropdownButtonFormField<ExerciseComplexity?>(
                  decoration: const InputDecoration(labelText: 'Complexity'),
                  value: _selectedComplexity,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Complexities')),
                    ...ExerciseComplexity.values.map((comp) => DropdownMenuItem(
                      value: comp,
                      child: Text(comp.displayName),
                    )),
                  ],
                  onChanged: (value) => setDialogState(() => _selectedComplexity = value),
                ),
                const SizedBox(height: 16),

                // Player count slider
                Text('Player Count: $_playerCount'),
                Slider(
                  value: _playerCount.toDouble(),
                  min: 6,
                  max: 22,
                  divisions: 16,
                  onChanged: (value) => setDialogState(() => _playerCount = value.round()),
                ),
                const SizedBox(height: 16),

                // Duration range
                Text('Duration: $_minDuration - $_maxDuration minutes'),
                RangeSlider(
                  values: RangeValues(_minDuration.toDouble(), _maxDuration.toDouble()),
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
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCategory = null;
                _selectedComplexity = null;
                _selectedIntensity = widget.filterIntensity;
                _selectedTacticalFocus = widget.filterTacticalFocus;
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
              setState(() {}); // Trigger rebuild with new filters
              Navigator.pop(context);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showExerciseDetails(TrainingExercise exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(exercise.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(exercise.description),
              const SizedBox(height: 16),
              _buildDetailRow('Duration', '${exercise.durationMinutes} minutes'),
              _buildDetailRow('Players', '${exercise.minPlayers}-${exercise.maxPlayers}'),
              _buildDetailRow('Intensity', exercise.trainingIntensity.name),
              if (exercise.tacticalFocus != null)
                _buildDetailRow('Tactical Focus', exercise.tacticalFocus!.displayName),
              _buildDetailRow('Complexity', exercise.complexity.displayName),
              _buildDetailRow('Space Required', exercise.spaceRequired),
              _buildDetailRow('Estimated RPE', '${exercise.estimatedRPE}/10'),
              if (exercise.equipment.isNotEmpty)
                _buildDetailRow('Equipment', exercise.equipment),
              if (exercise.coachingPoints.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Coaching Points:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...exercise.coachingPoints.map((point) => Text('• $point')),
              ],
              // Field diagram section
              if (exercise.fieldDiagram != null) ...[
                const SizedBox(height: 16),
                const Text('Field Diagram:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green[50],
                  ),
                  child: InkWell(
                    onTap: () => _openFieldDiagramViewer(exercise),
                    borderRadius: BorderRadius.circular(8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sports_soccer,
                            size: 32,
                            color: Colors.green[600],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Field Diagram Available',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap to view/edit diagram',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          if (exercise.fieldDiagram != null)
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _openFieldDiagramViewer(exercise);
              },
              icon: const Icon(Icons.sports_soccer),
              label: const Text('View Diagram'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (widget.isSelectMode)
            ElevatedButton(
              onPressed: () {
                widget.onExerciseSelected?.call(exercise);
                Navigator.pop(context);
              },
              child: const Text('Select'),
            )
          else
            ElevatedButton(
              onPressed: () {
                // TODO: Add to training session or edit
                Navigator.pop(context);
              },
              child: const Text('Add to Session'),
            ),
        ],
      ),
    );
  }

  void _openFieldDiagramViewer(TrainingExercise exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FieldDiagramEditorScreen(
          exerciseId: exercise.id.toString(),
          initialDiagram: exercise.fieldDiagram,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getIntensityColor(TrainingIntensity intensity) {
    switch (intensity) {
      case TrainingIntensity.recovery:
        return Colors.green;
      case TrainingIntensity.activation:
        return Colors.blue;
      case TrainingIntensity.development:
        return Colors.orange;
      case TrainingIntensity.acquisition:
        return Colors.red;
      case TrainingIntensity.competition:
        return Colors.purple;
    }
  }

  Color _getTacticalFocusColor(TacticalFocus focus) {
    switch (focus) {
      case TacticalFocus.recovery:
        return Colors.green;
      case TacticalFocus.defensiveOrg:
        return Colors.indigo;
      case TacticalFocus.attackingOrg:
        return Colors.orange;
      case TacticalFocus.transitions:
        return Colors.cyan;
      case TacticalFocus.setPieces:
        return Colors.purple;
      case TacticalFocus.matchPreparation:
        return Colors.red;
      case TacticalFocus.gameModel:
        return Colors.blue;
      case TacticalFocus.physicalConditioning:
        return Colors.brown;
      case TacticalFocus.possession:
        return Colors.blue;
      case TacticalFocus.pressing:
        return Colors.red;
      case TacticalFocus.counterAttack:
        return Colors.orange;
      case TacticalFocus.positionalPlay:
        return Colors.green;
      case TacticalFocus.setpieces:
        return Colors.purple;
      case TacticalFocus.defensive:
        return Colors.grey;
      case TacticalFocus.attacking:
        return Colors.amber;
    }
  }

  String _getIntensityDescription(TrainingIntensity intensity) {
    switch (intensity) {
      case TrainingIntensity.recovery:
        return 'Low intensity, technical skills, fun activities';
      case TrainingIntensity.activation:
        return 'Low-medium intensity, activation, set pieces';
      case TrainingIntensity.development:
        return 'Medium intensity, technical-tactical development';
      case TrainingIntensity.acquisition:
        return 'High intensity tactical work, game model specific';
      case TrainingIntensity.competition:
        return 'Match simulation, competition preparation';
    }
  }
}
