#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "set"
require "date"

$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)
require "lenbands"
require "lenbands/api_schema_compiler"

root = Lenbands::ROOT
errors = []
load_yaml = lambda do |relative|
  begin
    data = YAML.safe_load(File.read(File.join(root, relative)), permitted_classes: [Date], aliases: false)
    unless data.is_a?(Hash)
      errors << "#{relative}: YAML root must be a mapping"
      next {}
    end
    data
  rescue StandardError => e
    errors << "#{relative}: #{e.message}"
    {}
  end
end

docs = load_yaml.call("DOCS.yaml")
openapi = load_yaml.call("artifacts/engineering/api/openapi.yaml")
schema_contract = load_yaml.call("artifacts/engineering/api/schema-contract.yaml")
type_system = load_yaml.call("artifacts/engineering/api/type-system.yaml")
ownership = load_yaml.call("artifacts/engineering/api/operation-ownership.yaml")
bops = load_yaml.call("artifacts/operations/bops/contract.yaml")

errors << "DOCS web_api path drifted" unless docs.dig("authority", "web_api", "path") == "artifacts/engineering/api/openapi.yaml"
errors << "DOCS web_api_schemas path drifted" unless docs.dig("authority", "web_api_schemas", "path") == "artifacts/engineering/api/schema-contract.yaml"
errors << "DOCS web_api_type_system path drifted" unless docs.dig("authority", "web_api_type_system", "path") == "artifacts/engineering/api/type-system.yaml"
errors << "DOCS web_api_operation_ownership path drifted" unless docs.dig("authority", "web_api_operation_ownership", "path") == "artifacts/engineering/api/operation-ownership.yaml"

legacy = docs["legacy_aliases"] || {}
retired_openapi_paths = %w[
  artifacts/engineering/contracts/openapi.yaml
  artifacts/engineering/contracts/writing-task-2/openapi.yaml
]
retired_openapi_paths.each do |path|
  errors << "retired OpenAPI must not remain in DOCS aliases: #{path}" if legacy.key?(path)
  errors << "retired OpenAPI must be physically removed: #{path}" if File.exist?(File.join(root, path))
end

errors << "authoring OpenAPI must remain 3.1.x" unless openapi["openapi"].to_s.start_with?("3.1.")
paths = openapi["paths"]
unless paths.is_a?(Hash)
  errors << "canonical OpenAPI paths must be a mapping"
  paths = {}
end

allowed_personas = Set.new(%w[guest learner premium_learner colab admin])
allowed_roles = Set.new(%w[learner colab admin])
expected_internal_scopes = Set.new(%w[evaluation_worker workflow_callback billing_webhook content_job notification_job research_benchmark_job])
allowed_internal_scopes = Set.new(Array(openapi.dig("x-lenbands", "internal_function_scopes")))
allowed_data = Set.new(%w[C0_public C1_account C2_learning C3_assessment C4_security C5_derived])
seen_personas = Set.new
operations = []

errors << "canonical internal function-scope registry drift" unless allowed_internal_scopes == expected_internal_scopes

