#!/usr/bin/env bash
# Bundle & minify Edge functions via supabase-edge-runtime build (VEO-107)
set -euo pipefail

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