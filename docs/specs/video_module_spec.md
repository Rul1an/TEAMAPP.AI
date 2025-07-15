# Video Module – Technical Specification (v0.1, 2025-07-15)

## 1. Scope
Defines the **data contracts, DB schema, storage layout, API surface and UI contracts** for *Phase 1* (Upload & Playback) of the Video Feature.

## 2. Data Model (Dart)

```dart
class Video {
  final String id;            // uuid-v4
  final String title;
  final String? description;
  final VideoType type;       // enum
  final String uploadedBy;    // user_id
  final DateTime uploadedAt;

  // Storage
  final String videoUrl;      // signed URL (expires)
  final String? thumbnailUrl; // 320x180 JPEG
  final int fileSize;         // bytes
  final int duration;         // seconds

  // Processing
  final ProcessingStatus status; // UPLOADING, READY, FAILED, TRANSCODING
  final Map<String, dynamic>? metadata; // exif, codec, resolution

  // Relations (nullable until later phases)
  final String? matchId;
  final String? trainingId;

  const Video({...});
  factory Video.fromJson(Map<String,dynamic> json) => ...;
  Map<String,dynamic> toJson() => ...;
}
```

### Enums
```dart
enum VideoType { match, training, highlight, tutorial }
enum ProcessingStatus { uploading, ready, failed, transcoding }
```

## 3. Supabase DB Schema (DDL excerpt)

```sql
create table public.videos (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organisations(id) on delete cascade,
  title text not null,
  description text,
  type text check (type in ('match','training','highlight','tutorial')),
  uploaded_by uuid not null references auth.users(id),
  uploaded_at timestamptz default now(),
  video_url text not null,
  thumbnail_url text,
  file_size bigint not null,
  duration integer not null,
  status text check (status in ('uploading','ready','failed','transcoding')) default 'uploading',
  metadata jsonb
);

alter table public.videos enable row level security;
create policy "org_isolation" on public.videos
  for all using (org_id = auth.uid())
  with check (org_id = auth.uid());
```

## 4. Storage Layout

```
/videos
  └─ {org_id}/
        └─ {video_id}/
              ├─ source.mp4
              ├─ thumb.jpg
              └─ hls/
                  ├─ index.m3u8
                  ├─ 360p_000.ts
                  └─ 720p_000.ts
```

* Upload Phase 1 saves only `source.mp4`. An Edge Function triggers **thumbnail generation** (frame at 25 s) via FFmpeg and updates `thumbnail_url`.

## 5. API Surface (Repository)

```dart
abstract interface class VideoRepository {
  Future<Video> upload({
    required io.File file,
    required String title,
    String? description,
    VideoType type = VideoType.match,
  });

  Stream<List<Video>> watchAll();

  Future<Video> getById(String id);
}
```

## 6. UI Contracts

| Widget | Props | Description |
|--------|-------|-------------|
| `VideoUploadButton` | `onUploaded(Video)` | FAB / toolbar action opens picker, shows progress bar (overlay) |
| `VideoCard` | `video: Video` | 16:9 thumbnail, title, badge (type) |
| `VideoDetailScreen` | `videoId` | Displays `Chewie` player and metadata sheet |

### Accessibility
* All controls reachable with `TalkBack` / `VoiceOver` – labels required.
* Contrast ratio ≥ 4.5:1 for text over thumbnail overlays.

## 7. Testing Strategy

| Layer | Tooling | Responsibility |
|-------|---------|---------------|
| Unit | `flutter_test` | Model (JSON), Repository mocks |
| Widget | `golden_toolkit` | `VideoCard` light/dark modes |
| Integration | `integration_test` | Upload 5 MB sample, expect status → READY |
| E2E (web) | `cypress` (*) | Smoke: upload & playback on Chrome |

*(*) Handled in Sprint 4 ‘Deployment Hardening’ plan.*

## 8. Performance Budgets (2025 targets)

| Metric | Budget | Rationale |
|--------|--------|-----------|
| Upload time | ≤ 2 min per 1 GB on 50 Mbps uplink | Coach Wi-Fi |
| First frame | ≤ 2.5 s on 10 Mbps | Competitive with YouTube |
| Memory | < 150 MB additional on 4 GB Android | Prevent OOM |

## 9. Open Questions

1. Do we enforce aspect-ratio (16:9) during upload or accept vertical footage?  
2. Where to store AI-generated tags (Phase 3)? Separate table vs JSONB column.

## 10. References & Best Practices 2025

* **OWASP Mobile Security Testing Guide – Flutter appendix (v1.3)**
* **Google “Smooth Streaming for Flutter” white-paper (I/O 2025)**
* **Supabase Edge Functions – FFmpeg Recipes collection (2025-05)**