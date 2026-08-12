#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

for spec in $(rg --files artifacts/engineering/contracts -g 'openapi.yaml'); do
  ruby -Itools/lib -rlenbands -rlenbands/yaml_loader -e '
    spec = ARGV.fetch(0)
    doc = Lenbands::YamlLoader.load_file(spec, mapping: true)
    abort("#{spec}: missing OpenAPI 3.x declaration") unless doc["openapi"].to_s.start_with?("3.")
    abort("#{spec}: missing global bearer security requirement") unless Array(doc["security"]).any? { |entry| entry.is_a?(Hash) && entry.key?("bearerAuth") }
    components = doc.fetch("components", {})
    bearer = components.dig("securitySchemes", "bearerAuth")
    abort("#{spec}: missing bearer security scheme") unless bearer
    abort("#{spec}: bearer scheme must be HTTP bearer") unless bearer["type"] == "http" && bearer["scheme"] == "bearer"
    schemas = components.fetch("schemas", {})
    schemas.each do |name, schema|
      next unless schema.is_a?(Hash)
      if schema["type"] == "object" && schema["required"]
        properties = schema.fetch("properties", {})
        Array(schema["required"]).each do |required|
          abort("#{spec}: schema #{name} requires undeclared property #{required}") unless properties.key?(required)
        end
      end
      if schema["enum"]
        abort("#{spec}: schema #{name} has empty enum") unless schema["enum"].is_a?(Array) && !schema["enum"].empty?
      end
    end
    refs = []
    walker = lambda do |value|
      case value
      when Hash
        refs << value["$ref"] if value["$ref"]
        value.each_value { |child| walker.call(child) }
      when Array
        value.each { |child| walker.call(child) }
      end
    end
    walker.call(doc)
    refs.each do |ref|
      next unless ref.start_with?("#/")
      node = doc
      ref.delete_prefix("#/").split("/").each { |part| node = node.fetch(part) }
    rescue KeyError
      abort("#{spec}: unresolved local $ref #{ref}")
    end
    doc.fetch("paths", {}).each do |path, operations|
      path_params = path.scan(/\{([^}]+)\}/).flatten
      operations.each do |method, operation|
        next unless %w[get post put patch delete].include?(method)
        params = Array(operation["parameters"]).map do |parameter|
          if parameter.is_a?(Hash) && parameter["$ref"]
            parameter["$ref"].split("/").last
          else
            parameter && parameter["name"]
          end
        end
        path_params.each do |parameter|
          abort("#{spec}: #{method.upcase} #{path} missing #{parameter} parameter") unless params.include?(parameter) || components.fetch("parameters", {}).key?(parameter.split(/(?=[A-Z])/).map(&:capitalize).join)
        end
        unless operation.fetch("responses", {}).keys.any? { |code| code.to_s.start_with?("2") }
          abort("#{spec}: #{method.upcase} #{path} missing success response")
        end
        if operation["requestBody"]
          json = operation.dig("requestBody", "content", "application/json", "schema")
          abort("#{spec}: #{method.upcase} #{path} request body missing JSON schema") unless json
        end
        operation.fetch("responses", {}).each do |code, response|
          next unless code.to_s.start_with?("2") && response.is_a?(Hash)
          next unless response.dig("content", "application/json")
          abort("#{spec}: #{method.upcase} #{path} response #{code} missing JSON schema") unless response.dig("content", "application/json", "schema")
        end
        next if method == "get"
        idempotent = params.include?("IdempotencyKey") || operation["x-idempotency-exempt"] == true
        abort("#{spec}: #{method.upcase} #{path} missing Idempotency-Key") unless idempotent
      end
    end
    required_paths = [
      "/v1/writing/submissions/{submissionId}/evaluation",
      "/v1/writing/submissions/{submissionId}/feedback",
      "/v1/me/quota",
      "/v1/writing/errors",
      "/v1/writing/errors/{errorId}/fixes",
      "/v1/writing/errors/{errorId}/retest",
      "/v1/review/cards"
    ]
    required_paths.each { |path| abort("#{spec}: missing P0 path #{path}") unless doc.fetch("paths", {}).key?(path) }
    quality = schemas.fetch("WritingEvaluation").fetch("properties").fetch("quality_status").fetch("enum")
    expected_quality = %w[accepted low_confidence insufficient_evidence invalid]
    abort("#{spec}: quality_status enum diverges from blueprint convention") unless quality == expected_quality
    task_type = schemas.fetch("WritingTask").fetch("properties").fetch("task_type").fetch("enum")
    expected_task_type = %w[W_task2_opinion W_task2_discussion W_task2_advantages_disadvantages W_task2_problem_solution W_task2_two_part]
    abort("#{spec}: task_type enum diverges from framework SSOT") unless task_type == expected_task_type
    evaluation_state = schemas.fetch("WritingEvaluation").fetch("properties").fetch("evaluation_state").fetch("enum")
    expected_evaluation_state = %w[submitted processing scored low_confidence invalid anti_gaming_review failed]
    abort("#{spec}: evaluation_state enum diverges from blueprint convention") unless evaluation_state == expected_evaluation_state
  ' "$spec"
done

echo "openapi validation passed"
