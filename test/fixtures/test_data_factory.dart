// test/fixtures/test_data_factory.dart
import 'package:uuid/uuid.dart';

/// Test data factory voor Nederlandse voetbal context (2025 Edition)
///
/// Deze factory creëert realistische test data voor JO17 Nederlandse voetbalteams
/// met focus op VOAB methodologie en Nederlandse terminologie
///
/// Features:
/// - Proper UUID generation for database compatibility
/// - Realistic Dutch football data
/// - Performance-optimized test scenarios
/// - Modern testing patterns for 2025
class TestDataFactory {
  static const _uuid = Uuid();

  // Generate proper UUIDs for testing
  static String generateUUID() => _uuid.v4();
  static String generateValidSlug() =>
      'test-org-${DateTime.now().millisecondsSinceEpoch}';

  static const String voabOrganizationId = 'voab_jo17_test';

  /// Test organization data (VOAB JO17-1)
  static Map<String, dynamic> voabOrganization() => {
        'id': voabOrganizationId,
        'name': 'VOAB JO17-1 Test',
        'subscription_tier': 'pro',
        'settings': {
          'methodology': 'voab',
          'language': 'nl',
          'timezone': 'Europe/Amsterdam',
        },
      };

  /// Nederlandse JO17 spelers voor realistische test scenarios
  static List<Map<String, dynamic>> dutchYouthPlayers() => [
        {
          'id': 'player_001',
          'name': 'Jan van der Berg',
          'position': 'Aanvaller',
          'birth_date': DateTime(2007, 3, 15).toIso8601String(),
          'organization_id': voabOrganizationId,
          'jersey_number': 9,
          'is_active': true,
        },
        {
          'id': 'player_002',
          'name': 'Piet de Vries',
          'position': 'Middenvelder',
          'birth_date': DateTime(2007, 8, 22).toIso8601String(),
          'organization_id': voabOrganizationId,
          'jersey_number': 10,
          'is_active': true,
        },
        {
          'id': 'player_003',
          'name': 'Kees Jansen',
          'position': 'Verdediger',
          'birth_date': DateTime(2007, 1, 5).toIso8601String(),
          'organization_id': voabOrganizationId,
          'jersey_number': 4,
          'is_active': true,
        },
        {
          'id': 'player_004',
          'name': 'Lars van Dijk',
          'position': 'Keeper',
          'birth_date': DateTime(2007, 11, 18).toIso8601String(),
          'organization_id': voabOrganizationId,
          'jersey_number': 1,
          'is_active': true,
        },
        {
          'id': 'player_005',
          'name': 'Ruben Bakker',
          'position': 'Verdediger',
          'birth_date': DateTime(2007, 6, 30).toIso8601String(),
          'organization_id': voabOrganizationId,
          'jersey_number': 5,
          'is_active': true,
        },
        {
          'id': 'player_006',
          'name': 'Sem de Jong',
          'position': 'Middenvelder',
          'birth_date': DateTime(2007, 4, 12).toIso8601String(),
          'organization_id': voabOrganizationId,
          'jersey_number': 8,
          'is_active': true,
        },
        {
          'id': 'player_007',
          'name': 'Max Hendriks',
          'position': 'Aanvaller',
          'birth_date': DateTime(2007, 9, 8).toIso8601String(),
          'organization_id': voabOrganizationId,
          'jersey_number': 11,
          'is_active': true,
        },
        {
          'id': 'player_008',
          'name': 'Tim Mulder',
          'position': 'Verdediger',
          'birth_date': DateTime(2007, 2, 25).toIso8601String(),
          'organization_id': voabOrganizationId,
          'jersey_number': 3,
          'is_active': true,
        },
      ];

