# Sprint 6 – Veo Edge Performance & Beta Hardening (2025-08)

## Doel
1. **Cold-start ≤ 100 ms** op Supabase Edge-runtime (Deno Deploy).  
2. **Latency P95 ≤ 60 ms** voor `veo_fetch_clips` (met token-cache miss).  
3. Gereedmaken voor **Public Beta** – 0 downtime deploy pipeline.

## Stories
| ID | Omschrijving | Target | Owner |
|----|--------------|--------|-------|
| VEO-107 | Bundle-optimalisatie & treeshake deps (esbuild) | ✅ Done |
| VEO-108 | Pre-warm token cache via periodic cron (edge schedules) | ✅ Done |
| VEO-109 | HTTP/2 Keep-alive pool voor GraphQL fetch | ✅ Done |
| VEO-110 | CI artifacts cache (`edge-runtime build`) | 🟡 In progress |
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
- [x] Blue-green routed via cell-based architecture (Supabase Regions)
- [x] Zero-trust egress policy (GraphQL & OAuth hosts allow-list)
- [ ] SLA dashboards public via Grafana Cloud share-link

## Implementatie-details VEO-110

Doel: versnel CI door build-artefacten (`supabase/edge_functions/dist/*`) te cachen.

1. **build_cache.sh**  – berekent hash van Edge-SRC + package-lock; slaat tar.xz in `~/.cache/edge_build/`.
2. **GitHub Actions**  – `actions/cache` key=`edge-${{ hashFiles('supabase/edge_functions/**/*.ts', 'package-lock.json') }}`
3. Bij hit: skip `npm run build:edge`; anders uitvoeren en cache herstellen.
4. Metrics: action step `save-cache` logt gereduceerde tijd (verwacht -40%).

_Workflow-snippet_
```yaml
- name: Restore Edge build cache
  uses: actions/cache@v4
  with:
    path: supabase/edge_functions/dist
    key: edge-${{ hashFiles('supabase/edge_functions/**/*.ts', 'package-lock.json') }}

- name: Build Edge functions (if needed)
  run: |
    if [ ! -d supabase/edge_functions/dist ]; then
      npm run build:edge
    fi

- name: Save Edge cache
  uses: actions/cache/save@v4
  if: success()
  with:
    path: supabase/edge_functions/dist
    key: edge-${{ hashFiles('supabase/edge_functions/**/*.ts', 'package-lock.json') }}
```

Nog te doen voor VEO-110:
* Integratie in `.github/workflows/ci.yml`.
* Documenteer _cache warming_ voor lokale dev (`npm run build:edge --cache`).