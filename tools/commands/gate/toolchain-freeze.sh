#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

tools/commands/doctor.rb
tools/commands/validate/toolchain.rb
tools/commands/validate/claude-code.rb
tools/commands/validate/trust-boundary.rb
tools/commands/validate/contract-ownership.rb
tools/commands/validate/platform-boundary.rb
tools/commands/validate/domain-automation.rb
tools/commands/generate/all.sh --check
tools/commands/validate/documents.rb
tools/commands/validate/implementation-catalog.sh
echo "toolchain contract freeze gate passed; this does not imply P0/runtime readiness"
