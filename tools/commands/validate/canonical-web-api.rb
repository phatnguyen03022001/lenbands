#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "set"
require "date"

root = File.expand_path("../../..", __dir__)
errors = []

load_yaml = lambda do |relative_path|
  path = File.join(root, relative_path)
  unless File.file?(path)
    errors << "missing required YAML: #{relative_path}"
    next {}
  end
  data = YAML.safe_load(File.read(path), permitted_classes: [Date], aliases: false)
  unless data.is_a?(Hash)
    errors << "YAML root must be a mapping: #{relative_path}"
    next {}
  end
  data
rescue Psych::Exception, SystemCallError => e
  errors << "invalid YAML #{relative_path}: #{e.message}"
  {}
end

docs = load_yaml.call("DOCS.yaml")
openapi = load_yaml.call("artifacts/engineering/api/openapi.yaml")
schema_contract = load_yaml.call("artifacts/engineering/api/schema-contract.yaml")
bops = load_yaml.call("artifacts/operations/bops/contract.yaml")

canonical_path = docs.dig("authority", "web_api", "path")
schema_path = docs.dig("authority", "web_api_schemas", "path")
errors << "DOCS.yaml web_api must resolve to canonical OpenAPI" unless canonical_path == "artifacts/engineering/api/openapi.yaml"
errors << "DOCS.yaml web_api_schemas must resolve to canonical schema contract" unless schema_path == "artifacts/engineering/api/schema-contract.yaml"

legacy = docs["legacy_aliases"]
unless legacy.is_a?(Hash)
  errors << "DOCS.yaml legacy_aliases must be a mapping"
else
  %w[artifacts/engineering/contracts/openapi.yaml artifacts/engineering/contracts/writing-task-2/openapi.yaml].each do |path|
    entry = legacy[path]
    errors << "legacy OpenAPI alias missing: #{path}" unless entry.is_a?(Hash)
    errors << "legacy OpenAPI alias #{path} does not resolve to canonical API" unless entry&.dig("canonical") == canonical_path
    errors << "legacy OpenAPI alias #{path} must be migration_only" unless entry&.dig("status") == "migration_only"
  end
end

errors << "canonical OpenAPI must use 3.1 document format" unless openapi["openapi"].to_s.start_with?("3.1.")
paths = openapi["paths"]
errors << "canonical OpenAPI paths must be a mapping" unless paths.is_a?(Hash)

allowed_personas = Set.new(%w[guest learner premium_learner colab admin])
allowed_roles = Set.new(%w[learner colab admin service])
allowed_data = Set.new(%w[C0_public C1_account C2_learning C3_assessment C4_security C5_derived])
seen_personas = Set.new
operation_ids = []
operation_count = 0

Array(paths&.to_a).each do |path, item|
  unless item.is_a?(Hash)
    errors << "#{path}: path item must be a mapping"
    next
  end

  item.each do |method, operation|
    next unless %w[get post put patch delete].include?(method)
    unless operation.is_a?(Hash)
      errors << "#{method.upcase} #{path}: operation must be a mapping"
      next
    end

    operation_count += 1
    op_id = operation["operationId"]
    operation_ids << op_id
    errors << "#{method.upcase} #{path}: operationId missing" if op_id.to_s.empty?

    personas = operation["x-web-personas"]
    roles = operation["x-required-roles"]
    entitlements = operation["x-required-entitlements"]
    data_classes = operation["x-data-classes"]
    idem = operation["x-idempotency"]

    errors << "#{op_id}: x-web-personas must be an array" unless personas.is_a?(Array)
    errors << "#{op_id}: x-required-roles must be an array" unless roles.is_a?(Array)
    errors << "#{op_id}: x-required-entitlements must be an array" unless entitlements.is_a?(Array)
    errors << "#{op_id}: x-data-classes must be a non-empty array" unless data_classes.is_a?(Array) && !data_classes.empty?
    errors << "#{op_id}: x-idempotency missing" if idem.to_s.empty?

    personas = Array(personas)
    roles = Array(roles)
    entitlements = Array(entitlements)
    data_classes = Array(data_classes)
    seen_personas.merge(personas)

    unknown_personas = personas.to_set - allowed_personas
    unknown_roles = roles.to_set - allowed_roles
    unknown_data = data_classes.to_set - allowed_data
    errors << "#{op_id}: unknown personas #{unknown_personas.to_a.inspect}" unless unknown_personas.empty?
    errors << "#{op_id}: unknown roles #{unknown_roles.to_a.inspect}" unless unknown_roles.empty?
    errors << "#{op_id}: unknown data classes #{unknown_data.to_a.inspect}" unless unknown_data.empty?

    if personas.include?("guest")
      errors << "#{op_id}: guest operation must have no required roles" unless roles.empty?
      errors << "#{op_id}: guest operation must explicitly disable bearer security" unless operation["security"] == []
      errors << "#{op_id}: guest operation may expose only C0_public" unless data_classes.to_set.subset?(Set.new(%w[C0_public]))
    end

    if entitlements.include?("premium")
      errors << "#{op_id}: premium entitlement requires learner role" unless roles == ["learner"]
      errors << "#{op_id}: premium-only operation must not admit base learner persona" if personas.include?("learner")
    end

    if path.start_with?("/v1/colab/")
      errors << "#{op_id}: Colab surface must be Colab-only" unless personas == ["colab"] && roles == ["colab"]
      errors << "#{op_id}: Colab surface must not expose C1/C3/C4" unless (data_classes.to_set & Set.new(%w[C1_account C3_assessment C4_security])).empty?
    end

    if path.start_with?("/v1/admin/")
      errors << "#{op_id}: Admin surface must be Admin-only" unless personas == ["admin"] && roles == ["admin"]
      errors << "#{op_id}: Admin surface must not expose raw C3 assessment data" if data_classes.include?("C3_assessment")
    end

    if path.start_with?("/v1/webhooks/")
      errors << "#{op_id}: webhook must have no web personas" unless personas.empty?
      errors << "#{op_id}: webhook must use service role" unless roles == ["service"]
      errors << "#{op_id}: webhook cannot accept C2/C3/C4" unless (data_classes.to_set & Set.new(%w[C2_learning C3_assessment C4_security])).empty?
    end

    if %w[post put patch delete].include?(method) && !path.start_with?("/v1/webhooks/")
      errors << "#{op_id}: durable mutation must require idempotency" unless idem == "required"
      params = Array(operation["parameters"])
      has_key = params.any? { |entry| entry.is_a?(Hash) && entry["$ref"] == "#/components/parameters/IdempotencyKey" }
      errors << "#{op_id}: durable mutation missing Idempotency-Key parameter" unless has_key
    end
  end
