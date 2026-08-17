#!/usr/bin/env ruby
# frozen_string_literal: true

require "set"

$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)
require "lenbands"
require "lenbands/yaml_loader"

root = ENV.fetch("LENBANDS_ROOT", File.expand_path("../../..", __dir__))
errors = []
policy_path = File.join(root, "artifacts/operations/execution-policy.yaml")
if ARGV.any?
  unless ARGV.length == 2 && ARGV[0] == "--policy"
    abort "usage: compute-boundary.rb [--policy PATH]"
  end
  policy_path = File.expand_path(ARGV[1])
end

load_yaml = lambda do |path|
  Lenbands::YamlLoader.load_file(path, mapping: true)
rescue Lenbands::YamlError => e
  errors << e.message
  {}
end

policy = load_yaml.call(policy_path)
docs = load_yaml.call(File.join(root, "DOCS.yaml"))
features_path = File.join(root, "blueprint/03-features.md")
features = File.file?(features_path) ? File.read(features_path) : ""
capability_ids = features.scan(/`([A-Z][A-Z0-9_]*\.[A-Za-z][A-Za-z0-9_]*)`/).flatten.to_set

errors << "execution policy must be a non-authoritative projection" unless policy["source_of_truth"] == false && policy["authority_class"] == "projection"
errors << "execution policy projection_id drifted" unless policy["projection_id"] == "compute-execution-policy"

expected_modes = %w[deterministic statistical_optimization specialized_model_api generative_model]
errors << "compute modes drifted" unless Array(policy["compute_modes"]) == expected_modes
errors << "lowest-sufficient selection order drifted" unless Array(policy["selection_order"]) == expected_modes

principles = Array(policy["architecture_principles"]).to_set
%w[
  domain_contracts_own_canonical_semantics_and_decisions
  execution_policy_projects_lowest_sufficient_computation_for_exact_canonical_decision_units
  probabilistic_components_are_inference_executors_never_canonical_decision_owners
  generated_presentation_is_non_authoritative_and_cannot_mutate_facts_or_decisions
  compute_mode_change_is_a_governed_architectural_change_not_an_implementation_optimization
  probabilistic_output_must_bind_evidence_and_provenance_before_domain_acceptance
].each { |item| errors << "execution policy missing principle #{item}" unless principles.include?(item) }

projection_rules = policy["projection_rules"] || {}
{
  "policy_may_not_create_capabilities" => true,
  "policy_may_not_create_decision_units" => true,
  "exact_domain_unit_binding_required" => true,
  "fuzzy_unit_matching_forbidden" => true,
  "canonical_semantics_remain_in_domain_owner" => true,
  "model_output_is_candidate_inference_only" => true,
  "canonical_state_mutation_requires_deterministic_domain_decision" => true,
  "higher_compute_mode_requires_lower_mode_insufficiency_evidence" => true,
  "future_defaults_do_not_authorize_implementation" => true
}.each do |key, value|
  errors << "execution projection rule #{key} drifted" unless projection_rules[key] == value
end

projection_entry = docs.dig("projections", "execution_policy")
unless projection_entry.is_a?(Hash)
  errors << "DOCS.yaml must register execution_policy under projections, not authority"
else
  errors << "DOCS execution-policy projection path drifted" unless projection_entry["path"] == "artifacts/operations/execution-policy.yaml"
  errors << "DOCS execution-policy projection may not claim semantic ownership" unless Array(projection_entry["owns"]).empty?
  errors << "DOCS execution-policy projection must be non-authoritative" unless projection_entry["authority_state"] == "projection"
end
if docs.fetch("authority", {}).values.any? { |entry| entry.is_a?(Hash) && entry["path"] == "artifacts/operations/execution-policy.yaml" }
  errors << "execution-policy must not be registered as canonical authority"
end

