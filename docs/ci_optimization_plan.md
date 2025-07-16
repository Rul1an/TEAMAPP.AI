# CI Optimisation Plan – July 2025

This document tracks the quick-win improvements that are being rolled out to the
GitHub Actions configuration for **TEAMAPP.AI**.

---
## 1  Remove duplicate workflows
| ✅ Done | Item |
|---------|------|
| ✔ | *flutter-web.yml* converted to **manual / deprecated** |
| ✔ | *ci.yml* converted to **manual / deprecated** |

> Rationale – they duplicated all steps already covered by
> `advanced-deployment.yml` and wasted CI minutes.

---
## 2  Global concurrency / permissions

*Added to `advanced-deployment.yml` (other workflows will be patched in phase 2)*
```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read
  id-token: write # required for OIDC deployments
```

---
## 3  Reusable *setup-flutter* action

Location `/.github/actions/setup-flutter/action.yml`
* Checkout → Flutter install → `pub get` → `build_runner`.
* Latest `subosito/flutter-action@v3` used.
* Inputs: `flutter-version` & `project-path`.

Adopted already in the **Quality Assurance** job. Remaining jobs will migrate
in a follow-up commit.

---
## 4  Eliminate `cd jo17_tactical_manager` boilerplate

From the QA steps now handled by the composite action; the legacy inline `if …
cd` snippets have been stripped.

---
## 5  Upgrade 1st-party actions to latest major versions
* `actions/upload-artifact` → **v5**
* `actions/download-artifact` → **v5**
* `actions/setup-node`       → **v5**
* `subosito/flutter-action`   → **v3** (via composite)

---
## Next phases
1. Add `concurrency` + `permissions` to the remaining workflows.
2. Replace duplicated Flutter setup in `build-and-test`, `performance-test`,
   and other jobs with the composite action.
3. Enable Dependabot for actions & Flutter versions.
4. (Optional) Migrate Netlify deploy steps to OIDC-based authentication.