# Sprint 1 – Import Phase Completion (Match Schedules + Duplicate Detection)

> Doel: afronden van alle resterende Phase-1 importfunctionaliteit zodat admins in bulk wedstrijdroosters kunnen uploaden en het systeem dubbele spelers/trainingen automatisch herkent.

## 1 – Back-log & Deliverables

| Nr. | Issue | Deliverable | Definition of Done |
|----:|-------|-------------|--------------------|
| 32 | Import Match Schedules | CSV-import pipeline (`match_date,opponent,venue,team_id`) + UI-wizard stap 3 (review) | *CSV importeert min. 100 records <1 s; UI toont preview en foutmeldingen* |
| 34 | Duplicate Detection on Import | Service-laag deduplicatie (hash `fullname+birthdate`), merge-strategie, unit-tests | *100 % test-coverage op import_service; duplicates worden gemarkeerd in preview* |
| – | End-to-End Tests | golden CSV scenarios (happy path, invalid row, duplicates) | *E2E test in `integration_test/` slaagt in CI* |

## 2 – High-level Activiteiten

1. **Data-schema**  
   • Extend `match_schedule` table/model (date, opponent, venue, teamRef)  
   • Add repository `MatchScheduleRepository` (Isar & Supabase sync)
2. **CSV-parser**  
   • Re-use existing `CsvParser` util; add `MatchScheduleCsvParser` subclass  
   • Validate columns, convert to DTOs
3. **Import Service**  
   • Combine parser + repository; detect duplicates via `DuplicateDetector` (issue #34)  
   • Return `ImportPreview` object (new vs duplicate vs error)
4. **UI Wizard**  
   • Add Step 3 “Review & Confirm” with `DataTable` preview; use green/yellow/red rows  
   • Bulk import button → call service, show snackbar + error file download
5. **Tests**  
   • Unit tests for parser, detector, service  
   • Widget test for wizard  
   • Integration test uploads sample CSV (CI)
6. **Docs & Demo**  
   • Update `docs/import_guide.md`  
   • Record Loom demo (<2 min)

## 3 – Detail Taken & Commando’s

### 3.1 Model & Repository
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3.2 Parser skeleton
```dart
class MatchScheduleCsvParser extends BaseCsvParser<MatchScheduleDto> {
  @override
  MatchScheduleDto? mapRow(Map<String, String> row) {
    try {
      return MatchScheduleDto(
        date: DateFormat('yyyy-MM-dd').parse(row['match_date']!),
        opponent: row['opponent']!,
        venue: row['venue']!,
        teamId: row['team_id']!,
      );
    } catch (_) {
      return null; // flagged as error
    }
  }
}
```

### 3.3 DuplicateDetector utility
```dart
class DuplicateDetector {
  final Set<int> _hashes = {};
  bool isDuplicate(PlayerDto dto) {
    final hash = _calc(dto.fullName, dto.birthDate);
    return !_hashes.add(hash);
  }
}
```

### 3.4 E2E Test command
```bash
flutter test integration_test/import_flow_test.dart
```

## 4 – Planning & RACI

| Dag | Activiteit | R | A | C | I |
|----|------------|---|---|---|---|
| D1 | Schema + repo | Dev-A | TL | DBA | QA |
| D2 | CSV parser | Dev-B | TL | Dev-team | QA |
| D3 | DuplicateDetector + service | Dev-A | TL | Dev-team | QA |
| D4 | Wizard UI | Dev-B | UX-lead | PO | QA |
| D5 | Tests + CI | Dev-C | TL | Dev-team | QA |
| D6 | Docs & Demo | Dev-A | PO | TL | All |

## 5 – Acceptatiecriteria (Review)

1. Upload van voorbeeld-CSV resulteert in correcte preview met kleuren.
2. Duplicates worden in UI geel gemarkeerd en niet dubbel opgeslagen.
3. Invalid rijen worden rood getoond met foutmelding.
4. CI workflow `lefthook` + integration test slaagt op eerste run.

## 6 – Risico’s & Mitigatie

| Risico | Impact | Kans | Mitigatie |
|--------|--------|------|-----------|
| CSV format varies | medium | medium | Column mapping step + docs |
| Large files (>5 k) | high | low | Streamed parsing + pagination preview |
| Duplicate logic false positives | medium | low | Configurable hash fields, unit tests |

---
*Laatste update:* 2025-07-14