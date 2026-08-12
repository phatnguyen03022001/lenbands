# frozen_string_literal: true

module Lenbands::EventSchemaPrivacyContract
  FORBIDDEN_PAYLOAD_FIELDS = %w[
    essay_text
    audio_data
    raw_answer
    error_text
    learner_content
  ].freeze

  module_function

  def validate(text)
    errors = []
    text.each_line do |line|
      match = line.match(/^- `([a-z][a-z0-9_]*)`/)
      next unless match

      fields = line.scan(/\{([^}]*)\}/).flatten.flat_map do |payload|
        payload.split(",").map { |field| field.strip.split(":", 2).first }
      end.compact
      (fields & FORBIDDEN_PAYLOAD_FIELDS).each do |field|
        errors << "#{match[1]}: forbidden raw learner-content payload field #{field}"
      end
    end
    errors
  end
end