  /// VOAB training session met Nederlandse terminologie
  static Map<String, dynamic> voabTrainingSession() => {
        'id': 'session_001',
        'title': 'Aanvallend spel - Acquisitie fase',
        'morphocycle_phase': 'acquisitie',
        'duration_minutes': 90,
        'organization_id': voabOrganizationId,
        'created_at': DateTime.now().toIso8601String(),
        'exercises': [
          {
            'id': 'exercise_001',
            'name': 'Passing onder druk',
            'duration_minutes': 20,
            'category': 'technical',
            'difficulty': 3,
            'player_count': '6-8',
            'equipment': ['Pionnen', 'Ballen', 'Hesjes'],
            'description':
                'Korte passing oefening met focus op techniek onder druk',
            'morphocycle_focus': 'acquisitie',
          },
          {
            'id': 'exercise_002',
            'name': 'Kleine speelvorm 4v4',
            'duration_minutes': 25,
            'category': 'tactical',
            'difficulty': 4,
            'player_count': '8',
            'equipment': ['Doeltjes', 'Hesjes', 'Ballen'],
            'description':
                'Kleine speelvorm gericht op positiespel en druk zetten',
            'morphocycle_focus': 'acquisitie',
          },
          {
            'id': 'exercise_003',
            'name': 'Afwerking in de 16',
            'duration_minutes': 15,
            'category': 'technical',
            'difficulty': 3,
            'player_count': '4-6',
            'equipment': ['Ballen', 'Doel'],
            'description': 'Afwerking oefening vanuit verschillende hoeken',
            'morphocycle_focus': 'acquisitie',
          },
        ],
        'attendance': dutchYouthPlayers()
            .take(6)
            .map((player) => {
                  'player_id': player['id'],
                  'status': 'present',
                  'arrival_time': DateTime.now()
                      .subtract(Duration(minutes: 30))
                      .toIso8601String(),
                })
            .toList(),
      };

  /// Nederlandse oefeningen library
  static List<Map<String, dynamic>> dutchExercises() => [
        {
          'id': 'ex_passing_001',
          'name': 'Passing onder druk',
          'category': 'technical',
          'morphocycle_phase': 'acquisitie',
          'duration_minutes': 20,
          'difficulty': 3,
          'tags': ['passing', 'druk', 'techniek'],
          'description': 'Korte passing oefening met verdedigende druk',
        },
        {
          'id': 'ex_passing_002',
          'name': 'Korte passing',
          'category': 'technical',
          'morphocycle_phase': 'acquisitie',
          'duration_minutes': 15,
          'difficulty': 2,
          'tags': ['passing', 'techniek', 'basis'],
          'description': 'Basis passing oefening voor techniek ontwikkeling',
        },
        {
          'id': 'ex_tactical_001',
          'name': '1v1 duels',
          'category': 'tactical',
          'morphocycle_phase': 'acquisitie',
          'duration_minutes': 18,
          'difficulty': 4,
          'tags': ['duel', 'verdediging', 'aanval'],
          'description': '1 tegen 1 situaties in verschillende zones',
        },
        {
          'id': 'ex_physical_001',
          'name': 'Sprint intervals',
          'category': 'physical',
          'morphocycle_phase': 'activatie',
          'duration_minutes': 12,
          'difficulty': 5,
          'tags': ['sprint', 'conditie', 'snelheid'],
          'description': 'Hoge intensiteit sprint training voor explosiviteit',
        },
        {
          'id': 'ex_set_pieces_001',
          'name': 'Hoekschop training',
          'category': 'set_pieces',
          'morphocycle_phase': 'acquisitie',
          'duration_minutes': 15,
          'difficulty': 3,
          'tags': ['hoekschop', 'standaardsituatie', 'tactiek'],
          'description': 'Hoekschop varianten voor aanvallende situaties',
        },
        {
          'id': 'ex_tactical_002',
          'name': 'Spelhervatting',
          'category': 'tactical',
          'morphocycle_phase': 'acquisitie',
          'duration_minutes': 20,
          'difficulty': 4,
          'tags': ['spelhervatting', 'opbouw', 'druk'],
          'description': 'Opbouw van achteruit onder druk van tegenstander',
        },
      ];

