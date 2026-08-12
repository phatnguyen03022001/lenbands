# frozen_string_literal: true

require "set"

module Lenbands::DomainAutomationContract
  EXPECTED_DOMAINS = %w[repository knowledge learning assessment ai release runtime_integration].to_set.freeze
  EXPECTED_INVARIANTS = %w[
    business_logic_domain_owned
    provider_semantics_neutral
    commodity_runtime_not_custom
    adapter_exit_path_required
    evidence_required_for_readiness
  ].freeze
  ALLOWED_STATES = %w[enforced partial evidence_blocked adapter_only].freeze

  def self.validate(contract:, adr_meta:, public_commands:, root:)
    errors = []
    errors << "domain automation schema_version must be 1.0.0" unless contract["schema_version"] == "1.0.0"
    errors << "success metric must be business_automation_coverage" unless contract["success_metric"] == "business_automation_coverage"
    errors << "infrastructure automation platform must remain a non-goal" unless contract["non_goal"] == "infrastructure_automation_platform"

    domains = contract.fetch("domains", {})
    errors << "domain automation coverage set mismatch" unless domains.keys.to_set == EXPECTED_DOMAINS
    command_set = public_commands.to_set
    control_ids = []
    domains.each do |domain, definition|
      state = definition["coverage_state"]
      errors << "#{domain}: invalid coverage_state #{state.inspect}" unless ALLOWED_STATES.include?(state)
      authorities = Array(definition["authorities"])
      errors << "#{domain}: authorities must not be empty" if authorities.empty?
      authorities.each { |path| errors << "#{domain}: missing authority #{path}" unless File.exist?(File.join(root, path)) }
      controls = Array(definition["controls"])
      errors << "#{domain}: controls must not be empty" if controls.empty?
      controls.each do |control|
        id = "#{domain}.#{control["id"]}"
        control_ids << id
        errors << "#{id}: unknown public command #{control["command"].inspect}" unless command_set.include?(control["command"])
      end
      gaps = Array(definition["gaps"])
      errors << "#{domain}: enforced coverage cannot retain gaps" if state == "enforced" && !gaps.empty?
      errors << "#{domain}: #{state} coverage must disclose gaps" if state != "enforced" && gaps.empty?
    end
    errors << "duplicate domain control IDs" unless control_ids.uniq.length == control_ids.length

    errors << "domain automation policy_invariants mismatch" unless Array(contract["policy_invariants"]) == EXPECTED_INVARIANTS
    errors << "ADR-0004 policy_invariants mismatch" unless Array(adr_meta["policy_invariants"]) == EXPECTED_INVARIANTS
    errors << "ADR-0004 commodity boundary differs from domain automation contract" unless Array(adr_meta["commodity_concerns"]).to_set == Array(contract["commodity_concerns"]).to_set
    errors
  end
end
