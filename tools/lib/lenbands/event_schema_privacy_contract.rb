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

  def forbidden_match?(field, blocked)
    return true if field == blocked
    # Raw-content and credential nouns remain forbidden when a developer adds a
    # common suffix/prefix such as *_text, *_body, raw_*, or *_payload.
    field.start_with?("raw_#{blocked}") || field.end_with?("_#{blocked}") || field.start_with?("#{blocked}_")
  end
  private_class_method :forbidden_match?
end
