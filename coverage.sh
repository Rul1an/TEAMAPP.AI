#!/usr/bin/env bash
# coverage.sh – run tests with coverage and generate HTML report
set -euo pipefail

flutter test --coverage

if command -v genhtml >/dev/null 2>&1; then
  echo "Generating HTML coverage report…"
  genhtml coverage/lcov.info --output-directory coverage/html
  echo "HTML report available at coverage/html/index.html"
else
  echo "genhtml not found; skipping HTML report generation."
fi
