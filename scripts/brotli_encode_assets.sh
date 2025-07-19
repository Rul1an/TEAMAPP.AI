#!/usr/bin/env bash
# Brotli-encodes Flutter web build artefacts for CloudFront (VEO-154)
#
# Usage:
#   ./scripts/brotli_encode_assets.sh [build_dir]
#
# Defaults:
#   build_dir = build/web
#
# The script will recursively find compressible file types (.js .html .css .json
# .wasm) and generate .br files alongside the originals *without* deleting the
# originals so CloudFront can perform content-negotiation (br > gzip > identity).
#
# Requires:
#   • brotli (>=1.0) – `brew install brotli` / `apt-get install brotli`
#   • GNU find / xargs
set -euo pipefail

BUILD_DIR=${1:-build/web}
if [[ ! -d "$BUILD_DIR" ]]; then
  echo "[ERROR] Build dir '$BUILD_DIR' not found. Run flutter build web first." >&2
  exit 1
fi

echo "[INFO] Brotli-compressing assets in $BUILD_DIR …"

# Extensions to compress.
EXTS="js css html json wasm svg ico"

# shellcheck disable=SC2086
find "$BUILD_DIR" -type f \( $(printf -- '-name *.%s -o ' $EXTS | sed 's/ -o $//') \) \
  -print0 | xargs -0 -P"$(nproc)" -I{} brotli --best --force --keep --input '{}' --output '{}.br'

echo "[INFO] Done – generated $(find "$BUILD_DIR" -name '*.br' | wc -l) .br files"