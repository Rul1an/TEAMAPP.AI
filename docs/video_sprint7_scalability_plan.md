# Sprint 7 – Scalability & Monetisation (2025-09)

> Scope : voorbereiden commerciële launch (tier-based billing), multi-region schaalbaarheid en advance compliance.

## Doelstellingen
1. **Multi-region active/active**: Edge-functions gedeployed naar _EU-West_, _US-East_ en _AP-Southeast_ met latentie-gebaseerde routing (≤ 80 ms P95 global).
2. **Rate-limits per subscription tier** (basic = 60 req/min, pro = 600, enterprise unlimited + burst).  
3. **Usage-based metering & Stripe billing integration**.
4. **Data-compliance** (GDPR/CCPA) – geo-fencing video assets & KMS-managed encryption.

## Stories
| ID | Beschrijving | Acceptance Criteria | Points |
|----|--------------|---------------------|--------|
| VEO-113 | Multi-region build & deploy matrix (Supabase Regions API) | Blue-green per regio + health probes | 5 |
| VEO-114 | Global Anycast routing (Cloudflare) met latency probing | <80 ms P95 RTT | 3 |
| VEO-115 | Tier-based rate-limiter (edge KV) middleware | 429 on overflow, OTLP metric `veo.rate_limited_total` | 5 |
| VEO-116 | Usage collector → Stripe metered billing (customer portal) | Invoices match metrics ±1 % | 8 |
| VEO-117 | Geo-replicated Storage buckets + KMS encryption at rest | Region-locked assets, cross-region fail-over <5 min | 5 |
| VEO-118 | Data-deletion workflow & audit log | 100 % test coverage, GDPR article 17 compliant | 3 |
| **Totaal** |   | **29** |

## Deliverables
* `edge_middleware/rate_limit.ts` – generic LRU + token-bucket, reads tier from JWT claim.
* GitHub workflow `edge_deploy_matrix.yml` – builds once, deploys to regions array.
* Prometheus alerts: `rate_limited_total > 0` warn.
* `billing_service/stripe_webhooks.ts` – sync subscription tier to user metadata.
* Terraform module `storage_replication.tf` – multi-region buckets + CMEK.
* Knowledge-base doc _GDPR SOP_.

## Risico’s & Mitigatie
* Stripe metered billing clocks drift →  reconcile daily with Prometheus usage export.
* Rate-limit false-positives → sliding-window + leaky-bucket hybrid.
* Multi-region consistency for token cache → choose regional caches; token valid globally.

## Best Practices 2025 Checklist (Sprint 7)
- [ ] Latency-based routing via Anycast & RUM feedback loop.
- [ ] Dynamic config rollout (_Feature-Flags as Data_; no redeploy).
- [ ] Zero-trust IAM between edge & storage (mTLS, short-lived tokens).
- [ ] Usage transparency dashboards public.

---

## Tijdlijn
Week 1: 113 / 114 kick-off, rate-limit spike.  
Week 2: 115 implement + internal load-test.  
Week 3: 116 billing integration, start legal review.  
Week 4: 117 replication + 118 audit trail, hard-ening & pen-test.