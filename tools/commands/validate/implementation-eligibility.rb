#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "set"

root = File.expand_path("../../..", __dir__)
errors = []
load_yaml = lambda do |relative|
  begin
    data = YAML.safe_load(File.read(File.join(root, relative)), aliases: false)
    unless data.is_a?(Hash)
      errors << "#{relative}: root must be a mapping"
      next {}
    end
    data
  rescue StandardError => e
    errors << "#{relative}: #{e.message}"
    {}
  end
end

eligibility = load_yaml.call("artifacts/operations/implementation-eligibility.yaml")
promotion = load_yaml.call("artifacts/operations/promotion-policy.yaml")
architecture = File.read(File.join(root, "artifacts/operations/architecture-frozen.md"))

axes = eligibility["axes"]
unless axes.is_a?(Hash)
  errors << "implementation eligibility axes must be a mapping"
  axes = {}
end
expected_axes = %w[scope_lifecycle implementation_eligibility implementation_authorization release_readiness].to_set
errors << "implementation state axes drifted" unless axes.keys.to_set == expected_axes
errors << "implementation eligibility must be family-scoped" unless axes.dig("implementation_eligibility", "evaluated_per") == "capability_family"
errors << "implementation authorization must be exact-candidate-and-family scoped" unless axes.dig("implementation_authorization", "evaluated_per") == "exact_candidate_sha_and_family"
errors << "release readiness must remain release-scope evaluated" unless axes.dig("release_readiness", "evaluated_per") == "release_scope"

invariants = Array(eligibility["invariants"]).to_set
%w[
  ACTIVE_does_not_mean_implementation_authorized
  implementation_eligibility_does_not_mean_release_ready
  authorization_is_bound_to_exact_candidate_sha_and_declared_family_scope
  evidence_that_requires_runtime_is_never_required_to_start_implementation
].each do |invariant|
  errors << "implementation eligibility missing invariant #{invariant}" unless invariants.include?(invariant)
end

policy = promotion["promotion_policy"]
unless policy.is_a?(Hash)
  errors << "promotion_policy must be a mapping"
  policy = {}
end
%w[required_family_status required_owner_spec_status required_acceptance_status required_evidence_status required_decision_status planned_to_active_requires].each do |field|
  errors << "promotion policy missing #{field}" unless policy.key?(field)
end
required_transition_facts = Array(policy["planned_to_active_requires"]).to_set
%w[family_dependencies_resolved framework_dependencies_resolved asset_requirements_resolved decision_requirements_resolved evidence_requirements_resolved].each do |fact|
  errors << "promotion policy planned_to_active_requires omits #{fact}" unless required_transition_facts.include?(fact)
end
errors << "promotion policy required_decision_status may not be blank" if policy["required_decision_status"].to_s.empty?

errors << "architecture governance must explicitly state ACTIVE is product scope only" unless architecture.include?("ACTIVE` therefore means **current product scope only**")
errors << "architecture governance must separate exact-SHA authorization" unless architecture.include?("exact candidate SHA")

transition = eligibility["current_transition"] || {}
errors << "eligibility migration must keep source mutation locked until trust-policy migration completes" unless transition["source_mutation_state"] == "locked"

if errors.empty?
  puts "implementation eligibility validation passed (axes=4, decision_status=enforced, source_mutation=locked)"
else
  warn errors.join("\n")
  warn "implementation eligibility validation failed: #{errors.length} issue(s)"
  exit 1
end
