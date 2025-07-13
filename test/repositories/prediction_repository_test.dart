import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/repositories/match_repository.dart';
import 'package:jo17_tactical_manager/repositories/prediction_repository.dart';
import 'package:jo17_tactical_manager/repositories/prediction_repository_stub.dart';

class _MockMatchRepo implements MatchRepository {
  List<Match> matches = [];

  @override
  Future<Result<void>> add(Match match) async {
    matches.add(match);
    return const Success(null);
  }

  @override
  Future<Result<void>> delete(String id) async {
    matches.removeWhere((m) => m.id == id);
    return const Success(null);
  }

  @override
  Future<Result<Match?>> getById(String id) async {
    try {
      final match = matches.firstWhere((m) => m.id == id);
      return Success(match);
    } catch (_) {
      // No match found – return Success with null to honor the nullable contract.
      return const Success(null);
    }
  }

  @override
  Future<Result<List<Match>>> getRecent() async => Success(matches);

  @override
  Future<Result<List<Match>>> getUpcoming() async => Success(matches);

  @override
  Future<Result<List<Match>>> getAll() async => Success(matches);

  @override
  Future<Result<void>> update(Match match) async => const Success(null);
}

void main() {
  test('PredictionRepository returns stable when no matches', () async {
    final matchRepo = _MockMatchRepo();
    final repo = PredictionRepositoryStub(matchRepository: matchRepo);

    final res = await repo.predictForm('team1');
    expect(res, isA<Success<FormTrend>>());
    expect(res.dataOrNull, FormTrend.stable);
  });
}
