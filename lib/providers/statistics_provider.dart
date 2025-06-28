import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';

final statisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final db = DatabaseService();
  return db.getStatistics();
});
