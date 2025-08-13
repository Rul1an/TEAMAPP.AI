import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/services/gdpr_service.dart';

void main() {
  test('exportUserData returns pretty JSON', () async {
    final service = GdprService.forTest(
      exportFn: (id) async => [
        {'table': 'profiles', 'id': id, 'email': 'user@example.com'},
      ],
      deleteFn: (_) async {},
    );
    final json = await service.exportUserData('u1');
    expect(json.contains('profiles'), isTrue);
    expect(json.contains('u1'), isTrue);
  });

  test('deleteUserData calls delete RPC', () async {
    var called = false;
    final service = GdprService.forTest(
      exportFn: (_) async => [],
      deleteFn: (_) async {
        called = true;
      },
    );
    await service.deleteUserData('u2');
    expect(called, isTrue);
  });
}
