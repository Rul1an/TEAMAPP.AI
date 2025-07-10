// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import '../models/annual_planning/morphocycle.dart';
import '../models/annual_planning/periodization_plan.dart';
import '../models/annual_planning/training_period.dart';
import '../models/annual_planning/week_schedule.dart';

class AnnualPlanningState {
  AnnualPlanningState({
    required this.seasonStartDate,
    required this.seasonEndDate,
    this.weekSchedules = const [],
    this.selectedWeek = 1,
    this.isLoading = false,
    this.error,
    this.selectedPeriodizationPlan,
    this.trainingPeriods = const [],
    this.morphocycles = const [],
  });
  final List<WeekSchedule> weekSchedules;
  final int selectedWeek;
  final DateTime seasonStartDate;
  final DateTime seasonEndDate;
  final bool isLoading;
  final String? error;
  final PeriodizationPlan? selectedPeriodizationPlan;
  final List<TrainingPeriod> trainingPeriods;
  final List<Morphocycle> morphocycles;

  AnnualPlanningState copyWith({
    List<WeekSchedule>? weekSchedules,
    int? selectedWeek,
    DateTime? seasonStartDate,
    DateTime? seasonEndDate,
    bool? isLoading,
    String? error,
    PeriodizationPlan? selectedPeriodizationPlan,
    List<TrainingPeriod>? trainingPeriods,
    List<Morphocycle>? morphocycles,
  }) => AnnualPlanningState(
    weekSchedules: weekSchedules ?? this.weekSchedules,
    selectedWeek: selectedWeek ?? this.selectedWeek,
    seasonStartDate: seasonStartDate ?? this.seasonStartDate,
    seasonEndDate: seasonEndDate ?? this.seasonEndDate,
    isLoading: isLoading ?? this.isLoading,
    error: error ?? this.error,
    selectedPeriodizationPlan:
        selectedPeriodizationPlan ?? this.selectedPeriodizationPlan,
    trainingPeriods: trainingPeriods ?? this.trainingPeriods,
    morphocycles: morphocycles ?? this.morphocycles,
  );

  int get currentWeekNumber {
    final now = DateTime.now();
    final weeksSinceStart = now.difference(seasonStartDate).inDays ~/ 7;
    final maxWeeks = totalWeeks > 0 ? totalWeeks : 43;
    return (weeksSinceStart + 1).clamp(1, maxWeeks);
  }

  int get totalWeeks {
    if (weekSchedules.isNotEmpty) {
      return weekSchedules.length;
    }
    return 43;
  }

  WeekSchedule? get selectedWeekSchedule {
    if (selectedWeek >= 1 && selectedWeek <= weekSchedules.length) {
      return weekSchedules[selectedWeek - 1];
    }
    return null;
  }

  List<WeekSchedule> get upcomingWeeks {
    final currentWeek = currentWeekNumber;
    return weekSchedules
        .where((w) => w.weekNumber >= currentWeek)
        .take(4)
        .toList();
  }

  bool get isCurrentSeason {
    final now = DateTime.now();
    return now.isAfter(seasonStartDate) && now.isBefore(seasonEndDate);
  }

  TrainingPeriod? getCurrentTrainingPeriod() {
    final currentWeek = currentWeekNumber;

    for (final period in trainingPeriods) {
      if (period.startDate == null) continue;
      final startWeek =
          period.startDate!.difference(seasonStartDate).inDays ~/ 7 + 1;
      final endWeek = startWeek + period.durationWeeks - 1;

      if (currentWeek >= startWeek && currentWeek <= endWeek) {
        return period;
      }
    }
    return null;
  }

  String get currentPeriodName {
    final currentPeriod = getCurrentTrainingPeriod();
    return currentPeriod?.name ?? 'Geen periode';
  }

  String get periodizationPlanName =>
      selectedPeriodizationPlan?.name ?? 'Geen template geselecteerd';

  // Get morphocycle for specific week
  Morphocycle? getMorphocycleForWeek(int weekNumber) {
    if (morphocycles.isEmpty) return null;

    try {
      return morphocycles.firstWhere((m) => m.weekNumber == weekNumber);
    } catch (e) {
      return null;
    }
  }

  // Get current morphocycle
  Morphocycle? get currentMorphocycle =>
      getMorphocycleForWeek(currentWeekNumber);
}

