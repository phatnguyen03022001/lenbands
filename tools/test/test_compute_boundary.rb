#!/usr/bin/env ruby
# frozen_string_literal: true

require "open3"
require "tempfile"
require "yaml"

root = File.expand_path("../..", __dir__)
validator = File.join(root, "tools/commands/validate/compute-boundary.rb")
policy_path = File.join(root, "artifacts/operations/execution-policy.yaml")
errors = []

run_policy = lambda do |data|
  Tempfile.create(["lenbands-execution-policy", ".yaml"]) do |file|
    file.write(data.to_yaml)
    file.flush
    Open3.capture3("ruby", validator, "--policy", file.path, chdir: root)
  end
end

stdout, stderr, status = Open3.capture3("ruby", validator, chdir: root)
errors << "base compute-boundary validator failed: #{stdout}#{stderr}" unless status.success?

base = YAML.safe_load(File.read(policy_path), aliases: false)
mutations = []

orphan = Marshal.load(Marshal.dump(base))
orphan["decision_policies"][0]["unit_id"] = "daily_action.invented_by_policy"
mutations << ["orphan decision unit", orphan, "invented orphan decision unit"]

wrong_owner = Marshal.load(Marshal.dump(base))
wrong_owner["decision_policies"][0]["domain_meta_ref"] = "artifacts/engineering/contracts/evaluation/evaluation-contract.meta.yaml"
mutations << ["wrong exact owner binding", wrong_owner, "bound to wrong owner"]

duplicate = Marshal.load(Marshal.dump(base))
duplicate["decision_policies"] << Marshal.load(Marshal.dump(duplicate["decision_policies"][0]))
mutations << ["duplicate unit", duplicate, "duplicate execution-policy entry"]

probabilistic_substitution = Marshal.load(Marshal.dump(base))
probabilistic_substitution["decision_policies"][0]["probabilistic_executor_allowed"] = true
mutations << ["deterministic probabilistic substitution", probabilistic_substitution, "cannot allow a probabilistic executor"]

missing_sufficiency = Marshal.load(Marshal.dump(base))
missing_sufficiency["decision_policies"][0].delete("sufficiency")
mutations << ["missing sufficiency evidence", missing_sufficiency, "missing sufficiency evidence"]

missing_evidence_level = Marshal.load(Marshal.dump(base))
missing_evidence_level["decision_policies"][0]["sufficiency"].delete("evidence_level")
mutations << ["missing sufficiency evidence level", missing_evidence_level, "missing/invalid sufficiency evidence_level"]

false_empirical_claim = Marshal.load(Marshal.dump(base))
false_empirical_claim["decision_policies"][0]["sufficiency"]["verdict"] = "empirically_validated_for_release"
mutations << ["design evidence claims empirical validity", false_empirical_claim, "design evidence may not claim empirical validity"]

empirical_without_run = Marshal.load(Marshal.dump(base))
empirical_without_run["decision_policies"][0]["sufficiency"]["evidence_level"] = "empirical"
empirical_without_run["decision_policies"][0]["sufficiency"]["verdict"] = "empirical_sufficient"
mutations << ["empirical evidence without bound run", empirical_without_run, "empirical sufficiency requires bound empirical_evidence_refs"]

weaken_dimensions = Marshal.load(Marshal.dump(base))
weaken_dimensions["sufficiency_evaluation"]["required_dimensions"].delete("privacy")
mutations << ["compute selection drops privacy dimension", weaken_dimensions, "sufficiency dimensions drifted"]

missing_profile = Marshal.load(Marshal.dump(base))
missing_profile["decision_policies"][0]["sufficiency"]["constraint_profile"] = "unknown_profile"
mutations << ["decision unit loses cross-cutting sufficiency binding", missing_profile, "missing/unknown constraint_profile"]

profile_drops_privacy = Marshal.load(Marshal.dump(base))
profile_drops_privacy["sufficiency_profiles"]["p0_deterministic_domain"]["dimensions"].delete("privacy")
mutations << ["sufficiency profile drops privacy", profile_drops_privacy, "cross-cutting dimensions drifted"]

profile_invents_semantics = Marshal.load(Marshal.dump(base))
profile_invents_semantics["sufficiency_profiles"]["p0_deterministic_domain"]["canonical_compute_mode"] = "deterministic"
mutations << ["sufficiency profile invents semantic decision", profile_invents_semantics, "may not define semantic/decision key canonical_compute_mode"]

model_mutates_state = Marshal.load(Marshal.dump(base))
model_entry = model_mutates_state["decision_policies"].find { |entry| entry["unit_id"] == "evaluation.semantic_inference" }
model_entry["probabilistic_constraints"]["may_mutate_canonical_state"] = true
mutations << ["model canonical-state mutation", model_mutates_state, "may not mutate canonical state"]

