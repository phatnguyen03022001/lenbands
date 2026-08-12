#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require_relative "hook_support"

input = LenbandsClaudeHook.input
source = input["source"].to_s
protected_sources = %w[project_settings local_settings skills]
exit 0 unless protected_sources.include?(source)

puts JSON.generate(
  "decision" => "block",
  "reason" => "LenBands #{source} changes require a privileged reviewed change and may not be activated inside a bounded session."
)
