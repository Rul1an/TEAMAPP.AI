import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/action_event.dart';
import '../repositories/analytics_repository.dart';
import '../providers/analytics_repository_provider.dart';
import '../providers/consent_provider.dart';

class HeatMapParams {
  HeatMapParams({
    required this.start,
    required this.end,
    required this.category,
  });
  final DateTime start;
  final DateTime end;
  final ActionCategory category;
}

class HeatMapController extends AsyncNotifier<List<ActionEvent>> {
  @override
  Future<List<ActionEvent>> build() async {
    // default params: last 5 matches? fallback to season
    return [];
  }

  Future<void> load(HeatMapParams params) async {
    state = const AsyncLoading();
    final bool analyticsAllowed =
        await ref.read(analyticsConsentProvider.future);
    if (!analyticsAllowed) {
      state = const AsyncData(<ActionEvent>[]);
      return;
    }
    final repo = ref.read(analyticsRepositoryProvider);
    final res = await repo.getHeatMapData(
      start: params.start,
      end: params.end,
      category: params.category,
    );
    state = res.when(
      success: AsyncData.new,
      failure: (err) => AsyncError(err, StackTrace.current),
    );
  }
}

final heatMapControllerProvider =
    AsyncNotifierProvider<HeatMapController, List<ActionEvent>>(
  HeatMapController.new,
);
