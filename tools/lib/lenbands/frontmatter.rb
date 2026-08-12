# frozen_string_literal: true

module Lenbands::Frontmatter
  RE = /\A---\s*\n(.*?)\n---\s*(?:\n|\z)/m

  # Parse YAML frontmatter from a markdown file.
  # Returns [data_hash, nil] on success, or [nil, error_string] on failure.
  def self.parse(path)
    text = File.read(path)
    match = text.match(RE)
    return [{}, nil] unless match
    data = YAML.safe_load(match[1], permitted_classes: [Date], aliases: false) || {}
    [data, nil]
  rescue Psych::Exception => e
    [nil, e.message]
  rescue StandardError => e
    [nil, e.message]
  end

  # Parse and return just the version field, or nil.
  def self.version(path)
    data, _err = parse(path)
    data&.fetch("version", nil)
  rescue StandardError
    nil
  end
end
