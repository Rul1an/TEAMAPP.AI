import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../models/annual_planning/index.dart';
// import '../models/club/club.dart'; // Unused import
import '../models/assessment.dart';
import '../models/formation_template.dart';
import '../models/match.dart';
import '../models/performance_rating.dart';
import '../models/player.dart';
import '../models/team.dart';
import '../models/training.dart';
import '../models/training_session/training_exercise.dart';
import '../models/training_session/training_session.dart';
import '../providers/demo_mode_provider.dart';
import '../providers/organization_provider.dart';
import '../services/demo_data_service.dart';

class DatabaseService {
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  static final DatabaseService _instance = DatabaseService._internal();

  Isar? _isar;
  bool _isInitialized = false;
  Ref? _ref;

  // Demo data cache
  Map<String, dynamic>? _demoData;

  // In-memory storage for web and temporary use
  final List<Team> _teams = [];
  final List<Training> _trainings = [];
  final List<Match> _matches = [];
  final List<Player> _players = [];
  final List<PerformanceRating> _performanceRatings = [];
  final List<FormationTemplate> _formationTemplates = [];
  // final List<Club> _clubs = []; // Unused field
  final List<PlayerAssessment> _assessments = [];

  // Annual Planning storage
  final List<SeasonPlan> _seasonPlans = [];
  final List<PeriodizationPlan> _periodizationPlans = [];
  final List<TrainingPeriod> _trainingPeriods = [];

  // Training Session storage
  final List<TrainingSession> _trainingSessions = [];
  final List<TrainingExercise> _trainingExercises = [];

  // Set the ref for accessing providers
  void setRef(Ref ref) {
    _ref = ref;
  }

  // Check if in demo mode
  bool get isDemoMode {
    if (_ref == null) return false;
    final demoState = _ref!.read(demoModeProvider);
    return demoState.isActive;
  }

  // Get current organization ID
  String? get currentOrganizationId {
    if (_ref == null) return null;
    return _ref!.read(currentOrganizationIdProvider);
  }

  // Get demo data based on role
  Map<String, dynamic> _getDemoData() {
    if (_ref == null) return {};

    final demoState = _ref!.read(demoModeProvider);
    if (!demoState.isActive || demoState.role == null) return {};

    // Cache demo data per role
    _demoData ??= DemoDataService.generateDemoData(demoState.role!);
    return _demoData!;
  }

  Future<Isar?> get isar async {
    if (_isar != null) return _isar;
    if (!kIsWeb) {
      await initialize();
    }
    return _isar;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    if (!kIsWeb) {
      // TODO(author): Enable when Isar schemas are generated
      // _isar = await Isar.open(
      //   [
      //     TeamSchema,
      //     PlayerSchema,
      //     TrainingSchema,
      //     MatchSchema,
      //     PerformanceRatingSchema,
      //     PlayerAssessmentSchema,
      //     FormationTemplateSchema,
      //     SeasonPlanSchema,
      //     PeriodizationPlanSchema,
      //     TrainingPeriodSchema,
      //     ContentDistributionSchema,
      //     TrainingSessionSchema,
      //     SessionPhaseSchema,
      //     PlayerAttendanceSchema,
      //     TrainingExerciseSchema,
      //   ],
      //   directory: dir.path,
      // );
    }

    // Initialize with sample data only if empty
    if (_players.isEmpty) {
      await _initializeSampleData();
    }

    // Initialize formation templates if empty
    if (_formationTemplates.isEmpty) {
      await _initializeFormationTemplates();
    }

    // Initialize annual planning data if empty
    if (_seasonPlans.isEmpty || _periodizationPlans.isEmpty) {
      await _initializeAnnualPlanningData();
    }
  }

