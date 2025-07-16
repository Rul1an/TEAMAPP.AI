# Sprint 6 – Veo Edge Performance & Beta Hardening (2025-08)

## Doel
1. **Cold-start ≤ 100 ms** op Supabase Edge-runtime (Deno Deploy).  
2. **Latency P95 ≤ 60 ms** voor `veo_fetch_clips` (met token-cache miss).  
3. Gereedmaken voor **Public Beta** – 0 downtime deploy pipeline.

## Stories
| ID | Omschrijving | Target | Owner |
|----|--------------|--------|-------|
| VEO-107 | Bundle-optimalisatie & treeshake deps (esbuild) | cold-start 100 ms | @core-edge |
| VEO-108 | Pre-warm token cache via periodic cron (edge schedules) | <10 ms auth | @core-edge |
| VEO-109 | HTTP/2 Keep-alive pool voor GraphQL fetch | −25 ms hop | @core-edge |
| VEO-110 | CI artifacts cache (`edge-runtime build`) | 40 % faster | @dev-ex |
| VEO-111 | Blue-green deploy + health-probe | zero-downtime | @dev-ops |
| VEO-112 | Docs polish & public beta landing page | marketing | @docs |

## Deliverables
* `scripts/build_edge.sh` – esbuild bundling 
* `supabase/functions/.edge_manifest.json` – hashed bundles for pre-warm
* Edge Cron: `/veo_ping_token` every 5 min (Supabase Scheduled Function)
* Grafana dashboards → SLO alerts (cold-start, latency)

## Risico’s & Mitigaties
* esbuild minification kan source-map breken → run e2e + OTLP check.  
* Keep-alive pool memory leak → add Canary (10 % traffic) for 24 h.

## Tijdsindicatie
| Story | Points |
|-------|--------|
| VEO-107 | 5 |
| VEO-108 | 3 |
| VEO-109 | 3 |
| VEO-110 | 2 |
| VEO-111 | 5 |
| VEO-112 | 2 |
| **Totaal** | **20** |

---

## Best Practices 2025 Checklist
- [x] OTLP spans + exemplars voor performance metrics
- [ ] Blue-green routed via cell-based architecture (Supabase Regions)
- [ ] Zero-trust egress policy (GraphQL & OAuth hosts allow-list)
- [ ] SLA dashboards public via Grafana Cloud share-link