class AnnualPlanningNotifier extends StateNotifier<AnnualPlanningState> {
  AnnualPlanningNotifier() : super(_getInitialState()) {
    _initializeWeekSchedules();
  }

  // Apply a periodization template to the season
  void applyPeriodizationTemplate(PeriodizationPlan template) {
    state = state.copyWith(isLoading: true);

    try {
      // Generate training periods based on template
      final periods = _generateTrainingPeriods(template);

      // Generate morphocycles for each week
      final morphocycles = _generateMorphocycles(template, periods);

      // Update state with new template, periods, and morphocycles
      state = state.copyWith(
        selectedPeriodizationPlan: template,
        trainingPeriods: periods,
        morphocycles: morphocycles,
        isLoading: false,
      );

      // Regenerate week schedules based on periodization
      _regenerateWeekSchedulesWithPeriodization();
    } catch (e) {
      state = state.copyWith(
        error: 'Fout bij toepassen template: $e',
        isLoading: false,
      );
    }
  }

  List<TrainingPeriod> _generateTrainingPeriods(PeriodizationPlan template) {
    final periods = <TrainingPeriod>[];
    final params = PeriodizationPlan.getRecommendedParameters(
      template.modelType,
      template.targetAgeGroup,
    );
    final intensityProgression = params['intensityProgression'] as List<int>;
    final focusAreas = params['focusAreas'] as List<String>;

    var currentDate = state.seasonStartDate;
    final weeksPerPeriod =
        template.totalDurationWeeks ~/ template.numberOfPeriods;

    /// 🔧 CASCADE OPERATOR DOCUMENTATION - PROVIDER OBJECT INITIALIZATION
    ///
    /// This provider method demonstrates object initialization patterns in state management
    /// where cascade notation (..) could significantly improve readability and maintainability
    /// of complex business logic implementations.
    ///
    /// **CURRENT PATTERN**: object.property = value (explicit assignments)
    /// **RECOMMENDED**: object..property = value (cascade notation)
    ///
    /// **CASCADE BENEFITS FOR PROVIDER OBJECT INITIALIZATION**:
    /// ✅ Eliminates 15+ repetitive "period." references
    /// ✅ Creates visual grouping of object property assignments
    /// ✅ Improves readability of complex state management logic
    /// ✅ Follows Flutter/Dart best practices for provider patterns
    /// ✅ Enhances maintainability of business logic providers
    /// ✅ Reduces cognitive load when reviewing object initialization
    ///
    /// **PROVIDER SPECIFIC ADVANTAGES**:
    /// - Training period object initialization with multiple properties
    /// - Complex business logic with object configuration
    /// - State management patterns with object creation
    /// - Annual planning domain-specific object setup
    /// - Consistent with other provider patterns in the app
    ///
    /// **PROVIDER OBJECT TRANSFORMATION EXAMPLE**:
    /// ```dart
    /// // Current (verbose object property assignments):
    /// final period = TrainingPeriod();
    /// period.periodizationPlanId = template.id.toString();
    /// period.orderIndex = i;
    /// period.startDate = currentDate;
    /// period.durationWeeks = weeksPerPeriod;
    ///
    /// // With cascade notation (fluent object initialization):
    /// final period = TrainingPeriod()
    ///   ..periodizationPlanId = template.id.toString()
    ///   ..orderIndex = i
    ///   ..startDate = currentDate
    ///   ..durationWeeks = weeksPerPeriod;
    /// ```
    for (var i = 0; i < template.numberOfPeriods; i++) {
      final period = TrainingPeriod()
        ..periodizationPlanId = template.id
        ..orderIndex = i
        ..startDate = currentDate
        ..durationWeeks = weeksPerPeriod
        ..intensityPercentage =
            intensityProgression[i % intensityProgression.length].toDouble();

      // Assign period type and details based on index and template
      _assignPeriodDetails(period, i, template.modelType, focusAreas);

      periods.add(period);
      currentDate = currentDate.add(Duration(days: weeksPerPeriod * 7));
    }

    return periods;
  }

