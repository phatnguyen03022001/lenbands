# frozen_string_literal: true

require "yaml"

module Lenbands::EventSchemaPrivacyContract
  module_function

  def validate(text, forbidden_fields: nil, root: Lenbands::ROOT)
    forbidden = forbidden_fields || registry_forbidden_fields(root)
    errors = []
    text.each_line do |line|
      match = line.match(/^- `([a-z][a-z0-9_]*)`/)
      next unless match

      event = match[1]
      fields = line.scan(/\{([^}]*)\}/).flatten.flat_map do |payload|
        payload.split(",").map do |field|
          field.strip.split(":", 2).first.to_s.gsub(/[^a-zA-Z0-9_-]/, "")
        end
      end.reject(&:empty?)
      fields.each do |field|
        normalized = field.downcase.tr("-", "_")
        next if opaque_reference?(normalized)
        if forbidden.any? { |blocked| forbidden_match?(normalized, blocked) }
          errors << "#{event}: forbidden raw/sensitive event payload field #{field}"
        end
      end
    end
    errors
  end

  def registry_forbidden_fields(root)
    path = File.join(root, "artifacts/operations/data-retention-registry.yaml")
    data = YAML.safe_load(File.read(path), aliases: false) || {}
    fields = Array(data["forbidden_general_telemetry_fields"]).map { |field| field.to_s.downcase.tr("-", "_") }.reject(&:empty?)
    raise "data retention telemetry deny set is empty" if fields.empty?
    fields
  rescue StandardError => e
    raise "event privacy deny registry unavailable: #{e.message}"
  end
  private_class_method :registry_forbidden_fields

  def opaque_reference?(field)
    field.end_with?("_ref", "_refs") && !field.start_with?("raw_")
  end
  private_class_method :opaque_reference?

  def forbidden_match?(field, blocked)
    return true if field == blocked
    # Raw-content and credential nouns remain forbidden when a developer adds a
    # content-bearing prefix/suffix such as raw_*, *_text, *_body or *_payload.
    return true if field.start_with?("raw_#{blocked}")
    return true if field.start_with?("#{blocked}_") && !field.end_with?("_ref", "_refs")
    field.end_with?("_#{blocked}")
  end
  private_class_method :forbidden_match?
end
