# 🎬 Video Platform – Sprint 9 Plan (Tagging & Categorisatie)

_Last updated: 2025-07-16_

## 1. Sprint Goal
Implementeer **geavanceerde tagging & categorisatie** zodat coaches en spelers snel belangrijke momenten kunnen vinden en delen. Richt availabilty blijft ≥ 99,95 % met volledige observability & test-coverage (45 %→50 %).

## 2. Alignment met Best Practices 2025
| # | Best Practice 2025 | Sprint 9-toepassing |
|---|--------------------|---------------------|
| 1 | **Clean Architecture** | Nieuwe Tag-feature in eigen package `features/video_tagging/` met repository > datasource > provider. |
| 2 | **Automation-first** | Lint & coverage gates uitgebreid naar nieuwe code; UI & e2e tests verplicht in PR. |
| 3 | **Quality bar 0 infos** | `very_good_analysis` + `dart_code_metrics` enforced; Tag-model ≤300 LOC. |
| 4 | **Observability built-in** | Custom events `video_tag_added`, `playlist_generated`; Grafana dashboard + SLO (p95 tagging latency < 500 ms). |
| 5 | **Progressive enhancement** | Tagging werkt offline (Hive cache) en synct bij reconnect. |
| 6 | **AI-ready** | Tags opgeslagen in vector-friendly schema (pre-work voor auto-highlights). |

## 3. Backlog & Deliverables
| Story ID | Week | Ptn | Deliverable | Owner | Status |
|----------|------|-----|-------------|--------|--------|
| **VEO-131** | 1 | 5 | Tag-domain models (`VideoTag`, `TagType`) + repository | Backend | ✅ Done |
| **VEO-132** | 1 | 4 | Tag-editor UI (timestamp picker, player select) | Frontend | ✅ Done |
| **VEO-133** | 1 | 3 | Supabase RPC `insert_tag` + Postgres GIN index | DB | ✅ Done |
| **VEO-134** | 2 | 4 | Search & Filter screen (tags, date, player) | Frontend | ✅ Done |
| **VEO-135** | 2 | 3 | Smart Playlists generator (per speler, highlights) | Backend | ✅ Done |
| **VEO-136** | 2 | 2 | GraphQL subscription for real-time tag updates | Platform | ✅ Done |
| **VEO-137** | 3 | 4 | Analytics events + Grafana dashboard | Observability | ✅ Done |
| **VEO-138** | 3 | 3 | E2E tests (Web/iOS/Android) – tagging flow | QA | ✅ Done |

_Totaal story-punten: 28_

## 4. Tijdlijn
```
Week 1 │■■■□□ Setup & Core (VEO-131 … 133)
Week 2 │■■■□□ UX & Smartness (VEO-134 … 136)
Week 3 │■■■■■ Done (VEO-137 … 138)
```

## 5. Definition of Done (DoD)
1. Tag-editor werkt online & offline; sync conflicts resolved.  
2. Search & Filter tonen resultaten < 300 ms p95.  
3. Dashboard `video-tagging` live met 2 SLO-widgets.  
4. CI groene balk; test-coverage ≥ 50 %.  
5. Geen analyzer warnings; alle files ≤ 300 LOC.

## 6. Open Risico’s
* Supabase RPC latency kan variëren – monitor & eventueel edge-function cache.  
* Mobile UX (timestamp scrub) vereist precieze touch-handling → usability tests in week 2.

---
_Sprint start: 2025-07-17 – einde: 2025-08-06_