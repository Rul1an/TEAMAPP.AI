#!/usr/bin/env bash
# Install or sync git hooks via Lefthook
set -euo pipefail

if ! command -v lefthook >/dev/null 2>&1; then
  echo "[install_hooks] lefthook binary not found. Installing locally…"
  dart pub global activate lefthook_cli >/dev/null 2>&1 || true
  export PATH="$PATH:":"$(dart pub global list | awk '/lefthook_cli/ {print $NF}')/bin"
fi

npx lefthook install

echo "[install_hooks] Git hooks installed via Lefthook."