end

errors << "canonical OpenAPI operationId duplicated" unless operation_ids.compact.uniq.length == operation_ids.compact.length
missing_personas = allowed_personas - seen_personas
errors << "canonical OpenAPI does not cover personas: #{missing_personas.to_a.sort.join(', ')}" unless missing_personas.empty?
errors << "canonical OpenAPI must contain a meaningful full-web surface" if operation_count < 40

# Payload schema contract must be complete for exactly the canonical operations.
operation_contracts = schema_contract["operation_contracts"]
schemas = schema_contract["schemas"]
unless operation_contracts.is_a?(Hash)
  errors << "schema-contract operation_contracts must be a mapping"
  operation_contracts = {}
end
unless schemas.is_a?(Hash)
  errors << "schema-contract schemas must be a mapping"
  schemas = {}
end

openapi_ids = operation_ids.compact.to_set
schema_ids = operation_contracts.keys.to_set
missing_schema_ops = openapi_ids - schema_ids
extra_schema_ops = schema_ids - openapi_ids
errors << "schema-contract missing operationIds: #{missing_schema_ops.to_a.sort.join(', ')}" unless missing_schema_ops.empty?
errors << "schema-contract contains unknown operationIds: #{extra_schema_ops.to_a.sort.join(', ')}" unless extra_schema_ops.empty?

operation_contracts.each do |op_id, contract|
  unless contract.is_a?(Hash)
    errors << "#{op_id}: operation schema contract must be a mapping"
    next
  end
  request_schema = contract["request"]
  response_schema = contract["response"]
  errors << "#{op_id}: request schema missing" if request_schema.to_s.empty?
  errors << "#{op_id}: response schema missing" if response_schema.to_s.empty?
  unless request_schema.to_s == "none" || schemas.key?(request_schema)
    errors << "#{op_id}: request schema #{request_schema.inspect} is undefined"
  end
  errors << "#{op_id}: response schema #{response_schema.inspect} is undefined" unless schemas.key?(response_schema)
end

# Reject ambiguous/unsafe schema-level score and identity shortcuts.
%w[PlacementResult EvaluationResult AttemptSummary].each do |name|
  errors << "schema-contract missing critical score schema #{name}" unless schemas.key?(name)
end
placement_props = schemas.dig("PlacementResult", "properties") || {}
eval_props = schemas.dig("EvaluationResult", "properties") || {}
errors << "PlacementResult must preserve score_label" unless placement_props.key?("score_label")
errors << "PlacementResult must preserve score_scope" unless placement_props.key?("score_scope")
errors << "EvaluationResult must preserve score_label" unless eval_props.key?("score_label")
errors << "EvaluationResult must preserve score_scope" unless eval_props.key?("score_scope")
errors << "EvaluationResult must preserve scorer_route_version" unless eval_props.key?("scorer_route_version")

bops_personas = Set.new(Array(bops.dig("scope", "web_personas")))
bops_roles = Set.new(Array(bops.dig("scope", "authorization_roles")))
errors << "BOPS persona set differs from canonical API" unless bops_personas == allowed_personas
errors << "BOPS authenticated role set must be learner/colab/admin" unless bops_roles == Set.new(%w[learner colab admin])

problem = openapi.dig("components", "schemas", "Problem")
errors << "RFC9457 Problem schema missing" unless problem.is_a?(Hash) && Array(problem["required"]).to_set.superset?(Set.new(%w[type title status]))

if errors.empty?
  puts "canonical web API validation passed (operations=#{operation_count}, typed_contracts=#{operation_contracts.length}, personas=#{seen_personas.to_a.sort.join(',')})"
else
  warn errors.join("\n")
  warn "canonical web API validation failed: #{errors.length} issue(s)"
  exit 1
end
