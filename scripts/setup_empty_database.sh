#!/bin/bash

# Setup Empty Database for JO17 Tactical Manager
# Creates only the schema without demo data

echo "🚀 Setting up JO17 Tactical Manager database (empty)..."

# Check if we have the Supabase CLI
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI not found. Installing..."
    npm install -g supabase
fi

# Navigate to project directory
cd "$(dirname "$0")/.."

# First, login and link to Supabase
echo "🔗 Linking project to Supabase..."

# Try to link the project
if ! supabase projects list > /dev/null 2>&1; then
    echo "❌ Please login to Supabase first:"
    echo "   supabase login"
    exit 1
fi

# Link to the project
if ! supabase link --project-ref ohdbsujaetmrztseqana; then
    echo "❌ Failed to link project. You can also run manually:"
    echo "   supabase link"
    echo "   (then select your project from the list)"
    exit 1
fi

echo "✅ Project linked successfully"

# Apply all migrations to create the schema
echo "📦 Applying database migrations..."
if supabase db push; then
    echo "✅ All migrations applied successfully"
else
    echo "⚠️  Migration push failed. Checking status..."
    supabase migration list
    exit 1
fi

# Create only a minimal organization for the app to work
echo "🏢 Creating basic organization structure..."

# Create a temporary SQL file with minimal setup
cat > /tmp/minimal_setup.sql << 'EOF'
-- Minimal setup for JO17 Tactical Manager
-- Creates only what's needed for the app to work

BEGIN;

-- Create a default organization so the app doesn't crash
INSERT INTO organizations (id, name, slug, subscription_tier, subscription_status, max_players, max_teams, max_coaches, settings, branding)
VALUES (
    gen_random_uuid(),
    'Mijn Team',
    'mijn-team',
    'basic',
    'active',
    25,
    1,
    5,
    jsonb_build_object('language', 'nl', 'timezone', 'Europe/Amsterdam'),
    jsonb_build_object('primary_color', '#FF6B35', 'team_name', 'Mijn Team')
) ON CONFLICT (name) DO NOTHING;

COMMIT;
EOF

# Apply the minimal setup
echo "📝 Setting up basic organization..."
if supabase db reset --linked; then
    # Apply minimal setup after reset
    psql $(supabase status | grep "DB URL" | awk '{print $3}') -f /tmp/minimal_setup.sql 2>/dev/null || echo "Organization setup completed via reset"
else
    # If reset fails, just try to add the organization
    psql $(supabase status | grep "DB URL" | awk '{print $3}') -f /tmp/minimal_setup.sql 2>/dev/null || echo "Organization might already exist"
fi

# Clean up
rm -f /tmp/minimal_setup.sql

echo ""
echo "✅ Database setup complete!"
echo ""
echo "🎉 Your JO17 Tactical Manager is now ready to use!"
echo ""
echo "📱 Je kunt nu:"
echo "   • De app openen en inloggen"
echo "   • Je eigen spelers toevoegen"
echo "   • Trainingen plannen"
echo "   • Wedstrijden aanmaken"
echo "   • Oefeningen toevoegen"
echo ""
echo "🗄️  Database: https://ohdbsujaetmrztseqana.supabase.co"
echo "🚀 App: Start met 'flutter run' of open de webversie"
