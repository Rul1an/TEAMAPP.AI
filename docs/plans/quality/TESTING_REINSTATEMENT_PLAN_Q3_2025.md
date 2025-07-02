# TESTING REINSTATEMENT PLAN – Q3 2025

> JO17 Tactical Manager · Owner: Core Dev Team · Created: 12 July 2025

## 🎯 Doelstelling

1. Herstellen van unit-, widget- en integratietests die zijn verwijderd bij de grote lint-opschoonactie.
2. Bouwen van een stabiele test-suite met **≥ 60 % line coverage** vóór eind Q3 2025.
3. Integreren van test-rapportage (coverage + pass/fail) in GitHub Actions pipeline.

## 📅 Roadmap

| Fase | Periode | Deliverables | KPI / Exit-criteria |
|------|---------|--------------|--------------------|
| 1. Setup & Foundation | Week 29 | • `flutter_test`, `integration_test` packages up-to-date<br>• `mocktail`, `riverpod_test` toegevoegd<br>• Initial `coverage.sh` script **(✅ afgerond)** | CI job "test" slaagt op main |
| 2. Unit tests – Data & Services | Week 30-31 | • Lightweight `StubHttpClient` injecteerbaar in `SupabaseClient` **(✅)**<br>• Hive-adapters unit-tested **(✅)**<br>• Coverage **25.5 %** (huidig) | ≥ 25 % overall coverage **(behaald)** |
| 3. Widget tests – Core Screens | Week 32-33 | • `dashboard` widget tests **(✅)**<br>• `training_attendance`, `match_detail` widget tests **(✅)**<br>• Golden tests voor `field_diagram` toolbar **(✅)** | ≥ 45 % coverage (huidig ~**27 %**, in progress) |
| 4. Integration tests – Critical Flows | Week 34 | • Happy-flow login → dashboard → player list<br>• Demo-mode flow incl. RBAC switch | ≤ 5 % flaky runs |
| 5. Coverage Optimisation & Cleanup | Week 35 | • Parameterised tests for edge cases<br>• Remove flaky/slow tests | ≥ 60 % coverage on `main` |

## 🛠️ Tech-Stack & Tools

* **flutter_test** – standaard unit/widget framework
* **integration_test** – e2e (runs on real device/emulator)
* **mocktail** – mocking zonder code-gen
* **riverpod_test** – helpers voor Provider-tests
* **coverage** – line coverage export; `genhtml` voor HTML-rapport
* **GitHub Actions** – matrix (linux, macOS) + artifact upload

## 🔄 CI/CD Wijzigingen

```yaml
# .github/workflows/ci.yaml (excerpt)
- name: Run tests
  run: |
    flutter test --coverage
    genhtml coverage/lcov.info --output=coverage/html
- uses: actions/upload-artifact@v3
  with:
    name: coverage-report
    path: coverage/html
```

## 📊 Risico's & Mitigatie

| Risico | Impact | Mitigatie |
|--------|--------|-----------|
| Flaky UI-tests in CI | Medium | Run tests on **physical iOS device farm (GitHub runner + Xcode)** later; retry-logic 1× |
| Supabase network calls | High | Use `StubHttpClient` + local JSON fixtures |
| FieldDiagram golden drift | Low | Lock Skia renderer version; goldens in `/test/goldens/` |

## 👥 Rollen & Verantwoordelijkheden

| Rol | Persoon/team | Taken |
|-----|--------------|-------|
| Test Lead | @roel | Owns plan, triage flaky tests, coverage tracking |
| Service Maintainer | Backend guild | Provide mock Supabase schema & fixtures |
| QA Reviewer | Dev-ops guild | Code reviews, merge approval |

## ✅ Definition of Done

* Test-suite draait < 4 min in CI.
* Coverage badge ≥ 60 % zichtbaar in README.
* No flaky tests (stability ≥ 95 % over 10 runs).
* All new PRs require passing tests via branch protection.

---

*Laatste update: 08-07-2025*
