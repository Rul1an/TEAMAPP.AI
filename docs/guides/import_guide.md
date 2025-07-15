# Import-gids – Wedstrijdoverzichten (Sprint 1)

_Laatste update: 2025-07-14_

---

## 1. Overzicht

Deze gids beschrijft hoe je als admin bulk wedstrijdroosters kunt importeren via de nieuwe **Import-wizard** (Sprint 1). Het proces bestaat uit drie eenvoudige stappen:

1. **Selecteer bestand** – Upload een `.csv`, `.xlsx` of `.xls` bestand.
2. **Preview** – Controleer de gemarkeerde rijen (groen = nieuw, geel = duplicate, rood = fout).
3. **Bevestigen** – Sla de nieuwe wedstrijden op en download optioneel een error-rapport.

> Demo-video: [Loom (2 min)](LOOM_URL_PLACEHOLDER) – laat zien hoe je in <120 s een volledig seizoens­rooster importeert.

---

## 2. Bestandsspecificatie

| Kolom | Verplicht | Voorbeeld | Opmerking |
|-------|-----------|-----------|-----------|
| `match_date` | ✅ | `2025-08-15` | Ondersteunde formaten: `yyyy-MM-dd`, `dd-MM-yyyy`, `dd/MM/yyyy`, `MM/dd/yyyy` |
| `opponent` | ✅ | `Ajax U17` | Naam van de tegenstander |
| `venue` | ➖ | `Sportpark De Toekomst` | Wordt gebruikt om automatisch _home/away_ te bepalen; laat leeg voor standaard _home_ |
| `team_id` | ✅ | `team1` | Interne identifier (bij meerdere teams in club) |

Bestand mag extra kolommen bevatten – deze worden genegeerd. De wizard vereist **minimaal 1 en maximaal 5 000** datarijen.

### 2.1 XLSX-template downloaden
Gebruik de _Download template_-knop op stap 1 om een kant-en-klaar `.xlsx` bestand met headers & voorbeeld­rij te krijgen.

---

## 2b. Player Roster bestanden

| Kolom | Verplicht | Voorbeeld |
|-------|-----------|-----------|
| `first_name` | ✅ | Jan |
| `last_name` | ✅ | Jansen |
| `birth_date` | ✅ | 2008-03-15 |
| `jersey_number` | ✅ | 10 |
| `position` | ✅ | Middenvelder |

Extra kolommen zoals `height`, `weight` worden genegeerd. Hash voor duplicates: `first_name + last_name + birth_date`. 

---

## 3. Kleur-legenda & Duplicate-detectie

| Kleur | Betekenis | Actie |
|-------|-----------|-------|
| 🟢 Groen | Nieuw record – wordt geïmporteerd | N.v.t. |
| 🟡 Geel | Potentiële duplicate – bestaat al in database | Wordt **niet** geïmporteerd; pas bestaande wedstrijd aan indien nodig |
| 🔴 Rood | Fout – ontbrekende kolommen / ongeldig datumformaat | Los fout op in bronbestand en importeer opnieuw |

Duplicate-detectie gebruikt de hash `match_date + opponent + venue + team_id` conform **2025-best-practice** zodat valse positives minimaal blijven.

---

## 4. Foutmeldingen

| Code | Omschrijving | Voorbeeld‐oplossing |
|------|--------------|--------------------|
| `missing_columns` | Rij bevat minder dan 4 kolommen | Voeg ontbrekende kolommen toe |
| `invalid_date` | Datumformaat niet herkend | Gebruik `YYYY-MM-DD` |
| `duplicate_row` | Rij is gemarkeerd als duplicate | Verwijder rij of pas data aan |

Na het importeren kun je een `.csv` met fout­rijen downloaden voor snelle correctie.

---

## 5. Tips & Best practices 2025

1. **Gebruik UTF-8** gecodeerde CSV-bestanden om diacritische tekens te behouden.
2. Exporteer vanuit Excel als **CSV UTF-8 (comma separated)** om locale-specifieke punt-komma issues te vermijden.
3. Splits extreem grote bestanden (> 000 rijen) om laadtijd in browser laag (<2 s) te houden.
4. Validatie draait client-side; bestanden blijven **lokaal** tot je op _Importeer_ klikt.
5. Importeer regelmatig en klein – zo voorkom je bulk conflicten.

---

## 6. CLI-fallback

Voor headless servers is een CLI-script beschikbaar:
```bash
flutter pub run tools:import_match_schedule path/to/schedule.csv --team=team1
```
Zie `tool/import_match_schedule.dart` voor opties.

---

## 7. Changelog

*2025-07-14* – Eerste versie (Sprint 1).