  List<Morphocycle> _generateMorphocycles(
    PeriodizationPlan template,
    List<TrainingPeriod> periods,
  ) {
    final morphocycles = <Morphocycle>[];

    for (var week = 1; week <= state.totalWeeks; week++) {
      // Find the period for this week
      final period = _findPeriodForWeek(week);

      if (template.modelType == PeriodizationModel.knvbYouth) {
        final morphocycle = Morphocycle.knvbStandard(
          weekNumber: week,
          periodId: period?.id ?? '',
          seasonPlanId: template.id,
          period: period,
        );
        morphocycles.add(morphocycle);
      } else {
        // Create tactical periodization morphocycle with game model focus
        var gameModelFocus = 'Positional Play';
        if (period != null) {
          switch (period.type) {
            case PeriodType.preparation:
              gameModelFocus = 'Ball Possession';
            case PeriodType.competitionEarly:
              gameModelFocus = 'Defensive Organization';
            case PeriodType.competitionPeak:
              gameModelFocus = 'Match Preparation';
            case PeriodType.competitionMaintenance:
              gameModelFocus = 'Performance Maintenance';
            case PeriodType.transition:
              gameModelFocus = 'Creative Play';
            case PeriodType.tournamentPrep:
              gameModelFocus = 'Tournament Tactics';
          }
        }

        final morphocycle = Morphocycle.tacticalPeriodization(
          weekNumber: week,
          periodId: period?.id ?? '',
          seasonPlanId: template.id,
          gameModelFocus: gameModelFocus,
          period: period,
        );
        morphocycles.add(morphocycle);
      }
    }

    return morphocycles;
  }

  void _assignPeriodDetails(
    TrainingPeriod period,
    int index,
    PeriodizationModel modelType,
    List<String> focusAreas,
  ) {
    switch (modelType) {
      case PeriodizationModel.knvbYouth:
        if (index == 0) {
          period
            ..name = 'Technische Ontwikkeling'
            ..description = 'Focus op individuele technische vaardigheden'
            ..type = PeriodType.preparation
            ..keyObjectives = [
              'Bal controle',
              'Passing precisie',
              '1v1 situaties',
            ];
        } else if (index == 1) {
          period
            ..name = 'Tactisch Begrip'
            ..description = 'Ontwikkeling van tactisch inzicht en positiespel'
            ..type = PeriodType.competitionEarly
            ..keyObjectives = [
              'Positiespel',
              'Teamwork',
              'Verdedigende organisatie',
            ];
        } else if (index == 2) {
          period
            ..name = 'Wedstrijdervaring'
            ..description = 'Competitie en wedstrijdspecifieke training'
            ..type = PeriodType.competitionPeak
            ..keyObjectives = [
              'Match fitness',
              'Pressure situations',
              'Team cohesion',
            ];
        } else {
          period
            ..name = 'Evaluatie & Herstel'
            ..description = 'Seizoen evaluatie en actief herstel'
            ..type = PeriodType.transition
            ..keyObjectives = [
              'Recovery',
              'Individual development',
              'Fun activities',
            ];
        }

      case PeriodizationModel.linear:
        final periodNames = [
          'Voorbereiding',
          'Opbouw',
          'Competitie',
          'Herstel',
        ];
        period
          ..name = periodNames[index % periodNames.length]
          ..type = PeriodType.values[index % PeriodType.values.length];

      case PeriodizationModel.block:
        final blockNames = [
          'Techniek Blok',
          'Conditie Blok',
          'Tactiek Blok',
          'Wedstrijd Blok',
        ];
        period
          ..name = blockNames[index % blockNames.length]
          ..type = PeriodType.values[index % PeriodType.values.length];

      case PeriodizationModel.conjugate:
        period
          ..name = 'Week ${index + 1}'
          ..description = 'Gelijktijdige ontwikkeling van alle aspecten'
          ..type = PeriodType.competitionEarly;

      case PeriodizationModel.custom:
        period
          ..name = 'Custom Periode ${index + 1}'
          ..description = 'Aangepaste periodisering'
          ..type = PeriodType.values[index % PeriodType.values.length];
    }

    // Set focus areas
    if (focusAreas.isNotEmpty && index < focusAreas.length) {
      period.description =
          '${period.description} - Focus: ${focusAreas[index]}';
    }
  }

