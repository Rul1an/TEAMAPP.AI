// ignore_for_file: unused_element

import 'package:flutter_test/flutter_test.dart';

// PredictionRepository not yet implemented – imports removed.
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/repositories/match_repository.dart';
import 'package:jo17_tactical_manager/models/match.dart';

class _MockMatchRepo implements MatchRepository {
  @override
  Future<Result<void>> add(Match match) async => const Success(null);

  @override
  Future<Result<void>> delete(String id) async => const Success(null);

  @override
  Future<Result<Match?>> getById(String id) async => const Success(null);

  @override
  Future<Result<List<Match>>> getAll() async => const Success(<Match>[]);

  @override
  Future<Result<List<Match>>> getUpcoming() async => const Success(<Match>[]);

  @override
  Future<Result<List<Match>>> getRecent() async => const Success(<Match>[]);

  @override
  Future<Result<void>> update(Match match) async => const Success(null);
}

void main() {
  // No-op: detailed tests will be added once PredictionRepository is implemented.
}
