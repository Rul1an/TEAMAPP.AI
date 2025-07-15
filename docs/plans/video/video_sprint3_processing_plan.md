# Sprint 3 – Video Processing & Optimisation  (17-07 → 31-07-2025)

> Parent Epic: `VIDEO_PHASE2` – see `video_phase2_enhanced_plan.md`.
>
> Goal: automatische transcodering (LL-HLS), thumbnail, duur-metadata & signed streaming-URL binnen 2 min na upload.

## Back-log & Deliverables

| Nr | Story | Definition-of-Done |
|----|-------|--------------------|
| S3-01 | Edge Function hardening  | • Env-validation + OTEL tracing  <br>• Streams object (no full mem)  <br>• Duration parsed  <br>• Generates LL-HLS master + 2 renditions  <br>• Cleans tmp files |
| S3-02 | Signed HLS URL in DB | Column `signed_hls_url` nullable; row updated by EF; expires 60 min (renew strategy TBD) |
| S3-03 | Storage trigger (retry) | `max_retries:3` + `dead_letter_queue: video_failures` in `supabase/functions.yaml` |
| S3-04 | Flutter polling & chips | `Video.status` enum uitgebreid; Grid toont ⏳ / ❌; auto-refresh every 5 s |
| S3-05 | Retry UI | Coach kan “Transcoding opnieuw” → calls RPC `retry_transcode(video_id)` |
| S3-06 | Pre-upload compress | Mobile: `video_compress` MediumQuality when not Wi-Fi & battery >30 % |
| S3-07 | Load-test & metrics | 500 MB file <90 s; OTEL spans exported & visible |

## Tasks & Estimates

| Dag | Owner | Task | h |
|----|-------|------|---|
| D1 | DevOps | EF env-validation + OTEL scaffold | 4 |
| D1 | FE | Status enum & model migration | 2 |
| D2 | DevOps | Implement LL-HLS command + duration parse | 6 |
| D3 | DevOps | Signed URL generation + DB migration | 5 |
| D3 | DevOps | Storage trigger YAML w/ retries | 2 |
| D4 | FE | Polling service & UI chips | 4 |
| D4 | FE | Retry RPC function + button | 3 |
| D5 | FE | Mobile pre-compress wrapper | 4 |
| D6 | QA | Load-test script + metrics validation | 4 |
| D7 | – | Buffer / bug-fix / docs | 4 |
| **Totaal** | | | **38 h** |

## Schema-wijzigingen

```sql
alter table public.videos
  add column if not exists signed_hls_url text;
```

## Column‐updates (Edge Function)

```ts
await supabase.from('videos').update({
  video_url: null,
  signed_hls_url: signedUrl,
  thumbnail_url: thumbUrl,
  duration,
  status: 'ready',
}).eq('id', id);
```

## CI/QA
* Unit-test: parseDuration util (HH:MM:SS.xx → sec).  
* Integration-test uploads `sample_25mb.mp4`, waits until status = ready, asserts `signed_hls_url` not null.

---
*Plan aangemaakt: 2025-07-15 22:15 UTC*