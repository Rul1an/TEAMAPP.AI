import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/analytics/heat_map_palette.dart';

class HeatMapSettings {
  const HeatMapSettings({
    this.palette = HeatMapPalette.classic,
    this.minCount = 4,
  });

  final HeatMapPalette palette;
  final int minCount;

  HeatMapSettings copyWith({HeatMapPalette? palette, int? minCount}) =>
      HeatMapSettings(
        palette: palette ?? this.palette,
        minCount: minCount ?? this.minCount,
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
}

final heatMapSettingsProvider =
    StateNotifierProvider<HeatMapSettingsNotifier, HeatMapSettings>(
  (ref) => HeatMapSettingsNotifier(),
);
