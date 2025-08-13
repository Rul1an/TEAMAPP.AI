import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/models/training.dart';

void main() {
  group('Model ID policy - String IDs everywhere', () {
    test('Training.id is String and JSON casting preserves String', () {
      final t = Training.fromJson({
        'id': 'abc-123',
        'date': DateTime.now().toIso8601String(),
        'duration': 60,
        'trainingNumber': 1,
        'focus': 'technical',
        'intensity': 'medium',
        'status': 'planned',
      });
      expect(t.id, isA<String>());

      final json = t.toJson();
      expect(json['id'], isA<String>());
    });
  });
}
