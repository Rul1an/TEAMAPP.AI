# Sprint 4 Plan ▸ Video Processing Extended (Phase-2b)

> Sprint window: **2025-07-29 → 2025-08-12**  
> Team: Video Feature Squad  
> Related: [Phase-2 Enhanced Plan](video_phase2_enhanced_plan.md), [VIDEO_FEATURE_ROADMAP](../../roadmaps/video/VIDEO_FEATURE_ROADMAP.md)

---

## 🎯 Sprint Goal
“Gebruikers zien automatisch gegenereerde thumbnails en kunnen de video direct terugkijken via een getekende LL-HLS-URL; opschoning & stabiliteit draaien volledig server-side.”

## 📝 Stories in Scope

| Ref | Titel | Ready? | DoD | Schatting |
|-----|-------|--------|-----|-----------|
| **VID-201** | **Edge-Function: thumbnails & metadata** | ✅ FFmpeg-wasm PoC | 3 thumbs + duration/codec in DB | 3 pd |
| **VID-202** | **Signed URL workflow** | ✅ Storage v2 API live | Playback URL 24h, IP-bind | 1 pd |
| **UI-090** | **Thumbnail-selector UI** | ✅ Design OK | User kan 1/3 thumb kiezen | 1.5 pd |
| **SEC-054** | **Signed URL rotation + leakage test** | ✅ QA script klaar | 0 leaks in OWASP scan | 1 pd |
| **OPS-072** | **Cleanup cron job (>48h tmp)** | ✅ Cron Edge template | Old *.tmp removed daily | 0.5 pd |
| **TST-045** | **Integration tests (upload→playback)** | ✅ Mock-signed URLs | 90 % pass | 2 pd |

_Total: 9 pd (Team capacity 9 pd)._  
_Buffer 1 pd (stretch: auto-ABR renditions)_

## 🔄 Definition of Done

1. Edge-Function genereert 3 PNG-thumbnails & metadata, record in `video_assets`.  
2. Complete-payload bevat `signedUrl`, `thumbs[3]`, `duration`.  
3. Flutter-UI toont thumbnails en laat gebruiker cover kiezen.  
4. Signed URL’s verlopen correct; leakage-scan groen.  
5. Dagelijkse cleanup job draait zonder errors (logs in Grafana).  
6. CI-pipeline groen + integratietest dekking ≥ 55 %.  
7. Sprint-review demo op iOS, Android & Web.

## 📈 Metrics

* P95 tijd _upload → playback_ < **65 s** (250 MB 1080p).  
* Storage waste (orphaned tmp) < **1 %**.  
* Crash-free sessions **> 99 %**.

## ⚠️ Risico’s & Mitigations

1. **FFmpeg-wasm CPU-footprint** → limit max file 500 MB, offload >500 MB to Q-farm.  
2. **Signed URL mis-config** → gated staging env + OWASP ZAP nightly.  
3. **Edge cold-start latency** → pre-warm via `edge-warm` scheduler.

## 📆 Dagelijks Werkplan

| Dag | Kernactiviteit |
|----|----------------|
| D1 | Edge-Function code, unit-tests |
| D2 | Storage webhook live, staging test  
| D3 | Flutter-UI thumbnail selector |
| D4 | Signed URL rotation & UX polish |
| D5 | Cleanup cron, logs, Grafana alert |
| D6 | Integration tests & hardening |
| D7 | Buffer / spill-over |
| D8 | Sprint-review & retro |

---
_Last updated: 15 Jul 2025_

## ✔️ Sprint Status (na dag 5)

| Story | Status |
|-------|--------|
| VID-201 | ✅ Edge-Function live (metadata + thumbs) |
| VID-202 | ✅ Signed URL refresh endpoint + Flutter timer |
| UI-090 | ✅ Thumbnail-selector UI implemented |
| SEC-054 | ✅ OWASP ZAP scan in CI; URL rotation done |
| OPS-072 | ✅ Cron cleanup function deployed |
| TST-045 | ➡️ To be done (Day 6) |

_Updated: 2025-08-03_