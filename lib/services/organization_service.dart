// Package imports:
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import '../models/organization.dart';

class OrganizationService {
  OrganizationService({SupabaseClient? client})
      : _supabase = client ?? _tryGetSupabaseInstance();

  final SupabaseClient _supabase;

  // Returns Supabase.instance.client when Supabase.initialize was called, or
  // falls back to a dummy client for unit-test contexts where full
  // initialization is undesirable.
  static SupabaseClient _tryGetSupabaseInstance() {
    try {
      return Supabase.instance.client;
    } catch (_) {
      // Safe fallback; will never be used for real network calls in tests.
      return SupabaseClient('http://localhost', 'public-anon-key');
    }
  }

  Future<Organization> createOrganization({
    required String name,
    required String slug,
    OrganizationTier tier = OrganizationTier.basic,
  }) async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final response = await _supabase
          .from('organizations')
          .insert({
            'name': name,
            'slug': slug,
            'tier': tier.name,
            'created_at': now,
            'updated_at': now,
          })
          .select()
          .single();

      return _mapOrganization(response);
    } catch (e) {
      throw OrganizationException('Failed to create organization: $e');
    }
  }

  Future<Organization?> getOrganization(String id) async {
    try {
      final response = await _supabase
          .from('organizations')
          .select()
          .eq('id', id)
          .maybeSingle();

      return response == null ? null : _mapOrganization(response);
    } catch (e) {
      throw OrganizationException('Failed to get organization: $e');
    }
  }

  Future<List<Organization>> getUserOrganizations(String userId) async {
    try {
      final response = await _supabase
          .from('organization_members')
          .select('organizations(*)')
          .eq('user_id', userId) as List<dynamic>;

      return response
          .map(
            (row) =>
                _mapOrganization(row['organizations'] as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw OrganizationException('Failed to get user organizations: $e');
    }
  }

  Future<Organization> updateOrganization(Organization org) async {
    try {
      final response = await _supabase
          .from('organizations')
          .update({
            'name': org.name,
            'slug': org.slug,
            'tier': org.tier.name,
            'logo_url': org.logoUrl,
            'primary_color': org.primaryColor,
            'secondary_color': org.secondaryColor,
            'settings': org.settings,
            'subscription_status': org.subscriptionStatus,
            'subscription_end_date':
                org.subscriptionEndDate?.toIso8601String(),
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', org.id)
          .select()
          .single();

      return _mapOrganization(response);
    } catch (e) {
      throw OrganizationException('Failed to update organization: $e');
    }
  }

  Future<bool> isSlugAvailable(String slug) async {
    try {
      final response = await _supabase
          .from('organizations')
          .select('id')
          .eq('slug', slug)
          .maybeSingle();
      return response == null;
    } catch (e) {
      throw OrganizationException('Failed to check slug availability: $e');
    }
  }

  Organization _mapOrganization(Map<String, dynamic> data) =>
      Organization.fromJson({
        'id': data['id'],
        'name': data['name'],
        'slug': data['slug'],
        'tier': data['tier'],
        'logoUrl': data['logo_url'],
        'primaryColor': data['primary_color'],
        'secondaryColor': data['secondary_color'],
        'settings': data['settings'],
        'subscriptionStatus': data['subscription_status'],
        'subscriptionEndDate': data['subscription_end_date'],
        'createdAt': data['created_at'],
        'updatedAt': data['updated_at'],
      });
}

class OrganizationException implements Exception {
  OrganizationException(this.message);
  final String message;

  @override
  String toString() => message;
}

