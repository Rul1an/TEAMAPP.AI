// Unit tests for LineupBuilderController
// Ensure business logic works independently of UI.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/models/formation_template.dart';
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/models/player.dart';
import 'package:jo17_tactical_manager/providers/formation_templates_provider.dart';
import 'package:jo17_tactical_manager/providers/matches_provider.dart';
import 'package:jo17_tactical_manager/providers/players_provider.dart';
import 'package:jo17_tactical_manager/repositories/formation_template_repository.dart';
import 'package:jo17_tactical_manager/repositories/match_repository.dart';
import 'package:jo17_tactical_manager/repositories/player_repository.dart';
import 'package:jo17_tactical_manager/screens/matches/lineup_builder/lineup_builder_controller.dart';

void main() {
  group('LineupBuilderController', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(overrides: [
        formationTemplateRepositoryProvider
            .overrideWithValue(_FakeFormationTemplateRepository()),
        matchRepositoryProvider.overrideWithValue(_FakeMatchRepository()),
        playerRepositoryProvider.overrideWithValue(_FakePlayerRepository()),
      ]);
    });

    tearDown(() => container.dispose());

    test('toggleDrawingMode flips the boolean flag', () {
      final ctrl = container.read(lineupBuilderControllerProvider);
      final initial = ctrl.isDrawingMode;
      ctrl.toggleDrawingMode();
      expect(ctrl.isDrawingMode, equals(!initial));
    });

    test('assignPlayerToPosition moves player from bench onto the field', () {
      final ctrl = container.read(lineupBuilderControllerProvider);
      final player = _createDummyPlayer('p1', 'Test');
      ctrl.benchPlayers.add(player);

      ctrl.assignPlayerToPosition(player, 'GK');

      expect(ctrl.fieldPositions['GK'], equals(player));
      expect(ctrl.benchPlayers.contains(player), isFalse);
    });

    test('moveFieldPlayerToBench moves player from field to bench', () {
      final ctrl = container.read(lineupBuilderControllerProvider);
      final player = _createDummyPlayer('p2', 'Keeper');
      ctrl.assignPlayerToPosition(player, 'GK');

      ctrl.moveFieldPlayerToBench('GK');

      expect(ctrl.fieldPositions['GK'], isNull);
      expect(ctrl.benchPlayers.contains(player), isTrue);
    });
  });
}

// ---------------------------------------------------------------------------
// Helpers & fakes
// ---------------------------------------------------------------------------

Player _createDummyPlayer(String id, String first) {
  final p = Player();
  p.id = id;
  p.firstName = first;
  p.lastName = 'Player';
  p.jerseyNumber = 1;
  p.birthDate = DateTime(2010, 1, 1);
  p.position = Position.goalkeeper;
  p.preferredFoot = PreferredFoot.right;
  p.height = 170;
  p.weight = 60;
  return p;
}

class _FakeFormationTemplateRepository implements FormationTemplateRepository {
  @override
  Future<Result<List<FormationTemplate>>> getAll() async => const Success([]);

  @override
  Future<Result<void>> add(FormationTemplate template) async =>
      const Success(null);

  @override
  Future<Result<void>> delete(String id) async => const Success(null);
}

class _FakeMatchRepository implements MatchRepository {
  @override
  Future<Result<List<Match>>> getAll() async => const Success([]);

  @override
  Future<Result<List<Match>>> getUpcoming() async => const Success([]);

  @override
  Future<Result<List<Match>>> getRecent() async => const Success([]);

  @override
  Future<Result<Match?>> getById(String id) async => const Success(null);

  @override
  Future<Result<void>> add(Match match) async => const Success(null);

  @override
  Future<Result<void>> update(Match match) async => const Success(null);

  @override
  Future<Result<void>> delete(String id) async => const Success(null);
}

class _FakePlayerRepository implements PlayerRepository {
  @override
  Future<Result<List<Player>>> getAll() async => const Success([]);

  @override
  Future<Result<Player?>> getById(String id) async => const Success(null);

  @override
  Future<Result<List<Player>>> getByPosition(Position position) async =>
      const Success([]);

  @override
  Future<Result<void>> add(Player player) async => const Success(null);

  @override
  Future<Result<void>> update(Player player) async => const Success(null);

  @override
  Future<Result<void>> delete(String id) async => const Success(null);
}
