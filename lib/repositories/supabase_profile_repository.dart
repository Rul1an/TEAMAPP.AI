import 'dart:io';

import '../core/result.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';
import 'profile_repository.dart';

class SupabaseProfileRepository implements ProfileRepository {
  SupabaseProfileRepository({ProfileService? service, this.cache})
      : _service = service ?? ProfileService();

  final ProfileService _service;
  final dynamic cache; // HiveProfileCache? but to avoid import cycles

  @override
  Future<Result<Profile?>> getCurrent() async {
    try {
      final profile = await _service.getCurrentProfile();
      return Success(profile);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<Profile>> update({
    String? username,
    String? avatarUrl,
    String? website,
  }) async {
    try {
      final profile = await _service.updateProfile(
        username: username,
        avatarUrl: avatarUrl,
        website: website,
      );
      return Success(profile);
    } catch (e) {
      // Treat "no user" / unauthorized situations specially
      if (e is StateError || e.toString().contains('no user')) {
        return Failure(UnauthorizedFailure());
      }
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<Profile>> uploadAvatar(File file) async {
    try {
      final profile = await _service.uploadAvatar(file);
      return Success(profile);
    } catch (e) {
      if (e is StateError || e.toString().contains('no user')) {
        return Failure(UnauthorizedFailure());
      }
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Stream<Profile> watch() => _service.subscribeProfile();
}
