import 'dart:convert';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// Project imports:
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/providers/players_provider.dart';
import 'package:jo17_tactical_manager/repositories/player_repository.dart';
import 'package:jo17_tactical_manager/screens/players/players_screen.dart';

// ---------------------------------------------------------------------------
// Mocks & fakes
// ---------------------------------------------------------------------------

class _MockPlayerRepository extends Mock implements PlayerRepository {}

class _FakePlayer extends Fake implements Player {}

/// Simple in-memory implementation of [FilePicker] used to stub `pickFiles()`.
class _FakeFilePicker extends FilePicker with MockPlatformInterfaceMixin {
  _FakeFilePicker(this._result);

  final FilePickerResult? _result;

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = false,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async => _result;

  // The remaining abstract methods are not used by the test.
  @override
  Future<bool?> clearTemporaryFiles() async => true;

  @override
  Future<String?> getDirectoryPath({
    String? dialogTitle,
    bool lockParentWindow = false,
    String? initialDirectory,
  }) async => null;

  @override
  Future<List<String>?> pickFileAndDirectoryPaths({
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  }) async => null;

  @override
  Future<String?> saveFile({
    String? dialogTitle,
    String? fileName,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Uint8List? bytes,
    bool lockParentWindow = false,
  }) async => null;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Builds a CSV string with [rowCount] player rows (+ header).
String _buildCsv(int rowCount) {
  final buffer = StringBuffer()
    ..writeln(
        'Voornaam,Achternaam,Rugnummer,Geboortedatum,Positie,Lengte,Gewicht,Voorkeursbeen');
  for (var i = 1; i <= rowCount; i++) {
    buffer.writeln(
        'First$i,Last$i,$i,01-01-2008,Middenvelder,170,60,Rechts');
  }
  return buffer.toString();
}

// ---------------------------------------------------------------------------
// Test
// ---------------------------------------------------------------------------

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Integration – Import bulk-edit flow', () {
    const rows = 10000;

    late _MockPlayerRepository mockRepo;

    setUpAll(() {
      registerFallbackValue<_FakePlayer>(_FakePlayer());
    });

    setUp(() {
      mockRepo = _MockPlayerRepository();
      when(() => mockRepo.add(any()))
          .thenAnswer((_) async => const Success<void>(null));

      final csv = _buildCsv(rows);
      final bytes = Uint8List.fromList(utf8.encode(csv));
      final fileResult = FilePickerResult([
        PlatformFile(
          name: 'players.csv',
          size: bytes.length,
          bytes: bytes,
          extension: 'csv',
        ),
      ]);

      // Inject fake picker globally.
      FilePicker.platform = _FakeFilePicker(fileResult);
    });

    testWidgets(
      'CSV 10k rows → import completes < 4 s with success snackbar',
      (tester) async {
        // Build screen with mocked repository.
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              playerRepositoryProvider.overrideWith((ref) => mockRepo),
            ],
            child: const MaterialApp(home: PlayersScreen()),
          ),
        );

        await tester.pumpAndSettle();

        final stopwatch = Stopwatch()..start();

        // Trigger the import via toolbar icon.
        await tester.tap(find.byIcon(Icons.upload_file));
        await tester.pumpAndSettle();

        stopwatch.stop();

        // Performance assertion (< 4 s).
        expect(stopwatch.elapsed.inSeconds, lessThan(4),
            reason: 'Preview duurde te lang (> 4 s)');

        // Validate success message contains imported count.
        expect(find.textContaining('$rows spelers'), findsOneWidget);

        // Repository `add` should have been invoked [rows] times.
        verify(() => mockRepo.add(any())).called(rows);
      },
    );
  });
}