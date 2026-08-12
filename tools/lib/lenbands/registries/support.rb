# frozen_string_literal: true

module Lenbands::Registries
  class RegistryError < StandardError; end

  module Support
    module_function

    def load_mapping(path)
      raise RegistryError, "registry file missing: #{relative(path)}" unless File.file?(path)

      data = YAML.safe_load(File.read(path), permitted_classes: [Date], aliases: false)
      raise RegistryError, "registry root must be a mapping: #{relative(path)}" unless data.is_a?(Hash)

      deep_freeze(data)
    rescue Psych::Exception, SystemCallError => e
      raise RegistryError, "registry unreadable: #{relative(path)}: #{e.message}"
    end

    def required_array(mapping, key, path)
      value = mapping[key]
      raise RegistryError, "registry key #{key.inspect} must be an array: #{relative(path)}" unless value.is_a?(Array)

      value
    end

    def deep_freeze(value)
      case value
      when Hash
        value.each { |key, item| deep_freeze(key); deep_freeze(item) }
      when Array
        value.each { |item| deep_freeze(item) }
      when Set
        value.each { |item| deep_freeze(item) }
      end
      value.freeze
    end

    def relative(path)
      path.delete_prefix(Lenbands::ROOT + File::SEPARATOR)
    end
  end
end
