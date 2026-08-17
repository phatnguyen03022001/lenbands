#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$repo_root"

tools/commands/doctor.rb
tools/commands/validate/toolchain.rb
tools/commands/validate/claude-code.rb
tools/commands/validate/trust-boundary.rb
tools/commands/generate/all.sh --check
tools/commands/validate/capability-phase-index.rb
tools/commands/validate/knowledge-assets.sh
tools/commands/validate/evidence-lineage.rb
ruby tools/commands/validate/evidence-integrity.rb
ruby tools/commands/validate/data-governance.rb
ruby tools/commands/validate/failure-registry.rb
tools/commands/validate/platform-boundary.rb
tools/commands/validate/domain-automation.rb
# Document validation owns framework/OpenAPI/semantic/spawn/benchmark orchestration.
tools/commands/validate/documents.rb
ruby tools/commands/validate/framework-remediation.rb
tools/commands/validate/contract-ownership.rb
ruby tools/commands/validate/implementation-eligibility.rb
tools/commands/validate/implementation-catalog.sh
ruby tools/commands/validate/compute-boundary.rb

test_files=(tools/test/test_*.rb)
if [[ ! -e "${test_files[0]}" ]]; then
  echo "verification failed: no test files matched tools/test/test_*.rb" >&2
  exit 1
fi
for test_file in "${test_files[@]}"; do
  ruby -Itools/lib "$test_file"
done

echo "repository contract verification passed; runtime/P0 readiness remains a separate fail-closed evidence gate"
