import '../core/result.dart';

enum FormTrend { improving, stable, declining }

abstract interface class PredictionRepository {
  Future<Result<FormTrend>> predictForm(String teamId);
}