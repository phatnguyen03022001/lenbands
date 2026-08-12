#!/usr/bin/env ruby
# frozen_string_literal: true

require "tmpdir"
require_relative "hook_support"

marker = LenbandsClaudeHook.session_marker
exit 0 unless File.file?(marker)

commands = [
  ["tools/bin/lenbands", "verify"],
  ["tools/bin/lenbands", "gate", "toolchain"],
  ["tools/bin/lenbands", "gate", "p0"]
]
failures = []
commands.each do |command|
  stdout, stderr, status = LenbandsClaudeHook.run(*command)
  expected = command.last == "p0" ? [0, 3] : [0]
  next if expected.include?(status.exitstatus)
  failures << "$ #{command.join(' ')}\n#{stdout}#{stderr}"
end

unless failures.empty?
  warn "LenBands handoff blocked; repair the repository before stopping:\n#{failures.join("\n")}"
  exit 2
end

File.delete(marker)
