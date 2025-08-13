// Lightweight GDPR service: export and delete hooks wired to Supabase RPCs.

import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

class GdprService {
  const GdprService(this._client)
      : _exportFn = null,
        _deleteFn = null;

  const GdprService.forTest({
    required Future<List<Map<String, dynamic>>> Function(String userId)
        exportFn,
    required Future<void> Function(String userId) deleteFn,
  })  : _client = null,
        _exportFn = exportFn,
        _deleteFn = deleteFn;

  final SupabaseClient? _client;
  final Future<List<Map<String, dynamic>>> Function(String userId)? _exportFn;
  final Future<void> Function(String userId)? _deleteFn;

  Future<String> exportUserData(String userId) async {
    List<Map<String, dynamic>> rows;
    if (_exportFn != null) {
      rows = await _exportFn(userId);
    } else {
      final result = await _client!.rpc<List<dynamic>>('gdpr_export_user',
          params: {'p_user_id': userId});
      rows = result.map((e) => e as Map<String, dynamic>).toList();
    }
    return const JsonEncoder.withIndent('  ').convert(rows);
  }

  Future<void> deleteUserData(String userId) async {
    if (_deleteFn != null) {
      await _deleteFn(userId);
    } else {
      await _client!
          .rpc<void>('gdpr_delete_user', params: {'p_user_id': userId});
    }
  }
}
