# KPI Dashboard Setup – Fan & Family Pilot (2025 Q3)

_Last updated: 2025-07-18_

This document explains the data pipeline and dashboard locations for the Fan & Family pilot.

## Data sources

| Source | Metric category | Export cadence |
|--------|-----------------|----------------|
| Firebase Analytics (GA4) | engagement_events, screen_view | near-real-time (streaming) |
| Firebase Cloud Messaging | push_open, push_foreground | near-real-time |
| Firebase Performance | app_start_time, frame_rate | hourly |

Analytics → BigQuery streaming export is enabled in the Firebase console (`bigquery-export` project).

## BigQuery datasets

* `fan_family_analytics.events_*` – GA4 raw events (partitioned per day)
* `fan_family_performance.metrics_*` – performance traces
* `fan_family_kpi.materialised` – daily materialised view for dashboards

```sql
-- Example KPI materialised view (simplified)
CREATE OR REPLACE TABLE fan_family_kpi.materialised AS
SELECT
  event_date,
  COUNTIF(event_name = 'screen_view') AS screen_views,
  COUNTIF(event_name = 'push_open') AS push_opens,
  COUNTIF(event_name = 'share_match') AS shares,
  APPROX_COUNT_DISTINCT(user_pseudo_id) AS mau
FROM `bigquery-export.fan_family_analytics.events_*`
WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY))
  AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
GROUP BY event_date;
```

Scheduled via Cloud Scheduler → Cloud Workflow daily 03:00 CET.

## Looker Studio dashboard

URL: <https://datastudio.google.com/fan-family-engagement>

Sections:

1. Overview – MAU, DAU/MAU %, avg session duration
2. Engagement – shares, push opens, deep-link hits
3. Performance – p95 load, app start, frame rate
4. Funnel – install → push opt-in → first share

## KPI Gate (Week 4)

Success criteria (see plan §4):

| KPI | Target | Source |
|-----|--------|--------|
| MAU uplift | +20 % vs baseline | BigQuery / materialised view |
| Support tickets | ‑30 % | Intercom tags `fan_family` |
| p95 load time | < 2 s | Firebase Performance |

## Next steps

* Automate weekly Slack digest via BigQuery → Cloud Functions.
* Enable Session Replay sampling once GA4 SDK supports Flutter (> SDK 10).
