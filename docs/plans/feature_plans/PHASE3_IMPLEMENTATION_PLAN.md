# Phase 3: Multi-Tenant Architecture Implementation Plan

## Overview
Transform the JO17 Tactical Manager into a true multi-tenant SaaS application where multiple football clubs can use the platform with complete data isolation.

## Database Schema

### 1. Organizations Table
```sql
CREATE TABLE organizations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  tier TEXT NOT NULL DEFAULT 'basic' CHECK (tier IN ('basic', 'pro', 'enterprise')),
  logo_url TEXT,
  primary_color TEXT DEFAULT '#1976D2',
  secondary_color TEXT DEFAULT '#FFC107',
  settings JSONB DEFAULT '{
    "features": {
      "svs_enabled": false,
      "analytics_enabled": false,
      "api_access": false
    },
    "limits": {
      "max_players": 25,
      "max_teams": 1,
      "max_coaches": 2
    }
  }',
  subscription_status TEXT DEFAULT 'trial',
  subscription_end_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for slug lookups
CREATE INDEX idx_organizations_slug ON organizations(slug);
```

### 2. Organization Members
```sql
CREATE TABLE organization_members (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('bestuurder', 'hoofdcoach', 'assistant', 'speler')),
  permissions JSONB DEFAULT '{}',
  invited_by UUID REFERENCES auth.users(id),
  invited_at TIMESTAMPTZ,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  is_active BOOLEAN DEFAULT true,
  UNIQUE(organization_id, user_id)
);

-- Create indexes
CREATE INDEX idx_org_members_org_id ON organization_members(organization_id);
CREATE INDEX idx_org_members_user_id ON organization_members(user_id);
```

### 3. Update Existing Tables
```sql
-- Add organization_id to all entity tables
ALTER TABLE players ADD COLUMN organization_id UUID REFERENCES organizations(id);
ALTER TABLE teams ADD COLUMN organization_id UUID REFERENCES organizations(id);
ALTER TABLE training_sessions ADD COLUMN organization_id UUID REFERENCES organizations(id);
ALTER TABLE matches ADD COLUMN organization_id UUID REFERENCES organizations(id);
ALTER TABLE exercises ADD COLUMN organization_id UUID REFERENCES organizations(id);

-- Create indexes
CREATE INDEX idx_players_org_id ON players(organization_id);
CREATE INDEX idx_teams_org_id ON teams(organization_id);
CREATE INDEX idx_training_sessions_org_id ON training_sessions(organization_id);
CREATE INDEX idx_matches_org_id ON matches(organization_id);
CREATE INDEX idx_exercises_org_id ON exercises(organization_id);
```

## Row Level Security (RLS) Policies

### 1. Helper Functions
```sql
-- Get user's organizations
CREATE OR REPLACE FUNCTION get_user_organizations(user_id UUID)
RETURNS SETOF UUID AS $$
  SELECT organization_id
  FROM organization_members
  WHERE user_id = $1 AND is_active = true;
$$ LANGUAGE sql SECURITY DEFINER;

-- Check if user has role in organization
CREATE OR REPLACE FUNCTION user_has_role(user_id UUID, org_id UUID, required_role TEXT)
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM organization_members
    WHERE user_id = $1
    AND organization_id = $2
    AND role = $3
    AND is_active = true
  );
$$ LANGUAGE sql SECURITY DEFINER;
```

### 2. RLS Policies for Players
```sql
-- Enable RLS
ALTER TABLE players ENABLE ROW LEVEL SECURITY;

-- Select policy: Users can view players in their organization
CREATE POLICY "select_players" ON players
  FOR SELECT USING (
    organization_id IN (SELECT get_user_organizations(auth.uid()))
  );

-- Insert policy: Coaches and admins can add players
CREATE POLICY "insert_players" ON players
  FOR INSERT WITH CHECK (
    organization_id IN (SELECT get_user_organizations(auth.uid()))
    AND EXISTS (
      SELECT 1 FROM organization_members
      WHERE user_id = auth.uid()
      AND organization_id = players.organization_id
      AND role IN ('bestuurder', 'hoofdcoach')
      AND is_active = true
    )
  );

-- Update policy: Coaches and admins can update players
CREATE POLICY "update_players" ON players
  FOR UPDATE USING (
    organization_id IN (SELECT get_user_organizations(auth.uid()))
    AND EXISTS (
      SELECT 1 FROM organization_members
      WHERE user_id = auth.uid()
      AND organization_id = players.organization_id
      AND role IN ('bestuurder', 'hoofdcoach')
      AND is_active = true
    )
  );

-- Delete policy: Only admins can delete players
CREATE POLICY "delete_players" ON players
  FOR DELETE USING (
    user_has_role(auth.uid(), organization_id, 'bestuurder')
  );
```

## Implementation Steps

### Step 1: Database Migration (Week 1)
1. Create migration files
2. Test migrations on development database
3. Add RLS policies
4. Verify data isolation

