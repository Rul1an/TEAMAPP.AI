# Sprint 2 – Player Rosters & Training Sessions Import

> Doel: uitbreiden van de generieke import-pipeline zodat admins **speler­selecties** en **trainingssessies** net zo eenvoudig kunnen inlezen als wedstrijd­roosters.
>
> Periode: 2025-07-15 → 2025-07-29 (2 weken, overlap met bug-fare week)

---

## 1 – Deliverables & Definition of Done

| # | Deliverable | Artefact | DoD criteria |
|---:|-------------|----------|--------------|
| 1 | Player CSV/XLSX parser | `PlayerRosterCsvParser` + unit-tests | ≥ 95 % parsing coverage; invalid rows flagged |
| 2 | Training Session parser | `TrainingSessionCsvParser` + unit-tests | Supports split-day sessions; ≥ 95 % coverage |
| 3 | Duplicate detection (players) | Configurable hash (`firstName+lastName+birthDate`) – reuse utility | ≤ 0.5 % false positives in test-dataset |
| 4 | Import services | `PlayerRosterImportService`, `TrainingSessionImportService` | Preview DTO + persist; seeded with existing repos |
| 5 | UI Wizard integration | Re-usable Wizard step (file → preview → confirm) | Visual parity with match-wizard; responsive mobile |
| 6 | Widget & integration tests | `integration_test/import_players_flow_test.dart` | CI green on first run |
| 7 | Docs & Demo | Update `import_guide.md` + Loom demo | Docs published; demo link shared in Slack |

Legend: ✅ = Done, ⏳ = In Progress, 🔲 = Not started

---

## 2 – Back-log (detailed)

| ID | Issue | Owner | Est. hrs |
|----|-------|-------|---------|
| 41 | Player Roster CSV parser | Dev-B | 6 |
| 42 | Player duplicate detector integration | Dev-B | 3 |
| 43 | Player import service + preview | Dev-B | 5 |
| 44 | Training Session CSV parser | Dev-C | 6 |
| 45 | Training import service + preview | Dev-C | 5 |
| 46 | Wizard component refactor to generic | Dev-A | 4 |
| 47 | Widget tests players | Dev-A | 3 |
| 48 | Integration test pipeline | Dev-A | 4 |
| 49 | Docs update + Loom | Dev-A | 2 |

*Buffer*: 8 hrs (prod-support / unexpected tech-debt)

---

## 3 – Architectuurkeuzes (Best practices 2025)

1. **Single Source Parser** – Alle CSV- & XLSX-parsers erven van `BaseCsvParser` met header-mapping en row-index tracking.
2. **DuplicateDetector v2** – Hash functor kan via constructor worden doorgegeven voor complexe merges (b.v. spelers met tweeling­namen).
3. **Service layer isolation** – Import-services bevatten géén UI-logica; worden via Riverpod Provider met repository-injectie gebruikt.
4. **Preview DTO** – Uniforme `ImportRowPreview<T>` zodat wizard slechts één table-component hoeft te renderen.
5. **Accessibility** – Kleuren + iconen voor colour-blind users (WCAG-AA contrast).
6. **Tests** – Golden-fixture CSV’s in `test/fixtures/`; snapshot-testing voor preview table widget.

---

## 4 – Sprint kalender & RACI

| Dag | Activiteit | R | A | C | I |
|-----|-----------|---|---|---|---|
| D1 | Parser skeletons (players & training) | Dev-B/C | TL | Dev-team | QA |
| D2 | Duplicate & services | Dev-B/C | TL | Dev-team | QA |
| D3 | Wizard refactor | Dev-A | UX | Dev-team | QA |
| D4 | Tests (unit/widget) | Dev-A | TL | QA | – |
| D5 | Integration test + CI | Dev-A | TL | Dev-team | Ops |
| D6 | Docs & Demo | Dev-A | PO | TL | All |
| D7 | Buffer / Bug-fix | All | TL | – | PO |
| D8 | Review & Retrospective | Team | TL | PO | All |

---

## 5 – Risico’s & Mitigatie

| Risico | Impact | Kans | Actie |
|--------|--------|------|-------|
| XLSX formule-cellen leveren null | medium | medium | Cast → String; fallback ‘0’ |
| Duplicate logic faalt bij dubbele achternaam spelers | medium | low | Levensfase-hash toevoegen, manual merge UI Sprint 3 |
| Wizard refactor breekt match-flow | high | low | E2E regression test in CI |

---

## 6 – Acceptatiecriteria

1. CSV & XLSX imports voor spelers én trainingen tonen correcte preview + kleurcodes.
2. Duplicates (spelers) worden gedetecteerd, trainingssessie-duplicates (date+time+team) idempotent opgeslagen.
3. Unit-, widget- en integration-tests dekken >90 % van import-code.
4. Documentatie + Loom-demo gedeeld en vindbaar in Help-menu.

---

*Doc gegenereerd via AI-assist; goedkeuring door Tech-Lead vereist.*