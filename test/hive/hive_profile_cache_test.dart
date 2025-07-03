import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:jo17_tactical_manager/hive/hive_profile_cache.dart';
import 'package:jo17_tactical_manager/models/profile.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('write & read profile cache', () async {
    Hive.init(null);
    final cache = HiveProfileCache();
    final profile = Profile(
      userId: '1',
      organizationId: 'org',
      username: 'john',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await cache.write(profile);
    final fetched = await cache.read();
    expect(fetched?.userId, '1');
  });
}
