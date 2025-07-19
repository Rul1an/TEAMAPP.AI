# Step 12 – Model Drift Monitoring & Automated Retraining Pipeline (2025)

> **Context.** Step 12 finalises the AI-Refinement epic by adding a closed feedback-loop that detects *data* and *concept* drift in production, triggers automated retraining, and redeploys improved YOLO-V9 checkpoints with full Governance/Risk/Compliance (GRC) traceability.

---

## 1. Goals

1. Detect data / concept drift within **5 min** of threshold breach (p95).  
2. Auto-retrain & shadow-deploy new model within **3 h** of confirmed drift.  
3. Achieve **≤ 1 %** Δ-mAP degradation between last training & current production window.

---

## 2. Architecture (2025 blueprint)

```
┌───────────────┐      OTLP/HTTP        ┌────────────────┐
│  JO17 App     ├─── traces + metrics ─▶ Grafana / Loki │
└───────────────┘                       └────────────────┘
        │                                   ▲
        ▼ Prometheus Remote-Write           │
┌────────────────┐            Alertmanager ─┘
│  Prometheus    │               │
│  (histograms)  │ ◀─────────────┘             S3 Artifact Store
└────────────────┘                                 ▲
        │                                         │
        ▼ Kafka + OTEL Collector                 │
┌────────────────┐      Feature Drift            │
│  Evidently AI  │ ◀───────────────┐             │
└────────────────┘                 │   SHA-256 +  │
        │ Webhooks                 │   metadata  │
        ▼                          ▼             │
┌────────────────┐         ┌──────────────────┐  │
│  Argo Workflows│ ───────▶│  Train YOLO-V9   │──┤
│  (retrain CI)  │         │  (GPU pool)      │  │
└────────────────┘         └──────────────────┘  │
        │ Helm promote                              │
        ▼                                           │
┌────────────────┐     Canary (shadow)              │
│ Kubernetes      │ ────────────────────────────────┘
└────────────────┘
```

---

## 3. Metrics & Drift Tests

| Category | Metric | Source | Threshold | Action |
|----------|--------|--------|-----------|--------|
| *Model perf* | mAP@0.5 (val) | Ultralytics log → Prometheus | −3 pp vs baseline | Retrain job |
| *Latency* | p95 inference (ms) | App OTEL histogram | >250 ms | SLA alert (Step 11) |
| *Data drift* | KL divergence (RGB histogram) | Evidently | >0.15 | Flag drift |
| *Concept drift* | PSI on object class “ball” | Evidently | >0.25 | Flag drift |

*Statistical tests 2025:*  
• **Kolmogorov–Smirnov 2-sample** for continuous features.  
• **Jensen-Shannon Distance** for class-probability vectors (multiclass).  
• **Unsupervised Autoencoder reconstruction error** for latent embeddings ( >3 σ ⇒ anomaly ).

---

## 4. Retraining Workflow (Argo)

1. **Trigger** – Drift-alert webhook from Evidently AI.  
2. **Data pull** – Incremental dataset `last_n_days=14` from object-store.  
3. **Fine-tune** – Run `ai/train_yolov9.py` with `--epochs 40`.  
4. **Eval** – Compare metrics vs prod (`best.pt`).  
5. **Package** – Export INT8 ONNX via `ai/quantize_yolov9_onnx.py`.  
6. **Security scan** – Check SBOM + CVE (Trivy).  
7. **Shadow deploy** – Helm release `yolov9-shadow`.  
8. **A/B route 1 % traffic** for 60 min.  
9. **Promote** if Δ-mAP ≥ 0 & p95 latency ≤ prod.  
10. **Rollback** on SLO miss.  
11. **Audit log** – Push event to GRC ledger (supabase table `model_audit`).

---

## 5. Compliance & Governance

* Aligns with **EU AI Act** Article-15 (Transparency) → stores model card & drift reports.  
* Generates `model.json` manifest with SHA-256, dataset hash, hyper-params.  
* Retains last **N = 10** models for audit (S3 lifecycle rule 180 days).  
* `Sentry DataScrubbers` ensure PII is excluded from training artefacts.

---

## 6. Timeline & Owners

| Day | Task | Owner |
|-----|------|-------|
| D1 | Provision Evidently AI cloud + Kafka topic | DevOps |
| D2 | Add histogram export in app (`TelemetryService`) | Anika |
| D3 | Argo template + GPU node-pool IaC | Omar |
| D4 | Create Prometheus rules + Alertmanager route | Chen |
| D5 | Shadow-deploy Helm chart skeleton | Dmitry |
| D6 | End-to-end dry-run (synthetic drift) | Lisa |
| D7 | Documentation & hand-over to SRE | Team |

---

## 7. Risks & Mitigations

| # | Risk | P | I | Mitigation |
|---|------|---|---|------------|
| 1 | False-positive drift alerts | M | M | Hysteresis window + manual approve toggle |
| 2 | GPU quota exhaustion | M | H | Spot-instances fallback, budget alert |
| 3 | Regulatory update (EU AI Act V2) | L | M | Quarterly compliance review |

---

## 8. References (2024-2025)

1. Evidently AI v2 “Drift Detection Cookbook” (Jan 2025)  
2. Fiddler AI – *ML Model Monitoring Best Practices* (Jul 2025)  
3. IEEE P7001-25 Draft – Transparency of Autonomous Systems  
4. AWS *CloudFront Brotli & Zstd Encoding* (GA 2024-12)  
5. Ultralytics YOLOv9 Docs v9.0.2 (Feb 2025)

---

*Prepared: 16 Jul 2025 – Product & Engineering*