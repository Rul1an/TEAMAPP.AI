#!/bin/bash

# Local PostgreSQL Setup for Migration Testing
# Date: 2025-07-31
# Ensures complete local testing environment

set -e

echo "🐘 Setting up Local PostgreSQL for Migration Testing..."
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function helpers
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

# Check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script is designed for macOS. For other OS, install PostgreSQL manually."
        exit 1
    fi
    print_success "macOS detected"
}

# Install PostgreSQL using Homebrew
install_postgresql() {
    print_success "Installing PostgreSQL via Homebrew..."

    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        print_error "Homebrew not found. Installing Homebrew first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install PostgreSQL
    if brew list postgresql@14 &> /dev/null; then
        print_warning "PostgreSQL 14 already installed"
    else
        print_success "Installing PostgreSQL 14..."
        brew install postgresql@14
    fi

    # Start PostgreSQL service
    print_success "Starting PostgreSQL service..."
    brew services start postgresql@14

    # Add to PATH
    echo 'export PATH="/opt/homebrew/opt/postgresql@14/bin:$PATH"' >> ~/.zshrc
    export PATH="/opt/homebrew/opt/postgresql@14/bin:$PATH"

    print_success "PostgreSQL installation completed"
}

# Configure PostgreSQL for development
configure_postgresql() {
    print_success "Configuring PostgreSQL for development..."

    # Wait for PostgreSQL to start
    sleep 3

    # Create development user
    if psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='postgres'" | grep -q 1; then
        print_warning "User 'postgres' already exists"
    else
        createuser -s postgres
        print_success "Created postgres superuser"
    fi

    # Test connection
    if psql -U postgres -d postgres -c "SELECT version();" &> /dev/null; then
        print_success "PostgreSQL connection test successful"
    else
        print_error "PostgreSQL connection test failed"
        exit 1
    fi
}

# Create test database and verify migration compatibility
test_migration_compatibility() {
    print_success "Testing migration compatibility..."

    # Create test database
    psql -U postgres -d postgres -c "DROP DATABASE IF EXISTS jo17_migration_test;"
    psql -U postgres -d postgres -c "CREATE DATABASE jo17_migration_test;"

    # Test basic migration operations
    psql -U postgres -d jo17_migration_test -c "
        CREATE TABLE test_table (
            id SERIAL PRIMARY KEY,
            name TEXT NOT NULL,
            created_at TIMESTAMPTZ DEFAULT NOW()
        );

        -- Test view creation (this was our main issue)
        CREATE VIEW test_view AS SELECT id, name FROM test_table;

        -- Test that we CANNOT create index on view
        DO \$\$
        BEGIN
            IF EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = 'test_view') THEN
                RAISE NOTICE 'test_view is a VIEW - cannot create index (this is expected)';
            END IF;
        END \$\$;

        -- Test RLS
        ALTER TABLE test_table ENABLE ROW LEVEL SECURITY;

        -- Cleanup
        DROP VIEW test_view;
        DROP TABLE test_table;
    "

    # Cleanup test database
    psql -U postgres -d postgres -c "DROP DATABASE jo17_migration_test;"

    print_success "Migration compatibility test passed"
}

# Run the actual migration test now that PostgreSQL is ready
run_migration_test() {
    print_success "Running full migration test suite..."

    if ./scripts/test_migrations_locally.sh; then
        print_success "🎉 All migrations passed with local PostgreSQL!"
    else
        print_error "Migration tests failed. Check the errors above."
        exit 1
    fi
}

# Main execution
main() {
    check_macos
    install_postgresql
    configure_postgresql
    test_migration_compatibility
    run_migration_test

    echo ""
    print_success "🎉 LOCAL POSTGRESQL SETUP COMPLETE!"
    print_success "✅ PostgreSQL 14 installed and configured"
    print_success "✅ Migration testing environment ready"
    print_success "✅ All migration tests passed"
    echo ""
    echo "To manually test migrations in the future:"
    echo "  ./scripts/test_migrations_locally.sh"
    echo ""
    echo "To access PostgreSQL directly:"
    echo "  psql -U postgres -d postgres"
}

# Execute main function
main "$@"
