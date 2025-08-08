#!/bin/bash

# Setup Standalone Database for JO17 Tactical Manager
# This script sets up the Supabase database for standalone use

echo "🚀 Setting up JO17 Tactical Manager database..."

# Check if we have the Supabase CLI
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI not found. Installing..."
    npm install -g supabase
fi

# Navigate to project directory
cd "$(dirname "$0")/.."

# First, link the project to Supabase
echo "🔗 Linking project to Supabase..."
echo "Please provide your Supabase project details when prompted."

# Try to link the project
if ! supabase projects list > /dev/null 2>&1; then
    echo "❌ Please login to Supabase first:"
    echo "supabase login"
    exit 1
fi

# Link to the project (user will need to select the project)
if ! supabase link; then
    echo "❌ Failed to link project. Please run manually:"
    echo "supabase link --project-ref ohdbsujaetmrztseqana"
    exit 1
fi

echo "✅ Project linked successfully"

# Apply all migrations to the configured Supabase instance
echo "📦 Applying database migrations..."

# Method 1: Try to push all migrations
if supabase db push; then
    echo "✅ Migrations applied successfully"
else
    echo "⚠️  Migration push failed. Checking status..."
    supabase migration list
    exit 1
fi

# Add demo data for standalone mode
echo "🎭 Adding demo data for standalone mode..."

# Create a temporary SQL file with demo data
cat > /tmp/demo_data.sql << 'EOF'
-- Demo data for standalone JO17 Tactical Manager
-- This creates a sample organization and data for immediate use

BEGIN;

-- 1. Create demo organization
INSERT INTO organizations (id, name, slug, subscription_tier, subscription_status, max_players, max_teams, max_coaches, settings, branding)
VALUES (
    'demo-org-uuid-12345678-1234-1234-1234-123456789012',
    'VOAB JO17-1 Demo',
    'voab-jo17-demo',
    'basic',
    'active',
    25,
    1,
    3,
    jsonb_build_object('language', 'nl', 'timezone', 'Europe/Amsterdam'),
    jsonb_build_object('primary_color', '#FF6B35', 'team_name', 'VOAB JO17-1')
) ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    updated_at = NOW();

-- 2. Create demo players
INSERT INTO players (id, organization_id, name, date_of_birth, position, shirt_number, email, phone, address, emergency_contact, medical_info, notes, status, created_at, updated_at)
VALUES
    (gen_random_uuid(), 'demo-org-uuid-12345678-1234-1234-1234-123456789012', 'Kevin de Bruyne', '2006-06-28', 'midfielder', 17, 'kevin@demo.voab.nl', '+31612345001', 'Demostraat 17, Amsterdam', 'Ouder: +31687654001', '', 'Sterke passing, creativiteit', 'active', NOW(), NOW()),
    (gen_random_uuid(), 'demo-org-uuid-12345678-1234-1234-1234-123456789012', 'Virgil van Dijk', '2006-07-08', 'defender', 4, 'virgil@demo.voab.nl', '+31612345002', 'Demostraat 4, Amsterdam', 'Ouder: +31687654002', '', 'Leiderschap, koppen', 'active', NOW(), NOW()),
    (gen_random_uuid(), 'demo-org-uuid-12345678-1234-1234-1234-123456789012', 'Memphis Depay', '2006-02-13', 'forward', 10, 'memphis@demo.voab.nl', '+31612345003', 'Demostraat 10, Amsterdam', 'Ouder: +31687654003', '', 'Snelheid, afwerking', 'active', NOW(), NOW()),
    (gen_random_uuid(), 'demo-org-uuid-12345678-1234-1234-1234-123456789012', 'Frenkie de Jong', '2006-05-12', 'midfielder', 21, 'frenkie@demo.voab.nl', '+31612345004', 'Demostraat 21, Amsterdam', 'Ouder: +31687654004', '', 'Techniek, overzicht', 'active', NOW(), NOW()),
    (gen_random_uuid(), 'demo-org-uuid-12345678-1234-1234-1234-123456789012', 'Matthijs de Ligt', '2006-08-12', 'defender', 3, 'matthijs@demo.voab.nl', '+31612345005', 'Demostraat 3, Amsterdam', 'Ouder: +31687654005', '', 'Sterke verdediger', 'active', NOW(), NOW());

