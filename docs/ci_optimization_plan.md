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
| 2.1 | **Apply `concurrency` + `permissions` to**<br>• `docs-snippets.yml`<br>• `lefthook.yml`<br>• `supabase-rls.yml` (✅ done)<br>• `profiles-ci.yml` (✅ done)<br>• `ci-monitor.yml` (✅ done) | Dev-Ops | XS | ✔ **Done** |
| 2.2 | **Migrate remaining jobs to composite action**<br>• `performance-test` (uses Node only – no Flutter needed) – *no change*<br>• `deploy-staging` / `deploy-production` – already Flutter-less | Dev | S | **N/A – confirmed not required** |
| 2.3 | **Enable Dependabot for Actions & Dart packages** | Dev-Ops | XS | ✔ **dependabot.yml added** |
| 2.6 | **Caching optimisation**<br>`cache: "npm"` added to `setup-node@v5` in *performance-test* | Dev | XS | ✔ **Done** |
| 2.7 | **Security hardening**<br>Cosign signing + CodeQL SAST added | Security | M | ✔ **Implemented** |

### External references (2025)
* GitHub Actions Concurrency docs (updated 2024-10)
* Netlify OIDC guide: https://docs.netlify.com/cli/oidc/
* Dependabot v2 schema: https://docs.github.com/en/code-security/dependabot/working-with-dependabot
* Composite & reusable workflows best-practices (GitHub Blog Feb-2025)

---
### Approval checklist
- [ ] Phase 2 tasks reviewed & prioritised
- [ ] Netlify OIDC feasibility confirmed with platform team
- [ ] Security team signs off on Cosign/CodeQL reports after first run

---
## Implementation proposals awaiting approval

### 2.4  Netlify OIDC Migration
```
# Example replacement step (production deploy)
- name: 🌟 Deploy to Netlify (OIDC)
  id: netlify-deploy
  uses: netlify/actions/cli@3
  with:
    args: deploy --dir=build/web --prod
  env:
    NETLIFY_AUTH_TOKEN: ''   # not required with OIDC
    NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
  permissions:
    id-token: write   # allow OIDC token request
```
*Prerequisites*
1. Enable **GitHub OIDC** in Netlify UI → *Site settings › Build & deploy › Continuous Deployment › Authentication tokens*.
2. Add GitHub repo as trusted, copy generated audience string (e.g. `netlify.com`) if required.
3. Remove `NETLIFY_AUTH_TOKEN` secret after cut-over.

### 2.7  Security hardening (Cosign & CodeQL)

1. **Cosign**
```
  - name: 📦 Install Cosign
    uses: sigstore/cosign-installer@v3

  - name: 🔏 Sign web artefact
    env:
      COSIGN_EXPERIMENTAL: 1
    run: cosign sign-blob --yes --output-signature build/web.sig build/web/index.html
```
  * Store public-key in repository (read-only) or use key-less attitude (Fulcio).  Artifact upload step must include both artefact and `.sig` file.

2. **CodeQL**
Add reusable workflow or job:
```
security-scan:
  uses: github/codeql-action/init@v3
    with:
      languages: javascript  # scanning workflows & Node tooling
  ...
  - uses: github/codeql-action/analyze@v3
```
  *Will run in parallel to existing super-linter.*