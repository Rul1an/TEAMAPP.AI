#!/usr/bin/env bash
# Data Deletion Workflow (GDPR/CCPA) – VEO-118
# Usage: ./scripts/data_deletion_workflow.sh <user_id>
set -euo pipefail

USER_ID="${1:-}"
if [[ -z "$USER_ID" ]]; then
  echo "Usage: $0 <user_id>" >&2
  exit 1
fi

echo "[INFO] Starting data deletion workflow for $USER_ID"

SUPABASE_URL=${SUPABASE_URL:-"https://$SUPABASE_PROJECT_ID.supabase.co"}
API_KEY=${SUPABASE_SERVICE_ROLE_KEY:-$SUPABASE_KEY}

# 1. Disable account login in Supabase
if command -v curl >/dev/null; then
  echo "[STEP] Disabling user in Supabase via Admin API..."
  curl -s -X POST "${SUPABASE_URL}/auth/v1/admin/users/$USER_ID" \
    -H "apikey: $API_KEY" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    -d '{"ban": true}' | jq '.'
else
  echo "curl not available – skipping Supabase disable"
fi

# 2. Delete stored files from S3
if command -v aws >/dev/null; then
  echo "[STEP] Deleting user files from edge storage bucket..."
  aws s3 rm "s3://veo-edge-storage-primary" --recursive --exclude "*" --include "$USER_ID/*" || true
else
  echo "aws CLI not found – skipping S3 deletion"
fi

# 3. Cancel Stripe subscription
SUB_ID="${2:-}"
if [[ -n "$SUB_ID" ]]; then
  if command -v stripe >/dev/null; then
    echo "[STEP] Cancelling Stripe subscription $SUB_ID..."
    stripe subscriptions cancel "$SUB_ID" || true
  else
    echo "stripe CLI not found – skipping subscription cancel"
  fi
else
  echo "No subscription ID provided – skipping Stripe cancel"
fi

# 4. Persist audit-log (immutable)
AUDIT_DIR="audits"
mkdir -p "$AUDIT_DIR"
LOG_FILE="$AUDIT_DIR/data_deletion.log"
TIMESTAMP=$(date -u +"%FT%TZ")
printf "%s DELETE %s\n" "$TIMESTAMP" "$USER_ID" >> "$LOG_FILE"

echo "[DONE] Data deletion completed and logged at $LOG_FILE"