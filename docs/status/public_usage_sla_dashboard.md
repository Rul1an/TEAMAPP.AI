# Publieke Usage & SLA Dashboards

Sprint 7 leverde een publiek leesbare **Grafana dashboard** op waarmee klanten live usage- en SLA-statistieken kunnen volgen.

## Endpoints
* Prometheus: `https://metrics.teamapp.ai/prometheus` (read-only)
* Grafana: `https://status.teamapp.ai` (anonymous viewer role)

## Dashboard provisioning
1. Het JSON-dashboard `monitoring/dashboards/public_sla_overview.json` wordt tijdens deploy naar Grafana gepusht via `grafana/provisioning/dashboards`.
2. Datasource `Prometheus` is read-only en alleen whitelisted queries.
3. Netlify proxy header `X-Frame-Options: sameorigin` verwijderd om embed mogelijk te maken.

## Metrics in gebruik
| Metric | Uitleg |
|--------|--------|
| `stripe_active_subscriptions_total` | Aantal actieve subscriptions (Stripe exporter) |
| `stripe_estimated_mrr_usd` | Geschatte MRR in USD |
| `increase(veo_rate_limited_total[5m])` | Requests geblokkeerd in de laatste 5 minuten |

## Embed
```html
<iframe src="https://status.teamapp.ai/d/public-sla-overview?orgId=1&refresh=30s" width="100%" height="600" frameborder="0"></iframe>
```