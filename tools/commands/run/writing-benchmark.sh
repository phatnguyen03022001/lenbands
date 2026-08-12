#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

dataset="artifacts/operations/benchmark/gold-corpus-manifest.yaml"
results=""
policy="artifacts/operations/benchmark/numeric-threshold-policy.yaml"
output=""
reviewer=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dataset) dataset="$2"; shift 2 ;;
    --results) results="$2"; shift 2 ;;
    --policy) policy="$2"; shift 2 ;;
    --output) output="$2"; shift 2 ;;
    --reviewed-by) reviewer="$2"; shift 2 ;;
    *) echo "usage: $0 [--dataset path] --results path --policy path --output evidence/benchmark-run.yaml --reviewed-by owner" >&2; exit 64 ;;
  esac
done

ruby -Itools/lib -rlenbands -rlenbands/yaml_loader -rdigest -rtime - "$dataset" "$results" "$policy" "$output" "$reviewer" <<'RUBY'
dataset_path, results_path, policy_path, output_path, reviewer = ARGV
root = File.expand_path(Dir.pwd)
evidence_root = File.join(root, "artifacts/operations/evidence")
blocked = []
dataset = Lenbands::YamlLoader.load_file(dataset_path, mapping: true)
policy = Lenbands::YamlLoader.load_file(policy_path, mapping: true)

blocked << "gold_corpus_not_ready" unless dataset["status"] == "ready"
blocked << "gold_corpus_rights_not_verified" unless dataset["rights_status"] == "verified"
blocked << "gold_corpus_labels_not_verified" unless dataset["label_status"] == "verified"
blocked << "gold_corpus_empty_or_below_minimum" if dataset["gold_case_count"].to_i < dataset["minimum_gold_cases_policy"].to_i
blocked << "threshold_policy_not_armed" unless policy["armed"] == true && policy["approval_state"] == "approved"
blocked << "numeric_cost_ceiling_missing" unless policy.dig("cost", "cost_per_accepted_evaluation_usd_max").is_a?(Numeric)
blocked << "reviewer_missing" if reviewer.to_s.empty?
blocked << "results_missing" if results_path.to_s.empty? || !File.file?(results_path.to_s)
expanded_output = output_path.to_s.empty? ? nil : File.expand_path(output_path, root)
blocked << "output_must_be_yaml_evidence_record" unless expanded_output&.end_with?(".yaml")
blocked << "output_must_stay_in_operations_evidence" unless expanded_output&.start_with?("#{evidence_root}/")

unless blocked.empty?
  warn "benchmark run blocked: #{blocked.join(", ")}"
  exit 2
end

results = Lenbands::YamlLoader.load_file(results_path, mapping: true)
cases = Array(dataset["cases"])
abort("dataset cases must not be empty") if cases.empty?
case_ids = cases.map { |item| item["case_id"] }
abort("dataset contains duplicate case IDs") unless case_ids.uniq.length == case_ids.length
raw_predictions = Array(results["results"])
abort("benchmark results must not be empty") if raw_predictions.empty?
prediction_ids = raw_predictions.map { |item| item["case_id"] }
abort("results contain duplicate case IDs") unless prediction_ids.uniq.length == prediction_ids.length
predictions = raw_predictions.to_h { |item| [item["case_id"], item] }
criteria = %w[task_response coherence_cohesion lexical_resource grammar]
missing = case_ids.reject { |case_id| predictions.key?(case_id) }
abort("missing result case IDs: #{missing.join(", ")}") unless missing.empty?
abort("result count mismatch") unless predictions.length == cases.length
abort("results contain unknown case IDs") unless prediction_ids.sort == case_ids.sort

criterion_errors = []
overall_errors = []
within_half = 0
evidence_valid = 0
actionable = 0
withheld_correctly = 0
false_acceptances = 0
latencies = []
costs = []
cases.each do |item|
  prediction = predictions.fetch(item["case_id"])
  abort("#{item["case_id"]}: evidence_valid must be boolean") unless [true, false].include?(prediction["evidence_valid"])
  abort("#{item["case_id"]}: actionable must be boolean") unless [true, false].include?(prediction["actionable"])
  abort("#{item["case_id"]}: expected_withheld must be boolean") unless [true, false].include?(prediction["expected_withheld"])
  abort("#{item["case_id"]}: quality_status missing") if prediction["quality_status"].to_s.empty?
  criteria.each do |criterion|
    value = prediction.dig("prediction", "criteria", criterion)
    abort("#{item["case_id"]}: #{criterion} prediction must be numeric") unless value.is_a?(Numeric)
    criterion_errors << (value - item.dig("reference", "criteria", criterion).to_f).abs
  end
  overall = prediction.dig("prediction", "overall_band")
  abort("#{item["case_id"]}: overall_band prediction must be numeric") unless overall.is_a?(Numeric)
  overall_error = (overall - item.dig("reference", "overall_band").to_f).abs
  overall_errors << overall_error
  within_half += 1 if overall_error <= 0.5
  evidence_valid += 1 if prediction["evidence_valid"] == true
  actionable += 1 if prediction["actionable"] == true
  withheld_correctly += 1 if prediction["expected_withheld"] == true && prediction["quality_status"] != "accepted"
  false_acceptances += 1 if prediction["expected_withheld"] == true && prediction["quality_status"] == "accepted"
  abort("#{item["case_id"]}: latency_ms must be numeric") unless prediction["latency_ms"].is_a?(Numeric)
  abort("#{item["case_id"]}: cost_usd must be numeric") unless prediction["cost_usd"].is_a?(Numeric)
  latencies << prediction["latency_ms"]
  costs << prediction["cost_usd"]
