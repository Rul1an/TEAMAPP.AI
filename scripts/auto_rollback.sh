#!/usr/bin/env bash
# Auto-rollback script triggered by deployment workflow
# Best Practices 2025: ≤300 LOC, observability.
set -euo pipefail

CLOUDWATCH_ALARM_NAME=${CLOUDWATCH_ALARM_NAME:-"error_budget_burn"}
NETLIFY_SITE_ID="${NETLIFY_SITE_ID:?}"
NETLIFY_AUTH_TOKEN="${NETLIFY_AUTH_TOKEN:?}"
CURRENT_DEPLOY_ID="${CURRENT_DEPLOY_ID:?}"

log() { echo "$(date --iso-8601=seconds) | $1"; }

check_alarm() {
  state=$(aws cloudwatch describe-alarms --alarm-names "$CLOUDWATCH_ALARM_NAME" --query 'MetricAlarms[0].StateValue' --output text)
  echo "$state"
}

get_previous_deploy() {
  curl -s -H "Authorization: Bearer $NETLIFY_AUTH_TOKEN" \
    https://api.netlify.com/api/v1/sites/$NETLIFY_SITE_ID/deploys | \
    jq -r --arg curr "$CURRENT_DEPLOY_ID" '[.[] | select(.state=="ready") | select(.id != $curr)] | .[0].id'
}

restore_deploy() {
  local deploy_id=$1
  log "Restoring Netlify deploy $deploy_id"
  curl -s -X POST -H "Authorization: Bearer $NETLIFY_AUTH_TOKEN" \
    https://api.netlify.com/api/v1/sites/$NETLIFY_SITE_ID/deploys/$deploy_id/restore > /dev/null
}

log "Checking CloudWatch alarm $CLOUDWATCH_ALARM_NAME..."
state=$(check_alarm)
log "Alarm state: $state"
if [[ "$state" == "ALARM" ]]; then
  log "Alarm is in ALARM state, initiating rollback"
  prev=$(get_previous_deploy)
  if [[ -z "$prev" ]]; then
    log "No previous deploy found; aborting rollback" && exit 1
  fi
  restore_deploy "$prev"
  log "Rollback completed to deploy $prev"
else
  log "Alarm state OK – no rollback needed"
fi