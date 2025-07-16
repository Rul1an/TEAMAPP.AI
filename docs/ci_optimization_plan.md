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

---
## Phase 2 – Remaining clean-up & hardening (to be approved)

| # | Task | Owner | Effort | Notes |
|---|------|-------|--------|-------|
| 2.1 | **Apply `concurrency` + `permissions` to**<br>• `docs-snippets.yml`<br>• `lefthook.yml`<br>• `supabase-rls.yml` (✅ done)<br>• `profiles-ci.yml` (✅ done)<br>• `ci-monitor.yml` (✅ done) | Dev-Ops | XS | Same snippet as phase-1 |
| 2.2 | **Migrate remaining jobs to composite action**<br>• `performance-test` (needs `npm` only → keep Flutter install minimal)<br>• `deploy-staging` / `deploy-production` (build step already done – no Flutter) | Dev | S | Pass `project-path` as root or sub-dir |
| 2.3 | **Enable Dependabot for Actions & Dart packages**<br>Add `.github/dependabot.yml` with two updates:<br>• `package-ecosystem: "github-actions"` every day<br>• `package-ecosystem: "pub"` weekly (directory = `/` & `/jo17_tactical_manager`) | Dev-Ops | XS | Keeps actions & analyzer aligned with SDK 3.8+ |
| 2.4 | **Replace Netlify auth with OIDC** (optional, requires Netlify UI change)<br>Use `netlify/actions/cli@3` + `id-token` → short-lived token. | Dev-Ops | M | Netlify supports OIDC since Jan-2025 |
| 2.5 | **Introduce reusable workflow**<br>Create `.github/workflows/_flutter.yml`. Jobs can call:<br>`uses: ./.github/workflows/_flutter.yml` with inputs (task: test/build). | Dev | M | Eliminates YAML duplication across repos |
| 2.6 | **Caching optimisation**<br>Add `cache: "npm"` to `setup-node@v5` step in `performance-test`. | Dev | XS | Saves ~30 s per run |
| 2.7 | **Security hardening**<br>• Add `sigstore/cosign-installer@3` and sign the web artefact before upload.<br>• Add `codeql` SAST (language: javascript for workflows). | Security | M | Aligns with GH policy 2025-Q2 |

### External references (2025)
* GitHub Actions Concurrency docs (updated 2024-10)
* Netlify OIDC guide: https://docs.netlify.com/cli/oidc/
* Dependabot v2 schema: https://docs.github.com/en/code-security/dependabot/working-with-dependabot
* Composite & reusable workflows best-practices (GitHub Blog Feb-2025)

---
### Approval checklist
- [ ] Phase 2 tasks reviewed & prioritised
- [ ] Netlify OIDC feasibility confirmed with platform team
- [ ] Security team signs off on Cosign/CodeQL integration