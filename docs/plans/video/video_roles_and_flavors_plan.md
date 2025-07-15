# Video Feature – Role & Flavor Matrix (linked to Sprint 1-4 roadmap)

> **Doc ID:** VIDEO_ROLES_FLAVORS_2025  
> **Relates to:** `docs/plans/video/video_sprint1_upload_playback_plan_2025.md`

## 1. SaaS Rollen & Kernbehoeftes

| Rol | Hoofd-doel | Must-Have Video Features (MVP) | Nice-to-Have (Phase 3+) |
|-----|-----------|--------------------------------|-------------------------|
| **Coach** | Training & wedstrijdanalyse | • Upload full-match/training clips  
• Tijdsgebonden tags  
• Speler-taggen  
• Deelbare playlists naar spelers | • Analyse-tools (teken, slow-mo)  
• AI highlights  
• Heatmaps uit video |
| **Analist** | Diepe performance-analyse | • Alle coach features + bulk-upload  
• Export tags naar CSV | • Batch AI processing  
• API-access (export JSON) |
| **Speler** | Eigen ontwikkeling | • Browse toegewezen video’s  
• Persoonlijke highlights  
• Reageren/liken | • Annotaties toevoegen  
• Compare ‘voor/na’ |
| **Ouder/Fan** | Passief consumptie | • Read-only highlights  
• Privacy-filtered (geen gevoelige tags) | • Commentaarfunctie beperkt |
| **Admin** | Beheer storage & access | • Bucket quota overzicht  
• RLS policies audit tools | • Retentie-beleid (auto-delete > 2 jr) |

## 2. App Flavors

| Flavor | Target rolgroep | Enabled Video Features | Disabled |
|--------|-----------------|------------------------|----------|
| `coach_suite` (default) | Coach + Analist + Speler | Alle MVP features | – |
| `fan_family` (light) | Fan/Ouder | Alleen read-only playback van **public** playlists (status = `public_highlight`) | Upload, Tagging, Analyse |

### Implementation Notes
* Flavors zijn al opgezet in existing `main.dart` via `dart-define FLAVOR`.  
* Gebruik **feature flags** (`FeatureRepository`) om runtime capabilities te togglen per rol+flavor.

```dart
final canUpload = flags.has('video_upload') && user.role.can('upload_video');
```

Mapping tabel wordt bij app-start geladen uit Supabase tabel `feature_flags`.

## 3. Aanpassingen op Sprint-planning

| Sprint | Extra issue | Owner | Est. |
|--------|-------------|-------|------|
| S1 | Data-model: `visibility` enum {private, org, public_highlight} | FE Guild | +2h |
| S1 | Flag seeding script (`video_upload`, `video_tagging`, `video_analytics`) | DevOps | +2h |
| S2 | UI gating in `VideoUploadButton` & `VideoGridScreen` | FE Guild | +3h |
| S2 | Fan flavor route filter → toon alleen `visibility = public_highlight` | FE Guild | +2h |
| S3 | Role-based action buttons (edit/delete) in `VideoDetailScreen` | FE Guild | +4h |
| S4 | Admin dashboard card “Video Storage Usage” | FE Guild | +3h |

## 4. Minimale Code-wijzigingen
* `Video` model → add `visibility` + `allowedRoles` (list).  
* Extend Supabase RLS: `visibility = 'public_highlight' OR org_id = auth.jwt()->>'org_id'`.
* Update queries in `SupabaseVideoDataSource` (`_toRow`).

```dart
'visibility': visibility.name,
'allowed_roles': allowedRoles,
```

## 5. Security & Privacy
1. **Jeugdprivacy**: fan-flavor ziet alleen clips zonder identificerende metadata.  
2. **RLS** garandeert dat spelers enkel eigen organisatie-video’s zien.  
3. **Download** endpoint beperkt tot Coach/Analist.

---
*Laatste update: 2025-07-15*