source_by_ref = {}
unit_by_id = {}
Array(policy["canonical_unit_sources"]).each do |source|
  ref = source["meta_ref"].to_s
  version = source["contract_version"].to_s
  if ref.empty? || version.empty?
    errors << "canonical unit source requires meta_ref and contract_version"
    next
  end
  path = File.join(root, ref)
  unless File.file?(path)
    errors << "canonical decision-unit source missing: #{ref}"
    next
  end
  meta = load_yaml.call(path)
  errors << "decision-unit source version mismatch #{ref}: policy=#{version} owner=#{meta["version"]}" unless meta["version"].to_s == version
  source_by_ref[ref] = meta
  units = Array(meta["decision_units"])
  errors << "canonical decision-unit source has no decision_units: #{ref}" if units.empty?
  units.each do |unit|
    unit_id = unit["unit_id"].to_s
    caps = Array(unit["capability_ids"])
    errors << "decision unit missing stable unit_id in #{ref}" if unit_id.empty?
    errors << "decision unit #{unit_id} has no capability_ids" if caps.empty?
    errors << "duplicate canonical decision unit #{unit_id}" if unit_by_id.key?(unit_id)
    caps.each do |capability_id|
      errors << "decision unit #{unit_id} references unknown capability #{capability_id}" unless capability_ids.include?(capability_id)
      errors << "decision unit #{unit_id} capability #{capability_id} is not derived_from #{ref}" unless Array(meta["derived_from"]).include?(capability_id)
    end
    unit_by_id[unit_id] = {"source" => ref, "capabilities" => caps, "meta" => meta}
  end
end

seen_units = Set.new
Array(policy["decision_policies"]).each do |entry|
  capability_id = entry["capability_id"].to_s
  unit_id = entry["unit_id"].to_s
  ref = entry["domain_meta_ref"].to_s
  version = entry["domain_contract_version"].to_s
  mode = entry["canonical_compute_mode"].to_s

  errors << "decision policy references unknown capability #{capability_id}" unless capability_ids.include?(capability_id)
  errors << "duplicate execution-policy entry for decision unit #{unit_id}" if seen_units.include?(unit_id)
  seen_units << unit_id

  canonical = unit_by_id[unit_id]
  if canonical.nil?
    errors << "execution policy invented orphan decision unit #{unit_id}"
    next
  end
  errors << "decision unit #{unit_id} bound to wrong owner #{ref}; expected #{canonical["source"]}" unless canonical["source"] == ref
  errors << "decision unit #{unit_id} capability binding mismatch #{capability_id}" unless canonical["capabilities"].include?(capability_id)
  errors << "decision unit #{unit_id} owner version mismatch" unless canonical["meta"]["version"].to_s == version
  errors << "decision unit #{unit_id} uses unknown compute mode #{mode}" unless expected_modes.include?(mode)
  errors << "decision unit #{unit_id} must be Tier A in the current exact-unit projection" unless entry["tier"] == "A"

  sufficiency = entry["sufficiency"]
  unless sufficiency.is_a?(Hash)
    errors << "decision unit #{unit_id} missing sufficiency evidence"
    sufficiency = {}
  end
  errors << "decision unit #{unit_id} missing outcome_contract" if sufficiency["outcome_contract"].to_s.empty?
  errors << "decision unit #{unit_id} missing quality_requirement" if sufficiency["quality_requirement"].to_s.empty?
  evidence_refs = Array(sufficiency["evidence_refs"])
  errors << "decision unit #{unit_id} missing sufficiency evidence_refs" if evidence_refs.empty?
  evidence_refs.each do |evidence_ref|
    errors << "decision unit #{unit_id} sufficiency evidence missing: #{evidence_ref}" unless File.file?(File.join(root, evidence_ref.to_s))
  end
  errors << "decision unit #{unit_id} missing sufficiency verdict" if sufficiency["verdict"].to_s.empty?

  if mode == "deterministic"
    errors << "deterministic unit #{unit_id} cannot allow a probabilistic executor" unless entry["probabilistic_executor_allowed"] == false
    errors << "deterministic unit #{unit_id} must have inference_executor=none" unless entry["inference_executor"] == "none"
  else
    errors << "probabilistic unit #{unit_id} must explicitly allow its executor" unless entry["probabilistic_executor_allowed"] == true
    constraints = entry["probabilistic_constraints"] || {}
    errors << "probabilistic unit #{unit_id} output must remain candidate-only" unless constraints["candidate_only"] == true
    errors << "probabilistic unit #{unit_id} may not mutate canonical state" unless constraints["may_mutate_canonical_state"] == false
    errors << "probabilistic unit #{unit_id} must not own canonical state mutation" unless entry["state_mutation_authority"] == "none"
    errors << "probabilistic unit #{unit_id} missing provenance requirements" if Array(entry["provenance_required"]).empty?
    errors << "probabilistic unit #{unit_id} lacks lower-mode insufficiency evidence" if sufficiency["lower_mode_rejection"].to_s.empty?
  end

  if entry["presentation_only"] == true
    errors << "presentation-only unit #{unit_id} cannot mutate canonical state" unless entry["state_mutation_authority"] == "none"
    errors << "presentation-only unit #{unit_id} cannot aggregate a domain decision" unless [nil, "none"].include?(entry["decision_aggregator"])
  end