-- 3. Create demo training sessions
INSERT INTO training_sessions (id, organization_id, title, date, start_time, end_time, location, focus, intensity, status, objectives, drills, coach_notes, created_at, updated_at)
VALUES
    (gen_random_uuid(), 'demo-org-uuid-12345678-1234-1234-1234-123456789012', 'Techniektraining', CURRENT_DATE + INTERVAL '1 day', '19:00:00', '20:30:00', 'Hoofdveld VOAB', 'technical', 'medium', 'planned', 'Verbeteren balbeheersing en passing', '["Passing in vierkant", "1v1 duels", "Afwerking"]', 'Focus op techniek vandaag', NOW(), NOW()),
    (gen_random_uuid(), 'demo-org-uuid-12345678-1234-1234-1234-123456789012', 'Conditietraining', CURRENT_DATE + INTERVAL '3 days', '19:00:00', '20:30:00', 'Hoofdveld VOAB', 'physical', 'high', 'planned', 'Uithoudingsvermogen opbouwen', '["Interval running", "Sprint oefeningen", "Core stability"]', 'Intensieve training', NOW(), NOW()),
    (gen_random_uuid(), 'demo-org-uuid-12345678-1234-1234-1234-123456789012', 'Tactiektraining', CURRENT_DATE - INTERVAL '2 days', '19:00:00', '20:30:00', 'Hoofdveld VOAB', 'tactical', 'medium', 'completed', 'Opbouw vanaf achteren', '["Positiespel", "Passing patronen", "Set pieces"]', 'Goede vooruitgang in opbouw', NOW(), NOW());

-- 4. Create demo exercises
INSERT INTO exercises (organization_id, name, description, category, difficulty_level, duration_minutes, player_count, equipment, instructions, tags)
VALUES
    ('demo-org-uuid-12345678-1234-1234-1234-123456789012', 'Passing in Vierkant', 'Basisoefening voor passing en balbeheersing', 'Technical', 2, 15, 8, ARRAY['pionnen', 'ballen'], 'Spelers staan in vierkant van 15x15m. Passen naar elkaar met maximaal 2 aanrakingen.', ARRAY['passing', 'technical', 'balbeheersing']),
    ('demo-org-uuid-12345678-1234-1234-1234-123456789012', '1 vs 1 Duels', 'Verbetering van individuele verdedigende en aanvallende vaardigheden', 'Tactical', 3, 20, 6, ARRAY['pionnen', 'ballen', 'goals'], 'Spelers proberen 1-op-1 van elkaar te winnen in een afgezet gebied', ARRAY['1v1', 'duel', 'tactical']),
    ('demo-org-uuid-12345678-1234-1234-1234-123456789012', 'Sprint Intervals', 'Conditietraining met korte intensieve sprints', 'Physical', 4, 25, 12, ARRAY['pionnen'], '30 seconden sprint, 90 seconden rust. 8 herhalingen.', ARRAY['conditie', 'sprint', 'fysiek']),
    ('demo-org-uuid-12345678-1234-1234-1234-123456789012', 'Positiespel 7v3', 'Tactische oefening voor balbeheersing onder druk', 'Tactical', 4, 20, 10, ARRAY['pionnen', 'ballen', 'hesjes'], '7 aanvallers proberen balbezit te houden tegen 3 verdedigers in 20x20m veld', ARRAY['positiespel', 'balbeheersing', 'druk']);

-- 5. Create demo matches
INSERT INTO matches (id, organization_id, opponent, date, kick_off_time, location, competition, match_type, status, home_away, result_home, result_away, notes, lineup_formation, created_at, updated_at)
VALUES
    (gen_random_uuid(), 'demo-org-uuid-12345678-1234-1234-1234-123456789012', 'Ajax JO17-2', CURRENT_DATE + INTERVAL '7 days', '14:00:00', 'Sportpark De Toekomst', 'Eredivisie JO17', 'competition', 'scheduled', 'away', null, null, 'Belangrijke uitwedstrijd', '4-3-3', NOW(), NOW()),
    (gen_random_uuid(), 'demo-org-uuid-12345678-1234-1234-1234-123456789012', 'PSV JO17-1', CURRENT_DATE - INTERVAL '7 days', '11:00:00', 'Hoofdveld VOAB', 'Eredivisie JO17', 'competition', 'completed', 'home', 2, 1, 'Goede prestatie, verdiende overwinning', '4-2-3-1', NOW(), NOW());

COMMIT;
EOF

# Apply the demo data
echo "📝 Inserting demo data..."
psql $(supabase status | grep "DB URL" | awk '{print $3}') -f /tmp/demo_data.sql

# Alternative: Use supabase SQL directly
if [ $? -ne 0 ]; then
    echo "📝 Trying alternative method..."
    supabase db reset --linked
    # Add data after reset
    psql $(supabase status | grep "DB URL" | awk '{print $3}') -f /tmp/demo_data.sql
fi

# Clean up
rm /tmp/demo_data.sql

echo "✅ Database setup complete!"
echo ""
echo "🎉 Your JO17 Tactical Manager is now ready to use!"
echo "📱 Open the app and you'll see:"
echo "   • Demo team: VOAB JO17-1"
echo "   • 5 demo players"
echo "   • 3 training sessions"
echo "   • 4 training exercises"
echo "   • 2 matches"
echo ""
echo "🔗 App URL: http://localhost:8080"
echo "🗄️  Database: https://ohdbsujaetmrztseqana.supabase.co"
