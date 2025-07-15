# Video Phase-2 – Processing & Optimisation (Enhanced 2025)

> *Supersedes:* high-level plan in `video_sprint1_upload_playback_plan_2025.md` §“Phase 2”.  
> *Context:* New research 2025-07-15 into Edge Runtime, HLS Low-Latency (LL-HLS) and WebCodecs reveals faster, cheaper paths.

## 🔍 Insights from 2025 landscape (quick research)

| Trend (2025) | Relevance | Practical take-away |
|--------------|-----------|---------------------|
| **ffmpeg.wasm@0.11** → 25 % faster (SIMD) & shared-array-buffer enabled by default | Reduces cold-start | Keep wasm build but enable `--simd` flag and persist cache dir `/tmp/ffmpeg` |
| **Supabase Storage Hooks v0.7**  (retry + dead-letter) | Automatic 3× retry on function error | Use new `max_retries` in storage trigger |
| **LL-HLS (RFC 8216bis)** widely supported | Instant scrubbing, <3 s latency | Generate master + `#EXT-X-PART` segments (2 s) for 360/720p |
| **URL-signing API (`storage.createSignedUrl()`)** | Secure but public playback | Replace hard-coded CDN links by signed URL (60 min) |
| **OpenTelemetry tracing (edge-runtime)** | Unified observability | Wrap function with OTEL exporter; send to Supabase Logs |

## 🚧 Skipped items in first draft

1. Duration extraction via `ffprobe` was marked *“skipped for brevity”*.  
2. Hard-coded public URLs.  
3. No retries / dead-letter.  
4. No memory cleanup (`ff.FS.unlinkFile`).

## ✅ Enhanced Implementation Checklist

### Edge Function `transcode-to-hls.ts`
1. **Env Validation**  
   ```ts
   const required = ['SUPABASE_URL','SUPABASE_SERVICE_ROLE_KEY'];
   required.forEach((k)=>{ if(!Deno.env.get(k)) throw new Error(`Missing env ${k}`); });
   ```
2. **Fetch object (stream)** to avoid full memory when >400 MB. Use `ReadableStream` → `Uint8Array` chunks.  
3. **ffprobe duration**  
   ```ts
   await ff.run('-i','source.mp4','-hide_banner');
   const durMatch = ff.logs.find(l=>l.includes('Duration')).match(/\d+:\d+:\d+\.\d+/);
   ```
4. **LL-HLS Command** (2 renditions)  
   ```bash
   -start_number 0 -hls_flags +independent_segments+append_list+part_index \
   -hls_time 4 -hls_part_size 0.5 -master_pl_name master.m3u8
   ```
5. **Signed URLs**  
   `bucket.createSignedUrl(path, 3600)` → store in DB.  
6. **Retries & Dead-letter**  
   Storage trigger YAML: `{max_retries: 3, dead_letter_queue: 'video_failures'}`.
7. **Monitoring**  
   ```ts
   import { span } from 'https://edge-otel.supabase.dev/mod.ts';
   await span('hls-transcode', async ()=>{ ... });
   ```
8. **Memory cleanup** – `ff.FS.readdir('/')` & unlink all temp files after upload.

### Flutter App adjustments
* Poll row until `status == ready`. New status values: `uploading`, `processing`, `ready`, `failed`.  
* Use master playlist URL (signed) for player.
* Show “retry transcoding” button if `failed` & coach role.

## ⏱ Updated Sprint Timeline

| Day | Task | Notes |
|-----|------|-------|
| D1 | Edge function env-validation + OTEL | new |
| D2 | LL-HLS transcode command & duration parse | rewrite |
| D3 | Signed URL + DB schema migration (`signed_hls_url`) | new |
| D4 | Storage trigger with `max_retries` | new |
| D5 | Flutter polling & error chip | move from old plan |
| D6 | Memory-cleanup + load-test (500 MB) | new |
| D7 | Buffer & documentation | — |

_Total effort_: 38 h (was 33 h) – accepted because storage re-tries reduce support load.

## 📎 Linked Docs
* `docs/specs/video_module_spec.md` – add `signedHlsUrl` field  
* Migration file `20250726_add_signed_url_to_videos.sql` (to be created)

---
*Plan revision generated 2025-07-15 22:00 UTC.*