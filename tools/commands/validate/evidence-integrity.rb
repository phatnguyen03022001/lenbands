#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "set"

root = File.expand_path("../../..", __dir__)
errors = []
load_yaml = lambda do |relative|
  path = File.join(root, relative)
  begin
    data = YAML.safe_load(File.read(path), aliases: false)
    data.is_a?(Hash) ? data : {}
  rescue StandardError => e
    errors << "#{relative}: #{e.message}"
    {}
  end
end

integrity = load_yaml.call("artifacts/operations/evidence-integrity.yaml")
acceptance = load_yaml.call("artifacts/operations/acceptance/p0-acceptance-manifest.yaml")
gold = load_yaml.call("artifacts/operations/benchmark/gold-corpus-manifest.yaml")
thresholds = load_yaml.call("artifacts/operations/benchmark/numeric-threshold-policy.yaml")

required_rules = %w[
  candidate_outputs_must_not_define_their_own_expected_result
  benchmark_expected_withhold_or_quality_disposition_is_gold_dataset_authority
  external_result_yaml_is_not_acceptance_evidence_without_registered_runner_provenance
  every_evidence_payload_is_bound_to_one_exact_candidate_sha
  a_metric_that_requires_human_judgment_is_not_auto_promoted_from_a_model_supplied_boolean
].to_set
actual_rules = Array(integrity["integrity_rules"]).to_set
missing = required_rules - actual_rules
errors << "evidence integrity missing rules: #{missing.to_a.sort.join(', ')}" unless missing.empty?

harness = acceptance["runtime_harness"] || {}
errors << "acceptance manifest must forbid external claim ingestion" unless harness["external_claim_ingestion"] == "forbidden"
if harness["state"] == "missing"
  errors << "missing runtime harness must not expose runner command" unless harness["runner_command"].nil?
elsif harness["state"] == "registered"
  errors << "registered runtime harness requires runner_command" if harness["runner_command"].to_s.empty?
else
  errors << "runtime harness state must be missing or registered"
end

required_reference = Array(gold["required_reference_fields"]).to_set
%w[criteria overall_band must_withhold_score evidence_refs].each do |field|
  errors << "gold corpus reference contract missing #{field}" unless required_reference.include?(field)
end
errors << "threshold policy must require separate human quality review" unless thresholds.dig("human_quality_review", "required") == true
errors << "threshold policy must reject candidate booleans for human quality" unless thresholds.dig("human_quality_review", "rule").to_s.include?("candidate_supplied_booleans") || thresholds.dig("human_quality_review", "rule").to_s.include?("model_or_candidate_supplied_booleans")

benchmark_runner_path = File.join(root, "tools/commands/run/writing-benchmark.rb")
benchmark_runner = File.read(benchmark_runner_path)
errors << "benchmark runner still trusts candidate expected_withheld" if benchmark_runner.include?('prediction["expected_withheld"]')
errors << "benchmark runner must reject candidate-owned withhold expectations" unless benchmark_runner.include?("candidate results may not supply expected_withheld/must_withhold_score")
errors << "benchmark runner does not read gold must_withhold_score" unless benchmark_runner.include?('item.dig("reference", "must_withhold_score")')
%w[candidate_sha dataset_sha256 policy_sha256 results_sha256 runner_sha256 scorer_route_version].each do |marker|
  errors << "benchmark runner evidence envelope missing #{marker}" unless benchmark_runner.include?(marker)
end
errors << "benchmark runner must require separate human quality review" unless benchmark_runner.include?("quality_review") && benchmark_runner.include?("human_quality_review_sha256")

acceptance_runner_path = File.join(root, "tools/commands/run/p0-acceptance.rb")
acceptance_runner = File.read(acceptance_runner_path)
errors << "generic acceptance runner still accepts --results" if acceptance_runner.include?("--results")
errors << "generic acceptance runner must fail closed without registered harness" unless acceptance_runner.include?("registered runtime harness is missing")
errors << "generic acceptance runner must state claimed YAML ingestion is forbidden" unless acceptance_runner.include?("external pass/fail YAML ingestion is forbidden")

benchmark_shim = File.read(File.join(root, "tools/commands/run/writing-benchmark.sh"))
acceptance_shim = File.read(File.join(root, "tools/commands/run/p0-acceptance.sh"))
errors << "benchmark compatibility shim must delegate to canonical runner" unless benchmark_shim.include?("writing-benchmark.rb") && !benchmark_shim.include?("expected_withheld")
errors << "acceptance compatibility shim must delegate to canonical runner" unless acceptance_shim.include?("p0-acceptance.rb") && !acceptance_shim.include?("--results")

if errors.empty?
  puts "evidence integrity validation passed (acceptance_ingestion=forbidden, gold_expectations=authoritative, candidate_binding=required)"
else
  warn errors.join("\n")
  warn "evidence integrity validation failed: #{errors.length} issue(s)"
  exit 1
end
