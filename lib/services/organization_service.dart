// TODO: Uncomment when implementing real Supabase queries
// import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/organization.dart';

class OrganizationService {
  // TODO: Add SupabaseClient when implementing real queries
  // final SupabaseClient _supabase = Supabase.instance.client;

  // For MVP: Simple organization creation
  Future<Organization> createOrganization({
    required String name,
    required String slug,
    OrganizationTier tier = OrganizationTier.basic,
  }) async {
    try {
      // For MVP: Create in-memory organization
      // TODO: Implement Supabase table creation
      final org = Organization(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        slug: slug,
        tier: tier,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // In real implementation, save to Supabase
      // final response = await _supabase
      //     .from('organizations')
      //     .insert(org.toJson())
      //     .select()
      //     .single();

      return org;
    } catch (e) {
      throw Exception('Failed to create organization: $e');
    }
  }

  // Get organization by ID
  Future<Organization?> getOrganization(String id) async {
    try {
      // For MVP: Return mock organization
      // TODO: Implement Supabase query
      if (id == 'default-org') {
        return Organization(
          id: id,
          name: 'Mijn Voetbalclub',
          slug: 'mijn-voetbalclub',
          tier: OrganizationTier.basic,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get organization: $e');
    }
  }

  // Get user's organizations
  Future<List<Organization>> getUserOrganizations(String userId) async {
    try {
      // For MVP: Return single default organization
      // TODO: Implement Supabase query with join on organization_members
      return [
        Organization(
          id: 'default-org',
          name: 'Mijn Voetbalclub',
          slug: 'mijn-voetbalclub',
          tier: OrganizationTier.basic,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    } catch (e) {
      throw Exception('Failed to get user organizations: $e');
    }
  }

  // Update organization
  Future<Organization> updateOrganization(Organization org) async {
    try {
      // For MVP: Return updated organization
      // TODO: Implement Supabase update
      return org.copyWith(updatedAt: DateTime.now());
    } catch (e) {
      throw Exception('Failed to update organization: $e');
    }
  }

  // Check if slug is available
  Future<bool> isSlugAvailable(String slug) async {
    try {
      // For MVP: Simple check
      // TODO: Implement Supabase query
      final reservedSlugs = ['admin', 'api', 'app', 'www', 'demo'];
      return !reservedSlugs.contains(slug.toLowerCase());
    } catch (e) {
      throw Exception('Failed to check slug availability: $e');
    }
  }
}
