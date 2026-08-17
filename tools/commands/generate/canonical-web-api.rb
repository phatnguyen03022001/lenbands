#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "date"

$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)
require "lenbands"
require "lenbands/yaml_loader"
require "lenbands/api_schema_compiler"

root = Lenbands::ROOT
check = ARGV.delete("--check")
output = nil
if (index = ARGV.index("--output"))
  output = ARGV[index + 1]
  ARGV.slice!(index, 2)
end
abort("usage: canonical-web-api.rb [--check] [--output path]") unless ARGV.empty?

openapi = Lenbands::YamlLoader.load_file(File.join(root, "artifacts/engineering/api/openapi.yaml"), mapping: true)
schema_contract = Lenbands::YamlLoader.load_file(File.join(root, "artifacts/engineering/api/schema-contract.yaml"), mapping: true)
type_system = Lenbands::YamlLoader.load_file(File.join(root, "artifacts/engineering/api/type-system.yaml"), mapping: true)
resolved, errors = Lenbands::ApiSchemaCompiler.resolve_openapi(openapi: openapi, schema_contract: schema_contract, type_system: type_system)
errors.concat(Lenbands::ApiSchemaCompiler.validate_resolved(openapi: resolved, schema_contract: schema_contract, type_system: type_system))
abort(errors.join("\n")) unless errors.empty?

if check
  puts "canonical web API resolution passed (operations=#{schema_contract.fetch("operation_contracts").length}, schemas=#{schema_contract.fetch("schemas").length}, generic_payloads=0)"
  exit 0
end

abort("--output is required outside --check mode") if output.to_s.empty?
expanded = File.expand_path(output, root)
scratch = File.join(root, "artifacts/operations/.tmp")
abort("resolved OpenAPI output must stay under artifacts/operations/.tmp") unless expanded.start_with?("#{scratch}/")
Dir.mkdir(scratch) unless Dir.exist?(scratch)
File.write(expanded, YAML.dump(resolved))
puts expanded
