import 'package:isar/isar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/team.dart';
import '../models/player.dart';
import '../models/training.dart';
import '../models/match.dart';
import '../models/performance_rating.dart';
import '../models/assessment.dart';
import '../models/formation_template.dart';
import '../models/annual_planning/index.dart';
import '../models/training_session/training_session.dart';
import '../models/training_session/session_phase.dart';
import '../models/training_session/player_attendance.dart';
import '../models/training_session/training_exercise.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Isar? _isar;
  bool _isInitialized = false;

  // In-memory storage for web
  final List<Team> _teams = [];
  final List<Player> _players = [];
  final List<Training> _trainings = [];
  final List<Match> _matches = [];
  final List<PerformanceRating> _performanceRatings = [];
  final List<PlayerAssessment> _assessments = [];
  final List<FormationTemplate> _formationTemplates = [];

  // Annual Planning storage
  final List<SeasonPlan> _seasonPlans = [];
  final List<PeriodizationPlan> _periodizationPlans = [];
  final List<TrainingPeriod> _trainingPeriods = [];

  // Training Session storage
  final List<TrainingSession> _trainingSessions = [];
  final List<SessionPhase> _sessionPhases = [];
  final List<PlayerAttendance> _playerAttendances = [];
  final List<TrainingExercise> _trainingExercises = [];

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

      // TODO: Enable when Isar schemas are generated
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
      ..id = 1
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
      Position.defender, Position.defender, Position.defender, Position.defender,
      Position.midfielder, Position.midfielder, Position.midfielder,
      Position.forward, Position.forward, Position.forward,
    ];

    final names = [
      ('Lars', 'de Jong'), ('Tom', 'Bakker'), ('Daan', 'Visser'),
      ('Sem', 'de Vries'), ('Lucas', 'van Dijk'), ('Finn', 'Jansen'),
      ('Milan', 'de Boer'), ('Jesse', 'Mulder'), ('Thijs', 'Peters'),
      ('Max', 'Hendriks'), ('Noah', 'van der Berg'),
    ];

    for (int i = 0; i < names.length; i++) {
      final player = Player()
        ..id = i + 1
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
        ..id = i + 1
        ..date = DateTime.now().add(Duration(days: i * 2))
        ..duration = 90
        ..focus = TrainingFocus.values[i % TrainingFocus.values.length]
        ..intensity = TrainingIntensity.values[i % TrainingIntensity.values.length]
        ..status = i < 2 ? TrainingStatus.completed : TrainingStatus.planned
        ..location = 'Sportpark De Toekomst'
        ..presentPlayerIds = _players.take(9).map((p) => p.id.toString()).toList()
        ..absentPlayerIds = _players.skip(9).map((p) => p.id.toString()).toList();

      _trainings.add(training);
    }

    // Add sample matches
    final opponents = ['Ajax JO17', 'PSV JO17', 'Feyenoord JO17', 'AZ JO17', 'Utrecht JO17'];
    for (int i = 0; i < 5; i++) {
      final match = Match()
        ..id = i + 1
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

    // Sample data initialized with ${_players.length} players
  }

  Future<void> _initializeFormationTemplates() async {
    // Add default formation templates
    final defaultTemplates = [
      FormationTemplate.defaultTemplate(
        name: '4-3-3 Aanvallend',
        description: 'Aanvallende opstelling met drie middenvelders en drie aanvallers',
        formation: Formation.fourThreeThree,
        positionPreferences: FormationTemplate.getDefaultPositionPreferences(Formation.fourThreeThree),
      ),
      FormationTemplate.defaultTemplate(
        name: '4-4-2 Gebalanceerd',
        description: 'Gebalanceerde opstelling met vier middenvelders en twee spitsen',
        formation: Formation.fourFourTwo,
        positionPreferences: FormationTemplate.getDefaultPositionPreferences(Formation.fourFourTwo),
      ),
      FormationTemplate.defaultTemplate(
        name: '4-3-3 Verdedigend',
        description: 'Verdedigende variant van 4-3-3 met een defensieve middenvelder',
        formation: Formation.fourThreeThreeDefensive,
        positionPreferences: FormationTemplate.getDefaultPositionPreferences(Formation.fourThreeThreeDefensive),
      ),
      FormationTemplate.defaultTemplate(
        name: '4-2-3-1 Modern',
        description: 'Moderne opstelling met dubbele pivot en één spits',
        formation: Formation.fourTwoThreeOne,
        positionPreferences: FormationTemplate.getDefaultPositionPreferences(Formation.fourTwoThreeOne),
      ),
      FormationTemplate.defaultTemplate(
        name: '3-4-3 Aanvallend',
        description: 'Zeer aanvallende opstelling met drie centrale verdedigers',
        formation: Formation.threeForThree,
        positionPreferences: FormationTemplate.getDefaultPositionPreferences(Formation.threeForThree),
      ),
    ];

    for (int i = 0; i < defaultTemplates.length; i++) {
      defaultTemplates[i].id = i + 1;
      _formationTemplates.add(defaultTemplates[i]);
    }

    // print('Formation templates initialized with ${_formationTemplates.length} templates');
  }

  // Team operations
  Future<void> saveTeam(Team team) async {
    team.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _teams.indexWhere((t) => t.id == team.id);
      if (index >= 0) {
        _teams[index] = team;
      } else {
        if (team.id == Isar.autoIncrement) {
          team.id = (_teams.map((t) => t.id).fold(0, (a, b) => a > b ? a : b) + 1);
        }
        _teams.add(team);
      }
    } else {
      // TODO: Implement Isar save
    }
  }

  Future<Team?> getTeam(int id) async {
    if (kIsWeb) {
      try {
        return _teams.firstWhere((t) => t.id == id);
      } catch (_) {
        return null;
      }
    }
    // TODO: Implement Isar get
    return null;
  }

  Future<List<Team>> getAllTeams() async {
    if (kIsWeb) {
      return List.from(_teams);
    }
    // TODO: Implement Isar getAll
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
        if (player.id == Isar.autoIncrement) {
          player.id = (_players.map((p) => p.id).fold(0, (a, b) => a > b ? a : b) + 1);
        }
        _players.add(player);
    // print('Player added: ${player.firstName} ${player.lastName} with ID ${player.id}');
      }
    } else {
      // TODO: Implement Isar save
    }
  }

  Future<Player?> getPlayer(int id) async {
    if (kIsWeb) {
      try {
        return _players.firstWhere((p) => p.id == id);
      } catch (_) {
        return null;
      }
    }
    // TODO: Implement Isar get
    return null;
  }

  Future<List<Player>> getAllPlayers() async {
    if (kIsWeb) {
    // print('Getting all players: ${_players.length} players found');
      return List.from(_players);
    }
    // TODO: Implement Isar getAll
    return [];
  }

  Future<List<Player>> getPlayersByPosition(Position position) async {
    if (kIsWeb) {
      return _players.where((p) => p.position == position).toList();
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<void> updatePlayer(Player player) async {
    // Mock implementation
    final index = _players.indexWhere((p) => p.id == player.id);
    if (index != -1) {
      _players[index] = player;
    }
  }

  Future<void> deletePlayer(int playerId) async {
    // Mock implementation
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
        if (training.id == Isar.autoIncrement) {
          training.id = (_trainings.map((t) => t.id).fold(0, (a, b) => a > b ? a : b) + 1);
        }
        _trainings.add(training);
      }
    } else {
      // TODO: Implement Isar save
    }
  }

  Future<List<Training>> getAllTrainings() async {
    if (kIsWeb) {
      return List.from(_trainings);
    }
    // TODO: Implement Isar getAll
    return [];
  }

  Future<List<Training>> getUpcomingTrainings() async {
    final now = DateTime.now();
    if (kIsWeb) {
      return _trainings
          .where((t) => t.date.isAfter(now) && t.status == TrainingStatus.planned)
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<List<Training>> getTrainingsForDateRange(DateTime start, DateTime end) async {
    if (kIsWeb) {
      return _trainings
          .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    }
    // TODO: Implement Isar query
    return [];
  }

  // Match operations
  Future<void> saveMatch(Match match) async {
    match.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _matches.indexWhere((m) => m.id == match.id);
      if (index >= 0) {
        _matches[index] = match;
      } else {
        if (match.id == Isar.autoIncrement) {
          match.id = (_matches.map((m) => m.id).fold(0, (a, b) => a > b ? a : b) + 1);
        }
        _matches.add(match);
    // print('Match added: ${match.opponent} on ${match.date}');
      }
    } else {
      // TODO: Implement Isar save
    }
  }

  Future<Match?> getMatch(int id) async {
    if (kIsWeb) {
      try {
        return _matches.firstWhere((m) => m.id == id);
      } catch (_) {
        return null;
      }
    }
    // TODO: Implement Isar get
    return null;
  }

  Future<List<Match>> getAllMatches() async {
    if (kIsWeb) {
      return List.from(_matches);
    }
    // TODO: Implement Isar getAll
    return [];
  }

  Future<List<Match>> getUpcomingMatches() async {
    final now = DateTime.now();
    if (kIsWeb) {
      return _matches
          .where((m) => m.date.isAfter(now) && m.status == MatchStatus.scheduled)
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    }
    // TODO: Implement Isar query
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
    // TODO: Implement Isar query
    return [];
  }

  // Statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final players = await getAllPlayers();
    final trainings = await getAllTrainings();
    final matches = await getAllMatches();
    final completedMatches = matches.where((m) => m.status == MatchStatus.completed).toList();

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

  // Matches
  Future<List<Match>> getMatches() async {
    // Mock implementation
    return _matches;
  }

  Future<void> addMatch(Match match) async {
    // Mock implementation
    match.id = _matches.length + 1;
    _matches.add(match);
  }

  Future<void> updateMatch(Match match) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _matches.indexWhere((m) => m.id == match.id);
    if (index != -1) {
      _matches[index] = match;
    }
  }

  Future<void> deleteMatch(int matchId) async {
    // Mock implementation
    _matches.removeWhere((m) => m.id == matchId);
  }

  // Trainings
  Future<List<Training>> getTrainings() async {
    // Mock implementation
    return _trainings;
  }

  Future<void> updateTraining(Training training) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _trainings.indexWhere((t) => t.id == training.id);
    if (index != -1) {
      _trainings[index] = training;
    }
  }

  Future<void> deleteTraining(int id) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));
    _trainings.removeWhere((t) => t.id == id);
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
    } else {
      // TODO: Implement Isar save
    }
  }

  Future<List<PerformanceRating>> getPlayerRatings(String playerId) async {
    if (kIsWeb) {
      return _performanceRatings
          .where((r) => r.playerId == playerId)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<List<PerformanceRating>> getMatchRatings(String matchId) async {
    if (kIsWeb) {
      return _performanceRatings
          .where((r) => r.matchId == matchId)
          .toList();
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<List<PerformanceRating>> getTrainingRatings(String trainingId) async {
    if (kIsWeb) {
      return _performanceRatings
          .where((r) => r.trainingId == trainingId)
          .toList();
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<PerformanceRating?> getLatestPlayerRating(String playerId) async {
    final ratings = await getPlayerRatings(playerId);
    return ratings.isNotEmpty ? ratings.first : null;
  }

  Future<PerformanceTrend> getPlayerPerformanceTrend(String playerId) async {
    final ratings = await getPlayerRatings(playerId);
    final trendString = PerformanceRating.calculateTrend(ratings);

    switch (trendString) {
      case '↗️':
        return PerformanceTrend.improving;
      case '↘️':
        return PerformanceTrend.declining;
      default:
        return PerformanceTrend.stable;
    }
  }

  Future<double> getPlayerAverageRating(String playerId, {int? lastNRatings}) async {
    final ratings = await getPlayerRatings(playerId);
    if (ratings.isEmpty) return 0.0;

    final ratingsToConsider = lastNRatings != null
        ? ratings.take(lastNRatings).toList()
        : ratings;

    final sum = ratingsToConsider.fold(0, (sum, r) => sum + r.overallRating);
    return sum / ratingsToConsider.length;
  }

  // Assessment operations
  Future<void> addAssessment(PlayerAssessment assessment) async {
    if (kIsWeb) {
      if (assessment.id == Isar.autoIncrement) {
        assessment.id = (_assessments.map((a) => a.id).fold(0, (a, b) => a > b ? a : b) + 1);
      }
      _assessments.add(assessment);
    } else {
      // TODO: Implement Isar save
    }
  }

  Future<void> updateAssessment(PlayerAssessment assessment) async {
    if (kIsWeb) {
      final index = _assessments.indexWhere((a) => a.id == assessment.id);
      if (index >= 0) {
        _assessments[index] = assessment;
      }
    } else {
      // TODO: Implement Isar update
    }
  }

  Future<PlayerAssessment?> getAssessment(int id) async {
    if (kIsWeb) {
      try {
        return _assessments.firstWhere((a) => a.id == id);
      } catch (_) {
        return null;
      }
    }
    // TODO: Implement Isar get
    return null;
  }

  Future<List<PlayerAssessment>> getPlayerAssessments(String playerId) async {
    if (kIsWeb) {
      return _assessments
          .where((a) => a.playerId == playerId)
          .toList()
        ..sort((a, b) => b.assessmentDate.compareTo(a.assessmentDate));
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<List<PlayerAssessment>> getAllAssessments() async {
    if (kIsWeb) {
      return List.from(_assessments);
    }
    // TODO: Implement Isar getAll
    return [];
  }

  Future<void> deleteAssessment(int id) async {
    if (kIsWeb) {
      _assessments.removeWhere((a) => a.id == id);
    } else {
      // TODO: Implement Isar delete
    }
  }

  Future<PlayerAssessment?> getLatestPlayerAssessment(String playerId) async {
    final assessments = await getPlayerAssessments(playerId);
    return assessments.isNotEmpty ? assessments.first : null;
  }

  // Formation Template operations
  Future<void> addFormationTemplate(FormationTemplate template) async {
    if (kIsWeb) {
      if (template.id == Isar.autoIncrement) {
        template.id = (_formationTemplates.map((t) => t.id).fold(0, (a, b) => a > b ? a : b) + 1);
      }
      _formationTemplates.add(template);
    } else {
      // TODO: Implement Isar save
    }
  }

  Future<void> updateFormationTemplate(FormationTemplate template) async {
    if (kIsWeb) {
      final index = _formationTemplates.indexWhere((t) => t.id == template.id);
      if (index >= 0) {
        template.updatedAt = DateTime.now();
        _formationTemplates[index] = template;
      }
    } else {
      // TODO: Implement Isar update
    }
  }

  Future<FormationTemplate?> getFormationTemplate(int id) async {
    if (kIsWeb) {
      try {
        return _formationTemplates.firstWhere((t) => t.id == id);
      } catch (_) {
        return null;
      }
    }
    // TODO: Implement Isar get
    return null;
  }

  Future<List<FormationTemplate>> getAllFormationTemplates() async {
    if (kIsWeb) {
      return List.from(_formationTemplates);
    }
    // TODO: Implement Isar getAll
    return [];
  }

  Future<List<FormationTemplate>> getDefaultFormationTemplates() async {
    if (kIsWeb) {
      return _formationTemplates.where((t) => t.isDefault).toList();
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<List<FormationTemplate>> getCustomFormationTemplates() async {
    if (kIsWeb) {
      return _formationTemplates.where((t) => t.isCustom).toList();
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<List<FormationTemplate>> getFormationTemplatesByFormation(Formation formation) async {
    if (kIsWeb) {
      return _formationTemplates.where((t) => t.formation == formation).toList();
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<void> deleteFormationTemplate(int id) async {
    if (kIsWeb) {
      _formationTemplates.removeWhere((t) => t.id == id);
    } else {
      // TODO: Implement Isar delete
    }
  }

  // Annual Planning Operations

  // SeasonPlan operations
  Future<void> saveSeasonPlan(SeasonPlan seasonPlan) async {
    seasonPlan.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _seasonPlans.indexWhere((s) => s.id == seasonPlan.id);
      if (index >= 0) {
        _seasonPlans[index] = seasonPlan;
      } else {
        if (seasonPlan.id == Isar.autoIncrement) {
          seasonPlan.id = (_seasonPlans.map((s) => s.id).fold(0, (a, b) => a > b ? a : b) + 1);
        }
        _seasonPlans.add(seasonPlan);
      }
    } else {
      // TODO: Implement Isar save
    }
  }

  Future<SeasonPlan?> getSeasonPlan(int id) async {
    if (kIsWeb) {
      try {
        return _seasonPlans.firstWhere((s) => s.id == id);
      } catch (_) {
        return null;
      }
    }
    // TODO: Implement Isar get
    return null;
  }

  Future<List<SeasonPlan>> getAllSeasonPlans() async {
    if (kIsWeb) {
      return List.from(_seasonPlans);
    }
    // TODO: Implement Isar getAll
    return [];
  }

  Future<List<SeasonPlan>> getActiveSeasonPlans() async {
    if (kIsWeb) {
      return _seasonPlans
          .where((s) => s.status == SeasonStatus.active)
          .toList()
        ..sort((a, b) => a.seasonStartDate.compareTo(b.seasonStartDate));
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<List<SeasonPlan>> getSeasonPlanTemplates() async {
    if (kIsWeb) {
      return _seasonPlans.where((s) => s.isTemplate).toList();
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<SeasonPlan?> getCurrentSeasonPlan() async {
    final now = DateTime.now();
    if (kIsWeb) {
      try {
        return _seasonPlans.firstWhere((s) =>
          s.status == SeasonStatus.active &&
          now.isAfter(s.seasonStartDate) &&
          now.isBefore(s.seasonEndDate)
        );
      } catch (_) {
        return null;
      }
    }
    // TODO: Implement Isar query
    return null;
  }

  Future<void> updateSeasonPlan(SeasonPlan seasonPlan) async {
    seasonPlan.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _seasonPlans.indexWhere((s) => s.id == seasonPlan.id);
      if (index >= 0) {
        _seasonPlans[index] = seasonPlan;
      }
    } else {
      // TODO: Implement Isar update
    }
  }

  Future<void> deleteSeasonPlan(int id) async {
    if (kIsWeb) {
      _seasonPlans.removeWhere((s) => s.id == id);
    } else {
      // TODO: Implement Isar delete
    }
  }

  // TrainingPeriod operations
  Future<void> saveTrainingPeriod(TrainingPeriod period) async {
    period.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _trainingPeriods.indexWhere((t) => t.id == period.id);
      if (index >= 0) {
        _trainingPeriods[index] = period;
      } else {
        if (period.id == Isar.autoIncrement) {
          period.id = (_trainingPeriods.map((t) => t.id).fold(0, (a, b) => a > b ? a : b) + 1);
        }
        _trainingPeriods.add(period);
      }
    } else {
      // TODO: Implement Isar save
    }
  }

  Future<TrainingPeriod?> getTrainingPeriod(int id) async {
    if (kIsWeb) {
      try {
        return _trainingPeriods.firstWhere((t) => t.id == id);
      } catch (_) {
        return null;
      }
    }
    // TODO: Implement Isar get
    return null;
  }

  Future<List<TrainingPeriod>> getAllTrainingPeriods() async {
    if (kIsWeb) {
      return List.from(_trainingPeriods);
    }
    // TODO: Implement Isar getAll
    return [];
  }

  Future<List<TrainingPeriod>> getTrainingPeriodsByPlan(String periodizationPlanId) async {
    if (kIsWeb) {
      return _trainingPeriods
          .where((t) => t.periodizationPlanId == periodizationPlanId)
          .toList()
        ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<TrainingPeriod?> getCurrentTrainingPeriod() async {
    if (kIsWeb) {
      try {
        return _trainingPeriods.firstWhere((t) => t.isActive);
      } catch (_) {
        return null;
      }
    }
    // TODO: Implement Isar query
    return null;
  }

  Future<void> updateTrainingPeriod(TrainingPeriod period) async {
    period.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _trainingPeriods.indexWhere((t) => t.id == period.id);
      if (index >= 0) {
        _trainingPeriods[index] = period;
      }
    } else {
      // TODO: Implement Isar update
    }
  }

  Future<void> deleteTrainingPeriod(int id) async {
    if (kIsWeb) {
      _trainingPeriods.removeWhere((t) => t.id == id);
    } else {
      // TODO: Implement Isar delete
    }
  }

  // Annual Planning initialization
  Future<void> _initializeAnnualPlanningData() async {
    // Create default periodization plan templates
    if (_periodizationPlans.isEmpty) {
      final knvbTemplate = PeriodizationPlan.knvbYouthU17();
      final linearTemplate = PeriodizationPlan.traditionalLinear();
      final blockTemplate = PeriodizationPlan.blockPeriodization();
      final conjugateTemplate = PeriodizationPlan.conjugateMethod();

      await savePeriodizationPlan(knvbTemplate);
      await savePeriodizationPlan(linearTemplate);
      await savePeriodizationPlan(blockTemplate);
      await savePeriodizationPlan(conjugateTemplate);
    }

    // Create sample season plan
    if (_seasonPlans.isEmpty) {
      final sampleSeason = SeasonPlan.jo17DutchSeason(
        teamName: "JO17-1",
        season: "2024-2025",
      );

      // Link to KNVB template
      final template = _periodizationPlans.firstWhere(
        (p) => p.modelType == PeriodizationModel.knvbYouth,
        orElse: () => _periodizationPlans.first,
      );
      sampleSeason.periodizationPlanId = template.id.toString();

      await saveSeasonPlan(sampleSeason);

      // Create training periods for the sample season
      final preparation = TrainingPeriod.preparation(
        periodizationPlanId: template.id.toString(),
        orderIndex: 0,
        durationWeeks: 8,
      );
      final earlyCompetition = TrainingPeriod.earlyCompetition(
        periodizationPlanId: template.id.toString(),
        orderIndex: 1,
        durationWeeks: 12,
      );
      final peakCompetition = TrainingPeriod.peakCompetition(
        periodizationPlanId: template.id.toString(),
        orderIndex: 2,
        durationWeeks: 16,
      );
      final transition = TrainingPeriod.transition(
        periodizationPlanId: template.id.toString(),
        orderIndex: 3,
        durationWeeks: 6,
      );

      await saveTrainingPeriod(preparation);
      await saveTrainingPeriod(earlyCompetition);
      await saveTrainingPeriod(peakCompetition);
      await saveTrainingPeriod(transition);
    }
  }

  // Helper method to apply template to players based on position preferences
  Future<Map<String, Player?>> applyFormationTemplate(
    FormationTemplate template,
    List<Player> availablePlayers,
  ) async {
    Map<String, Player?> lineup = {};
    List<Player> remainingPlayers = List.from(availablePlayers);

    // Sort players by position preference match
    for (String position in template.positionPreferences.keys) {
      final preferredPositionType = template.positionPreferences[position]!;

      // Find best match from remaining players
      Player? bestMatch;
      for (Player player in remainingPlayers) {
        if (_matchesPosition(player.position, preferredPositionType)) {
          bestMatch = player;
          break;
        }
      }

      if (bestMatch != null) {
        lineup[position] = bestMatch;
        remainingPlayers.remove(bestMatch);
      } else {
        lineup[position] = null;
      }
    }

    return lineup;
  }

  bool _matchesPosition(Position playerPosition, String preferredType) {
    switch (preferredType) {
      case 'goalkeeper':
        return playerPosition == Position.goalkeeper;
      case 'defender':
        return playerPosition == Position.defender;
      case 'midfielder':
        return playerPosition == Position.midfielder;
      case 'forward':
        return playerPosition == Position.forward;
      default:
        return false;
    }
  }

  // =====================================================
  // Training Session Operations
  // =====================================================

  // TrainingSession CRUD operations
  Future<void> saveTrainingSession(TrainingSession session) async {
    session.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _trainingSessions.indexWhere((s) => s.id == session.id);
      if (index >= 0) {
        _trainingSessions[index] = session;
      } else {
        if (session.id == Isar.autoIncrement) {
          session.id = (_trainingSessions.map((s) => s.id).fold(0, (a, b) => a > b ? a : b) + 1);
        }
        _trainingSessions.add(session);
      }
    } else {
      // TODO: Implement Isar save
    }
  }

  Future<TrainingSession?> getTrainingSession(int id) async {
    if (kIsWeb) {
      try {
        return _trainingSessions.firstWhere((s) => s.id == id);
      } catch (_) {
        return null;
      }
    }
    // TODO: Implement Isar get
    return null;
  }

  Future<List<TrainingSession>> getAllTrainingSessions() async {
    if (kIsWeb) {
      return List.from(_trainingSessions);
    }
    // TODO: Implement Isar getAll
    return [];
  }

  Future<List<TrainingSession>> getTrainingSessionsByTeam(String teamId) async {
    if (kIsWeb) {
      return _trainingSessions
          .where((s) => s.teamId == teamId)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<List<TrainingSession>> getUpcomingTrainingSessions() async {
    final now = DateTime.now();
    if (kIsWeb) {
      return _trainingSessions
          .where((s) => s.date.isAfter(now) && s.status == SessionStatus.planned)
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<List<TrainingSession>> getRecentTrainingSessions({int limit = 5}) async {
    if (kIsWeb) {
      final completed = _trainingSessions
          .where((s) => s.status == SessionStatus.completed)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return completed.take(limit).toList();
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<TrainingSession?> getActiveTrainingSession() async {
    if (kIsWeb) {
      try {
        return _trainingSessions.firstWhere((s) => s.status == SessionStatus.inProgress);
      } catch (_) {
        return null;
      }
    }
    // TODO: Implement Isar query
    return null;
  }

  Future<List<TrainingSession>> getTrainingSessionsForDateRange(DateTime start, DateTime end) async {
    if (kIsWeb) {
      return _trainingSessions
          .where((s) => s.date.isAfter(start) && s.date.isBefore(end))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<void> updateTrainingSession(TrainingSession session) async {
    session.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _trainingSessions.indexWhere((s) => s.id == session.id);
      if (index >= 0) {
        _trainingSessions[index] = session;
      }
    } else {
      // TODO: Implement Isar update
    }
  }

  Future<void> deleteTrainingSession(int id) async {
    if (kIsWeb) {
      _trainingSessions.removeWhere((s) => s.id == id);
      // Also delete related exercises
      _trainingExercises.removeWhere((e) => e.trainingSessionId == id.toString());
    } else {
      // TODO: Implement Isar delete
    }
  }

  // SessionPhase CRUD operations
  Future<void> saveSessionPhase(SessionPhase phase) async {
    phase.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _sessionPhases.indexWhere((p) => p.id == phase.id);
      if (index >= 0) {
        _sessionPhases[index] = phase;
      } else {
        if (phase.id == Isar.autoIncrement) {
          phase.id = (_sessionPhases.map((p) => p.id).fold(0, (a, b) => a > b ? a : b) + 1);
        }
        _sessionPhases.add(phase);
      }
    } else {
      // TODO: Implement Isar save
    }
  }

  Future<SessionPhase?> getSessionPhase(int id) async {
    if (kIsWeb) {
      try {
        return _sessionPhases.firstWhere((p) => p.id == id);
      } catch (_) {
        return null;
      }
    }
    // TODO: Implement Isar get
    return null;
  }

  Future<List<SessionPhase>> getAllSessionPhases() async {
    if (kIsWeb) {
      return List.from(_sessionPhases);
    }
    // TODO: Implement Isar getAll
    return [];
  }

  Future<void> updateSessionPhase(SessionPhase phase) async {
    phase.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _sessionPhases.indexWhere((p) => p.id == phase.id);
      if (index >= 0) {
        _sessionPhases[index] = phase;
      }
    } else {
      // TODO: Implement Isar update
    }
  }

  Future<void> deleteSessionPhase(int id) async {
    if (kIsWeb) {
      _sessionPhases.removeWhere((p) => p.id == id);
    } else {
      // TODO: Implement Isar delete
    }
  }

  // PlayerAttendance CRUD operations
  Future<void> savePlayerAttendance(PlayerAttendance attendance) async {
    attendance.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _playerAttendances.indexWhere((a) => a.id == attendance.id);
      if (index >= 0) {
        _playerAttendances[index] = attendance;
      } else {
        if (attendance.id == Isar.autoIncrement) {
          attendance.id = (_playerAttendances.map((a) => a.id).fold(0, (a, b) => a > b ? a : b) + 1);
        }
        _playerAttendances.add(attendance);
      }
    } else {
      // TODO: Implement Isar save
    }
  }

  Future<PlayerAttendance?> getPlayerAttendance(int id) async {
    if (kIsWeb) {
      try {
        return _playerAttendances.firstWhere((a) => a.id == id);
      } catch (_) {
        return null;
      }
    }
    // TODO: Implement Isar get
    return null;
  }

  Future<List<PlayerAttendance>> getAllPlayerAttendances() async {
    if (kIsWeb) {
      return List.from(_playerAttendances);
    }
    // TODO: Implement Isar getAll
    return [];
  }

  Future<List<PlayerAttendance>> getPlayerAttendanceHistory(String playerId) async {
    if (kIsWeb) {
      return _playerAttendances
          .where((a) => a.playerId == playerId)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<void> updatePlayerAttendance(PlayerAttendance attendance) async {
    attendance.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _playerAttendances.indexWhere((a) => a.id == attendance.id);
      if (index >= 0) {
        _playerAttendances[index] = attendance;
      }
    } else {
      // TODO: Implement Isar update
    }
  }

  Future<void> deletePlayerAttendance(int id) async {
    if (kIsWeb) {
      _playerAttendances.removeWhere((a) => a.id == id);
    } else {
      // TODO: Implement Isar delete
    }
  }

  // TrainingExercise CRUD operations
  Future<void> saveTrainingExercise(TrainingExercise exercise) async {
    exercise.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _trainingExercises.indexWhere((e) => e.id == exercise.id);
      if (index >= 0) {
        _trainingExercises[index] = exercise;
    // print('Updated exercise: ${exercise.name} (ID: ${exercise.id})');
      } else {
        if (exercise.id == Isar.autoIncrement) {
          exercise.id = (_trainingExercises.map((e) => e.id).fold(0, (a, b) => a > b ? a : b) + 1);
        }
        _trainingExercises.add(exercise);
    // print('Added new exercise: ${exercise.name} (ID: ${exercise.id}, SessionId: ${exercise.trainingSessionId})');
      }
    // print('Total exercises in database: ${_trainingExercises.length}');
    } else {
      // TODO: Implement Isar save
    }
  }

  Future<TrainingExercise?> getTrainingExercise(int id) async {
    if (kIsWeb) {
      try {
        return _trainingExercises.firstWhere((e) => e.id == id);
      } catch (_) {
        return null;
      }
    }
    // TODO: Implement Isar get
    return null;
  }

  Future<List<TrainingExercise>> getAllTrainingExercises() async {
    if (kIsWeb) {
      return List.from(_trainingExercises);
    }
    // TODO: Implement Isar getAll
    return [];
  }

  Future<List<TrainingExercise>> getExercisesForSession(String sessionId) async {
    if (kIsWeb) {
      return _trainingExercises
          .where((e) => e.trainingSessionId == sessionId)
          .toList()
        ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<List<TrainingExercise>> getLibraryExercises() async {
    if (kIsWeb) {
      final libraryExercises = _trainingExercises
          .where((e) => e.trainingSessionId == "library" || (e.trainingSessionId?.isEmpty ?? true))
          .toList();

    // print('Getting library exercises:');
    // print('Total exercises: ${_trainingExercises.length}');
    // print('Library exercises: ${libraryExercises.length}');
      for (final _ in libraryExercises) {
    // print('- ${exercise.name} (SessionId: ${exercise.trainingSessionId})');
      }

      return libraryExercises;
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<List<TrainingExercise>> getExercisesByType(ExerciseType type) async {
    if (kIsWeb) {
      return _trainingExercises.where((e) => e.type == type).toList();
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<void> updateTrainingExercise(TrainingExercise exercise) async {
    exercise.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _trainingExercises.indexWhere((e) => e.id == exercise.id);
      if (index >= 0) {
        _trainingExercises[index] = exercise;
      }
    } else {
      // TODO: Implement Isar update
    }
  }

  Future<void> deleteTrainingExercise(int id) async {
    if (kIsWeb) {
      _trainingExercises.removeWhere((e) => e.id == id);
    } else {
      // TODO: Implement Isar delete
    }
  }

  // Training Session Helper Methods
  Future<TrainingSession> createSessionFromTemplate({
    required String teamId,
    required DateTime date,
    required TrainingType type,
    int? trainingNumber,
  }) async {
    final allSessions = await getTrainingSessionsByTeam(teamId);
    final nextNumber = trainingNumber ?? (allSessions.length + 1);

    final session = TrainingSession.create(
      teamId: teamId,
      date: date,
      trainingNumber: nextNumber,
      type: type,
    );

    // Add standard phases based on VOAB template
    final phases = <SessionPhase>[
      SessionPhase.trainingSetup(start: date),
      SessionPhase.warmup(start: date.add(const Duration(minutes: 10))),
      SessionPhase.mainTraining(start: date.add(const Duration(minutes: 25))),
      SessionPhase.evaluation(start: date.add(const Duration(minutes: 85))),
      SessionPhase.cooldown(start: date.add(const Duration(minutes: 95))),
    ];

    session.phases = phases;

    // Set default warmup activities
    session.warmupActivities = [
      "Bal raken en bewegen",
      "Dynamische warming-up",
      "Korte passing oefening",
      "Beweeglijkheid en coördinatie",
    ];

    await saveTrainingSession(session);
    return session;
  }

  Future<void> markSessionInProgress(int sessionId) async {
    final session = await getTrainingSession(sessionId);
    if (session != null) {
      final updatedSession = session.copyWith(
        status: SessionStatus.inProgress,
        startTime: DateTime.now(),
      );
      await updateTrainingSession(updatedSession);
    }
  }

  Future<void> completeSession(int sessionId, {String? evaluation}) async {
    final session = await getTrainingSession(sessionId);
    if (session != null) {
      final updatedSession = session.copyWith(
        status: SessionStatus.completed,
        endTime: DateTime.now(),
        postSessionEvaluation: evaluation,
      );
      await updateTrainingSession(updatedSession);
    }
  }

  Future<Map<String, dynamic>> getTrainingSessionStatistics() async {
    final sessions = await getAllTrainingSessions();
    final completedSessions = sessions.where((s) => s.status == SessionStatus.completed).toList();

    final totalSessions = sessions.length;
    final avgAttendance = completedSessions.isNotEmpty
        ? completedSessions.map((s) => s.attendancePercentage).reduce((a, b) => a + b) / completedSessions.length
        : 0.0;

    final exerciseTypes = <ExerciseType, int>{};
    for (final exercise in _trainingExercises) {
      exerciseTypes[exercise.type] = (exerciseTypes[exercise.type] ?? 0) + 1;
    }

    return {
      'totalSessions': totalSessions,
      'completedSessions': completedSessions.length,
      'upcomingSessions': sessions.where((s) => s.status == SessionStatus.planned).length,
      'avgAttendancePercentage': avgAttendance,
      'totalExercises': _trainingExercises.length,
      'exercisesByType': exerciseTypes,
      'lastSessionDate': sessions.isNotEmpty ? sessions.map((s) => s.date).reduce((a, b) => a.isAfter(b) ? a : b) : null,
    };
  }

  // =====================================================
  // PeriodizationPlan Operations (restored)
  // =====================================================

  Future<void> savePeriodizationPlan(PeriodizationPlan plan) async {
    plan.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _periodizationPlans.indexWhere((p) => p.id == plan.id);
      if (index >= 0) {
        _periodizationPlans[index] = plan;
      } else {
        if (plan.id == Isar.autoIncrement) {
          plan.id = (_periodizationPlans.map((p) => p.id).fold(0, (a, b) => a > b ? a : b) + 1);
        }
        _periodizationPlans.add(plan);
      }
    } else {
      // TODO: Implement Isar save
    }
  }

  Future<PeriodizationPlan?> getPeriodizationPlan(int id) async {
    if (kIsWeb) {
      try {
        return _periodizationPlans.firstWhere((p) => p.id == id);
      } catch (_) {
        return null;
      }
    }
    // TODO: Implement Isar get
    return null;
  }

  Future<List<PeriodizationPlan>> getAllPeriodizationPlans() async {
    if (kIsWeb) {
      return List.from(_periodizationPlans);
    }
    // TODO: Implement Isar getAll
    return [];
  }

  Future<List<PeriodizationPlan>> getPeriodizationPlanTemplates() async {
    if (kIsWeb) {
      return _periodizationPlans.where((p) => p.isTemplate).toList();
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<List<PeriodizationPlan>> getPeriodizationPlansByAgeGroup(AgeGroup ageGroup) async {
    if (kIsWeb) {
      return _periodizationPlans.where((p) => p.targetAgeGroup == ageGroup).toList();
    }
    // TODO: Implement Isar query
    return [];
  }

  Future<void> updatePeriodizationPlan(PeriodizationPlan plan) async {
    plan.updatedAt = DateTime.now();
    if (kIsWeb) {
      final index = _periodizationPlans.indexWhere((p) => p.id == plan.id);
      if (index >= 0) {
        _periodizationPlans[index] = plan;
      }
    } else {
      // TODO: Implement Isar update
    }
  }

  Future<void> deletePeriodizationPlan(int id) async {
    if (kIsWeb) {
      _periodizationPlans.removeWhere((p) => p.id == id);
    } else {
      // TODO: Implement Isar delete
    }
  }
}
