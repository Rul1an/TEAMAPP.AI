#!/usr/bin/env bash
# Starts local Supabase Postgres + Storage using supabase-cli.
set -euo pipefail

supabase start db --shadow false