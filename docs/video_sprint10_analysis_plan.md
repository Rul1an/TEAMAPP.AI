# 🛠️ Video Platform – Sprint 10 Plan (Analyse Tools & Offline Caching)

_Last updated: 2025-07-16_

## 1. Sprint Goal
Lever een **eerste pakket geavanceerde video-analyse-tools** (tekenlaag, slow-motion, frame-by-frame) én **offline caching** voor mobiele gebruikers zodat sessies zonder netwerk volledig ondersteund zijn. Availability ≥ 99,95 % en test-coverage stijgt van 50 → 55 %.

## 2. Alignment met Best Practices 2025
| # | Best Practice 2025 | Sprint-toepassing |
|---|--------------------|------------------|
| 1 | **Clean Architecture** | Analyse-toolkit in package `features/video_analysis/`; UI ↔︎ ViewModel ↔︎ Service layers. |
| 2 | **Automation-first** | Lint, coverage & Lighthouse gates uitgebreid naar nieuwe code; Golden-tests verplicht voor Canvas-overlays. |
| 3 | **Quality bar 0 infos** | `very_good_analysis` & `dart_code_metrics` enforced; overlay widgets ≤300 LOC. |
| 4 | **Observability built-in** | Events `analysis_tool_used`, `offline_cache_hit`; p95 analysis-latency < 200 ms dashboard. |
| 5 | **Progressive enhancement** | Offline-first caching via `cached_video_player`; tools degraderen elegant bij lage CPU / fps. |
| 6 | **Performance-ready** | Impeller & Skwasm rendering paths profiled; WebAssembly SIMD flags enabled.

## 3. Backlog & Deliverables
| Story ID | Week | Ptn | Deliverable | Owner | Status |
|----------|------|-----|-------------|--------|--------|
| **VEO-139** | 1 | 5 | Canvas-overlay service (lines, circles, freehand) | Frontend | ⏳ Planned |
| **VEO-140** | 1 | 4 | Slow-motion / frame-by-frame controls (0.25× – 2×) | Frontend | ⏳ Planned |
| **VEO-141** | 1 | 3 | Offline caching PoC (`cached_video_player`) | Platform | ⏳ Planned |
| **VEO-142** | 2 | 4 | UX polish + gesture support (mobile) | UX Guild | ⏳ Planned |
| **VEO-143** | 2 | 3 | Analysis events → Firebase + CW Metrics | Observability | ⏳ Planned |
| **VEO-144** | 2 | 2 | CloudWatch dashboard p95 analysis-latency | Observability | ⏳ Planned |
| **VEO-145** | 3 | 4 | Golden / widget tests for overlay toolkit | QA | ⏳ Planned |
| **VEO-146** | 3 | 3 | E2E offline playback tests (Web/iOS/Android) | QA | ⏳ Planned |

_Totaal story-punten: 28_

## 4. Tijdlijn
```
Week 1 │■■■□□ Core Tools & Caching (VEO-139 … 141)
Week 2 │■■■□□ UX + Observability (VEO-142 … 144)
Week 3 │■■■□□ Tests & Hardening (VEO-145 … 146)
```

## 5. Definition of Done (DoD)
1. Overlay-toolkit ondersteunt tekenen & verwijderen op alle platformen.  
2. Slow-motion & frame-step controls werken tot 0.25× zonder dropped frames.  
3. Offline-cache hit-ratio ≥ 80 % in simulatietest (30 min flight-mode).  
4. Dashboard `video-analysis` toont p95 analyse-latency < 200 ms.  
5. CI groen; coverage ≥ 55 %; 0 analyzer infos.

## 6. Open Risico’s
* Canvas-overlay kan performance beïnvloeden op older iOS-devices → profile & fallback.  
* DRM-beperkingen bij offline caching; legale check gepland week 1.

---
_Sprint start: 2025-07-17 – einde: 2025-08-07_