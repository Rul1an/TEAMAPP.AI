# Sprint 0 – Developer Experience Foundation (DX-sprint)

> Scope: realiseer pre-commit quality-gate (Lefthook), uniforme lint-regels (very_good_analysis 5.x) en metrics (Dart Code Metrics) zodat refactors & features in latere sprints sneller en veiliger zijn.

## 1 – Back-log & Deliverables

| Nr. | Issue  | Deliverable | Definition of Done |
|-----|--------|-------------|--------------------|
| 36  | Pre-commit hooks | `.lefthook.yml` met parallele taken; `lefthook run --all` job in CI; hooks geïnstalleerd (git) | *Alle commits falen/ slagen lokaal & in CI volgens de hook-uitkomst* |
| 35  | very_good_analysis + DCM | `analysis_options.yaml` inclusief VGV 5.1.0 plus DCM-plug-in; `pubspec.yaml` dev-deps bijgewerkt | *`dart analyze` produceert 0 errors; DCM run zonder fatal* |
| –   | Team-onboarding | README-dev sectie „Git Hooks & Lint” | *Nieuwe developer kan project clonen, `lefthook install` draait automatisch* |

## 2 – High-level Activiteiten

1. **Tooling‐setup**  
   a. Voeg packages toe (`pub add --dev …`)  
   b. Genereer/ schrijf `.lefthook.yml`  
   c. Maak script `tool/install_hooks.sh` (post-install)
2. **Lint-profiel**  
   a. Kopieer include van `very_good_analysis`  
   b. Plug-in `dart_code_metrics`; voeg belangrijkste regels toe
3. **CI-integratie**  
   a. Pas `.github/workflows/ci-monitor.yml` aan: `lefthook run --all`  
   b. Cache Pub & Lefthook binary voor snelheid
4. **Validatie & fixes**  
   a. Run `dart fix --apply`, `dart format` op repo  
   b. Los resterende analyzer errors op (quick-wins)
5. **Documentatie**  
   a. `README_DEV.md` > stappen „Setup hooks / Lint”  
   b. Changelog entry
6. **Review & merge**  
   a. Team-review PR  
   b. Squash & merge na groene CI

## 3 – Detail-taken & Commands

### 3.1 Packages installeren
```bash
npm install --save-dev lefthook
flutter pub add --dev very_good_analysis dart_code_metrics
```

### 3.2 Lefthook initialiseren
```bash
lefthook install    # schrijft .git/hooks
```

### 3.3 .lefthook.yml (voorbeeld)
```yaml
pre-commit:
  parallel: true
  commands:
    format:
      run: dart format --line-length=100 {staged_files}
    import_sorter:
      run: flutter pub run import_sorter:main {staged_files}
    analyze:
      run: dart analyze --fatal-infos
    dcm:
      run: dcm analyze --fatal-style --fatal-performance ./
commit-msg:
  scripts:
    commitlint:
      runner: npx --yes commitlint --edit $1
```

### 3.4 analysis_options.yaml (snippet)
```yaml
include: package:very_good_analysis/analysis_options.5.1.0.yaml

analyzer:
  exclude:
    - build/**
  plugins:
    - dart_code_metrics

dart_code_metrics:
  rules:
    - newline_before_return
    - no-equal-then-else
```

### 3.5 CI-workflow uitbreiding
```yaml
- name: Lefthook – all hooks
  run: npx lefthook run --all
```

## 4 – Planning & RACI

| Dag | Activiteit | R | A | C | I |
|-----|-----------|---|---|---|---|
| D1  | Tooling-setup, lefthook init | Dev-1 | TechLead | Dev-team | QA |
| D2  | analysis_options & lint fixes | Dev-2 | TechLead | Dev-team | QA |
| D3  | CI-update & documentatie | Dev-1 | DevOps | TechLead | All |
| D4  | Code-review & merge | TechLead | PO | Dev-team | QA |

*Legenda:* **R** = Responsible, **A** = Accountable, **C** = Consulted, **I** = Informed

## 5 – Acceptatiecriteria (Sprint Review)

1. `git commit` zonder staged wijzigingen → hook abort met duidelijke melding.  
2. Bewuste lint-overtreding in `.dart` file laat commit falen.  
3. PR-CI job slaagt wanneer repo clean is; faalt wanneer fout wordt geïntroduceerd.  
4. Onboarding vanaf scratch (clone + `flutter pub get`) resulteert in ge-installeerde hooks.

## 6 – Risico’s & Mitigatie

| Risico | Impact | Kans | Mitigatie |
|--------|--------|------|-----------|
| performance lange hooks | medium | low | parallel=true + only staged files |
| false-positives van nieuwe lints | low | medium | lint-set reviewen, regels op warn i.p.v. error |
| CI minuten verhoogd | low | low | Job cache + run alleen analyse |

## 7 – Resources / Referenties

* Evil Martians – “Leveraging Lefthook” (2024-03)  
* very_good_analysis 5.1.0 changelog  
* Dart Code Metrics docs 1.19 (May 2025)

---
*Laatste update:* 2025-07-14