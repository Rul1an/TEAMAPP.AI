import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/models/profile.dart';
import 'package:jo17_tactical_manager/repositories/supabase_profile_repository.dart';
import 'package:jo17_tactical_manager/services/profile_service.dart';

class _FakeProfileService extends ProfileService {
  Profile? _profile;
  bool throwUnauthorized = false;

  set profile(Profile? p) => _profile = p;

  @override
  Future<Profile?> getCurrentProfile() async {
    return _profile;
  }

  @override
  Future<Profile> updateProfile({String? username, String? avatarUrl, String? website}) async {
    if (throwUnauthorized) {
      throw StateError('no user');
    }
    _profile = (_profile ?? Profile(
      userId: 'u',
      organizationId: 'org',
      username: 'x',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ))
        .copyWith(username: username ?? 'x');
    return _profile!;
  }

  @override
  Future<Profile> uploadAvatar(File file) async => _profile!;

  @override
  Stream<Profile> subscribeProfile() => Stream.value(_profile!);
}

void main() {
  group('SupabaseProfileRepository', () {
    late _FakeProfileService fake;
    late SupabaseProfileRepository repo;

    setUp(() {
      fake = _FakeProfileService();
      repo = SupabaseProfileRepository(service: fake);
    });

    test('getCurrent returns Success when profile exists', () async {
      fake.profile = Profile(
        userId: '123',
        organizationId: 'org',
        username: 'test',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final res = await repo.getCurrent();
      expect(res.isSuccess, isTrue);
      expect(res.dataOrNull?.userId, '123');
    });

    test('update handles unauthorized', () async {
      fake.throwUnauthorized = true;
      final res = await repo.update(username: 'new');
      expect(res.isSuccess, isFalse);
      expect(res.errorOrNull, isA<UnauthorizedFailure>());
    });
  });
}
