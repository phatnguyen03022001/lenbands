# frozen_string_literal: true

require "minitest/autorun"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "lenbands"
require "lenbands/api_schema_compiler"

class ApiSchemaCompilerTest < Minitest::Test
  def type_system
    {
      "primitive_types" => {"string" => {"type" => "string"}, "integer" => {"type" => "integer"}},
      "aliases" => {"timestamp" => {"type" => "string", "format" => "date-time"}},
      "transport_policy" => {
        "idempotency_key" => {"type" => "string", "minLength" => 16, "maxLength" => 128},
        "webhook_signature_input" => "raw_request_body",
        "webhook_normalization_order" => %w[verify_signature parse_and_normalize],
        "public_failure_codes" => %w[CONTENT_UNAVAILABLE]
      }
    }
  end

  def schema_contract
    {
      "operation_contracts" => {"createThing" => {"request" => "ThingInput", "response" => "Thing"}},
      "schemas" => {
        "ThingInput" => {"required" => ["name"], "properties" => {"name" => "string", "tags" => "array<string>"}},
        "Thing" => {"required" => ["id", "state"], "properties" => {"id" => "string", "state" => "ready|blocked", "created_at" => "timestamp"}}
      }
    }
  end

  def openapi
    {
      "openapi" => "3.1.0",
      "paths" => {
        "/things" => {
          "post" => {
            "operationId" => "createThing",
            "requestBody" => {"$ref" => "#/components/requestBodies/JsonObject"},
            "responses" => {
              "201" => {"$ref" => "#/components/responses/ObjectCreated"},
              "202" => {"$ref" => "#/components/responses/ObjectAccepted"},
              "204" => {"description" => "done"}
            }
          }
        }
      },
      "components" => {
        "parameters" => {"IdempotencyKey" => {"name" => "Idempotency-Key", "in" => "header", "required" => true, "schema" => {"type" => "string"}}},
        "schemas" => {
          "JsonObject" => {"type" => "object", "additionalProperties" => true},
          "Problem" => {"type" => "object", "properties" => {"code" => {"type" => "string"}}}
        },
        "requestBodies" => {"JsonObject" => {"required" => true}},
        "responses" => {
          "ObjectCreated" => {"description" => "generic"},
          "ObjectAccepted" => {"description" => "generic"}
        }
      }
    }
  end

  def test_resolves_every_success_transport_to_exact_schema_and_policy
    resolved, errors = Lenbands::ApiSchemaCompiler.resolve_openapi(openapi: openapi, schema_contract: schema_contract, type_system: type_system)
    assert_empty errors
    assert_empty Lenbands::ApiSchemaCompiler.validate_resolved(openapi: resolved, schema_contract: schema_contract, type_system: type_system)
    operation = resolved.dig("paths", "/things", "post")
    assert_equal "#/components/schemas/ThingInput", operation.dig("requestBody", "content", "application/json", "schema", "$ref")
    assert_equal "#/components/schemas/Thing", operation.dig("responses", "201", "content", "application/json", "schema", "$ref")
    assert_equal "#/components/schemas/Thing", operation.dig("responses", "202", "content", "application/json", "schema", "$ref")
    refute operation.dig("responses", "204").key?("content")
    assert_equal({"type" => "string", "minLength" => 16, "maxLength" => 128}, resolved.dig("components", "parameters", "IdempotencyKey", "schema"))
    assert_equal %w[CONTENT_UNAVAILABLE], resolved.dig("components", "schemas", "Problem", "properties", "code", "enum")
    refute resolved.dig("components", "schemas").key?("JsonObject")
    refute resolved.dig("components", "responses").key?("ObjectAccepted")
  end

  def test_unknown_type_token_fails_closed
    contract = Marshal.load(Marshal.dump(schema_contract))
    contract["schemas"]["Thing"]["properties"]["state"] = "typo_semantic_alias"
    _compiled, errors = Lenbands::ApiSchemaCompiler.compile(schema_contract: contract, type_system: type_system)
    assert errors.any? { |error| error.include?("unknown type token") }
  end

  def test_literal_union_and_nullable_reference_are_typed
    contract = Marshal.load(Marshal.dump(schema_contract))
    contract["schemas"]["Thing"]["properties"]["state"] = "ready|blocked|null"
    contract["schemas"]["Thing"]["properties"]["parent"] = "Thing|null"
    compiled, errors = Lenbands::ApiSchemaCompiler.compile(schema_contract: contract, type_system: type_system)
    assert_empty errors
    assert_equal ["ready", "blocked", nil], compiled.dig("Thing", "properties", "state", "enum")
    assert_equal "#/components/schemas/Thing", compiled.dig("Thing", "properties", "parent", "oneOf", 0, "$ref")
  end
end
