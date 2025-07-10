import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/prediction_repository.dart';
import '../repositories/prediction_repository_stub.dart';
import '../repositories/match_repository.dart';
import '../providers/matches_provider.dart';

class FormPredictionController extends AsyncNotifier<FormTrend> {
  FormPredictionController(this.teamId);
  final String teamId;

  @override
  Future<FormTrend> build() async {
    final repo = PredictionRepositoryStub(
      matchRepository: ref.read(matchRepositoryProvider),
    );
    final res = await repo.predictForm(teamId);
    return res.dataOrNull ?? FormTrend.stable;
  }
}

final formPredictionProvider =
    AsyncNotifierProvider.family<FormPredictionController, FormTrend, String>(
  (ref, teamId) => FormPredictionController(teamId),
);