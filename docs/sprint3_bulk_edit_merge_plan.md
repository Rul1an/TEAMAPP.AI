# Sprint 3 – Advanced Import UX (Bulk-edit, Merge & Undo)

> Doel: de import­ervaring verfijnen met in-app bulkbewerking, handmatige merge van duplicaten en een undo-mechanisme.
>
> Periode: 2025-07-30 → 2025-08-13 (2 weken)

---

## 1 – Deliverables & DoD

| # | Deliverable | Artefact | DoD criteria |
|---:|-------------|----------|--------------|
| 1 | Bulk-edit grid component | `EditableDataTable` widget | Inline-validatie, keyboard-nav, 100 % a11y |
| 2 | Duplicate merge dialog | `MergeDuplicatesDialog` | Allows field-level choose; saves merged entity |
| 3 | Undo/rollback layer | `ImportTransaction` model + service | Single-action undo ≤ 5 s after import |
| 4 | Performance tuning large files | Streaming parser v2 | Preview 10k rows < 3 s on M1 Mac |
| 5 | E2E regression tests | `integration_test/import_bulk_edit_flow_test.dart` | CI green, coverage ≥ 90 % |
| 6 | Docs & Demo | Update guide, Loom video | Published & shared |

Legend: ✅ = Done, ⏳ = In Progress, 🔲 = Not started

---

## 2 – Backlog & Estimatie

| ID | Issue | Owner | Est. hrs |
|----|-------|-------|---------|
| 51 | EditableDataTable core | Dev-A | 8 |
| 52 | Cell validators + focus handling | Dev-A | 6 |
| 53 | Merge dialog implementation | Dev-B | 6 |
| 54 | Conflict-resolution service layer | Dev-B | 4 |
| 55 | Undo transaction model | Dev-C | 5 |
| 56 | Parser streaming upgrade | Dev-C | 6 |
| 57 | Performance benchmarks | Dev-C | 2 |
| 58 | E2E tests bulk edit | Dev-A | 4 |
| 59 | Docs & Demo | Dev-A | 2 |

Buffer: 8 hrs

---

## 3 – Architectuurkeuzes 2025

1. **EditableDataTable** leunt op `DataTable2` package met custom `TableSpan` voor virtual scrolling.
2. **Optimistic UI** – bulkwijzigingen worden client-side in `ImportEditingState` bijgehouden, pas bij bevestiging gecommit.
3. **Merge engine** – gebruikt field-level precedence rules (CSV > existing DB) en toont diff-highlights.
4. **Undo** – geïmplementeerd als soft-delete van `ImportTransaction` records met cascade rollback.
5. **Streaming CSV** – parse in chunks (250 rows) om UI-freeze te voorkomen.

---

## 4 – Sprint-kalender

| Dag | Activiteit | R | A | C | I |
|-----|-----------|---|---|---|---|
| D1 | Bulk-edit grid skeleton | Dev-A | TL | UX | QA |
| D2 | Validators + focus | Dev-A | TL | UX | QA |
| D3 | Merge dialog + service | Dev-B | TL | Dev-team | QA |
| D4 | Undo layer & streaming parser | Dev-C | TL | Dev-team | QA |
| D5 | Performance test & polish | Dev-C | TL | Dev-team | QA |
| D6 | E2E tests | Dev-A | TL | QA | – |
| D7 | Docs & demo | Dev-A | PO | TL | All |
| D8 | Buffer/retro | Team | TL | PO | All |

---

## 5 – Risico’s & Mitigatie

| Risico | Impact | Kans | Actie |
|--------|--------|------|-------|
| Virtual scroll bugs in EditableDataTable | high | medium | Reuse proven package, add unit tests |
| Merge conflict complexity | medium | medium | Scope to most common fields, escalate edge cases |
| Undo leads to data inconsistency | high | low | Transaction log + integration tests |

---

## 6 – Acceptatiecriteria

1. Gebruiker kan cellen inline aanpassen en opslaan zonder pagina-reload.
2. Duplicate merge ondersteunt ten minste spelers en wedstrijden.
3. Import kan met één klik worden teruggedraaid binnen 5 seconden.
4. Preview van 10k rijen laadt binnen vastgestelde performance-budget.
5. Alle tests slagen; code-coverage ≥ 90 % voor nieuwe modules.

---

*Awaiting PO sign-off.*