## Progress update (2025-08-02)

| Story | Description | Status |
|-------|-------------|--------|
| VEO-101 | Edge Function `veo_fetch_clips` – OAuth2 + GraphQL highlights list | ✅ Done |
| VEO-102 | Edge Function `veo_ingest_highlights` + DB table `veo_highlights` (migration) | ✅ Done |
| VEO-103 | Playback pipeline – storage sync + presigned URL via `veo_get_clip_url` | 🟡 In review |

### Next up
1. VEO-104 – Flutter widget `HighlightGallery` consuming `/rpc/veo_get_clip_url` per clip (SWR + lazy-loading thumbnails).
2. VEO-105 – Observability: OTLP traces for all VEO Edge calls via `OTEL_EXPORTER_OTLP_ENDPOINT`.
3. VEO-106 – CI integration tests with `edge-runtime` and mocked Veo API.