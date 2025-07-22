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