  Future<void> _initializeSampleData() async {
    // Add sample team
    final team = Team()
      ..id = '1' // Changed to String
      ..name = 'JO17-1'
      ..ageGroup = 'JO17'
      ..season = '2024-2025'
      ..preferredFormation = Formation.fourThreeThree
      ..matchesPlayed = 10
      ..wins = 6
      ..draws = 2
      ..losses = 2
      ..goalsFor = 25
      ..goalsAgainst = 12;

    _teams.add(team);

    // Add sample players
    final positions = [
      Position.goalkeeper,
      Position.defender,
      Position.defender,
      Position.defender,
      Position.defender,
      Position.midfielder,
      Position.midfielder,
      Position.midfielder,
      Position.forward,
      Position.forward,
      Position.forward,
    ];

    final names = [
      ('Lars', 'de Jong'),
      ('Tom', 'Bakker'),
      ('Daan', 'Visser'),
      ('Sem', 'de Vries'),
      ('Lucas', 'van Dijk'),
      ('Finn', 'Jansen'),
      ('Milan', 'de Boer'),
      ('Jesse', 'Mulder'),
      ('Thijs', 'Peters'),
      ('Max', 'Hendriks'),
      ('Noah', 'van der Berg'),
    ];

    for (int i = 0; i < names.length; i++) {
      final player = Player()
        ..id = (i + 1).toString() // Changed to String
        ..firstName = names[i].$1
        ..lastName = names[i].$2
        ..jerseyNumber = i + 1
        ..birthDate = DateTime.now().subtract(Duration(days: 6000 + (i * 30)))
        ..position = positions[i]
        ..preferredFoot = i % 3 == 0 ? PreferredFoot.left : PreferredFoot.right
        ..height = 165.0 + (i * 2)
        ..weight = 55.0 + (i * 1.5)
        ..matchesPlayed = 8 + (i % 3)
        ..goals = i > 7 ? 3 + i : 0
        ..assists = i > 5 ? 2 + (i % 3) : 0
        ..trainingsAttended = 18 + (i % 5)
        ..trainingsTotal = 20;

      _players.add(player);
    }

    // Add sample trainings
    for (int i = 0; i < 5; i++) {
      final training = Training()
        ..id = (i + 1).toString() // Changed to String
        ..date = DateTime.now().add(Duration(days: i * 2))
        ..duration = 90
        ..focus = TrainingFocus.values[i % TrainingFocus.values.length]
        ..intensity =
            TrainingIntensity.values[i % TrainingIntensity.values.length]
        ..status = i < 2 ? TrainingStatus.completed : TrainingStatus.planned
        ..location = 'Sportpark De Toekomst'
        ..presentPlayerIds = _players.take(9).map((p) => p.id).toList()
        ..absentPlayerIds = _players.skip(9).map((p) => p.id).toList();

      _trainings.add(training);
    }

    // Add sample matches
    final opponents = [
      'Ajax JO17',
      'PSV JO17',
      'Feyenoord JO17',
      'AZ JO17',
      'Utrecht JO17',
    ];
    for (int i = 0; i < 5; i++) {
      final match = Match()
        ..id = (i + 1).toString() // Changed to String
        ..date = DateTime.now().add(Duration(days: i * 7))
        ..opponent = opponents[i]
        ..location = i % 2 == 0 ? Location.home : Location.away
        ..competition = Competition.league
        ..status = i < 2 ? MatchStatus.completed : MatchStatus.scheduled
        ..venue = i % 2 == 0 ? 'Sportpark De Toekomst' : 'Uitstadion'
        ..teamScore = i < 2 ? 2 + i : null
        ..opponentScore = i < 2 ? 1 : null;

      _matches.add(match);
    }
  }

  Future<void> _initializeFormationTemplates() async {
    // Add default formation templates
    final defaultTemplates = [
      FormationTemplate.defaultTemplate(
        name: '4-3-3 Aanvallend',
        description:
            'Aanvallende opstelling met drie middenvelders en drie aanvallers',
        formation: Formation.fourThreeThree,
        positionPreferences: FormationTemplate.getDefaultPositionPreferences(
            Formation.fourThreeThree,),
      ),
      FormationTemplate.defaultTemplate(
        name: '4-4-2 Gebalanceerd',
        description:
            'Gebalanceerde opstelling met vier middenvelders en twee spitsen',
        formation: Formation.fourFourTwo,
        positionPreferences: FormationTemplate.getDefaultPositionPreferences(
            Formation.fourFourTwo,),
      ),
      FormationTemplate.defaultTemplate(
        name: '4-3-3 Verdedigend',
        description:
            'Verdedigende variant van 4-3-3 met een defensieve middenvelder',
        formation: Formation.fourThreeThreeDefensive,
        positionPreferences: FormationTemplate.getDefaultPositionPreferences(
            Formation.fourThreeThreeDefensive,),
      ),
      FormationTemplate.defaultTemplate(
        name: '4-2-3-1 Modern',
        description: 'Moderne opstelling met dubbele pivot en één spits',
        formation: Formation.fourTwoThreeOne,
        positionPreferences: FormationTemplate.getDefaultPositionPreferences(
            Formation.fourTwoThreeOne,),
      ),
      FormationTemplate.defaultTemplate(
        name: '3-4-3 Aanvallend',
        description:
            'Zeer aanvallende opstelling met drie centrale verdedigers',
        formation: Formation.threeForThree,
        positionPreferences: FormationTemplate.getDefaultPositionPreferences(
            Formation.threeForThree,),
      ),
    ];

    for (int i = 0; i < defaultTemplates.length; i++) {
      defaultTemplates[i].id = (i + 1).toString(); // Changed to String
      _formationTemplates.add(defaultTemplates[i]);
    }
  }

