# Cleanup Phase – Repository Migration Finalisation (Q3 2025)

*Document version: 2025-07-11*

---

## 🎯 Objective
Remove remaining legacy *Service* layer usages, migrate to the **Repository pattern**, and reach **zero analyzer issues**.

## 🔍 Current Findings (11 Jul 2025)

| Legacy Service | Status | Replacement Needed |
|----------------|--------|--------------------|
| `club_service.dart` | Used by `club_provider.dart` | ✅ Create `ClubRepository` |
| `organization_service.dart` | Used by `organization_provider.dart` | ✅ Create `OrganizationRepository` |
| `permission_service.dart` | Used by RBAC demo + guards | ✅ Create `PermissionRepository` |
| `feature_service.dart` | Used by `subscription_provider.dart` | ✅ Create `FeatureRepository` |
| `auth_service.dart` | Still required for Supabase auth flows | ⏳ Keep (wrap later) |
| `database_service.dart` | Local Isar helper for *Local* repositories | 🔄 Replace with Hive where feasible |
| `import/export/pdf_service.dart` | Still valid (utility layer) | ✅ Keep |
| `monitoring_service.dart`, `telemetry_service.dart` | Placeholder observability | 📈 Integrate later |

Direct Supabase calls are **fully removed** from UI/providers (confirmed via grep). Remaining sources are confined to data-sources and auth service.

## 🌐 Best-Practice References (2025)
* VGV "Serviceless Flutter" whitepaper (2025Q1)
* Supabase **row-oriented cache** pattern – https://supabase.com/blog/offline-first-cache
* Riverpod 3 *RepositoryProvider* cookbook – riverpod.dev/docs/recipes/repository

## 🗺️ Milestones & Timeline
| ID | Deliverable | ETA |
|----|-------------|-----|
| C1 | Analysis & task list (this doc) | **Done** |
| C2 | `ClubRepository` (+ Hive cache) | 15 Jul |
| C3 | `OrganizationRepository` (+ Hive) | 17 Jul |
| C4 | `Permission` & `Feature` repositories | 19 Jul |
| C5 | Refactor Local* repos → Hive (remove `database_service.dart`) | 22 Jul |
| C6 | Delete obsolete service classes | 23 Jul |
| C7 | Analyzer 0-error verification + CI pass | 24 Jul |
| C8 | Docs & Roadmaps update | 25 Jul |

## ✅ Definition of Done
1. No imports from `lib/services/` inside providers or UI.
2. All data access flows through repositories.
3. `flutter analyze` returns **0 errors / warnings**.
4. Test suite green; coverage ≥ existing threshold.
5. Documentation updated.

---

## 📋 Task Breakdown (linked to TODO IDs)
1. **cleanup-analysis** – Confirm mapping of each legacy service.
2. **club-repo-migration** – Implement `ClubRepositoryImpl`, migrate provider, unit tests.
3. **org-repo-migration** – Same for organizations.
4. **permission-feature-repo** – Consolidate RBAC & feature-flag logic into repositories.
5. **local-repo-refactor** – Switch Local* repos from Isar helper to Hive encrypted boxes.
6. **service-deletion** – Remove `club_service.dart`, `organization_service.dart`, `permission_service.dart`, `feature_service.dart`.
7. **analyzer-clean** – Run formatter & analyzer; fix lints.
8. **docs-update-cleanup** – Update analysis map, architecture addendum, roadmap tables.

---

## 🔗 Dependencies / Risks
* Supabase RLS rules already multi-tenant; new repos must respect same policies.
* Hive 4 web cipher performance – benchmark on low-end Chromebooks.
* RBAC demo widget relies on `permission_service.dart`; ensure provider refactor does not break demo.

---

Ready to execute 🚀