### Step 2: Update Models (Week 1-2)
```dart
// lib/models/organization.dart
@freezed
class Organization with _$Organization {
  const factory Organization({
    required String id,
    required String name,
    required String slug,
    required OrganizationTier tier,
    String? logoUrl,
    required String primaryColor,
    required String secondaryColor,
    required OrganizationSettings settings,
    required SubscriptionStatus subscriptionStatus,
    DateTime? subscriptionEndDate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Organization;
}

// lib/models/organization_member.dart
@freezed
class OrganizationMember with _$OrganizationMember {
  const factory OrganizationMember({
    required String id,
    required String organizationId,
    required String userId,
    required UserRole role,
    required Map<String, dynamic> permissions,
    String? invitedBy,
    DateTime? invitedAt,
    required DateTime joinedAt,
    required bool isActive,
  }) = _OrganizationMember;
}
```

### Step 3: Create Organization Service (Week 2)
```dart
// lib/services/organization_service.dart
class OrganizationService {
  final SupabaseClient _supabase;

  Future<Organization> createOrganization({
    required String name,
    required String slug,
  }) async {
    // Implementation
  }

  Future<void> inviteMember({
    required String organizationId,
    required String email,
    required UserRole role,
  }) async {
    // Implementation
  }

  Future<List<OrganizationMember>> getMembers(String organizationId) async {
    // Implementation
  }
}
```

### Step 4: Update UI Components (Week 2-3)
1. Organization creation flow
2. Organization switcher
3. Member management screen
4. Invitation system
5. Organization settings

### Step 5: Testing (Week 3)
1. Unit tests for organization service
2. Integration tests for multi-tenancy
3. Security testing for data isolation
4. Performance testing with multiple organizations

## UI/UX Implementation

### 1. Organization Creation Flow
```dart
// lib/screens/organization/create_organization_screen.dart
class CreateOrganizationScreen extends ConsumerStatefulWidget {
  // Step 1: Organization details (name, slug)
  // Step 2: Choose plan (basic, pro, enterprise)
  // Step 3: Invite initial members
  // Step 4: Confirmation
}
```

### 2. Organization Switcher
```dart
// lib/widgets/organization/organization_switcher.dart
class OrganizationSwitcher extends ConsumerWidget {
  // Dropdown to switch between organizations
  // Show current organization
  // Quick access to organization settings
}
```

### 3. Member Management
```dart
// lib/screens/organization/members_screen.dart
class OrganizationMembersScreen extends ConsumerWidget {
  // List current members
  // Invite new members
  // Update member roles
  // Remove members
}
```

## API Endpoints

### Organizations
- `GET /api/organizations` - List user's organizations
- `POST /api/organizations` - Create new organization
- `GET /api/organizations/:id` - Get organization details
- `PUT /api/organizations/:id` - Update organization
- `DELETE /api/organizations/:id` - Delete organization

### Members
- `GET /api/organizations/:id/members` - List members
- `POST /api/organizations/:id/members` - Invite member
- `PUT /api/organizations/:id/members/:memberId` - Update member
- `DELETE /api/organizations/:id/members/:memberId` - Remove member

## Security Considerations

### 1. Data Isolation
- All queries must include organization_id filter
- RLS policies enforce organization boundaries
- No cross-organization data access

### 2. Permission Checks
- Role-based access control (RBAC)
- Feature-based permissions
- API rate limiting per organization

### 3. Audit Trail
```sql
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  organization_id UUID REFERENCES organizations(id),
  user_id UUID REFERENCES auth.users(id),
  action TEXT NOT NULL,
  resource_type TEXT NOT NULL,
  resource_id UUID,
  changes JSONB,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

## Migration Strategy

### For Existing Data
1. Create default organization for existing users
2. Assign all existing data to default organization
3. Update all queries to include organization filter
4. Test data isolation thoroughly

### Migration Script
```sql
-- Create default organization
INSERT INTO organizations (name, slug, tier)
VALUES ('Default Organization', 'default-org', 'basic')
RETURNING id;

-- Assign existing users to default organization
INSERT INTO organization_members (organization_id, user_id, role)
SELECT
  (SELECT id FROM organizations WHERE slug = 'default-org'),
  id,
  'hoofdcoach'
FROM auth.users;

-- Update existing data
UPDATE players SET organization_id = (SELECT id FROM organizations WHERE slug = 'default-org');
UPDATE teams SET organization_id = (SELECT id FROM organizations WHERE slug = 'default-org');
-- etc...
```

## Success Criteria

### Technical
- [ ] All data properly isolated by organization
- [ ] RLS policies working correctly
- [ ] No performance degradation
- [ ] All tests passing

### Functional
- [ ] Users can create organizations
- [ ] Users can invite team members
- [ ] Users can switch between organizations
- [ ] Organization settings working

### Security
- [ ] No data leaks between organizations
- [ ] Proper permission enforcement
- [ ] Audit trail functioning
- [ ] Rate limiting in place

## Timeline

### Week 1 (Dec 16-22)
- Database schema design
- Migration scripts
- RLS policies
- Model updates

### Week 2 (Dec 23-29)
- Organization service
- Basic UI components
- Integration with existing features

### Week 3 (Dec 30 - Jan 5)
- Member management
- Invitation system
- Testing & bug fixes

### Week 4 (Jan 6-12)
- Performance optimization
- Security audit
- Documentation
- Deployment preparation

---

Last Updated: December 2024
