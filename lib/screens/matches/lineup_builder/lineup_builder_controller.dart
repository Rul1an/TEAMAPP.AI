import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/formation_template.dart';
import '../../../models/match.dart';
import '../../../models/player.dart';
import '../../../models/team.dart';
import '../../../widgets/common/tactical_drawing_canvas.dart';
import '../../../providers/formation_templates_provider.dart';
import '../../../providers/matches_provider.dart';
import '../../../providers/players_provider.dart';

/// Controller (ChangeNotifier) that encapsulates all business logic for the
/// Lineup Builder screen. UI widgets listen via Riverpod.
class LineupBuilderController extends ChangeNotifier {
  LineupBuilderController(this._ref) {
    _initializePositions();
  }

  final Ref _ref;

  // --- Public state ---------------------------------------------------------
  Formation selectedFormation = Formation.fourThreeThree;
  Map<String, Player?> fieldPositions = {};
  final List<Player> benchPlayers = [];
  List<Player> availablePlayers = [];
  Match? match;

  // Templates
  FormationTemplate? selectedTemplate;
  List<FormationTemplate> availableTemplates = [];

  // Tactical drawing UI state (kept here so multiple widgets can share it)
  bool isDrawingMode = false;
  DrawingTool selectedDrawingTool = DrawingTool.arrow;
  Color selectedDrawingColor = Colors.red;
  List<DrawingElement> tacticalDrawings = [];

  // --- Initialization ------------------------------------------------------

  Future<void> loadTemplates() async {
    final repo = _ref.read(formationTemplateRepositoryProvider);
    final res = await repo.getAll();
    availableTemplates = res.dataOrNull ?? [];
    notifyListeners();
  }

  Future<void> loadMatch(String matchId) async {
    final repo = _ref.read(matchRepositoryProvider);
    final res = await repo.getById(matchId);
    match = res.dataOrNull;
    if (match != null && match!.selectedFormation != null) {
      selectedFormation = match!.selectedFormation!;
      _initializePositions();
      await _loadExistingLineup();
    }
    notifyListeners();
  }

  Future<void> _loadExistingLineup() async {
    final playersRes = await _ref.read(playerRepositoryProvider).getAll();
    final players = playersRes.dataOrNull ?? [];

    // Field positions
    match!.fieldPositions.forEach((pos, playerId) {
      final p = players.firstWhere(
        (pl) => pl.id == playerId,
        orElse: Player.new,
      );
      if (p.id.isNotEmpty) fieldPositions[pos] = p;
    });

    // Bench
    for (final id in match!.substituteIds) {
      final p = players.firstWhere((pl) => pl.id == id, orElse: Player.new);
      if (p.id.isNotEmpty) benchPlayers.add(p);
    }
  }

  void _initializePositions() {
    fieldPositions = {
      'GK': null,
      'LB': null,
      'CB1': null,
      'CB2': null,
      'RB': null,
      'CM1': null,
      'CM2': null,
      'CM3': null,
      'LW': null,
      'ST': null,
      'RW': null,
    };
  }

  // --- Mutations ------------------------------------------------------------
  void toggleDrawingMode() {
    isDrawingMode = !isDrawingMode;
    notifyListeners();
  }

  void selectDrawingTool(DrawingTool tool) {
    selectedDrawingTool = tool;
    notifyListeners();
  }

  void selectFormation(Formation formation) {
    selectedFormation = formation;
    _initializePositions();
    notifyListeners();
  }

  // ------------------------ Player selection / swap -----------------------

  void assignPlayerToPosition(Player player, String positionKey) {
    // Remove from any previous spot or bench
    fieldPositions.updateAll(
      (key, value) => value?.id == player.id ? null : value,
    );
    benchPlayers.removeWhere((p) => p.id == player.id);

    fieldPositions[positionKey] = player;
    notifyListeners();
  }

  void moveFieldPlayerToBench(String positionKey) {
    final player = fieldPositions[positionKey];
    if (player != null) {
      benchPlayers.add(player);
      fieldPositions[positionKey] = null;
      notifyListeners();
    }
  }

  void removeBenchPlayer(Player player) {
    benchPlayers.removeWhere((p) => p.id == player.id);
    notifyListeners();
  }
}

/// Riverpod provider
final lineupBuilderControllerProvider =
    ChangeNotifierProvider<LineupBuilderController>((ref) {
  return LineupBuilderController(ref);
});
