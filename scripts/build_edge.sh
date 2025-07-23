#!/usr/bin/env bash
# Bundle & minify Edge functions via supabase-edge-runtime build (VEO-107)
set -euo pipefail

# Detect whether the edge runtime CLI is available; skip build gracefully otherwise (CI forks lack private registry access)
if ! npx --yes supabase-edge-runtime --version >/dev/null 2>&1; then
  echo "⚠️  supabase-edge-runtime CLI not available (404) – skipping edge bundle."
  exit 0
fi

ROOT="$(dirname "$0")/.."
SRC_DIR="$ROOT/supabase/edge_functions"
DIST_DIR="$SRC_DIR/dist"

rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

for fn in "$SRC_DIR"/*.ts; do
  base=$(basename "$fn")
  echo "📦 Bundling $base"
  npx supabase-edge-runtime build "$fn" --minify --out "$DIST_DIR/$base"
  # Generate source map alongside bundle
  if [[ -f "$DIST_DIR/$base" ]]; then
    echo "✔️  Output: $DIST_DIR/$base"
  fi
done

echo "Edge bundles generated in $DIST_DIR"
