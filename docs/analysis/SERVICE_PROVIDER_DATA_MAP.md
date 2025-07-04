# Service & Provider Data Map (Q3 2025)

_Last updated: **2025-07-11**_

This analysis inventories every data call inside `lib/services/` and `lib/providers/` as preparation for the Repository-Layer refactor.

---

## 1. Data Sources

| ID | Source | Type | Notes |
|----|--------|------|-------|
| S1 | Supabase REST / Realtime | Cloud | Auth, profiles, organizations, clubs, feature-flags, permissions |
| S2 | Supabase Storage | Cloud | Avatar uploads (`avatars` bucket) |
| S3 | Isar | Local | Offline persistence for teams / players / matches / etc. (Mobile/Desktop only) |
| S4 | In-Memory Lists | Local | Web & temporary storage when Isar not available |
| S5 | Filesystem | Local | Import/Export/PDF services (Excel/CSV/PDF) |
| S6 | TBD → Hive 4 | Local | Planned encrypted cache layer |

---

## 2. Service Catalogue

| Service | Layer | Key Methods | Primary Source(s) |
|---------|-------|-------------|-------------------|
| `auth_service.dart` | Auth | `signInWithEmail()`, `signOut()`, `authStateChanges` | S1 |
| `profile_repository.dart` | Repository | `getCurrent()`, `update()`, `uploadAvatar()` | S1, S2, S6 |
| `organization_service.dart` | Organization | `getOrganizations()`, `createOrganization()` … | S1 |
| `club_service.dart` | Club | CRUD on `clubs` | S1 |
| `permission_service.dart` | RBAC | `hasPermission()`, `fetchPermissions()` | S1 |
| `feature_service.dart` | Feature Flags | `isEnabled()`, `getVariant()` | S1 |
| `database_service.dart` | Offline DB | CRUD for teams / players / matches / etc. | S3 / S4 |
| `import_service.dart` | I/O | Excel/CSV import | S5 |
| `export_service.dart` | I/O | Excel/CSV/PDF export | S5 |
| `pdf_service.dart` | I/O | PDF generation utility | S5 |
| `monitoring_service.dart` | Observability | RUM + Sentry hooks | S1 (future), S6 |
| `demo_data_service.dart` | Demo | Generates seeded data for demo mode | Local |
| `match_repository.dart` | Repository | CRUD for `matches` (Supabase + Hive) | S1, S6 |
| `training_repository.dart` | Repository | CRUD for `trainings` (Supabase + Hive) | S1, S6 |
| `profile_service.dart` | Profile | `getCurrentProfile()`, `updateProfile()`, `uploadAvatar()` | S1, S2 |

_Backups (`*.bak`, `*.backup`) were ignored._

---

## 3. Provider → Service Mapping

| Provider | Consumed Services | Domain |
|----------|-------------------|--------|
| `auth_provider.dart` | AuthService | Auth |
| `organization_provider.dart` | OrganizationService | Org |
| `club_provider.dart` | ClubRepository, TeamRepository | Club |
| `players_provider.dart` | PlayerRepository | Football Data |
| `matches_provider.dart` | MatchRepository | Football Data |
| `trainings_provider.dart` | TrainingRepository | Football Data |
| `training_sessions_provider.dart` | TrainingSessionRepository | Football Data |
| `annual_planning_provider.dart` | PlanningRepository | Planning |
| `field_diagram_provider.dart` | FieldDiagramRepository | Training Design |
| `player_tracking_provider.dart` | PlayerTrackingRepository | Performance |
| `demo_mode_provider.dart` | DemoDataService | Demo |
| `subscription_provider.dart` | FeatureService | SaaS |
| `profile_provider.dart` | ProfileRepository | Profile |

---

## 4. Issues & Opportunities

1. **Tight Coupling (Resolved)** – Providers nu afhankelijk van abstracte **Repository interfaces** (e.g. `PlayerRepository`). Implementaties kunnen lokaal (Isar/Hive) of cloud (Supabase) zijn.
2. **Error Handling (Resolved)** – Sealed `Result<T>` utility toegevoegd (`lib/core/result.dart`).
3. **Offline Cache (Resolved)** – Hive 4 encrypted caches actief voor alle belangrijke domeinen.
4. **Observability** – `analytics_service.dart` placeholder; needs integration of RUM (web-vitals) & Sentry performance.

---

## 5. Next Steps

| ID | Task | Status |
|----|------|--------|
| R1 | _Repo Analysis_ (this document) | ✅ Completed |
| R2 | Design abstract repository interfaces | ✅ Completed |
| R3 | Implement `Result<T>` utility + tests | ✅ Completed |
| R4 | Configure `riverpod_generator` + `freezed` | ✅ Completed |
| R5 | Implement Hive encrypted cache | ✅ Completed |

_Internal link: see `docs/plans/architecture/REPOSITORY_LAYER_REFRACTOR_Q3_2025.md` for the full roadmap._