paths.each do |path, path_item|
  next unless path_item.is_a?(Hash)
  path_item.each do |method, operation|
    next unless %w[get post put patch delete].include?(method)
    unless operation.is_a?(Hash)
      errors << "#{method.upcase} #{path}: operation must be a mapping"
      next
    end

    op_id = operation["operationId"]
    operations << op_id
    errors << "#{method.upcase} #{path}: operationId missing" if op_id.to_s.empty?

    personas = operation["x-web-personas"]
    roles = operation["x-required-roles"]
    entitlements = operation["x-required-entitlements"]
    data_classes = operation["x-data-classes"]
    idem = operation["x-idempotency"]
    function_scope = operation["x-internal-function-scope"]

    errors << "#{op_id}: x-web-personas must be an array" unless personas.is_a?(Array)
    errors << "#{op_id}: x-required-roles must be an array" unless roles.is_a?(Array)
    errors << "#{op_id}: x-required-entitlements must be an array" unless entitlements.is_a?(Array)
    errors << "#{op_id}: x-data-classes must be non-empty" unless data_classes.is_a?(Array) && !data_classes.empty?
    errors << "#{op_id}: x-idempotency missing" if idem.to_s.empty?

    personas = Array(personas)
    roles = Array(roles)
    entitlements = Array(entitlements)
    data_classes = Array(data_classes)
    seen_personas.merge(personas)

    errors << "#{op_id}: unknown persona" unless personas.to_set.subset?(allowed_personas)
    errors << "#{op_id}: unknown role" unless roles.to_set.subset?(allowed_roles)
    errors << "#{op_id}: unknown data class" unless data_classes.to_set.subset?(allowed_data)

    if function_scope
      errors << "#{op_id}: unknown internal function scope #{function_scope.inspect}" unless allowed_internal_scopes.include?(function_scope)
      errors << "#{op_id}: web persona operation may not also use internal function scope" unless personas.empty?
      errors << "#{op_id}: internal function-scoped operation may not require web role" unless roles.empty?
    elsif personas.empty? && path.start_with?("/v1/webhooks/")
      errors << "#{op_id}: webhook missing x-internal-function-scope"
    end

    if personas.include?("guest")
      errors << "#{op_id}: guest operation must disable bearer security" unless operation["security"] == []
      errors << "#{op_id}: guest operation may expose only C0_public" unless data_classes.to_set.subset?(Set.new(%w[C0_public]))
    end

    if entitlements.include?("premium")
      errors << "#{op_id}: premium entitlement requires learner role" unless roles == ["learner"]
      errors << "#{op_id}: premium-only operation admits base learner" if personas.include?("learner")
    end

    if path.start_with?("/v1/colab/")
      errors << "#{op_id}: Colab surface access drift" unless personas == ["colab"] && roles == ["colab"] && function_scope.nil?
      errors << "#{op_id}: Colab may not expose C1/C3/C4" unless (data_classes.to_set & Set.new(%w[C1_account C3_assessment C4_security])).empty?
    end

    if path.start_with?("/v1/admin/")
      errors << "#{op_id}: Admin surface access drift" unless personas == ["admin"] && roles == ["admin"] && function_scope.nil?
      errors << "#{op_id}: Admin may not expose raw C3" if data_classes.include?("C3_assessment")
    end

    if path.start_with?("/v1/webhooks/")
      errors << "#{op_id}: webhook must have no web persona" unless personas.empty?
      errors << "#{op_id}: webhook must not use web role" unless roles.empty?
      errors << "#{op_id}: webhook must use billing_webhook function scope" unless function_scope == "billing_webhook"
      errors << "#{op_id}: webhook may not accept C2/C3/C4" unless (data_classes.to_set & Set.new(%w[C2_learning C3_assessment C4_security])).empty?
    end

    if %w[post put patch delete].include?(method) && !path.start_with?("/v1/webhooks/")
      errors << "#{op_id}: durable mutation must require idempotency" unless idem == "required"
      params = Array(operation["parameters"])
      errors << "#{op_id}: durable mutation missing Idempotency-Key" unless params.any? { |entry| entry.is_a?(Hash) && entry["$ref"] == "#/components/parameters/IdempotencyKey" }
    end
  end
end

errors << "operationId duplicated" unless operations.compact.uniq.length == operations.compact.length
errors << "canonical API must contain exactly 63 operations" unless operations.length == 63
errors << "canonical API persona coverage drift" unless seen_personas == allowed_personas

contracts = schema_contract["operation_contracts"]
schemas = schema_contract["schemas"]
unless contracts.is_a?(Hash) && schemas.is_a?(Hash)
  errors << "schema contract must contain operation_contracts and schemas mappings"
  contracts = {}
  schemas = {}
end

openapi_ids = operations.compact.to_set
errors << "schema operation set differs from OpenAPI" unless contracts.keys.to_set == openapi_ids
errors << "ownership operation set differs from OpenAPI" unless (ownership["operations"] || {}).keys.to_set == openapi_ids
contracts.each do |op_id, contract|
  request = contract["request"]
  response = contract["response"]
  errors << "#{op_id}: undefined request schema #{request}" unless request == "none" || schemas.key?(request)
  errors << "#{op_id}: undefined response schema #{response}" unless schemas.key?(response)
end

compiled, compile_errors = Lenbands::ApiSchemaCompiler.compile(schema_contract: schema_contract, type_system: type_system)
errors.concat(compile_errors)
resolved, resolve_errors = Lenbands::ApiSchemaCompiler.resolve_openapi(openapi: openapi, schema_contract: schema_contract, type_system: type_system)
errors.concat(resolve_errors)
errors.concat(Lenbands::ApiSchemaCompiler.validate_resolved(openapi: resolved, schema_contract: schema_contract, type_system: type_system))
errors << "compiled schema count differs from semantic schema count" unless compiled.length == schemas.length

%w[TargetProfile PlacementResult EvaluationResult WritingError WritingErrorRetest AttemptSummary DailyAction Profile].each do |name|
  errors << "critical schema missing #{name}" unless schemas.key?(name)
