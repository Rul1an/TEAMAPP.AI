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

1. Bump `pubspec.yaml`