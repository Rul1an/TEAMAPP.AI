#!/usr/bin/env bash
# Starts Grafana LGTM stack (Tempo, Prometheus, Loki) for local OTLP ingestion.
set -euo pipefail

docker run --name lgtm -p 3000:3000 -p 4317:4317 -p 4318:4318 \
  --rm -d grafana/otel-lgtm:0.8.1

echo "LGTM stack running → Tempo/Prometheus/Loki reachable via http://localhost:3000 (Grafana)"