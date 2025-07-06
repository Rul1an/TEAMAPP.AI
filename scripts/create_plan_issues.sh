#!/usr/bin/env bash
# create_plan_issues.sh
# Helper script to sync open tasks from docs/*.md to GitHub issues.
# Requires GitHub CLI: https://cli.github.com/ and that you are authenticated (`gh auth login`).
# Usage: ./scripts/create_plan_issues.sh <GITHUB_REPO> [--dry-run]

set -euo pipefail

REPO=${1:-}
DRY=${2:-}
if [[ -z "$REPO" ]]; then
  echo "Usage: $0 <github_user_or_org>/<repo> [--dry-run]" >&2
  exit 1
fi

create_issue() {
  local title=$1
  local body=$2
  local labels=$3
  if [[ "$DRY" == "--dry-run" ]]; then
    echo "DRY RUN: gh issue create -R $REPO -t \"$title\" -b \"$body\" -l \"$labels\""
  else
    gh issue create -R "$REPO" -t "$title" -b "$body" -l "$labels"
  fi
}

############################################
# PDF Service Modularisation (P1-P8)
############################################
PDF_LABELS="quality,export,q3-2025"
create_issue "PDF Service Modularisation: P1 – Skeleton lib/pdf module & asset migration" "Origin: PDF_SERVICE_MIGRATION_PLAN_Q3_2025.md" "$PDF_LABELS"
create_issue "PDF Service Modularisation: P2 – Implement PdfGenerator base class" "Origin: PDF_SERVICE_MIGRATION_PLAN_Q3_2025.md" "$PDF_LABELS"
create_issue "PDF Service Modularisation: P3 – MatchReportPdfGenerator" "Origin: PDF_SERVICE_MIGRATION_PLAN_Q3_2025.md" "$PDF_LABELS"
create_issue "PDF Service Modularisation: P4 – PlayerAssessmentPdfGenerator" "Origin: PDF_SERVICE_MIGRATION_PLAN_Q3_2025.md" "$PDF_LABELS"
create_issue "PDF Service Modularisation: P5 – Unit & golden tests (≥80 %)" "Origin: PDF_SERVICE_MIGRATION_PLAN_Q3_2025.md" "$PDF_LABELS"
create_issue "PDF Service Modularisation: P6 – Wire up providers & UI flows" "Origin: PDF_SERVICE_MIGRATION_PLAN_Q3_2025.md" "$PDF_LABELS"
create_issue "PDF Service Modularisation: P7 – Remove legacy pdf_service.dart & helpers" "Origin: PDF_SERVICE_MIGRATION_PLAN_Q3_2025.md" "$PDF_LABELS"
create_issue "PDF Service Modularisation: P8 – Update docs & roadmap" "Origin: PDF_SERVICE_MIGRATION_PLAN_Q3_2025.md" "$PDF_LABELS"

############################################
# Large File Refactor tasks
############################################
REF_LABELS="refactor,quality,q3-2025"
create_issue "Large File Refactor: Split SessionBuilderScreen" "Origin: LARGE_FILE_REFACTOR_PLAN_Q3_2025.md (#refactor-session-builder)" "$REF_LABELS"
create_issue "Large File Refactor: Modularise pdf_service (refactor-pdf-service)" "Origin: LARGE_FILE_REFACTOR_PLAN_Q3_2025.md" "$REF_LABELS"
create_issue "Large File Refactor: ExerciseLibrary widget-first split" "Origin: LARGE_FILE_REFACTOR_PLAN_Q3_2025.md (#refactor-exercise-library)" "$REF_LABELS"
create_issue "Large File Refactor: Decompose WeeklyPlanning screen" "Origin: LARGE_FILE_REFACTOR_PLAN_Q3_2025.md (#refactor-weekly-planning)" "$REF_LABELS"
create_issue "Large File Refactor: Extract dashboard cards widgets" "Origin: LARGE_FILE_REFACTOR_PLAN_Q3_2025.md (#refactor-dashboard-screen)" "$REF_LABELS"
create_issue "Large File Refactor: Split PerformanceMonitoringScreen" "Origin: LARGE_FILE_REFACTOR_PLAN_Q3_2025.md (#refactor-performance-monitoring)" "$REF_LABELS"
create_issue "Large File Refactor: Break annual_planning_provider into services" "Origin: LARGE_FILE_REFACTOR_PLAN_Q3_2025.md (#refactor-annual-planning-provider)" "$REF_LABELS"

############################################
# Repository Layer Refactor (R7-R8)
############################################
REPO_LABELS="docs,cleanup,q3-2025"
create_issue "Repository Layer Refactor: R7 – Update docs & samples" "Origin: REPOSITORY_LAYER_REFRACTOR_Q3_2025.md" "$REPO_LABELS"
create_issue "Repository Layer Refactor: R8 – Remove obsolete service classes & ensure analyzer 0 issues" "Origin: REPOSITORY_LAYER_REFRACTOR_Q3_2025.md" "$REPO_LABELS"

############################################
# Hive Profile Cache tasks (H1-H6)
############################################
HIVE_LABELS="offline,hive,q3-2025"
create_issue "Hive Profile Cache: H1 – Add Hive dependencies to pubspec" "Origin: HIVE_PROFILE_CACHE_PLAN_Q3_2025.md" "$HIVE_LABELS"
create_issue "Hive Profile Cache: H2 – Generate ProfileAdapter & run codegen" "Origin: HIVE_PROFILE_CACHE_PLAN_Q3_2025.md" "$HIVE_LABELS"
create_issue "Hive Profile Cache: H3 – Implement HiveProfileCache helpers" "Origin: HIVE_PROFILE_CACHE_PLAN_Q3_2025.md" "$HIVE_LABELS"
create_issue "Hive Profile Cache: H4 – Inject cache into SupabaseProfileRepository with SWR" "Origin: HIVE_PROFILE_CACHE_PLAN_Q3_2025.md" "$HIVE_LABELS"
create_issue "Hive Profile Cache: H5 – Unit tests with in-memory Hive" "Origin: HIVE_PROFILE_CACHE_PLAN_Q3_2025.md" "$HIVE_LABELS"
create_issue "Hive Profile Cache: H6 – Update docs & diagrams" "Origin: HIVE_PROFILE_CACHE_PLAN_Q3_2025.md" "$HIVE_LABELS"

echo "Created issue commands for open plan items. Run with --dry-run first to verify."