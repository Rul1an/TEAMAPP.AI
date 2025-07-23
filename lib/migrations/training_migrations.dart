import 'package:isar/isar.dart';
import '../models/training.dart';

/// Migration that ensures every [Training] in the Isar database has a
/// non-zero [Training.trainingNumber]. Older records created before this
/// field existed will contain the default `0`. This migration updates those
/// rows to the new safe default `1`.
Future<int> migrateTrainingNumber(Isar isar) async {
  return isar.writeTxn(() async {
    final collection = isar.collection<Training>();
    final trainings = await collection.where().findAll();
    final trainingsNeedingFix =
        trainings.where((t) => t.trainingNumber == 0).toList();

    for (final training in trainingsNeedingFix) {
      training.trainingNumber = 1;
    }

    if (trainingsNeedingFix.isNotEmpty) {
      await collection.putAll(trainingsNeedingFix);
    }
    return trainingsNeedingFix.length;
  });
}
