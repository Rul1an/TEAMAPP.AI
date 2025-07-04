// Dart imports:
import 'dart:io';

// Project imports:
import '../core/result.dart';
import '../models/profile.dart';

abstract interface class ProfileRepository {
  Future<Result<Profile?>> getCurrent();

  Future<Result<Profile>> update({
    String? username,
    String? avatarUrl,
    String? website,
  });

  Future<Result<Profile>> uploadAvatar(File file);

  Stream<Profile> watch();
}
