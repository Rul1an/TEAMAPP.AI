#!/usr/bin/env bash
# scripts/run_qa_control.sh
# -------------------------------------------
# Automated QA-control helper for JO17 Tactical Manager
#
# Prerequisites:
#   - GITHUB_TOKEN  : token with `actions:read` scope
#   - GH_REPOSITORY : GitHub repo in owner/name format (default inferred via `git remote`)
#   - STAGING_URL   : URL of the deployed staging site (e.g. https://staging--teamappai.netlify.app)
#   - NODE >= 18 & Lighthouse CLI (`npm i -g lighthouse`) installed
#   - jq, curl, tar, unzip, bc utilities available
# -------------------------------------------
set -euo pipefail

### Helper functions ----------------------------------------------------------
info()  { printf "\033[1;34mℹ️  %s\033[0m\n" "$*"; }
success() { printf "\033[1;32m✅ %s\033[0m\n" "$*"; }
fail() { printf "\033[1;31m❌ %s\033[0m\n" "$*"; exit 1; }

### Validate environment ------------------------------------------------------
: "${GITHUB_TOKEN:?Set GITHUB_TOKEN token with actions:read scope}"

# Derive repo if not explicitly provided
if [[ -z "${GH_REPOSITORY:-}" ]]; then
  GH_REPOSITORY=$(git config --get remote.origin.url | sed -E 's#.*github.com[/:]([^/]+/[^/.]+)(\.git)?#\1#')
  [[ -z "$GH_REPOSITORY" ]] && fail "Unable to determine GitHub repository. Set GH_REPOSITORY."
fi

: "${STAGING_URL:?Set STAGING_URL to staging site (e.g. https://staging--site.netlify.app)}"

HEAD_BRANCH=$(git rev-parse --abbrev-ref HEAD)

API="https://api.github.com/repos/$GH_REPOSITORY"
HEAD_SHA=$(git rev-parse HEAD)

info "Looking for successful workflow runs (branch: $HEAD_BRANCH)…"
RUN_JSON=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "$API/actions/runs?per_page=20&branch=$HEAD_BRANCH")
RUN_ID=$(echo "$RUN_JSON" | jq -r '.workflow_runs | map(select(.conclusion=="success"))[0].id')

if [[ "$RUN_ID" == "null" || -z "$RUN_ID" ]]; then
  info "No successful run on $HEAD_BRANCH. Trying 'main' branch…"
  RUN_JSON=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "$API/actions/runs?per_page=20&branch=main")
  RUN_ID=$(echo "$RUN_JSON" | jq -r '.workflow_runs | map(select(.conclusion=="success"))[0].id')
fi

if [[ "$RUN_ID" == "null" || -z "$RUN_ID" ]]; then
  info "No successful run on 'main'. Falling back to latest successful run across branches…"
  RUN_JSON=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "$API/actions/runs?per_page=20")
  RUN_ID=$(echo "$RUN_JSON" | jq -r '.workflow_runs | map(select(.conclusion=="success"))[0].id')
fi

[[ "$RUN_ID" == "null" || -z "$RUN_ID" ]] && fail "No successful workflow run found after fallback attempts."

success "Found workflow run $RUN_ID"
ARTIFACTS_JSON=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "$API/actions/runs/$RUN_ID/artifacts")

mkdir -p .qa_artifacts && cd .qa_artifacts

### Coverage report -----------------------------------------------------------
COV_ID=$(echo "$ARTIFACTS_JSON" | jq -r '.artifacts[] | select(.name|test("coverage|lcov")) | .id' | head -n1)
if [[ -n "$COV_ID" ]]; then
  info "Downloading coverage artifact (#$COV_ID)…"
  curl -L -H "Authorization: token $GITHUB_TOKEN" "$API/actions/artifacts/$COV_ID/zip" -o coverage.zip
  unzip -q coverage.zip -d coverage
  # Find lcov file
  LCOV=$(find coverage -name "*lcov.info" | head -n1 || true)
  if [[ -n "$LCOV" ]]; then
    TOTAL=$(awk -F: '/^LF:/ {sum+=$2} END {print sum}' "$LCOV")
    COVERED=$(awk -F: '/^LH:/ {sum+=$2} END {print sum}' "$LCOV")
    PCT=$((COVERED * 100 / TOTAL))
    success "Coverage: $PCT% ($COVERED / $TOTAL lines)"
  else
    fail "lcov.info not found in coverage artifact."
  fi
else
  fail "Coverage artifact not found."
fi

### Web build artifact --------------------------------------------------------
WEB_ID=$(echo "$ARTIFACTS_JSON" | jq -r '.artifacts[] | select(.name=="web-build" or .name=="build-web") | .id' | head -n1)
if [[ -n "$WEB_ID" ]]; then
  info "Downloading web build artifact (#$WEB_ID)…"
  curl -L -H "Authorization: token $GITHUB_TOKEN" "$API/actions/artifacts/$WEB_ID/zip" -o web-build.zip
  unzip -q web-build.zip -d web-build
  [[ ! -f web-build/index.html ]] && fail "index.html missing in web build artifact." || success "Web build downloaded."
else
  fail "Web build artifact not found."
fi

### Lighthouse score on staging ---------------------------------------------
info "Running Lighthouse audit against $STAGING_URL… (categories: accessibility,best-practices,seo)"
REPORT_JSON="lh-report.json"
lighthouse "$STAGING_URL" \
  --output json \
  --output-path "$REPORT_JSON" \
  --only-categories=accessibility,best-practices,seo \
  --chrome-flags="--headless --no-sandbox" >/dev/null

A11Y_RAW=$(jq '.categories.accessibility.score' "$REPORT_JSON")
BP_RAW=$(jq '.categories["best-practices"].score' "$REPORT_JSON")
SEO_RAW=$(jq '.categories.seo.score' "$REPORT_JSON")

A11Y_SCORE=$(echo "$A11Y_RAW * 100" | bc -l)
BP_SCORE=$(echo "$BP_RAW * 100" | bc -l)
SEO_SCORE=$(echo "$SEO_RAW * 100" | bc -l)

success "Lighthouse Scores – Accessibility: $A11Y_SCORE  BP: $BP_SCORE  SEO: $SEO_SCORE"

THRESHOLD=80
for S in $A11Y_SCORE $BP_SCORE $SEO_SCORE; do
  BELOW=$(echo "$S < $THRESHOLD" | bc -l)
  [[ $BELOW -eq 1 ]] && fail "Score $S below threshold $THRESHOLD"
done

success "All QA-control checks passed!"