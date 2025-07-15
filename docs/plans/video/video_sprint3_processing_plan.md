# Sprint 3 Plan ▸ Video Processing Core (Phase-2a)

> Sprint window: **2025-07-15 → 2025-07-29**  
> Team: Video Feature Squad  
> Related: [Phase-2 Enhanced Plan](video_phase2_enhanced_plan.md), [VIDEO_FEATURE_ROADMAP](../../roadmaps/video/VIDEO_FEATURE_ROADMAP.md)

---

## 🎯 Sprint Goal
“End-users kunnen _sneller_ én _veiliger_ video’s uploaden dankzij device-side compressie, live verwerkings-feedback en een eerste test-suite voor regressie.”

## 📝 Stories in Scope

| Ref | Titel | Ready? | DoD | Opmerking |
|----|-------|-------|-----|-----------|
| **FLUT-102** | **Device-side pre-compress (Flutter)** | ✅ _All libs stable_ | Upload-tijd < 60 s bij 100 MB bron | UI wijzigt niet |
| **UI-089** | **Realtime status chip** toont _Queued → Processing → Complete_ | ✅ SignalR channels live | Status-update ≤ 1 s | Chip in VideoListItem |
| **TST-044** | **Unit & widget tests** voor upload flow | ✅ Mock-Supabase lib geverifieerd | CI ≥ 90 % pass  | 15 testcases |
| **OPS-071** | **Retry-queue bij upload-failure (S-02)** | ✅ Storage Hooks v0.7 live | Mislukte uploads worden max 3× geretry’d | Kritiek voor stabiliteit |

**Conclusie:** Alle drie stories zijn _Ready-for-Dev_ – afhankelijkheden (`video_compress 3.1.2`, `ffmpeg_kit_flutter 6.0.3`, Supabase Channels) zijn getest op Android 14 + iOS 17.

## 👷‍♀️ Sprint Backlog & Schattingen

| Dag | Taak | Story | Eigentijd |
|----|------|-------|-----------|
| D1 | Spike: benchmark compress-presets | FLUT-102 | 0.5 pd |
| D1-D2 | Implement Pre-compress util | FLUT-102 | 1.5 pd |
| D2 | Integreren in `UploadService` | FLUT-102 | 0.5 pd |
| D2 | QA manual test matrix | FLUT-102 | 0.5 pd |
| D3 | Supabase channel stream → provider | UI-089 | 0.5 pd |
| D3 | Chip component + theming | UI-089 | 0.5 pd |
| D3 | E2E happy-flow Cypress | UI-089 | 0.5 pd |
| D4 | Mock storage + upload tests | TST-044 | 1 pd |
| D4 | Implement Retry-queue logic (storage hook) | OPS-071 | 0.5 pd |
| D4 | QA scenario’s “offline / 4G drop” | OPS-071 | 0.5 pd |
| D5 | CI integration + coverage badge | TST-044 | 0.5 pd |
| D5 | Tech-debt: refactor `upload_bloc` | ‑ | 0.5 pd |

_Total: 7.5 person-days → capacity 9 pd (buffer 1.5 pd)._

## 🔄 Definition of Done

1. Build & tests green on main.  
2. Video upload < 60 s over 25 Mbps LTE.  
3. Status chip updates w/out manual refresh.  
4. Test coverage `> 55 %` lines for `feature_video_upload`.  
5. Docs & release notes updated.

## ⚠️ Risico’s & Mitigations

- ***Large native libs size (FFmpeg)*** → use min-preset, strip architectures.
- ***Channel disconnects*** → auto-reconnect exponential back-off.
- ***CI flakiness on macOS runners*** → fallback to Linux + video stub.

## 🧪 Test Matrix High-level

| Scenario | Android | iOS | Web |
|----------|---------|-----|-----|
| Upload 30 MB 1080p | ✅ | ✅ | ✅ |
| Upload 300 MB 4K | ✅ | ✅ | — Web warns file > 100 MB |
| Airplane-mode mid-upload | ✅ resume | ✅ resume | ⚠️ blocked |

## 📈 Metrics to Track

- _Average upload throughput_ after compress.  
- _Time-to-processing-complete_ (P95).  
- _CI pass %_.

## ▶️ Volgende Stap – _Sprint 4 Preview_

Fase-2b richt zich op **server-side thumbnail generatie, metadata extractie** en **signed URLs**. Zie `video_sprint4_processing_plan.md` (t.b.d.).

---
_Last updated: 15 Jul 2025_