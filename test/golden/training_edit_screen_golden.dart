// ignore_for_file: deprecated_member_use, require_trailing_commas, dead_code

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:test_utils/surface_utils.dart';

import 'package:jo17_tactical_manager/models/training.dart';
import 'package:jo17_tactical_manager/providers/trainings_provider.dart';
import 'package:jo17_tactical_manager/repositories/training_repository.dart';
import 'package:jo17_tactical_manager/screens/training/training_edit_screen.dart';
import 'package:jo17_tactical_manager/core/result.dart';

class _FakeTrainingRepo implements TrainingRepository {
  _FakeTrainingRepo(this._t);
  final Training _t;

  @override
  Future<Result<Training?>> getById(String id) async => Success(_t);
  @override
  Future<Result<void>> update(Training training) async => const Success(null);
  @override
  Future<Result<List<Training>>> getAll() async => const Success([]);

  @override
  Future<Result<void>> add(Training training) async => const Success(null);

  @override
  Future<Result<void>> delete(String id) async => const Success(null);

  @override
  Future<Result<List<Training>>> getUpcoming() async => const Success([]);

  @override
  Future<Result<List<Training>>> getByDateRange(
          DateTime start, DateTime end) async =>
      const Success([]);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const testSize = Size(375, 812);
  final isCi = Platform.environment['CI'] == 'true';
  const skipGolden = true; // baseline not yet committed

  final dummy = Training()
    ..id = '1'
    ..date = DateTime(2025, 8)
    ..duration = 60
    ..focus = TrainingFocus.technical
    ..intensity = TrainingIntensity.medium
    ..status = TrainingStatus.planned
    ..trainingNumber = 1;

  group('TrainingEditScreen golden', () {
    setUp(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      setScreenSizeBinding(binding, testSize);
    });

    tearDown(() {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      resetScreenSizeBinding(binding);
    });

    testWidgets('initial state', (tester) async {
      final repo = _FakeTrainingRepo(dummy);
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (c, s) => ProviderScope(
              overrides: [trainingRepositoryProvider.overrideWithValue(repo)],
              child: const TrainingEditScreen(trainingId: '1'),
            ),
          ),
        ],
      );
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(TrainingEditScreen),
        matchesGoldenFile('goldens/training_edit_screen_initial.png'),
      );
    }, skip: skipGolden || isCi);
  });
}
