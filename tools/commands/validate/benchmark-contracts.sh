#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

ruby -Itools/lib -rlenbands -rlenbands/yaml_loader -rset -rdigest <<'RUBY'
errors = []
corpus = Lenbands::YamlLoader.load_file("artifacts/operations/benchmark/gold-corpus-manifest.yaml", mapping: true)
policy = Lenbands::YamlLoader.load_file("artifacts/operations/benchmark/numeric-threshold-policy.yaml", mapping: true)
acceptance = Lenbands::YamlLoader.load_file("artifacts/operations/acceptance/p0-acceptance-manifest.yaml", mapping: true)
features = File.read("blueprint/03-features.md")
writing_framework = File.read("blueprint/framework/writing-task-framework.md")

evidence_schema = acceptance["evidence_ref_schema"] || {}
errors << "acceptance evidence_ref schema must require path and checksum" unless Array(evidence_schema["required_fields"]) == %w[path checksum]
errors << "acceptance evidence_ref checksum format must be sha256" unless evidence_schema["checksum_format"] == "sha256"
errors << "acceptance evidence paths must be immutable and under evidence root" unless evidence_schema["path_policy"] == "immutable_file_under_evidence_root"

errors << "corpus must be source_of_truth for its dataset inclusion" unless corpus["source_of_truth"] == true
errors << "corpus manifest must remain missing until rights and labels exist" if corpus["status"] == "ready" && (corpus["rights_status"] != "verified" || corpus["label_status"] != "verified")
errors << "corpus case_count does not match cases" unless corpus["case_count"].to_i == Array(corpus["cases"]).length
errors << "corpus gold_case_count exceeds case_count" if corpus["gold_case_count"].to_i > corpus["case_count"].to_i
Array(corpus["required_task_types"]).each do |task_type|
  errors << "unknown writing task type in corpus policy: #{task_type}" unless writing_framework.include?(task_type)
end
Array(corpus["cases"]).each do |item|
  %w[case_id task_type task_version essay_ref reference rights_evidence_ref].each do |field|
    errors << "corpus case #{item["case_id"]}: missing #{field}" unless item.key?(field)
  end
  reference = item["reference"] || {}
  criteria = reference["criteria"] || {}
  %w[task_response coherence_cohesion lexical_resource grammar].each do |criterion|
    errors << "corpus case #{item["case_id"]}: missing reference criterion #{criterion}" unless criteria.key?(criterion)
  end
  errors << "corpus case #{item["case_id"]}: must_withhold_score must be boolean" unless [true, false].include?(reference["must_withhold_score"])
  errors << "corpus case #{item["case_id"]}: evidence_refs must be non-empty" if item.key?("reference") && Array(reference["evidence_refs"]).empty?
  if corpus["status"] == "ready"
    rights_ref = item["rights_evidence_ref"].to_s
    errors << "corpus case #{item["case_id"]}: rights evidence file missing" if rights_ref.empty? || !File.file?(rights_ref)
  end
end

quality = policy.fetch("quality", {})
%w[criterion_mae_max_band overall_mae_max_band within_half_band_min invalid_or_low_confidence_withheld_min false_acceptance_max p95_latency_ms_max].each do |field|
  errors << "threshold policy missing numeric machine-quality field #{field}" unless quality[field].is_a?(Numeric)
end
human = policy.fetch("human_quality_review", {})
errors << "human quality review must be required" unless human["required"] == true
%w[evidence_validity_min actionable_feedback_min].each do |field|
  errors << "human quality review missing numeric field #{field}" unless human[field].is_a?(Numeric)
end
errors << "human quality rule must reject model/candidate booleans" unless human["rule"].to_s.include?("booleans_do_not_satisfy_this_gate")

cost = policy.fetch("cost", {})
errors << "cost retry threshold must be numeric" unless cost["max_retry_count"].is_a?(Numeric)
if policy["armed"] == true
  errors << "armed policy cannot have pending approval" if policy["approval_state"] != "approved"
  errors << "armed policy missing approval record" if policy.dig("approval_requirements", "approval_record").to_s.empty?
  errors << "armed policy missing numeric USD cost ceiling" unless cost["cost_per_accepted_evaluation_usd_max"].is_a?(Numeric)
  approval_record = policy.dig("approval_requirements", "approval_record").to_s
  if !approval_record.empty? && File.file?(approval_record)
    approval_meta_path = approval_record.sub(/\.(?:md|yaml|yml)\z/, ".meta.yaml")
    approval_meta = File.file?(approval_meta_path) ? Lenbands::YamlLoader.load_file(approval_meta_path, mapping: true) : {}
    errors << "armed policy approval record metadata must be approved" unless approval_meta["status"] == "approved" && !approval_meta["reviewed_by"].to_s.empty?
  end
end

expected_packs = (1..6).map { |n| format("P0-%02d", n) }
packs = Array(acceptance["packs"])
pack_ids = packs.map { |pack| pack["pack_id"] }
errors << "acceptance packs mismatch: #{pack_ids.sort.inspect}" unless pack_ids.sort == expected_packs
capability_ids = features.scan(/\x60([A-Z][A-Z0-9_]*\.[A-Za-z][A-Za-z0-9_]*)\x60/).flatten.to_set
packs.each do |pack|
  errors << "#{pack["pack_id"]}: acceptance_tests empty" if Array(pack["acceptance_tests"]).empty?
  errors << "#{pack["pack_id"]}: required_evidence empty" if Array(pack["required_evidence"]).empty?
  errors << "#{pack["pack_id"]}: unknown capability" if (Array(pack["capability_ids"]) - capability_ids.to_a).any?
  if pack["status"] == "passed"
    refs = pack["evidence_refs"] || {}
    Array(pack["required_evidence"]).each do |evidence_id|
      reference = refs[evidence_id]
      valid = reference.is_a?(Hash) && reference["path"].is_a?(String) && reference["checksum"].to_s.match?(/\Asha256:[0-9a-f]{64}\z/)
      errors << "#{pack["pack_id"]}: passed pack missing structured evidence_ref #{evidence_id}" unless valid
      next unless valid
      path = reference["path"]
      evidence_root = acceptance["evidence_root"].to_s.sub(%r{/+\z}, "") + "/"
      errors << "#{pack["pack_id"]}: evidence path escapes evidence root #{path}" unless path.start_with?(evidence_root)
      errors << "#{pack["pack_id"]}: evidence file missing #{path}" unless File.file?(path)
      actual = File.file?(path) ? "sha256:#{Digest::SHA256.file(path).hexdigest}" : nil
      errors << "#{pack["pack_id"]}: evidence checksum mismatch #{evidence_id}" unless reference["checksum"] == actual
    end
  end
end

if errors.empty?
  readiness = corpus["status"] == "ready" && policy["armed"] == true && packs.all? { |pack| pack["status"] == "passed" }
  puts "benchmark/acceptance contract shape valid (readiness=#{readiness ? 'eligible' : 'blocked'}, corpus=#{corpus["status"]}, policy=#{policy["approval_state"]}, acceptance=#{packs.length} packs, human_quality=separate)"
else
  errors.each { |error| warn error }
  warn "benchmark/acceptance contract validation failed: #{errors.length} issue(s)"
  exit 1
end
RUBY
