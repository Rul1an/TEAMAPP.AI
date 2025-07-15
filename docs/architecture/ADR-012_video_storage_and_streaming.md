# ADR-012: Video Storage & Streaming Strategy

*Status: Proposed – 2025-07-15*

## Context

The **Video Feature Roadmap** (v1.0, Dec-2024) introduces upload, playback and later AI-analysis for match & training footage. We must pick a storage + delivery solution that aligns with our multi-tenant Supabase backend, keeps costs predictable (< €50 / 200 GB / mo) and meets UX-targets (start-playback < 3 s on 10 Mbps).

Short-listed options (2025 benchmarks):

| # | Option | Pros | Cons |
|---|--------|------|------|
| A | **Supabase Storage** (+ Edge Functions + HLS) | Same auth stack, RLS, CDN, pay-as-you-go.  | No built-in adaptive streaming; max file 2 GB per request |
| B | Firebase Storage + Cloudinary** | Robust transcoding, AI thumbnails | Two separate auth schemes; higher base cost; vendor-lock |
| C | Self-hosted S3 + Elastic Transcoder | Full control; cheapest at scale | Ops burden (24/7), deploy complexity |

## Decision

We **adopt Option A** – *Supabase Storage* with a dedicated `videos` bucket.  Adaptive streaming is achieved via **HLS transcoding** in Supabase Edge Functions using `ffmpeg_kit_flutter` & `fly-ffmpeg` containers.

Key points:

1. **Zero-context switch** – we already use Supabase auth/RLS; bucket inherits `org_id` policies.
2. **Predictable billing** – €25/100 GB tier is within coaching-club budgets.
3. **Edge Functions** (2025 Q2 GA) allow on-demand transcoding to 360p/720p renditions → minimal idle cost.
4. **Security** – signed URLs & PostgREST row policies prevent cross-tenant leaks (GDPR youth protection).

## Consequences

✔  Single SDK (`supabase_flutter`) for auth + storage + DB.  
✔  Chunked uploads (tus-resumable) supported as of v2.3.0.  
✔  Future AI stages can stream pre-signed S3-compat URLs to GPU workers.

✖  First-play latency depends on on-demand transcode (~4-10 s) until cache warm. We mitigate via nightly **“hot path pre-render” job** for recent matches.

✖  Max file 5 GB in dev tier – communicate constraint to coaches (break half-time). For >5 GB we will split uploads (Phase 2).

## Alternatives Considered

### Cloudinary via signed uploads
Rejected due to switching cost and complex per-minute pricing (>$89/mo for 100 GB HD with 3 transcoding presets).

### mux.com
Excellent developer DX but $20 per hour of processed video would exceed budget.

## Reference Implementation

* Edge Function: `transcode-to-hls.ts` (to be created)  
* Bucket policy: `storage_policies/videos_rls.sql`  
* Mobile chunked-upload: `VideoDataSource.upload()` – uses `SupabaseClient.storage.from('videos').uploadBinary(resumable: true)`.

## Related ADRs

* ADR-006: **File Storage Strategy** (avatars, documents)  
* ADR-009: **Supabase RLS Multi-Tenancy**