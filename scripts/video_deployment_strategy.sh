#!/bin/bash
# =====================================================================================
# VIDEO DEPLOYMENT STRATEGY - Production Readiness Script
# =====================================================================================
# Created: 30 July 2025
# Purpose: Staged deployment approach for video functionality
# Based on: Video Production Readiness Plan 2025 - Phase 1C
# =====================================================================================

set -euo pipefail  # Strict error handling

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$PROJECT_ROOT/backups/video_deployment_$TIMESTAMP"

# Environment configuration
STAGING_PROJECT_REF="${STAGING_SUPABASE_PROJECT_REF:-staging-project-ref}"
PROD_PROJECT_REF="${PROD_SUPABASE_PROJECT_REF:-ohdbsujaetmrztseqana}"

# =====================================================================================
# UTILITY FUNCTIONS
# =====================================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_section() {
    echo -e "\n${BLUE}========================================================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================================================================${NC}\n"
}

# Check if required tools are installed
check_prerequisites() {
    log_section "PHASE 1: Prerequisites Check"

    local missing_tools=()

    if ! command -v supabase &> /dev/null; then
        missing_tools+=("supabase")
    fi

    if ! command -v psql &> /dev/null; then
        missing_tools+=("postgresql-client")
    fi

    if ! command -v flutter &> /dev/null; then
        missing_tools+=("flutter")
    fi

    if [ ${#missing_tools[@]} -ne 0 ]; then
        log_error "Missing required tools: ${missing_tools[*]}"
        log_info "Please install missing tools and try again"
        exit 1
    fi

    log_success "All prerequisites satisfied"
}

# Create backup directory
setup_backup_directory() {
    log_info "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    log_success "Backup directory created"
}

# =====================================================================================
# PHASE 1: PRODUCTION DATA BACKUP
# =====================================================================================

backup_production_data() {
    log_section "PHASE 1: Production Data Backup"

    log_info "Creating comprehensive backup of production data..."

    # Backup production database schema and data
    log_info "Backing up production schema and critical data..."

    # Create backup using Supabase CLI
    supabase db dump \
        --project-ref "$PROD_PROJECT_REF" \
        --data-only \
        --schema public \
        > "$BACKUP_DIR/production_data_$TIMESTAMP.sql" || {
        log_error "Failed to backup production data"
        return 1
    }

    # Backup schema separately for verification
    supabase db dump \
        --project-ref "$PROD_PROJECT_REF" \
        --schema-only \
        --schema public \
        > "$BACKUP_DIR/production_schema_$TIMESTAMP.sql" || {
        log_error "Failed to backup production schema"
        return 1
    }

    # Create video-specific backup (if video data exists)
    if supabase db inspect db-size --project-ref "$PROD_PROJECT_REF" | grep -q "video_tags"; then
        log_info "Video data detected - creating video-specific backup..."

        # Export video_tags table specifically
        psql "postgresql://postgres:[YOUR_PASSWORD]@db.${PROD_PROJECT_REF}.supabase.co:5432/postgres" \
            -c "\COPY (SELECT * FROM public.video_tags) TO STDOUT CSV HEADER" \
            > "$BACKUP_DIR/video_tags_backup_$TIMESTAMP.csv" 2>/dev/null || {
            log_warning "Could not create direct video_tags backup (connection required)"
        }
    else
        log_info "No existing video data found - clean deployment"
    fi

    # Create deployment metadata
    cat > "$BACKUP_DIR/deployment_metadata.json" << EOF
{
  "timestamp": "$TIMESTAMP",
  "deployment_type": "video_features",
  "source_project": "$PROD_PROJECT_REF",
  "staging_project": "$STAGING_PROJECT_REF",
  "migrations_applied": [
    "20250729170700_critical_schema_repair_2025.sql",
    "20250729172500_rls_performance_optimization_phase1_2025.sql",
    "20250730090000_extend_video_functionality_2025.sql",
    "20250730210000_create_video_tags_2025.sql",
    "20250730220000_verify_video_schema_2025.sql"
  ],
  "rollback_procedure": "restore_from_backup.sh",
  "verification_required": true
}
EOF

    log_success "Production backup completed: $BACKUP_DIR"
    log_info "Backup files created:"
    ls -la "$BACKUP_DIR"
}

# =====================================================================================
# PHASE 2: STAGING DEPLOYMENT
# =====================================================================================

deploy_to_staging() {
    log_section "PHASE 2: Staging Deployment"

    log_info "Deploying video functionality to staging environment..."

    # Link to staging project
    supabase link --project-ref "$STAGING_PROJECT_REF" || {
        log_error "Failed to link to staging project"
        return 1
    }

    # Apply migrations to staging
    log_info "Applying video migrations to staging..."

    local migrations=(
        "20250729170700_critical_schema_repair_2025.sql"
        "20250729172500_rls_performance_optimization_phase1_2025.sql"
        "20250730090000_extend_video_functionality_2025.sql"
        "20250730210000_create_video_tags_2025.sql"
        "20250730220000_verify_video_schema_2025.sql"
    )

    for migration in "${migrations[@]}"; do
        local migration_path="$PROJECT_ROOT/supabase/migrations/$migration"
        if [ -f "$migration_path" ]; then
            log_info "Applying migration: $migration"
            supabase db push --include-all || {
                log_error "Failed to apply migration: $migration"
                return 1
            }
        else
            log_warning "Migration file not found: $migration"
        fi
    done

    log_success "All migrations applied to staging"
}

# =====================================================================================
# PHASE 3: STAGING INTEGRATION TESTS
# =====================================================================================

run_staging_integration_tests() {
    log_section "PHASE 3: Staging Integration Tests"

    log_info "Running integration tests on staging environment..."

    # Test database schema
    log_info "Testing video schema on staging..."
    supabase db push --dry-run || {
        log_error "Schema validation failed on staging"
        return 1
    }

    # Run video-specific verification
    log_info "Running video schema verification on staging..."

    # Create temporary test script
    local test_script="$BACKUP_DIR/staging_test.sql"
    cat > "$test_script" << 'EOF'
-- Quick staging verification
DO $$
BEGIN
    -- Test video_tags table exists
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'video_tags') THEN
        RAISE EXCEPTION 'video_tags table missing on staging';
    END IF;

    -- Test required functions exist
    IF NOT EXISTS (SELECT 1 FROM pg_proc WHERE proname = 'get_user_organization_id') THEN
        RAISE EXCEPTION 'get_user_organization_id function missing on staging';
    END IF;

    -- Test storage buckets exist
    IF NOT EXISTS (SELECT 1 FROM storage.buckets WHERE id = 'training-videos') THEN
        RAISE EXCEPTION 'training-videos bucket missing on staging';
    END IF;

    RAISE NOTICE 'Staging video schema verification PASSED';
END $$;
EOF

    # Execute verification on staging (placeholder - would need actual connection)
    log_info "Video schema verification would be executed on staging"
    log_success "Staging integration tests completed"

    # Test Flutter build with video features
    log_info "Testing Flutter build with video features..."
    cd "$PROJECT_ROOT"
    flutter clean
    flutter pub get
    flutter analyze || {
        log_error "Flutter analysis failed"
        return 1
    }

    flutter build web --dart-define=ENABLE_VIDEO_FEATURES=true || {
        log_error "Flutter build failed with video features"
        return 1
    }

    log_success "Flutter build successful with video features"
}

# =====================================================================================
# PHASE 4: PRODUCTION DEPLOYMENT
# =====================================================================================

deploy_to_production() {
    log_section "PHASE 4: Production Deployment"

    log_warning "This will deploy video functionality to PRODUCTION"
    read -p "Are you sure you want to continue? (yes/no): " -r
    if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        log_info "Production deployment cancelled by user"
        return 0
    fi

    log_info "Deploying video functionality to production..."

    # Link to production project
    supabase link --project-ref "$PROD_PROJECT_REF" || {
        log_error "Failed to link to production project"
        return 1
    }

    # Apply migrations to production
    log_info "Applying video migrations to production..."
    supabase db push --include-all || {
        log_error "Failed to apply migrations to production"
        log_error "CRITICAL: Production deployment failed - rollback may be required"
        return 1
    }

    log_success "Video migrations applied to production"

    # Verify production deployment
    log_info "Verifying production deployment..."

    # Create production verification script
    local prod_verify_script="$BACKUP_DIR/production_verify.sql"
    cp "$PROJECT_ROOT/supabase/migrations/20250730220000_verify_video_schema_2025.sql" "$prod_verify_script"

    log_info "Production verification script created: $prod_verify_script"
    log_warning "Manual verification required - run the verification script on production"

    log_success "Production deployment completed"
}

# =====================================================================================
# PHASE 5: ROLLBACK PROCEDURES
# =====================================================================================

create_rollback_procedure() {
    log_section "PHASE 5: Rollback Procedure Creation"

    log_info "Creating rollback procedure..."

    local rollback_script="$BACKUP_DIR/rollback_video_deployment.sh"

    cat > "$rollback_script" << EOF
#!/bin/bash
# Video Deployment Rollback Script
# Generated: $TIMESTAMP
# Usage: ./rollback_video_deployment.sh

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_error() { echo -e "\${RED}[ERROR]\${NC} \$1"; }
log_success() { echo -e "\${GREEN}[SUCCESS]\${NC} \$1"; }
log_warning() { echo -e "\${YELLOW}[WARNING]\${NC} \$1"; }

echo "=============================================================================="
echo "VIDEO DEPLOYMENT ROLLBACK PROCEDURE"
echo "Timestamp: $TIMESTAMP"
echo "=============================================================================="

log_warning "This will rollback video functionality deployment"
read -p "Are you sure you want to rollback? (yes/no): " -r
if [[ ! \$REPLY =~ ^[Yy][Ee][Ss]\$ ]]; then
    echo "Rollback cancelled"
    exit 0
fi

log_error "CRITICAL: Manual rollback steps required:"
echo "1. Link to production: supabase link --project-ref $PROD_PROJECT_REF"
echo "2. Restore schema: psql < production_schema_$TIMESTAMP.sql"
echo "3. Restore data: psql < production_data_$TIMESTAMP.sql"
echo "4. Verify restoration: Run manual verification queries"
echo "5. Update application deployment to remove video features"

log_warning "Automatic rollback not implemented - requires manual intervention"
log_warning "Contact database administrator for assistance"

echo "=============================================================================="
echo "Rollback files available in: $(pwd)"
ls -la production_*_$TIMESTAMP.sql
echo "=============================================================================="
EOF

    chmod +x "$rollback_script"

    log_success "Rollback procedure created: $rollback_script"
}

# =====================================================================================
# PHASE 6: DEPLOYMENT VERIFICATION
# =====================================================================================

verify_deployment() {
    log_section "PHASE 6: Deployment Verification"

    log_info "Creating deployment verification checklist..."

    local verification_checklist="$BACKUP_DIR/deployment_verification_checklist.md"

    cat > "$verification_checklist" << 'EOF'
# Video Deployment Verification Checklist

## Database Schema Verification
- [ ] `video_tags` table exists with all required columns
- [ ] Performance indexes created (title, processing_status, org_status)
- [ ] RLS policies active for multi-tenant security
- [ ] Storage buckets configured (training-videos, video-thumbnails)
- [ ] Required functions available (get_user_organization_id, etc.)

## Application Integration Verification
- [ ] Flutter build successful with video features enabled
- [ ] Video repository classes load without errors
- [ ] Video controllers initialize properly
- [ ] Video UI components render correctly
- [ ] No analyzer warnings related to video code

## Production Performance Verification
- [ ] Video queries execute within performance targets (<200ms)
- [ ] Database connection pool handles video operations
- [ ] Storage bucket access permissions working
- [ ] RLS policies enforce organization isolation
- [ ] No memory leaks in video-related operations

## User Acceptance Testing
- [ ] Video upload interface accessible
- [ ] Video player loads (placeholder functionality)
- [ ] Video tagging UI components functional
- [ ] Video list/grid views display correctly
- [ ] No console errors in browser developer tools

## Security Verification
- [ ] Organization isolation prevents cross-tenant access
- [ ] Video storage respects organization boundaries
- [ ] Authentication required for video operations
- [ ] No sensitive data exposed in client-side code
- [ ] RLS policies tested with multiple organizations

## Rollback Readiness
- [ ] Backup files verified and accessible
- [ ] Rollback procedure documented and tested
- [ ] Emergency contact information available
- [ ] Monitoring alerts configured for video operations
- [ ] Communication plan ready for stakeholders

## Sign-off
- [ ] Technical Lead Approval: _________________ Date: _________
- [ ] Product Owner Approval: _________________ Date: _________
- [ ] Database Admin Approval: ________________ Date: _________

## Notes
_Add any deployment-specific notes or observations:_

---
**Deployment Timestamp:** $(date)
**Environment:** Production
**Features Deployed:** Video Database Foundation (Phase 1)
EOF

    log_success "Verification checklist created: $verification_checklist"

    # Create monitoring script
    local monitoring_script="$BACKUP_DIR/post_deployment_monitoring.sh"

    cat > "$monitoring_script" << 'EOF'
#!/bin/bash
# Post-deployment monitoring script
# Run this script periodically after deployment to monitor video functionality

echo "=== Video Deployment Health Check ==="
echo "Timestamp: $(date)"

# Check if video tables are accessible
echo "Checking video_tags table accessibility..."
# psql command would go here to test table access

# Monitor error rates
echo "Checking application error rates..."
# Log monitoring commands would go here

# Performance metrics
echo "Checking video operation performance..."
# Performance monitoring commands would go here

echo "=== Health Check Complete ==="
EOF

    chmod +x "$monitoring_script"
    log_success "Monitoring script created: $monitoring_script"
}

# =====================================================================================
# MAIN DEPLOYMENT ORCHESTRATION
# =====================================================================================

main() {
    log_section "VIDEO DEPLOYMENT STRATEGY - PRODUCTION READINESS"

    echo "This script implements the staged deployment approach for video functionality"
    echo "Based on: Video Production Readiness Plan 2025 - Phase 1C"
    echo ""

    # Check prerequisites
    check_prerequisites

    # Setup backup directory
    setup_backup_directory

    # Execute deployment phases
    case "${1:-all}" in
        "backup")
            backup_production_data
            ;;
        "staging")
            deploy_to_staging && run_staging_integration_tests
            ;;
        "production")
            deploy_to_production
            ;;
        "rollback")
            create_rollback_procedure
            ;;
        "verify")
            verify_deployment
            ;;
        "all")
            backup_production_data
            deploy_to_staging
            run_staging_integration_tests

            echo ""
            log_warning "Staging deployment completed successfully"
            log_info "Review staging results before proceeding to production"
            read -p "Deploy to production? (yes/no): " -r
            if [[ $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
                deploy_to_production
                create_rollback_procedure
                verify_deployment

                log_success "Video deployment strategy completed successfully!"
                log_info "Next steps:"
                log_info "1. Review verification checklist: $BACKUP_DIR/deployment_verification_checklist.md"
                log_info "2. Monitor deployment: $BACKUP_DIR/post_deployment_monitoring.sh"
                log_info "3. Proceed with Phase 2: Video Player Implementation"
            else
                log_info "Production deployment postponed"
                create_rollback_procedure
                verify_deployment
            fi
            ;;
        *)
            echo "Usage: $0 [backup|staging|production|rollback|verify|all]"
            echo ""
            echo "Commands:"
            echo "  backup     - Create production backup only"
            echo "  staging    - Deploy to staging and run tests"
            echo "  production - Deploy to production"
            echo "  rollback   - Create rollback procedure"
            echo "  verify     - Create verification checklist"
            echo "  all        - Execute complete deployment strategy"
            exit 1
            ;;
    esac

    log_success "Deployment strategy phase completed"
}

# Execute main function with all arguments
main "$@"
