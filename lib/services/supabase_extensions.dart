// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../config/supabase_config.dart';

/// Extensions that automatically scope Supabase queries to the current
/// `organization_id` stored in the authenticated user's metadata. This ensures
/// all selects / mutations respect Row-Level-Security policies.
extension OrganizationScopedQueries on SupabaseClient {
  /// Returns a [PostgrestFilterBuilder] already filtered on the
  /// `organization_id` column. Throws if the user has no organization selected
  /// (this should be set after login via `setCurrentOrganizationId`).
  PostgrestFilterBuilder<dynamic> fromOrg(String table) {
    final orgId = currentOrganizationId;
    if (orgId == null) {
      throw StateError(
        'Current user has no organization_id claim. Call setCurrentOrganizationId() after sign-in.',
      );
    }
    return from(table).select().eq('organization_id', orgId);
  }

  /// Convenience helper to insert a single row with the current organization
  /// injected automatically.
  PostgrestTransformBuilder<dynamic> orgInsert(
    String table,
    Map<String, dynamic> values,
  ) {
    final orgId = currentOrganizationId;
    if (orgId == null) {
      throw StateError('No organization_id found in user metadata');
    }
    return from(table).insert({...values, 'organization_id': orgId});
  }
}