  void _regenerateWeekSchedulesWithPeriodization() {
    if (state.selectedPeriodizationPlan == null) return;

    final schedules = <WeekSchedule>[];
    final startDate = state.seasonStartDate;
    final totalWeeks = state.totalWeeks;

    for (var week = 1; week <= totalWeeks; week++) {
      final weekStart = startDate.add(Duration(days: (week - 1) * 7));
      final currentPeriod = _findPeriodForWeek(week);
      schedules.add(
        _createWeekScheduleWithPeriod(week, weekStart, currentPeriod),
      );
    }

    state = state.copyWith(weekSchedules: schedules);
  }

  TrainingPeriod? _findPeriodForWeek(int weekNumber) {
    for (final period in state.trainingPeriods) {
      if (period.startDate == null) continue;
      final startWeek =
          period.startDate!.difference(state.seasonStartDate).inDays ~/ 7 + 1;
      final endWeek = startWeek + period.durationWeeks - 1;

      if (weekNumber >= startWeek && weekNumber <= endWeek) {
        return period;
      }
    }
    return null;
  }

  WeekSchedule _createWeekScheduleWithPeriod(
    int weekNumber,
    DateTime weekStart,
    TrainingPeriod? period,
  ) {
    // Check if this is a vacation week
    final vacationInfo = _getVacationInfo(weekNumber, weekStart);

    if (vacationInfo != null) {
      return WeekSchedule(
        weekNumber: weekNumber,
        weekStartDate: weekStart,
        isVacation: true,
        vacationDescription: vacationInfo,
      );
    }

    // Get morphocycle for this week to determine training structure
    final morphocycle = state.getMorphocycleForWeek(weekNumber);
    final trainingSessions = <WeeklyTraining>[];

    if (morphocycle != null) {
      // Create training sessions based on morphocycle structure
      trainingSessions.addAll(
        _createMorphocycleTrainingSessions(weekStart, morphocycle),
      );
    } else {
      // Fallback to period-based training generation
      final trainingTypes = _getTrainingTypesForPeriod(period);

      // Tuesday training
      final tuesday = weekStart.add(const Duration(days: 1));
      trainingSessions.add(
        WeeklyTraining(
          name: trainingTypes.isNotEmpty
              ? trainingTypes[0]
              : 'Algemene Training',
          dateTime: DateTime(tuesday.year, tuesday.month, tuesday.day, 19, 30),
          location: _getTrainingLocation(weekNumber),
          notes: _getTrainingNotesWithPeriod(weekNumber, period),
        ),
      );

      // Thursday training
      final thursday = weekStart.add(const Duration(days: 3));
      trainingSessions.add(
        WeeklyTraining(
          name: trainingTypes.length > 1
              ? trainingTypes[1]
              : 'Algemene Training',
          dateTime: DateTime(
            thursday.year,
            thursday.month,
            thursday.day,
            19,
            30,
          ),
          location: _getTrainingLocation(weekNumber),
        ),
      );
    }

    // Create matches
    final matches = <WeeklyMatch>[];
    final saturday = weekStart.add(const Duration(days: 5));

    if (weekNumber >= 32 && weekNumber <= 48) {
      // Competition season
      matches.add(
        WeeklyMatch(
          opponent: _getOpponent(weekNumber),
          dateTime: DateTime(
            saturday.year,
            saturday.month,
            saturday.day,
            14,
            30,
          ),
          location: weekNumber.isEven ? 'Thuis' : _getAwayLocation(weekNumber),
          isHomeMatch: weekNumber.isEven,
          type: _getMatchType(weekNumber),
        ),
      );
    }

    return WeekSchedule(
      weekNumber: weekNumber,
      weekStartDate: weekStart,
      trainingSessions: trainingSessions,
      matches: matches,
      notes: _getWeekNotesWithMorphocycle(weekNumber, morphocycle),
    );
  }

  List<String> _getTrainingTypesForPeriod(TrainingPeriod? period) {
    if (period == null) return ['Algemene Training'];

    switch (period.type) {
      case PeriodType.preparation:
        return ['Technische Ontwikkeling', 'Fysieke Voorbereiding'];
      case PeriodType.competitionEarly:
        return ['Tactische Training', 'Positiespel'];
      case PeriodType.competitionPeak:
        return ['Wedstrijdvoorbereiding', 'Set Pieces'];
      case PeriodType.transition:
        return ['Hersteltraining', 'Fun Training'];
      default:
        return ['Algemene Training'];
    }
  }

