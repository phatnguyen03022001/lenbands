#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

results=""
output=""
reviewer=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --results) results="$2"; shift 2 ;;
    --output) output="$2"; shift 2 ;;
    --reviewed-by) reviewer="$2"; shift 2 ;;
    *) echo "usage: $0 --results path --output evidence/p0-acceptance-run.yaml --reviewed-by owner" >&2; exit 64 ;;
  esac
done

ruby -Itools/lib -rlenbands -rlenbands/yaml_loader -rdigest -rtime - "$results" "$output" "$reviewer" <<'RUBY'
results_path, output_path, reviewer = ARGV
root = File.expand_path(Dir.pwd)
evidence_root = File.join(root, "artifacts/operations/evidence")
manifest = Lenbands::YamlLoader.load_file("artifacts/operations/acceptance/p0-acceptance-manifest.yaml", mapping: true)
blocked = []
blocked << "runtime_results_missing" if results_path.to_s.empty? || !File.file?(results_path.to_s)
blocked << "reviewer_missing" if reviewer.to_s.empty?
blocked << "output_path_missing" if output_path.to_s.empty?
expanded_output = output_path.to_s.empty? ? nil : File.expand_path(output_path, root)
blocked << "output_must_be_yaml_evidence_record" unless expanded_output&.end_with?(".yaml")
blocked << "output_must_stay_in_operations_evidence" unless expanded_output&.start_with?("#{evidence_root}/")
unless blocked.empty?
  warn "P0 acceptance run blocked: #{blocked.join(", ")}"
  exit 2
end

results = Lenbands::YamlLoader.load_file(results_path, mapping: true)
expected = manifest.fetch("packs").to_h { |pack| [pack["pack_id"], pack["acceptance_tests"]] }
actual_packs = Array(results["packs"])
actual_ids = actual_packs.map { |pack| pack["pack_id"] }
failures = []
failures << "duplicate pack IDs" unless actual_ids.uniq.length == actual_ids.length
failures << "result packs differ from acceptance manifest" unless actual_ids.sort == expected.keys.sort
actual = actual_packs.to_h { |pack| [pack["pack_id"], pack["tests"]] }
expected.each do |pack_id, test_ids|
  raw_entries = Array(actual[pack_id])
  entry_ids = raw_entries.map { |test| test["test_id"] }
  failures << "#{pack_id}: duplicate test IDs" unless entry_ids.uniq.length == entry_ids.length
  entries = raw_entries.to_h { |test| [test["test_id"], test] }
  failures << "#{pack_id}: result test IDs differ from manifest" unless entry_ids.sort == test_ids.sort
  test_ids.each do |test_id|
    failures << "#{pack_id}/#{test_id}: missing" unless entries.key?(test_id)
    failures << "#{pack_id}/#{test_id}: not passed" if entries.key?(test_id) && entries[test_id]["status"] != "passed"
  end
end
failures << "results must explicitly report redaction_passed=true" unless results["redaction_passed"] == true
failures << "results must explicitly report idempotency_passed=true" unless results["idempotency_passed"] == true
abort(failures.join("\n")) unless failures.empty?
abort("refusing to overwrite acceptance evidence") if File.exist?(expanded_output) || File.exist?("#{expanded_output}.meta.yaml")
abort("output parent directory is missing") unless File.directory?(File.dirname(expanded_output))

run_id = "acceptance-#{Time.now.utc.strftime("%Y%m%dT%H%M%SZ")}-#{Digest::SHA256.file(results_path).hexdigest[0, 12]}"
payload = {
  "acceptance_run_id" => run_id,
  "manifest_schema_version" => manifest["schema_version"],
  "build_ref" => results["build_ref"],
  "packs" => results["packs"],
  "redaction_passed" => true,
  "idempotency_passed" => true,
  "decision" => "hold",
  "reviewed_by" => reviewer,
  "reviewed_at" => Time.now.utc.iso8601
}
File.write(expanded_output, payload.to_yaml)
hash = Digest::SHA256.file(expanded_output).hexdigest
File.write("#{expanded_output}.meta.yaml", {
  "type" => "p0-acceptance-run",
  "status" => "review",
  "version" => "1.0.0",
  "owner" => "operations",
  "representation" => "yaml",
  "derived_from" => ["OPS.ReleaseGate", "OPS.Observability"],
  "purpose" => "immutable-p0-runtime-acceptance-run",
  "consumed_by" => ["operations", "engineering"],
  "created_at" => Time.now.utc.strftime("%Y-%m-%d"),
  "updated_at" => Time.now.utc.strftime("%Y-%m-%d"),
  "evidence_id" => run_id,
  "payload_sha256" => "sha256:#{hash}",
  "immutable" => true
}.to_yaml)
puts payload.to_yaml
RUBY
