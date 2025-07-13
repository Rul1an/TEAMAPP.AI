// Package imports:
import 'package:uuid/uuid.dart';

// Project imports:
import '../models/club/club.dart';
import '../models/club/team.dart';
import '../models/match.dart';
import '../models/player.dart';
import '../models/training_session/training_session.dart';
import '../providers/demo_mode_provider.dart';

class DemoDataService {
  static const _uuid = Uuid();

  static Map<String, dynamic> generateDemoData(DemoRole role) {
    switch (role) {
      case DemoRole.clubAdmin:
      case DemoRole.boardMember:
        return _generateAdminData();
      case DemoRole.technicalCommittee:
        return _generateTechnicalData();
      case DemoRole.coach:
      case DemoRole.assistantCoach:
        return _generateCoachData();
      case DemoRole.player:
        return _generatePlayerData();
    }
  }

  static Map<String, dynamic> _generateAdminData() {
    final club = _createDemoClub();
    final teams = _createDemoTeams(club.id);
    final allPlayers = <Player>[];

    for (final team in teams) {
      allPlayers.addAll(_createDemoPlayers(18, teamId: team.id));
    }

    return {
      'club': club,
      'teams': teams,
      'players': allPlayers,
      'coaches': _createDemoCoaches(),
      'matches': _createDemoMatches(teams.first.id),
      'trainings': _createDemoTrainings(teams.first.id),
    };
  }

  static Map<String, dynamic> _generateTechnicalData() {
    final data = _generateAdminData();
    // Add technical specific data
    data['assessments'] = _createDemoAssessments();
    data['playerStats'] = _createDemoPlayerStats();
    return data;
  }

  static Map<String, dynamic> _generateCoachData() {
    final teamId = _uuid.v4();
    final players = _createDemoPlayers(18, teamId: teamId);

    return {
      'team': _createDemoTeam(teamId: teamId, name: 'JO17-1'),
      'players': players,
      'trainings': _createDemoTrainings(teamId),
      'matches': _createDemoMatches(teamId),
    };
  }

  static Map<String, dynamic> _generatePlayerData() {
    final playerId = _uuid.v4();
    final teamId = _uuid.v4();

    return {
      'profile': _createDemoPlayerProfile(playerId),
      'team': _createDemoTeam(teamId: teamId, name: 'JO17-1'),
      'schedule': <dynamic>[], // Empty for now
      'stats': _createDemoPlayerStats(playerId),
    };
  }

  static Club _createDemoClub() => Club(
    id: 'demo-club-voab',
    name: 'VOAB Utrecht',
    shortName: 'VOAB',
    logoUrl: 'https://placehold.co/200x200/1976d2/ffffff?text=VOAB',
    colors: '#1976d2,#ffffff',
    foundedDate: DateTime(1928),
    street: 'Sportpark Overvecht',
    city: 'Utrecht',
    country: 'Nederland',
    website: 'https://voab.nl',
    settings: const ClubSettings(),
    status: ClubStatus.active,
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
    updatedAt: DateTime.now(),
  );

  static List<Team> _createDemoTeams(String clubId) => [
    Team(
      id: _uuid.v4(),
      clubId: clubId,
      name: 'JO17-1',
      shortName: 'JO17-1',
      ageCategory: AgeCategory.jo17,
      level: TeamLevel.competitive,
      gender: TeamGender.male,
      currentSeason: '2024-2025',
      league: 'KNVB',
      division: '1e klasse',
      headCoachId: _uuid.v4(),
      assistantCoachId: _uuid.v4(),
      settings: const TeamSettings(),
      status: TeamStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      updatedAt: DateTime.now(),
    ),
    Team(
      id: _uuid.v4(),
      clubId: clubId,
      name: 'JO17-2',
      shortName: 'JO17-2',
      ageCategory: AgeCategory.jo17,
      level: TeamLevel.recreational,
      gender: TeamGender.male,
      currentSeason: '2024-2025',
      league: 'KNVB',
      division: '3e klasse',
      headCoachId: _uuid.v4(),
      settings: const TeamSettings(),
      status: TeamStatus.active,
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      updatedAt: DateTime.now(),
    ),
  ];

