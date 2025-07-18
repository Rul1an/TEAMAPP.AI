// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

// Project imports:
import 'package:jo17_tactical_manager/hive/hive_training_cache.dart';
import 'package:jo17_tactical_manager/models/training.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock secure storage & path provider channels used by HiveFlutter
  const secureStorageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(secureStorageChannel, (call) async => null);

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    pathProviderChannel,
    (call) async => Directory.systemTemp.path,
  );

  group('HiveTrainingCache', () {
    setUp(() {
      Hive.init(Directory.systemTemp.path);
    });

    Training makeTraining(String id) {
      return Training()
        ..id = id
        ..date = DateTime(2025)
        ..duration = 90
        ..focus = TrainingFocus.technical
        ..intensity = TrainingIntensity.medium
        ..status = TrainingStatus.planned;
    }

    test('write & read list', () async {
      final cache = HiveTrainingCache();
      final trainings = [makeTraining('t1')];
      await cache.write(trainings);
      final read = await cache.read();
      expect(read?.first.id, 't1');
    });

    test('returns null after TTL expiry', () async {
      final cache = HiveTrainingCache();
      final trainings = [makeTraining('t2')];
      await cache.write(trainings);
      expect(
        await cache.read(ttl: const Duration(milliseconds: 50)),
        isNotNull,
      );
      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(await cache.read(ttl: const Duration(milliseconds: 50)), isNull);
    });
  });
}