  /// Performance ratings voor Nederlandse context
  static List<Map<String, dynamic>> performanceRatings() => [
        {
          'id': 'rating_001',
          'player_id': 'player_001',
          'session_id': 'session_001',
          'ratings': {
            'passing': 4,
            'verdedigen': 3,
            'mentaliteit': 5,
            'techniek': 4,
            'fysiek': 3,
          },
          'notes':
              'Goede ontwikkeling in aanvallend spel. Focus op verdediging.',
          'created_at': DateTime.now().toIso8601String(),
        },
        {
          'id': 'rating_002',
          'player_id': 'player_002',
          'session_id': 'session_001',
          'ratings': {
            'passing': 5,
            'verdedigen': 4,
            'mentaliteit': 4,
            'techniek': 5,
            'fysiek': 4,
          },
          'notes': 'Uitstekende technische vaardigheden. Leiderschap getoond.',
          'created_at': DateTime.now().toIso8601String(),
        },
      ];

  /// Test match data
  static Map<String, dynamic> testMatch() => {
        'id': 'match_001',
        'opponent': 'FC Utrecht JO17',
        'date': DateTime.now().add(Duration(days: 7)).toIso8601String(),
        'location': 'Sportpark De Koerbelt',
        'type': 'friendly',
        'organization_id': voabOrganizationId,
        'lineup': dutchYouthPlayers()
            .take(11)
            .map((player) => {
                  'player_id': player['id'],
                  'position': player['position'],
                  'starting': true,
                })
            .toList(),
      };

  /// Nederlandse search terms voor testing
  static List<String> dutchSearchTerms() => [
        'passing',
        'verdedigen',
        'aanvallen',
        'techniek',
        'tactiek',
        'conditie',
        'duels',
        'afwerking',
        'opbouw',
        'druk zetten',
        'positiespel',
        'omschakeling',
        'spelhervatting',
        'hoekschoppen',
        'vrije trappen',
      ];

  /// VOAB morphocycle phases
  static List<String> morphocyclePhases() =>
      ['acquisitie', 'transformatie', 'realisatie', 'activatie'];

  /// Nederlandse equipment terms
  static List<String> dutchEquipment() => [
        'Ballen',
        'Pionnen',
        'Hesjes',
        'Doeltjes',
        'Hoedjes',
        'Ladders',
        'Paaltjes',
        'Markers',
        'Doel',
        'Keepershandschoenen',
      ];

  /// Test organization settings
  static Map<String, dynamic> organizationSettings() => {
        'methodology': 'voab',
        'language': 'nl',
        'timezone': 'Europe/Amsterdam',
        'season_start': DateTime(2024, 8, 1).toIso8601String(),
        'season_end': DateTime(2025, 6, 30).toIso8601String(),
        'training_days': ['tuesday', 'thursday'],
        'match_day': 'saturday',
      };

  /// Generate realistic Nederlandse namen
  static List<String> generateDutchNames(int count) {
    final firstNames = [
      'Jan',
      'Piet',
      'Kees',
      'Lars',
      'Ruben',
      'Sem',
      'Max',
      'Tim',
      'Daan',
      'Bram',
      'Thijs',
      'Niels',
      'Sven',
      'Joep',
      'Cas',
      'Finn'
    ];

    final lastNames = [
      'van der Berg',
      'de Vries',
      'Jansen',
      'van Dijk',
      'Bakker',
      'de Jong',
      'Hendriks',
      'Mulder',
      'Peters',
      'van Leeuwen',
      'de Wit',
      'Smit',
      'Janssen',
      'van den Berg',
      'Visser'
    ];

    final names = <String>[];
    for (int i = 0; i < count; i++) {
      final firstName = firstNames[i % firstNames.length];
      final lastName = lastNames[i % lastNames.length];
      names.add('$firstName $lastName');
    }
    return names;
  }

  /// Create full team roster (25 players)
  static List<Map<String, dynamic>> fullTeamRoster() {
    final names = generateDutchNames(25);
    final positions = ['Keeper', 'Verdediger', 'Middenvelder', 'Aanvaller'];

    return List.generate(
        25,
        (index) => {
              'id': 'player_${(index + 1).toString().padLeft(3, '0')}',
              'name': names[index],
              'position': positions[index % 4],
              'birth_date': DateTime(2007, (index % 12) + 1, (index % 28) + 1)
                  .toIso8601String(),
              'organization_id': voabOrganizationId,
              'jersey_number': index + 1,
              'is_active': index < 23, // 23 active players, 2 inactive
            });
  }
}
