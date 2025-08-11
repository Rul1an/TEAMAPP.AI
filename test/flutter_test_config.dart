import 'package:flutter_test/flutter_test.dart';
import 'helpers/plugins_test_helper.dart';
import 'helpers/firebase_test_helper.dart';

Future<void> testExecutable(Future<void> Function() testMain) async {
  // Ensure platform channels and Firebase are mocked for all tests
  await PluginsTestHelper.setupPluginMocks();
  await FirebaseTestHelper.setupFirebaseMocking();
  await testMain();
}
