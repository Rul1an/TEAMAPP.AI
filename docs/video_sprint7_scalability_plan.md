# Sprint 7 – Scalability & Monetisation (2025-09)

## Doelstellingen

* **Multi-region active/active** (EU-W, US-E, AP-SE) met **P95 ≤ 80 ms** end-to-end latency
* **Tier-based rate-limits**  
  * Basic → 60 requests/min  
  * Pro → 600 requests/min  
  * Enterprise → ∞ + burst-credits
* **Usage-metering → Stripe billing** (metered subscriptions & on-demand overage)
* **GDPR / CCPA-compliance** – geo-fenced storage met **KMS-encryptie**

---

## Stories & Story Punten

| Key | Beschrijving | Ptn |
|-----|--------------|-----|
| VEO-113 | Multi-region build/deploy-matrix | 5 |
| VEO-114 | Global Anycast routing < 80 ms | 3 |
| VEO-115 | Edge rate-limiter middleware | 5 |
| VEO-116 | Usage-collector → Stripe metered billing | 8 |
| VEO-117 | Geo-replicated buckets + KMS | 5 |
| VEO-118 | Data-deletion workflow & audit-log | 3 |
| **Totaal** |  | **29** |

---

## Deliverables

* `edge_middleware/rate_limit.ts` — LRU cache + token-bucket (**✅ implemented**)
* Workflow `edge_deploy_matrix.yml` — _build once, deploy per regio_ (**✅ implemented**)
* Prometheus-alert `veo.rate_limited_total` (**✅ added**)
* `scripts/load_test_rate_limit.ts` + workflow `edge-loadtest.yml` (**✅ implemented**)
* `billing_service/stripe_webhooks.ts`, `subscription_sync.ts`, `usage_collector.ts` (**in-progress – VEO-116**)
* Terraform `storage_replication.tf` (multi-region + CMEK) (**✅ draft**) 
* GDPR **SOP-document** (**✅ draft**)
* `lib/services/feature_flag_service.dart` (**✅ implemented**)
* Stripe Prometheus exporter `stripe_prom_exporter.ts` + alert `stripe_billing.yml` (**✅ implemented**)

---

## Risico’s & Mitigatie

| Risico | Impact | Mitigatie |
|--------|--------|-----------|
| Billing-drift | Onjuist factureren → revenue leak | Dagelijks reconciliëren via Prometheus-export & Stripe API |
| False-positive rate-limits | Legit verkeer geblokkeerd | Sliding-window + leaky-bucket hybrid, SLO-alerts |
| Token-cache inconsistency | Access-errors regionaal | Regionale caches met global token-validity TTL |

---

## Best-Practices 2025 Checklist

- [x] Latency-based routing met RUM-feedback
- [x] Feature-flags-as-data (zonder redeploy)
- [ ] Zero-trust mTLS tussen edge & storage
- [ ] Publieke usage / SLA-dashboards

---

## Tijdlijn

| Week | Focus |
|------|-------|
| 1 | (✅) Stories **VEO-113**, **VEO-114** kick-off & rate-limit spike |
| 2 | (✅) Story **VEO-115** middleware, unit- & load-tests |
| 3 | (in-progress) Story **VEO-116** billing, start legal review |
| 4 | Stories **VEO-117**, **VEO-118**, hardening & pen-tests |