missing_provenance = Marshal.load(Marshal.dump(base))
model_entry = missing_provenance["decision_policies"].find { |entry| entry["unit_id"] == "evaluation.semantic_inference" }
model_entry["provenance_required"] = []
mutations << ["missing inference provenance", missing_provenance, "missing provenance requirements"]

missing_lower_mode = Marshal.load(Marshal.dump(base))
model_entry = missing_lower_mode["decision_policies"].find { |entry| entry["unit_id"] == "evaluation.semantic_inference" }
model_entry["sufficiency"]["lower_mode_rejections"].delete("specialized_model_api")
mutations << ["generative mode skips specialized lower mode", missing_lower_mode, "lower-mode rejection set drifted"]

extra_lower_mode = Marshal.load(Marshal.dump(base))
model_entry = extra_lower_mode["decision_policies"].find { |entry| entry["unit_id"] == "evaluation.semantic_inference" }
model_entry["sufficiency"]["lower_mode_rejections"]["generative_model"] = "self"
mutations << ["lower-mode map includes current mode", extra_lower_mode, "lower-mode rejection set drifted"]

missing_empirical_requirement = Marshal.load(Marshal.dump(base))
model_entry = missing_empirical_requirement["decision_policies"].find { |entry| entry["unit_id"] == "evaluation.semantic_inference" }
model_entry["sufficiency"].delete("empirical_validation_required")
mutations << ["probabilistic mode skips empirical promotion proof", missing_empirical_requirement, "must require empirical validation before promotion"]

presentation_substitution = Marshal.load(Marshal.dump(base))
presentation = presentation_substitution["decision_policies"].find { |entry| entry["unit_id"] == "evaluation.presentation_wording" }
presentation["canonical_compute_mode"] = "generative_model"
presentation["probabilistic_executor_allowed"] = true
presentation["inference_executor"] = "governed_model_route"
presentation["sufficiency"]["constraint_profile"] = "p0_writing_semantic_inference"
presentation["sufficiency"]["lower_mode_rejections"] = {
  "deterministic" => "claimed",
  "statistical_optimization" => "claimed",
  "specialized_model_api" => "claimed"
}
presentation["sufficiency"]["empirical_validation_required"] = true
presentation["probabilistic_constraints"] = {"candidate_only" => true, "may_mutate_canonical_state" => false}
presentation["provenance_required"] = ["evaluation_id"]
mutations << ["P0 presentation silently becomes generative", presentation_substitution, "must use deterministic compute"]

future_unit = Marshal.load(Marshal.dump(base))
future_unit["future_capability_defaults"][0]["unit_id"] = "personal.future_invented_unit"
mutations << ["future policy invents unit", future_unit, "may not define unit_id"]

mutations.each do |label, data, expected|
  _stdout, mutation_stderr, mutation_status = run_policy.call(data)
  if mutation_status.success?
    errors << "#{label}: mutation unexpectedly passed"
  elsif !mutation_stderr.include?(expected)
    errors << "#{label}: expected failure marker #{expected.inspect}, got #{mutation_stderr.inspect}"
  end
end

docs = YAML.safe_load(File.read(File.join(root, "DOCS.yaml")), aliases: false)
expected_compute_ownership = %w[decision_compute_boundaries probabilistic_inference_pipeline algorithmic_vs_inference_grouping compute_mode_change_gate]
errors << "DOCS learning_engines regained broad domain-semantic ownership" unless Array(docs.dig("authority", "learning_engines", "owns")) == expected_compute_ownership

agent_markers = {
  ".claude/agents/repo-cartographer.md" => ["exact `decision_units[].unit_id`", "never treat the execution-policy projection as semantic authority"],
  ".claude/agents/contract-deepener.md" => ["execution-policy.yaml` may only project an existing exact unit", "probabilistic outputs remain typed candidate inference"],
  ".claude/agents/red-team-reviewer.md" => ["classifiers, embeddings, rerankers, remote model APIs", "compute-mode changes hidden inside"],
  ".claude/agents/runtime-composer.md" => ["actual computation does not exceed the projected compute mode", "A deterministic unit may not call a classifier"],
  ".claude/agents/runtime-integration-verifier.md" => ["canonical compute mode vs actual executor/dependencies", "blocking substitution"],
  ".claude/agents/verification-auditor.md" => ["compute-boundary mutation tests", "deterministic units reject probabilistic substitution"],
  ".claude/agents/ielts-semantics-auditor.md" => ["intermediate semantic interpretation from canonical semantic fact", "cannot redefine or invent canonical IELTS/LenBands semantics"]
}

agent_markers.each do |relative_path, markers|
  body = File.read(File.join(root, relative_path))
  markers.each do |marker|
    errors << "#{relative_path} lost compute-boundary routing marker: #{marker}" unless body.include?(marker)
  end
end

abort(errors.join("\n")) unless errors.empty?
puts "PASS: compute-boundary projection, exact sufficiency, lower-mode, mutation and agent-routing tests"
