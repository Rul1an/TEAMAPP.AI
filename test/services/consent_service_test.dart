import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:jo17_tactical_manager/services/consent_service.dart';

void main() {
  setUp(() async {
    Hive.init('.hive_test');
    if (Hive.isBoxOpen('consent')) {
      final box = Hive.box<Map<String, bool>>('consent');
      await box.clear();
      await box.close();
    }
  });

  tearDown(() async {
    if (Hive.isBoxOpen('consent')) {
      final box = Hive.box<Map<String, bool>>('consent');
      await box.clear();
      await box.close();
    }
  });

  test('default consent flags are false', () async {
    final service = ConsentService();
    final flags = await service.getConsent();
    expect(flags['analytics'], isFalse);
    expect(flags['performance'], isFalse);
    expect(flags['marketing'], isFalse);
  });

  test('setConsent persists flags locally', () async {
    final service = ConsentService();
    await service.setConsent({'analytics': true});
    final flags = await service.getConsent();
    expect(flags['analytics'], isTrue);
    expect(flags['performance'], isFalse);
  });
}
