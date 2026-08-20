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
family = ENV["LENBANDS_IMPLEMENTATION_FAMILY"].to_s
base_sha = ENV["LENBANDS_IMPLEMENTATION_BASE_SHA"].to_s
scopes = ENV["LENBANDS_IMPLEMENTATION_SOURCE_SCOPES"].to_s
founder_ref = ENV["LENBANDS_FOUNDER_AUTHORIZATION_REF"].to_s
auth_ref = ENV["LENBANDS_IMPLEMENTATION_AUTHORIZATION_REF"].to_s
if [family, base_sha, scopes, founder_ref, auth_ref].all? { |value| !value.empty? }
  puts "Claude family-scoped authorization context detected for #{family}; PreToolUse guard must validate exact baseline and source scope before any source mutation."
else
  puts "Claude family-scoped authorization mode: no external implementation authorization is active; application source remains locked."
end
