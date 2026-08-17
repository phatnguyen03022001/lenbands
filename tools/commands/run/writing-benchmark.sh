#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

# Stable compatibility entrypoint. The canonical benchmark implementation lives in one file only.
exec bash tools/commands/run/writing-benchmark.rb "$@"