  Future<void> _initializeAnnualPlanningData() async {
    // TODO(author): Initialize annual planning data
  }

  // Team operations
  Future<void> saveTeam(Team team) async {
    team.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _teams.indexWhere((t) => t.id == team.id);
      if (index >= 0) {
        _teams[index] = team;
      } else {
        if (team.id.isEmpty) {
          // Changed from == ""
          team.id =
              (_teams.length + 1).toString(); // Changed to String generation
        }
        _teams.add(team);
      }
    } else {
      // TODO(author): Implement Isar save
    }
  }

  Future<Team?> getTeam(String id) async {
    // Changed parameter to String
    if (kIsWeb) {
      try {
        return _teams.firstWhere((t) => t.id == id);
      } catch (_) {
        return null;
      }
    }
    // TODO(author): Implement Isar get
    return null;
  }

  Future<List<Team>> getAllTeams() async {
    if (kIsWeb) {
      return List.from(_teams);
    }
    // TODO(author): Implement Isar getAll
    return [];
  }

  // Player operations
  Future<void> savePlayer(Player player) async {
    player.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _players.indexWhere((p) => p.id == player.id);
      if (index >= 0) {
        _players[index] = player;
      } else {
        if (player.id.isEmpty) {
          // Changed from == ""
          player.id =
              (_players.length + 1).toString(); // Changed to String generation
        }
        _players.add(player);
      }
    } else {
      // TODO(author): Implement Isar save
    }
  }

  Future<Player?> getPlayer(String id) async {
    // Changed parameter to String
    if (kIsWeb) {
      try {
        return _players.firstWhere((p) => p.id == id);
      } catch (_) {
        return null;
      }
    }
    // TODO(author): Implement Isar get
    return null;
  }

  Future<List<Player>> getAllPlayers() async {
    if (isDemoMode) {
      final demoData = _getDemoData();
      return demoData['players'] ?? [];
    }

    if (kIsWeb) {
      return List.from(_players);
    }
    // TODO(author): Implement Isar getAll
    return [];
  }

  Future<List<Player>> getPlayersByPosition(Position position) async {
    if (kIsWeb) {
      return _players.where((p) => p.position == position).toList();
    }
    // TODO(author): Implement Isar query
    return [];
  }

  Future<void> updatePlayer(Player player) async {
    final index = _players.indexWhere((p) => p.id == player.id);
    if (index != -1) {
      _players[index] = player;
    }
  }

  Future<void> deletePlayer(String playerId) async {
    // Changed parameter to String
    _players.removeWhere((p) => p.id == playerId);
  }

  // Training operations
  Future<void> saveTraining(Training training) async {
    training.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _trainings.indexWhere((t) => t.id == training.id);
      if (index >= 0) {
        _trainings[index] = training;
      } else {
        if (training.id.isEmpty) {
          // Changed from == ""
          training.id = (_trainings.length + 1)
              .toString(); // Changed to String generation
        }
        _trainings.add(training);
      }
    } else {
      // TODO(author): Implement Isar save
    }
  }

  Future<List<Training>> getAllTrainings() async {
    if (isDemoMode) {
      final demoData = _getDemoData();
      return demoData['trainings'] ?? [];
    }

    if (kIsWeb) {
      return List.from(_trainings);
    }
    // TODO(author): Implement Isar getAll
    return [];
  }

  Future<List<Training>> getUpcomingTrainings() async {
    final now = DateTime.now();
    if (kIsWeb) {
      return _trainings
          .where(
              (t) => t.date.isAfter(now) && t.status == TrainingStatus.planned,)
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    }
    // TODO(author): Implement Isar query
    return [];
  }

  Future<List<Training>> getTrainingsForDateRange(
      DateTime start, DateTime end,) async {
    if (kIsWeb) {
      return _trainings
          .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    }
    // TODO(author): Implement Isar query
    return [];
  }

  Future<void> updateTraining(Training training) async {
    final index = _trainings.indexWhere((t) => t.id == training.id);
    if (index != -1) {
      _trainings[index] = training;
    }
  }

  Future<void> deleteTraining(String trainingId) async {
    _trainings.removeWhere((t) => t.id == trainingId);
  }

  // Match operations
  Future<void> saveMatch(Match match) async {
    match.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _matches.indexWhere((m) => m.id == match.id);
      if (index >= 0) {
        _matches[index] = match;
      } else {
        if (match.id.isEmpty) {
          // Changed from == ""
          match.id =
              (_matches.length + 1).toString(); // Changed to String generation
        }
        _matches.add(match);
      }
    } else {
      // TODO(author): Implement Isar save
    }
  }

  Future<Match?> getMatch(String id) async {
    // Changed parameter to String
    if (kIsWeb) {
      try {
        return _matches.firstWhere((m) => m.id == id);
      } catch (_) {
        return null;
      }
    }
    // TODO(author): Implement Isar get
    return null;
  }

  Future<List<Match>> getAllMatches() async {
    if (isDemoMode) {
      final demoData = _getDemoData();
      return demoData['matches'] ?? [];
    }

    if (kIsWeb) {
      return List.from(_matches);
    }
    // TODO(author): Implement Isar getAll
    return [];
  }

  Future<List<Match>> getUpcomingMatches() async {
    final now = DateTime.now();
    if (kIsWeb) {
      return _matches
          .where(
              (m) => m.date.isAfter(now) && m.status == MatchStatus.scheduled,)
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    }
    // TODO(author): Implement Isar query
    return [];
  }

  Future<List<Match>> getRecentMatches({int limit = 5}) async {
    if (kIsWeb) {
      final completed = _matches
          .where((m) => m.status == MatchStatus.completed)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return completed.take(limit).toList();
    }
    // TODO(author): Implement Isar query
    return [];
  }

  Future<List<Match>> getMatches() async => _matches;

  Future<void> addMatch(Match match) async {
    match.id = (_matches.length + 1).toString(); // Changed to String
    _matches.add(match);
  }

  Future<void> updateMatch(Match match) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _matches.indexWhere((m) => m.id == match.id);
    if (index != -1) {
      _matches[index] = match;
    }
  }

  Future<void> deleteMatch(String matchId) async {
    _matches.removeWhere((m) => m.id == matchId);
  }

  // Statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final players = await getAllPlayers();
    final trainings = await getAllTrainings();
    final matches = await getAllMatches();
    final completedMatches =
        matches.where((m) => m.status == MatchStatus.completed).toList();

    int wins = 0;
    int draws = 0;
    int losses = 0;
    int goalsFor = 0;
    int goalsAgainst = 0;

    for (final match in completedMatches) {
      if (match.teamScore != null && match.opponentScore != null) {
        goalsFor += match.teamScore!;
        goalsAgainst += match.opponentScore!;

        if (match.teamScore! > match.opponentScore!) {
          wins++;
        } else if (match.teamScore! < match.opponentScore!) {
          losses++;
        } else {
          draws++;
        }
      }
    }

    final totalMatches = wins + draws + losses;
    final winPercentage = totalMatches > 0 ? (wins / totalMatches) * 100 : 0.0;

    return {
      'totalPlayers': players.length,
      'totalTrainings': trainings.length,
      'totalMatches': matches.length,
      'winPercentage': winPercentage,
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'goalsFor': goalsFor,
      'goalsAgainst': goalsAgainst,
      'goalDifference': goalsFor - goalsAgainst,
    };
  }

  // Performance Rating operations
  Future<void> savePerformanceRating(PerformanceRating rating) async {
    if (kIsWeb) {
      final index = _performanceRatings.indexWhere((r) => r.id == rating.id);
      if (index >= 0) {
        _performanceRatings[index] = rating;
      } else {
        _performanceRatings.add(rating);
      }
    }
  }

  Future<List<PerformanceRating>> getPlayerRatings(String playerId) async {
    if (kIsWeb) {
      return _performanceRatings.where((r) => r.playerId == playerId).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    }
    return [];
  }

  Future<double> getPlayerAverageRating(String playerId,
      {int? lastNRatings,}) async {
    final ratings = await getPlayerRatings(playerId);
    if (ratings.isEmpty) return 0.0;

    final ratingsToConsider =
        lastNRatings != null ? ratings.take(lastNRatings).toList() : ratings;

    if (ratingsToConsider.isEmpty) return 0.0;

    final sum =
        ratingsToConsider.map((r) => r.overallRating).reduce((a, b) => a + b);

    return sum / ratingsToConsider.length;
  }

  Future<PerformanceTrend> getPlayerPerformanceTrend(String playerId) async {
    final ratings = await getPlayerRatings(playerId);

    if (ratings.length < 3) return PerformanceTrend.stable;

    final recentRatings = ratings.take(6).toList();
    if (recentRatings.length < 3) return PerformanceTrend.stable;

    final midPoint = recentRatings.length ~/ 2;
    final mostRecent = recentRatings.take(midPoint).toList();
    final older = recentRatings.skip(midPoint).toList();

    final recentAvg =
        mostRecent.map((r) => r.overallRating).reduce((a, b) => a + b) /
            mostRecent.length;

    final olderAvg = older.map((r) => r.overallRating).reduce((a, b) => a + b) /
        older.length;

    const threshold = 0.3;
    if (recentAvg > olderAvg + threshold) {
      return PerformanceTrend.improving;
    } else if (recentAvg < olderAvg - threshold) {
      return PerformanceTrend.declining;
    } else {
      return PerformanceTrend.stable;
    }
  }

  // Assessment operations
  Future<List<PlayerAssessment>> getAllAssessments() async {
    if (kIsWeb) {
      return List.from(_assessments);
    }
    return [];
  }

  Future<List<PlayerAssessment>> getPlayerAssessments(String playerId) async {
    if (kIsWeb) {
      return _assessments.where((a) => a.playerId == playerId).toList()
        ..sort((a, b) => b.assessmentDate.compareTo(a.assessmentDate));
    }
    return [];
  }

  Future<PlayerAssessment?> getAssessment(String assessmentId) async {
    if (kIsWeb) {
      try {
        return _assessments.firstWhere((a) => a.id == assessmentId);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<void> addAssessment(PlayerAssessment assessment) async {
    assessment.id = (_assessments.length + 1).toString();
    _assessments.add(assessment);
  }

  Future<void> updateAssessment(PlayerAssessment assessment) async {
    final index = _assessments.indexWhere((a) => a.id == assessment.id);
    if (index != -1) {
      _assessments[index] = assessment;
    }
  }

  // Formation Template operations
  Future<List<FormationTemplate>> getAllFormationTemplates() async {
    if (kIsWeb) {
      return List.from(_formationTemplates);
    }
    return [];
  }

  Future<void> addFormationTemplate(FormationTemplate template) async {
    if (template.id.isEmpty) {
      template.id = (_formationTemplates.length + 1).toString();
    }
    _formationTemplates.add(template);
  }

  Future<void> deleteFormationTemplate(String templateId) async {
    _formationTemplates.removeWhere((t) => t.id == templateId);
  }

  Future<Map<String, dynamic>> applyFormationTemplate(
      FormationTemplate template, List<Player> availablePlayers,) async {
    // Simple implementation - return formation data
    return {
      'formation': template.formation,
      'players': availablePlayers.take(11).toList(),
    };
  }

  // Annual Planning operations
  Future<List<SeasonPlan>> getAllSeasonPlans() async {
    if (kIsWeb) {
      return List.from(_seasonPlans);
    }
    return [];
  }

  Future<List<PeriodizationPlan>> getAllPeriodizationPlans() async {
    if (kIsWeb) {
      return List.from(_periodizationPlans);
    }
    return [];
  }

  Future<List<TrainingPeriod>> getAllTrainingPeriods() async {
    if (kIsWeb) {
      return List.from(_trainingPeriods);
    }
    return [];
  }

  // Training Session operations
  Future<List<TrainingSession>> getUpcomingTrainingSessions() async {
    final now = DateTime.now();
    if (kIsWeb) {
      return _trainingSessions.where((s) => s.date.isAfter(now)).toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    }
    return [];
  }

  Future<List<TrainingSession>> getRecentTrainingSessions(
      {int limit = 5,}) async {
    if (kIsWeb) {
      final sessions = _trainingSessions.toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return sessions.take(limit).toList();
    }
    return [];
  }

  Future<List<TrainingSession>> getAllTrainingSessions() async {
    if (kIsWeb) {
      return List.from(_trainingSessions);
    }
    return [];
  }

  Future<TrainingSession?> getTrainingSession(String sessionId) async {
    if (kIsWeb) {
      try {
        return _trainingSessions.firstWhere((s) => s.id == sessionId);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<void> saveTrainingSession(TrainingSession session) async {
    if (kIsWeb) {
      final index = _trainingSessions.indexWhere((s) => s.id == session.id);
      if (index >= 0) {
        _trainingSessions[index] = session;
      } else {
        if (session.id.isEmpty) {
          session.id = (_trainingSessions.length + 1).toString();
        }
        _trainingSessions.add(session);
      }
    }
  }

  Future<void> saveTrainingExercise(TrainingExercise exercise) async {
    if (kIsWeb) {
      final index = _trainingExercises.indexWhere((e) => e.id == exercise.id);
      if (index >= 0) {
        _trainingExercises[index] = exercise;
      } else {
        if (exercise.id == 0) {
          exercise.id = _trainingExercises.length + 1;
        }
        _trainingExercises.add(exercise);
      }
    }
  }
}
