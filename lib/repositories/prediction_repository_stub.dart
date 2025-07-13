import '../core/result.dart';
import '../models/match.dart';
import '../repositories/match_repository.dart';
import 'prediction_repository.dart';

class PredictionRepositoryStub implements PredictionRepository {
  PredictionRepositoryStub({required this.matchRepository});

  final MatchRepository matchRepository;

  @override
  Future<Result<FormTrend>> predictForm(String teamId) async {
    // Fallback: use `getRecent()` and filter for team
    final matchesRes = await matchRepository.getRecent();
    if (!matchesRes.isSuccess) return Failure(matchesRes.errorOrNull!);
    final allMatches = matchesRes.dataOrNull!
        .where((m) => m.teamId == teamId)
        .toList();

    // Take the last [n] played by date desc
    allMatches.sort((a, b) => b.date.compareTo(a.date));
    final matches = allMatches.take(3).toList();
    if (matches.isEmpty) return const Success(FormTrend.stable);

    int _points(Match m) {
      final res = m.result;
      if (res == MatchResult.win) return 3;
      if (res == MatchResult.draw) return 1;
      return 0;
    }

    final totalPoints = matches.fold<int>(0, (sum, m) => sum + _points(m));
    final avgPts = totalPoints / matches.length;
    if (avgPts >= 2.1) return const Success(FormTrend.improving);
    if (avgPts <= 0.9) return const Success(FormTrend.declining);
    return const Success(FormTrend.stable);
  }
}
