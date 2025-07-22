import '../models/training.dart';

extension TrainingSafeNumber on Training {
  /// Returns a guaranteed non-zero training number.
  int get nr => trainingNumber == 0 ? 1 : trainingNumber;
}