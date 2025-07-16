# 📽️ Video Platform – Sprint 8 Plan (Reliability & Chaos Engineering)

_Last updated: 2025-07-16_

## 1. Sprint Goal
Verhoog de **betrouwbaarheid** van het video-platform naar **≥ 99,95 % availability** door proactieve chaos-testen, geautomatiseerde herstelmechanismen en observability-verbeteringen.

## 2. Alignment met Best Practices 2025
| # | Best Practice 2025 | Sprint 8-toepassing |
|---|--------------------|---------------------|
| 1 | **Clean Architecture** | Chaos-scripts en infra-modules worden los als _tools_ gepackaged; geen logica in workflows. |
| 2 | **Automation-first (CI gates)** | Nightly chaos-runs & CI-monitor; alle dashboards worden als _IaC_ (Terraform/CloudWatch) gedeployed. |
| 3 | **Quality bar 0 infos** | Lint + coverage checks uitgebreid naar scripts & Terraform (`tflint`, `checkov`). |
| 4 | **≤ 300 LOC/file** | Scripts gesplitst per concern (validate, fail-over, rollback). |
| 5 | **Observability built-in** | Nieuwe SLO-dashboards, alert-policies & synthetic canaries. |
| 6 | **Progressive enhancement** | Chaos-experiments geïntegreerd in blue/green deploy; feature-flags voor resilience toggles. |

## 3. Backlog & Deliverables
| Story ID | Week | Punt(en) | Deliverable | Owner | Status |
|----------|------|----------|-------------|--------|--------|
| **VEO-119** | 1 | 5 | Route 53 GameDay fail-over-script | SRE | ✅ Done |
| **VEO-120** | 1 | 5 | FIS network-latency experiment | SRE | ✅ Done |
| **VEO-121** | 1 | 3 | Nightly chaos GitHub Action | Platform | ✅ Done |
| **VEO-122** | 1 | 4 | RDS PITR (35 d) Terraform module | DB | ✅ Done |
| **VEO-123** | 1 | 4 | Disaster-Recovery runbook | Platform | ✅ Done |
| **VEO-124** | 1 | 5 | Security-scan PR-gate (`snyk`) | Security | ✅ Done |
| **VEO-125** | 2 | 4 | **SLO-dashboard** (availability & latency) + _CloudWatch Synthetics_ | Observability | ✅ Done |
| **VEO-126** | 2 | 3 | **Alerting-policy** (PagerDuty) – error budget burn | Observability | ✅ Done |
| **VEO-127** | 2 | 5 | **Dependency chaos** – Kinesis outage simulator | SRE | ✅ Done |
| **VEO-128** | 3 | 4 | **CPU/Memory stress** experiment (FIS) | SRE | ✅ Done |
| **VEO-129** | 3 | 3 | **Auto-rollback** integ. in blue/green deploy (error budget) | Platform | ✅ Done |
| **VEO-130** | 3 | 2 | **Chaos scorecard** in PR comment bot | DevEx | ✅ Done |

_Totaal story-punten: 38_

## 4. Tijdlijn
```
Week 1 │■■■■■ Done (VEO-119 … 124)
Week 2 │■■■■■ Done (VEO-125 … 127)
Week 3 │■■■■■ Done (VEO-128 … 130)
```

## 5. Definition of Done (DoD)
1. Dashboard URL gedeeld in `#video-platform-alerts` met 2 SLO-grafieken.
2. Alle chaos-experiments zijn **tagged** met `owner=video-platform` en beschikken over rollback.
3. PagerDuty route activeert binnen 2 min bij error-budget burn > 5 %.
4. CI green; **no open** `ci`-label issues (CI Monitor).

## 6. Open Risico’s
* CloudWatch Synthetics limieten kunnen kosten verhogen → budget-review na week 2.
* Kinesis outage experiment vereist hoofdsleutels; IAM-scope review scheduled.

---
_Document is auto-published via `docs-snippets.yml` workflow._