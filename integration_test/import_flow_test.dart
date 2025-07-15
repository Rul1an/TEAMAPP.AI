import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/providers/import_providers.dart';
import 'package:jo17_tactical_manager/repositories/match_repository.dart';
import 'package:jo17_tactical_manager/services/match_schedule_import_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class _MockMatchRepository extends Mock implements MatchRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full import flow: preview -> persist', (tester) async {
    final repo = _MockMatchRepository();

    // Provide default behavior
    when(() => repo.getAll()).thenAnswer((_) async => const Success([]));
    when(() => repo.add(any())).thenAnswer((_) async => const Success(null));

    final container = ProviderContainer(overrides: [
      matchRepositoryProvider.overrideWithValue(repo),
      matchScheduleImportServiceProvider.overrideWithValue(
        MatchScheduleImportService(repo),
      ),
    ]);

    final service = container.read(matchScheduleImportServiceProvider);

    final csvContent = '''match_date,opponent,venue,team_id
2025-08-15,Ajax,Home Field,team1
2025-08-22,Feyenoord,Uit,team1
''';
    final preview = await service.previewCsv(Uint8List.fromList(csvContent.codeUnits));
    expect(preview.newCount, 2);
    expect(preview.errorCount, 0);

    final result = await service.persist(preview);
    expect(result.isSuccess, isTrue);
    verify(() => repo.add(any())).called(2);
  });
}