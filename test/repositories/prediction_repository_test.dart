import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/repositories/match_repository.dart';
import 'package:jo17_tactical_manager/repositories/prediction_repository.dart';
import 'package:jo17_tactical_manager/repositories/prediction_repository_stub.dart';

class _MockMatchRepo implements MatchRepository {
  _MockMatchRepo(this.matches);

  final List<Match> matches;

  @override
  Future<Result<void>> add(Match match) async => const Success(null);

  @override
  Future<Result<void>> delete(String id) async => const Success(null);

  @override
  Future<Result<Match?>> getById(String id) async =>
      Success(matches.firstWhere((m) => m.id == id, orElse: () => Match()));

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
  test('PredictionRepositoryStub returns stable when no matches', () async {
    final repo = PredictionRepositoryStub(matchRepository: _MockMatchRepo([]));
    final res = await repo.predictForm('team');
    expect(res.dataOrNull, FormTrend.stable);
  });

  test('PredictionRepositoryStub detects improving form', () async {
    final matches = [
      Match()
        ..id = '1'
        ..date = DateTime.now()
        ..opponent = 'Opp'
        ..location = Location.home
        ..competition = Competition.league
        ..status = MatchStatus.completed
        ..teamScore = 2
        ..opponentScore = 0,
      Match()
        ..id = '2'
        ..date = DateTime.now().subtract(const Duration(days: 1))
        ..opponent = 'Opp'
        ..location = Location.home
        ..competition = Competition.league
        ..status = MatchStatus.completed
        ..teamScore = 3
        ..opponentScore = 1,
      Match()
        ..id = '3'
        ..date = DateTime.now().subtract(const Duration(days: 2))
        ..opponent = 'Opp'
        ..location = Location.home
        ..competition = Competition.league
        ..status = MatchStatus.completed
        ..teamScore = 1
        ..opponentScore = 1,
    ];

    final repo = PredictionRepositoryStub(matchRepository: _MockMatchRepo(matches));
    final res = await repo.predictForm('team');
    expect(res.dataOrNull, FormTrend.improving);
  });
}
