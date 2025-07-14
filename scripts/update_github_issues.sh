#!/usr/bin/env bash
# Bulk-update TEAMAPP.AI GitHub issues
#
# – Sluit zes afgeronde issues (#30, #29, #28, #7, #6, #5)
# – Voegt status-comments toe aan zeven open issues (#37 t/m #31)
#
# Voorwaarden:
# • $GITHUB_TOKEN (classic PAT, scope "repo") moet zijn gezet óf gh moet al geauthenticeerd zijn.
# • Het script probeert automatisch een standalone gh-binary te installeren als gh niet aanwezig is.
#
# Gebruik:
#   chmod +x scripts/update_github_issues.sh
#   ./scripts/update_github_issues.sh

set -euo pipefail

REPO="Rul1an/TEAMAPP.AI"

# 1. Zorg dat GitHub CLI beschikbaar is ───────────────────────────────────────
if ! command -v gh >/dev/null 2>&1; then
  echo "[setup] gh CLI niet gevonden; download standalone binary…"
  GH_VERSION="2.48.0"
  ARCH="$(uname -m)"
  case "$ARCH" in
    x86_64|amd64) ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *) echo "[error] Unsupported architecture: $ARCH" >&2; exit 1 ;;
  esac
  TMP_DIR="$(mktemp -d)"
  curl -sSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_${ARCH}.tar.gz" -o "$TMP_DIR/gh.tgz"
  tar -xf "$TMP_DIR/gh.tgz" -C "$TMP_DIR"
  install -m 0755 "$TMP_DIR/gh_${GH_VERSION}_linux_${ARCH}/bin/gh" /usr/local/bin/
  rm -rf "$TMP_DIR"
  echo "[setup] gh ${GH_VERSION} geïnstalleerd."
fi

# 2. Authenticeren indien nodig ───────────────────────────────────────────────
if ! gh auth status -h github.com >/dev/null 2>&1; then
  if [[ -z "${GITHUB_TOKEN:-}" ]]; then
    echo "[error] gh is niet geauthenticeerd en GITHUB_TOKEN ontbreekt." >&2
    exit 1
  fi
  echo "[setup] gh authenticeren via GITHUB_TOKEN…"
  printf '%s\n' "$GITHUB_TOKEN" | gh auth login --hostname github.com --with-token
fi

echo "[info] gh CLI klaar voor gebruik."

# 3. Sluit de afgeronde issues ───────────────────────────────────────────────
CLOSE_LIST=(30 29 28 7 6 5)
echo "[action] Sluit afgeronde issues afzonderlijk…"
for num in "${CLOSE_LIST[@]}"; do
  echo "  → Sluit #$num…"
  gh issue close "$num" --repo "$REPO" --comment "Gereed – implementatie is opgenomen in main."
done
echo "[info] Afgeronde issues gesloten."

# 4. Voorbereiden Markdown-comments voor de open issues ───────────────────────
TMP_ROOT="$(mktemp -d)"
cleanup() { rm -rf "$TMP_ROOT"; }
trap cleanup EXIT

# Helper-functie om snel een md-bestand te vullen
write_md() {
  local path="$1"; shift
  printf '%s\n' "$@" >"$path"
}

# -- #37 ---------------------------------------------------------------------
write_md "$TMP_ROOT/37.md" \
  "#37 – Phase 2 Refactor > 300 LOC files" "" \
  "### Status (2025-07-14)" \
  "Phase 1 is afgerond; volgende bestanden hebben nog **> 300 LOC**  " "(gegenereerd op 14-07-2025):" "" \
  "| LOC | Pad |" "|----:|-----|" \
  "| 5109 | lib/models/player_tracking/player_performance_data.freezed.dart |" \
  "| 2568 | lib/models/club/staff_member.freezed.dart |" \
  "| 1664 | lib/screens/training_sessions/session_builder_screen.dart |" \
  "| 1214 | lib/models/club/club.freezed.dart |" \
  "| 1213 | lib/models/club/team.freezed.dart |" \
  "| 1031 | lib/screens/annual_planning/load_monitoring_screen.dart |" \
  "|  913 | lib/screens/training_sessions/enhanced_exercise_library_screen.dart |" \
  "|  883 | lib/screens/analytics/performance_analytics_screen.dart |" \
  "|  880 | lib/screens/annual_planning/weekly_planning_screen.dart |" \
  "|  865 | lib/providers/annual_planning_provider.dart |" \
  "|  757 | lib/screens/training_sessions/exercise_designer_screen.dart |" \
  "|  741 | lib/providers/field_diagram_provider.dart |" \
  "|  696 | lib/widgets/field_diagram/field_painter.dart |" \
  "|  676 | lib/screens/matches/match_detail_screen.dart |" \
  "|  655 | lib/screens/matches/edit_match_screen.dart |" \
  "|  651 | lib/screens/admin/club_management_screen.dart |" \
  "|  629 | lib/pdf/generators/training_session_pdf_generator.dart |" \
  "|  627 | lib/screens/dashboard/dashboard_screen.dart |" \
  "|  625 | lib/screens/season/season_hub_screen.dart |" "" \
  "#### Todo (Q4 2025)" \
  "- [ ] Splits \\`player_performance_data.freezed.dart\\` in sub-modellen" \
  "- [ ] Extract widgets uit \\`session_builder_screen.dart\\`" \
  "- [ ] Zie overige regels hierboven"

