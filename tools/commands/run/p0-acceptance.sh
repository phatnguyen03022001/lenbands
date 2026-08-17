#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

# Stable compatibility entrypoint. Generic claimed-result ingestion is retired.
exec bash tools/commands/run/p0-acceptance.rb "$@"
