#!/usr/bin/env ruby
# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, "..", "lib")
require "lenbands"
require "lenbands/yaml_loader"
require "lenbands/criterion_mapping_contract"
require "lenbands/reporter"

root = Lenbands::ROOT
canonical = File.read(File.join(root, "artifacts/engineering/contracts/evaluation/evaluation-contract.md"))
taxonomy = File.read(File.join(root, "blueprint/framework/error-taxonomy.md"))
openapi = Lenbands::YamlLoader.load_file(
  File.join(root, "artifacts/engineering/contracts/writing-task-2/openapi.yaml"),
  mapping: true
)
validate = ->(contract, errors, api) do
  Lenbands::CriterionMappingContract.validate(canonical_contract: contract, error_taxonomy: errors, openapi: api)
end
copy = ->(value) { Marshal.load(Marshal.dump(value)) }
reporter = Lenbands::Reporter.new("criterion mapping mutation tests")

reporter << "canonical criterion mapping rejected" unless validate.call(canonical, taxonomy, openapi).empty?

mutated_contract = canonical.sub("| `TR` | `task_response` |", "| `TR` | `task_achievement` |")
unless validate.call(mutated_contract, taxonomy, openapi).any? { |item| item.include?("canonical Writing criterion mapping drift") }
  reporter << "canonical criterion mapping drift was accepted"
end

# Mutate the controlled criterion cell structurally rather than matching the
# human-language description. Documentation wording may change while the table
# contract remains the same; this mutation test must continue testing the
# semantic criterion boundary rather than a Vietnamese/English literal.
mutated_taxonomy = taxonomy.sub(
  /^(\| `W_tr_position_unclear` \|[^|]*\|[^|]*\| )TR( \|.*)$/,
  '\\1TA\\2'
)
reporter << "Writing taxonomy mutation fixture did not match the controlled row" if mutated_taxonomy == taxonomy
unless validate.call(canonical, mutated_taxonomy, openapi).any? { |item| item.include?("taxonomy criterion set drift") }
  reporter << "Writing taxonomy criterion drift was accepted"
end

mutated_openapi = copy.call(openapi)
criterion_schema = nil
walk = lambda do |node|
  case node
  when Hash
    node.each do |key, value|
      criterion_schema ||= value if key == "criterion" && value.is_a?(Hash) && value.key?("enum")
      walk.call(value)
    end
  when Array
    node.each { |value| walk.call(value) }
  end
end
walk.call(mutated_openapi)
criterion_schema["enum"] = %w[task_response coherence_cohesion lexical_resource grammar task_achievement]
unless validate.call(canonical, taxonomy, mutated_openapi).any? { |item| item.include?("OpenAPI criterion enum drift") }
  reporter << "OpenAPI criterion enum drift was accepted"
end

reporter.pass!("PASS: criterion mapping mutation tests")
