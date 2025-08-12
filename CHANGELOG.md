# Changelog

All notable changes to this project will be documented in this file using [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) principles and **semantic versioning**.

---

## [0.9.0] – 2025-07-15 – *Import Phase Completion*

### Added
- **Import wizard** finished: CSV bulk upload for match schedules with duplicate-detection preview.
- End-to-end regression test suite covering happy-path, invalid row, and duplicate scenarios.
- **CI pipeline**: Flutter SDK cached (`subosito/flutter-action@v2`), `melos bootstrap`, automated tests with coverage, and static analysis.
- Loom demo linked in docs/import_guide.md.

### Changed
- Updated docs (`sprint1_import_phase_plan.md`, new manual QA checklist) to reflect progress.

### Fixed
- Various analyzer warnings across workspace packages.

### Security
- No security-related changes.

---
## [0.9.1] – 2025-08-11 – Security & CI Modernization

### Added
- SentryNavigatorObserver toegevoegd aan GoRouter voor navigatie-breadcrumbs.
- Beveiligde integratie-test job in CI die alleen draait op interne PRs/main met Supabase-secrets.

### Changed
- Supabase secrets gemigreerd van hard-coded naar `--dart-define` (CI secrets injectie).
- CI teststrategie gesplitst: unit/widget (fork‑vriendelijk) en aparte integratiejob (secured).
- Navigatie mapping gefixt om te aligneren met tests (0:Dashboard, 1:Season, 2:Training, 3:Matches, 4:Players, 5:Insights).
- ErrorSanitizer minder agressief; redigeert niet langer alle exceptions.
- `flutter_secure_storage` naar stabiele versie gepind; ongebruikte `riverpod` verwijderd.

### Fixed
- Providers geven nu volledige error objecten door aan `AsyncValue.error` (geen onveilige `.message`).
- Robuuste `Player` JSON-deserialisatie met veilige parsing en enum-fallbacks.

### Docs
- README aangevuld met dart‑defines en CI teststrategie.

### Security
- Production builds falen wanneer Supabase secrets ontbreken; tests hebben veilige defaults alleen voor unit/widget.

---