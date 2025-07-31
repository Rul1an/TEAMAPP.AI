#!/usr/bin/env bash
# GameDay – Route 53 fail-over simulation
# Best Practices 2025: clean-code, ≤300 LOC, built-in observability, progressive enhancement.
set -euo pipefail

# --- Config ------------------------------------------------------------------
ZONE_ID="${ROUTE53_HOSTED_ZONE_ID:?ROUTE53_HOSTED_ZONE_ID required}"
PRIMARY_RECORD="${PRIMARY_RECORD_NAME:-api.example.com}"
SECONDARY_RECORD="${SECONDARY_RECORD_NAME:-api-dr.example.com}"
CLOUDWATCH_NS="VideoPlatform/GameDay"
DRY_RUN="${DRY_RUN:-false}"
RUN_ID="${RUN_ID:-$(date +%s)}"
LATENCY_THRESHOLD_MS=${LATENCY_THRESHOLD_MS:-500}

log() { echo "$(date --iso-8601=seconds) | $1"; }
metric() {
  aws cloudwatch put-metric-data \
    --namespace "$CLOUDWATCH_NS" \
    --metric-name "$1" \
    --value "$2" \
    --unit "$3" \
    --dimensions RunId="${RUN_ID}" >/dev/null || true
}

# --- Helpers -----------------------------------------------------------------
change_record() {
  local target=$1
  log "Switching Route53 record to $target (dry-run=$DRY_RUN)"
  $DRY_RUN && return 0 || true
  aws route53 change-resource-record-sets --hosted-zone-id "$ZONE_ID" \
    --change-batch "{\"Changes\":[{\"Action\":\"UPSERT\",\"ResourceRecordSet\":{\"Name\":\"$PRIMARY_RECORD\",\"Type\":\"CNAME\",\"TTL\":60,\"ResourceRecords\":[{\"Value\":\"$target\"}]}}]}" >/dev/null
}

measure_latency() {
  local url=$1
  local start_ts
  start_ts=$(date +%s%3N)
  curl -s -o /dev/null "$url"
  local end_ts=$(date +%s%3N)
  echo $((end_ts - start_ts))
}

validate_failover() {
  local latency
  latency=$(measure_latency "https://$PRIMARY_RECORD/health")
  log "Latency after fail-over: ${latency} ms"
  metric "LatencyMs" "$latency" "Milliseconds"
  if (( latency > LATENCY_THRESHOLD_MS )); then
    log "Latency above threshold (${LATENCY_THRESHOLD_MS} ms) – initiating rollback"
    return 1
  fi
  return 0
}

rollback() {
  log "Rolling back to primary endpoint"
  change_record "$PRIMARY_RECORD"
  metric "Rollback" 1 "Count"
}

# --- Main --------------------------------------------------------------------
log "GameDay start | run_id=$RUN_ID | zone=$ZONE_ID"
metric "Start" 1 "Count"

trap 'rollback; log "GameDay aborted"; metric "Aborted" 1 "Count"' ERR INT

# Step 1 switch to secondary
change_record "$SECONDARY_RECORD"

# Step 2 validate
if validate_failover; then
  log "Fail-over validated successfully (<${LATENCY_THRESHOLD_MS} ms)"
  metric "Success" 1 "Count"
else
  rollback
  exit 1
fi

# Step 3 rollback (clean-up)
rollback
log "GameDay completed successfully"
exit 0