end

profile_props = schemas.dig("Profile", "properties") || {}
profile_required = Set.new(Array(schemas.dig("Profile", "required")))
errors << "Profile must persist learner timezone" unless profile_props["timezone"] == "iana_timezone" && profile_required.include?("timezone")
errors << "ProfilePatch must allow explicit timezone change" unless schemas.dig("ProfilePatch", "properties", "timezone") == "iana_timezone|null"
timezone_alias = type_system.dig("aliases", "iana_timezone") || {}
errors << "IANA timezone alias must require runtime timezone-database validation" unless timezone_alias["x-lenbands-rule"] == "validate_against_runtime_iana_timezone_database_not_pattern_alone"

placement_props = schemas.dig("PlacementResult", "properties") || {}
placement_required = Set.new(Array(schemas.dig("PlacementResult", "required")))
%w[result_id attempt_id score_label score_scope result_validity calibration_status termination_reason evidence_coverage configuration_version policy_version created_at].each do |field|
  errors << "PlacementResult missing required #{field}" unless placement_required.include?(field) && placement_props.key?(field)
end
errors << "PlacementResult must not use legacy confidence_state" if placement_props.key?("confidence_state")
errors << "PlacementResult result_validity drifted" unless placement_props["result_validity"] == "accepted|limited_evidence|insufficient_evidence|invalid"

daily_plan_required = Set.new(Array(schemas.dig("DailyPlan", "required")))
%w[evidence_state_version target_profile_version].each do |field|
  errors << "DailyPlan missing source-version binding #{field}" unless daily_plan_required.include?(field)
end
daily_action_props = schemas.dig("DailyAction", "properties") || {}
daily_action_required = Set.new(Array(schemas.dig("DailyAction", "required")))
%w[intent reason_code source_evidence_refs].each do |field|
  errors << "DailyAction missing controlled routing field #{field}" unless daily_action_required.include?(field) && daily_action_props.key?(field)
end
errors << "DailyAction intent vocabulary drifted" unless daily_action_props["intent"] == "CONTINUE|REVIEW_DUE|RETEST|REMEDIATE|COLLECT_EVIDENCE|GOAL_COVERAGE|FALLBACK"
errors << "DailyAction reason vocabulary must be closed" unless daily_action_props["reason_code"] == "resume_active_session|due_review|eligible_retest|admitted_error|evidence_gap|target_coverage_gap|deterministic_fallback"

eval_props = schemas.dig("EvaluationResult", "properties") || {}
%w[score_label score_scope scorer_route_version result_validity criteria overall_band_estimate].each do |field|
  errors << "EvaluationResult missing #{field}" unless eval_props.key?(field)
end
errors << "EvaluationResult must not expose legacy overall_band alias" if eval_props.key?("overall_band")
errors << "EvaluationResult must not require learner-facing raw confidence" if eval_props.key?("overall_confidence") || eval_props.key?("confidence_state") || eval_props.key?("quality_status")
criterion_props = schemas.dig("CriterionResult", "properties") || {}
errors << "CriterionResult must use band_estimate" unless criterion_props.key?("band_estimate") && !criterion_props.key?("band")

writing_error_input = schemas.dig("WritingErrorInput", "properties") || {}
%w[score confidence error_pattern user_id].each do |forbidden|
  errors << "WritingErrorInput may not accept client-authored #{forbidden}" if writing_error_input.key?(forbidden)
end

config_alias = type_system.dig("aliases", "governed_config_map") || {}
errors << "Admin config type must block secret-like keys" unless config_alias.dig("propertyNames", "not", "pattern").to_s.include?("secret")

bops_personas = Set.new(Array(bops.dig("scope", "web_personas")))
bops_roles = Set.new(Array(bops.dig("scope", "authorization_roles")))
errors << "BOPS persona set differs from API" unless bops_personas == allowed_personas
errors << "BOPS authenticated role set drift" unless bops_roles == allowed_roles

problem = openapi.dig("components", "schemas", "Problem")
errors << "RFC9457 Problem source schema missing" unless problem.is_a?(Hash) && Array(problem["required"]).to_set.superset?(Set.new(%w[type title status]))

if errors.empty?
  puts "canonical web API validation passed (operations=63, typed_contracts=#{contracts.length}, compiled_schemas=#{compiled.length}, generic_build_payloads=0)"
else
  warn errors.join("\n")
  warn "canonical web API validation failed: #{errors.length} issue(s)"
  exit 1
end
