# Merge- & Rebase-strategie naar `main`

_Stand: na merge van `cursor/bekijk-branch-inhoud-4ef3` → `main` (commit 7344f8b)_

## 1  Overzicht categorieën

| Categorie | Doel | Voorbeeld-branches |
|-----------|------|--------------------|
| **CI / Infra** | Werk- & deployment-workflows, scripts, Terraform | `fix-error-in-file-check-process-d91e`, `check-and-resolve-ci-workflow-issues-903b`, … |
| **Epics / Features** | Grote functionele uitbreidingen | `feature/ui_refinement_q3_2025`, `feature/import-phase-completion`, `implement-mlops-workflow-and-policies-3d1b`, `plan-sprint-7-scalability-and-monetization-286c` |
| **UI-refinements** | Verbeteringen/bugfixes top-laag UI – leunen op UI-epic | `continue-ui-refinement-and-implementation-c2c5`, `fix-training-attendance-fab-navigation-7816`, … |
| **Bug / Quality sweeps** | Kleine fixes, lints, test-herstel | `analyze-and-fix-test-errors-59ab`, `fix-null-coalescing-operator-issue-8a1c`, … |
| **Docs / Roadmap** | Alleen documentatie | `plan-video-sprint-*`, `update-*`, … |

## 2  Relatie‐mapping

### 2.1 UI Refinement Epic
```
feature/ui_refinement_q3_2025  (basis)
├─ continue-ui-refinement-and-implementation-c2c5
├─ fix-training-attendance-fab-navigation-7816
├─ fix-match-detail-screen-errors-and-failing-tests-19de
├─ analyseer-merge-conflicten-en-merge-besluit-6874
└─ bc-3d18b772-98e7-46f5-8c0d-3cf05ac58d9d-1983
```

### 2.2 Import-Phase Epic
```
feature/import-phase-completion  (basis)
└─ implement-sprint-1-import-phase-completion-b50e
```

### 2.3 Scalability & Monetization Epic
```
plan-sprint-7-scalability-and-monetization-286c  (basis)
└─ fix-s3-replication-kms-and-syntax-2f5b
```

### 2.4 MLOps Epic
```
implement-mlops-workflow-and-policies-3d1b
(geen aparte child-branches)
```

CI/Infra-branches staan los van bovenstaande epics.

## 3  Gefaseerde merge-volgorde

> **NB:** Elke stap: `git fetch --all` → branch **rebasen** op actuele `main`, tests runnen, _pas dan_ merge (via PR of fast-forward) + CI-gate.

1. **CI / Infra**  
   a. `fix-error-in-file-check-process-d91e` (98 commits)  
   b. `check-and-resolve-ci-workflow-issues-903b`  
   c. `resolve-git-merge-conflict-in-documentation-d4f0`  
   d. `run-flutter-tests-and-fix-errors-3235`  
   e. overige `fix-ci-*`, `her-enable-deployment-*`, `setup-flutter-sdk-*`  
   _Rationale: minimal code overlap, unblockt pipelines voor volgende features._

2. **UI Refinement Epic**  
   a. `feature/ui_refinement_q3_2025`  
   b. Child-branches in volgorde van grootte:  
      i. `continue-ui-refinement-and-implementation-c2c5`  
      ii. `fix-training-attendance-fab-navigation-7816`  
      iii. `fix-match-detail-screen-errors-and-failing-tests-19de`  
      iv. `analyseer-merge-conflicten-en-merge-besluit-6874`  
      v. `bc-3d18b772-98e7-46f5-8c0d-3cf05ac58d9d-1983`  
   _Rationale: child-branches bouwen op epic; rebase voorkomt dubbele conflicts._

3. **Import-Phase Epic**  
   a. `feature/import-phase-completion`  
   b. `implement-sprint-1-import-phase-completion-b50e`

4. **Scalability & Monetization Epic**  
   a. `plan-sprint-7-scalability-and-monetization-286c`  
   b. `fix-s3-replication-kms-and-syntax-2f5b`

5. **MLOps Epic**  
   • `implement-mlops-workflow-and-policies-3d1b`

6. **Bug / Quality sweeps**  
   Groepeer naar onderwerp, rebase en cherry-pick waar handig; voorbeeldvolgorde:  
   1. analyzers/lints (`fix-null-coalescing-operator-issue-8a1c`, `analyze-and-fix-static-analysis-issues-dc9c`, …)  
   2. test-fixes (`analyze-and-fix-test-errors-59ab`, `fix-test-case-errors-in-project-ead8`, …)  
   3. functionele minor-fixes (`fix-multiple-bugs-in-the-codebase-8e1c`, …)

7. **Docs / Roadmap**  
   Merge of squash rechtstreeks zodra relevante feature is in-geklapt.

## 4  Checklist per merge

- [ ] Branch rebased op laatste `main` (geen merge-commits)
- [ ] `flutter pub get` / `melos bootstrap` succesvol
- [ ] `melos run build_runner` & tests groen
- [ ] `dart analyze` & `flutter analyze` nul fouten
- [ ] CI-workflow groen na PR-merge
- [ ] Release-notes/CHANGELOG bijgewerkt indien nodig

---

> **Tip:** documenteer de status in `workflows.json` of equivalent dashboard zodat team real-time ziet welke batch in progress is.