# Sprint 5 Plan ▸ Veo Highlights Integration (Phase-3)

> Sprint window: **2025-08-12 → 2025-08-26**  
> Team: Video Feature Squad  
> Related: [Veo Assessment](veo_integration_assessment.md)

---

## 🎯 Sprint Goal
“Automatisch Veo-highlights in de app tonen, naadloos gemixt met eigen uploads en voorzien van dezelfde tagging & analyse capabilities.”

## 📝 Stories in Scope

| Ref | Titel | DoD | Schatting |
|-----|-------|-----|-----------|
| VEO-101 | GraphQL auth + fetch clip list | Clips JSON voor team/id | 1 pd |
| VEO-102 | Edge-Function ingest & pipeline reuse | Clip opgeslagen, processing broadcast | 1 pd |
| VEO-103 | UI tab ‘Veo Highlights’ + filter | Tab toont thumbs & player | 0.5 pd |
| VEO-104 | E2E test ingest→player | CI pass incl. mock Veo API | 0.5 pd |

_Total: 3 pd (buffer 1 pd)_

## 🔄 Definition of Done

1. Veo API key in env; ingest job haalt highlights ≤24 h oud.  
2. Highlights verschijnen in VideoUploadScreen onder aparte tab.  
3. Player & thumbnail UX identiek aan eigen uploads.  
4. All tests & ZAP scan groen.

## Risico’s
1. Veo API rate-limits → cache GraphQL response in KV.  
2. Licentie/ToS wijziging → feature-flag toggle.

---
_Last updated: 03 Aug 2025_