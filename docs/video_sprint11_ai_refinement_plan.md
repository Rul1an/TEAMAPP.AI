# Video Sprint 11 — Insight Refinement & Roll-out (May 26 – Jun 6 2025)

## 1. Sprint Goal
Ship **coach-ready Insight refinement & sharing**: polish Quick Insights recommendations, enable sharing playlists via link, and roll out Analysis stack to first 3 pilot clubs.

## 2. Strategic Alignment
| Dimension | Alignment |
|-----------|-----------|
| Company OKR | _“100 pilot clubs actively using AI insights by Q3”_ |
| Product Theme | Insight virality & collaboration |
| Tech Principle | Feature-flagged, Observable-by-default, Accessibility-first |
| Stakeholders | Product @eva • Eng @ramon • GTM @lara • Pilot clubs (DOS, Excelsior, Rijnsburg) |

## 3. Backlog Commitment (VEO-147…154)
| # | Story | Type | Est | Acceptance Criteria |
|---|-------|------|-----|----------------------|
| 147 | **InsightRecommendationEngine v1.1** | BE+DS | 8 | Precision ≥92 %, recall ≥90 % on validation-set; latency <150 ms p95. |
| 148 | **Shareable Playlist Links** | BE+FE | 5 | Signed URL valid 14 d, ACL scoped to org; deep-link opens in dashboard. |
| 149 | **Coach Notes on Clips** | FE | 3 | Inline rich-text comments, autosave offline, sync conflict-free via CRDT. |
| 150 | **Bulk Export to Hudl** | BE | 5 | OAuth2 import; <60 s for 90-min match; progress UI. |
| 151 | **Accessibility Audit AA** | QA | 3 | Axe-ci score ≥ 90; no critical violations. |
| 152 | **Observability – Insights SLO Dashboard** | DevOps | 3 | Grafana board: recommendation latency, link clicks; alert at 5 % error budget burn. |
| 153 | **Pilot Roll-out Playbook** | PM | 2 | Notion runbook, checklists, feedback loops T-1, T+3, T+10. |
| 154 | **E2E ‘share_flow_test.dart’** | QA | 3 | Generates playlist → share → open in incognito; runs in CI <3 min. |
_Total SP: 32 (velocity 38 ⇒ 6 SP buffer)_

## 4. Timeline
| Date | Activity |
|------|----------|
| **Mon 26 May** | Kick-off, backlog refinement, enable feature flag _insight_share_ (off) |
| Tue 27 – Fri 30 May | Parallel: 147, 148, 152 groundwork; a11y audit start |
| Mon 2 Jun | Mid-sprint demo to pilot clubs; collect early feedback |
| Tue 3 – Thu 5 Jun | Finish bulk export, coach notes, E2E; freeze & UAT |
| **Fri 6 Jun** | Sprint review + retro; flag on for pilots 10 % ramp |

## 5. Definition of Done 2025
1. Code passes `very_good_analysis` + mutation ≥80 %. 
2. SLA dashboards show green for 24 h pre-merge. 
3. Docs: ADR, OpenAPI, changelog, in-app guide updated. 
4. a11y: WCAG 2.2 AA, verified by axe-ci & manual screen-reader walkthrough. 
5. Security: OWASP ZAP no High findings; signed URLs length ≥128 bit entropy. 
6. Roll-out: LaunchDarkly flag + back-out playbook.

## 6. Risks & Mitigations
| Risk | P | I | Action |
|------|---|---|--------|
| Recommendation false-positives annoy coaches | M | H | Feedback loop in UI, weekly relearning. |
| Link-sharing leak (public) | L | H | Signed URLs + ACL + 7 day log retention audit. |
| Hudl API rate limits | M | M | Exponential back-off, queue jobs. |
| Pilot club bandwidth | M | M | Async video tutorials, office hours. |
| Team overlap with holiday | M | L | Re-balance pairing, buffer 6 SP. |

---
© 2025 Video Engineering Org — Sprint 11 plan (best practices 2025)