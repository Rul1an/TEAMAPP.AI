# Supabase – Video Storage Bucket Setup

> Follow these once per environment (dev / staging / prod). Time: ~2 min.

## 1. Create bucket `videos`

1. Open Supabase Dashboard → *Storage* → *Create bucket*  
2. **Name**: `videos`  
3. **Public bucket**: ❌ Disabled (keep private)  
4. Click **Create**.

## 2. Configure CORS (optional – Web uploads)

Add allowed origin: `https://app.jo17-manager.com` and local dev: `http://localhost:8080`.

## 3. Policies (RLS)

Paste & run the SQL from `supabase/migrations/2025071501_create_videos.sql` (section policies) if not already applied:

```sql
alter table public.videos enable row level security;
-- .. policies as in migration file
```

Bucket Policy (`storage.videos`):

```
-- Only owners (org_id) can upload/delete; everyone in org can read
create policy "videos_read_same_org" on storage.objects
  for select using ( ( auth.jwt()->>'org_id') = (bucket_id) );
```

## 4. Signed URL usage

App requests a **signed URL** (expires 60 min) instead of making bucket public.

```dart
final url = supabase.storage.from('videos').getPublicUrl(path, expiry: 3600);
```

## 5. Quota Alerts

Set usage alert in Billing → *Usage* → +Add Alert → Bucket storage >90 GB.

---
*Last updated: 2025-07-15*