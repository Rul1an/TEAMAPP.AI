# 🆘 Disaster Recovery (DR) Runbook – Video Platform

_Last updated: 2025-07-16_

## 🎯 Doel
Herstelservice voor het Video Platform binnen **30 minuten** bij regionale storing of dataverlies.

## 🔄 Recovery Workflow
| # | Actie | Owner | Tooling |
|---|-------|-------|---------|
| 1 | Writes **bevriezen** (`FEATURE_WRITE_BLOCK=true`) | On-call SRE | Envoy filter |
| 2 | **PITR restore** starten (`create_restore=true`) | DB Engineer | `backup/terraform/pitr.tf` |
| 3 | **Fail-over simuleren** (`scripts/gameday_failover.sh DRY_RUN=false`) | On-call SRE | GitHub Actions → Manual run |
| 4 | DR-cluster **promoten** naar primary | Platform Lead | Supabase CLI `supabase promote` |
| 5 | **Smoke-tests** draaien | QA | `flutter drive` E2E suite |
| 6 | Writes **de-freeze** (`FEATURE_WRITE_BLOCK=false`) | On-call SRE | Envoy |

## 🛡️ Observability
1. **CloudWatch Dashboard** `VideoPlatform/DR` – RPO age, write latency, 5xx rate.
2. **PagerDuty Policy** `video-platform-critical` – triggert op CloudWatch alarms.
3. **Slack Alerts** – `#video-platform-alerts` krijgt GameDay en Chaos-run status.

## 📜 Preconditions
- GitHub secrets `ROUTE53_HOSTED_ZONE_ID`, `AWS_CHAOS_ROLE_ARN`, etc.
- RDS backups ≥35 d retention.
- FIS IAM-rol met SSM + ENI permissies.

## 📝 Changelog
| Datum | Wijziging |
|-------|-----------|
| 2025-07-16 | Eerste versie, aligned met Best Practices 2025. |