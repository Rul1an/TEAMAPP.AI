# VEO-106 • Edge-runtime Integration Tests

Deze handleiding beschrijft **stap voor stap** hoe je lokaal (of in CI) end-to-end tests draait voor de Veo-edge-pipeline.  
Het doel is om automatisch te verifiëren dat de drie Edge-functions samenwerken én dat OTLP-traces & ‑metrics correct worden weggeschreven.

## TL;DR
```bash
# Eénmalig (lokaal) – **volledig geautomatiseerd**
./scripts/dev/start_otel_stack.sh   # start OTEL collector (Docker)
./scripts/dev/start_supabase.sh     # start Postgres+Storage (Docker)

# Edge-runtime + tests (package.json script aanwezig)
npm run edge:start &                # ↳ edge runtime (port 8787) – stop met Ctrl-C
npm run test:e2e                    # ↳ Deno test suite met OTEL enabled
```

> ℹ️  Alle Docker-containers worden automatisch gestopt door `docker compose down`.

---

## 1. Vereisten

| Tool | Minimum versie | Opmerking |
|------|----------------|-----------|
| Docker | 24.x | Nodig voor Postgres & Grafana LGTM stack |
| Node  | 20.x | Voor `supabase-edge-runtime` & test tooling |
| Deno  | 1.41 (incl. `--unstable-otel`) | Wordt in CI geïnstalleerd via `deno install` |
| supabase-cli | v1.152+ | Voor lokale database & edge-runtime |

## 2. Repository-setup

1. **Install dependencies**
   ```bash
   npm ci   # node tools voor edge-runtime bootstrap
   flutter pub get  # (optioneel) – mobile app deps
   ```

2. **Nieuwe scripts** (`package.json`)
   ```jsonc
   "scripts": {
     "edge:start": "supabase-edge-runtime serve --no-verify-jwt --port 8787 supabase/edge_functions",
     "test:e2e": "deno task test:e2e"
   }
   ```
   > Het commando `deno task test:e2e` is gedefinieerd in `deno.json` en start de volledige test-suite.

3. **Edge-function refactor** – iedere file exporteert nu zijn handler:
   ```ts
   // veo_fetch_clips.ts
   export async function handler(req: Request) { ... }
   serve(handler);
   ```
   Idem voor `veo_ingest_highlights.ts` & `veo_get_clip_url.ts`.

## 3. OTEL-collector (Grafana LGTM stack)

De snelste manier is de kant-en-klare Docker-image van Grafana:
```bash
docker run --name lgtm -p 3000:3000 -p 4317:4317 -p 4318:4318 \
  --rm -d grafana/otel-lgtm:0.8.1
```

* Tempo (traces)  → `http://localhost:4318/v1/traces`
* Prometheus (metrics) → `http://localhost:4318/v1/metrics`
* Loki (logs) → `http://localhost:4318/v1/logs`

> 📓  Vergeet niet **OTEL_DENO=true** en **OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318** te zetten als je lokaal draait.

## 4. Supabase-stack lokaal

1. **Start database + storage**
   ```bash
   supabase start db --shadow false
   ```
2. **Apply migrations** (wordt normaal al gedaan door `supabase start`, maar kan handmatig):
   ```bash
   supabase db reset --force
   supabase db push
   ```
3. **Edge-runtime** (Node-compat layer):
   ```bash
   npm run edge:start
   # Luistert op :8787 – de tests sturen hier hun requests naartoe
   ```

## 5. Tests draaien

### 5.1 Test-structuur
```
supabase/edge_functions/_tests/
 ├─ veo_pipeline_test.ts      # Happy path ingest → playback
 ├─ auth_error_test.ts        # 401 flow
 └─ gql_failure_test.ts       # GraphQL foutpad
```

Elke test importeert de handlers direct voor unit-niveau checks èn voert een **HTTP round-trip** uit tegen de lokale runtime voor E2E.

### 5.2 Start tests
```bash
# Alles-in-één helper (package.json)
npm run test:e2e
```
Als je handmatig wilt draaien:
```bash
OTEL_DENO=true OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318 \
  deno test -A supabase/edge_functions/_tests --unstable-otel
```

> ⚠️  **Ingest & DB-verificatie**: de huidige test-suite dekt enkel `veo_fetch_clips` (happy path).  
> Uitbreiding naar `veo_ingest_highlights` + Prometheus queries staat open als TODO – zie sectie *Nog te doen* onderaan.

## 6. CI-setup (GitHub Actions-fragment)

```yaml
jobs:
  integration:
    runs-on: ubuntu-latest
    services:
      lgtm:
        image: grafana/otel-lgtm:0.8.1
        ports: [ "4318:4318", "3000:3000" ]
    steps:
      - uses: actions/checkout@v4
      - uses: denoland/setup-deno@v1
        with:
          deno-version: v1.x
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - name: Start Supabase
        run: supabase start db --shadow false &
      - name: Run Edge runtime
        run: npm run edge:start &
      - name: Run tests
        run: |
          export OTEL_DENO=true
          export OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318
          deno test -A supabase/edge_functions/_tests --unstable-otel
```

## 7. Handmatige stappen voor dev-machines

1. **Docker Desktop** – zorg dat “file sharing” actief is zodat Supabase data-volumes kunnen mounten.
2. **Grafana dashboards** – importeer `./docs/grafana/veo_edge.json` voor kant-en-klare panels.
3. **Tempo retention** – standaard maar 1 h; verhoog indien gewenst via `lgtm/data/grafana/tempo.yaml`.
4. **Port conflicts** – gebruik `.env` om alternatieve poorten te mappen (LGTM, Supabase, Edge runtime).
5. **Cleanup** – `docker ps -q | xargs docker stop` verwijdert alle test-containers.

---

> **Resultaat**: bij elke Pull Request draait een volledige ingest-flow, inclusief observability-verificaties.  
> Developers kunnen lokaal dezelfde workflow draaien met `npm run test:e2e` en de grafana UI live bekijken op `http://localhost:3000`.

---

### Nog te doen

* 🟡  E2E-tests voor `veo_ingest_highlights` en `veo_get_clip_url` – vereisen Mock Supabase API of test-database seeding.
* 🟡  Tempo API-queries in tests (verifiëren traces) – voorbeeldstub in `supabase/edge_functions/_tests/otel_assert.ts` **(nog aan te maken)**.
* 🟡  Dashboard-import automatiseren via Grafana API.