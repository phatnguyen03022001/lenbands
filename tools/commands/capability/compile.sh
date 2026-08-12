#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

if [[ $# -ne 1 ]]; then
  echo "usage: tools/compile-capability.sh <CAPABILITY_ID|P0-XX>" >&2
  exit 2
fi

query="$1"

ruby -Itools/lib -rlenbands -rlenbands/yaml_loader -rlenbands/registries - "$query" <<'RUBY'
query = ARGV.fetch(0)
manifest = Lenbands::YamlLoader.load_file("artifacts/operations/capability-manifest.yaml", mapping: true)
families = manifest.fetch("capability_families")

family = families.find do |item|
  item["family_id"] == query || Array(item["capability_ids"]).include?(query)
end

unless family
  warn "unknown capability or family: #{query}"
  exit 1
end

puts "# Capability Compile Context"
puts
pack_id = family["family_id"]
# Resolve pack_id to implementation family via canonical manifest registry
implementation_family = family["implementation_family_id"] || "UNRESOLVED.Unknown"
puts "pack_id: #{pack_id}"
puts "family_id: #{implementation_family}"
puts "family_name: #{family["family_name"]}"
puts "phase: #{family["phase"]}"
puts "owner: #{family["owner"]}"
puts "readiness_state: #{family["readiness_state"]}"
puts
puts "capability_ids:"
Array(family["capability_ids"]).each { |value| puts "  - #{value}" }
puts
puts "states:"
Array(family["states"]).each { |value| puts "  - #{value}" }
puts
puts "events_published:"
Array(family["events_published"]).each { |value| puts "  - #{value}" }
puts
puts "data_entities:"
Array(family["data_entities"]).each { |value| puts "  - #{value}" }
puts
puts "artifacts_current:"
Array(family["artifacts_current"]).each do |artifact|
  puts "  - #{artifact["path"]} (#{artifact["status"]})"
end
puts
puts "evidence_required:"
Array(family["evidence_required"]).each { |value| puts "  - #{value}" }
puts
puts "readiness_blockers:"
Array(family["readiness_blockers"]).each { |value| puts "  - #{value}" }
RUBY
