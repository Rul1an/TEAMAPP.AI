# Manual QA & Release Checklist – Sprint 1 Import Phase

> *Generated automatically on 2025-07-15 – items below vereisen handmatige actie buiten CI/CD pipelines.*

## 1. Environment Preparation

1.1 Zet geldige **Supabase-staging** secrets in je shell of CI-omgeving.
```bash
export SUPABASE_URL="https://xyzcompany.supabase.co"
export SUPABASE_ANON_KEY="<anon-key>"
```
1.2 Controleer dat `ENV=staging` door de app/config gelezen wordt.

## 2. Volledige E2E-regressiesuite (Staging)

```bash
flutter test --coverage \
  --dart-define=ENV=staging \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
```
* Verwacht: exit-code 0 en **coverage ≥ 40 %**.
* Upload `coverage/html/index.html` als artefact als je buiten CI draait.

## 3. Handmatige QA-checklist

| # | Scenario | Verwacht resultaat |
|---|----------|-------------------|
| 1 | Upload CSV > 100 records | Preview toont correcte kleuren (groen/ geel/ rood) |
| 2 | Dubbele spelers | Gele markering; geen dubbele opslag na bevestigen |
| 3 | Foutieve rijen | Rode markering met foutmelding |
| 4 | Offline-modus | Dashboard/Planner laden cached data zonder crash |
| 5 | PDFs genereren | Geen runtime-fouten; bestandsgrootte < 2 MB |

## 4. Release-notes & Changelog

1. Genereer changelog: `npx changelogithub --no-publish`  
2. Bewerk sectie **Unreleased → v0.9.0** (features, tech, docs).  
3. Commit:
```bash
git add CHANGELOG.md docs/import_guide.md
git commit -m "docs: prepare v0.9.0 release notes"
```

## 5. Tag & Push

```bash
git tag -a v0.9.0 -m "Sprint 1 Import Phase complete"
git push origin v0.9.0
```

## 6. Pull Request naar `main`

1. Open PR **cursor/setup-flutter-sdk-bootstrap-and-run-tests-0089 → main**.  
2. Wacht op groene build + review → *Squash & merge*.

## 7. Post-Merge Production Deploy

CI-workflow `advanced-deployment.yml` draait automatisch.  
Controle:
* Cloud Run/Supabase migraties slagen.  
* `/health` endpoint retourneert **200**.

---
> ☑️ *Document geïncludeerd in repo zodat duidelijk is welke stappen buiten CI om door de dev moeten worden uitgevoerd.*