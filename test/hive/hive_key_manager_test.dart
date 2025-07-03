import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/hive/hive_key_manager.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorage extends Mock implements FlutterSecureStorage {}

void main() {
  test('generates and stores key', () async {
    final storage = _MockStorage();
    when(() => storage.read(key: any(named: 'key')))
        .thenAnswer((_) async => null);
    when(
      () => storage.write(key: any(named: 'key'), value: any(named: 'value')),
    ).thenAnswer((_) async {});

    final manager = HiveKeyManager(storage: storage);
    final key = await manager.getKey();
    expect(key.length, 32);
    verify(
      () => storage.write(
        key: 'hive_encryption_key',
        value: any(named: 'value'),
      ),
    ).called(1);
  });

  test('returns cached key on subsequent calls', () async {
    final initial = base64Encode(List<int>.filled(32, 1));
    final storage = _MockStorage();
    when(() => storage.read(key: any(named: 'key')))
        .thenAnswer((_) async => initial);

    final manager = HiveKeyManager(storage: storage);
    final k1 = await manager.getKey();
    final k2 = await manager.getKey();
    expect(k1, k2);
  });
}
