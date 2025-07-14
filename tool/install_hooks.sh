#!/usr/bin/env bash
# Install or sync git hooks via Lefthook
set -euo pipefail

if ! command -v lefthook >/dev/null 2>&1; then
  echo "[install_hooks] lefthook binary not found. Installing via npm…"
  npm install --global --silent lefthook
fi

lefthook install

echo "[install_hooks] Git hooks installed via Lefthook."