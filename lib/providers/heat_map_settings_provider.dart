import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  HeatMapSettingsNotifier() : super(const HeatMapSettings());

  void setPalette(HeatMapPalette palette) {
    state = state.copyWith(palette: palette);
  }

  void setMinCount(int minCount) {
    final int safe = minCount < 1 ? 1 : minCount;
    state = state.copyWith(minCount: safe);
  }

  void setDpEnabled(bool enabled) {
    state = state.copyWithAll(dpEnabled: enabled);
  }

  void setEpsilon(double epsilon) {
    final double safe = epsilon <= 0 ? 1.0 : epsilon;
    state = state.copyWithAll(epsilon: safe);
  }
}

final heatMapSettingsProvider =
    StateNotifierProvider<HeatMapSettingsNotifier, HeatMapSettings>(
  (ref) => HeatMapSettingsNotifier(),
);
