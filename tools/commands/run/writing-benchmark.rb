#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"
export LENBANDS_RUNNER_PATH="$0"

dataset="artifacts/operations/benchmark/gold-corpus-manifest.yaml"
results=""
policy="artifacts/operations/benchmark/numeric-threshold-policy.yaml"
quality_review=""
output=""
reviewer=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dataset) dataset="$2"; shift 2 ;;
    --results) results="$2"; shift 2 ;;
    --policy) policy="$2"; shift 2 ;;
    --quality-review) quality_review="$2"; shift 2 ;;
    --output) output="$2"; shift 2 ;;
    --reviewed-by) reviewer="$2"; shift 2 ;;
    *) echo "usage: $0 [--dataset path] --results path --policy path --quality-review path --output evidence/benchmark-run.yaml --reviewed-by owner" >&2; exit 64 ;;
  esac
done

ruby -Itools/lib -rlenbands -rlenbands/yaml_loader -rdigest -rtime - "$dataset" "$results" "$policy" "$quality_review" "$output" "$reviewer" <<'RUBY'
dataset_path, results_path, policy_path, quality_review_path, output_path, reviewer = ARGV
root = File.expand_path(Dir.pwd)
evidence_root = File.join(root, "artifacts/operations/evidence")
runner_path = File.expand_path(ENV.fetch("LENBANDS_RUNNER_PATH"), root)

dataset = Lenbands::YamlLoader.load_file(dataset_path, mapping: true)
policy = Lenbands::YamlLoader.load_file(policy_path, mapping: true)
blocked = []
blocked << "gold_corpus_not_ready" unless dataset["status"] == "ready"
blocked << "gold_corpus_rights_not_verified" unless dataset["rights_status"] == "verified"
blocked << "gold_corpus_labels_not_verified" unless dataset["label_status"] == "verified"
blocked << "gold_corpus_empty_or_below_minimum" if dataset["gold_case_count"].to_i < dataset["minimum_gold_cases_policy"].to_i
blocked << "threshold_policy_not_armed" unless policy["armed"] == true && policy["approval_state"] == "approved"
blocked << "numeric_cost_ceiling_missing" unless policy.dig("cost", "cost_per_accepted_evaluation_usd_max").is_a?(Numeric)
blocked << "results_missing" if results_path.to_s.empty? || !File.file?(results_path.to_s)
blocked << "quality_review_missing" if quality_review_path.to_s.empty? || !File.file?(quality_review_path.to_s)
blocked << "reviewer_missing" if reviewer.to_s.empty?
expanded_output = output_path.to_s.empty? ? nil : File.expand_path(output_path, root)
blocked << "output_must_be_yaml_evidence_record" unless expanded_output&.end_with?(".yaml")
blocked << "output_must_stay_in_operations_evidence" unless expanded_output&.start_with?("#{evidence_root}/")
unless blocked.empty?
  warn "benchmark run blocked: #{blocked.join(', ')}"
  exit 2
end

results = Lenbands::YamlLoader.load_file(results_path, mapping: true)
quality_review = Lenbands::YamlLoader.load_file(quality_review_path, mapping: true)
candidate_sha = results["candidate_sha"].to_s
abort("results candidate_sha must be a full commit SHA") unless candidate_sha.match?(/\A[0-9a-f]{40}\z/)
scorer_route_version = results["scorer_route_version"].to_s
abort("results scorer_route_version is required") if scorer_route_version.empty?
abort("candidate results may not supply expected_withheld/must_withhold_score") if File.read(results_path).match?(/expected_withheld|must_withhold_score/)

cases = Array(dataset["cases"])
abort("dataset cases must not be empty") if cases.empty?
case_ids = cases.map { |item| item["case_id"] }
abort("dataset contains duplicate case IDs") unless case_ids.uniq.length == case_ids.length
cases.each do |item|
  reference = item["reference"]
  abort("#{item['case_id']}: reference must be a mapping") unless reference.is_a?(Hash)
  abort("#{item['case_id']}: gold must_withhold_score must be boolean") unless [true, false].include?(reference["must_withhold_score"])
  abort("#{item['case_id']}: gold evidence_refs must be non-empty") if Array(reference["evidence_refs"]).empty?
