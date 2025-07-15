# Veo Integration Assessment – JO17 Tactical Manager (2025)

> Author: Video Feature Squad  
> Date: 2025-07-15  
> Status: Draft v1

---

## 1. Wat is Veo?
[Veo](https://www.veo.co) is een AI-camera­platform gericht op sportclubs met:
• Auto-tracking 180°/360° camera
• Cloud-upload & AI-generated highlights
• API (beta, GraphQL) voor video assets & moments
• Subscription vanaf €1.099 + €29/maand

## 2. Integratie-scenario’s

| Scenario | Beschrijving | Voor- & Nadelen | Geschatte effort |
|----------|-------------|-----------------|------------------|
| A. **Deep-link** | Alleen URL naar Veo-platform in app | + Zeer snel<br>+ Geen opslagkosten<br>– Bounce buiten app<br>– Geen player-branding | 0.5 pd |
| B. **Embed iFrame** | Veo ‘share’ iFrame in WebView/Flutter Web | + Simpel<br>+ Veo player controls<br>– Mobile native WebView UX
– Authenticatie tokens nodig | 1 pd |
| C. **API ingest (clips)** | Via Veo GraphQL asset-API losse MP4/HLS naar eigen storage | + Uniform UX in eigen player<br>+ Thumbnails & tagging zelf<br>– Data-egress bandbreedte €€<br>– Juridische SLA API beta | 3-4 pd + infra |
| D. **Hybrid** | Highlights via API, full match deep-link | + Beste UX/effort-ratio<br>+ Volkostenefficiënt<br>– Twee flows onderhouden | 2 pd |

## 3. Besluit (2025-07-15)

**Kies Scenario D – Hybrid.**  
Redenen:
1. Full-match video (>10 GB) niet dupliceren → deep-link bespaart storage.  
2. Highlights (2-3 min) _wel_ embedden → eigen tagging, statistiek & offline caching.  
3. Effort past in **Sprint 5** zonder roadmap uitloop.  
4. API beta-status acceptabel voor non-mission-critical highlights; fallback = deep-link.

## 4. Implementatie-stappen

1. Verken Veo GraphQL `getClips(teamId, matchId)` – POC in Postman.  
2. Edge-Function `veo_ingest` → haalt clip-URL, upload naar `videos` bucket.  
3. Hergebruik bestaande `video_processing` pipeline (thumbnails, metadata).  
4. DB-schema: `video_assets.source = 'veo'` & `original_id`.  
5. UI: extra tab “Veo Highlights” in `VideoUploadScreen`.  
6. Feature-flag `features.video.veo = true` (config table).

## 5. Planning & Stories

| Ref | Story | Schatting |
|-----|-------|-----------|
| **VEO-101** | GraphQL auth + fetch clip list | 1 pd |
| **VEO-102** | Edge-Function ingest & pipeline reuse | 1 pd |
| **VEO-103** | UI tab & filter ‘source = veo’ | 0.5 pd |
| **VEO-104** | E2E test ingest→player | 0.5 pd |

_Totaal: 3 pd – in Sprint 5._

## 6. Risico’s & Mitigations

1. **API beta outages** – fallback deep-link, daily cron re-ingest.  
2. **Licentievoorwaarden** – check Veo ToS > redistribution of clips.  
3. **Bandwidth costs** – monitor CDN egress; limit auto-ingest to highlights.  

---
_Last updated: 15 Jul 2025_