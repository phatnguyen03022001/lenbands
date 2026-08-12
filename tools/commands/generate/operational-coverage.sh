#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
out_dir="$repo_root/artifacts/operations/generated"
mkdir -p "$out_dir"

check=false
if [[ "${1:-}" == "--check" ]]; then
  check=true
  shift
fi
if [[ $# -ne 0 ]]; then
  echo "usage: $0 [--check]" >&2
  exit 64
fi

temp_root="${TMPDIR:-/tmp}"
render_dir="$(mktemp -d "${temp_root%/}/lenbands-operational-coverage.XXXXXX")"
trap 'rm -rf "$render_dir"' EXIT

# Generate operationalization-matrix.md and runtime-coverage.md from canonical registries.
# Coverage status is derived via filesystem inspection, not hardcoded claims.

cat > "$render_dir/operationalization-matrix.md" <<'EOF'
# Operationalization Matrix (Generated)

Generated from capability-family-map.yaml, family registries, owner runtime specs, interaction contracts, and contract paths. Do not edit manually.

| Capability | Lifecycle | Family | Delta | Owner Spec | Interaction | API | Entities | Events | Failure | Acceptance | Evidence | Status |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
EOF

ruby -I"$repo_root/tools/lib" -rlenbands -rlenbands/registries -ryaml - "$render_dir" "$repo_root" <<'RUBY'
out_dir, repo_root = ARGV

def file_exists?(repo_root, path)
  return false if path.nil? || path.to_s.empty? || path == "null"
  File.file?(File.join(repo_root, path))
end

entries = Lenbands::Registries::CapabilityRegistry.entries

# Derive stem from owner_spec path (e.g. "artifacts/engineering/runtime/identity-core-runtime.md" → "identity-core")
def stem_from_path(path)
  return nil if path.nil? || path.to_s.empty?
  File.basename(path.to_s, "-runtime.md")
rescue
  nil
end

# Build coverage per family via filesystem inspection
family_registry = Lenbands::Registries::FamilyRegistry
family_coverage = {}

family_registry.families.each do |fam|
  fid = fam["family_id"]
  owner_spec = fam["owner_spec"]
  interaction_spec = fam["interaction_spec"]

  owner_stem = stem_from_path(owner_spec)

  # Filesystem inspection — measure, don't claim
  family_coverage[fid] = {
    "owner_spec" => file_exists?(repo_root, owner_spec) ? "complete" : "missing",
    "interaction" => file_exists?(repo_root, interaction_spec) ? "complete" : "missing",
    "api" => Array(fam["shared_contracts"]).any? { |c| c.to_s.include?("openapi") } ? "complete" : "missing",
    "entities" => Array(fam["shared_contracts"]).any? { |c| c.to_s.include?("data-contract") } ? "complete" : "candidate",
    "events" => Array(fam["shared_contracts"]).any? { |c| c.to_s.include?("event-contract") } ? "complete" : "shared",
    "failure" => Array(fam["shared_contracts"]).any? { |c| c.to_s.include?("failure-contract") } ? "complete" : "candidate",
    "acceptance" => Array(fam["shared_acceptance"]).empty? ? "planned" : "defined_pending_run",
    "evidence" => Array(fam["shared_evidence"]).empty? ? "planned" : "requirement_defined_pending_record"
  }
end

File.open(File.join(out_dir, "operationalization-matrix.md"), "a") do |f|
  entries.each do |entry|
    id = entry["capability_id"]
    lifecycle = entry["lifecycle"]
    family = entry["family_id"]
    delta = entry["delta_id"] || "null"
    status = entry["status"] || "planned"

    if lifecycle == "ACTIVE"
      cov = family_coverage[family] || {}
      f.puts "| `#{id}` | `#{lifecycle}` | `#{family}` | `#{delta}` | `#{cov["owner_spec"]}` | `#{cov["interaction"]}` | `#{cov["api"]}` | `#{cov["entities"]}` | `#{cov["events"]}` | `#{cov["failure"]}` | `#{cov["acceptance"]}` | `#{cov["evidence"]}` | `#{status}` |"
    else
      f.puts "| `#{id}` | `#{lifecycle}` | `#{family}` | `#{delta}` | planned | planned | planned | planned | planned | planned | planned | planned | `#{status}` |"
    end
  end
end

# Build runtime-coverage.md
active_fams = family_registry.active_families
planned_fams = family_registry.families.reject { |f| f["lifecycle"] == "ACTIVE" }

File.open(File.join(out_dir, "runtime-coverage.md"), "w") do |f|
  f.puts "# Runtime Coverage (Generated)"
  f.puts
  f.puts "Generated from the canonical family registry and current owner/interaction/contract/evidence files. Do not edit manually."
  f.puts
  f.puts "| Family | Lifecycle | Owner Runtime Spec | Interaction Contract | API | State/Entity | Events | Failure | Acceptance | Evidence | Build Status |"
  f.puts "|---|---|---|---|---|---|---|---|---|---|---|"

  active_fams.each do |fam|
    fid = fam["family_id"]
    lc = fam["lifecycle"]
    cov = family_coverage[fid] || {}
    f.puts "| #{fid} | #{lc} | #{cov["owner_spec"]} | #{cov["interaction"]} | #{cov["api"]} | #{cov["entities"]} | #{cov["events"]} | #{cov["failure"]} | #{cov["acceptance"]} | #{cov["evidence"]} | candidate |"
  end

  planned_fams.first(6).each do |fam|
    fid = fam["family_id"]
    lc = fam["lifecycle"] || "PLANNED"
    f.puts "| #{fid} | #{lc} | planned | planned | planned | planned | planned | planned | planned | planned | planned |"
  end

  f.puts
  f.puts "No ACTIVE family is marked ready by this report. Evidence records remain pending where corpus, benchmark, thresholds, or acceptance runs are absent."
end
RUBY

cat > "$render_dir/README.md" <<'EOF'
# Generated Operational Reports

Generated by tools/generate-operational-coverage.sh. These files are projections, not sources of truth. Do not edit manually.
EOF

outputs=(operationalization-matrix.md runtime-coverage.md README.md)
stale=0
for file in "${outputs[@]}"; do
  if ! cmp -s "$render_dir/$file" "$out_dir/$file"; then
    stale=1
    if ! $check; then
      mv "$render_dir/$file" "$out_dir/$file"
    fi
  fi
done

if $check; then
  if (( stale )); then
    echo "operational coverage projections are stale; run tools/generate-operational-coverage.sh" >&2
    exit 1
  fi
  echo "operational coverage projections are current"
elif (( stale )); then
  echo "operational coverage generated: $out_dir"
else
  echo "operational coverage unchanged"
fi
