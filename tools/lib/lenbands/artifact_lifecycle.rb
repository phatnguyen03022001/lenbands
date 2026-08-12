# frozen_string_literal: true

module Lenbands::ArtifactLifecycle
  LIFECYCLE_STATUS = /\A\s*status\s*:\s*(?:draft|review|approved|deprecated|archived)(?:\s+#.*)?\z/
  SEMANTIC_VERSION = /\A\s*version\s*:\s*["']?\d+\.\d+\.\d+["']?(?:\s+#.*)?\z/
  LIFECYCLE_ONLY_KEY = /\A\s*(?:representation|derived_from|purpose|reviewed_by|reviewed_at)\s*:/

  module_function

  def embedded_metadata?(lines)
    in_yaml_fence = false
    Array(lines).first(30).any? do |line|
      stripped = line.strip
      if !in_yaml_fence && stripped.match?(/\A```ya?ml\z/i)
        in_yaml_fence = true
        false
      elsif in_yaml_fence && stripped.start_with?("```")
        in_yaml_fence = false
        false
      else
        in_yaml_fence && lifecycle_signature?(line)
      end
    end
  end

  def lifecycle_signature?(line)
    line.match?(LIFECYCLE_STATUS) || line.match?(SEMANTIC_VERSION) || line.match?(LIFECYCLE_ONLY_KEY)
  end
end
