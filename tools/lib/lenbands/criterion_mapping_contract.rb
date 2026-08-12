# frozen_string_literal: true

module Lenbands::CriterionMappingContract
  EXPECTED_MAPPING = {
    "TR" => "task_response",
    "CC" => "coherence_cohesion",
    "LR" => "lexical_resource",
    "GRA" => "grammar"
  }.freeze

  module_function

  def validate(canonical_contract:, error_taxonomy:, openapi:)
    errors = []
    mapping = canonical_contract.scan(/^\| `([^`]+)` \| `([^`]+)` \|$/).to_h
    errors << "canonical Writing criterion mapping drift: #{mapping.inspect}" unless mapping == EXPECTED_MAPPING

    task2_criteria = error_taxonomy.each_line.each_with_object(Set.new) do |line, criteria|
      match = line.match(/^\| `(W_[a-z0-9_]+)` \|[^|]*\|[^|]*\| ([^|]+) \|/)
      next unless match
      next if match[1].start_with?("W_t1_", "W_letter_")

      criteria << match[2].strip
    end
    expected_short = EXPECTED_MAPPING.keys.to_set
    unless task2_criteria == expected_short
      errors << "Writing Task 2 taxonomy criterion set drift: #{task2_criteria.to_a.sort.inspect}"
    end

    criterion_enums = collect_criterion_enums(openapi)
    errors << "OpenAPI declares no criterion enums" if criterion_enums.empty?
    criterion_enums.each do |values|
      next if values.to_set == EXPECTED_MAPPING.values.to_set

      errors << "OpenAPI criterion enum drift: #{values.inspect}"
    end
    errors
  end

  def collect_criterion_enums(node, output = [])
    case node
    when Hash
      node.each do |key, value|
        output << Array(value["enum"]) if key == "criterion" && value.is_a?(Hash) && value.key?("enum")
        collect_criterion_enums(value, output)
      end
    when Array
      node.each { |value| collect_criterion_enums(value, output) }
    end
    output
  end
  private_class_method :collect_criterion_enums
end
