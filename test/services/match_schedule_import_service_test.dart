import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/repositories/match_repository.dart';
import 'package:jo17_tactical_manager/services/match_schedule_import_service.dart';
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:mocktail/mocktail.dart';

class _MockMatchRepository extends Mock implements MatchRepository {}

void main() {
  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(Match());
  });

  group('MatchScheduleImportService', () {
    late _MockMatchRepository repo;
    late MatchScheduleImportService service;

    setUp(() {
      repo = _MockMatchRepository();
      service = MatchScheduleImportService(repo);
    });

    test('preview detects duplicates and new records', () async {
      // Existing match in repository (duplicate)
      final existing = Match()
        ..date = DateTime(2025, 8, 15)
        ..opponent = 'Ajax'
        ..venue = 'Home Field'
        ..location = Location.home
        ..competition = Competition.league
        ..id = 'team1';

      when(() => repo.getAll()).thenAnswer((_) async => Success([existing]));

      // CSV with duplicate of existing and a new record
      final csvContent = '''match_date,opponent,venue,team_id
2025-08-15,Ajax,Home Field,team1
2025-08-22,Feyenoord,Home Field,team1
''';
      final preview = await service.previewCsv(Uint8List.fromList(csvContent.codeUnits));

      expect(preview.duplicateCount, 1);
      expect(preview.newCount, 1);
      expect(preview.errorCount, 0);
    });

    test('persist saves only new records', () async {
      when(() => repo.getAll()).thenAnswer((_) async => const Success([]));
      when(() => repo.add(any())).thenAnswer((_) async => const Success(null));

      // CSV with two new records
      final csvContent = '''match_date,opponent,venue,team_id
2025-08-15,Ajax,Home Field,team1
2025-08-22,Feyenoord,Home Field,team1
''';
      final preview = await service.previewCsv(Uint8List.fromList(csvContent.codeUnits));

      final result = await service.persist(preview);

      expect(result, isA<Success<int>>());
      expect((result as Success<int>).data, 2);
      // Verify add called twice
      verify(() => repo.add(any())).called(2);
    });
  });
}