  static Team _createDemoTeam({required String teamId, required String name}) =>
      Team(
        id: teamId,
        clubId: 'demo-club-voab',
        name: name,
        shortName: name,
        ageCategory: AgeCategory.jo17,
        level: TeamLevel.competitive,
        gender: TeamGender.male,
        currentSeason: '2024-2025',
        league: 'KNVB',
        division: '1e klasse',
        headCoachId: _uuid.v4(),
        assistantCoachId: _uuid.v4(),
        settings: const TeamSettings(),
        status: TeamStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        updatedAt: DateTime.now(),
      );

  static List<Player> _createDemoPlayers(int count, {String? teamId}) {
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
    final players = <Player>[];

    for (var i = 0; i < count; i++) {
      final position = i == 0
          ? Position.goalkeeper
          : positions[(i - 1) % (positions.length - 1) + 1];
      final names = _generateDutchName().split(' ');

      final player = Player()
        ..id = _uuid.v4()
        ..firstName = names[0]
        ..lastName = names.length > 1 ? names[1] : ''
        ..jerseyNumber = i + 1
        ..position = position
        ..birthDate = DateTime.now().subtract(Duration(days: 16 * 365 + i * 30))
        ..preferredFoot = i % 3 == 0 ? PreferredFoot.left : PreferredFoot.right
        ..height = 165.0 + (i * 2)
        ..weight = 55.0 + (i * 1.5)
        ..matchesPlayed = 8 + (i % 3)
        ..goals = i > 7 ? 3 + i : 0
        ..assists = i > 5 ? 2 + (i % 3) : 0
        ..trainingsAttended = 18 + (i % 5)
        ..trainingsTotal = 20;

      players.add(player);
    }

    return players;
  }

  static Player _createDemoPlayerProfile(String playerId) {
    final player = Player()
      ..id = playerId
      ..firstName = 'Robin'
      ..lastName = 'van der Berg'
      ..jerseyNumber = 10
      ..position = Position.midfielder
      ..birthDate = DateTime.now().subtract(
        const Duration(days: 16 * 365 + 180),
      )
      ..preferredFoot = PreferredFoot.right
      ..height = 175.0
      ..weight = 68.0
      ..email = 'robin.vanderberg@demo.nl'
      ..phoneNumber = '06-12345678'
      ..matchesPlayed = 14
      ..goals = 8
      ..assists = 12
      ..trainingsAttended = 28
      ..trainingsTotal = 30;

    return player;
  }

  static List<Match> _createDemoMatches(String teamId) {
    final opponents = [
      'Ajax JO17',
      'PSV JO17',
      'Feyenoord JO17',
      'AZ JO17',
      'Vitesse JO17',
      'FC Utrecht JO17',
      'FC Twente JO17',
    ];

    final matches = <Match>[];
    final now = DateTime.now();

    // Past matches
    for (var i = 3; i >= 1; i--) {
      final date = now.subtract(Duration(days: i * 7));
      final match = Match()
        ..id = _uuid.v4()
        ..date = date
        ..teamId = teamId
        ..opponent = opponents[i % opponents.length]
        ..location = i.isEven ? Location.home : Location.away
        ..competition = Competition.league
        ..status = MatchStatus.completed
        ..venue = i.isEven ? 'Sportpark Overvecht' : 'Uitstadion'
        ..teamScore = i.isEven ? 2 : 1
        ..opponentScore = i.isEven ? 1 : 2;

      matches.add(match);
    }

    // Upcoming matches
    for (var i = 1; i <= 4; i++) {
      final date = now.add(Duration(days: i * 7));
      final match = Match()
        ..id = _uuid.v4()
        ..date = date
        ..teamId = teamId
        ..opponent = opponents[(i + 3) % opponents.length]
        ..location = i.isEven ? Location.away : Location.home
        ..competition = Competition.league
        ..status = MatchStatus.scheduled
        ..venue = i.isEven ? 'Uitstadion' : 'Sportpark Overvecht';

      matches.add(match);
    }

    return matches;
  }

