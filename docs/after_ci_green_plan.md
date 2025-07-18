# Plan van aanpak na een groene CI-pipeline

Zodra **alle jobs in de CI-workflow groen** zijn (tests, analyse, build), volg je dit stappenplan.

## 1. QA-controle

1. Download en bekijk de laatste workflow-artefacten:
   - Code-coverage rapport
   - Web-build artefact
   - Lighthouse-score
2. Deploy (of open) de **staging**-omgeving en voer een snelle sanity-check uit.

## 2. Pull-request afronden

1. Laat de product-owner in het PR-commentaar _QA ✓_ plaatsen.
2. **Squash-merge** de PR naar `main` met de titel:
   > feat(ci): Sprint-1 import & quality gate
3. Verwijder de feature-branch.

## 3. Semantische versie & release

1. Bump `pubspec.yaml` naar **v0.9.0**.
2. Maak een **GitHub Release** met tag `v0.9.0 – Import phase & CI setup` en changelog uit de PR-body.
3. De release-workflow pusht automatisch de tag.

## 4. Blue/Green deploy (Cloud Run)

1. Trigger de workflow `advanced-deployment.yml` om een nieuwe **green**-revision aan te maken.
2. Voer een health-check (`/healthz`) en een loadprobe van 30 s uit.
3. Zet **100 %** van het verkeer over van **blue → green**.
4. Houd de oude revision 24 u aan als rollback-optie.

## 5. Post-deploy taken

1. Draai het volledige **E2E-regressiescript** op de productie-URL (Cypress-matrix).
2. Publiceer de coverage-badge en het Lighthouse-rapport in de `README`.
3. Voeg het **SBOM**-artefact toe aan de release-assets.

## 6. Sprint-2 voorbereiding

1. Maak ticket “Sprint 2: Deployment hardening”.
2. Verplaats de resterende TODO’s (dark-theme, `navigatorObservers`, Supabase-integratie).
3. Archiveer het Sprint-1 project-board en open een nieuw board voor Sprint-2.