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

## 3. Versie & release

1. Bump `pubspec.yaml` naar **v0.9.0**.
2. Maak een **GitHub Release** met tag `v0.9.0` en changelog uit de PR-body.
3. De release-workflow pusht automatisch de tag.

## 4. Blue/Green deploy (Cloud Run)

1. Start de workflow `advanced-deployment.yml`.
2. Dit creëert een nieuwe **green**-revision.
3. Voer health-check (`/healthz`) en 30 s loadprobe uit.
4. Verplaats 100 % traffic van **blue → green**.
5. Houd de oude revision 24 u actief als rollback-optie.

## 5. Post-deploy taken

1. Draai het volledige **E2E-regressiescript** op de productie-URL (Cypress-matrix).
2. Publiceer de coverage-badge en Lighthouse-rapport in de `README`.
3. Koppel het **SBOM**-artefact aan de release-assets.

## 6. Voorbereiding Sprint 2

1. Maak ticket “Sprint 2: Deployment hardening”.
2. Migreer openstaande TODO’s (dark theme, navigatorObservers, Supabase-integratie).
3. Archiveer het Sprint-1 project-board en open een nieuw board voor Sprint-2.