end
withhold_case_count = cases.count { |item| item.dig("reference", "must_withhold_score") == true }
abort("gold corpus must include at least one must_withhold_score case") if withhold_case_count.zero?

raw_predictions = Array(results["results"])
abort("benchmark results must not be empty") if raw_predictions.empty?
prediction_ids = raw_predictions.map { |item| item["case_id"] }
abort("results contain duplicate case IDs") unless prediction_ids.uniq.length == prediction_ids.length
abort("result IDs differ from gold corpus") unless prediction_ids.sort == case_ids.sort
predictions = raw_predictions.to_h { |item| [item["case_id"], item] }

criteria = %w[task_response coherence_cohesion lexical_resource grammar]
criterion_errors = []
overall_errors = []
within_half = 0
withheld_correctly = 0
false_acceptances = 0
latencies = []
accepted_costs = []

cases.each do |item|
  prediction = predictions.fetch(item["case_id"])
  quality_status = prediction["quality_status"]
  abort("#{item['case_id']}: invalid quality_status") unless %w[accepted low_confidence insufficient_evidence invalid unavailable delayed].include?(quality_status)
  criteria.each do |criterion|
    value = prediction.dig("prediction", "criteria", criterion)
    abort("#{item['case_id']}: #{criterion} prediction must be numeric") unless value.is_a?(Numeric)
    reference = item.dig("reference", "criteria", criterion)
    abort("#{item['case_id']}: #{criterion} gold label must be numeric") unless reference.is_a?(Numeric)
    criterion_errors << (value - reference).abs
  end
  overall = prediction.dig("prediction", "overall_band")
  reference_overall = item.dig("reference", "overall_band")
  abort("#{item['case_id']}: overall prediction must be numeric") unless overall.is_a?(Numeric)
  abort("#{item['case_id']}: overall gold label must be numeric") unless reference_overall.is_a?(Numeric)
  error = (overall - reference_overall).abs
  overall_errors << error
  within_half += 1 if error <= 0.5

  must_withhold = item.dig("reference", "must_withhold_score")
  accepted = quality_status == "accepted"
  withheld_correctly += 1 if must_withhold && !accepted
  false_acceptances += 1 if must_withhold && accepted

  latency = prediction["latency_ms"]
  cost = prediction["cost_usd"]
  abort("#{item['case_id']}: latency_ms must be numeric") unless latency.is_a?(Numeric)
  abort("#{item['case_id']}: cost_usd must be numeric") unless cost.is_a?(Numeric)
  latencies << latency
  accepted_costs << cost if accepted
end

mean = ->(values) { values.sum / values.length.to_f }
p95 = ->(values) { values.sort.fetch((values.length * 0.95).ceil - 1) }
metrics = {
  "criterion_mae_band" => mean.call(criterion_errors),
  "overall_mae_band" => mean.call(overall_errors),
  "within_half_band" => within_half / cases.length.to_f,
  "invalid_or_low_confidence_withheld" => withheld_correctly / withhold_case_count.to_f,
  "false_acceptance_rate" => false_acceptances / withhold_case_count.to_f,
  "p95_latency_ms" => p95.call(latencies),
  "cost_per_accepted_evaluation_usd" => accepted_costs.empty? ? nil : mean.call(accepted_costs)
}

