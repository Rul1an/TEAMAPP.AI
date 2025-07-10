// ignore_for_file: cascade_invocations

// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/core/result.dart';
import 'package:jo17_tactical_manager/models/profile.dart';
import 'package:jo17_tactical_manager/providers/profile_provider.dart';
import 'package:jo17_tactical_manager/repositories/profile_repository.dart';

class _FakeRepo implements ProfileRepository {
  Profile? _profile;
  final _controller = StreamController<Profile>.broadcast();

  Profile? get profile => _profile;

  set profile(Profile? p) {
    _profile = p;
    if (p != null) _controller.add(p);
  }

  @override
  Future<Result<Profile?>> getCurrent() async => Success(_profile);

  @override
  Stream<Profile> watch() => _controller.stream;

  @override
  Future<Result<Profile>> update({
    String? username,
    String? avatarUrl,
    String? website,
  }) async {
    _profile = Profile(
      userId: 'u',
      organizationId: 'org',
      username: username ?? 'x',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _controller.add(_profile);
    return Success(_profile!);
  }

  @override
  Future<Result<Profile>> uploadAvatar(File file) async => Success(_profile!);
}

void main() {
  test('currentProfileProvider emits data', () async {
    final repo = _FakeRepo();
    repo.profile = Profile(
      userId: '1',
      organizationId: 'org',
      username: 'john',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final container = ProviderContainer(
      overrides: [profileRepositoryProvider.overrideWithValue(repo)],
    );

    addTearDown(container.dispose);

    final value = await container.read(currentProfileProvider.future);
    expect(value?.username, 'john');

    await container
        .read(currentProfileProvider.notifier)
        .editProfile(username: 'new');
  });
}
