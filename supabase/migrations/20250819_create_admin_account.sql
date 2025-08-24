-- Create admin account and organization for Roel Schuurkes
-- Migration: 20250819_create_admin_account.sql

-- Create the VOAB JO17 organization
INSERT INTO organizations (id, name, slug, description, subscription_tier, created_at, updated_at)
VALUES (
    'voab-jo17-production',
    'VOAB JO17',
    'voab-jo17',
    'VOAB JO17 Tactical Manager - Production Organization',
    'premium',
    NOW(),
    NOW()
) ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    subscription_tier = EXCLUDED.subscription_tier,
    updated_at = NOW();

-- Create admin profile for Roel Schuurkes
INSERT INTO profiles (id, email, full_name, role, organization_id, permissions, created_at, updated_at)
VALUES (
    'admin-user-roel',
    'roel@voab.nl',
    'Roel Schuurkes',
    'admin',
    'voab-jo17-production',
    ARRAY['*'], -- Full admin permissions
    NOW(),
    NOW()
) ON CONFLICT (id) DO UPDATE SET
    full_name = EXCLUDED.full_name,
    role = EXCLUDED.role,
    organization_id = EXCLUDED.organization_id,
    permissions = EXCLUDED.permissions,
    updated_at = NOW();

-- Create permissions record for admin access
INSERT INTO permissions (id, user_id, organization_id, role, permissions, granted_by, granted_at, created_at, updated_at)
VALUES (
    'perm-admin-roel',
    'admin-user-roel',
    'voab-jo17-production',
    'admin',
    ARRAY[
        'players.read', 'players.create', 'players.update', 'players.delete',
        'matches.read', 'matches.create', 'matches.update', 'matches.delete',
        'trainings.read', 'trainings.create', 'trainings.update', 'trainings.delete',
        'organizations.read', 'organizations.create', 'organizations.update', 'organizations.delete',
        'analytics.read', 'analytics.create', 'analytics.update', 'analytics.delete',
        'admin.all', 'export.all', 'import.all'
    ],
    'system',
    NOW(),
    NOW(),
    NOW()
) ON CONFLICT (id) DO UPDATE SET
    permissions = EXCLUDED.permissions,
    updated_at = NOW();

-- Create features access for the organization
INSERT INTO features (id, organization_id, feature_name, enabled, tier_required, created_at, updated_at)
VALUES
    ('feat-voab-players', 'voab-jo17-production', 'playerManagement', true, 'free', NOW(), NOW()),
    ('feat-voab-matches', 'voab-jo17-production', 'matchManagement', true, 'free', NOW(), NOW()),
    ('feat-voab-trainings', 'voab-jo17-production', 'trainingPlanning', true, 'free', NOW(), NOW()),
    ('feat-voab-analytics', 'voab-jo17-production', 'performanceAnalytics', true, 'premium', NOW(), NOW()),
    ('feat-voab-video', 'voab-jo17-production', 'video', true, 'premium', NOW(), NOW()),
    ('feat-voab-export', 'voab-jo17-production', 'importExport', true, 'premium', NOW(), NOW()),
    ('feat-voab-admin', 'voab-jo17-production', 'userManagement', true, 'premium', NOW(), NOW())
ON CONFLICT (id) DO UPDATE SET
    enabled = EXCLUDED.enabled,
    tier_required = EXCLUDED.tier_required,
    updated_at = NOW();

-- Enable RLS policies for the new organization data
-- This ensures proper data isolation in multi-tenant setup

COMMENT ON TABLE organizations IS 'Updated with VOAB JO17 production organization';
COMMENT ON TABLE profiles IS 'Updated with Roel Schuurkes admin profile';
COMMENT ON TABLE permissions IS 'Updated with full admin permissions for Roel';
COMMENT ON TABLE features IS 'Updated with premium features for VOAB JO17';