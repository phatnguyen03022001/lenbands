#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

if [[ "${1:-}" == "--check" ]]; then
  shift
  [[ $# -eq 0 ]] || { echo "usage: $0 [--check]" >&2; exit 64; }
  tools/commands/generate/capability-index.sh --check
  tools/commands/generate/lifecycle-registry.sh --check
  tools/commands/generate/operational-coverage.sh --check
  tools/commands/generate/repository-baseline.sh --check
  ruby tools/commands/generate/canonical-web-api.rb --check
  exit 0
fi

[[ $# -eq 0 ]] || { echo "usage: $0 [--check]" >&2; exit 64; }

tools/commands/generate/capability-index.sh
tools/commands/generate/lifecycle-registry.sh
tools/commands/generate/operational-coverage.sh
tools/commands/generate/repository-baseline.sh
ruby tools/commands/generate/canonical-web-api.rb --output artifacts/operations/.tmp/openapi.resolved.yaml
