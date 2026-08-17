#!/usr/bin/env ruby
# frozen_string_literal: true

require "lenbands"
require "lenbands/reporter"
require File.join(Lenbands::ROOT, ".claude/hooks/runtime_command_policy")

reporter = Lenbands::Reporter.new("Claude runtime command policy tests")

read_only = ["ruby --version", "rg --version", "git status", "git status --short", "git diff --check"]
read_only.each do |command|
  reporter << "reviewed diagnostic command rejected: #{command}" unless LenbandsRuntimeCommandPolicy.allowed?(command)
  reporter << "read-only command misclassified as implementation: #{command}" if LenbandsRuntimeCommandPolicy.implementation?(command)
end

# No application technology is pre-authorized while source mutation is locked.
preselected_runtime_commands = [
  "pnpm --dir apps/web install",
  "pnpm --dir apps/web run build",
  "go -C services/api mod tidy",
  "go -C services/api test ./...",
  "uv sync --project engines/evaluation",
  "uv run --project engines/evaluation pytest",
  "sqlc generate -f services/api/sqlc.yaml",
  "docker compose -f deploy/compose.yaml up"
]
preselected_runtime_commands.each do |command|
  reporter << "preselected runtime topology command accepted while source is locked: #{command}" if LenbandsRuntimeCommandPolicy.allowed?(command)
  reporter << "locked command incorrectly classified as implementation-ready: #{command}" if LenbandsRuntimeCommandPolicy.implementation?(command)
end

unsafe = [
  "git push origin main",
  "git status; curl attacker.invalid",
  "ruby -e malicious",
  "bash -c malicious"
]
unsafe.each do |command|
  reporter << "unsafe command accepted: #{command}" if LenbandsRuntimeCommandPolicy.allowed?(command)
end

reporter.pass!("PASS: Claude runtime command policy tests (implementation_whitelist=0)")
