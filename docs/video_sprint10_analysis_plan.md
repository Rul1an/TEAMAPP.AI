# Video Sprint 10 — Advanced Analysis & Insights (May 12 – May 23 2025)

## 1. Sprint Goal
Deliver the first _coach-ready_ **Analysis & Insights** stack that automatically extracts tactical patterns from tagged video and surfaces them in an interactive dashboard, while ensuring SLAs (< 200 ms p95) and full offline mode on tablets.

## 2. Strategic Alignment
| Dimension | Alignment |
|-----------|-----------|
| Company OKR | _“Elevate coaching efficiency by 25 % via AI-driven insights (OKR-2.1)”_ |
| Product Vision | Build the #1 all-in-one video assistant for amateur clubs by 2026 |
| Tech North Star | _Event-driven core, Observable-by-default, AI-first developer experience_ |
| Stakeholders | Product : @eva, Engineering : @ramon, Data Science : @lisa, UX : @tom |

## 3. Committed Backlog (VEO-139 … VEO-146)

| #  | Title | Type | Effort | Acceptance Criteria |
|----|-------|------|--------|----------------------|
| VEO-139 | **Real-time VideoEventDetectorService (v1)** | FE + BE | 8 | • Detects goals, corners & fouls within 1 s of tag.<br>• Streams events through Supabase `realtime` channel.<br>• 95 % precision/recall on test set. |
| VEO-140 | **PlayerMovementAnalytics MVP** | DS + BE | 5 | • Calculates heat-maps & distance-covered / player.<br>• Exportable as JSON via `/analytics/player/{id}` RPC. |
| VEO-141 | **SmartPlaylistService v2 – pattern recognition** | BE | 5 | • Generates drill playlists (high-press, counter-attack).<br>• <200 ms p95 for 60-minute match. |
| VEO-142 | **AnalysisDashboard Screen (Flutter)** | FE | 8 | • Responsive UX with offline cache (Hive).<br>• Real-time updates via Riverpod streams.<br>• Lighthouse PWA score ≥ 90. |
| VEO-143 | **Data Export (CSV/Excel)** | BE | 3 | • Coach can export selected tags & metrics.<br>• Export finishes <5 s for 90-minute match. |
| VEO-144 | **Observability & SLIs for Analysis Pipeline** | DevOps | 3 | • OpenTelemetry 2.0 traces for every step.<br>• Grafana dashboard with p50/p95, error rate.<br>• Alerting via PagerDuty (≤ 2 min MTTA). |
| VEO-145 | **E2E integration test `analysis_flow_test.dart`** | QA | 3 | • Covers tag → detector → dashboard happy-path.<br>• Runs in CI (<180 s) & on Firebase Test Lab (tablet). |
| VEO-146 | **UX polish & a11y improvements** | FE | 2 | • Keyboard navigation, contrast ratio AA.<br>• Voice-over labels for metrics. |

_Total committed capacity_: 37 SP (team velocity avg = 38).

## 4. Timeline & Key Activities

| Date | Activity |
|------|----------|
| **Mon May 12** | Kick-off, architecture deep-dive, refine tickets, create epics |
| Tue May 13 | Spikes : OpenTelemetry auto-instrumentation, ML inference latency |
| Wed May 14 – Fri May 16 | Parallel delivery VEO-139, 140, initial UI skeleton VEO-142 |
| Mon May 19 | Mid-sprint review, load-test EventDetector (goal ≤200 ms) |
| Tue May 20 – Wed May 21 | Implement SmartPlaylist v2, Observability, Data Export |
| Thu May 22 | QA freeze, run E2E on staging, defect triage |
| **Fri May 23** | Sprint Review + Retro, release to production (feature-flag OFF by default) |

## 5. Definition of Done (DoD 2025 edition)
1. **Code Quality**: passes `flutter analyze`, `dart fix ‑-dry-run` returns zero, mutation score ≥ 75 %.
2. **Tests**: unit > 95 % critical paths, integration & golden tests for UI, contract tests using Pact.
3. **Security**: OWASP dependency check score A, no hard-coded secrets (trufflehog).
4. **Performance**: p95 latency targets met, verified in k6 CI job.
5. **Observability**: traces, logs, metrics auto-linked in CloudWatch & Grafana with SLO burn-down panel.
6. **Docs**: ADRs updated, public API documented in `specs/openapi.yaml`, guides in `docs/guides/`.
7. **Rollout**: feature-flagged, can be toggled per tenant, rollout plan in LaunchDarkly project.
8. **Accessibility**: WCAG 2.2 AA compliance checks automated (axe-ci).

## 6. Risks & Mitigations
| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| ML model latency > 200 ms on tablet | M | H | Tensor-RT quantization, async prefetch to Isolate. |
| Inaccurate event detection (precision <90 %) | M | H | Add synthetic data augmentation, daily retraining pipeline. |
| Supabase real-time limits (concurrent streams) | L | M | Fallback to WebSocket multiplexing, throttling strategy. |
| Flutter PWA offline cache corruption | L | M | Progressive rollouts + Sentry crashlytics alerts. |
| Team velocity drop due to holidays | M | M | Pair-program rotation, buffer 1 SP unallocated. |

---
© 2025 Video Engineering Org (VEO) – _Built with best practices & latest techniques 2025_