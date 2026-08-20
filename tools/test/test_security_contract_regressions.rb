#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "date"
require "lenbands"
require "lenbands/reporter"

root = Lenbands::ROOT
reporter = Lenbands::Reporter.new("Security contract regression tests")
read = ->(path) { File.read(File.join(root, path)) }
load_yaml = ->(path) { YAML.safe_load(read.call(path), permitted_classes: [Date], aliases: false) }

type_system = load_yaml.call("artifacts/engineering/api/type-system.yaml")
transport = type_system.fetch("transport_policy", {})
limits = transport.fetch("request_limits", {})
reporter << "global JSON body ceiling missing" unless limits["max_json_body_bytes"].to_i.positive?
reporter << "JSON depth ceiling missing" unless limits["max_json_depth"].to_i.positive?
profiles = limits.fetch("semantic_profiles", {})
%w[learner_assessment_text human_note bounded_assessment_answer bounded_structured_content].each do |profile|
  reporter << "request limit profile missing: #{profile}" unless profiles.key?(profile)
end
rendering = transport.fetch("browser_rendering", {})
reporter << "raw HTML is not fail-closed" unless rendering["raw_html_rendering_default"] == "prohibited"
reporter << "sanitized rich-text renderer is not required" unless rendering["markdown_or_rich_text_requires_allowlisted_renderer_and_sanitization"] == true
reporter << "unsafe-eval CSP is not prohibited" unless rendering["csp_unsafe_eval"] == "prohibited"
session = transport.fetch("browser_session", {})
reporter << "persistent raw bearer storage is not prohibited" unless session["persistent_raw_bearer_storage_in_application_controlled_browser_storage"] == "prohibited"
reporter << "cookie mutation CSRF/origin defense is not required" unless session["cookie_authenticated_mutation_requires_origin_or_csrf_defense"] == true

access = read.call("artifacts/engineering/api/access-control.md")
["Browser session and credential transport", "Recent-auth / step-up policy"].each do |heading|
  reporter << "access-control missing #{heading}" unless access.include?(heading)
end
reporter << "client-authored recent-auth is not explicitly rejected" unless access.include?("recent-auth proof") && access.include?("cannot be supplied as an arbitrary client-authored boolean/header")

api_readme = read.call("artifacts/engineering/api/README.md")
reporter << "API governance still advertises live migration aliases" if api_readme.include?("migration-only aliases") || api_readme.include?("are migration-only")
reporter << "target_met scope rule missing" unless api_readme.include?("TargetFeasibility.target_met") && api_readme.include?("P0 Writing-only evidence cannot produce overall/four-skill `target_met`")

critical = load_yaml.call("artifacts/experience/critical-path-usability-contract.yaml")
reporter << "critical path missing browser security" unless critical.key?("browser_security")
reporter << "critical path missing auth-expiry recovery" unless critical.dig("browser_network", "degradation", "auth_expiry")
reporter << "critical path does not require re-auth before resume" unless critical.dig("navigation", "resume", "expired_auth_requires_reauthentication_before_resume") == true

threat = read.call("artifacts/operations/bops/threat-model.md")
%w[RT-21 RT-22 RT-23 RT-24 RT-25].each do |id|
  reporter << "red-team scenario missing: #{id}" unless threat.include?("`#{id}`")
end

change_governance = load_yaml.call("artifacts/operations/change-governance.yaml")
reporter << "dev integration ref is not explicit" unless change_governance.dig("change_model", "development_integration_ref", "ref") == "refs/heads/dev"
reporter << "dev incorrectly claims release authority" unless change_governance.dig("change_model", "development_integration_ref", "authoritative_for_release") == false
reporter << "candidate identity is still branch-name based" unless change_governance.dig("candidate_selection", "branch_name_is_not_candidate_identity") == true

family_registry = load_yaml.call("artifacts/operations/capability-family-registry.yaml")
active_families = Array(family_registry["families"]).select { |family| family["lifecycle"] == "ACTIVE" }
active_contracts = active_families.flat_map { |family| Array(family["shared_contracts"]) }
retired = %w[
  artifacts/engineering/contracts/runtime/auth-identity-contract.md
  artifacts/engineering/contracts/openapi.yaml
  artifacts/engineering/contracts/writing-task-2/openapi.yaml
  artifacts/engineering/contracts/runtime/api-ownership-bff-contract.md
]
retired.each do |path|
  reporter << "retired contract returned to active family registry: #{path}" if active_contracts.include?(path)
end
legacy_failures = active_families.flat_map { |family| Array(family["shared_failures"]) }
reporter << "legacy LOW_CONFIDENCE failure returned to active family registry" if legacy_failures.any? { |failure| failure.include?("LOW_CONFIDENCE") }

reporter.pass!("PASS: security contract regression tests")
