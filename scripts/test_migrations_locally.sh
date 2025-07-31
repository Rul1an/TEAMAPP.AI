#!/bin/bash

# Database Migration Testing Script - 2025 Best Practices
# Tests all migrations locally before pushing to prevent CI failures

set -e  # Exit on any error

echo "🧪 Starting Local Database Migration Testing..."
echo "================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DB_NAME="jo17_test_migrations"
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"
MIGRATIONS_DIR="supabase/migrations"

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

# Check if PostgreSQL is running
check_postgres() {
    print_status "Checking PostgreSQL connection..."
    if ! psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d postgres -c "SELECT 1;" > /dev/null 2>&1; then
        print_error "PostgreSQL is not running or connection failed"
        print_warning "Please start PostgreSQL: brew services start postgresql"
        exit 1
    fi
    print_status "PostgreSQL connection verified"
}

# Create test database
create_test_db() {
    print_status "Creating test database: $DB_NAME"
    psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d postgres -c "DROP DATABASE IF EXISTS $DB_NAME;" > /dev/null 2>&1
    psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d postgres -c "CREATE DATABASE $DB_NAME;" > /dev/null 2>&1
    print_status "Test database created"
}

# Test individual migration
test_migration() {
    local migration_file="$1"
    local migration_name=$(basename "$migration_file")

    echo ""
    print_status "Testing migration: $migration_name"
    echo "----------------------------------------"

    if psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -f "$migration_file" > /tmp/migration_output.log 2>&1; then
        print_status "Migration $migration_name executed successfully"
    else
        print_error "Migration $migration_name FAILED"
        echo "Error details:"
        cat /tmp/migration_output.log
        return 1
    fi
}

# Test all migrations in order
test_all_migrations() {
    print_status "Testing all migrations in chronological order..."

    local failed_migrations=()

    # Sort migrations by timestamp
    for migration_file in $(ls -1 "$MIGRATIONS_DIR"/*.sql 2>/dev/null | sort); do
        if ! test_migration "$migration_file"; then
            failed_migrations+=("$(basename "$migration_file")")
        fi
    done

    if [ ${#failed_migrations[@]} -eq 0 ]; then
        print_status "All migrations passed! ✨"
        return 0
    else
        print_error "Failed migrations:"
        for failed in "${failed_migrations[@]}"; do
            echo "  - $failed"
        done
        return 1
    fi
}

# Verify schema state after migrations
verify_schema() {
    print_status "Verifying final schema state..."

    # Check critical tables exist
    local required_tables=("organizations" "profiles" "teams" "players" "videos" "video_tags" "training_sessions" "matches")

    for table in "${required_tables[@]}"; do
        if psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -c "SELECT 1 FROM $table LIMIT 1;" > /dev/null 2>&1; then
            print_status "Table '$table' exists and accessible"
        else
            print_error "Table '$table' missing or inaccessible"
            return 1
        fi
    done

    # Check views don't have invalid indexes
    local problematic_views=$(psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -t -c "
        SELECT schemaname||'.'||viewname
        FROM pg_views
        WHERE schemaname = 'public'
    " | xargs)

    if [ ! -z "$problematic_views" ]; then
        print_warning "Found views that might have index issues:"
        echo "$problematic_views"
    fi

    print_status "Schema verification completed"
}

# Cleanup
cleanup() {
    print_status "Cleaning up test database..."
    psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d postgres -c "DROP DATABASE IF EXISTS $DB_NAME;" > /dev/null 2>&1
    rm -f /tmp/migration_output.log
    print_status "Cleanup completed"
}

# Main execution
main() {
    echo "Starting database migration testing pipeline..."

    # Trap cleanup on exit
    trap cleanup EXIT

    check_postgres
    create_test_db

    if test_all_migrations && verify_schema; then
        echo ""
        print_status "🎉 ALL MIGRATION TESTS PASSED!"
        print_status "Safe to push to GitHub"
        echo "================================================"
        exit 0
    else
        echo ""
        print_error "💥 MIGRATION TESTS FAILED!"
        print_error "DO NOT PUSH TO GITHUB"
        echo "================================================"
        exit 1
    fi
}

# Run main function
main "$@"
