#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

ruby tools/commands/validate/canonical-web-api.rb
ruby tools/commands/generate/canonical-web-api.rb --check

echo "openapi validation passed (canonical full-web contract + resolved typed projection)"
