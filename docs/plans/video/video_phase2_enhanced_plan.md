# Video Phase-2 Enhanced Plan ▸ Processing & Optimization (Sprint 3-4)

> Document status: **Draft v1 – 2025-07-15**  
> Owner: Video Feature Team  
> Related docs: [VIDEO_FEATURE_ROADMAP](../../roadmaps/video/VIDEO_FEATURE_ROADMAP.md)

---

## 🎯 Doel
Breng de video-upload‐ervaring naar een professioneel niveau door compressie, optimalisatie en robuuste observability toe te voegen – zonder concessies te doen aan kwaliteit of privacy.

Phase-2 focust op _processing & optimisation_ en vult de basis-upload (Phase-1) aan met het volgende:

1. **Pre-compressie + adaptive bitrate** vóór upload.
2. **Backend-pipeline** voor thumbnails, metadata & CDN-ready streams.
3. **Realtime feedback** naar de gebruiker (status chips, progress events).
4. **Observability & kost-bewaking** via OTEL traces & metering.

## 🆕 2025-Technieken & Best-Practices

| Domein | Techniek | Waarom 2025-relevant? | Integratie-strategie |
| ------ | -------- | --------------------- | -------------------- |
| Streaming | **LL-HLS v1.1** (Low-Latency HLS) | < 2 s latency, breed ondersteund (Safari, Android 14) | Maak ABR renditions met `ffmpeg_kit_flutter`; serve via Supabase + Cloudflare CDN |
| Storage events | **Supabase Storage Hooks v0.7** | Native triggers bij `object.created` → geen extra infra | Lambda-achtige edge-functions starten FFmpeg jobs |
| Beveiliging | **Signed URLs RFC-v4 (2025)** | Finer-grained expiry & IP-binding | Genereer tijdens upload‐finalisatie; SDK support in `supabase_flutter` ≥ 2.4 |
| Observability | **OpenTelemetry (OTEL) 1.11** | End-to-end tracing incl. client, FFmpeg, edge | Add `opentelemetry_api` + `otlp_grpc` exporters |

## ⏩ Eerder _geskipped_ – nu terug op radar

| # | Punt | Reden skip | Nieuw commitment |
|---|------|------------|------------------|
| S-01 | Multi-thumbnail selectie | UI backlog vol | Sprint 4 opnemen |
| S-02 | Retry-queue bij upload-failure | Onvoldoende infra-hooks | Realiseren via Storage Hooks v0.7 |
| S-03 | Cleanup job oude renditions | Lage prioriteit | Cron Edge-Function Sprint 4 |

## ✅ Checklist Implementatie

- [ ] **Duratie-extractie** via `ffprobe` → DB kolom `duration`  
- [ ] **Pre-compress (Flutter)** met `video_compress` quality `Medium` (<50 MB/10 min)  
- [ ] **Edge-function**: generate **signed URL** (24 h) bij `PROCESSING_DONE`  
- [ ] **Retry-mechanisme** (3× exponential) tijdens upload  
- [ ] **Thumbnails (3x)** @ 1 %, 50 %, 90 %  
- [ ] **Status chip UI** met realtime Supabase channel  
- [ ] **OTEL traces** client↔edge↔storage  
- [ ] **Automated cleanup** orphaned tmp files > 48 h

## 🗓️ Tijdslijn & Effort (Sprint 3-4)

| Week | Thema | Stories | Schatting |
|------|-------|---------|-----------|
| 1 | Pre-compress & upload | FLUT-102, FLUT-103 | 3 pd |
| 1-2 | Edge FFmpeg jobs | VID-201 | 4 pd |
| 2 | Status chip + channels | UI-89 | 2 pd |
| 3 | Metadata extract + DB | VID-202 | 2 pd |
| 3-4 | Thumbnails + signed URLs | VID-203, SEC-54 | 4 pd |
| 4 | OTEL tracing + alerts | OBS-11 | 3 pd |
| 4 | Docs & hand-off | DOC-7 | 1 pd |

_Total: 19 person-days_

---

## 📌 Deliverables

1. **Gecomprimeerde uploads (<50 MB/10 min)**
2. **3 × thumbnails** gegenereerd on-upload
3. **Real-time processing chip** in upload-lijst
4. **Signed streaming URL** (LL-HLS) per rendition
5. **OTEL dashboard** in Grafana Cloud

---

_Last updated: 15 Jul 2025_