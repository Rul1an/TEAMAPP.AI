# Predictive Analytics PoC – Form Prediction (Q3 2025)

_Issue: #30 – Phase 1 Master Roadmap_
_Last updated: 2025-07-17_

## 1. Objective
Deliver a proof-of-concept model that predicts team “form” (expected performance trend) for the upcoming match based on historical ratings, training intensity, and fatigue indicators.

Form output: 🔼 improving • ➡️ stable • 🔽 declining.

## 2. High-Level Approach (Best Practices 2025)
1. ML-ready dataset built on-device (privacy) using `ml_lite`.
2. Lightweight GradBoost model trained offline & bundled as asset (≈30 KB).  
   * Fallback: rule-based heuristic if model asset unavailable.
3. Inference isolated in a Dart `Isolate` to keep UI responsive.
4. Repository pattern ➜ `PredictionRepository.predictForm(teamId)` returns `Result<FormTrend>`.
5. Riverpod `FormPredictionController` exposes async state to UI.

## 3. Data Features
| Feature | Source |
|---------|--------|
| Avg. player rating last 3 matches | `MatchRepository` + ratings |
| Training attendance % last 2 weeks | `TrainingRepository` |
| Training intensity avg last 2 wks | `TrainingRepository` |
| Win/Draw/Loss streak (±2) | `MatchRepository` |
| Injury count | `PlayersRepository` status |
| Days rest since last match | Matches |

## 4. Work Breakdown
| ID | Task | Est. h | Owner | Depends |
|----|------|--------|-------|---------|
| P1 | Export dataset script → CSV | 3 | data-eng | — |
| P2 | Train GradientBoost model (Python) | 4 | data-eng | P1 |
| P3 | Convert model → tflite & bundle in `assets/models/` | 2 | data-eng | P2 |
| P4 | Dart wrapper `lib/ml/form_predictor.dart` using `tflite_flutter` | 3 | FE | P3 |
| P5 | `PredictionRepository` interface + impl | 2 | FE | P4 |
| P6 | `FormPredictionController` (AsyncNotifier) | 1 | FE | P5 |
| P7 | Add form badge to `DashboardScreen` | 1 | FE | P6 |
| P8 | Unit test: mapping features vector | 1 | QA | P4 |
| P9 | Widget test: badge states | 1 | QA | P7 |
| P10 | Docs & screenshots | 0.5 | Docs | P7 |
| **Total** | **18.5 h** | — | — |

## 5. Acceptance Criteria
* Model inference <50 ms on mid-tier phone.
* Form badge visible on dashboard with 🔼 ⟂ 🔽 icons.
* Heuristic fallback produces same classification ±1.
* Tests green; analyzer 0 issues.

## 6. Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| Model asset loading on Web (CORS) | Medium | Serve via assets/ and precache; fallback heuristic |
| Over-fitting small dataset | Medium | k-fold CV, early stopping |
| tflite_flutter size bloat | Low | Use selective import, tree-shaking |

---
_Next action: create PredictionRepository interface + empty impl & controller stubs so UI work can begin while model training proceeds._