import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jo17_tactical_manager/services/player_roster_import_service.dart';
import 'package:jo17_tactical_manager/repositories/player_repository.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/providers/import_providers.dart';
import 'package:jo17_tactical_manager/providers/players_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jo17_tactical_manager/core/result.dart';

class _MockPlayerRepo extends Mock implements PlayerRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Player import preview & persist', (tester) async {
    final repo = _MockPlayerRepo();
    when(()=>repo.getAll()).thenAnswer((_) async => const Success(<Player>[]));
    when(()=>repo.add(any())).thenAnswer((_) async => const Success(null));

    final container = ProviderContainer(overrides: [
      playerRepositoryProvider.overrideWithValue(repo),
      playerRosterImportServiceProvider.overrideWithValue(PlayerRosterImportService(repo)),
    ]);

    final service = container.read(playerRosterImportServiceProvider);

    final csv = '''first_name,last_name,birth_date,jersey_number,position
Jan,Jansen,2008-03-15,10,Middenvelder
Piet,Pietersen,2009-05-20,9,Aanvaller
''';

    final preview = await service.previewCsv(Uint8List.fromList(csv.codeUnits));
    expect(preview.newCount, 2);

    final res = await service.persist(preview);
    expect(res.isSuccess, true);
    verify(()=>repo.add(any())).called(2);
  });
}