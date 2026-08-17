# frozen_string_literal: true

require "set"

module Lenbands
  module ApiSchemaCompiler
    HTTP_METHODS = %w[get post put patch delete].freeze
    GENERIC_COMPONENTS = %w[JsonObject].freeze
    GENERIC_RESPONSES = %w[ObjectOK ListOK ObjectCreated ObjectAccepted].freeze

    module_function

    def compile(schema_contract:, type_system:)
      errors = []
      schemas = schema_contract["schemas"]
      aliases = type_system["aliases"]
      primitives = type_system["primitive_types"]
      unless schemas.is_a?(Hash)
        errors << "schema-contract schemas must be a mapping"
        schemas = {}
      end
      unless aliases.is_a?(Hash)
        errors << "type-system aliases must be a mapping"
        aliases = {}
      end
      unless primitives.is_a?(Hash)
        errors << "type-system primitive_types must be a mapping"
        primitives = {}
      end

      compiled = {}
      schemas.each do |name, definition|
        unless definition.is_a?(Hash)
          errors << "#{name}: schema definition must be a mapping"
          next
        end
        properties = definition["properties"]
        unless properties.nil? || properties.is_a?(Hash)
          errors << "#{name}: properties must be a mapping"
          next
        end
        object = {"type" => "object", "additionalProperties" => false, "properties" => {}}
        required = Array(definition["required"])
        object["required"] = required unless required.empty?
        Array(properties&.to_a).each do |property, expression|
          object["properties"][property] = compile_type(
            expression,
            schema_names: schemas.keys.to_set,
            aliases: aliases,
            primitives: primitives,
            errors: errors,
            context: "#{name}.#{property}"
          )
        end
        compiled[name] = object
      end
      [compiled, errors]
    end

    def compile_type(expression, schema_names:, aliases:, primitives:, errors:, context:)
      return deep_copy(expression) if expression.is_a?(Hash)
      unless expression.is_a?(String) && !expression.empty?
        errors << "#{context}: type expression must be a non-empty string or JSON Schema mapping"
        return {}
      end

      if expression.start_with?("array<") && expression.end_with?(">")
        inner = expression[6...-1]
        return {"type" => "array", "items" => compile_type(inner, schema_names: schema_names, aliases: aliases, primitives: primitives, errors: errors, context: "#{context}[]")}
      end

      if expression.include?("|")
        parts = expression.split("|")
        nullable = parts.delete("null")
        all_literals = parts.all? { |part| literal_token?(part, schema_names: schema_names, aliases: aliases, primitives: primitives) }
        if all_literals
          values = parts.dup
          values << nil if nullable
          return {"type" => nullable ? ["string", "null"] : "string", "enum" => values}
        end
        branches = parts.map { |part| compile_type(part, schema_names: schema_names, aliases: aliases, primitives: primitives, errors: errors, context: context) }
        branches << {"type" => "null"} if nullable
        return {"oneOf" => branches}
      end

      return {"$ref" => "#/components/schemas/#{expression}"} if schema_names.include?(expression)
      return deep_copy(primitives[expression]) if primitives.key?(expression)
      return deep_copy(aliases[expression]) if aliases.key?(expression)

      errors << "#{context}: unknown type token #{expression.inspect}; declare it in type-system.yaml or schemas"
      {}
    end

    def literal_token?(token, schema_names:, aliases:, primitives:)
      return false if token.start_with?("array<")
      !schema_names.include?(token) && !aliases.key?(token) && !primitives.key?(token)
    end

    def resolve_openapi(openapi:, schema_contract:, type_system:)
      resolved = deep_copy(openapi)
      compiled, errors = compile(schema_contract: schema_contract, type_system: type_system)
      operation_contracts = schema_contract["operation_contracts"]
      unless operation_contracts.is_a?(Hash)
        errors << "schema-contract operation_contracts must be a mapping"
        operation_contracts = {}
      end
      transport = type_system["transport_policy"]
      unless transport.is_a?(Hash)
        errors << "type-system transport_policy must be a mapping"
        transport = {}
      end

      resolved["openapi"] = "3.1.2" if resolved["openapi"].to_s.start_with?("3.1.")
      resolved["components"] ||= {}
      resolved["components"]["schemas"] ||= {}
      resolved["components"]["schemas"].merge!(compiled)
      idempotency_schema = transport["idempotency_key"]
      if idempotency_schema.is_a?(Hash)
        resolved["components"]["parameters"] ||= {}
        resolved["components"]["parameters"]["IdempotencyKey"] ||= {"name" => "Idempotency-Key", "in" => "header", "required" => true}
        resolved["components"]["parameters"]["IdempotencyKey"]["schema"] = deep_copy(idempotency_schema)
      else
        errors << "transport policy idempotency_key must be a JSON Schema mapping"
      end

      public_failure_codes = Array(transport["public_failure_codes"])
      problem = resolved.dig("components", "schemas", "Problem")
      if problem.is_a?(Hash) && problem.dig("properties", "code").is_a?(Hash) && !public_failure_codes.empty?
        problem["properties"]["code"] = {"type" => "string", "enum" => public_failure_codes}
      else
        errors << "Problem.code or public failure-code registry missing"
      end

      seen = Set.new
      Array(resolved["paths"]&.to_a).each do |path, path_item|
        next unless path_item.is_a?(Hash)
        path_item.each do |method, operation|
          next unless HTTP_METHODS.include?(method)
          next unless operation.is_a?(Hash)
          op_id = operation["operationId"]
          contract = operation_contracts[op_id]
          unless contract.is_a?(Hash)
            errors << "#{method.upcase} #{path}: no schema contract for #{op_id.inspect}"
            next
          end
          seen << op_id
          request_name = contract["request"]
          response_name = contract["response"]
          if request_name == "none"
            operation.delete("requestBody")
          elsif compiled.key?(request_name)
            operation["requestBody"] = {"required" => true, "content" => {"application/json" => {"schema" => {"$ref" => "#/components/schemas/#{request_name}"}}}}
          else
            errors << "#{op_id}: request schema #{request_name.inspect} is not compiled"
          end

          responses = operation["responses"]
          unless responses.is_a?(Hash)
            errors << "#{op_id}: responses must be a mapping"
            next
          end
          success_code = responses.keys.find { |code| code.to_s.match?(/\A2\d\d\z/) }
          unless success_code
            errors << "#{op_id}: no success response"
            next
          end
          unless compiled.key?(response_name)
            errors << "#{op_id}: response schema #{response_name.inspect} is not compiled"
            next
          end
          responses[success_code] = {"description" => "Success", "content" => {"application/json" => {"schema" => {"$ref" => "#/components/schemas/#{response_name}"}}}}
          operation["x-lenbands-schema-contract"] = {"request" => request_name, "response" => response_name}
          if path.start_with?("/v1/webhooks/")
            operation["x-signature-input"] = transport["webhook_signature_input"]
            operation["x-normalization-order"] = Array(transport["webhook_normalization_order"])
          end
        end
      end

      missing_ops = operation_contracts.keys.to_set - seen
      errors << "schema-contract contains operations absent from OpenAPI: #{missing_ops.to_a.sort.join(', ')}" unless missing_ops.empty?

      request_bodies = resolved.dig("components", "requestBodies")
      request_bodies.delete("JsonObject") if request_bodies.is_a?(Hash)
      response_components = resolved.dig("components", "responses")
      GENERIC_RESPONSES.each { |name| response_components.delete(name) } if response_components.is_a?(Hash)
      GENERIC_COMPONENTS.each { |name| resolved.dig("components", "schemas")&.delete(name) }
      [resolved, errors]
    end

    def validate_resolved(openapi:, schema_contract:, type_system: nil)
      errors = []
      contracts = schema_contract.fetch("operation_contracts", {})
      Array(openapi["paths"]&.to_a).each do |path, path_item|
        next unless path_item.is_a?(Hash)
        path_item.each do |method, operation|
          next unless HTTP_METHODS.include?(method) && operation.is_a?(Hash)
          op_id = operation["operationId"]
          contract = contracts[op_id]
          next unless contract.is_a?(Hash)
          annotation = operation["x-lenbands-schema-contract"]
          errors << "#{op_id}: resolved operation lacks schema-contract annotation" unless annotation == {"request" => contract["request"], "response" => contract["response"]}
          if contract["request"] == "none"
            errors << "#{op_id}: resolved no-body operation still has requestBody" if operation.key?("requestBody")
          else
            ref = operation.dig("requestBody", "content", "application/json", "schema", "$ref")
            expected = "#/components/schemas/#{contract['request']}"
            errors << "#{op_id}: resolved request ref #{ref.inspect} != #{expected}" unless ref == expected
          end
          responses = operation["responses"] || {}
          success_code = responses.keys.find { |code| code.to_s.match?(/\A2\d\d\z/) }
          ref = responses.dig(success_code, "content", "application/json", "schema", "$ref") if success_code
          expected = "#/components/schemas/#{contract['response']}"
          errors << "#{op_id}: resolved response ref #{ref.inspect} != #{expected}" unless ref == expected
          if path.start_with?("/v1/webhooks/")
            errors << "#{op_id}: webhook signature must bind raw request body" unless operation["x-signature-input"] == "raw_request_body"
          end
        end
      end
      serialized = openapi.to_s
      errors << "resolved OpenAPI still references generic JsonObject" if serialized.include?("#/components/schemas/JsonObject") || serialized.include?("#/components/requestBodies/JsonObject")
      GENERIC_RESPONSES.each { |name| errors << "resolved OpenAPI still references generic response #{name}" if serialized.include?("#/components/responses/#{name}") }
      idempotency = openapi.dig("components", "parameters", "IdempotencyKey", "schema")
      errors << "resolved Idempotency-Key policy must be 16..128" unless idempotency == {"type" => "string", "minLength" => 16, "maxLength" => 128}
      if type_system
        expected_codes = Array(type_system.dig("transport_policy", "public_failure_codes"))
        actual_codes = Array(openapi.dig("components", "schemas", "Problem", "properties", "code", "enum"))
        errors << "resolved Problem.code enum differs from public failure registry" unless actual_codes == expected_codes
      end
      errors
    end

    def deep_copy(value)
      Marshal.load(Marshal.dump(value))
    end
  end
end
