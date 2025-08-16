import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../widgets/analytics/heat_map_palette.dart';

class HeatMapSettings {
  const HeatMapSettings({
    this.palette = HeatMapPalette.classic,
    this.minCount = 4,
    this.dpEnabled = false,
    this.epsilon = 1.0,
  });

  final HeatMapPalette palette;
  final int minCount;
  final bool dpEnabled;
  final double epsilon;

  HeatMapSettings copyWith({HeatMapPalette? palette, int? minCount}) =>
      HeatMapSettings(
        palette: palette ?? this.palette,
        minCount: minCount ?? this.minCount,
        dpEnabled: dpEnabled,
        epsilon: epsilon,
      );

  HeatMapSettings copyWithAll({
    HeatMapPalette? palette,
    int? minCount,
    bool? dpEnabled,
    double? epsilon,
  }) =>
      HeatMapSettings(
        palette: palette ?? this.palette,
        minCount: minCount ?? this.minCount,
        dpEnabled: dpEnabled ?? this.dpEnabled,
        epsilon: epsilon ?? this.epsilon,
      );
}

class HeatMapSettingsNotifier extends StateNotifier<HeatMapSettings> {
  HeatMapSettingsNotifier() : super(const HeatMapSettings()) {
    _load();
  }

  void setPalette(HeatMapPalette palette) {
    state = state.copyWith(palette: palette);
    _persist();
  }

  void setMinCount(int minCount) {
    final int safe = minCount < 1 ? 1 : minCount;
    state = state.copyWith(minCount: safe);
    _persist();
  }

  void setDpEnabled({required bool enabled}) {
    state = state.copyWithAll(dpEnabled: enabled);
    _persist();
  }

  void setEpsilon(double epsilon) {
    final double safe = epsilon <= 0 ? 1.0 : epsilon;
    state = state.copyWithAll(epsilon: safe);
    _persist();
  }

  static const String _boxName = 'app_settings';
  static const String _key = 'heatmap_settings';

  Future<void> _load() async {
    try {
      final Box<Map<dynamic, dynamic>> box =
          await Hive.openBox<Map<dynamic, dynamic>>(_boxName);
      final Map<dynamic, dynamic>? data = box.get(_key);
      if (data == null) return;
      final paletteIndex = data['palette'] as int?;
      final minCount = data['minCount'] as int?;
      final dpEnabled = data['dpEnabled'] as bool?;
      final epsilon = (data['epsilon'] as num?)?.toDouble();
      state = state.copyWithAll(
        palette: paletteIndex != null &&
                paletteIndex >= 0 &&
                paletteIndex < HeatMapPalette.values.length
            ? HeatMapPalette.values[paletteIndex]
            : state.palette,
        minCount: minCount ?? state.minCount,
        dpEnabled: dpEnabled ?? state.dpEnabled,
        epsilon: epsilon ?? state.epsilon,
      );
    } catch (_) {
      // Ignore persistence errors
    }
  }

  Future<void> _persist() async {
    try {
      final Box<Map<dynamic, dynamic>> box =
          await Hive.openBox<Map<dynamic, dynamic>>(_boxName);
      await box.put(_key, <String, dynamic>{
        'palette': state.palette.index,
        'minCount': state.minCount,
        'dpEnabled': state.dpEnabled,
        'epsilon': state.epsilon,
      });
    } catch (_) {
      // Ignore persistence errors
    }
  }
}

final heatMapSettingsProvider =
    StateNotifierProvider<HeatMapSettingsNotifier, HeatMapSettings>(
  (ref) => HeatMapSettingsNotifier(),
);
