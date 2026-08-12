#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "shellwords"
require_relative "hook_support"

LenbandsClaudeHook.input
root = LenbandsClaudeHook.root
scratch_root = File.join(root, "artifacts", "operations", ".tmp")
FileUtils.mkdir_p(scratch_root)
env_file = ENV["CLAUDE_ENV_FILE"].to_s
unless env_file.empty?
  File.open(env_file, "a") do |file|
    file.puts("export TMPDIR=#{Shellwords.escape(scratch_root)}")
    file.puts("export CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1")
  end
end

stdout, stderr, status = LenbandsClaudeHook.run("tools/bin/lenbands", "context")
unless status.success?
  warn "LenBands context bootstrap failed: #{stderr}#{stdout}"
  exit 2
end

puts stdout
puts "Claude document-convergence mode: all application source workspaces and runtime implementation commands are globally locked."