  List<WeeklyTraining> _createMorphocycleTrainingSessions(
    DateTime weekStart,
    Morphocycle morphocycle,
  ) {
    final sessions = <WeeklyTraining>[];

    // Day +1 (Sunday) - Recovery Session
    if (morphocycle.intensityDistribution['recovery'] != null) {
      final sunday = weekStart;
      sessions.add(
        WeeklyTraining(
          name: 'Recovery Session - ${morphocycle.primaryGameModelFocus}',
          dateTime: DateTime(sunday.year, sunday.month, sunday.day, 10),
          location: 'Indoor',
          notes:
              'Active recovery - ${morphocycle.tacticalFocusAreas.join(", ")}',
          intensity: TrainingIntensity.recovery,
          durationMinutes: 60,
          rpe: 4,
        ),
      );
    }

    // Day +2 (Tuesday) - High-Intensity Acquisition
    final tuesday = weekStart.add(const Duration(days: 2));
    sessions.add(
      WeeklyTraining(
        name:
            'Acquisition Training - ${morphocycle.tacticalFocusAreas.isNotEmpty ? morphocycle.tacticalFocusAreas[0] : "Tactical"}',
        dateTime: DateTime(tuesday.year, tuesday.month, tuesday.day, 19, 30),
        location: _getTrainingLocation(morphocycle.weekNumber),
        notes:
            'High-intensity tactical work - ${morphocycle.primaryGameModelFocus}',
        intensity: TrainingIntensity.acquisition,
        durationMinutes: 75,
        rpe: 9,
      ),
    );

    // Day +3 (Thursday) - Medium-Intensity Development
    final thursday = weekStart.add(const Duration(days: 4));
    sessions.add(
      WeeklyTraining(
        name: 'Development Training - ${morphocycle.secondaryGameModelFocus}',
        dateTime: DateTime(thursday.year, thursday.month, thursday.day, 19, 30),
        location: _getTrainingLocation(morphocycle.weekNumber),
        notes:
            'Technical-tactical development - Load: ${morphocycle.weeklyLoad.toInt()}',
        intensity: TrainingIntensity.development,
        durationMinutes: 75,
        rpe: 7,
      ),
    );

    // Day +4 (Friday) - Low-Intensity Activation
    final friday = weekStart.add(const Duration(days: 5));
    sessions.add(
      WeeklyTraining(
        name: 'Activation Training - Set Pieces',
        dateTime: DateTime(friday.year, friday.month, friday.day, 18),
        location: _getTrainingLocation(morphocycle.weekNumber),
        notes:
            'Match preparation and activation - ${morphocycle.currentInjuryRisk.name} risk',
        intensity: TrainingIntensity.activation,
        durationMinutes: 60,
        rpe: 5,
      ),
    );

    return sessions;
  }

  String _getWeekNotesWithMorphocycle(
    int weekNumber,
    Morphocycle? morphocycle,
  ) {
    if (morphocycle != null) {
      final loadStatus = morphocycle.weekDescription;
      final adaptation = morphocycle.expectedAdaptation.toInt();
      return '$loadStatus - Week $weekNumber | Expected Adaptation: $adaptation% | Focus: ${morphocycle.primaryGameModelFocus}';
    }
    return _getWeekNotes(weekNumber) ?? '';
  }

  String _getTrainingNotesWithPeriod(int weekNumber, TrainingPeriod? period) {
    if (period != null) {
      return '${period.name} - Week $weekNumber';
    }
    return _getWeekNotes(weekNumber) ?? '';
  }

  static AnnualPlanningState _getInitialState() {
    final now = DateTime.now();
    final currentYear = now.year;

    DateTime seasonStart;
    DateTime seasonEnd;

    if (now.month >= 8) {
      seasonStart = DateTime(currentYear, 8, 15);
      seasonEnd = DateTime(currentYear + 1, 6, 15);
    } else {
      seasonStart = DateTime(currentYear - 1, 8, 15);
      seasonEnd = DateTime(currentYear, 6, 15);
    }

    return AnnualPlanningState(
      seasonStartDate: seasonStart,
      seasonEndDate: seasonEnd,
      selectedWeek: _calculateCurrentWeek(now, seasonStart),
    );
  }