# -- #36 ---------------------------------------------------------------------
write_md "$TMP_ROOT/36.md" \
  "#36 – Pre-commit hooks (lefthook)" "" \
  "### Status (2025-07-14)" \
  "Nog niet gestart." "" \
  "#### Todo" \
  "- [ ] Voeg \\`.lefthook.yml\\` toe met \\`flutter format\\` en \\`import_sorter\\`" \
  "- [ ] CI controleren op \\`lefthook run --all\\`"

# -- #35 ---------------------------------------------------------------------
write_md "$TMP_ROOT/35.md" \
  "#35 – very_good_analysis & dart_code_metrics" "" \
  "### Status" \
  "\\`analysis_options.yaml\\` bevat eigen regels; very_good_analysis nog niet geïmporteerd." "" \
  "#### Todo" \
  "- [ ] Voeg dependency \\`very_good_analysis: ^5.1.0\\`" \
  "- [ ] Draai \\`dart fix --apply\\`" \
  "- [ ] Schakel optionele lints van dart_code_metrics in"

# -- #34 ---------------------------------------------------------------------
write_md "$TMP_ROOT/34.md" \
  "#34 – Duplicate Detection on Import" "" \
  "### Status" \
  "\\`import_service.dart\\` valideert nog geen duplicaten." "" \
  "#### Tasks" \
  "- [ ] Hash-map op \\`fullname+birthdate\\`" \
  "- [ ] UI-meldingen in import-wizard" \
  "- [ ] Unit-tests op merge-strategie"

# -- #33 ---------------------------------------------------------------------
write_md "$TMP_ROOT/33.md" \
  "#33 – Bulk Operations UI" "" \
  "### Her-scope" \
  "Bulk-flow betreft **spelers, trainingen en matches**:" "" \
  "| Stap | UI | Achter-eind |" \
  "|------|----|-------------|" \
  "| VOORSELECTIE | multi-select in list view | n.v.t. |" \
  "| BULK-UPDATE | dialog met velden: status, datum, label | REST \\`PATCH /batch\\` |" \
  "| BULK-DELETE | bevestigings-dialog | REST \\`DELETE /batch\\` |" "" \
  "#### Todo" \
  "- [ ] Voeg checkbox-kolom toe aan \\`DataTable\\`’s" \
  "- [ ] Implement \\`BulkActionBar\\` component" \
  "- [ ] Repository-methode \\`batchUpdate\\`, \\`batchDelete\\`"

# -- #32 ---------------------------------------------------------------------
write_md "$TMP_ROOT/32.md" \
  "#32 – Import Match Schedules" "" \
  "### Status" \
  "CSV-import voor spelers en trainingen is gereed; match-schema’s nog niet." "" \
  "#### Todo" \
  "- [ ] CSV-parser (\\`match_date, opponent, venue\\`)" \
  "- [ ] Validation + duplicate checks" \
  "- [ ] UI-wizard stap 3 (review)"

# -- #31 ---------------------------------------------------------------------
write_md "$TMP_ROOT/31.md" \
  "#31 – Predictive Analytics PoC" "" \
  "### Status" \
  "Alleen lege test-suite \\`prediction_repository_test.dart\\`." "" \
  "#### Roadmap" \
  "- [ ] Maak feature-branch \\`analytics/predict_form\\`" \
  "- [ ] Experimenteer met \\`ml_algo\\` of offline TF-Lite model" \
  "- [ ] Baseline-meting vs huidige \\`heat_map_card\\`"

# 5. Plaats de status-updates ────────────────────────────────────────────────
OPEN_LIST=(37 36 35 34 33 32 31)
for num in "${OPEN_LIST[@]}"; do
  echo "[action] Plaats comment voor issue #$num…"
  gh issue comment "$num" --repo "$REPO" --body-file "$TMP_ROOT/$num.md"
  echo "[info]  → comment geplaatst."
done

echo "✅ Issues bijgewerkt."