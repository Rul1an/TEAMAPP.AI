# Team Performance Heatmaps – Implementation Plan (Q3 2025)

_Issue: #29 – Phase 1 Master Roadmap_
_Last updated: 2025-07-16_

## 1. Background
Coaches need a quick, visual overview of pitch zones where the team is most/least active (passes, shots, ball recoveries, etc.). Heat-maps will be added to the **Performance Analytics** screen and optionally match detail. 2025 UI trends suggest animated, WebGL-backed maps for web/desktop and canvas-painted layers for mobile.

## 2. Functional Requirements
1. Render positional heatmaps for:
   * Overall team touches (default)
   * Offensive actions (shots, key passes)
   * Defensive actions (tackles, interceptions)
2. Time-frame filter: entire season, last 5 matches, single match.
3. Interactivity: tooltip with action count on tap/hover.
4. Works offline (data from Hive cache) & online (Supabase sync).
5. Performance: first paint < 150 ms on mid-tier Android.

## 3. Data & Architecture
* **Source**: `ActionEvent` table (x,y,actionType, matchId, timestamp).
* **Repository**: `AnalyticsRepository.getHeatMapData(range, type)` returns `List<ActionEvent>`.
* **Processing**: bin events into 30×20 grid → intensity matrix.
* **Rendering**:
  * Web/Desktop: `fl_chart/HeatMapChart` custom painter (WebGL optional later).
  * Mobile: Custom `CustomPainter` with colour gradient.
* **State**: Riverpod `HeatMapController` (AsyncNotifier) keeps matrix & filter state.

## 4. Work Breakdown
| ID | Task | Est. h | Owner | Depends |
|----|------|--------|-------|---------|
| H1 | Extend `AnalyticsRepository` with `getHeatMapData` | 3 | backend | — |
| H2 | Create `heat_map_controller.dart` (StateNotifier) | 2 | FE | H1 |
| H3 | Build `heat_map_painter.dart` (mobile) | 4 | FE | H2 |
| H4 | Web/Desktop painter optimisation (canvas) | 3 | FE | H3 |
| H5 | Integrate component in `PerformanceAnalyticsScreen` | 2 | FE | H3 |
| H6 | Filter UI (dropdown + date-range) | 2 | FE | H2 |
| H7 | Unit tests: binning algorithm | 1.5 | QA | H1 |
| H8 | Widget tests: controller ↔ painter | 2 | QA | H2-H3 |
| H9 | Docs & screenshots update | 1 | Docs | H5 |
| **Total** | **20.5 h** | — | — |

## 5. Acceptance Criteria
* Selecting filter updates heatmap <300 ms (cached data).
* Colours follow VGV-2025 accessibility palette (≥4.5 contrast).
* Works offline (Hive) and online (Supabase) seamlessly.
* Unit & widget tests pass; analyzer 0 issues.
* File sizes: painter <200 LOC, controller <120 LOC.

## 6. Risks & Mitigations
| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Large datasets slow binning | Medium | Medium | Use isolate & cache matrix per filter |
| Colour-blind accessibility | Medium | Low | Provide alternate palette toggle |
| WebGL not supported on some browsers | Low | Low | Fallback to Canvas |