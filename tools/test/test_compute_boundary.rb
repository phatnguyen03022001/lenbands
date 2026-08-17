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

model_mutates_state = Marshal.load(Marshal.dump(base))
model_entry = model_mutates_state["decision_policies"].find { |entry| entry["unit_id"] == "evaluation.semantic_inference" }
model_entry["probabilistic_constraints"]["may_mutate_canonical_state"] = true
mutations << ["model canonical-state mutation", model_mutates_state, "may not mutate canonical state"]

missing_provenance = Marshal.load(Marshal.dump(base))
model_entry = missing_provenance["decision_policies"].find { |entry| entry["unit_id"] == "evaluation.semantic_inference" }
model_entry["provenance_required"] = []
mutations << ["missing inference provenance", missing_provenance, "missing provenance requirements"]

future_unit = Marshal.load(Marshal.dump(base))
future_unit["future_capability_defaults"][0]["unit_id"] = "personal.future_invented_unit"
mutations << ["future policy invents unit", future_unit, "may not define unit_id"]

mutations.each do |label, data, expected|
  _stdout, stderr, status = run_policy.call(data)
  if status.success?
    errors << "#{label}: mutation unexpectedly passed"
  elsif !stderr.include?(expected)
    errors << "#{label}: expected failure marker #{expected.inspect}, got #{stderr.inspect}"
  end
end

abort(errors.join("\n")) unless errors.empty?
puts "PASS: compute-boundary projection and mutation tests"
