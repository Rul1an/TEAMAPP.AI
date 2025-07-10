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
    // The Match model currently has no explicit `teamId` field. In a real
    // implementation this should be replaced with proper filtering logic once
    // the model supports it. For the stub we simply include all matches.
    final allMatches = matchesRes.dataOrNull!;

    // Take the last [n] played by date desc
    allMatches.sort((a, b) => b.date.compareTo(a.date));
    final matches = allMatches.take(3).toList();
    if (matches.isEmpty) return const Success(FormTrend.stable);

    final avgPts =
        matches
            .map(
              (m) => m.result == MatchResult.win
                  ? 3
                  : m.result == MatchResult.draw
                  ? 1
                  : 0,
            )
            .reduce((a, b) => a + b) /
        matches.length;
    if (avgPts >= 2.1) return const Success(FormTrend.improving);
    if (avgPts <= 0.9) return const Success(FormTrend.declining);
    return const Success(FormTrend.stable);
  }
}
