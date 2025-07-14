# Import Report – Sprint 1 Plan

_Last updated: 2025-07-14_

---

## 1. Context  
The import feature is a cornerstone of the admin workflow: club staff need a fast way to upload complete match schedules (and eventually player stats, trainings, etc.) from existing spreadsheets.  Sprint&nbsp;1 focuses on delivering a **minimal-viable import pipeline** for match schedules while laying the groundwork for future data types (players, trainings, performance metrics).

Key goals:
1. CSV/XLSX ingestion with sensible validation rules.
2. Automatic duplicate detection to avoid data pollution.
3. Clear, colour-coded preview so admins can confidently confirm an import.
4. Repeatable tests in CI to guarantee stability over time.

> Full technical breakdown lives in `docs/sprint1_import_phase_plan.md`. This file tracks *progress* and *actions*.

---

## 2. Sprint&nbsp;1 – Deliverables & Checklist

| # | Deliverable | Status |
|---:|-------------|:-------:|
| 1 | Data-schema extension (`match_schedule` table) | ✅ Completed |
| 2 | Repository layer (`MatchScheduleRepository` + Isar/Supabase sync) | ✅ Completed |
| 3 | CSV parser (`MatchScheduleCsvParser`) | ✅ Completed |
| 4 | Duplicate detection utility (`DuplicateDetector`) | ✅ Completed |
| 5 | Import service + preview DTO | ✅ Completed |
| 6 | UI Wizard – Step 3 “Review & Confirm” | ✅ Completed |
| 7 | End-to-end & widget tests | 🔲 Pending |
| 8 | Docs (`import_guide.md`) & Loom demo | ✅ Completed |

Legend: ✅ = Done, ⏳ = In Progress, 🔲 = Not started

---

## 3. Next-Step Actions (T-frame: 1 week)

1. **Parser & Formats**  
   • Finalise `MatchScheduleCsvParser` edge-case handling (empty rows, locale dates).  
   • Spike XLSX support using `excel: ^2.x` – wrap in `XlsxScheduleParser` to reuse mapping logic.
2. **Duplicate Detection**  
   • Implement configurable hash keys (`opponent+date+teamId`).  
   • Add unit tests covering collision and false-positive scenarios.
3. **Import Service**  
   • Compose parser + repository + detector; return `ImportPreview` with row-level meta (new/dup/error).  
   • Surface preview in the wizard with green/yellow/red rows.
4. **Testing**  
   • Write golden CSV/XLSX fixtures (happy path, invalid row, duplicate).  
   • Add widget test for “Review & Confirm” highlighting.  
   • Integrate into CI (`flutter test integration_test/import_flow_test.dart`).
5. **UX Polish & Docs**  
   • Snackbar confirmation + error-file download.  
   • Update `docs/import_guide.md` with screenshots & troubleshooting.  
   • Record 2-minute Loom demo for stakeholders.

---

## 4. Risks & Mitigation (rolling)

| Risk | Impact | Likelihood | Mitigation |
|------|--------|-----------|-----------|
| XLSX library parsing speed on large (5k+) rows | Medium | Medium | Use streaming API, paginate preview |
| Duplicate hash misses variations (stadium vs venue abbreviations) | Medium | Low | Normalise strings, allow admin override |
| CI flakiness on large file upload in integration test | Low | Low | Use smaller fixture; flag big-file test as separate job |

---

## 5. Future Sprint Notes

*Sprint 2* will extend the same import framework to **player rosters** and **training sessions**, re-using duplicate detection & preview UI.  Early backlog items:
- Player CSV/XLSX mapping + photo optional column.
- Training sessions with periodisation tags.
- Bulk edit + undo capability after import.

---

Feel free to append additional status updates or planning rows as the sprint progresses.