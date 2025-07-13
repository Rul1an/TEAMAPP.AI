
import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/repositories/match_repository.dart';
import 'package:jo17_tactical_manager/repositories/prediction_repository.dart';
import 'package:jo17_tactical_manager/repositories/prediction_repository_stub.dart';
import 'package:jo17_tactical_manager/models/match.dart';
import 'package:jo17_tactical_manager/core/result.dart';

class _MockMatchRepo implements MatchRepository {
  List<Match> matches = [];

  @override
  Future<Result<List<Match>>> getRecent() async => Success(matches);

  // The remaining interface methods are not needed for this test.
  @override
  Future<Result<void>> add(Match match) async => const Success(null);

  @override
  Future<Result<void>> delete(String id) async => const Success(null);

  @override
  Future<Result<Match?>> getById(String id) async => const Success(null);

  @override
  Future<Result<List<Match>>> getAll() async => Success(matches);

  @override
  Future<Result<List<Match>>> getUpcoming() async => Success(matches);

  @override
  Future<Result<void>> update(Match match) async => const Success(null);
}

void main() {
  test('predictForm returns improving when team wins last three', () async {
    final mockRepo = _MockMatchRepo();
    mockRepo.matches = List.generate(
      3,
      (i) => (Match()
        ..id = '$i'
        ..teamId = 'team1'
        ..date = DateTime(2025, 1, i + 1)
        ..opponent = 'Opp'
        ..location = Location.home
        ..competition = Competition.league
        ..status = MatchStatus.completed
        ..teamScore = 2
        ..opponentScore = 0),
    );

    final predictionRepo =
        PredictionRepositoryStub(matchRepository: mockRepo);

    final res = await predictionRepo.predictForm('team1');
    expect(res.isSuccess, isTrue);
    expect(res.dataOrNull, FormTrend.improving);
  });
}
