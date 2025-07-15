#!/usr/bin/env bash
# scripts/monitor_ci_and_run_qa.sh
# Monitors latest CI run for current branch; once successful, executes run_qa_control.sh.
#
# Requires GITHUB_TOKEN, STAGING_URL (and optionally GH_REPOSITORY).
set -euo pipefail

check_deps() {
  for bin in curl jq date; do
    if ! command -v "$bin" >/dev/null 2>&1; then
      echo "❌ $bin not installed" && exit 1
    fi
  done
}

check_deps

: "${GITHUB_TOKEN?Set GITHUB_TOKEN}" 
: "${STAGING_URL?Set STAGING_URL}"

if [[ -z "${GH_REPOSITORY:-}" ]]; then
  GH_REPOSITORY=$(git config --get remote.origin.url | sed -E 's#.*github.com[/:]([^/]+/[^/.]+)(\.git)?#\1#')
fi
BRANCH=$(git rev-parse --abbrev-ref HEAD)
API="https://api.github.com/repos/$GH_REPOSITORY"

echo "📡 Monitoring CI runs for branch $BRANCH…"

while true; do
  RUN_JSON=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "$API/actions/runs?per_page=1&branch=$BRANCH")
  RUN_ID=$(echo "$RUN_JSON" | jq -r '.workflow_runs[0].id')
  STATUS=$(echo "$RUN_JSON" | jq -r '.workflow_runs[0].status')
  CONCL=$(echo "$RUN_JSON" | jq -r '.workflow_runs[0].conclusion')
  echo "🕒 Run $RUN_ID status=$STATUS conclusion=$CONCL"

  if [[ "$STATUS" == "completed" ]]; then
    if [[ "$CONCL" == "success" ]]; then
      echo "✅ CI succeeded. Running QA checks…"; break
    else
      echo "❌ CI finished with conclusion=$CONCL. Exiting."; exit 1
    fi
  fi
  sleep 60
done

# Execute QA script
./scripts/run_qa_control.sh && echo "🎉 QA checks passed!" || { echo "❌ QA checks failed"; exit 1; }