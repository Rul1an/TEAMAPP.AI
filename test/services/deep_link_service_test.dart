import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jo17_tactical_manager/services/deep_link_service.dart';

class _MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('DeepLinkService.handleUriForTest', () {
    late DeepLinkService service;
    late _MockGoRouter router;

    setUp(() {
      service = DeepLinkService();
      router = _MockGoRouter();
    });

    test('navigates to match route from web hash URI', () {
      final uri = Uri.parse('https://teamappai.netlify.app/#/matches/123');
      service.handleUriForTest(uri, router);
      verify(() => router.go('/matches/123')).called(1);
    });

    test('navigates to training route from mobile URI', () {
      final uri = Uri.parse('teamapp://training/abc');
      service.handleUriForTest(uri, router);
      verify(() => router.go('/training/abc')).called(1);
    });
  });
}

