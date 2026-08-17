#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

ruby -Itools/lib -rlenbands -rlenbands/yaml_loader <<'RUBY'
manifest = Lenbands::YamlLoader.load_file("artifacts/operations/acceptance/p0-acceptance-manifest.yaml", mapping: true)
integrity = Lenbands::YamlLoader.load_file("artifacts/operations/evidence-integrity.yaml", mapping: true)
harness = manifest["runtime_harness"] || {}

unless integrity.dig("runtime_acceptance_policy", "ingestion_of_claimed_pass_yaml") == "forbidden"
  warn "P0 acceptance blocked: evidence integrity policy is not fail-closed"
  exit 2
end

unless harness["state"] == "registered" && harness["runner_command"].is_a?(String) && !harness["runner_command"].empty?
  warn "P0 acceptance blocked: registered runtime harness is missing; external pass/fail YAML ingestion is forbidden"
  exit 2
end

warn "P0 acceptance blocked: the registered runtime harness must be invoked directly by its dedicated evidence runner; generic result ingestion has been retired"
exit 2
RUBY
