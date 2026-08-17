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

model_mutates_state = Marshal.load(Marshal.dump(base))
model_entry = model_mutates_state["decision_policies"].find { |entry| entry["unit_id"] == "evaluation.semantic_inference" }
model_entry["probabilistic_constraints"]["may_mutate_canonical_state"] = true
mutations << ["model canonical-state mutation", model_mutates_state, "may not mutate canonical state"]

missing_provenance = Marshal.load(Marshal.dump(base))
model_entry = missing_provenance["decision_policies"].find { |entry| entry["unit_id"] == "evaluation.semantic_inference" }
model_entry["provenance_required"] = []
mutations << ["missing inference provenance", missing_provenance, "missing provenance requirements"]

missing_empirical_requirement = Marshal.load(Marshal.dump(base))
model_entry = missing_empirical_requirement["decision_policies"].find { |entry| entry["unit_id"] == "evaluation.semantic_inference" }
model_entry["sufficiency"].delete("empirical_validation_required")
mutations << ["probabilistic mode skips empirical promotion proof", missing_empirical_requirement, "must require empirical validation before promotion"]

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
puts "PASS: compute-boundary projection, sufficiency, mutation and agent-routing tests"
