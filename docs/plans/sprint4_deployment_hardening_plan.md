# Sprint 4 – Deployment Hardening & CI Expansion (Aug 2025)

> Goal: raise the reliability & security bar so that every merge to `main` can be deployed to production automatically with confidence and speed.

## 1 — Back-log & Deliverables

| Nr. | Epic | Deliverable | Definition of Done |
|----:|------|-------------|--------------------|
| 41 | *Observability* | 🔧 **Lighthouse ≥ 90** performance/accessibility scores on PR checks | Workflow fails when any score < 90 |
| 42 | *Reliability* | 🟢 **Blue-Green deploy** flow for Cloud Run (+ automatic rollback on 5xx spike) | `advanced-deployment.yml` promotes *green* revision only after passing smoke-test & Sentry warm-up |
| 43 | *Security* | 🛡 **Secret scanning & SCA** (OSV-scanner + Trivy) in CI | Build fails on HIGH/CRITICAL CVEs or leaked secrets |
| 44 | *Supply chain* | 📦 **SBOM generation** & upload to GitHub Security tab | SBOM produced via `cyclonedx` & attached to release |
| 45 | *DX* | ⏱ **Matrix build** (Chrome, Safari, Firefox) runs Cypress smoke-suite in < 6 min | Parallelisation across 3 runners |
| 46 | *Docs* | 📄 Updated “Runbook: Prod Incident” + Loom demo | Available under `docs/ops/` |

## 2 — High-Level Activities

1. **CI workflow split**  
   • Create `.github/workflows/performance.yml` that runs Lighthouse via `treosh/lighthouse-ci-action` in PRs  
   • Add threshold comment reporter using `lighthouse-bot`
2. **Blue-Green deployment**  
   • Cloud Run service uses traffic-split 0% ➡️ 100% after health-check  
   • Implement smoke-test: hit `/health` & `/v1/ping`  
   • On error ratio > 0.1% or Sentry fatal, rollback to previous revision
3. **Security gate**  
   • Add **Trivy** for container scan; fails on HIGH/CRITICAL  
   • Run **osv-scanner** on `pubspec.lock`  
   • Enable GitHub Advanced Security secret-scanner alerts → fail PR on new leaks
4. **SBOM & provenance**  
   • Generate **CycloneDX JSON** SBOM during build  
   • Upload artifact & attach to release  
   • Sign container with `cosign` + GitHub OIDC
5. **Cross-browser smoke tests**  
   • Add minimal **Cypress** suite (login → dashboard)  
   • Use `cypress-io/github-action` matrix for Chrome, Safari Technology Preview, Firefox  
   • Parallel to keep <6 min wall-time
6. **Documentation**  
   • Update `RUNBOOK_PRODUCTION_INCIDENT.md` with rollback cmd  
   • Record 2-min Loom showing blue-green UI

## 3 — Timeline (2-week sprint)

| Day | Task | Owner |
|-----|------|-------|
| 1 | Set up perf workflow & fail-threshold | Dev-Ops A |
| 2 | Write Lighthouse bot comment script | Dev-Ops B |
| 3 | Implement Cloud Run blue-green logic | Dev-Ops A |
| 4 | Smoke-test & Sentry warm-up hook | Dev-Ops C |
| 5 | Trivy & osv-scanner integration | Security Lead |
| 6 | SBOM + Cosign signing | Dev-Ops B |
| 7 | Cypress smoke tests matrix | QA Engineer |
| 8 | Optimize build cache & doc updates | Dev-Ops A |
| 9 | Dry-run full pipeline → staging | All |
| 10 | Sprint demo & retro | Team |

## 4 — Acceptatiecriteria

1. PR fails automatically if a Lighthouse score < 90.  
2. Blue-Green rollout shows zero downtime (<1 s 5xx spike) in k6 load test.  
3. Container image passes Trivy scan (no HIGH/CRITICAL).  
4. SBOM appears in GitHub Security tab for release 0.9.x.  
5. Cypress smoke-suite passes on Chrome / Safari / Firefox in < 6 min.  
6. Runbook + Loom demo approved by PO.

## 5 — Risks & Mitigation

| Risk | Impact | Likelihood | Mitigation |
|------|--------|-----------|-----------|
| Trivy false-positives stop deploy | medium | medium | Allow override via `SECURITY_ALLOW=true` label after security review |
| Safari TP runner flakiness | low | high | Retry once, mark job `continue-on-error` but block merge if total failures > 1 |
| Cloud Run traffic-split bug | high | low | Keep manual rollback script + previous revision for 14 days |

---
*Generated 2025-07-15 – aligns with OWASP Top-10 2025 & Google Cloud best-practices.*