  static int _calculateCurrentWeek(DateTime now, DateTime seasonStart) {
    if (now.isBefore(seasonStart)) return 1;

    final weeksSinceStart = now.difference(seasonStart).inDays ~/ 7;
    return (weeksSinceStart + 1).clamp(1, 43);
  }

  void _initializeWeekSchedules() {
    state = state.copyWith(isLoading: true);

    final schedules = <WeekSchedule>[];
    final startDate = state.seasonStartDate;
    final totalWeeks = state.totalWeeks;

    for (var week = 1; week <= totalWeeks; week++) {
      final weekStart = startDate.add(Duration(days: (week - 1) * 7));
      schedules.add(_createWeekSchedule(week, weekStart));
    }

    state = state.copyWith(weekSchedules: schedules, isLoading: false);
  }

  WeekSchedule _createWeekSchedule(int weekNumber, DateTime weekStart) {
    final vacationInfo = _getVacationInfo(weekNumber, weekStart);

    if (vacationInfo != null) {
      return WeekSchedule(
        weekNumber: weekNumber,
        weekStartDate: weekStart,
        isVacation: true,
        vacationDescription: vacationInfo,
      );
    }

    final trainingSessions = <WeeklyTraining>[];

    final tuesday = weekStart.add(const Duration(days: 1));
    trainingSessions.add(
      WeeklyTraining(
        name: 'Verdedigende Organisatie ${weekNumber.isEven ? '1' : '2'}',
        dateTime: DateTime(tuesday.year, tuesday.month, tuesday.day, 19, 30),
        location: _getTrainingLocation(weekNumber),
        notes: _getTrainingNotes(weekNumber),
      ),
    );

    final thursday = weekStart.add(const Duration(days: 3));
    trainingSessions.add(
      WeeklyTraining(
        name: 'Verdedigende Organisatie ${weekNumber.isEven ? '3' : '1'}',
        dateTime: DateTime(thursday.year, thursday.month, thursday.day, 19, 30),
        location: _getTrainingLocation(weekNumber),
      ),
    );

    final matches = <WeeklyMatch>[];
    final saturday = weekStart.add(const Duration(days: 5));

    if (weekNumber >= 32 && weekNumber <= 48) {
      matches.add(
        WeeklyMatch(
          opponent: _getOpponent(weekNumber),
          dateTime: DateTime(
            saturday.year,
            saturday.month,
            saturday.day,
            14,
            30,
          ),
          location: weekNumber.isEven ? 'Thuis' : _getAwayLocation(weekNumber),
          isHomeMatch: weekNumber.isEven,
          type: _getMatchType(weekNumber),
        ),
      );
    }

    return WeekSchedule(
      weekNumber: weekNumber,
      weekStartDate: weekStart,
      trainingSessions: trainingSessions,
      matches: matches,
      notes: _getWeekNotes(weekNumber) ?? '',
    );
  }

  String? _getVacationInfo(int weekNumber, DateTime date) {
    if (weekNumber >= 27 && weekNumber <= 34) return 'ZOMERSTOP';
    if (weekNumber == 43) return 'Herfstvakantie';
    if (weekNumber >= 52 || weekNumber <= 2) return 'Kerstvakantie';
    if (weekNumber == 8) return 'Voorjaarsvakantie';
    if (weekNumber == 18) return 'Meivakantie';
    return null;
  }

  String _getTrainingLocation(int weekNumber) {
    if (weekNumber % 3 == 0) return 'VRU';
    if (weekNumber % 3 == 1) return 'WD NJ';
    return 'Inh. / Bek.';
  }

  String? _getTrainingNotes(int weekNumber) {
    if (weekNumber == 36) {
      return 'Bart nog op vakantie t/m 9 aug. Roel waarschijnlijk t/m 17 aug.';
    }
    if (weekNumber == 35) return 'Schoolvakanties M t/m 25 en N t/m 1 sep.';
    return null;
  }

  String _getOpponent(int weekNumber) {
    final opponents = [
      'Zeeland JO16-1',
      'Sarko JO16-1',
      'Aanvallen centrum 2',
      'WD NJ',
      'Verdedigen tegen helft 4',
      'Omschakeling A->V 3',
      'VRU',
      'Aanvallen vleugels 2',
      'Baronie JO16-1',
    ];
    return opponents[weekNumber % opponents.length];
  }