end

missing_units = unit_by_id.keys.to_set - seen_units
extra_units = seen_units - unit_by_id.keys.to_set
errors << "execution policy missing canonical decision units: #{missing_units.to_a.sort.join(', ')}" unless missing_units.empty?
errors << "execution policy contains unknown decision units: #{extra_units.to_a.sort.join(', ')}" unless extra_units.empty?

future_seen = Set.new
Array(policy["future_capability_defaults"]).each do |entry|
  capability_id = entry["capability_id"].to_s
  errors << "future compute default references unknown capability #{capability_id}" unless capability_ids.include?(capability_id)
  errors << "duplicate future compute default #{capability_id}" if future_seen.include?(capability_id)
  future_seen << capability_id
  errors << "future compute default #{capability_id} may not define unit_id" if entry.key?("unit_id")
  errors << "future compute default #{capability_id} may not define domain_meta_ref" if entry.key?("domain_meta_ref")
  errors << "future compute default #{capability_id} must remain non-authorizing" unless entry["implementation_authorized"] == false
  errors << "future compute default #{capability_id} missing coarse disposition" if entry["coarse_disposition"].to_s.empty?
end

forbidden_classes = Array(policy["forbidden_probabilistic_decision_classes"]).to_set
%w[authentication authorization entitlement idempotency quota_enforcement canonical_state_transition fsrs_schedule_transition objective_answer_key_scoring score_aggregation deterministic_recommendation_priority canonical_readiness_aggregation].each do |decision_class|
  errors << "execution policy omits forbidden probabilistic decision class #{decision_class}" unless forbidden_classes.include?(decision_class)
end

engines_path = File.join(root, "blueprint/06-engines.md")
engines = File.file?(engines_path) ? File.read(engines_path) : ""
errors << "learning engines still claim AI is the sole scorer" if engines.include?("AI is the sole scorer")
errors << "learning engines still use Recommendation Engine as the primary compute grouping" if engines.match?(/^## .*Recommendation Engine/m)
%w["Domain contracts own canonical semantics and decisions" "lowest sufficient computation" "Probabilistic components are inference executors" "Generated presentation is non-authoritative"].each do |marker|
  errors << "learning engines missing compute-boundary marker #{marker}" unless engines.include?(marker.delete_prefix('"').delete_suffix('"'))
end

errors << "capability catalog still claims AI is the sole scorer" if features.include?("AI is the sole scorer")
errors << "capability catalog still assigns PERSONAL.Insights meaning to AI wording" if features.include?("AI explains why the learner is weak")

routing_path = File.join(root, "artifacts/engineering/contracts/runtime/llm-routing-context-contract.md")
routing = File.file?(routing_path) ? File.read(routing_path) : ""
errors << "LLM routing still selects Go as a deterministic domain architecture" if routing.include?("deterministic Go domain rule")
errors << "LLM routing still delegates retry semantics to a Worker Contract" if routing.include?("Worker Contract")

if errors.empty?
  puts "compute boundary validation passed (units=#{unit_by_id.length}, future_defaults=#{future_seen.length}, projection_only=true)"
else
  warn errors.join("\n")
  warn "compute boundary validation failed: #{errors.length} issue(s)"
  exit 1
end
