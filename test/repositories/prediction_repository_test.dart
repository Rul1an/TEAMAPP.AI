import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/repositories/prediction_repository.dart';
import 'package:jo17_tactical_manager/repositories/prediction_repository_stub.dart';
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/repositories/match_repository.dart';

class _MockMatchRepo implements MatchRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  // Basic smoke test to ensure PredictionRepositoryStub compiles and returns a
  // stable result when no matches are present.
  final repo = PredictionRepositoryStub(matchRepository: _MockMatchRepo());
  test('predictForm returns stable when no data', () async {
    final res = await repo.predictForm('team');
    expect(res, const Success(FormTrend.stable));
  });
}