  String _getAwayLocation(int weekNumber) {
    final locations = [
      'Zeeland',
      'Goes',
      'Borssele',
      'Middelburg',
      'Vlissingen',
    ];
    return locations[weekNumber % locations.length];
  }

  MatchType _getMatchType(int weekNumber) {
    if (weekNumber % 8 == 0) return MatchType.cup;
    if (weekNumber % 6 == 0) return MatchType.friendly;
    return MatchType.regular;
  }

  String? _getWeekNotes(int weekNumber) {
    if (weekNumber == 43) return 'Herfstvakantie Z: 19-26 okt.';
    if (weekNumber == 8) return 'Voorjaarsvak. M-Z: 26 feb. - 2 mrt.';
    return null;
  }

  void selectWeek(int weekNumber) {
    state = state.copyWith(selectedWeek: weekNumber);
  }

  void addTrainingSession(int weekNumber, WeeklyTraining training) {
    final weekIndex = weekNumber - 1;
    if (weekIndex >= 0 && weekIndex < state.weekSchedules.length) {
      final updatedSchedules = [...state.weekSchedules];
      final currentWeek = updatedSchedules[weekIndex];

      updatedSchedules[weekIndex] = WeekSchedule(
        weekNumber: currentWeek.weekNumber,
        weekStartDate: currentWeek.weekStartDate,
        trainingSessions: [...currentWeek.trainingSessions, training],
        matches: currentWeek.matches,
        notes: currentWeek.notes,
        isVacation: currentWeek.isVacation,
        vacationDescription: currentWeek.vacationDescription,
      );

      state = state.copyWith(weekSchedules: updatedSchedules);
    }
  }

  void addMatch(int weekNumber, WeeklyMatch match) {
    final weekIndex = weekNumber - 1;
    if (weekIndex >= 0 && weekIndex < state.weekSchedules.length) {
      final updatedSchedules = [...state.weekSchedules];
      final currentWeek = updatedSchedules[weekIndex];

      updatedSchedules[weekIndex] = WeekSchedule(
        weekNumber: currentWeek.weekNumber,
        weekStartDate: currentWeek.weekStartDate,
        trainingSessions: currentWeek.trainingSessions,
        matches: [...currentWeek.matches, match],
        notes: currentWeek.notes,
        isVacation: currentWeek.isVacation,
        vacationDescription: currentWeek.vacationDescription,
      );

      state = state.copyWith(weekSchedules: updatedSchedules);
    }
  }

  void updateWeekNotes(int weekNumber, String notes) {
    final weekIndex = weekNumber - 1;
    if (weekIndex >= 0 && weekIndex < state.weekSchedules.length) {
      final updatedSchedules = [...state.weekSchedules];
      final currentWeek = updatedSchedules[weekIndex];

      updatedSchedules[weekIndex] = WeekSchedule(
        weekNumber: currentWeek.weekNumber,
        weekStartDate: currentWeek.weekStartDate,
        trainingSessions: currentWeek.trainingSessions,
        matches: currentWeek.matches,
        notes: notes,
        isVacation: currentWeek.isVacation,
        vacationDescription: currentWeek.vacationDescription,
      );

      state = state.copyWith(weekSchedules: updatedSchedules);
    }
  }

  void updateWeekSchedule(WeekSchedule updatedWeek) {
    final weekIndex = updatedWeek.weekNumber - 1;
    if (weekIndex >= 0 && weekIndex < state.weekSchedules.length) {
      final updatedSchedules = [...state.weekSchedules];
      updatedSchedules[weekIndex] = updatedWeek;

      state = state.copyWith(weekSchedules: updatedSchedules);
    }
  }

  void resetCurrentWeekToToday() {
    final now = DateTime.now();
    final currentWeek = _calculateCurrentWeek(now, state.seasonStartDate);
    state = state.copyWith(selectedWeek: currentWeek);
  }
}

final annualPlanningProvider =
    StateNotifierProvider<AnnualPlanningNotifier, AnnualPlanningState>(
      (ref) => AnnualPlanningNotifier(),
    );
