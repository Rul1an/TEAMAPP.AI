# Step 12 – Closed-Loop Model Drift Monitoring & Continuous Retraining Plan (2025-2026)

> Status  : **Draft v0.9 – ready for peer review**  
> Owner    : ML Platform Team  
> Reviewers: Data Science, SRE, Security & Compliance, Product  
> Related Jira epics: **VEO-155 → VEO-162**  
> Target sprint: **Sprint 12 (Q3 2025)**

---

## 1. Purpose & Executive Summary
Machine-learning performance degrades over time due to changing data distributions, concept drift and model staleness. This document defines our **closed-loop monitoring, drift detection, automated retraining and safe rollout pipeline** that keeps models reliable, compliant and high-performing in production.

Key highlights:
* Real-time and batch **drift dashboards** powered by *Evidently AI v2*.
* **Argo Workflows v4** orchestrates retraining on Kubernetes; **Weights & Biases** captures lineage & metrics.
* **Shadow + canary deployments** via *Argo Rollouts* ensure safe promotion.
* Full **auditability** & **EU AI Act (2025) compliance** baked in (risk-tier 2).
* **R & D timeline**: 10 weeks → GA in Q1 2026.

---

## 2. Goals & Non-Goals
### 2.1 Goals
1. Detect data & concept drift < **15 min** after occurrence.  
2. Auto-trigger retraining when KPI thresholds are violated or on monthly schedule.  
3. Ship retrained models through **shadow → 10 % canary → 100 % rollout** with rollback protection.  
4. Provide *near-real-time* visibility via Grafana & Evidently AI dashboards.  
5. Maintain provable lineage & model cards for regulatory audits.

### 2.2 Non-Goals
* Does **NOT** cover feature-store schema evolution (handled in Step 13).  
* On-device (mobile) model updates are out of scope.

---

## 3. Architecture (High Level)
```mermaid
flowchart TD
    subgraph Monitoring
        A1(Raw Telemetry) --> B1(Evidently Live Metrics)
        A2(Online Predictions) --> B1
    end
    B1 --> C1[Drift Alerts (Pub/Sub)]
    C1 --> D1{Policy Engine}
    D1 -- KPI breach --> E1[Argo Workflow – Retrain]
    D1 -- Monthly schedule --> E1
    E1 --> F1[Model Registry (W&B)]
    F1 --> G1[Shadow Deploy]
    G1 --> H1{SLO check + Approval}
    H1 -- pass --> I1[Canary 10 %]
    H1 -- fail --> Rollback((Rollback))
    I1 --> J1[Full Prod Rollout]
    J1 --> Monitoring
```

---

## 4. Component Detail
| # | Component | Tech Stack (2025) | Function |
|---|-----------|-------------------|----------|
| 1 | Telemetry Capture | *Kafka 3.8*, *OpenTelemetry 1.13*, *Vector 0.32* | Streams features, predictions & outcomes. |
| 2 | Drift Detection | *Evidently AI v2 (serverless mode)* | Computes statistical tests (PSI, Hellinger, KS) & performance deltas. |
| 3 | Alerting & Policy | *Cloud Pub/Sub*, *OPA v1.5* policies | Maps metric breaches to retraining triggers. |
| 4 | Training Pipeline | *Argo Workflows v4*, *Kubeflow Pipelines 2.1* SDK | Reproducible training incl. hyper-opt (Optuna), unit tests, vulnerability scan. |
| 5 | Model Registry | *Weights & Biases Core 1.0* | Stores artefacts, lineage, approval metadata. |
| 6 | Deployment | *Argo Rollouts v2*, *Istio 1.22* | Shadow, canary & automated rollback on SLO breach. |
| 7 | Observability | *Grafana 11*, *Prometheus 3*, *Loki* | Live dashboards & alerts integrated with PagerDuty. |
| 8 | Compliance | *OpenLineage*, *TrustworthyAI Toolkit 0.8* | Generates EU AI Act Annex VIII artefacts & audit logs. |

---

## 5. KPI Matrix & Thresholds (initial)
| Domain | Metric | Drift Test / Calc | Alert Threshold | Source |
|--------|--------|-------------------|-----------------|--------|
| Data | Population Stability Index (PSI) | PSI over 30 d window | > 0.2 | Evidently Live |
| Data | Feature value range | Z-score | Z > 4 | Evidently Live |
| Performance | AUROC | Δ vs training | −5 pp | W&B eval |
| Performance | Latency p95 | Raw | > 150 ms | Prometheus |
| Ethics | Demographic Parity | Δ fairness | −3 pp | TrustworthyAI |

(All thresholds will be revisited after 4 weeks of prod telemetry.)

---

## 6. Work Breakdown & Timeline
| Week | Tasks | Owner |
|------|-------|-------|
| W1 | Finalise design, OPA policies skeleton | ML-Plat |
| W2 | Set up Evidently AI live service & Grafana dashboards | Data Sci / SRE |
| W3 | Implement Argo training template, integrate Optuna | ML-Plat |
| W4 | Automate lineage push to W&B, OpenLineage PoC | ML-Plat |
| W5 | Shadow deployment path, Istio routing rules | SRE |
| W6 | Canary rollout gates, latency SLO in Prometheus | SRE |
| W7 | OPA policy hardened, security scan gating | SecOps |
| W8 | End-to-end dry-run w/ synthetic drift | All |
| W9 | Pilot on Recommendation model v3 | ML-Plat |
| W10 | GA assessment, doc & hand-off to Ops | All |

---

## 7. Risk Register & Mitigations
| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|-----------|--------|------------|
| R1 | High false-positive drift alerts | M | M | Adaptive thresholds, ensemble tests |
| R2 | Long retraining duration blocks hotfixes | L | H | Concurrent hotfix path in Argo, on-demand scaling |
| R3 | EU AI Act requires external audit | H | H | Early engagement with notified bodies, maintain audit trail |
| R4 | Cost overruns in GPU training | M | M | Spot instances, budget alerts |

---

## 8. Compliance & Governance
* Aligns with **EU AI Act risk-based framework** (Tier 2 – limited risk).  
* Generates **model cards**, **datasheets** and **Annex VIII** documentation automatically.  
* Stores signed approvals in **Git-ops repo (sealed-secrets)**.

---

## 9. Open Questions
1. Do we integrate **Databricks Feature Store** or stick with current Feast deployment?  
2. Versioning strategy for inference graphs needs endorsement.  
3. Confirm budget from FinOps for GPU on-demand quota.

---

## 10. References
* Evidently AI v2 whitepaper, Feb 2025.  
* Argo Workflows v4 roadmap, GitHub RFC #8927.  
* EU AI Act consolidated text, April 2025.  
* “Reliable & Resilient MLOps 2025”, O’Reilly.

---

**Next Action:** Please add comments in this MR before *15 August 2025*. After approval, tasks will be created in **Jira epic VEO-155**.