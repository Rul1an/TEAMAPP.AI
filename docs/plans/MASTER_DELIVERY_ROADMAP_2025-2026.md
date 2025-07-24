# JO17 Tactical Manager – Master Delivery Roadmap (2025-2026)

_Last updated: 2025-07-16_

## Guiding Principles (Best Practices 2025)
1. Clean Architecture (feature-first, repository layer, offline-first caches).
2. Automation-first → CI pipelines with lint/coverage/test gates (**CI Monitor** workflow).
3. Quality bar: 0 analyzer infos, `very_good_analysis`, code-metrics guard.
4. ≤ 300 LOC/source-file (excl. generated).
5. Observability built-in (analytics + error monitoring).
6. Progressive enhancement: Wasm web, Impeller, offline-first, AI-ready.

---

## Phase 0 – Foundation (✅ Completed Jul 2025)
| Key Result | Delivered |
|------------|-----------|
| Repository layer & Hive caches (Profiles → Players/Matches/Trainings) | Jul 2025 |
| Offline-first strategy validated | Jul 2025 |
| PDF Service modularised (Match, Player, Training generators) | Jul 2025 |
| Large File Refactors (< 300 LOC target) incl. PerformanceMonitoringScreen | Jul 2025 |
| CI Monitor workflow active – builds green | Jul 2025 |

---

## Phase 1 – Product Polish & Technical Debt (Q3 2025)
| ID | Deliverable | Owner | ETA |
|----|-------------|-------|-----|
| 1.1 | **Edit Training Screen** finalise CRUD flow | Frontend Guild | ✅ Completed Aug 2025 |
| 1.2 | **Heatmaps for team performance** | Analytics Guild | ✅ Completed Aug 2025 |
| 1.3 | Predictive analytics PoC (form prediction) | AI Squad | Aug Wk 4 |
| 1.4 | Import Match Schedules (CSV/XLS) | Import Guild | Sep Wk 1 |
| 1.5 | Import Training Plans | Import Guild | Sep Wk 2 |
| 1.6 | Bulk operations UI | Import Guild | Sep Wk 2 |
| 1.7 | Duplicate-detection on import (complete) | Import Guild | Sep Wk 2 |
| 1.8 | **UI Refinement (Slice 5)** – navigation merge, view-only gating, analytics observer | Front-end Guild | ✅ Completed Jul 24 |

Quality Gates: CI green; coverage ≥ 45 % (raised from 40 %); no file > 300 LOC.

---

## Phase 2 – Quality & Observability (Q4 2025)
### 2A Code Quality Upgrade
(see `CODE_QUALITY_UPGRADE_Q4_2025.md`)
| Task | ETA |
|------|-----|
| Adopt `very_good_analysis` + `dart_code_metrics` | Oct Wk 1-3 |
| Pre-commit hooks (`lefthook`) | Oct Wk 3 |
| Refactor remaining > 300 LOC files | Oct Wk 4 |
| `CODING_STANDARDS.md` workshop | Nov Wk 1 |

### 2B Analytics & Monitoring
(see `ANALYTICS_MONITORING_Q4_2025.md`)
| Task | ETA |
|------|-----|
| Define event schema & GDPR consent | Oct Wk 1 |
| Firebase Analytics integration | Oct Wk 2 |
| Sentry error/perf monitoring | Oct Wk 2 |
| Dashboards & team enablement | Oct Wk 4 |

Exit Criteria Phase 2: 0 lint infos; analytics events visible; Sentry capturing crashes; CI coverage ≥ 50 %.

---

## Phase 3 – Advanced Features (Q1 2026)
| Stream | Highlights |
|--------|------------|
| **Lineup 2.0** | Drag-&-drop builder, formation templates, tactical board |
| **Video Platform** | Upload + storage, compression, player, tagging |
| **Data Persistence** | Supabase sync, auth, multi-team tenants |
| **Monetisation Prep** | Freemium tiering, usage-based pricing hooks |

---

## Phase 4 – AI & Micro-SaaS (Q2 2026 → Q4 2026)
| Goal | Description |
|------|-------------|
| AI Training Assistant | GPT-powered session generation |
| Tactical AI Assistant | Real-time formation & substitution suggestions |
| Microservices Backend | Split domain services, event-driven bus |
| API Marketplace | External integrations (KNVB, wearables) |

---

## Rolling Risk Register
* **Lint adoption friction** – Mitigate via IDE-settings & pair-sessions.
* **GDPR/Privacy** – Legal review before production analytics.
* **Video storage costs** – Benchmark & adopt tiered quality.

---

## CI / Dev-Ex KPIs
| KPI | Target | Current (Jul 16) |
|-----|--------|------------------|
| Build success rate | ≥ 98 % | 100 % |
| Analyzer warnings | 0 | 0 |
| Test coverage | ≥ 50 % by Q4 | 42 % |
| Time-to-merge (median) | < 24 h | 18 h |

---

_This master roadmap consolidates all subordinate plans and will evolve each sprint. Updates are propagated via CI docs-workflow._
