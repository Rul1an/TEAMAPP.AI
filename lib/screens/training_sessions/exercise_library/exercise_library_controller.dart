import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/training_session/training_exercise.dart';
import '../../../../models/annual_planning/morphocycle.dart';
import '../../../../providers/exercise_designer_provider.dart';

/// Holds UI state & filtering logic for ExerciseLibraryScreen.
class ExerciseLibraryController extends ChangeNotifier {
  ExerciseLibraryController(this._ref);

  final Ref _ref;

  // Raw list exposed via provider (fetched remotely + cache).
  List<TrainingExercise> _rawExercises = [];

  // --- Filters -------------------------------------------------------------
  String _search = '';
  ExerciseCategory? _category;
  ExerciseComplexity? _complexity;
  TrainingIntensity? _intensity;
  TacticalFocus? _tacticalFocus;
  int? _minDuration;
  int? _maxDuration;
  int? _playerCount;
  bool _showMorphocycleBanner = true;

  // Public getters ---------------------------------------------------------
  List<TrainingExercise> get filteredExercises {
    var list = _rawExercises;
    if (_search.isNotEmpty) {
      list = list
          .where((e) => e.name.toLowerCase().contains(_search.toLowerCase()))
          .toList();
    }
    if (_category != null) {
      list = list.where((e) => e.category == _category).toList();
    }
    if (_complexity != null) {
      list = list.where((e) => e.complexity == _complexity).toList();
    }
    if (_intensity != null) {
      list = list.where((e) {
        switch (_intensity!) {
          case TrainingIntensity.recovery:
            return e.primaryIntensity <= 3;
          case TrainingIntensity.acquisition:
            return e.primaryIntensity >= 8;
          case TrainingIntensity.development:
            return e.primaryIntensity >= 5 && e.primaryIntensity <= 7;
          case TrainingIntensity.activation:
            return e.primaryIntensity >= 4 && e.primaryIntensity <= 6;
          case TrainingIntensity.competition:
            return e.primaryIntensity >= 9;
        }
      }).toList();
    }
    if (_tacticalFocus != null) {
      list = list.where((e) => e.tacticalFocus == _tacticalFocus).toList();
    }
    if (_minDuration != null) {
      list = list.where((e) => e.durationMinutes >= _minDuration!).toList();
    }
    if (_maxDuration != null) {
      list = list.where((e) => e.durationMinutes <= _maxDuration!).toList();
    }
    if (_playerCount != null) {
      list = list.where((e) => e.minPlayers <= _playerCount!).toList();
    }
    return list;
  }

  bool get showMorphocycleBanner => _showMorphocycleBanner;

  // Expose current filter values for UI widgets
  String get search => _search;
  ExerciseCategory? get category => _category;
  ExerciseComplexity? get complexity => _complexity;
  TrainingIntensity? get intensity => _intensity;
  TacticalFocus? get tacticalFocus => _tacticalFocus;
  int? get minDuration => _minDuration;
  int? get maxDuration => _maxDuration;
  int? get playerCount => _playerCount;

  // --- Mutations -----------------------------------------------------------
  void setSearch(String value) {
    _search = value;
    notifyListeners();
  }

  void setCategory(ExerciseCategory? value) {
    _category = value;
    notifyListeners();
  }

  void setComplexity(ExerciseComplexity? value) {
    _complexity = value;
    notifyListeners();
  }

  void setIntensity(TrainingIntensity? value) {
    _intensity = value;
    notifyListeners();
  }

  void setTacticalFocus(TacticalFocus? value) {
    _tacticalFocus = value;
    notifyListeners();
  }

  void setDurationRange(int? min, int? max) {
    _minDuration = min;
    _maxDuration = max;
    notifyListeners();
  }

  void setPlayerCount(int? players) {
    _playerCount = players;
    notifyListeners();
  }

  void resetFilters() {
    _search = '';
    _category = null;
    _complexity = null;
    _intensity = null;
    _tacticalFocus = null;
    _minDuration = null;
    _maxDuration = null;
    _playerCount = null;
    notifyListeners();
  }

  /// Toggle morphocycle recommendation banner visibility.
  void toggleMorphocycleBanner() {
    _showMorphocycleBanner = !_showMorphocycleBanner;
    notifyListeners();
  }

  // --- Data loading --------------------------------------------------------
  Future<void> loadExercises() async {
    final asyncVal = await _ref.read(exerciseLibraryProvider.future);
    _rawExercises = asyncVal;
    notifyListeners();
  }
}

/// Riverpod provider wrapping above controller.
final exerciseLibraryControllerProvider =
    ChangeNotifierProvider.autoDispose<ExerciseLibraryController>((ref) {
  final ctrl = ExerciseLibraryController(ref);
  // Kick off initial load (fire-and-forget)
  ctrl.loadExercises();
  return ctrl;
});
