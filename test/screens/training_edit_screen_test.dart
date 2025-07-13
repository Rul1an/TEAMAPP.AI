import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:jo17_tactical_manager/models/training.dart';
import 'package:jo17_tactical_manager/screens/training/training_edit_screen.dart';
import 'package:jo17_tactical_manager/repositories/training_repository.dart';
import 'package:jo17_tactical_manager/providers/trainings_provider.dart';
import 'package:jo17_tactical_manager/core/result.dart';

class _MockTrainingRepo implements TrainingRepository {
  _MockTrainingRepo();

  final _saved = <Training>[];

  @override
  Future<Result<void>> add(Training training) async => const Success(null);

  @override
  Future<Result<void>> delete(String id) async => const Success(null);

  @override
  Future<Result<List<Training>>> getAll() async => const Success([]);

  @override
  Future<Result<Training?>> getById(String id) async => Success(_dummy);

  @override
  Future<Result<List<Training>>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async => const Success([]);

  @override
  Future<Result<List<Training>>> getUpcoming() async => const Success([]);

  @override
  Future<Result<void>> update(Training training) async {
    _saved.add(training);
    return const Success(null);
  }

  Training get saved => _saved.first;
}

final _dummy = () {
  final t = Training()
    ..id = '1'
    ..date = DateTime(2025, 7, 20)
    ..duration = 60
    ..focus = TrainingFocus.technical
    ..intensity = TrainingIntensity.medium
    ..status = TrainingStatus.planned
    ..presentPlayerIds = []
    ..absentPlayerIds = [];
  return t;
}();

Widget _wrapWithRouter(Widget child) => ProviderScope(
  overrides: [],
  child: MaterialApp.router(
    routerConfig: GoRouter(
      routes: [GoRoute(path: '/', builder: (_, __) => child)],
    ),
  ),
);

void main() {
  late _MockTrainingRepo repo;

  setUp(() {
    repo = _MockTrainingRepo();
  });

  testWidgets('prefills form with existing training data', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          trainingRepositoryProvider.overrideWithValue(repo),
          trainingsProvider.overrideWith((ref) => Future.value([_dummy])),
        ],
        child: MaterialApp(home: TrainingEditScreen(trainingId: '1')),
      ),
    );
    await tester.pumpAndSettle();

    // Duration field should contain 60
    expect(find.widgetWithText(TextFormField, '60'), findsOneWidget);
    // Focus dropdown should show technical
    expect(find.text(TrainingFocus.technical.name), findsOneWidget);
  });

  testWidgets('shows validation error on invalid duration', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          trainingRepositoryProvider.overrideWithValue(repo),
          trainingsProvider.overrideWith((ref) => Future.value([_dummy])),
        ],
        child: MaterialApp(home: TrainingEditScreen(trainingId: '1')),
      ),
    );
    await tester.pumpAndSettle();

    // enter invalid duration
    await tester.enterText(find.byType(TextFormField).first, '5');
    await tester.tap(find.text('Opslaan'));
    await tester.pumpAndSettle();

    expect(find.textContaining('15–240'), findsOneWidget);
  });

  testWidgets('successful save calls repository update', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          trainingRepositoryProvider.overrideWithValue(repo),
          trainingsProvider.overrideWith((ref) => Future.value([_dummy])),
        ],
        child: MaterialApp(home: TrainingEditScreen(trainingId: '1')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, '90');
    await tester.tap(find.text('Opslaan'));
    await tester.pumpAndSettle();

    expect(repo.saved.duration, 90);
  });
}