quality_thresholds = policy.fetch("quality")
numeric_pass = metrics["criterion_mae_band"] <= quality_thresholds["criterion_mae_max_band"] &&
               metrics["overall_mae_band"] <= quality_thresholds["overall_mae_max_band"] &&
               metrics["within_half_band"] >= quality_thresholds["within_half_band_min"] &&
               metrics["false_acceptance_rate"] <= quality_thresholds["false_acceptance_max"] &&
               metrics["p95_latency_ms"] <= quality_thresholds["p95_latency_ms_max"] &&
               metrics["cost_per_accepted_evaluation_usd"].is_a?(Numeric) &&
               metrics["cost_per_accepted_evaluation_usd"] <= policy.dig("cost", "cost_per_accepted_evaluation_usd_max")

abort("quality review candidate_sha mismatch") unless quality_review["candidate_sha"] == candidate_sha
abort("quality review dataset_id mismatch") unless quality_review["dataset_id"] == dataset["dataset_id"]
abort("quality review dataset_version mismatch") unless quality_review["dataset_version"] == dataset["dataset_version"]
abort("quality review must be approved") unless quality_review["status"] == "approved"
review_policy = policy.fetch("human_quality_review")
evidence_validity = quality_review["evidence_validity"]
actionability = quality_review["actionable_feedback"]
abort("quality review evidence_validity must be numeric") unless evidence_validity.is_a?(Numeric)
abort("quality review actionable_feedback must be numeric") unless actionability.is_a?(Numeric)
human_pass = evidence_validity >= review_policy["evidence_validity_min"] && actionability >= review_policy["actionable_feedback_min"]

abort("output path is required") if expanded_output.nil?
abort("refusing to overwrite benchmark evidence") if File.exist?(expanded_output) || File.exist?("#{expanded_output}.meta.yaml")
abort("output parent directory is missing") unless File.directory?(File.dirname(expanded_output))

dataset_sha = Digest::SHA256.file(dataset_path).hexdigest
policy_sha = Digest::SHA256.file(policy_path).hexdigest
results_sha = Digest::SHA256.file(results_path).hexdigest
quality_review_sha = Digest::SHA256.file(quality_review_path).hexdigest
runner_sha = Digest::SHA256.file(runner_path).hexdigest
run_id = "benchmark-#{Time.now.utc.strftime('%Y%m%dT%H%M%SZ')}-#{results_sha[0, 12]}"
output = {
  "benchmark_run_id" => run_id,
  "candidate_sha" => candidate_sha,
  "dataset_id" => dataset["dataset_id"],
  "dataset_version" => dataset["dataset_version"],
  "dataset_sha256" => "sha256:#{dataset_sha}",
  "threshold_policy_id" => policy["policy_id"],
  "policy_sha256" => "sha256:#{policy_sha}",
  "results_sha256" => "sha256:#{results_sha}",
  "human_quality_review_sha256" => "sha256:#{quality_review_sha}",
  "runner_sha256" => "sha256:#{runner_sha}",
  "scorer_route_version" => scorer_route_version,
  "quality_metrics" => metrics,
  "human_quality_metrics" => {"evidence_validity" => evidence_validity, "actionable_feedback" => actionability},
  "decision" => numeric_pass && human_pass ? "promote" : "hold",
  "reviewed_by" => reviewer,
  "reviewed_at" => Time.now.utc.iso8601
}
File.write(expanded_output, output.to_yaml)
payload_hash = Digest::SHA256.file(expanded_output).hexdigest
File.write("#{expanded_output}.meta.yaml", {
  "type" => "benchmark-run",
  "status" => "review",
  "version" => "1.1.0",
  "owner" => "operations",
  "representation" => "yaml",
  "derived_from" => ["EVAL.Writing", "GOVERNANCE.GoldStandardBenchmark", "OPS.EvaluationQuality"],
  "purpose" => "immutable-writing-evaluation-benchmark-run",
  "created_at" => Time.now.utc.strftime("%Y-%m-%d"),
  "updated_at" => Time.now.utc.strftime("%Y-%m-%d"),
  "evidence_id" => run_id,
  "payload_sha256" => "sha256:#{payload_hash}",
  "immutable" => true
}.to_yaml)
puts output.to_yaml
RUBY