  static List<TrainingSession> _createDemoTrainings(String teamId) {
    final sessions = <TrainingSession>[];
    final now = DateTime.now();

    // Create trainings for the next 2 weeks
    for (var week = 0; week < 2; week++) {
      // Tuesday training
      final tuesday = now.add(
        Duration(days: (2 - now.weekday + 7 * week) % 7 + 7 * week),
      );
      if (tuesday.isAfter(now)) {
        sessions
          ..add(_createTrainingSession(teamId, tuesday, 'Techniek & Passing'))
          ..add(
            _createTrainingSession(
              teamId,
              tuesday.add(const Duration(days: 7)),
              'Tactiek & Positiespel',
            ),
          );
      }
    }

    return sessions;
  }

  static TrainingSession _createTrainingSession(
    String teamId,
    DateTime date,
    String focus,
  ) {
    return TrainingSession.create(teamId: teamId, date: date, trainingNumber: 1)
      ..id = _uuid.v4()
      ..sessionObjective = focus
      ..technicalTacticalGoal = focus
      ..startTime = DateTime(date.year, date.month, date.day, 19)
      ..endTime = DateTime(date.year, date.month, date.day, 20, 30)
      ..durationMinutes = 90;
  }

  static List<Map<String, dynamic>> _createDemoCoaches() => [
    {
      'id': _uuid.v4(),
      'name': 'Johan de Vries',
      'role': 'Hoofdtrainer',
      'email': 'johan.devries@voab.nl',
      'phone': '06-11111111',
      'licenseLevel': 'UEFA B',
    },
    {
      'id': _uuid.v4(),
      'name': 'Henk Jansen',
      'role': 'Assistent Trainer',
      'email': 'henk.jansen@voab.nl',
      'phone': '06-22222222',
      'licenseLevel': 'TC3',
    },
  ];

  static List<Map<String, dynamic>> _createDemoAssessments() =>
      // Technical assessments data
      [];
  static Map<String, dynamic> _createDemoPlayerStats([String? playerId]) => {
    'goals': 8,
    'assists': 12,
    'yellowCards': 2,
    'redCards': 0,
    'trainingsAttended': 28,
    'trainingsTotal': 30,
    'matchesPlayed': 14,
    'matchesTotal': 15,
    'averageRating': 7.5,
  };

  static String _generateDutchName() {
    final firstNames = [
      'Jan',
      'Piet',
      'Klaas',
      'Henk',
      'Willem',
      'Jeroen',
      'Mark',
      'Dennis',
      'Robin',
      'Thomas',
      'Lars',
      'Niels',
      'Bram',
      'Tim',
      'Sven',
      'Daan',
      'Luuk',
      'Jesse',
      'Ruben',
      'Tom',
      'Max',
      'Finn',
      'Sem',
      'Lucas',
    ];

    final lastNames = [
      'de Jong',
      'Jansen',
      'de Vries',
      'van den Berg',
      'van Dijk',
      'Bakker',
      'Visser',
      'Smit',
      'Meijer',
      'de Boer',
      'Mulder',
      'de Groot',
      'Bos',
      'Vos',
      'Peters',
      'Hendriks',
      'van der Meer',
      'van der Linden',
      'Dekker',
      'Brouwer',
      'de Wit',
      'Dijkstra',
      'van Leeuwen',
      'de Bruijn',
      'van der Heijden',
    ];

    final firstName =
        firstNames[DateTime.now().millisecond % firstNames.length];
    final lastName = lastNames[DateTime.now().microsecond % lastNames.length];

    return '$firstName $lastName';
  }
}
