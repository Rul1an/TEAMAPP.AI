## Repository Cache & Error Policy (2025)

Doel: uniforme strategie voor offline-first repositories (read-through cache, write-invalidate) en foutafhandeling (sealed Result) in JO17 Tactical Manager.

### Caching
- Read-through: op succes → cache write; op netwerkfout → cache read fallback.
- TTL per domein configureerbaar in cache-implementatie (zie `hive/*_cache.dart`).
- Invalidate op mutaties (create/update/delete) → volgende read haalt vers van remote.

### Errors
- Alle repo-methodes retourneren `Result<T>` (geen throws).
- Map IO/HTTP naar domein-fouten (`AppFailure` subtypes). UI toont humane boodschap.
- UI mag `isStale` tonen wanneer data uit cache komt.

### Concurrency & Consistency
- Mutaties: sequentieel per entity (vermijd write-write conflicten); optimistic UI toegestaan indien cache-inval.
- Background refresh: toegestaan via provider refresh; geen silent overwrites.

### Testen
- Unit: remote fail + cache hit ⇒ Success(list). Remote ok ⇒ cache write.
- Integration (optioneel): offline scenario’s, TTL expiry, invalidatiepad.

### Referenties
- `lib/repositories/**`, `lib/hive/**`, `lib/core/result.dart`