end

mean = lambda do |values|
  abort("cannot calculate mean for an empty sample") if values.empty?
  values.sum / values.length.to_f
end
p95 = lambda do |values|
  abort("cannot calculate p95 for an empty sample") if values.empty?
  values.sort.fetch((values.length * 0.95).ceil - 1)
end
metrics = {
  "criterion_mae_band" => mean.call(criterion_errors),
  "overall_mae_band" => mean.call(overall_errors),
  "within_half_band" => within_half / cases.length.to_f,
  "evidence_coverage" => evidence_valid / cases.length.to_f,
  "actionable_feedback" => actionable / cases.length.to_f,
  "invalid_or_low_confidence_withheld" => withheld_correctly / cases.length.to_f,
  "false_acceptance_rate" => false_acceptances / cases.length.to_f,
  "p95_latency_ms" => p95.call(latencies),
  "cost_per_accepted_evaluation_usd" => mean.call(costs)
}
thresholds = policy.fetch("quality")
pass = metrics["criterion_mae_band"] <= thresholds["criterion_mae_max_band"] &&
       metrics["overall_mae_band"] <= thresholds["overall_mae_max_band"] &&
       metrics["within_half_band"] >= thresholds["within_half_band_min"] &&
       metrics["evidence_coverage"] >= thresholds["evidence_coverage_min"] &&
       metrics["actionable_feedback"] >= thresholds["actionable_feedback_min"] &&
       metrics["invalid_or_low_confidence_withheld"] >= thresholds["invalid_or_low_confidence_withheld_min"] &&
       metrics["false_acceptance_rate"] <= thresholds["false_acceptance_max"] &&
       metrics["p95_latency_ms"] <= thresholds["p95_latency_ms_max"] &&
       metrics["cost_per_accepted_evaluation_usd"] <= policy.dig("cost", "cost_per_accepted_evaluation_usd_max")

abort("output path is required") if expanded_output.nil?
abort("refusing to overwrite benchmark evidence") if File.exist?(expanded_output) || File.exist?("#{expanded_output}.meta.yaml")
abort("output parent directory is missing") unless File.directory?(File.dirname(expanded_output))

run_id = "benchmark-#{Time.now.utc.strftime("%Y%m%dT%H%M%SZ")}-#{Digest::SHA256.hexdigest(File.read(dataset_path) + File.read(results_path))[0, 12]}"
output = {
  "benchmark_run_id" => run_id,
  "dataset_id" => dataset["dataset_id"],
  "dataset_version" => dataset["dataset_version"],
  "rubric_version" => dataset.dig("reference_label_requirements", "rubric_version"),
  "prompt_template_id" => results["prompt_template_id"],
  "model_version" => results["model_version"],
  "quality_metrics" => metrics,
  "threshold_policy_id" => policy["policy_id"],
  "decision" => pass ? "promote" : "hold",
  "reviewed_by" => reviewer,
  "reviewed_at" => Time.now.utc.iso8601
}
File.write(expanded_output, output.to_yaml)
payload_hash = Digest::SHA256.file(expanded_output).hexdigest
File.write("#{expanded_output}.meta.yaml", {
  "type" => "benchmark-run",
  "status" => "review",
  "version" => "1.0.0",
  "owner" => "operations",
  "representation" => "yaml",
  "derived_from" => ["EVAL.Writing", "GOVERNANCE.GoldStandardBenchmark", "OPS.EvaluationQuality"],
  "purpose" => "immutable-writing-evaluation-benchmark-run",
  "consumed_by" => ["operations", "engineering"],
  "created_at" => Time.now.utc.strftime("%Y-%m-%d"),
  "updated_at" => Time.now.utc.strftime("%Y-%m-%d"),
  "evidence_id" => run_id,
  "payload_sha256" => "sha256:#{payload_hash}",
  "immutable" => true
}.to_yaml)
puts output.to_yaml
RUBY
