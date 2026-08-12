# frozen_string_literal: true

require "psych"

module Lenbands
  class YamlError < StandardError; end

  module YamlLoader
    module_function

    def load_file(path, mapping: false)
      raise YamlError, "YAML file missing: #{path}" unless File.file?(path)

      source = File.read(path)
      reject_duplicate_mapping_keys!(source, path)
      data = YAML.safe_load(source, permitted_classes: [Date, Time], aliases: false)
      if mapping && !data.is_a?(Hash)
        raise YamlError, "YAML root must be a mapping: #{path}"
      end
      data
    rescue Psych::Exception, SystemCallError => e
      raise YamlError, "invalid YAML #{path}: #{e.message}"
    end

    def reject_duplicate_mapping_keys!(source, path)
      visit = nil
      visit = lambda do |node|
        case node
        when Psych::Nodes::Mapping
          seen = {}
          node.children.each_slice(2) do |key_node, value_node|
            key = key_node.is_a?(Psych::Nodes::Scalar) ? key_node.value : "<complex-key>"
            raise YamlError, "duplicate YAML key #{key.inspect}: #{path}" if seen.key?(key)

            seen[key] = true
            visit.call(value_node)
          end
        when Psych::Nodes::Sequence
          node.children.each { |child| visit.call(child) }
        end
      end

      Psych.parse_stream(source).children.each do |document|
        visit.call(document.root) if document.root
      end
    end
  end
end
