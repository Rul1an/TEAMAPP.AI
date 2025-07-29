import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/prediction_repository.dart';
import '../repositories/prediction_repository_stub.dart';
import '../providers/matches_provider.dart';

class FormPredictionController extends FamilyAsyncNotifier<FormTrend, String> {
  @override
  Future<FormTrend> build(String arg) async {
    final repo = PredictionRepositoryStub(
      matchRepository: ref.read(matchRepositoryProvider),
    );
    final res = await repo.predictForm(arg);
    return res.dataOrNull ?? FormTrend.stable;
  }
}

final formPredictionProvider =
    AsyncNotifierProvider.family<FormPredictionController, FormTrend, String>(
  FormPredictionController.new,
);
